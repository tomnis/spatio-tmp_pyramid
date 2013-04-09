setup
load loaded_data

bias_type = 0;

num_levels = 3;
protate = 0;
object_type = 'active_passive';
spatial_cuts = 1;
regular = 0;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
should_boost = 1;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
dataset = DataSet(data, frs, best_scores, locations, object_type);


num_pools = 10;
pool_size = 300;

pools = generate_pools(num_pools, pool_size, num_levels, protate, bias_type, regular, dataset);

load split;

traindata = dataset.sub(split.train{1});
testdata = dataset.sub(split.test{1});

pool_size_for_train= 1;

pool_sizes = [1, 10:10:pool_size];

for i=1:length(pool_sizes)
	pool_size_for_train = pool_sizes(i)

	clear train_pools;
	% get the first pool_size_for_train pools
	for p = 1:num_pools
		train_pools{p} = pools{p}(1:pool_size_for_train);
	end

	accuracies(:, i) = boost_main(train_pools, traindata, testdata, 'poly', dim);
end
