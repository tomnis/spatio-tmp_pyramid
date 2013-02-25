% call this to use the boosing classifier
% pools is cell array of pools
% traindata is a DataSet object
% testdata is a DataSet object
% kernel_type is 'poly', 'chisq', 'histintersect'

% return something containing the accuracies as well as the confusion matrices
function [d] = boost_main(pools, traindata, testdata, kernel_type, dim, omit_base)
	num_itrs = length(pools);

	if ~exist('omit_base')
		omit_base = 0;
	end

	target_accuracy = .8;

	accuracies = [];
	for itr=1:num_itrs
		disp (['boost_main trial ' num2str(itr) ' of ' num2str(num_itrs)])
		% create the partition pool
		pool = pools{itr};
	

		f = boost(traindata, pool, target_accuracy, dim, kernel_type, omit_base);

		% now that we have the classifier, test on the test data

		% get application of each partition scheme to be used by the classifier
		for pat_ind = 1:length(f.min_pat_inds)
			pool_num = f.min_pat_inds(pat_ind);
			partition = pool{pool_num};
			partitioned_feats{pool_num} = testdata.compute_histograms(partition, dim, omit_base); 
		end


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
