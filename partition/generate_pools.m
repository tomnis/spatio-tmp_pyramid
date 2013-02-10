% generate a set of partition pools
%
% num_pools -> number of pools to generate
% pool_size -> number of partitions in each pool
% num_levels -> number of levels in the pyramid
% prorate -> probability of rotating cut planes
% bias_Type -> 0, 1,2. unbiased, cut around active objects, cut through active objects
function pools = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, regular, dataset)
	
	% TODO should i compute the distribution on the train, or all data?
	if bias_type > 1
		distr = dataset.compute_obj_distrs(10);
	else
		distr.bx = [];
		distr.by = [];
		distr.bz = [];
	end
	
	if bias_type == 2
		inverse = 1;
	else
		inverse = 0;
	end
	randrs.x = RandDistr(distr.bx, inverse);
	randrs.y = RandDistr(distr.by, inverse);
	randrs.z = RandDistr(distr.bz, inverse);

	for itr=1:num_pools
		pool1 = make_pool(1, 1, 0, 0, randrs);
		pool2 = make_pool(pool_size / 2, 2, protate, regular, randrs);
		pool3 = make_pool(pool_size / 2, 3, protate, regular, randrs);
		pools{itr} = [pool1, pool2, pool3];
	end
