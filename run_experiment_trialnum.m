
% run_experiment is essentially a wrapper for this script.
% but we can use condor to process all trials in parallel
function [accuracies, confns] = run_experiment_trialnum(allpools, bias_type, kernel_type, trial_num)
	load loaded_data;

	object_type = 'active_passive';
	dataset = DataSet(data, frs, best_scores, locations, object_type);

	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

	load split
	pools = allpools{bias_type};
	num_pools = length(pools);

	traindata = dataset.sub(split.train{trial_num});
	testdata = dataset.sub(split.test{trial_num});

	for j=1:num_pools
		disp (['trying pool ' num2str(j) ' of ' num2str(num_pools)])
		d = boost_main(pools(j), traindata, testdata, kernel_type, dim);
		accuracies(:,j) = d.accuracies;
		confns{j} = d.confns;
	end
