setup

load loaded_data

% generate a set of pools. intented to replace the 
num_pools = 20
num_levels = 3;
pool_size = 50;
protate = 0;
regular = 0;


object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

% set of unbiased pools
bias_type = 1;
allpools{bias_type} = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, dataset);

% set of pools to cut through AO region
bias_type = 2;
allpools{bias_type} = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, dataset);

% set of pools to cut around AO region
bias_type = 3;
allpools{bias_type} = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, dataset);

save('allpools.mat', 'allpools')
