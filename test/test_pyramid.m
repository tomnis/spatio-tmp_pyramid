p = Pyramid(3, []);

% test get dimension
assert(p.get_dimension(1) == 0)
assert(p.get_dimension(2) == 1)
assert(p.get_dimension(3) == 1)
assert(p.get_dimension(4) == 2)
assert(p.get_dimension(15) == 0)
assert(p.get_dimension(16) == 1)
assert(p.get_dimension(60) == 2)
fprintf(1, 'passed get_dimension()\n');

% test get level
assert(p.get_kdlevel(1) == 0)
assert(p.get_kdlevel(2) == 1)
assert(p.get_kdlevel(6) == 2)
assert(p.get_kdlevel(11) == 3)
assert(p.get_kdlevel(16) == 4)
fprintf(1, 'passed get_kdlevel()\n');

% test set entire level
p = Pyramid(3, []);
p = p.set_kdlevel_data(2, 2);
p = p.set_kdlevel_data(3, 3);
assert(isequal(p.kdtree(4:7), zeros(4,1) + 2));
assert(isequal(p.kdtree(8:15), zeros(8,1) + 3));
fprintf(1, 'passed set_level()\n');

randrs.x = RandDistr([], 0);
randrs.y = RandDistr([], 0);
randrs.z = RandDistr([], 0);
p = Pyramid(2, randrs);
fprintf(1, 'passed RandDistr pyramid()\n');


% test the empty pyramid
p = Pyramid(1, []);
assert(length(p.kdtree) == 0);
assert(p.bin(.5, .5, .5) == 0)
fprintf(1, 'passed empty pyramid (one level)\n');


% we get a regular pyramid by passing in an empty distribution
p = Pyramid(2, []);
for i=1:length(p.kdtree)
	assert(p.kdtree(i) == .5);
end
fprintf(1, 'passed regular pyramid()\n');


% test get the pyramid level
p = Pyramid(4, []);
assert(p.get_pyramid_level(1) == 1);
assert(p.get_pyramid_level(3) == 1);
assert(p.get_pyramid_level(4) == 1);
assert(p.get_pyramid_level(8) == 2);
assert(p.get_pyramid_level(127) == 3);
fprintf(1, 'passed get_pyramid_level()\n');


% test binning in 2 level regular pyramid
% this is dependent on the permutation used
p = Pyramid(2, []);
l = .25;
h = .75;
assert(p.bin(l, l, l) == 0);
assert(p.bin(l, l, h) == 1);
assert(p.bin(l, h, l) == 2);
assert(p.bin(l, h, h) == 3);
assert(p.bin(h, l, l) == 4);
assert(p.bin(h, l, h) == 5);
assert(p.bin(h, h, l) == 6);
assert(p.bin(h, h, h) == 7);
fprintf(1, 'passed bin()\n');


% test selective binning in 3 level regular pyramid
p = Pyramid(3, []); 

% consider only the top level, the entire clip
assert(p.bin_level(h, h, h, 0) == 0);
% consider level 1
assert(p.bin_level(l, l, l, 1) == 0);
assert(p.bin_level(l, l, h, 1) == 1);
assert(p.bin_level(l, h, l, 1) == 2);
assert(p.bin_level(l, h, h, 1) == 3);
assert(p.bin_level(h, l, l, 1) == 4);
assert(p.bin_level(h, l, h, 1) == 5);
assert(p.bin_level(h, h, l, 1) == 6);
assert(p.bin_level(h, h, h, 1) == 7);
fprintf(1, 'passed bin_level()\n');



% test apply partition
p = Pyramid(2, []);
dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960);

ex_old = p.kdtree;
p2 = p.apply_partition(dim);
ex_new = [640, 480, 480, 500, 500, 500, 500]';

assert(isequal(ex_old, p.kdtree));
assert(isequal(ex_new, p2.kdtree));
fprintf(1, 'passed apply_partition()\n');


% test custom permutation of dimensions
perm = [3,2,1];
p = Pyramid(2, [], perm);
assert(isequal(p.perm, perm));
fprintf(1, 'passed custom permutation of dimensions\n');
