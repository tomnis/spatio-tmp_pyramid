% pool{i}(j) => size 2^(j-1), the unique cuts made for level j of the ith partition scheme
%
% used in boosting
% the boosting algo requires that we are able to represent a 
% pool of partition schemas without computing corresponding histograms,
% so generate the pool.
% in general, we don't know the dimensions of the structure being partitions, 
% so represent the planar cuts as fractions, multiply later in the boosting 
% algo to find the actual cuts

% TODO add a way to specify only partitioning along the temporal dimension
% TODO Some overlap with make_cuts.m, should be refactored
% TODO should add a way to make regular cuts
% num_partitions -> number of partitions in the pool
% max_level -> return cuts for levels [0..max_level + 1]
% protate -> probability of independently rotating each planar cut
function [pool] = make_pool(num_partitions, max_level, protate)
	assert(protate >= 0.0 && protate <= 1.0);
	assert(num_partitions > 0);
	assert(max_level > 0);

	for i = 1:num_partitions
		pool{i} = make_partition(max_level, protate);
	end
end


% partition is set of xcuts, ycuts, zcuts,
% level i has 2^i - 1 planar cuts
function [partition] = make_partition(max_level, protate)
	% for i levels, we need a total of 2^i -1 cuts
	for level = 1:max_level
		partition(level) = make_cut_fracs(level, protate);
	end
end


% generate the cuts (fractional representation) for this particular level
% level i has 2^i - 1 planar cuts total
% 2 ^ (i - 1) new cuts made at level i
function [cut_fracs] = make_cut_fracs(level, protate)
	
	cut_fracs = struct('xcut_fracs', [], 'ycut_fracs', [], 'zcut_fracs', []);

	% could vectorize, but we need the possibility to independently rotate each partition
	for i = 1:2^(level-1)
		% randomly rotated cut_fracs		
		if (rand < protate)
			newxcut = [0 rand rand];
			newycut = [rand 0 rand];
			newzcut = [rand rand 0];

		% axis aligned cut_fracs
		else
			cts = rand(1,3);
			newxcut = [0 cts(1) cts(1)];
			newycut = [cts(2) 0 cts(2)];
			newzcut = [cts(3) cts(3) 0];
		end

		cut_fracs.xcut_fracs = [cut_fracs.xcut_fracs; newxcut];
		cut_fracs.ycut_fracs = [cut_fracs.ycut_fracs; newycut];
		cut_fracs.zcut_fracs = [cut_fracs.zcut_fracs; newzcut];
	end
end
