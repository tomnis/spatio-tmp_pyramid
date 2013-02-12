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


for i=1:4
	obj_types = [i];


	% set of unbiased pools
	bias_type = 1;
	allpools{bias_type} = generate_pools_fine_grained_bias(num_pools, pool_size, num_levels, protate, bias_type, obj_types, regular, dataset);

	% set of pools to cut through AO region
	bias_type = 2;
	allpools{bias_type} = generate_pools_fine_grained_bias(num_pools, pool_size, num_levels, protate, bias_type, obj_types, regular, dataset);

	% set of pools to cut around AO region
	bias_type = 3;
	allpools{bias_type} = generate_pools_fine_grained_bias(num_pools, pool_size, num_levels, protate, bias_type, obj_types, regular, dataset);

	save(['allpoolslvls2-3size100objtype', num2str(i)], 'allpools')
end
