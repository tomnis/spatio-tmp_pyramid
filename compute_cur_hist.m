% given the current set of features and cuts,
% compute the current histogram
% level i will have 2^i x 2^i x 2^i regions
function [cur_hist] = compute_cur_hist(feats, cuts, level, dim)
	% initialize the current histogram to be all zeros
	cur_hist = zeros(1, (2^level)^3 * dim.num_feat_types);
	% index in the histogram will be region_num * | feature_types | + feat_type
	for i = 1:length(feats.x)
		f = [feats.x(i), feats.y(i), feats.z(i)];
		region_num = bin(f, cuts);
		% matlab doesnt allow '/' in struct field names, so substitute
		% TODO this is pretty hacky, should be refactored at some point
		label_str = strtrim(regexprep(feats.label(i), '/', '_'));
		label_num = dim.labels.(label_str{1});
		idx = region_num * dim.num_feat_types + label_num;
		cur_hist(idx) = cur_hist(idx) + 1;
	end
end
