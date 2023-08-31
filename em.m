classdef em
% Provides useful routines for Electro-Magnetism
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [] = Bode(F, FT, Mag_Ax, Phase_Ax, varargin)
			% Plots a single-sided spectrum using typical Bode-plot style
			% If negative frequencies are not specified, the spectrum is
			% extend assuming a real-valued signal.
			% X-Axis is logarithmic
			% Magnitude plots in dB (assuming Voltage Ratios)
			% Phase plots in degrees
			% Additional arguments are forwarded to the plotting command
			Fv = reshape(F,[],1);
			Xv = reshape(FT, length(Fv), []);
			% Sort and Ensure completeness of spectrum
			Dat = sortrows([Fv, Xv]);
			F_plt = Dat(:,1);
			X_plt = Dat(:,2);
			if(Dat(1,1) >= 0)
				[X_plt, F_plt] = num.ds_freq_ext(X_plt, F_plt); %#ok<ASGLU> 
			end
			new_plot = ((nargin < 3) || isempty(Mag_Ax));
			if(new_plot)
				Fig = figure();
				Mag_Ax = subplot(2,1,1);
				Phase_Ax = subplot(2,1,2);
			end
			rad2deg = 180/pi;
			semilogx(Mag_Ax, Dat(:,1), 20.*log10(abs(Dat(:,2))), varargin{:}); hold on;
			semilogx(Phase_Ax, Dat(:,1), rad2deg.*(angle(Dat(:,2))), varargin{:}); hold on;
				% UNWRAP
			if(new_plot)
				ylabel(Mag_Ax, 'Magnitude / dB');
				ylabel(Phase_Ax, 'Phase / Deg');
				xlabel(Phase_Ax, 'Frequency / Unspecified');
			end
		end
		function [V_comp] = comp_atten_dB(atten, V, varargin)
			% Scales voltage according to the (inverse) of the extrnal attenuation
			% Attenuation is expressed in dB (W/W);
			% e.g. A 10 dB attnuator would be specified as (+) 10
			% Alternatively, external gain would be specified as (-) gain [dB]
			% (Default) 'V' compensation assumes input is votage
			% 'W' compensation assumes input is power
			if(nargin > 2)
				if( strcmp(varargin{1}, "W") )
					lin_gain = 10.^(atten/10);
				else
					lin_gain = 10.^(atten/20);
				end
			else
				lin_gain = 10.^(atten/20);
			end
			V_comp = lin_gain.*V;
		end
		function [alpha, beta] = skin_depth_gamma(freq, sigma, mu_r, epsilon_r)
			% Electromagnetic Fields and Waves - Iskander (p.299)
			ep = const.epsilon0.*epsilon_r;
			mu = const.mu0*mu_r;
			omega = (2*pi).*freq;
			k1 = omega.*sqrt(mu*ep/2);
			arg = sqrt(1 + (sigma./(omega.*ep)).^2);
			alpha = k1.*sqrt(arg - 1); % [Np/m]
			beta = k1.*sqrt(arg + 1); % [rad/m]
		end
	end
end
