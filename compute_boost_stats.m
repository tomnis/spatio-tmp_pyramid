function [stats] = compute_boost_stats(pool_size, num_itrs)

setup
load tempfile

num_levels = 3;
protate = 0;
target_accuracy = .8;
object_type = 'active_passive';
spatial_cuts = 1;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

% assign the best scores to each clip
compute_scores

stats = struct('avg', [], 'stddev', [], 'min', [], 'max', []); 

max_accuracies = [];

for i=1:num_itrs
	pool = make_pool(pool_size, num_levels, protate);
	f = boost(data, pool, target_accuracy, num_levels, dim);
	max_accuracies = [max_accuracies max(f.accuracies)];
end

stats.avg = mean(max_accuracies);
stats.stddev = std(max_accuracies);
stats.min = min(max_accuracies);
stats.max = max(max_accuracies);
