% generate a set of pools. intented to replace the 
num_pools = 1000
num_levels = 3;
pool_size = 50;
protate = 0;
regular = 0;

% compute the random number generators we need
ubrandrs.x = RandDistr([]);
ubrandrs.y = RandDistr([]);
ubrandrs.z = RandDistr([]);


% set of unbiased pools

% set of pools to cut through AO region

% set of pools to cut around AO region

for i=1:num_pools
	unbiased_pools{i} = make_pool(pool_size, num_levels, protate, regular, ubrandrs);

end
