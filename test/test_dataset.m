clear
setup
load tempfile
best_scores.active = best_s_active;
best_scores.passive = best_s_passive;
locations.active = locations_active;
locations.passive = locations_passive;

object_type = 'active_passive';

d = DataSet(data, frs, best_scores, locations, object_type);

compute_scores
d
data
