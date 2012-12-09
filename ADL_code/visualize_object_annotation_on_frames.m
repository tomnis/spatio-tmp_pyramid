function visualize_object_annotation_on_frames(path_frames, fname_annot, path_frames_out)

mkdir(path_frames_out);

[annot annot_frs] = read_object_annotation(fname_annot);

%%% text image for labels
[label_texts dummy label_nums] = unique(annot.label);
for i = 1:length(label_texts)
  object_bws{i} = imresize(text2im(label_texts{i}), 0.7);
end

%%% text image for id numbers
for i = 1:max(annot.id)+1
  track_id_bws{i} = imresize(text2im(num2str(i)), 0.7);
end

col = floor(rand(3, max(annot.id)+1)*128)+128;  %% random colors

for fr = annot_frs
  im1 = imread([path_frames sprintf('%0.6d.jpg', fr+1)]); %%% +1 since frame in annotation starts from 0.
  im1 = imresize(im1, 0.5);

  f1 = find(annot.fr == fr);
  if ~isempty(f1)
    bbox = annot.bbox(f1, :);
    bbox_id = annot.id(f1) + 1; %% +1 since id is anotation starts from 0
    
    clear bbox_bws
    for i = 1:length(f1)
      bbox_bws{i} = [object_bws{label_nums(f1(i))} track_id_bws{bbox_id(i)}];
    end
    line_width = annot.active(f1)*4 + 2; %%% line with is 2 for passive objects and 4 for active ones.
    im1 = show_bbox_on_image(im1, bbox, col, line_width, bbox_id, bbox_bws);
  end
  imwrite(im1, [path_frames_out sprintf('%0.6d.jpg', fr)]);
end
