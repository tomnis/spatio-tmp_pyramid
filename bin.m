% given a space-time feature f = (x,y,z) and a set of planar cuts, determine 
% which unique region f is located in by determining where f is relative to each of the cuts
% TODO need to know the xlen, ylen, start and end frames to compute this result?
function [bin_label] = bin(f, cuts)
	assert(isequal(size(f), [1,3]));
	bin_label = 0;
	
	% x := 2x or x := 2x +1 as necessary
	for i=1:size(cuts.xcuts,1)
		bin_label = 2 * bin_label + compare(f, cuts.xcuts(i,:));
	end
	for i=1:size(cuts.ycuts,1)
		bin_label = 2 * bin_label + compare(f, cuts.ycuts(i,:));
	end
	for i=1:size(cuts.zcuts,1)
		bin_label = 2 * bin_label + compare(f, cuts.zcuts(i,:));
	end
end


% return 0 if f is closer to the origin, 1 otherwise
function [c] = compare(f, cut)
	% get normal vector to this cut plane 
	% for equation of the form ax + by + cz = d, a normal vector is given by [a b c]
	nrm = cut(1:3);
	c = 0;
	% compute the nearest point on the cut plane, then see which point is closer to the origin
	%  (f . n) / (n . n) * n where n is the normal to the plane and . denotes dot product.	
	p = dot(f, nrm) / dot(nrm, nrm) * nrm;
	% TODO should the origin take start_frame into account?
	origin = [0 0 0];
	c = dist(f, origin) >= dist(p, origin);
	assert(c == 0 || c == 1)
end
