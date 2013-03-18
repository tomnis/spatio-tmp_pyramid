setup
load loaded_data
object_type = 'active_passive';

num_levels = 3;
pool_size = 50;
protate = 0;
regular = 0;

d = DataSet(data, frs, best_scores, locations, object_type);

bias_type = 3;

if bias_type > 1
	distr = d.compute_obj_distrs(10);
else
	distr.bx = [];
	distr.by = [];
	distr.bz = [];
end

if bias_type == 2
	inverse = 1;
else
	inverse = 0;
end
randrs.x = RandDistr(distr.bx, inverse);
randrs.y = RandDistr(distr.by, inverse);
randrs.z = RandDistr(distr.bz, inverse);

% create the partition pool
pool = make_pool(pool_size, num_levels, protate, regular, randrs);

[accuracy confn] = leave_one_out(d, pool, person_ids);

save('/u/tomas/thesis/results/leave_one_out/leave_one_out', 'accuracy', 'confn')
