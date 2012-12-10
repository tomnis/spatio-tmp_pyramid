% given a partition, plot all the planes
function [eqs_to_plot] = visualize_partition(partition, spatial_cuts)
	partition


	% apply the partition to a dummy space
	cut_eqs = apply_partition(partition, 1280, 960, 1, 1000, spatial_cuts);

	% we want an array of plane functions to plot
	eqs_to_plot = [];

	cut_eqs

	for lvl = 1:length(cut_eqs)
		level_eqs = cut_eqs(lvl)
		
		for c = 1:size(level_eqs.xcuts,1)
			xcut = level_eqs.xcuts(c,:);
			ycut = level_eqs.ycuts(c,:);
			zcut = level_eqs.zcuts(c,:);

			%eqs_to_plot = [eqs_to_plot; get_plane(xcut)];
			%eqs_to_plot = [eqs_to_plot; get_plane(ycut)];
			eqs_to_plot = [eqs_to_plot; get_plane(zcut)];
		end
	end
end


% cut is a vector representing ax + by + cz = d
% symbolically solve this for z
function [plane] = get_plane(cut)
	syms x y z;
	p = [x, y, z];
	pfunc = cut(1) * x + cut(2) * y + cut(3) * z - cut(4)
	plane = solve(pfunc, z);
end
