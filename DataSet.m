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
		function set_scores(self, frs, best_scores, locations, object_type)
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
			self.num_clips = 55;
		end



		function set_feats(self)
		end



		function sanity_check(self)
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
			% compute the best scoring objects
			set_scores(self, frs, best_scores, locations, object_type);
			% compute the feature vectors
		end
	end

end
