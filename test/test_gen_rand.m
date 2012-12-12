setup
load tempfile;
compute_scores;
distr = compute_obj_distr(data);

genrandx = RandDistr(distr.bx);

num_itrs = 1000;
obs = zeros(num_itrs, 1);

for i=1:num_itrs
	obs(i) = genrandx.get();
end

bin_centers = [.05:.1:1];

[btest, test] = hist(obs, bin_centers);

bar(test, btest);
