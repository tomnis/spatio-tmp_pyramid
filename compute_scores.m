% TODO  change this to check for defined of variabe object type
object_type = 'active_passive';

size(best_s_active)

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
