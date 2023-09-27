classdef SP_Lowpass < TD_Filter
	% Provides wrapper for MATLAB's Lowpass filter
	% Name-value arguments to lowpass may be specified and will be forwaded
	% to the appropriate fuction.
	properties
		F0;
		Varargin;
	end
	methods
		function Obj = SP_Lowpass(Name, Desc, F0, varargin)
			% Populates filter with relevant data
			Obj.Name = sprintf('(Lowpass) %s', Name);
			Obj.Desc = sprintf('(Lowpass) %s', Desc);
			Obj.F0 = F0;
			Obj.Varargin = varargin;
		end
		function [Y, Tp] = process(obj, T, X)
			% Lowpass filter input signal
			Fs = 1/mean(diff(T));
			if( isempty(obj.Varargin) )
				Y = lowpass(X, obj.F0, Fs);
			else
				Y = lowpass(X, obj.F0, Fs, obj.Varargin{:});
			end
			Tp = T;
		end
	end
end
