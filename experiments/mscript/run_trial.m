setup;
load loaded_data;

object_type = 'active_passive';
dataset = DataSet(data, frs, best_scores, locations, object_type);

protate = 0;
spatial_cuts = 1;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

pools = allpools{bias_type};

[accuracies confns] = run_experiment_trialnum(allpools, bias_type, 'poly', trial_num)
