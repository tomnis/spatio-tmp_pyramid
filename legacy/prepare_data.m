clear data
%[data best_s_active best_s_passive locations_active locations_passive frs objects_active objects_passive] = read_data(person_ids, path1, path2, path3);
% we have the loaded object data saved in this file
%save tempfile data best_s_active best_s_passive locations_active locations_passive frs objects_active objects_passive
	
load tempfile
object_type

%%% assigning best scores to each pre-segmented data point (clip)
compute_scores


regular = 0;
%%% now make the partition scheme
% make_pool takes as param the maximum level
if num_levels > 1
	partition = make_pool(1, num_levels, dim.protate, regular);
	partition = partition{1}
end

% compute feature histograms for each clip
compute_feats
