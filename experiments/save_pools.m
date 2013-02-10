setup

load loaded_data

% generate a set of pools. intented to replace the 
num_pools = 20
num_levels = 2;
pool_size = 100;
protate = 0;
regular = 0;


object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

% set of unbiased pools
bias_type = 1;
allpools{bias_type} = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, regular, dataset);

% set of pools to cut through AO region
bias_type = 2;
allpools{bias_type} = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, regular, dataset);

% set of pools to cut around AO region
bias_type = 3;
allpools{bias_type} = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, regular, dataset);

%{
for bias_type =1:3
	clear pools
	pools = generate_pools(1, 1, 1, 0, bias_type, 0, dataset)
	for num_levels = 2:3

	end
	allpools{bias_type} = pools;
end
%}

save('allpoolslvls2-3size100.mat', 'allpools')
