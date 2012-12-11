% given: 
%
% a partition scheme (fractional representation of cuts)
% parameters representing the dimensions of the clip in question
% spatial_cuts -> boolean indicating whether we should apply spatial cuts
% 	in addition to temporal cuts
%
% return:
% equations of the form [a b c d] representing the cut planes
function [cut_eqs] = apply_partition(partition, xlen, ylen, start_frame, end_frame, spatial_cuts)
	
	zlen = end_frame - start_frame + 1;

	% for each level in the partition scheme
	for lvl = length(partition)
		cut_eqs(lvl) = struct('xcuts', [], 'ycuts', [], 'zcuts', []);
		
		level = partition(lvl);

		% for each cut in the current level
		for i = 1:length(level)
			% apply the spatial cuts if specified
			if spatial_cuts
				% multiplying the fractional cut vectors by the x and y length
				% will yield, respectively, the correct cut boundaries in the clip are partitioning
				xcut = level.xcut_fracs(i,:)	* xlen;
				ycut = level.ycut_fracs(i,:)	* ylen;

				% get three points that lie on the plane
				[p1 p2 p3] = get_points(xcut, xlen, ylen, start_frame, end_frame);
				% use them to compute a plane equation
				newxcut = get_plane_eq(p1, p2, p3);			
			
				[p1 p2 p3] = get_points(ycut, xlen, ylen, start_frame, end_frame);
				newycut = get_plane_eq(p1, p2, p3);			
			else
				newxcut = [];
				newycut = [];

			end

			cut_eqs(lvl).xcuts = [cut_eqs(lvl).xcuts; newxcut]; 
			cut_eqs(lvl).ycuts = [cut_eqs(lvl).ycuts; newycut]; 

			% now apply the temporal cut
			% multiply temporal fractional cuts by number of frames in clip
			zcut = [start_frame start_frame 0] + level.zcut_fracs(i,:) * zlen;
			[p1 p2 p3] = get_points(zcut, xlen, ylen, start_frame, end_frame);
			cut_eqs(lvl).zcuts = [cut_eqs(lvl).zcuts; get_plane_eq(p1, p2, p3)];			
		end
	end
end
