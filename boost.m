% data contains labels
% output is strong classifier
function [f] = boost(data, partitions, target_accuracy)

for pattern = partitions
	% randomly sample a subset of the clips

	% represent each clip in the subset using pattern

	% train an svm classifier on the subset
end

% weight vector w
w = zeros(length(data.label), 1);
c = length(unique(data.label));
% each w_i = 1 / c * number of clips with label c_i
for i=1:length(data.label)
	w(i) = 1 / (c * length(find(data.label == data.label{i})))
end

j = 0;
accuracy = 0;

while accuracy < target_accuracy
	% for each clip, update the weight
	w ./ sum(w);
	j = j+1;

	% for each pattern, compute classification error
	for pattern = partitions
		%err(pattern) = 	
	end
end
