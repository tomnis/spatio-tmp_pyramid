setup
load loaded_data;

object_type = 'active_passive';

d = DataSet(data, frs, best_scores, locations, object_type);


distr = d.compute_obj_distr(10);

genrandx = RandDistr(distr.bx);

num_itrs = 1000;
obs = zeros(num_itrs, 1);

for i=1:num_itrs
	obs(i) = genrandx.get();
end

bin_centers = [.05:.1:1];

[btest, test] = hist(obs, bin_centers);

bar(test, btest);
