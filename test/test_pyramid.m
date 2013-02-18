p = Pyramid(3, []);

% test get dimension
assert(p.get_dimension(1) == 0)
assert(p.get_dimension(2) == 1)
assert(p.get_dimension(3) == 1)
assert(p.get_dimension(4) == 2)
assert(p.get_dimension(15) == 0)
assert(p.get_dimension(16) == 1)
assert(p.get_dimension(60) == 2)

% test get level
assert(p.get_kdlevel(1) == 0)
assert(p.get_kdlevel(2) == 1)
assert(p.get_kdlevel(6) == 2)
assert(p.get_kdlevel(11) == 3)
assert(p.get_kdlevel(16) == 4)

% test set root
p = Pyramid(3, []);
p = p.set_root(1);
assert(p.kdtree(1) == 1);

% test set entire level
p = Pyramid(3, []);
p = p.set_kdlevel_data(2, 2);
p = p.set_kdlevel_data(3, 3);
assert(isequal(p.kdtree(4:7), zeros(4,1) + 2));
assert(isequal(p.kdtree(8:15), zeros(8,1) + 3));
