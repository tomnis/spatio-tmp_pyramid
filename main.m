clear

setup

object_type = 'active_passive'
%object_type = 'passive'
num_levels = 2
protate = 0.0
show_confn = 0;
% initially start_frame and end_frame set to dummy values
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);
spatial_cuts = 0


prepare_data
%data
%save('datafile', data)
accuracy = train_and_test(data, person_ids, show_confn);
