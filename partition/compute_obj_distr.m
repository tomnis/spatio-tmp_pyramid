% given the data with best scores already computed, compute a distribution
% of object locations
% we will need to normalize the x,y,z coordinates by the dimensions 
% of the clip
% compute a mean and stddev for each dimension. 
% TODO this will compute using all data points, should there be filtering first?
function [distr] = compute_obj_distr(data, num_bins)

distr = struct('bx', [], 'by', [], 'bz', []);

locs = [];
% TODO get rid of these constants, maybe insert into the data struct
xlen = 1280;
ylen = 960;


% TODO there is some very similar code in compute_feats, should refactor


for k=1:length(data.best_s)
	%for r = 1:size(data.best_s{k}, 1)
	% the first 5 are active objects
	for r = 1:5
		num_frames = size(data.best_s{k}, 2);
		for c = 1:num_frames
		
			if data.best_s{k}(r,c) > 0
				% reshape the location from 1x1x4 to 1x4
				loc = reshape(data.locs{k}(r,c,:), 1,4);
				
				% compute the centroid of the bounding box
				x = mean([loc(1) loc(3)]) / xlen;
				y = mean([loc(2) loc(4)]) / ylen;
				% the frame is the column in the best score matrix
				z = c / num_frames;
				locs = [locs; x,y,z];
			end
		end
	end
end

bin_centers = [.05:.1:1];

[bx, x] = hist(locs(:,1), bin_centers);
[by, y] = hist(locs(:,2), bin_centers);
[bz, z] = hist(locs(:,3), bin_centers);


% normalize
bx = bx / sum(bx);
by = by / sum(by);
bz = bz / sum(bz);

distr.bx = bx;
distr.by = by;
distr.bz = bz;

%{
subplot(2,3,1);
bar(x, bx); 
title 'distribution ob active objects among x axis (normalized)'

subplot(2,3,2);
bar(y, by); 
title 'distribution ob active objects among y axis (normalized)'

subplot(2,3,3);
bar(z, bz); 
title 'distribution ob active objects among z (time) axis (normalized)'

subplot(2,3,4);
bar(x, get_inv(bx));

subplot(2,3,5);
bar(y, get_inv(by));

subplot(2,3,6);
bar(z, get_inv(bz));
%}
end

% TODO move this to the randgen
function [inv] = get_inv(fn)
	std(fn)
	inv = max(fn) - fn  + .25 * std(fn);
	inv = inv / (sum(inv));
end
