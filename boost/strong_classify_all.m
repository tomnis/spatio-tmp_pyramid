% classify all the data points
% pass in all partitioned features
function [labels] = strong_classify_all(classifier, partitioned_feats, valid_labels)
	labels = [];
	num_test = 0;

	% figure out how many test examples there are
	% some of partitioned_feats may be empty
	for i = 1:length(partitioned_feats)
		num_test = size(partitioned_feats{i}, 2);
		if num_test
			break
		end
	end
	
	assert(num_test > 0)
	%keyboard

	for i = 1:num_test
		labels(i) = strong_classify(classifier, partitioned_feats, i, valid_labels);
	end
end

% strongly classify the ith data point
% = argmax_c (sum_{m=1}^j alpha(m) * f_m(I) == c)
% j = length(alpha)
% feats
function [label] = strong_classify(classifier, partitioned_feats, i, valid_labels)
	cur_max_label = 0;
	cur_max_score = intmin;


	for j=1:length(valid_labels)
		cur_score = 0;
		cur_test_label = valid_labels(j);
		
		% compute the score for the current label
		for m=1:length(classifier.alpha)
			x_test = partitioned_feats{classifier.min_pat_inds(m)}(:,i);
			y_test = cur_test_label;
			
			cur_label = svmpredict(y_test', x_test', classifier.min_class_classifiers(m));
			cur_score = cur_score + classifier.alpha(m) * (cur_label == cur_test_label);
		end
		if cur_score > cur_max_score
			cur_max_label = cur_label;
			cur_max_score = cur_score;
		end
	end
	label = cur_max_label;
	assert(label > 0);
end
