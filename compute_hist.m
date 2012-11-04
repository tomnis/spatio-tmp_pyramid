% given a set of features extracted from a clip and a partition scheme
% compute the feature histogram
% dim => struct containing start_frame, end_frame, xlen, ylen, protate
% cut_eqs => array of structs. 
function [hist] = compute_hist(feats, nlevels, cut_eqs, dim)
	assert(nlevels > 0);
	hist = [];
	
	cuts = struct('xcuts', [], 'ycuts', [], 'zcuts', []);

	% level 0 is the entire shot
	for level = 0:nlevels-1

		if level > 0
			prt_cuts = cut_eqs(level);
			
			cuts.xcuts = [cuts.xcuts; prt_cuts.xcuts];
			cuts.ycuts = [cuts.ycuts; prt_cuts.ycuts];
			cuts.zcuts = [cuts.zcuts; prt_cuts.zcuts];
		end

		% compute the histogram for the current level
		hist = [hist; compute_cur_hist(feats, cuts, level, dim)];
	end
end

%{
-partition(i) will contain the cuts for level i
-partition(0) not defined
%}
