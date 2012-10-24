% dim => struct containing start_frame, end_frame, xlen, ylen, protate
function [hist] = compute_hist(feats, nlevels, dim)
	assert(nlevels > 0);
	hist = [];

	cuts = struct('xcuts', [], 'ycuts', [], 'zcuts', []); 

	% level 0 is the entire shot
	for level = 0:nlevels-1
		% add another set of cuts 
		cuts = make_cuts(level, cuts, dim);
		% compute the histogram for the current level
		hist = [hist; compute_cur_hist(feats, cuts, level, dim)];
	end
end
