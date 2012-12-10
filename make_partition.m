% partition is set of xcuts, ycuts, zcuts,
% level 0 is the entire unpartitioned clip, no need to explicitly represent
% level i has 2^i - 1 planar cuts
function [partition] = make_partition(num_levels, protate)
	% for i levels, we need a total of 2^i -1 cuts
	for level = 1:num_levels-1
		partition(level) = make_cut_fracs(level, protate);
	end
end


% generate the cuts (fractional representation) for this particular level
% level i has 2^i - 1 planar cuts total
% 2 ^ (i - 1) new cuts made at level i
function [cut_fracs] = make_cut_fracs(level, protate)
	cut_fracs = struct('xcut_fracs', [], 'ycut_fracs', [], 'zcut_fracs', []);

	% could vectorize, but we need the possibility to independently rotate each partition
	for i = 1:2^(level-1)
		% randomly rotated cut_fracs		
		if (rand < protate)
			newxcut = [0 rand rand];
			newycut = [rand 0 rand];
			newzcut = [rand rand 0];

		% axis aligned cut_fracs
		else
			cts = rand(1,3);
			newxcut = [0 cts(1) cts(1)];
			newycut = [cts(2) 0 cts(2)];
			newzcut = [cts(3) cts(3) 0];
		end

		cut_fracs.xcut_fracs = [cut_fracs.xcut_fracs; newxcut];
		cut_fracs.ycut_fracs = [cut_fracs.ycut_fracs; newycut];
		cut_fracs.zcut_fracs = [cut_fracs.zcut_fracs; newzcut];
	end
end
