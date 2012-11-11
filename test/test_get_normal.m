addpath ..

p1 = [1,3,2];
p2 = [3,-1,6];
p3 = [5,2,0];

nrm = get_normal(p1,p2,p3);
% example taken from steward calc textbook
unnorm = [12 20 14];
assert(isequal(nrm, unnorm ./ norm(unnorm)));

eq = get_plane_eq(p1,p2,p3)
eq1 = [12 20 14 100] ./norm(unnorm)
assert(isequal(eq, eq1, eps))
