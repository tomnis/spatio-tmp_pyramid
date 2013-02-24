% see what happens if we omit the base level of the pyramid
function [accuracies, all_confns, nb_accuracies, all_nb_confns] = test_no_base(allpools, bias_type, kernel_type, num_trials)
	load loaded_data;

	object_type = 'active_passive';
	dataset = DataSet(data, frs, best_scores, locations, object_type);

	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

	load split

	pools = allpools{bias_type};
	
	num_pools = length(pools);

	for i=1:num_trials
		disp (['trial ' num2str(i) ' of ' num2str(num_trials)])

		traindata = dataset.sub(split.train{i});
		testdata = dataset.sub(split.test{i});


		for j=1:num_pools
			disp (['trying pool ' num2str(j) ' of ' num2str(num_pools)])
			d = boost_main(pools(j), traindata, testdata, kernel_type, dim);
			trial_accuracies(:,j) = d.accuracies;
			confns{j} = d.confns;


			e = boost_main_nobase(pools(j), traindata, testdata, kernel_type, dim);
			nb_trial_accuracies(:, j) = e.accuracies;
			nb_confns{j} = e.confns;
		end
		mean(trial_accuracies)
		
		accuracies(:,:,i) = trial_accuracies;
		all_confns{i} = confns;
		clear trial_accuracies;
		clear confns;


		nb_accuracies(:, :, i) = nb_trial_accuracies;
		all_nb_confns{i} = nb_confns;
		clear nb_trial_accuracies;
		clear nb_confns;
	end

	mean(mean(accuracies))
