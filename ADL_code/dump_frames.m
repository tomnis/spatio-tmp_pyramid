clear
path0 = '/scratch2/Hamed/ADL/data_cvpr12/ADL_data/full/';

person_ids = [11];

path_video = [path0 'videos/'];
path_annot = [path0 'object_annotation/'];
path_frames0 = [path0 'frames/'];
path_frames_annotated0 = [path0 'frames_annotated/'];

for i = person_ids
  path_frames = [path_frames0 'P_' sprintf('%0.2d', i) '/'];
  path_frames_annotated = [path_frames_annotated0 'P_' sprintf('%0.2d', i) '/'];
  fname_annot = [path_annot 'object_annot_P_' sprintf('%0.2d', i) '.txt'];
%   video2frames([path_video 'P_' sprintf('%0.2d', i) '.MP4'], path_frames);
  visualize_object_annotation_on_frames(path_frames, fname_annot, path_frames_annotated);
end

  
  
