classdef SP_ZM_Det < TD_Filter
	% Provides zero-mean detrending of input signals
	% Certain models (especially integration models) benefit significantly
	% from being detrended such that the average of the signal noise is
	% zero-mean. This is implemented as the subtraction of the mean of the
	% head of an input signal. Average is taken over the interval t0, t1.
	% ---
	% Note:
	% Signal X(t) is detrended; this is beneficial to integration results.
	properties
		t0;
		t1;
	end
	methods
		function Obj = SP_ZM_Det(Name, Desc, t0, t1)
			% Populates filter with relevant data
			Obj.Name = sprintf('(ZM.Det) %s', Name);
			Obj.Desc = sprintf('(ZM.Det) %s', Desc);
			Obj.t0 = t0;
			Obj.t1 = t1;
		end
		function [Y, Tp] = process(obj, T, X)
			% Detrend the Input Signal
			[Y, ~] = num.zm_det(X, T, obj.t0, obj.t1);
			Tp = T;
		end
	end
end
