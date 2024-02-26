classdef SP_FD_Compensation < TD_Filter
	% Provides a Frequency-Domain Compensation Function (H) using FFT
	% This model is provided a time-domain signal and computes the tranform
	% into-, and out of- the frequency domain. For cascades of filters one
	% is recommended to pre-compute the cumulative effect or use a different
	% implementation for computational efficiency.
	% A discrete FD Model is provided and the reponse is computed as:
	%   Y(t) = IFFT{ H * FFT{ X(t) } }
	% A 'FD Model' (Struct) containing three fields: 'freq', 'H', 'lag'
	% is inputed where:
	%   'freq' is a double-sided freqeuncy vector
	%   'H' is the (frequency domain) compensation function
	%   'lag' is the timeshift [in seconds] needed to re-nomalized time
	properties
		FD_Model;
	end
	methods
		function Obj = SP_FD_Compensation(Name, Desc, FD_Model)
			% Populates filter with relevant data
			Obj.Name = sprintf('(FD) %s', Name);
			Obj.Desc = sprintf('(FD) %s', Desc);
			Obj.FD_Model = FD_Model;
		end
		function [Y, Tp] = process(obj, T, X)
			% Apply Frequency-Domain Model, if present
			if( ~isempty(obj.FD_Model) )
				Y = num.apply_fd_comp(obj.FD_Model, T, X);
				if( any(isnan(Y)) )
					% error('SP_FD_Compensation: FD Model Failed to Apply');
					warning('SP_FD_Compensation: "%s" Model Failed; Reverting Signal', ...
						obj.Name);
					Y = X;
				end
			else
				warning('SP_FD_Compensation: No Model Provided');
			end
			Tp = T(1:length(Y)); % FFT May Truncate last point
		end
	end
end
