classdef SP_Delay < TD_Filter
	% Provides a Time Shift Function using offset of the T Axis
	% This Model preserves samples, and monotonic ordering data
	% Correspondence between time axis of multiple records is not guarenteed
	properties
		Delay;
	end
	methods
		function Obj = SP_Delay(Name, Desc, Delay)
			% Populates filter with relevant data
			Obj.Name = sprintf('(Delay) %s', Name);
			Obj.Desc = sprintf('(Delay) %s', Desc);
			Obj.Delay = Delay;
		end
		function [Y, Tp] = process(obj, T, X)
			% Apply Time Delay
			if( ~isempty(obj.Delay) )
				Tp = T - obj.Delay;
				if( any(isnan(Tp)) )
					error('SP_Delay: Time Shift Failed to Apply');
					warning('SP_Delay: Time Shift Failed; Reverting');
					Tp = T;
				end
			else
				warning('SP_Delay: No Delay Specified');
			end
			Y = X;
		end
	end
end
