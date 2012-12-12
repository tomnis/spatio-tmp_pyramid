% given a distribution, generate a random number according to that distribution
% this is used in the generation of biased random cuts
% distr is a probability histogram of observed active object locations
% dividing [0,1] into length(distr) equally sized bins.
classdef RandDistr 
	
	properties (GetAccess='private', SetAccess='private')
		% distribution histogram 
		distr
		psums
	end

	methods
		% constructor
		function self=RandDistr(varargin)
			self.distr = [1];
			if nargin == 1
				self.distr = varargin{1};
			end
			self.psums = cumsum(self.distr);
			% assert distr sums to 1
			assert(abs(self.psums(end) - 1) < .001)
		end
	
		% get the next number according to the current distribution
		function a=get(self)
			r = rand;
			
			% use psums to figure out which bin the result number should come from
			b = 1;
			while self.psums(b) < r
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
