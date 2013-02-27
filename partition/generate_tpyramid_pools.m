function [tpyramid_pools] = generate_tpyramid_pools(num_pools, pool_size, bias_type, regular, dataset, protate, num_cuts)
	if bias_type > 1
		distr = dataset.compute_obj_distrs(10);
	else
		distr.bz = [];
	end
	
	if bias_type == 2
		inverse = 1;
	else
		inverse = 0;
	end

	if ~regular
		randr = RandDistr(distr.bz, inverse);
	else
		randr = [];
	end

	for itr=1:num_pools
		tpyramid_pools{itr} = make_tpyramid_pool(pool_size, randr, num_cuts, protate);
	end
end
