setup
load loaded_data
object_type = 'active_passive';

num_levels = 3;
pool_size = 1;
protate = 0;
regular = 0;

d = DataSet(data, frs, best_scores, locations, object_type);

bias = 0;
% TODO should i compute the distribution on the train, or all data?
if bias
	distr = dataset.compute_obj_distrs(10);
else
	distr.bx = [];
	distr.by = [];
	distr.bz = [];
end

randrs.x = RandDistr(distr.bx);
randrs.y = RandDistr(distr.by);
randrs.z = RandDistr(distr.bz);

% create the partition pool
pool = make_pool(pool_size, num_levels, protate, regular, randrs);

accuracy = leave_one_out(d, pool, person_ids, 0);
