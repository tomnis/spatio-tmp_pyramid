function [labels] = strong_classify_all(classifier, partitioned_feats, valid_labels, num_test)
	labels = [];
  
  if ~exist('num_test')
    num_test = 0;

    % figure out how many test examples there are
    % some of partitioned_feats may be empty
    for i = 1:length(partitioned_feats)
      num_test = size(partitioned_feats{i}, 2);
      if num_test
        break
      end
    end
  end
	assert(num_test > 0)

	% precompute classifications using all classifiers
	% TODO this is recomputed every time, when all thats necessary is to 
	% give the last ones and recompute the new ones, but not a big deal,
	% pretty fast anyway
	for m=1:length(classifier.alpha)
		x_test = partitioned_feats{classifier.min_pat_inds(m)};
		y_test = ones(1, size(x_test,2));
		allpreds(:,m) = svmpredict(y_test', x_test', classifier.min_class_classifiers(m));
	end

	% now classify all the data points
	% = argmax_c (sum_{m=1}^j alpha(m) * f_m(I) == c)
	for i=1:num_test
		cur_max_score = intmin;
		cur_max_label = 0;

		for c=1:length(valid_labels)
			cur_test_label = valid_labels(c);

      allpreds(i, :) == cur_test_label;
      classifier.alpha;
			cur_score = dot(classifier.alpha, (allpreds(i,:) == cur_test_label));

			if cur_score > cur_max_score
				cur_max_label = cur_test_label;
				cur_max_score = cur_score;
			end
		end
		labels(i) = cur_max_label;
    % below commented out on 3/21 5pm. we are dealing with +/- 1 labels
    % now for the 1 vs all version
		% assert(labels(i) > 0);
	end
