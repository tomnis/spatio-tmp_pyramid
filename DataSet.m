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




		% return a subset of self
		function self = sub(self, I, D)
			if ~exist('D')
  			D = 1;
			end
			
			if ~isempty(self),
			  n = properties(self);
			  for i = 1:length(n),
			    f = n{i};

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
			valid_labels = [1 2 3 4 5 6 9 10 12 13 14 15 17 20 22 23 24 27];
			f1 = find(ismember(self.label, valid_labels));
			self = sub(self, f1, 2);
			labels = unique(self.label);
			n_label = length(labels);
			%% mapping the action labels to a new label set.
			map1(labels+1) = [1:n_label]; 
			self.label = map1(self.label+1);
		end




		% given a partition, compute the resulting feature histograms for each clip
		function hists=compute_histograms(self, partition, dim)
			dim.num_feat_types = size(self.best_s{1}, 1)
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
	
	end
end
