function [data best_s_active best_s_passive frs objects_active objects_passive] = read_data(person_ids, path1, path2, path3)
k = 0;
for i = person_ids
  fname = [path1 'P_' sprintf('%0.2d', i) '.txt'];
  fid = fopen(fname);
  while 1
    txt1 = fgetl(fid);
    if isequal(txt1, -1)
      break
    end
    k = k+1;
    data.person(1, k)    = i;
    data.fr_start(1, k)  = (str2num(txt1(1:2))*60 + str2num(txt1(4:5)))*30; %%converting mm:ss to frame number
    data.fr_end(1, k)    = (str2num(txt1(7:8))*60 + str2num(txt1(10:11)))*30;
    data.label(1, k)     = str2num(txt1(13:min(14, length(txt1))));
  end
  fclose(fid);
end

for k = 1:length(data.label)
  assert(data.fr_start(k) < data.fr_end(k));
end

%%% reading best scoring detected objects
[best_s_active frs_active objects_active] = read_detected_objects(path2, person_ids);
[best_s_passive frs_passive objects_passive] = read_detected_objects(path3, person_ids);

for i = 1:length(frs_passive)
  assert(isequal(frs_active{i}, frs_passive{i}));
end
frs = frs_passive;
