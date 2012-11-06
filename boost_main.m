load tempfile

pool_size = 10;
num_levels = 2;
protate = 0.8;
target_accuracy = .5;
object_type = 'active_passive';

dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);

% assign the best scores to each clip
compute_scores

pool = make_pool(pool_size, num_levels, protate);


f = boost(data, pool, target_accuracy, num_levels, dim);
