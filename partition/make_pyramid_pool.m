% if randrs is empty the generated pool will be regular
function [pyramid_pool] = make_pyramid_pool(num_pyramids, num_levels, randrs, perm, addT)
	assert(num_pyramids > 0)
	assert(num_levels > 0)

	if ~exist('perm')
		perm = [];
	end

	pyramid_pool = {};

	% add the temporal only cuts
	if exist('addT') && addT
		pyramid_pool{1} = Tpyramid([], 1, 0);
		pyramid_pool{2} = Tpyramid([], 3, 0);
		for i=1:50
			pyramid_pool{length(pyramid_pool) + 1} = Tpyramid(randrs.z, 5, .5);
		end
	end
	
	for i=1:num_pyramids
		pyramid_pool{length(pyramid_pool) + 1} = Pyramid(num_levels, randrs, perm);
	end
end
