% call this to use the boosing classifier
% pools is cell array of pools
% traindata is a DataSet object
% testdata is a DataSet object
% kernel_type is 'poly', 'chisq', 'histintersect'
function [d] = boost_main_checkpools(pools, traindata, testdata, kernel_type, dim)
	num_itrs = length(pools);

	target_accuracy = .8;

	accuracies = [];
	for itr=1:num_itrs
		disp (['boost_main trial ' num2str(itr) ' of ' num2str(num_itrs)])
		% create the partition pool
		pool = pools{itr};
	

		f = boost(traindata, pool, target_accuracy, dim, kernel_type);

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

		fs{itr} = f;
		
		strong_classifications = strong_classify_all(f, partitioned_feats, testdata.valid_labels);

		assert(isequal(size(strong_classifications), size(testdata.label)));

		strong_class_indicator = (strong_classifications == testdata.label);
		boost_main_accuracy = mean(strong_class_indicator)
		accuracies(itr) = boost_main_accuracy;

		confn = confusionmat(testdata.label, strong_classifications);
		confns{itr} = confn;

		clear partitioned_feats;
	end
	
	d.accuracies = accuracies;
	d.confns = confns;
	d.fs = fs;
