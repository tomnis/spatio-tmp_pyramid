% data contains labels
% output is strong classifier
% should_boost determines whether we should simple return 
function [f] = boost(dataset, partitions, target_accuracy, dim, should_boost)
  assert(should_boost == 0 || should_boost == 1);

  spatial_cuts = dim.spatial_cuts;
  
  labels = unique(dataset.label);
  n_label = length(labels);
  
  % for each partition pattern
  for prt_num = 1:length(partitions)
  	partition = partitions{prt_num};
  
  	% do we need to reset data to its prior state?
  	% represent each clip in the subset using partition pattern
  	% must be in the loop because the histogram will be different depending on the partition pattern
		hists = dataset.compute_histograms(partition, dim);
  	partitioned_feats{prt_num} = hists;
  
  	% randomly sample a subset of the clips
		num_sample_clips = randi(dataset.num_clips);
  	sampleinds = sort(randsample(dataset.num_clips, num_sample_clips));
  
  	% train an svm classifier on the subset
  	x_train = hists(:, sampleinds);
  	y_train = dataset.label(sampleinds);
  
    %%% repeat samples to be balanced
    f3 = [];
    for j = 1:n_label
      f1 = find(y_train == j);
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
  	
  	classifiers(prt_num) = svmtrain(y_train1', x_train1', '-c 1 -t 0');
  end
  
  % initialize the weight vector w
  weights = zeros(length(dataset.label), 1);
  % c is the number of classes
  c = length(unique(dataset.label));
  
  % each w_i = 1 / (c * number of clips with label c_i)
  % inversely proportional to class size, to prevent unbalanced sample sizes
  for i=1:dataset.num_clips
  	weights(i) = 1 / (c * length(find(dataset.label == dataset.label(i))));
  end
  
  
  % just compute accuracy using the initial weights
  if ~should_boost
  
  
  	return
  end
  
  
  
  
  j = 0;
  accuracy = 0;
  accuracies = [];
  while accuracy < target_accuracy && j < 5
  	
  	% for each clip, update the weight
  	weights = weights ./ sum(weights);
  	j = j+1;
  
  	% for each pattern, compute classification error
  	% should be dot(weights, I) where I is indicator of incorrect prediction
  	y_test = dataset.label';
  	
  	% compute the pattern which gives min err
  	min_err = length(weights);
  	min_pat_ind = 1;
  	for pattern_ind = 1:length(partitions)
  		x_test = partitioned_feats{pattern_ind}';
  		
  		y_pred = svmpredict(y_test, x_test, classifiers(pattern_ind));
  		indicator = y_pred' ~= dataset.label;
  		
  		cur_err = dot(weights, indicator);
  		
  		% if we find a new minimum, store the error, pattern, and indicator
  		if cur_err <= min_err
  			min_err = cur_err;
  			min_pat_ind = pattern_ind;
  			min_indicator = indicator;
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
  	strong_classifications = strong_classify_all(f, partitioned_feats, dataset.valid_labels);
  	
		% compute its classification accuracy (percentage of correct classifications)
  	f.accuracies(j) = mean(strong_classifications == dataset.label);
  end
end
