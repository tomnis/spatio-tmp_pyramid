load tempfile

pool_size = 10;
num_levels = 2;
protate = 0.0;
target_accuracy = .95;


pool = make_pool(pool_size, num_levels, protate);


f = boost(data, partitions, target_accuracy);
