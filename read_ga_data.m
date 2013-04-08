function [data] = read_ga_data(path)
  d = dir(path);
  d = d(4:end);
  % now d has just the relevant Si.... files
  d.name;
 
  k = 1;
  
  objectstrs = {}
  for i =1:length(d)
    f = fopen([path, d(i).name]);
    person = str2num(d(i).name(2));
    
    % loop through the lines in f
    % <action><object> (frames) [bool]
    line = fgetl(f);
    while ischar(line)
      if length(line) > 0 && line(end) == ']'
        % get the label
        j = strfind(line, '>')-1;
        label = line(2:j);
        line = line(j+2:end);
        
        j = strfind(line, '>')-1;
        objs = regexp(line(2:j), ',', 'split');
        line = line(strfind(line, '('):end);
        
        j = strfind(line, ')')-1;
        frs = regexp(line(2:j), '-', 'split');

        data.person(k) = person;
        data.vid{k} = d(i).name;
        labelstr{k} = label;
        data.objstr{k} = objs;
        data.fr_start(k) = str2num(frs{1});
        data.fr_end(k) = str2num(frs{2});
        
        k = k +1;
      end
      line = fgetl(f);
    end
    fclose(f); 
  end
  
  %data.person
  %data.labelstr
  %data.fr_start
  %data.fr_end
  data.label = labelstr2num(labelstr);
end


% go from string labels to integer labels
function [label_nums] = labelstr2num(labelstrs)
  sorted = sort(unique(labelstrs));
  label_nums = [];

  for k = 1:length(labelstrs)
    label_nums(k) = find(strcmp(labelstrs{k}, sorted) > 0);
  end
end
