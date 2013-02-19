% if randrs is empty the generated pool will be regular
function [pyramid_pool] = make_pyramid_pool(num_pyramids, num_levels, randrs)
	assert(num_pyramids > 0)
	assert(num_levels > 0)

	for i=1:num_pyramids
		pyramid_pool{i} = Pyramid(num_levels, randrs);
	end
end
