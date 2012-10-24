% given three points on the plane,
% represent a cut as a normal plane equation
% in the form [x,y,z,d]
function [eq] = get_plane_eq(p1, p2, p3)
	nrm = get_normal(p1, p2, p3);
	d = dot(nrm, p1);
	eq = [nrm, d];
	assert(isequal(size(eq), [1,4]));
end
