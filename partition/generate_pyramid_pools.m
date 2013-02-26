function [pyramid_pools] = generate_pyramid_pools(num_pools, pool_size, num_levels, bias_type, regular,  dataset, perm)

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
		pyramid_pools{itr} = make_pyramid_pool(pool_size, num_levels, randrs, perm)
	end
end
