classdef plt
% Provides useful routines for potting in MATLAB
	properties(Constant)
	end
	methods(Static = true)
		function [ax] = point(P2, opts)
			% ax = point(P2, line_spec)
			% P2 - Position vector
			%    + P3(1) is taken as X
			%    + P3(2) is taken as Y
			% line_spec - Line specififcations to be forwarded to plot
			%    + Be sure to specify use of a marker, e.g. '.'
			% AX - Axis handle created by plot
			% Provides simple macro to expand input vector,
			% assumes points share (common row index) when ambiguous.
			sz = size(P2);
			if(sz(2) == 2) % Default / Row Vector Case
				ax = plot(P2(:,1), P2(:,2), opts);
			elseif(sz(1) == 2)
				ax = plot(P2(1,:), P2(2,:), opts);
			else
				% Pass
			end
		end
		function [ax] = point3(P3, opts)
			% ax = point3(P3, line_spec)
			% P3 - Position vector
			%    + P3(1) is taken as X
			%    + P3(2) is taken as Y
			%    + P3(3) is taken as Z
			% line_spec - Line specififcations to be forwarded to plot3
			%    + Be sure to specify use of a marker, e.g. '.'
			% AX - Axis handle created by plot3
			% Provides simple macro to expand input vector,
			% assumes points share (common row index) when ambiguous.
			sz = size(P3);
			if(sz(2) == 3) % Default / Row Vector Case
				ax = plot3(P3(:,1), P3(:,2), P3(:,3), opts);
			elseif(sz(1) == 3)
				ax = plot3(P3(1,:), P3(2,:), P3(3,:), opts);
			else
				% Pass
			end
		end
	end
	methods(Access = private, Static = true)
	end
end