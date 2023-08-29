classdef em
% Provides useful routines for Electro-Magnetism
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
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
