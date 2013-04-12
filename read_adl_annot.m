% read the adl object annotations
function [data, frames, best_scores, locations] = read_adl_annot()
  person_ids = [7:20]
  path = '~/thesis/ADL_code/ADL_annotations/';
  setup
  
  k = 0;
  for i = person_ids
    fname = [path, 'action_annotation/', 'P_' sprintf('%0.2d', i) '.txt'];
    fid = fopen(fname);
    while 1
      txt1 = fgetl(fid);
      if isequal(txt1, -1)
        break
      end
      k = k+1;
      data.person(k)    = i;
      data.fr_start(k)  = (str2num(txt1(1:2))*60 + str2num(txt1(4:5)))*30; %%converting mm:ss to frame number
      data.fr_end(k)    = (str2num(txt1(7:8))*60 + str2num(txt1(10:11)))*30;
      data.label(k)     = str2num(txt1(13:min(14, length(txt1))));
    end
    fclose(fid);
  end
  % takes care of data


  % need ordering of the active and passive objects
  all_active = {};
  all_passive = {};

  %for person=person_ids
  for person=person_ids
    personf = sprintf('%02d', person);
    file = ['object_annot_P_', personf, '.txt']
    [annot annot_frs] = read_object_annotation([path, 'object_annotation/', file]);
    
    % get rid of trailing space if it exists
    for k=1:length(annot.label)
      if isequal(annot.label{k}(end), ' ')
        annot.label{k} = annot.label{k}(1:end-1);
      end
    end

    % may not have to add 1 here to all frame nums?
    annot_frs = annot_frs + 1;
    annot.fr = annot.fr + 1;
    
    % store the frames and annotations for this person
    frames{person} = annot_frs;
    all_annot{person} = annot;
    % active objects
    person_ao = unique(annot.label(find(annot.active == 1)));
    all_active = unique(cat(1, all_active, person_ao));
    % passive objects
    person_po = unique(annot.label(find(annot.active == 0)));
    all_passive = unique(cat(1, all_passive, person_po));
  end
  

  all_active
  all_passive
  
  for person =person_ids
    % allocate space
    active_objs = zeros(length(all_active), length(frames{person}));
    active_locs = zeros(length(all_active), length(frames{person}), 4);
    passive_objs = zeros(length(all_passive), length(frames{person}));
    passive_locs = zeros(length(all_passive), length(frames{person}), 4);
    
    annot = all_annot{person};
    % for each annotation of this person, increment the appropriate histogram
    % and store the locations
    for k=1:length(annot.fr)
      frameind = find(frames{person} == annot.fr(k));
      if size(frameind) == [1 0]
        fprintf(1, 'skipping frame %d of %d\n', k, length(annot.fr));
        continue
      end
      if annot.active(k)
        objind = strs2nums(annot.label(k), all_active);
        active_objs(objind, frameind) = active_objs(objind, frameind) + 1;
        active_locs(objind, frameind, :) = annot.bbox(k,:);
      else
        objind = strs2nums(annot.label(k), all_passive);
        passive_objs(objind, frameind) = passive_objs(objind, frameind) + 1;
        passive_locs(objind, frameind, :) = annot.bbox(k,:);
      end
    end

    best_scores.active{person} = active_objs;
    best_scores.passive{person} = passive_objs;
    locations.active{person} = active_locs;
    locations.passive{person} = passive_locs;
  end
end

% look up each string in qstrs, 
% form a vector containing the index for each string in ans_strs
function [nums] = strs2nums(qstrs, ans_strs)
  nums = zeros(length(qstrs),1);
  for i=1:length(qstrs)
    nums(i) = find(strcmp(qstrs{i}, ans_strs) > 0);
  end
end
