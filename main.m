clear
w = whos

addpath /u/tomas/thesis  %% root directory
addpath /u/tomas/thesis/third_party/libsvm-mat-3.0-1


path0 = '/scratch/vision/luzheng/data/video_summarization/adl/';  %% root directory

%person_ids = [1:6];  %% persons used in action recognition
person_ids = [7:20];  %% persons used in action recognition
%person_ids = [7:7];  %% persons used in action recognition

path1 = [path0 'ADL_annotations/action_annotation/'];     %% action annottaion
path2 = [path0 'ADL_detected_objects/testset/active/'];   %% detected active objects
path3 = [path0 'ADL_detected_objects/testset/passive/'];  %% detected passive objects

%[data best_s_active best_s_passive locations_active locations_passive frs objects_active objects_passive] = read_data(person_ids, path1, path2, path3);

% we have the loaded object data saved in this file
%save tempfile
load tempfile


object_type = 'active_passive'
%object_type = 'passive'
nlevels = 4
protate = 0.8
% initially start_frame and end_frame set to dummy values
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);



 %%% assigning best scores to each pre-segmented data point (clip)
for k = 1:length(data.label)
  i = data.person(k);
	% TODO figure out exactly what this is doing
  f1 = find((frs{i} > data.fr_start(k)) .* (frs{i} < data.fr_end(k)));
  %f1
  %size(f1)
	% the frames of person i that are in this clip
  data.frs{k} = frs{i}(f1);
				 
  data.best_s_active{k} = best_s_active{i}(:, f1);
  data.best_s_active{k} = data.best_s_active{k} + 0.7;
  data.best_s_active{k}(data.best_s_active{k} < 0) = 0;
  
	data.best_s_passive{k} = best_s_passive{i}(:, f1);
  data.best_s_passive{k} = data.best_s_passive{k} + 0.35;
  data.best_s_passive{k}(data.best_s_passive{k} < 0) = 0;
  
	if isequal(object_type, 'active_passive')
    data.best_s{k} = [data.best_s_active{k}; data.best_s_passive{k}];  %% active + passive objects
		data.locs{k} = [locations_active{i}(:, f1, :); locations_passive{i}(:, f1, :)];
  elseif isequal(object_type, 'passive')
    data.best_s{k} = [data.best_s_passive{k}];  %% passive objects only
		data.locs{k} = [locations_passive{i}(:, f1, :)];
  end
  %pause
end
%keyboard
% sanity check, should have locations for each score
assert(isequal(size(data.locs), size(data.best_s)));

dim.num_feat_types = size(data.best_s{1},1);

%%% now make the partition scheme
partition = make_pool(1, nlevels, dim.protate);
partition = partition{1};





% compute feature histograms for each clip
for k=1:length(data.label)
	clear feats
  i = data.person(k);
	
	% set the start and end frames of the current clip, used in compute_hist
	num_frames = length(data.frs{k});
	dim.start_frame = data.frs{k}(1);
	dim.end_frame = data.frs{k}(num_frames);

	feats = struct('person', [], 'x', [], 'y', [], 'z', [], 'label',[]);
	feats_ind = 0;

	for r = 1:size(data.best_s{k}, 1)
		for c = 1:size(data.best_s{k}, 2)
			if data.best_s{k}(r,c) > 0
				feats_ind = feats_ind + 1;
				
				% reshape the location from 1x1x4 to 1x4
				loc = reshape(data.locs{k}(r,c,:), 1,4);
				
				feats.person(feats_ind) = i;
				% compute the centroid of the bounding box
				feats.x(feats_ind) = loc(1) + mean([loc(1) loc(3)]);
				feats.y(feats_ind) = loc(2) + mean([loc(2) loc(4)]);
				% the frame is the column in the best score matrix
				feats.z(feats_ind) = c;
				% the object label is the row in the best score matrix
				feats.label(feats_ind) = r;
			end
		end
	end

	data.feat(:,k) = compute_hist(feats, nlevels, dim, partition);
end

data.feat = bsxfun(@rdivide, data.feat, sum(data.feat, 1) + eps); %% normalizing

thr = 0.01;
data.feat(data.feat > thr) = thr;   %% clipping features

%save('datafile', data)
train_and_test
