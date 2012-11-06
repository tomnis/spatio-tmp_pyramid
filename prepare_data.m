clear data
%[data best_s_active best_s_passive locations_active locations_passive frs objects_active objects_passive] = read_data(person_ids, path1, path2, path3);
% we have the loaded object data saved in this file
%save tempfile data best_s_active best_s_passive locations_active locations_passive frs objects_active objects_passive
	
load tempfile
object_type

%%% assigning best scores to each pre-segmented data point (clip)
compute_scores

%%% now make the partition scheme
% make_pool takes as param the maximum level
if num_levels > 1
	partition = make_pool(1, num_levels, dim.protate);
	partition = partition{1}
end

% !!!!!
% partitions at this point are different across runs

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

	% apply the partition to the features
	if num_levels == 1
		cut_eqs = struct('xcuts', [], 'ycuts', [], 'zcuts', []);
	else
		cut_eqs = apply_partition(partition, dim.xlen, dim.ylen, dim.start_frame, dim.end_frame);
	end
		
	data.feat(:,k) = compute_hist(feats, num_levels, cut_eqs, dim);
end

data.feat = bsxfun(@rdivide, data.feat, sum(data.feat, 1) + eps); %% normalizing

thr = 0.01;
data.feat(data.feat > thr) = thr;   %% clipping features


valid_labels = [1 2 3 4 5 6 9 10 12 13 14 15 17 20 22 23 24 27];

f1 = find(ismember(data.label, valid_labels));
data = sub(data, f1, 2);
