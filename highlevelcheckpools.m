function [accuracies] = highlevelcheckpools(bias_type, kernel_type, num_trials)
	setup
	load loaded_data

	object_type = 'active_passive';
	dataset = DataSet(data, frs, best_scores, locations, object_type);

	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

	load split
	load allpoolslvls2-3size100

	num_pools = 10;

	% TODO fix so that accuracies wont get overwritten
	for i=1:num_trials
		disp (['trial ' num2str(i) ' of ' num2str(num_trials)])

		traindata = dataset.sub(split.train{i});
		testdata = dataset.sub(split.test{i});


		for j=1:num_pools
			disp (['trying pool ' num2str(j) ' of ' num2str(num_pools)])
			trial_accuracies(:,j) = boost_main_checkpools(allpools{bias_type}(j), traindata, testdata, kernel_type, dim);
		end
		mean(trial_accuracies)
		
		accuracies(:,:,i) = trial_accuracies;
	end

	mean(mean(accuracies))
