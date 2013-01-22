% run the ramanan version and my own version
% we need to run the boosting a number of iterations to account for
% any bad luck with selection of the partition.

function [stats] = compare_orig_and_boost(pool_size, num_itrs, train_frac)
	setup
	load loaded_data

	object_type = 'active_passive';
  d = DataSet(data, frs, best_scores, locations, object_type);

	n_label = length(unique(d.label));

	% create a split with the specified properties
	[train_inds test_inds] = d.get_split(train_frac);

	% compute accuracy using the ramanan method...
	% this is deterministic, so just run once
	rhists = d.compute_ramanan_histograms('pyramid');
	x_train = rhists(:, train_inds);
	y_train = d.label(:, train_inds);
  
	%%% repeat samples to be balanced
  f3 = [];
  for j = 1:n_label
    f1 = find(y_train == j);
    f1_n = length(f1);
    if f1_n == 0
      continue
    end
      
    f2 = repmat(f1, [1 ceil(100/f1_n)]);
    f3 = [f3 f2(1:100)];
  end
  
  %select the training examples to use
  x_train = x_train(:, f3);
  y_train = y_train(:, f3);
	svm = svmtrain(y_train', x_train', '-c 1 -t 0');

	x_test = rhists(:, test_inds);
	y_test = d.label(:, test_inds);
  y_pred = svmpredict(y_test', x_test', svm);

	ind = (y_pred' == y_test);
	acc = mean(ind)
	
	% compute accuracy using the boosting method. 
	boost_accs_unbias = boost_main(pool_size, num_itrs, train_inds, test_inds, 0);
	boost_accs_bias = boost_main(pool_size, num_itrs, train_inds, test_inds, 1);

	stats.orig_acc = acc;
	stats.unbias_accs = boost_accs_unbias;
	stats.bias_accs = boost_accs_bias;
	stats.avg_b = mean(boost_accs_bias);
	stats.min_b = min(boost_accs_bias);
	stats.max_b = max(boost_accs_bias);
	stats.stddev_b = std(boost_accs_bias);
	stats.avg_ub = mean(boost_accs_unbias);
	stats.min_ub = min(boost_accs_unbias);
	stats.max_ub = max(boost_accs_unbias);
	stats.stddev_ub = std(boost_accs_unbias);
end
