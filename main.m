addpath /u/tomas/adl/ADL_code/third_party/libsvm-mat-3.0-1
addpath /u/tomas/adl/ADL_code  %% root directory

path0 = '/scratch/vision/luzheng/data/video_summarization/adl/';  %% root directory

%person_ids = [1:6];  %% persons used in action recognition
%person_ids = [7:20];  %% persons used in action recognition
person_ids = [7:7];  %% persons used in action recognition

path1 = [path0 'ADL_annotations/action_annotation/'];     %% action annottaion
path2 = [path0 'ADL_detected_objects/testset/active/'];   %% detected active objects
path3 = [path0 'ADL_detected_objects/testset/passive/'];  %% detected passive objects
path4 = [path0 'ADL_annotations/object_annotation/'];
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 640, 'ylen', 480, 'protate', .5);

dim.labels = struct('basket', 1,'bed', 2,'blanket', 3,'book', 4,'bottle', 5,'cell', 6,'cell_phone', 7,'cloth', 8,'comb', 9,'container', 10,'dent_floss', 11,'detergent', 12,'dish', 13,'door', 14,'elec_keys', 15,'electric_keys', 16,'food_snack', 17,'fridge', 18,'kettle', 19, 'keyboard', 20,'knife_spoon_fork', 21,'laptop', 22,'large_container', 23,'microwave', 24,'milk_juice', 25,'monitor', 26,'mop', 27,'mug_cup', 28,'oven_stove', 29,'pan', 30,'perfume', 31,'person', 32,'pills', 33,'pitcher', 34,'shoe', 35,'shoes', 36,'soap_liquid', 37,'tap', 38,'tea_bag', 39,'thermostat', 40,'tooth_brush', 41,'tooth_paste', 42,'towel', 43,'trash_can', 44,'tv', 45,'tv_remote', 46,'vacuum', 47,'washer_dryer', 48);


% bin label is actually a hist label


dim.num_feat_types = length(fieldnames(dim.labels));

feats = read_feats(path4, person_ids);

h = compute_hist(feats, 3, dim);
%[data best_s_active best_s_passive frs objects_active objects_passive] = read_data(person_ids, path1, path2, path3);
