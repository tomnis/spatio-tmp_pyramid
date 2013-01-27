% given a distribution, generate a random number according to that distribution
% this is used in the generation of biased random cuts
% distr is a probability histogram of observed active object locations
% dividing [0,1] into length(distr) equally sized bins.
classdef RandDistr 
	
	properties (GetAccess='private', SetAccess='private')
		% distribution histogram 
		distr = [1];
		inv_distr = [1];
		psums = [1];
		uniform = 0;
	end

	methods (Access='private')
		% TODO this could probably give more optimal results
		function [inv] = get_inv(self, fn)
			inv = max(fn) - fn  + .25 * std(fn);
			inv = inv / (sum(inv));
		end
	end

	methods
		% constructor
		% distr is active object distribution
		% inverse is whether we should use distr or its inverse
		% using distr is cutting through active object regions
		% inverse is cutting around active object regions
		function self=RandDistr(distr, inverse)
			if length(distr) == 0
				self.uniform = 1;
				% TODO hacky at this point, should probably build a true distr
				return;
			end


			if inverse
				self.distr = self.get_inv(distr);
			else 
				self.distr = distr
			end

			self.psums = cumsum(self.distr);
			% assert distr sums to 1
			assert(abs(self.psums(end) - 1) < .001)
		end




		% get a vector according to the current distribution
		function as = getn(self, n)
			as = zeros(1, n);
			for i=1:n
				as(i) = self.get();
			end
		end




		% get the next number according to the current distribution
		function a=get(self)
			a = rand;
		
			if self.uniform
				return
			end

			% use psums to figure out which bin the result number should come from
			b = 1;
			while self.psums(b) < a
				b = b + 1;
			end

			% then generate a new random number coming from that bin range to return
			low = (b-1) / length(self.distr);
			high = b / length(self.distr);
			% interval [low, high]
			a = low + (high - low)*rand;
		end

	end
end
