function [annot annot_frs] = read_object_annotation(fname)
%%% reads object annotations from text files

% sample line
% 000001 120 230 456 479 00000000 0 person

fid = fopen(fname, 'r');
if isequal(fid, -1)
  display('file not found')
  annot = [];
  return
end
k = 0;
while 1
  txt1 = fgetl(fid);
  if isequal(txt1, -1)
    break
  end
  k = k+1;
  annot.fr(k, 1)      = str2num(txt1(24:31));
  annot.bbox(k, 1:4)  = str2num(txt1(8:22));
  annot.id(k, 1)      = str2num(txt1(1:6));
  annot.label{k, 1}   = txt1(35:end);
  annot.active(k, 1)  = str2num(txt1(33));
end
fclose(fid);

%%% reading the list of annotated frames
k = 0;
fid = fopen([fname(1:end-4) '_annotated_frames.txt'], 'r');
while 1
  txt1 = fgetl(fid);
  if isequal(txt1, -1)
    break
  end
  k = k+1;
  annot_frs(k) = str2num(txt1);
end
fclose(fid);



