classdef Tpyramid
	properties (GetAccess='public', SetAccess='private')
		ltcuts = [];
		rtcuts = [];
		num_cuts = 0;
		protate = 0;
		regular = 0;
		randr;
		cut_eqs = [];
	end

	methods (Access='private')
		function self = setup_cuts(self)
			% TODO handle the regular case here
			self.ltcuts = zeros(self.num_cuts, 1);
			self.rtcuts = zeros(self.num_cuts, 1);
			
			for i=1:self.num_cuts
				self.ltcuts(i) = self.randr.get();
				% do rotation here if necessary
				if rand <= self.protate
					self.rtcuts(i) = self.randr.get();
				else
					self.rtcuts(i) = self.ltcuts(i);
				end
			end
		end
	end % end private methods

	methods (Access='public')
		function self = Tpyramid(randr, num_cuts, protate)
			self.num_cuts = num_cuts;
			self.randr = randr;
			self.protate = protate;
			self.regular = length(randr) == 0;
			self = self.setup_cuts();
		end

		function histogram = compute_hist(self, feats, dim)

			num_regions = 2^self.num_cuts;
			
			histogram = zeros(num_regions * (dim.num_feat_types + 1), 1);

			for i=1:length(feats.x)
				f = [feats.x(i), feats.y(i), feats.z(i)];
				region_num = bin(f, self.cut_eqs, dim, 1);
				idx = region_num * dim.num_feat_types + feats.label(i);
				histogram(idx) = histogram(idx) + 1;
			end
		end

		function self = apply_partition(self, dim)
			% TODO hard coded to zlen now but change later
			zlen = dim.end_frame - dim.start_frame + 1;
			appltcuts = self.ltcuts .* zlen;
			apprtcuts = self.rtcuts .* zlen;

			for i=1:length(self.ltcuts)
				zcut = [dim.start_frame dim.start_frame 0] + [appltcuts(i) apprtcuts(i) 0];
				[p1 p2 p3] = get_points(zcut, dim.xlen, dim.ylen, dim.start_frame, dim.end_frame);
				self.cut_eqs = [self.cut_eqs; get_plane_eq(p1, p2, p3)];
			end
		end
	end % end public methods
end
