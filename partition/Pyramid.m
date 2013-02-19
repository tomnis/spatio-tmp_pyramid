classdef Pyramid

	properties (GetAccess='public', SetAccess='private')
		randrs = [];
		regular = 0;
		num_pyramid_levels = 0;
		num_kdtree_levels = 0;
		kdtree = [];
		perm = [1,2,3];
	end

	methods (Access='private')
		function self = setup_tree(self)
			constraints = [ 0, 1; 0, 1; 0, 1];
			self = self.setup_tree_helper(1, constraints);
		end
		
		

		function self = setup_tree_helper(self, ind, constraints)
			%fprintf(1, '%d: %d\n', ind, self.get_dimension(ind));
			% use the constraints
			% to generate a random number in the appropriate interval
			dim_ind = self.get_dimension(ind) + 1;
			rmin = constraints(dim_ind, 1);
			rmax = constraints(dim_ind, 2);
			
			if self.regular
				r = rmin + (rmax - rmin) / 2;
			% TODO bias the top level here
			elseif self.get_pyramid_level(ind) == 1
				r = rmin + (rmax - rmin) * rand;
			else
				r = rmin + (rmax - rmin) * rand;
			end

			self.kdtree(ind) = r;

			left_child = self.get_left_child_ind(ind);
			if left_child <= length(self.kdtree)
				c_left = zeros(size(constraints)) + constraints;
				c_left(dim_ind, 2) = r;
				self = self.setup_tree_helper(left_child, c_left);
			end
			
			right_child = self.get_right_child_ind(ind);
			if right_child <= length(self.kdtree)
				c_right = zeros(size(constraints)) + constraints;
				c_right(dim_ind, 1) = r;
				self = self.setup_tree_helper(right_child, c_right);
			end
		end



		% compute the histogram for a single level
		function [level_hist] = compute_curlvl_hist(self, feats, level, dim)
			num_regions = 8^level;

			level_hist = zeros(num_regions * dim.num_feat_types, 1);

			for i = 1:length(feats.x)
				region_num = self.bin_level(feats.x(i), feats.y(i), feats.z(i), level);
				assert(region_num >= 0 && region_num < num_regions);

				idx = region_num * dim.num_feat_types + feats.label(i);

				% finally, increment the appropriate position
				level_hist(idx) = level_hist(idx) + 1;
			end
		end
	end % end private methods
	


	methods
		function self = Pyramid(num_levels, randrs, perm)
			assert(num_levels > 0);

			self.randrs = randrs;
			self.regular = length(randrs) == 0;
			self.num_pyramid_levels = num_levels;
			if exist('perm')
				self.perm = perm;
			end

			% levels in the kd tree. need 3 kdtree levels for each pyramid level
			self.num_kdtree_levels = (num_levels - 1) * 3;
			if num_levels == 1
				self.num_kdtree_levels = 0;
			end
			% the 'heap' of cuts
			self.kdtree = zeros(2^self.num_kdtree_levels - 1, 1);
			if num_levels > 1
				self = self.setup_tree();
			end
		end

		

		% compute the histograms for the features of a single clip
		% TODO add a way for the caller to specify which levels should be included in the final
		% histogram
		function hist = compute_hist(self, feats, dim)
			hist = [];

			for level = 0:self.num_pyramid_levels-1
				hist = [hist; self.compute_curlvl_hist(feats, level, dim)];
			end
		end



		function self = apply_partition(self, dim)
			dims = [dim.xlen, dim.ylen, dim.end_frame - dim.start_frame + 1];
			dims = dims(self.perm);
			for level = 0:self.num_kdtree_levels-1
				level_inds = self.get_kdlevel_inds(level);
				self.kdtree(level_inds) = self.kdtree(level_inds) .* dims(mod(level, 3)+1);
			end
		end



		% return the x,y, or z dimension split by the cut at ind
		% return 0, 1, 2
		function [dimension] = get_dimension(self, ind)
			dimension = mod(self.get_kdlevel(ind), 3);
		end

		

		% return the level in the kd-tree that cut lies on
		function [kdlevel] = get_kdlevel(self, ind)
			kdlevel = floor(log2(ind));
		end



		% return the level in the pyramid that kd-tree ind contributes to
		% recall that pyramid levels start counting at 0
		function [pyramid_level] = get_pyramid_level(self, ind)
			pyramid_level = floor(self.get_kdlevel(ind) / 3) + 1;
		end


		% return the region num that the point (dim0, dim1, dim2) lies in
		% pyramid_level is in 0...num_pyramid_levels -1
		function [bin_num] = bin_level(self, dim0, dim1, dim2, pyramid_level)
			assert(pyramid_level >= 0 && pyramid_level < self.num_pyramid_levels);
			node_ind = 1;
			p = [dim0, dim1, dim2];
			p = p(self.perm);
			% how deep we should go in the tree
			depth = 3 * pyramid_level;

			while node_ind <= length(self.kdtree) && depth > 0
				dim_ind = self.get_dimension(node_ind) + 1;
				
				if p(dim_ind) <= self.kdtree(node_ind)
					node_ind = self.get_left_child_ind(node_ind);
				else
					node_ind = self.get_right_child_ind(node_ind);	
				end
				depth = depth -1;
			end
			bin_num = mod(node_ind, 8^pyramid_level);
		end

		

		function [bin_num] = bin(self, dim0, dim1, dim2)
			bin_num = self.bin_level(dim0, dim1, dim2, self.num_pyramid_levels-1);
		end



		% return the index of inds left child	
		function [left_child_ind] = get_left_child_ind(self, ind)
			left_child_ind = 2 * ind;
		end



		% return the index of inds right child
		function [right_child_ind] = get_right_child_ind(self, ind)
			right_child_ind = 2 * ind + 1;
		end
		


		% return the index of inds parent node
		function [parent_ind] = get_parent_ind(self, ind)
			parent_ind = floor(ind / 2);
		end



		% given a kdlevel, return all the indices that make up that level
		function [kdlevel_inds] = get_kdlevel_inds(self, kdlevel)
			kdlevel_inds = [2^kdlevel:2^(kdlevel+1) - 1];
		end
		


		% set all the values at a certain level in the kdtree to data
		function [self] = set_kdlevel_data(self, kdlevel, data)
			self.kdtree(self.get_kdlevel_inds(kdlevel)) = data;
		end
	end	% end public methods
end
