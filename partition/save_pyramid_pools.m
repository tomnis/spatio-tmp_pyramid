setup
load loaded_data

num_pools = 1
num_levels = 3
pool_size = 500
protate = 0;
regular = 0;

object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

perm = [1,3,2];

%unbiased, around AO, through AO
for bias_type =1:3
	pyramids = generate_pyramid_pools(num_pools, pool_size, num_levels, bias_type, regular, dataset, perm);
	allpyramids{bias_type} = pyramids;
end

pstr = num2str(perm);
pstr(ismember(pstr, ' ')) = [];

save(['allpyramidslvl', num2str(num_levels), 'size', num2str(pool_size), 'perm', pstr, '.mat'], 'allpyramids');
