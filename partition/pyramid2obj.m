% give a pyramid, make an obj representation
function [] = pyramid2obj(pyramid, savefile)
  [verts, faces] = get_geom(pyramid, [0,1; 0,1; 0,1;], 1, [], []); 
  verts
  faces
  
  fid = fopen(savefile, 'w');
  s = '%s\n';
  
  fprintf(fid, s, 'mtllib default.mtl');

  fprintf(1, 'writing vertex data...\n');
  for i =1:length(verts)
    fprintf(fid, '%s', 'v ');
    fprintf(fid, '%s ', num2str(verts(i,1)));
    fprintf(fid, '%s ', num2str(verts(i,2)));
    fprintf(fid, s, num2str(verts(i,3)));
  end
  fprintf(fid, s, ['# ', num2str(length(verts)), ' vertices']);

  
  fprintf(1, 'writing texture vertex data...\n');
  fprintf(fid, s, 'vt 0 0 0');
  fprintf(fid, s, 'vt 0 1 0');
  fprintf(fid, s, 'vt 1 1 0');
  fprintf(fid, s, 'vt 1 0 0');


  fprintf(1, 'writing face data...\n');
  fprintf(fid, s, 'usemtl default');
  for i = 1:length(faces)
    fprintf(fid, '%s', 'f ');
    fprintf(fid, '%s ', [num2str(faces(i,1)), '/1']);
    fprintf(fid, '%s ', [num2str(faces(i,2)), '/2']);
    fprintf(fid, '%s ', [num2str(faces(i,3)), '/3']);
    fprintf(fid, s, [num2str(faces(i,4)), '/4']);
  end
  fprintf(fid, s, ['# ', num2str(length(faces)), ' polygons']);


  fclose(fid);
end

function [verts, faces] = get_geom(pyramid, constraints, ind, oldverts, oldfaces)
  r = pyramid.kdtree(ind);
  dim_ind = pyramid.get_dimension(ind)+1;
  dim = pyramid.perm(dim_ind);
  
  if dim == 1
    v1 = [r, constraints(2, 1), constraints(3,1)];
    v2 = [r, constraints(2, 1), constraints(3,2)];
    v3 = [r, constraints(2, 2), constraints(3,1)];
    v4 = [r, constraints(2, 2), constraints(3,2)];
  elseif dim == 2
    v1 = [constraints(1, 1), r, constraints(3,1)];
    v2 = [constraints(1, 1), r, constraints(3,2)];
    v3 = [constraints(1, 2), r, constraints(3,1)];
    v4 = [constraints(1, 2), r, constraints(3,2)];
  elseif dim == 3
    v1 = [constraints(1, 1), constraints(2,1), r];
    v2 = [constraints(1, 1), constraints(2,2), r];
    v3 = [constraints(1, 2), constraints(2,1), r];
    v4 = [constraints(1, 2), constraints(2,2), r];
  end
  
  verts = [oldverts; v1; v2; v4; v3];
  faces = [oldfaces; [length(verts)-3:length(verts)]];

  % now recurse
  left_child = pyramid.get_left_child_ind(ind);
  if left_child <= length(pyramid.kdtree)
    c_left = zeros(size(constraints)) + constraints;
    c_left(dim_ind, 2) = r;
    [verts, faces] = get_geom(pyramid, c_left, left_child, verts, faces);
  end

  right_child = pyramid.get_right_child_ind(ind);
  if right_child <= length(pyramid.kdtree)
    c_right = zeros(size(constraints)) + constraints;
    c_right(dim_ind, 1) = r;
    [verts, faces] = get_geom(pyramid, c_right, right_child, verts, faces);
  end
end
