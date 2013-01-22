function [accuracies] = boost_main(pool_size, num_itrs, train_inds, test_inds, bias)
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

	% TODO should i compute the distribution on the train, or all data?
	if bias
		distr = dataset.compute_obj_distrs(10);
	else
		distr.bx = [];
		distr.by = [];
		distr.bz = [];
	end


	distr
	randrs.x = RandDistr(distr.bx);
	randrs.y = RandDistr(distr.by);
	randrs.z = RandDistr(distr.bz);

	accuracies = [];
	for itr=1:num_itrs

		% create the partition pool
		pool = make_pool(pool_size, num_levels, protate, regular, randrs);


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


		strong_classifications = strong_classify_all(f, partitioned_feats, testdata.valid_labels);

		size(strong_classifications)
		size(testdata.label)
		size(partitioned_feats)

		assert(isequal(size(strong_classifications), size(testdata.label)));

		strong_class_indicator = (strong_classifications == testdata.label);
		accuracy = mean(strong_class_indicator)
		accuracies(itr) = accuracy;
		clear partitioned_feats;
	end
