clear
setup
load loaded_data

object_type = 'active_passive';

d = DataSet(data, frs, best_scores, locations, object_type);


best_s_active = best_scores.active;
best_s_passive = best_scores.passive;
locations_active = locations.active;
locations_passive = locations.passive;

compute_scores

num_partitions = 1;
num_levels = 3;
protate = 0;
pool = make_pool(num_partitions, num_levels, protate);
partition = pool{1};
dim.xlen = 1280;
dim.ylen = 960;
spatial_cuts = 1;
dim.spatial_cuts = spatial_cuts;
compute_feats
d
data

hists = d.compute_histograms(partition, dim);

assert(isequal(d.person, data.person), 'person error');
assert(isequal(d.fr_start, data.fr_start), 'fr_start error');
assert(isequal(d.fr_end, data.fr_end), 'fr_end error');
assert(isequal(d.label, data.label), 'label error');
assert(isequal(d.frs, data.frs), 'frs error');
assert(isequal(d.best_s_active, data.best_s_active), 'best_s_active error');
assert(isequal(d.best_s_passive, data.best_s_passive), 'best_s_passive error');
assert(isequal(d.best_s, data.best_s), 'best_s error');
assert(isequal(d.locs, data.locs), 'locs error');


assert(isequal(hists, data.feat), 'histogram error');
