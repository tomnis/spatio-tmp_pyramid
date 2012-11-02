% given a set of features extracted from a clip and a partition scheme
% compute the feature histogram
% dim => struct containing start_frame, end_frame, xlen, ylen, protate
function [hist] = compute_hist(feats, nlevels, dim, partition)
	assert(nlevels > 0);
	hist = [];
	
	% apply the partition to the features
	cut_eqs = apply_partition(partition, dim.xlen, dim.ylen, dim.start_frame, dim.end_frame);

	cuts = struct('xcuts', [], 'ycuts', [], 'zcuts', []);


	% level 0 is the entire shot
	for level = 0:nlevels-1

		if level > 0
			partition_cuts = partition(level);
			cuts.xcuts = [cuts.xcuts; partition_cuts.xcut_fracs];
			cuts.ycuts = [cuts.ycuts; partition_cuts.ycut_fracs];
			cuts.zcuts = [cuts.zcuts; partition_cuts.zcut_fracs];
		end

		% compute the histogram for the current level
		hist = [hist; compute_cur_hist(feats, cuts, level, dim)];
	end
end

%{
-partition(i) will contain the cuts for level i
-partition(0) not defined
%}
