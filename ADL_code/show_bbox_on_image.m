function im1 = show_bbox_on_image(im1, bbox, col, lw, bbox_id, bbox_bws)
% drawss bbox on an image (im1) and returns the image file
% % bbox: a matrix of size n*5
% default color is 1:red
% default line width (lw) is 3

sz = size(bbox,1);
if ~exist('lw')
  lw(1:sz) = 2;
end

[sz1 sz2 sz3] = size(im1);

bbox = round(bbox);

for j = floor(size(bbox,2)/4):-1:1  %% for visualizing oarts (not useful here)
  for i = 1:sz
    x1 = bbox(i, (j-1)*4+1);
    y1 = bbox(i, (j-1)*4+2);
    x2 = bbox(i, (j-1)*4+3);
    y2 = bbox(i, (j-1)*4+4);
    
    this_col = col(:, bbox_id(i));

    m1 = floor((lw(i)-1)/2);   %% -1 because of the pixel itself
    m2 = ceil((lw(i)-1)/2);
    for k = 1:3  %% RGB
      im1(max(1,y1-m1):min(sz1,y1+m2), max(1,x1):min(sz2,x2), k) = this_col(k);
      im1(max(1,y2-m1):min(sz1,y2+m2), max(1,x1):min(sz2,x2), k) = this_col(k);
      im1(max(1,y1):min(sz1,y2), max(1,x1-m1):min(sz2,x1+m2), k) = this_col(k);
      im1(max(1,y1):min(sz1,y2), max(1,x2-m1):min(sz2,x2+m2), k) = this_col(k);
    end
    
    im1 = show_text_on_image(im1, bbox_bws{i}, x1, y1, this_col);
  end
end