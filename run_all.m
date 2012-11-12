function [stats] = run_all(protate, num_itrs, spatial_cuts)
setup

show_confn = 0;
% initially start_frame and end_frame set to dummy values
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);

% set empirically, found that 4 levels overflows memory but
% if using a more space efficient representation could experiment with this more
max_num_levels = 3;
accuracy = [];

for itr = 1:num_itrs
	% compute the accuracy for this iteration, for each feature type
	% and each type of level
	itr_accuracy = [];
	for object_type = {'passive', 'active_passive'}
		object_type = object_type{1}
		for num_levels = 1:max_num_levels;
			num_levels
			prepare_data
			itr_accuracy = [itr_accuracy train_and_test(data, person_ids, show_confn)];
		end
	end
	accuracy(itr,:) = itr_accuracy;
end

stats = struct('avg', [], 'stddev', [], 'min', [], 'max', []);

for i=1:size(accuracy,2)
	stats.avg(i) = mean(accuracy(:,i));
	stats.stddev(i) = std(accuracy(:,i));
	stats.min(i) = min(accuracy(:,i));
	stats.max(i) = max(accuracy(:,i));
end
end
