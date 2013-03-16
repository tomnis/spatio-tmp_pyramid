setup
load loaded_data

object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

train_frac = .6;
num_trials = 100;

for i=1:num_trials
	[train_inds test_inds] = dataset.get_split(train_frac);
	train{i} = train_inds;
	test{i} = test_inds;
end

split.train = train;
split.test = test;

save('split60.mat', 'split')
