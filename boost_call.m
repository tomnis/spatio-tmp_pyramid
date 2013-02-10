setup
load loaded_data

train_inds = [1:203];
test_inds = [1:203];

bias_type = 1;

num_levels = 3;
protate = 0;
object_type = 'active_passive';
spatial_cuts = 1;
regular = 0;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
should_boost = 1;
dataset = DataSet(data, frs, best_scores, locations, object_type);
% get the train and test sets
traindata = dataset.sub(train_inds);
testdata = dataset.sub(test_inds);
	

kernel_type = 'poly';
pool_size = 1;
num_pools = 1;

pools = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, regular, dataset);

accuracies = boost_main(pools, traindata, testdata, kernel_type, dim);
mean(accuracies)
