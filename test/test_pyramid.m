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

% test set root
p = Pyramid(3, []);
p = p.set_root(1);
assert(p.kdtree(1) == 1);
fprintf(1, 'passed set_root()\n');

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

% we get a regular pyramid by passing in an empty distribution
p = Pyramid(2, []);
for i=1:length(p.kdtree)
	assert(p.kdtree(i) == .5);
end
fprintf(1, 'passed regular pyramid()\n');

% test binning in 2 level regular pyramid
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
