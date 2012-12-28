% given a space-time feature f = (x,y,z) and a set of planar cuts, determine 
% which unique region f is located in by determining where f is relative to each of the cuts
function [bin_label] = bin(f, cut_eqs, dim)
	assert(isequal(size(f), [1 3]));
	bin_label = 0;
	
	% x := 2x or x := 2x +1 as necessary
	for i=1:size(cut_eqs.xcuts,1)
		bin_label = 2 * bin_label + compare(f, cut_eqs.xcuts(i,:), dim);
	end

	for i=1:size(cut_eqs.ycuts,1)
		bin_label = 2 * bin_label + compare(f, cut_eqs.ycuts(i,:), dim);
	end
	
	for i=1:size(cut_eqs.zcuts,1)
		bin_label = 2 * bin_label + compare(f, cut_eqs.zcuts(i,:), dim);
	end

	bin_label;
end


% return 0 if f is closer to the origin, 1 otherwise
% cut = [a b c d] where ax + by + cz = d is the equation of the cut plane
function [c] = compare(f, cut, dim)
	% get normal vector to this cut plane 
	% for equation of the form ax + by + cz = d, a normal vector is given by [a b c]
	nrm = cut(1:3);
	% compute the nearest point on the cut plane, then see which point is closer to the origin
	
	% p_prime is an arbitrary point on the plane, so use the 
	% point on the plane that is closest to the origin, which is given by:
	% [a b c] * d
	p_prime = nrm * cut(4) / norm(nrm);
	p = f + (dot(nrm, p_prime) - dot(nrm, f)) * nrm;

	origin = [1 1 dim.start_frame];
	c = dist(f, origin) >= dist(p, origin);
	assert(c == 0 || c == 1)
end


function [d] = dist(p1, p2)
	d = sqrt(sum((p1-p2) .^ 2));
end
