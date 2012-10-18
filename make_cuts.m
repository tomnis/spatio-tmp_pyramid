% dim.protate specifies probability of 'rotating' a cut
% dim => struct containing start_frame, end_frame, xlen, ylen, dim.protate
function [cuts] = make_cuts(level, cuts, dim)

	for j= 1:2^(level-1)
		% generate randomly rotated cuts
		if (rand(1) < dim.protate)
			newxcut = [0 cut(1, dim.xlen) cut(1, dim.xlen)];
			newycut = [cut(1, dim.ylen) 0 cut(1, dim.ylen)];
			newzcut = [cut(dim.start_frame, dim.end_frame) cut(dim.start_frame, dim.end_frame) 0];

		% generate axis-aligned cuts
		else
			xc = cut(1, dim.xlen);
			yc = cut(1, dim.ylen);
			zc = cut(dim.start_frame, dim.end_frame);
			newxcut = [0 xc xc]; 
			newycut = [yc 0 yc]; 
			newzcut = [zc zc 0]; 
		end

		[p1,p2,p3] = get_points(newxcut, dim.xlen, dim.ylen, dim.start_frame, dim.end_frame);
		cuts.xcuts = [cuts.xcuts; get_plane_eq(p1, p2, p3)];

		[p1,p2,p3] = get_points(newycut, dim.xlen, dim.ylen, dim.start_frame, dim.end_frame);
		cuts.ycuts = [cuts.ycuts; get_plane_eq(p1, p2, p3)];

		[p1,p2,p3] = get_points(newzcut, dim.xlen, dim.ylen, dim.start_frame, dim.end_frame);
		cuts.zcuts = [cuts.zcuts; get_plane_eq(p1, p2, p3)];
	end
end


% simple wrapper around rand int
function [c] = cut(minval, maxval)
	c = randi([minval maxval]);
	assert(c > 0)
end
