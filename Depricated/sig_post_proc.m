classdef sig_post_proc
	% Signal Processing Details
	% Provides commonly used methods for intial intake of raw measurements
	properties
		Ext_atten_dB; % External attenuation [dB]
		FD_Model; % Frequency-Domain Compensation Model
		Notes; % Additional Remarks
		PID; % [kP, kI, kD] % Proportional, Integral, and Differential
		t0; % Time when signal ceases to be null.
	end
	methods
		function obj = sig_post_proc(Ext_atten_dB, FD_Model, Notes, PID, t0)
			obj.Ext_atten_dB = Ext_atten_dB;
			obj.FD_Model = FD_Model;
			obj.Notes = Notes;
			obj.PID = PID;
			if( ~isempty(t0) )
				obj.t0 = t0;
			else
				obj.t0 = -inf;
			end
		end
		function [Y, Tt] = process(obj, T, X)
			% Zero-Mean Detrending of Signal
			if( obj.t0 ~= -inf )
				Y = num.zm_det(X, T, -inf, obj.t0);
			else
				Y = X; % Ensure Y is populated at this step
			end
			% Compensate for attenuation, if specified
			if( ~isempty(obj.Ext_atten_dB) && (obj.Ext_atten_dB ~= 0) )
				Y = em.comp_atten_dB(obj.Ext_atten_dB, Y, 'V');
			end
			% Apply PID Model, if present
			if( ~isempty(obj.PID) )
				Y = num.pid_comp(obj.PID, T, Y);
			end
			% Apply Frequency-Domain Model, if present
			if( ~isempty(obj.FD_Model) )
				Y = num.apply_fd_comp(obj.FD_Model, T, Y);
			end
			Tt = T(1:length(Y)); % FFT May Truncate last point
		end
	end
end