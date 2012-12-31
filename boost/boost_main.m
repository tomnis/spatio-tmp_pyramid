function [stats] = boost_main(pool_size, num_itrs, train_inds, test_inds)
	setup
	load loaded_data

	num_levels = 3;
	protate = 0;
	target_accuracy = .8;
	object_type = 'active_passive';
	spatial_cuts = 1;
	regular = 0;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
	should_boost = 1;


  dataset = DataSet(data, frs, best_scores, locations, object_type);
	% get the train and test sets
	traindata = dataset.sub(train_inds);
	testdata = dataset.sub(test_inds);

	accuracies = [];
	for itr=1:num_itrs

		% create the partition pool
		pool = make_pool(pool_size, num_levels, protate, regular);


		f = boost(traindata, pool, target_accuracy, num_levels, dim, should_boost);

		% now that we have the classifier, test on the test data

		% get application of each partition scheme to be used by the classifier
		% todo this can be made more efficient
		% this is also compute in boost.m i believe
		% TODO only use the max here?
		for pat_ind = 1:length(f.min_pat_inds)
			pool_num = f.min_pat_inds(pat_ind);
			partition = pool{pool_num};
			partitioned_feats{pool_num} = testdata.compute_histograms(partition, dim); 
		end


		strong_classifications = strong_classify_all(f.alpha, f.min_class_classifiers, f.min_pat_inds, partitioned_feats, testdata.label);

		strong_class_indicator = (strong_classifications == testdata.label);
		accuracy = mean(strong_class_indicator)
		accuracies(itr) = accuracy;
	end
	
	stats.avg = mean(accuracies);
	stats.min = min(accuracies);
	stats.max = max(accuracies);
	stats.stddev = std(accuracies);
