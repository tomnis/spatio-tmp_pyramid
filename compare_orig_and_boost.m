% run the ramanan version and my own version
% we need to run the boosting a number of iterations to account for
% any bad luck with selection of the partition.

function [stats] = compare_orig_and_boost(pool_size, num_itrs, train_frac)
	setup
	load loaded_data

	object_type = 'active_passive';
  d = DataSet(data, frs, best_scores, locations, object_type);

	% create a split with the specified properties
	[train_inds test_inds] = d.get_split(train_frac);

	size(train_inds)
	size(test_inds)

	% compute accuracy using the ramanan method...
	% this is deterministic, so just run once
	rhists = d.compute_ramanan_histograms('pyramid');
	x_train = rhists(:, train_inds);
	y_train = d.label(:, train_inds);
	svm = svmtrain(y_train', x_train', '-c 1 -t 0');

	x_test = rhists(:, test_inds);
	y_test = d.label(:, test_inds);
  y_pred = svmpredict(y_test', x_test', svm);

	ind = (y_pred' == y_test);
	acc = mean(ind)
	
	% compute accuracy using the boosting method. 
	stats = boost_main(pool_size, num_itrs, train_inds, test_inds);
	stats.orig_acc = acc;
end
