
classdef Pyramid

	properties (GetAccess='public', SetAccess='private')
		randrs = [];
		regular = 0;
		num_pyramid_levels = 0;
		num_kdtree_levels = 0;
		kdtree = [];
	end

	methods (Access='private')
		function self = setup_tree_helper(self, ind, constraints)
			%fprintf(1, '%d: %d\n', ind, self.get_dimension(ind));
			% use the constraints
			% to generate a random number in the appropriate interval
			dim_ind = self.get_dimension(ind) + 1;
			rmin = constraints(dim_ind, 1);
			rmax = constraints(dim_ind, 2);
			
			if self.regular
				r = rmin + (rmax - rmin) / 2;
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
	end

	
	methods
		function self = Pyramid(num_levels, randrs)
			self.randrs = randrs;
			self.regular = length(randrs) == 0;

			self.num_pyramid_levels = num_levels;

			% levels in the kd tree. need 3 kdtree levels for each pyramid level
			self.num_kdtree_levels = (num_levels - 1) * 3;
			% the 'heap' of cuts
			self.kdtree = zeros(2^self.num_kdtree_levels - 1, 1);

			self = self.setup_tree();
		end
	
		
		function self = setup_tree(self)
			constraints = [ 0, 1; 0, 1; 0, 1];
			self = self.setup_tree_helper(1, constraints);
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

		% return the region num that the point (dim0, dim1, dim2) lies in
		function [bin_num] = bin(self, dim0, dim1, dim2)
			node_ind = 1;

			p = [dim0, dim1, dim2];

			while node_ind <= length(self.kdtree)
				dim_ind = self.get_dimension(node_ind) + 1;
				
				if p(dim_ind) <= self.kdtree(node_ind)
					node_ind = self.get_left_child_ind(node_ind);
				else
					node_ind = self.get_right_child_ind(node_ind);	
				end
			end
			bin_num = mod(node_ind, length(self.kdtree) + 1);
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

		% return the data stored at inds left child
		function [left_child_data] = get_left_child_data(self, ind)
			left_child_data = self.kdtree(get_left_child_ind(ind));
		end
		
		% return the data stored at inds right child
		function [right_child_data] = get_right_child_data(self, ind)
			right_child_data = self.kdtree(get_right_child_ind(ind));
		end
		
		% return the data stored at inds parent child
		function [parent_child_data] = get_parent_data(self, ind)
			parent_child_data = self.kdtree(get_parent_ind(ind));
		end

		% modify the root of the tree
		function [self] = set_root(self, data)
			self.kdtree(1) = data;
		end

		% set data to be the left child of ind
		function [self] = set_left_child(self, ind, data)
			self.kdtree(get_left_child_ind(ind)) = data;
		end

		% set data to be the right child of ind
		function [self] = set_right_child(self, ind, data)
			self.kdtree(get_right_child_ind(ind)) = data;
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
