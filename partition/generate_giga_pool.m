function [giga_pool] = generate_giga_pool(dataset, perm)
	% 50 of each bias type and levels would be total size 300
	giga_pool = {};

	bias_sizes = [500, 250, 1000];

	for bias_type = 1:3
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
	
		% add the temporal only pyramids
		addT = 1;

		% now we have the correct distributions, loop over the number of levels
		for num_levels = 3:4
			pool_size = bias_sizes(bias_type);
			current_pool = make_pyramid_pool(pool_size, num_levels, randrs, perm, addT);
			giga_pool = cat(2, giga_pool, current_pool);
		end
		clear randrs;
	end

