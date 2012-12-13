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
		hist = [hist; compute_curlvl_hist(feats, cuts, level, dim)];
	end
end



% given the current set of features and cuts, compute the current histogram
% each level i has 2^i -1 cuts along each dimension, 
% and a feature can be positive or negative with respect to each cut
function [cur_hist] = compute_curlvl_hist(feats, cuts, level, dim)
	num_regions = 2 ^ (3 * (2 ^ level - 1));
	
	% initialize the current histogram to be all zeros
	cur_hist = zeros(num_regions * dim.num_feat_types, 1);
	
	% index in the histogram will be region_num * | feature_types | + feat_type
	for i = 1:length(feats.x)
		f = [feats.x(i), feats.y(i), feats.z(i)];
		
		region_num = bin(f, cuts, dim);
		assert(region_num >= 0 && region_num < num_regions);
	
		idx = region_num * dim.num_feat_types + feats.label(i);

		% finally, increment the appropriate position
		cur_hist(idx) = cur_hist(idx) + 1;
	end
end
