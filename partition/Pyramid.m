
classdef Pyramid

	properties (GetAccess='public', SetAccess='private')
		kdtree = [];
		num_kdtree_levels = 0;
	end

	methods (Access='private')
	end

	methods
		function self = Pyramid(num_levels, randrs)
			% levels in the kd tree. need 3 kdtree levels for each pyramid level
			self.num_kdtree_levels = (num_levels - 1) * 3;
			% the 'heap' of cuts
			self.kdtree = zeros(2^self.num_kdtree_levels - 1, 1);
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

		% return the region num that the point (x,y,z) lies in
		function [bin_num] = bin(x,y,z)
			bin_num = 0;
			node_ind = 1;
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
