% initially start_frame and end_frame set to dummy values
protate = 0;
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);
dim.spatial_cuts = 0;

randr = RandDistr([], 0);

t = Tpyramid(randr, 5, 0);
oldlcuts = t.ltcuts
oldrcuts = t.rtcuts

tprime = t.apply_partition(dim);
assert(isequal(oldlcuts, t.ltcuts))
assert(isequal(oldrcuts, t.rtcuts))
tprime.cut_eqs


t = Tpyramid(randr, 10, 1);
oldlcuts = t.ltcuts
oldrcuts = t.rtcuts

tprime = t.apply_partition(dim);
assert(isequal(oldlcuts, t.ltcuts))
assert(isequal(oldrcuts, t.rtcuts))
tprime.cut_eqs
