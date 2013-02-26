setup
load loaded_data

object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

perm = [1,3,2];

megapool = generate_mega_pool(dataset, perm);

save('megapoolequal', 'megapool')
