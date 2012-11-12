load tempfile

pool_size = 20;
num_levels = 3;
protate = 0;
target_accuracy = .5;
object_type = 'active_passive';
spatial_cuts = 0;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

% assign the best scores to each clip
compute_scores

pool = make_pool(pool_size, num_levels, protate);


f = boost(data, pool, target_accuracy, num_levels, dim);
