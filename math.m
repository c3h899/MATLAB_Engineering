classdef math
% Provides useful routines and interface tweaks
% Core mathematical operations
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [XYZ] = circ(N,r)
			% Returns the (X,Y,Z) coordinates forming a circumscribed, regular polygon
			% of N-sides and circular radius r. The polygon will be described as a 
			% series of (N + 1) coordinate pairs enclosing the polygon centered at (0,0).
			% Such is expressed as a (N+1)x3 matrix.
			theta_seg = 2*pi/N;
			ii = 0:N; % Redundant point, but allows figure to be closed
			theta = theta_seg.*ii;
			XYZ = zeros(N+1,3);
			XYZ(:,1) = r.*cos(theta);
			XYZ(:,2) = r.*sin(theta);
		end
		function [pts] = logspace(a,b,n)
			% Points = logspace(A, B, N)
			% Wrapper for Logspace, providing linspace's syntax.
			% (N logarithmically spaced points between A and B)
			A_prime = log10(a);
			B_prime = log10(b);
			pts = logspace(A_prime, B_prime, n);
			% Why is this not the default interface?
		end
		function [vals] = logspace_offset(start, stop, num_points, bias)
			% offset_logspace(start, stop, num_points, bias)
			% start  : minimum value in the interval
			% stop   : maximum value in the interval
			% points : number of points in the interval
			% bias   : DC offset applied to bias the range.
			%        : The minimum order of the interval is log10(bias)
			% Provides a crude means for establishing logarithmic intervals
			% which contain 0. This is mathematically impossible; however,
			% this provides a useful contrivance when defining binning intervals.
			% Returns logspace(start + bias, stop + bias, num_points) - bias
			LOG10_CONST = 1/log(10);
			min_order = LOG10_CONST.*log(start + bias);
			max_order = LOG10_CONST.*log(stop + bias);
			vals = logspace(min_order, max_order, num_points) - bias;
				% One can exponentiate linearly spaced points over the log
				% However, rudimentary performance testing showed this slower than 
				% MATLAB's core implementation
			% Tidy Up Results by ensuring the original values are preserved.
			vals(1) = start;
			vals(end) = stop;
		end
		function [XYZ_Prime] = rot3d(XYZ, aX, aY, aZ)
			% https://en.wikipedia.org/wiki/Rotation_matrix
			Rx = [[1 0 0]; [0 cos(aX) -sin(aX)]; [0 sin(aX) cos(aX)]];
			Ry = [[cos(aY) 0 sin(aY)]; [0 1 0]; [-sin(aY) 0 cos(aY)]];
			Rz = [[cos(aZ) -sin(aZ) 0]; [sin(aZ) cos(aZ) 0]; [0 0 1]];
			Rtot = Rx*Ry*Rz;
			% Transform
			XYZ_Prime = zeros(size(XYZ));
			for ii = 1:size(XYZ,1)
				XYZ_Prime(ii,:) = (Rtot*(XYZ(ii,:)'))';
			end
		end
	end
end