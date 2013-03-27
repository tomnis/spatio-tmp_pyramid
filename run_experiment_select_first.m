% intended to replace all the highlevel* functions
% which are now deprecated and marked for deletion
function [accuracies, all_confns, all_fs] = run_experiment_select_first(allpools, bias_type, kernel_type, trials,split60)
	load loaded_data;

	object_type = 'active_passive';
	dataset = DataSet(data, frs, best_scores, locations, object_type);

	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

	if exist('split60') && split60 == 1
		load split60
	else
		load split
	end

	pools = allpools{bias_type};
	
	num_pools = length(pools);

	for i=1:length(trials)
		cur_trial = trials(i)
		disp (['trial ' num2str(i) ' of ' num2str(length(trials))])

		traindata = dataset.sub(split.train{cur_trial});
		testdata = dataset.sub(split.test{cur_trial});


		for j=1:num_pools
			disp (['trying pool ' num2str(j) ' of ' num2str(num_pools)])
			d = boost_main_select_first(pools(j), traindata, testdata, kernel_type, dim);
			trial_accuracies(:,j) = d.accuracies;
			confns{j} = d.confns;
			fs{j} = d.fs;
		end
		mean(trial_accuracies)
		
		accuracies(:,:,cur_trial) = trial_accuracies;
		all_confns{cur_trial} = confns;
		all_fs{cur_trial} = fs;
		clear trial_accuracies;
		clear confns;
		clear fs;
	end

	mean(mean(accuracies))
