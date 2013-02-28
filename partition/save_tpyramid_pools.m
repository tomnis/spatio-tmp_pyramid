setup
load loaded_data

num_pools = 1
pool_size = 50
protate = .5;
num_cuts = 5;
object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);
regular = 0;

%unbiased, around AO, through AO
for bias_type =1:3
	pyramids = generate_tpyramid_pools(num_pools, pool_size, bias_type, regular, dataset, protate, num_cuts);
	allpyramids{bias_type} = pyramids;
end

save(['alltpyramidscuts', num2str(num_cuts), 'size', num2str(pool_size), '.mat'], 'allpyramids');
