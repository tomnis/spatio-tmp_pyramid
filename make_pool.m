% pool{i}(j) => size 2^(j-1), the unique cuts made for level j of the ith partition scheme
%
% used in boosting and prepare_data
% the boosting algo requires that we are able to represent a 
% pool of partition schemas without computing corresponding histograms,
% so generate the pool.
% in general, we don't know the dimensions of the structure being partitions, 
% so represent the planar cuts as fractions, multiply later in the boosting 
% algo to find the actual cuts

% TODO should add a way to make regular cuts
% num_partitions -> number of partitions in the pool
% num_levels -> return partitions for levels [0..num_levels-1]
% protate -> probability of independently rotating each planar cut
function [pool] = make_pool(num_partitions, num_levels, protate)
	assert(protate >= 0.0 && protate <= 1.0);
	assert(num_partitions > 0);
	assert(num_levels > 0);

	for i = 1:num_partitions
		pool{i} = make_partition(num_levels, protate);
	end
end
