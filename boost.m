% data contains labels
% output is strong classifier
function [f] = boost(data, partitions, target_accuracy)

for pattern = partitions
	% randomly sample a subset of the clips

	% represent each clip in the subset using pattern

	% train an svm classifier on the subset
end

% weight vector w
weights = zeros(length(data.label), 1);
c = length(unique(data.label));
% each w_i = 1 / c * number of clips with label c_i
for i=1:length(data.label)
	weights(i) = 1 / (c * length(find(data.label == data.label{i})))
end

j = 0;
accuracy = 0;

while accuracy < target_accuracy
	% for each clip, update the weight
	weights ./ sum(weights);
	j = j+1;

	% for each pattern, compute classification error
	% should be dot(weights, I) where I is indicator of correct prediction
	for pattern = partitions
		%err(pattern) = 	
	end

	% select the pattern with minimum error
	[min_err min_pat] = min(err);

	% compute the weight for this pattern
	alpha_j = log((1 - min_err) / min_err) + log(c - 1)

	% recompute the weights
	for i=1:length(weights)
		weights(i) = weights(i) * exp(alpha_j * 
	end
	% generate the strong classifier

	% compute its classification accuracy
end

