% return an array of features for the 
function [feats] = read_feats(path, person_ids)
path
k = 0;
for i = person_ids
	fname = [path 'object_annot_P_' sprintf('%0.2d', i) '.txt']
	fid = fopen(fname);
	while 1
		% line(2:5) = [x1 y1 x2 y2]
		% line(6) = frame number
		% line(7) = boolean indicating active object
		% line(8) = object label
		line = fgetl(fid);
		if isequal(line, -1)
			break
		end
		line = strsplit(line);
		k = k + 1;
		feats.person(1, k) = i;
	
		crds = [];
		for j=2:5
			crds = [crds str2num(line{j})];
		end

		feats.x(1,k) = crds(1) + mean([crds(1) crds(3)]);
		feats.y(1,k) = crds(2) + mean([crds(2) crds(4)]);
		feats.z(1,k) = str2num(line{6});
		feats.label(1,k) = line(8);
	end
	fclose(fid);
end
