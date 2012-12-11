% given a cut-representation of a plane, return three points that lie on the plane
function [p1, p2, p3] = get_points(cut, xlen, ylen, start_frame, end_frame)
	if(cut(1) == 0)
		p1 = [cut(2) 1 start_frame];
		p2 = [cut(2) ylen start_frame];
		p3 = [cut(3) 1 end_frame];
	elseif(cut(2) == 0)
		p1 = [1 cut(1) start_frame ];
		p2 = [xlen cut(1) start_frame ];
		p3 = [1 cut(3) end_frame ];
	elseif(cut(3) == 0)
		p1 = [1 1 cut(1) ];
		p2 = [1 ylen cut(1) ];
		p3 = [xlen 1 cut(2) ];
	end
end
