% class to represent the dataset 
classdef DataSet

	properties (GetAccess='public', SetAccess='private')
		person % person filming each clip
		fr_start % start frames of each clip
		fr_end % end frames of each clip
		label % action labels of each clip
		
		frs % cell; frames in each clip
		best_s_active % cell; best scoring active objects in each clip
		best_s_passive % cell; best scoring passive objects in each clip
		best_s % cell; best scoring overall, computed in compute_scores
		locs % cell; locations of objects in each clip

		num_clips
		valid_labels
	end

	methods (Access='private')
	
		function self=set_scores(self, frs, best_scores, locations, object_type)
			best_s_active = best_scores.active;
			best_s_passive = best_scores.passive;	
			locs_active = locations.active;
			locs_passive = locations.passive;

			%%% assigning best scores to each pre-segmented data point (clip)
			for k = 1:length(self.label)
			  i = self.person(k);
				% TODO figure out exactly what this is doing
			  f1 = find((frs{i} > self.fr_start(k)) .* (frs{i} < self.fr_end(k)));
				% the frames of person i that are in this clip
				self.frs{k} = frs{i}(f1);

				 
 				self.best_s_active{k} = best_s_active{i}(:, f1);
			  self.best_s_active{k} = self.best_s_active{k} + 0.7;
			  self.best_s_active{k}(self.best_s_active{k} < 0) = 0;
  
				self.best_s_passive{k} = best_s_passive{i}(:, f1);
			  self.best_s_passive{k} = self.best_s_passive{k} + 0.35;
			  self.best_s_passive{k}(self.best_s_passive{k} < 0) = 0;
			
				%% active + passive objects
				if isequal(object_type, 'active_passive') 
			    self.best_s{k} = [self.best_s_active{k}; self.best_s_passive{k}]; 
					self.locs{k} = [locs_active{i}(:, f1, :); locs_passive{i}(:, f1, :)];
			  %% passive objects only
				elseif isequal(object_type, 'passive')
			    self.best_s{k} = [self.best_s_passive{k}]; 
					self.locs{k} = [locs_passive{i}(:, f1, :)];
			  end
			end

			% sanity check, should have locations for each score
			assert(isequal(size(self.locs), size(self.best_s)));
		end





	end

	methods 
		% constructor
		% (data, frs, best_scores, locations, object_type)
		function self=DataSet(data, frs, best_scores, locations, object_type)
			% TODO add some error checking here
			self.person = data.person;
			self.fr_start = data.fr_start;
			self.fr_end = data.fr_end;
			self.label = data.label;
			
			self.num_clips = length(self.person);
			% initialize the cell arrays
			self.frs = cell(1, self.num_clips);
			self.best_s_active = cell(1, self.num_clips);
			self.best_s_passive = cell(1, self.num_clips);
			self.best_s = cell(1, self.num_clips);
			self.locs = cell(1, self.num_clips);


			self = set_scores(self, frs, best_scores, locations, object_type);
			% remap the label set
			self.valid_labels = [1 2 3 4 5 6 9 10 12 13 14 15 17 20 22 23 24 27];
			f1 = find(ismember(self.label, self.valid_labels));
			self = sub(self, f1, 2);
			labels = unique(self.label);
			n_label = length(labels);
			%% mapping the action labels to a new label set.
			map1(labels+1) = [1:n_label]; 
			self.label = map1(self.label+1);
		end




		% given a partition, compute the resulting feature histograms for each clip
		function hists=compute_histograms(self, partition, dim)
			dim.num_feat_types = size(self.best_s{1}, 1);
			for k=1:self.num_clips
      	clear features
        i = self.person(k);
      
      	% set the start and end frames of the current clip, used in compute_hist
      	dim.start_frame = self.frs{k}(1);
      	dim.end_frame = self.frs{k}(end);
      
      	features = struct('person', [], 'x', [], 'y', [], 'z', [], 'label',[]);
      	features_ind = 0;
      
      	for r = 1:size(self.best_s{k}, 1)
      		for c = 1:size(self.best_s{k}, 2)
      			if self.best_s{k}(r,c) > 0
      				features_ind = features_ind + 1;
      				
      				% reshape the location from 1x1x4 to 1x4
      				loc = reshape(self.locs{k}(r,c,:), 1,4);
      				
      				features.person(features_ind) = i;
      				% compute the centroid of the bounding box
      				features.x(features_ind) = mean([loc(1) loc(3)]);
      				features.y(features_ind) = mean([loc(2) loc(4)]);
      				% the frame is the column in the best score matrix
      				features.z(features_ind) = c;
      				% the object label is the row in the best score matrix
      				features.label(features_ind) = r;
      			end
      		end
      	end
      
      	% apply the partition to the features
      	cut_eqs = apply_partition(partition, dim);
				hists(:, k) = compute_hist(features, cut_eqs, dim);
			end
			hists = bsxfun(@rdivide, hists, sum(hists, 1) + eps); %% normalizing

			thr = 0.01;
			hists(hists > thr) = thr;   %% clipping features
		end




		% compute the ramanan-style histograms
		function hists = compute_ramanan_histograms(self, feat_type)
			assert(isequal(feat_type, 'bag') || isequal(feat_type, 'pyramid'));

      for k = 1:self.num_clips
        
        n_frs = length(self.frs{k});
        
        if isequal(feat_type, 'bag')
          self.feat(:, k) = sum(self.best_s{k}, 2) / n_frs;
        elseif isequal(feat_type, 'pyramid')
          mid_fr = (self.fr_start(1, k) + self.fr_end(1, k))/2;
          f1 = find(self.frs{1, k} < mid_fr);
          f2 = find(self.frs{1, k} >= mid_fr);
         	hists(:, k) = [sum(self.best_s{k}, 2); sum(self.best_s{k}(:, f1), 2); sum(self.best_s{k}(:, f2), 2)] / n_frs;
        end
        
      end
      hists = bsxfun(@rdivide, hists, sum(hists, 1) + eps); %% normalizing
      
      thr = 0.01;
      hists(hists > thr) = thr;   %% clipping features
		end




		function [traininds testinds] = get_split(self, train_frac)
			assert(0 <= train_frac && train_frac <= 1);
			traininds = [];
			testinds = [];

    	% get all the unique labels
    	uniq_labels = unique(self.label);
    
    	for	i = 1:length(uniq_labels)
    		% get all the clips with label i
    		cur_label = uniq_labels(i);
    		clips_with_label = find(self.label == cur_label);
    
    		% only one clip with this label type
    		if length(clips_with_label) == 1
					disp('singleton class');
    			continue;
    		end
    		
    		% how many clips with this label should we select?
    		num_sampledclips = round(train_frac * length(clips_with_label));
    
    		if num_sampledclips == length(clips_with_label)
    			num_sampledclips = num_sampledclips -1;
    		end
    		
    		% get a sample to use
    		sampled_inds = sort(randsample(length(clips_with_label), num_sampledclips));
    		not_sampled_inds = setdiff([1:length(clips_with_label)], sampled_inds);
    
    		train_inds_from_data = clips_with_label(sampled_inds);
    		test_inds_from_data = clips_with_label(not_sampled_inds);
    
    		% sanity check that we only select clips that have the correct label type
    		assert(length(find(self.label(train_inds_from_data) ~= cur_label)) == 0);
    		assert(length(train_inds_from_data) > 0);
    		assert(length(find(self.label(test_inds_from_data) ~= cur_label)) == 0);
    		assert(length(test_inds_from_data) > 0);
    
    		traininds = [traininds train_inds_from_data];
    		testinds = [testinds test_inds_from_data];
    	end
		end
		
		
		
		
		% return a subset of self
		function self = sub(self, I, D)
			if ~exist('D')
  			D = 1;
			end
			
			if ~isempty(self),
			  n = properties(self);
			  for i = 1:length(n),
			    f = n{i};
					
					if isequal(f, 'valid_labels')
						continue;
					end

			    if isequal(class(self.(f)), 'double')
						% scalar value, so subset doesnt make sense
						if length(self.(f)) == 1
							continue;
						end
			      self.(f) = self.(f)(I);

			    elseif isequal(class(self.(f)), 'cell')
						tmp = cell(1,length(I));
			      for j = 1:length(I)
			        tmp{j} = self.(f){I(j)};
			      end
						self.(f) = tmp;
			    end

			  end
			end
			self.num_clips = length(I);
		end



		% TODO implement the num_bins stuff
    function [distr] = compute_obj_distrs(self, num_bins)
    
      distr = struct('bx', [], 'by', [], 'bz', []);
      
      locs = [];
      % TODO get rid of these constants, maybe insert into the data struct
      xlen = 1280;
      ylen = 960;
      
      
      % TODO there is some very similar code in compute_feats, should refactor
      
      
      for k=1:length(self.best_s)
      	%for r = 1:size(data.best_s{k}, 1)
      	% the first 5 are active objects
      	for r = 1:5
      		num_frames = size(self.best_s{k}, 2);
      		for c = 1:num_frames
      		
      			if self.best_s{k}(r,c) > 0
      				% reshape the location from 1x1x4 to 1x4
      				loc = reshape(self.locs{k}(r,c,:), 1,4);
      				
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
      distr.bx = bx / sum(bx);
      distr.by = by / sum(by);
      distr.bz = bz / sum(bz);
		end

	end % end public methods
end
