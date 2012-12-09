function im1 = show_text_on_image(im1, bw, x1, y1, text_col)

[sz1 sz2] = size(bw);
[sz1_im sz2_im dummy] = size(im1);

x1 = min(max(x1-10, 1), sz2_im);
y1 = min(max(y1-20, 1), sz1_im);

x2 = min(x1 + sz2 - 1, sz2_im);
y2 = min(y1 + sz1 - 1, sz1_im);

x1 = x2 - sz2 + 1;
y1 = y2 - sz1 + 1;

for k = 1:3
  im1(y1:y2, x1:x2, k) = (1-bw) * text_col(k);
end
