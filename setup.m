w = whos

addpath /u/tomas/thesis  %% root directory
addpath /u/tomas/thesis/boost 
addpath /u/tomas/thesis/legacy 
addpath /u/tomas/thesis/partition
addpath /u/tomas/thesis/read_data
addpath /u/tomas/thesis/test
addpath /u/tomas/thesis/vis 
addpath /u/tomas/thesis/third_party/libsvm-mat-3.0-1


path0 = '/scratch/vision/luzheng/data/video_summarization/adl/';  %% root directory

%person_ids = [1:6];  %% persons used in action recognition
person_ids = [7:20];  %% persons used in action recognition
%person_ids = [7:7];  %% persons used in action recognition

path1 = [path0 'ADL_annotations/action_annotation/'];     %% action annottaion
path2 = [path0 'ADL_detected_objects/testset/active/'];   %% detected active objects
path3 = [path0 'ADL_detected_objects/testset/passive/'];  %% detected passive objects
