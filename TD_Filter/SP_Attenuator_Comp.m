classdef SP_Attenuator_Comp < TD_Filter
	% Provides wrapper for comp_atten_dB
	properties
		Atten_dB;
	end
	methods
		function Obj = SP_Attenuator_Comp(Name, Desc, Atten_dB)
			% Populates filter with relevant data
			Obj.Name = sprintf('(Atten) %s', Name);
			Obj.Desc = sprintf('(Atten) %s', Desc);
			Obj.Atten_dB = Atten_dB;
		end
		function [Y, Tp] = process(obj, T, X)
			if(obj.Atten_dB ~= 0)
				Y = em.comp_atten_dB(obj.Atten_dB, X, 'V');
			else
				Y = X;
				%disp('0 dB');
			end
			Tp = T;
		end
	end
end
