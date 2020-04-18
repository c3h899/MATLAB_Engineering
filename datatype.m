classdef datatype
% Provides useful routines for type conversion
% MATLAB, being an autotyped language, sometimes needs "hints"
	methods(Static = true) % Element-Wise Processing
		function [dp] = double(val)
			if isa(val,'double') % Greedy Test
				dp = val;
			elseif isnumeric(val)
				dp = double(val);
			else
				dp = str2double(val);
			end
		end
		function [sp] = single(val)
			if isa(val,'single') % Greedy Test
				dp = val;
			elseif isnumeric(val)
				dp = single(val);
			else
				dp = single(str2double(val));
			end
		end
	end
end