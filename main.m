clear

setup
load loaded_data
%object_type = 'active_passive'
object_type = 'passive'
num_levels = 1
protate = 0.0
show_confn = 0;
% initially start_frame and end_frame set to dummy values
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);
dim.spatial_cuts = 1;

dataset = DataSet(data, frs, best_scores, locations, object_type);
pool = make_pool(1, num_levels, protate);
partition = pool{1};

histograms = dataset.compute_histograms(partition, dim);

accuracy = train_and_test(dataset, histograms, person_ids, show_confn);
