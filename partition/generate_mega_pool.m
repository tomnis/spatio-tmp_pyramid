
function [mega_pool] = generate_mega_pool(dataset, perm)
	% 50 of each bias type and levels would be total size 300
	mega_pool = {};

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
	

		% now we have the correct distributions, loop over the number of levels
		for num_levels = 2:4
			current_pool = make_pyramid_pool(50, num_levels, randrs, perm);
			mega_pool = cat(2, mega_pool, current_pool);
		end
		clear randrs;
	end

