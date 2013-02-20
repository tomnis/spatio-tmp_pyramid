function [accuracies] = highlevel_pyramid(bias_type, kernel_type, num_trials, perm)
	setup
	load loaded_data

	object_type = 'active_passive';
	dataset = DataSet(data, frs, best_scores, locations, object_type);

	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

	load split
	load allpyramids
	%load allpyramids4lvl

	pyramids = allpyramids{bias_type};
	num_pools = length(pyramids);

	for i=1:num_pools
		for j=1:length(pyramids{i})
			pyramids{i}{j} = pyramids{i}{j}.set_perm(perm);
		end
	end

	for i=1:num_trials
		disp (['trial ' num2str(i) ' of ' num2str(num_trials)])

		traindata = dataset.sub(split.train{i});
		testdata = dataset.sub(split.test{i});


		for j=1:num_pools
			disp (['trying pool ' num2str(j) ' of ' num2str(num_pools)])
			trial_accuracies(:,j) = boost_main(pyramids(j), traindata, testdata, kernel_type, dim);
		end
		mean(trial_accuracies)
		
		accuracies(:,:,i) = trial_accuracies;
	end

	mean(mean(accuracies))
