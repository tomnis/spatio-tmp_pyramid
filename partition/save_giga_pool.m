setup
load loaded_data

object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

perm = [1,3,2];

gigapool = generate_giga_pool(dataset, perm);

save('/u/tomas/thesis/matfiles/gigapool', 'gigapool')
