% given the data with best scores already computed, compute a distribution
% of object locations
% we will need to normalize the x,y,z coordinates by the dimensions 
% of the clip
% compute a mean and stddev for each dimension. 
% TODO this will compute using all data points, should there be filtering first?
function [distr] = compute_obj_distr(data)

distr = struct('x_mean', [], 'x_std', [], 'y_mean', [], 'y_std', [], 'z_mean', [], 'z_std', []);

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

distr.x_mean = mean(locs(:, 1));
distr.x_std = std(locs(:, 1));
% TODO see if any difference from using the mle
%j = mle(locs(:,1), 'distribution', 'norm')
distr.y_mean = mean(locs(:, 2));
distr.y_std = std(locs(:, 2));
distr.z_mean = mean(locs(:, 3));
distr.z_std = std(locs(:, 3));


bin_centers = [.05:.1:1];
hist(locs(:,3), bin_centers);
