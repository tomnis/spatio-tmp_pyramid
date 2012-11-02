% used in boosting
% the boosting algo requires that we are able to represent a 
% pool of partition schemas without computing corresponding histograms,
% so generate the pool.
% in general, we don't know the dimensions of the structure being partitions, 
% so represent the planar cuts as fractions, multiply later in the boosting 
% algo to find the actual cuts

% TODO add a way to specify only partitioning along the temporal dimension
% TODO Some overlap with make_cuts.m, should be refactored
function [pool] = make_pool(num_partitions, num_levels, protate)
	assert(protate >= 0.0 && protate <= 1.0)

	for i = 1:num_partitions
		pool(i) = make_partition(num_levels, protate);
	end
	
end

% partition is set of xcuts, ycuts, zcuts,
% level i has 2^i - 1 planar cuts
function [partition] = make_partition(num_levels, protate)
	% for i levels, we need a total of 2^i -1 cuts
	% could vectorize, but we need the possibility to independently rotate each partition
	for level = 1:num_levels
		partition(level) = make_cuts(level, protate);
	end
end


% generate the cuts for this particular level
% level i has 2^i - 1 planar cuts total
% 2 ^ (i - 1) new cuts made at level i
function [cuts] = make_cuts(level, protate)
	
	cuts = struct('xcuts', [], 'ycuts', [], 'zcuts', []);

	for i = 1:2^(level-1)
		% randomly rotated cuts		
		if (rand < protate)
			newxcut = [0 rand rand];
			newycut = [rand 0 rand];
			newzcut = [rand rand 0];

		% axis aligned cuts
		else
			cts = rand(1,3);
			newxcut = [0 cts(1) cts(1)];
			newycut = [cts(2) 0 cts(2)];
			newzcut = [cts(3) cts(3) 0];
		end

		cuts.xcuts = [cuts.xcuts; newxcut];
		cuts.ycuts = [cuts.ycuts; newycut];
		cuts.zcuts = [cuts.zcuts; newzcut];
	end
end
