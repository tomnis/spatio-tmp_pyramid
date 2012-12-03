% data contains labels
% output is strong classifier
function [f] = boost(data, partitions, target_accuracy, num_levels, dim)
data

spatial_cuts = dim.spatial_cuts;

% store the original data before we do any computation
% TODO find out if this is necessary.
% seems like it could be the case that the original values are being overwritten or something?
data_prime = data;

labels = unique(data.label);
n_label = length(labels);

% for each partition pattern
for prt_num = 1:length(partitions)
	partition = partitions{prt_num};

	% do we need to reset data to its prior state?
	data = data_prime;
	% represent each clip in the subset using partition pattern
	% must be in the loop because the histogram will be different depending on the partition pattern
	compute_feats

	partitioned_feats{prt_num} = data.feat;

	data
	num_clips = length(data.label);

	% randomly sample a subset of the clips
	sampleinds = sort(randsample(num_clips, randi(num_clips)));

	% train an svm classifier on the subset
	x_train = data.feat(:, sampleinds);
	y_train = data.label(sampleinds);

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
weights = zeros(length(data.label), 1);
% c is the number of classes
c = length(unique(data.label));

% each w_i = 1 / (c * number of clips with label c_i)
% inversely proportional to class size, to prevent unbalanced sample sizes
for i=1:length(data.label)
	weights(i) = 1 / (c * length(find(data.label == data.label(i))));
end

j = 0;
accuracy = 0;
accuracies = [];
while accuracy < target_accuracy && j < 10
	
	% for each clip, update the weight
	weights = weights ./ sum(weights);
	j = j+1;

	% for each pattern, compute classification error
	% should be dot(weights, I) where I is indicator of incorrect prediction
	x_test = data.feat';
	y_test = data.label';
	
	% compute the pattern which gives min err
	min_err = length(weights);
	min_pat_ind = 1;
	for pattern_ind = 1:length(partitions)
		x_test = partitioned_feats{pattern_ind}';
		
		y_pred = svmpredict(y_test, x_test, classifiers(pattern_ind));
		indicator = y_pred' ~= data.label;
		
		cur_err = dot(weights, indicator);
		
		% if we find a new minimum, store the error, pattern, and indicator
		if cur_err <= min_err
			min_err = cur_err;
			min_pat_ind = pattern_ind;
			min_indicator = indicator;
		end
	end

	% compute the weight for the pattern with min error
	alpha(j) = log((1 - min_err) / min_err) + log(c - 1);
	% remember which svm gave the min error in the jth iteration
	min_class_classifiers(j) = classifiers(min_pat_ind);
	min_pat_inds(j) = min_pat_ind;

	assert(length(weights) == length(min_indicator));

	% recompute the weights
	% note that indicator needs to be in the correct state
	for i=1:length(weights)
		weights(i) = weights(i) * exp(alpha(j) * min_indicator(i));
	end

	% generate the strong classifier
	strong_classifications = strong_classify_all(alpha, min_class_classifiers, min_pat_inds, partitioned_feats, data.label);
	
	% compute its classification accuracy (percentage of correct classifications)
	strong_class_indicator = (strong_classifications == data.label);
	accuracy = mean(strong_class_indicator);
	accuracies(j) = accuracy;
	end

	f.alpha = alpha;
	f.min_class_classifiers = min_class_classifiers;
	f.accuracies = accuracies;
	f.min_pat_inds = min_pat_inds;
end
