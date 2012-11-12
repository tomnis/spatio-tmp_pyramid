addpath ..

xlen = 1280;
ylen = 960;
protate = 0.5;
start_frame = 1;
end_frame = 1000;

dim = struct('start_frame', start_frame, 'end_frame', end_frame, 'xlen', xlen, 'ylen', ylen, 'protate', protate);

[p1 p2 p3] = get_points([0 xlen/2 xlen/2], xlen, ylen, start_frame, end_frame);
cuts.xcuts = get_plane_eq(p1, p2, p3);

[p1 p2 p3] = get_points([ylen/2 0 ylen/2], xlen, ylen, start_frame, end_frame);
cuts.ycuts = get_plane_eq(p1, p2, p3);

[p1 p2 p3] = get_points([dim.end_frame/2 dim.end_frame/2 0], xlen, ylen, start_frame, end_frame);
cuts.zcuts = get_plane_eq(p1, p2, p3);

assert(bin([1 1 start_frame], cuts, dim) == 0);
assert(bin([1 1 end_frame], cuts, dim) == 1);
assert(bin([1 ylen start_frame], cuts, dim) == 2);
assert(bin([1 ylen end_frame], cuts, dim) == 3);
assert(bin([xlen 1 start_frame], cuts, dim) == 4);
assert(bin([xlen 1 end_frame], cuts, dim) == 5);
assert(bin([xlen ylen start_frame], cuts, dim) == 6);
assert(bin([xlen ylen end_frame], cuts, dim) == 7);

disp('passed all bin tests');
