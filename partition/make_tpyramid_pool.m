% if randr is empty the generated pool will be regular
function [tpyramid_pool] = make_tpyramid_pool(pool_size, randr, num_cuts, protate)
	assert(pool_size > 0)
	assert(protate >= 0 && protate <= 1)

	for i=1:pool_size
		tpyramid_pool{i} = Tpyramid(randr, num_cuts, protate);
	end

	for i=1:4
		tpyramid_pool{length(tpyramid_pool) + 1} = Tpyramid([], i, 0);
	end
end
