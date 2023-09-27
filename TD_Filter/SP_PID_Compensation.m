classdef SP_PID_Compensation < TD_Filter
	% Provides simple Proportional-Integral-Derivative Compensation
	% This model is a direct time-domian implemation which provides
	% basic common numerical operations.
	%   Y(t) = A(1)*X(t) + A(2)*Integral{ X(t) dt } + A(3)*d/dx { X(t) }
	% A 'FD Model' (Struct) containing three fields: 'freq', 'H', 'lag'
	% Note/Warning:
	% Signal X(t) is not detrended failure to ensure zero-mean null signals
	% will be detrimental to integration results.
	properties
		PID;
	end
	methods
		function Obj = SP_PID_Compensation(Name, Desc, PID)
			% Populates filter with relevant data
			Obj.Name = sprintf('(PID) %s', Name);
			Obj.Desc = sprintf('(PID) %s', Desc);
			Obj.PID = PID;
		end
		function [Y, Tp] = process(obj, T, X)
			% Apply Frequency-Domain Model, if present
			if( ~isempty(obj.PID) )
				Y = num.pid_comp(obj.PID, T, X);
			else
				Y = X;
			end
			Tp = T;
		end
	end
end
