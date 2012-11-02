% given: 
%
% a partition scheme (fractional representation of cuts)
% parameters representing the dimensions of the clip in question
%
% return:
% equations of the form [a b c d] representing the cut planes
function [cut_eqs] = apply_partition(partition, xlen, ylen, start_frame, end_frame)
	
	zlen = end_frame - start_frame + 1;

	% for each level in the partition scheme
	for lvl = length(partition)
		cut_eqs(lvl) = struct('xcuts', [], 'ycuts', [], 'zcuts', []);

		
		level = partition(lvl);

		% for each cut in the current level
		for i = 1:length(level)
			% multiplying the fractional cut vectors by the x and y length
			% will yield, respectively, the correct cut boundaries in the clip are partitioning
			xcut = level.xcut_fracs(i,:)	* xlen;
			ycut = level.ycut_fracs(i,:)	* ylen;
			% we must multiply the fractional cuts along the temporal dimension by the total number of frames
			zcut = [start_frame start_frame 0] + level.zcut_fracs(i,:) * zlen;

			% get three points that lie on the plane
			[p1 p2 p3] = get_points(xcut, xlen, ylen, start_frame, end_frame);
			% use them to compute a plane equation
			cut_eqs(lvl).xcuts = [cut_eqs(lvl).xcuts; get_plane_eq(p1, p2, p3)];			

			[p1 p2 p3] = get_points(ycut, xlen, ylen, start_frame, end_frame);
			cut_eqs(lvl).ycuts = [cut_eqs(lvl).ycuts; get_plane_eq(p1, p2, p3)];			
			[p1 p2 p3] = get_points(zcut, xlen, ylen, start_frame, end_frame);
			cut_eqs(lvl).zcuts = [cut_eqs(lvl).zcuts; get_plane_eq(p1, p2, p3)];			
		end
	end
end
