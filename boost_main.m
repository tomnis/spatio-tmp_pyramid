function [stats] = boost_main(pool_size, num_itrs, train_inds, test_inds)
	setup
	load tempfile

	num_levels = 3;
	protate = 0;
	target_accuracy = .8;
	object_type = 'active_passive';
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
	should_boost = 1;

	% assign the best scores to each clip
	compute_scores

	% store the original data struct, not sure if necessary
	dataorig = data;

	accuracies = [];
	for itr=1:num_itrs
		data = dataorig;

		% create the partition pool
		pool = make_pool(pool_size, num_levels, protate);

		traindata = applysplit(data, train_inds);

		f = boost(traindata, pool, target_accuracy, num_levels, dim, should_boost);

		% now that we have the classifier, test on the test data
		testdata = applysplit(data, test_inds);
		testdataorig = testdata;

		% get application of each partition scheme that will be used by the classifier
		% todo this can be made more efficient
		for pat_ind = 1:length(f.min_pat_inds)
			pool_num = f.min_pat_inds(pat_ind);
			partition = pool{pool_num};
			data = testdata;
			compute_feats 
			partitioned_feats{pool_num} = data.feat;
		end


		strong_classifications = strong_classify_all(f.alpha, f.min_class_classifiers, f.min_pat_inds, partitioned_feats, data.label);

		strong_class_indicator = (strong_classifications == data.label);
		accuracy = mean(strong_class_indicator)
		accuracies(itr) = accuracy;
	end
	
	stats.avg = mean(accuracies);
	stats.min = min(accuracies);
	stats.max = max(accuracies);
	stats.stddev = std(accuracies);
