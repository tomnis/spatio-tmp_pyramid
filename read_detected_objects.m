function [best_s locations frs objects] = read_detected_objects(path2, person_ids)

%%% list of detected objects
dirlist = dir(path2);
% get rid of . and ..
dirlist(1:2) = [];
for i = 1:length(dirlist)
  objects{i} = dirlist(i).name
end

%%% reading best scoring detected objects
for i = person_ids
  for j = 1:length(objects)
    fname = [path2 objects{j} '/' 'P_' sprintf('%0.2d', i) '.mat']
    clear boxes frs
    load(fname);
    
    assert(length(boxes) == length(frs));
    frs1{i} = frs;
    if j > 1
      assert(isequal(frs, frs1{i}));
    end
    for i1 = 1:length(boxes)
			% boxes{i1}.s -> scores
			% boxes{i1}.c -> category labels
			% boxes{i1}.xy -> [x1 y1 x2 y2]
      if ~isempty(boxes{i1})
				[max_score ind] = max([boxes{i1}.s]);
        best_s{i}(j, i1) = max_score;
				% we also need to store the observed location of each
				locations{i}(j, i1, :) = boxes{i1}(ind).xy;
        %best_s{i}(j, i1) = max([boxes{i1}.s]);
        %         best_s_exist{i}(j, i1) = 1;
      else
        best_s{i}(j, i1) = -100;
        %         best_s_exist{i}(j, i1) = 0;
      end
    end
  end
end
frs = frs1;
