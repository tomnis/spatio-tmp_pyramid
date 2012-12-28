% classify all the data points
% pass in the new labels that have been map1'ed
% pass in all partitioned features
function [labels] = strong_classify_all(alpha, min_class_classifiers, min_pat_inds, partitioned_feats, new_labels)
	labels = [];
	for i = 1:length(new_labels)
		labels(i) = strong_classify(alpha, min_class_classifiers, min_pat_inds, partitioned_feats, i, new_labels(i));
	end
end

% label is the correct label of the ith data point
% (already map1'ed)
% strongly classify the ith data point
% = argmax_c (sum_{m=1}^j alpha(m) * f_m(I) == c)
% j = length(alpha)
% feats
function [label] = strong_classify(alpha, min_class_classifiers, min_pat_inds, partitioned_feats, i ,new_label)
	cur_max_label = 0;
	cur_max_score = 0;
	
	num_labels = length(unique(new_label));

	for j=1:num_labels
		cur_score = 0;
		for m=1:length(alpha)
			x_test = partitioned_feats{min_pat_inds(m)}(:,i);
			y_test = new_label;
			
			cur_label = svmpredict(y_test', x_test', min_class_classifiers(m));
			cur_score = cur_score + alpha(m) * (cur_label == new_label);
		end
		if cur_score > cur_max_score
			cur_max_label = cur_label;
			cur_max_score = cur_score;
		end
	end
	label = cur_max_label;
end
