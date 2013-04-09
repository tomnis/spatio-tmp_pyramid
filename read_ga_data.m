function [data, frames, best_scores, locations] = read_ga_data()
  path = '/tmp/labels2/';
  d = dir(path);
  d = d(4:end);
  
  action_list = get_action_list();
  object_list = get_object_list();
  % first figure out how many frames for each person
  all_frs = [];
  for i=1:3
    frames{i} = [];
    for a = 1:length(action_list)
      frs = dir(['/var/local/png/S', num2str(i), '_', action_list{a}, '_C1']);
      % get rid of parent dirs
      num_frs = length(frs) -2;
      all_frs(i,a) = num_frs;
    end
  end

  for i=1:3
    best_scores.active{i} = zeros(length(object_list), sum(all_frs(i,:)));
    locations.active{i} = zeros(length(object_list), sum(all_frs(i,:)), 4);
    best_scores.passive{i} = zeros(length(object_list), sum(all_frs(i,:)));
    locations.passive{i} = zeros(length(object_list), sum(all_frs(i,:)), 4);
  end

  
  all_frs
  person = 0;
  offset = 0;
  action_ind = 1;
  for i=1:length(d)
    disp(d(i).name)   
    
    thisperson = str2num(d(i).name(2));
    if thisperson == 4
      break
    end

    if thisperson ~= person
      offset = 0;
      person = thisperson;
      action_ind = 1;
    else
      offset = offset + all_frs(person, action_ind);
      action_ind = action_ind + 1 ;
    end
    
    label = d(i).name(4:end);
    label = label(1:strfind(label, '_')-1);
    data.person(i) = person;
    data.label{i} = label;
    
    f = fopen([path, d(i).name]);
    line = fgetl(f);
    first = 1;
    while ischar(line)
      if length(line) > 0 && line(end) == ']'
        
        j = strfind(line, '>')+1;
        line = line(j:end);
        
        j = strfind(line, '>')-1;
        objs = regexp(line(2:j), ',', 'split');

        l = strfind(line, '(')+1;
        j = strfind(line, ')')-1; 
        frs = regexp(line(l:j), '-', 'split');

        if first
          fr_start = str2num(frs{1});
          first = 0;
        end
        fr_end = str2num(frs{2});
        
        % now read the locations for each frame
        for fr = str2num(frs{1}):str2num(frs{2})
          [frame_scores frame_locs] = get_frame_data(objs, d(i).name, fr);
          best_scores.active{person}(:, offset+fr) = frame_scores;
          locations.active{person}(:,offset + fr,:) = frame_locs;
        end
      end
      line = fgetl(f);
    end
    data.fr_start(i) = offset + fr_start;
    data.fr_end(i) = offset + fr_end;
    frames{person} = [frames{person}, offset+fr_start:offset+fr_end];
  end
  data.label = strs2nums(data.label, 'action');
end



function [frame_scores, frame_locs] = get_frame_data(objs, name, frame)
  action_list = get_action_list();
  object_list = get_object_list();
  frame_scores = zeros(length(object_list), 1);
  frame_locs = zeros(length(object_list), 1, 4);

  p = sprintf('%010d', frame);
  path = ['/tmp/masks/', name(1:end-4), '/'];
  try
    load([path, 'finalHandObjectSegments_hack_', p, '_30_10_500_16']);
  catch
    fprintf(1, 'no file.. skipping frame %d for %s\n', frame, name)
    return
  end
  % bounding box for the object detection
  [r,c]=find(maskO==max(max(maskO)));
  xmin = min(c);
  ymin = min(r);
  xmax = max(c);
  ymax = max(r);

  nums = strs2nums(objs, 'objects');
  for i=1:length(nums)
    frame_locs(nums(i),:,:) = [xmin, ymin, xmax, ymax];
    frame_scores(nums(i)) = frame_scores(nums(i)) + 1;
  end
  
  % bounding box for left hand
  [r,c]=find(maskLH==max(max(maskLH)));
  xmin = min(c);
  ymin = min(r);
  xmax = max(c);
  ymax = max(r);
  frame_locs(17,:,:) = [xmin, ymin, xmax, ymax];
  frame_scores(17) = frame_scores(nums(i)) + 1;

  % bounding box for right hand
  [r,c]=find(maskRH==max(max(maskRH)));
  xmin = min(c);
  ymin = min(r);
  xmax = max(c);
  ymax = max(r);
  frame_locs(18,:,:) = [xmin, ymin, xmax, ymax];
  frame_scores(18) = frame_scores(nums(i)) + 1;
end

   
function [nums] = strs2nums(strs, type)
  if strcmp(type, 'action')
    list = get_action_list();
  else
    list = get_object_list();
  end
  nums = [];

  for k=1:length(strs)
    nums(k) = find(strcmp(strs{k}, list) > 0);
  end
end


function [action_list] = get_action_list()
  action_list{1} = 'Cheese';
  action_list{2} = 'CofHoney';
  action_list{3} = 'Coffee';
  action_list{4} = 'Hotdog';
  action_list{5} = 'Pealate';
  action_list{6} = 'Peanut';
  action_list{7} = 'Tea';
end


function [object_list] = get_object_list()
  object_list{1} = 'bread';
  object_list{2} = 'cheese';
  object_list{3} = 'chocolate';
  object_list{4} = 'coffee';
  object_list{5} = 'cup';
  object_list{6} = 'honey';
  object_list{7} = 'hotdog';
  object_list{8} = 'jam';
  object_list{9} = 'ketchup';
  object_list{10} = 'mayonnaise';
  object_list{11} = 'mustard';
  object_list{12} = 'peanut';
  object_list{13} = 'spoon';
  object_list{14} = 'sugar';
  object_list{15} = 'tea';
  object_list{16} = 'water' ;
  object_list{17} = 'lefthand';
  object_list{18} = 'righthand';
end
