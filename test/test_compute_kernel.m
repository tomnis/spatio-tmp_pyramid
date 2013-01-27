load loaded_data
protate = 0;
spatial_cuts = 1;
regular = 0;
object_type = 'active_passive';
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
dataset = DataSet(data, frs, best_scores, locations, object_type);


randrs.x = RandDistr([]);
randrs.y = RandDistr([]);
randrs.z = RandDistr([]);

pool = make_pool(1, 2, protate, regular, randrs);

hists = dataset.compute_histograms(pool{1}, dim);

k = compute_kernel(hists, dataset.label, 'chisq');
