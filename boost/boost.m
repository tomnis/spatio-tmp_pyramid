% data contains labels
% output is strong classifier
function [f] = boost(dataset, pool, target_accuracy, dim, kernel_type, omit_base)
  spatial_cuts = dim.spatial_cuts;

	if ~exist('omit_base')
		omit_base = 0;
	end

  labels = unique(dataset.label);
  n_label = length(labels);

  % for each partition pattern
  for prt_num = 1:length(pool)
		fprintf(1, '\rpattern %d of %d...', prt_num, length(pool));
  	partition = pool{prt_num};
 
  	% represent each clip in the subset using partition pattern
  	% must be in the loop because the histogram will be different depending on the partition pattern
		fprintf(1, ' computing histograms...');
		hists = dataset.compute_histograms(partition, dim, omit_base);
  	partitioned_feats{prt_num} = hists;
  
  	% randomly sample a subset of the clips
		%num_sample_clips = randi(dataset.num_clips);
  	%sampleinds = sort(randsample(dataset.num_clips, num_sample_clips));
  	% changed 2/6 4pm:
		% remove the randomness from training on random subsets
		sampleinds = 1:dataset.num_clips;

  	% train an svm classifier on the subset
  	x_train = hists(:, sampleinds);
  	y_train = dataset.label(sampleinds);
  
    %%% repeat samples to be balanced
    f3 = [];
    for j = 1:n_label
      l = labels(j);
      f1 = find(y_train == l);
      f1_n = length(f1);
      if f1_n == 0
        continue
      end
      
      f2 = repmat(f1, [1 ceil(100/f1_n)]);
      f3 = [f3 f2(1:100)];
    end
  
  	% select the training examples to use
    x_train1 = x_train(:, f3);
    y_train1 = y_train(:, f3);

		if isequal(kernel_type, 'poly')
 			fprintf(1, ' training... (polynomial kernel,  ex:%d) ', length(y_train1));
 		  svm = svmtrain(y_train1', x_train1', '-c 1 -t 0 -q');
		else 
			fprintf(1, ' precomputing %s kernel...', kernel_type);
			K = compute_kernel(x_train1', x_train1', kernel_type);
 			fprintf(1, ' training... (ex:%d)', length(y_train1));
			trains{prt_num} = x_train1;
			svm = svmtrain(y_train1', K, '-q -t 4');
		end
		fprintf(1, ' done.');
		classifiers(prt_num) = svm;
  end
  
  % initialize the weight vector w
  weights = zeros(dataset.num_clips, 1);
  % c is the number of classes
  c = length(unique(dataset.label));
  
  % each w_i = 1 / (c * number of clips with label c_i)
  % inversely proportional to class size, to prevent a problem from unbalanced sample sizes
  for i=1:dataset.num_clips
  	weights(i) = 1 / (c * length(find(dataset.label == dataset.label(i))));
  end
  
  
  j = 0;
  accuracy = 0;
  accuracies = [];
  while accuracy < target_accuracy && j < 30
  	
  	% for each clip, update the weight
  	weights = weights ./ sum(weights);
  	j = j+1;
  
  	% for each pattern, compute classification error
  	% should be dot(weights, I) where I is indicator of incorrect prediction
  	y_test = dataset.label';
  	
  	% compute the pattern which gives min err
  	min_err = length(weights);
  	min_pat_ind = 1;
  	for pattern_ind = 1:length(pool)
  		x_test = partitioned_feats{pattern_ind}';
  	
			% first boosting round we compute the and cache the indicators
			if j == 1
				if isequal(kernel_type, 'poly')
					y_pred = svmpredict(y_test, x_test, classifiers(pattern_ind));
				else
					xtest = compute_kernel(x_test, trains{pattern_ind}', kernel_type);
					y_pred = svmpredict(y_test, xtest, classifiers(pattern_ind));
				end
				
				indicator = y_pred' ~= dataset.label;
				cur_err = dot(weights, indicator);
				
				% cache the indicator to be used in later iterations
				indicators{pattern_ind} = indicator;	
			else
				cur_err = dot(weights, indicators{pattern_ind});
			end

  		% if we find a new minimum, store the error, pattern, and indicator
  		if cur_err <= min_err
  			min_err = cur_err;
  			min_pat_ind = pattern_ind;
  			min_indicator = indicators{pattern_ind};
  		end
  	end
  
  	% compute the weight for the pattern with min error
  	f.alpha(j) = log((1 - min_err) / min_err) + log(c - 1);
  	% remember which svm gave the min error in the jth iteration
  	f.min_class_classifiers(j) = classifiers(min_pat_ind);
  	f.min_pat_inds(j) = min_pat_ind;
  
  	assert(length(weights) == length(min_indicator));
  
  	% recompute the weights
  	% note that indicator needs to be in the correct state
  	for i=1:length(weights)
  		weights(i) = weights(i) * exp(f.alpha(j) * min_indicator(i));
  	end
  
  	% generate the strong classifier
  	%strong_classifications = strong_classify_all(f, partitioned_feats, dataset.valid_labels);
		% compute its classification accuracy (percentage of correct classifications)
  	%accuracy = mean(strong_classifications == dataset.label);	
  	%f.accuracies(j) = accuracy;
  end
	%f.accuracies
end
