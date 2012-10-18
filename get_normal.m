% given three points, return a vector normal to the plane that contains the points
function [nrm] = get_normal(p1, p2, p3)
	% compute an orthogonal vector, then normalize
	nrm = cross(p1-p2, p1-p3);
	nrm = nrm ./ norm(nrm);
end
