classdef em
% Provides useful routines for Electro-Magnetism
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [f_3dB, gain, slope] = bi_linear_hf_fit(f, H, f_min, f1, f2, f_max, varargin)
			% Performs a biliear fit of magnitude of H to inference a 3dB point
			% (f_min, f1) is taken as the transition band.
			% (fs, f_max) is taken as the ~flat passband
			N = 1;
			% Stop Band
			stop = (f > f_min) & (f < f1);
			H_stop = 20.*log10(abs(H(stop)));
			P1_stop = polyfit(log10(f(stop)), H_stop, 1);
			% Pass Band
			pass = (f > f2) & (f < f_max);
			H_pass = 20.*log10(abs(H(pass)));
			P1_pass = polyfit(log10(f(pass)), H_pass, 1);
			% Intersection
			if( P1_pass(1) == P1_stop(1) )
				if( P1_pass(2) == P1_stop(2) )
					error('bi_linear_hf_fit: Lines are the same.');
				else
					error('bi_linear_hf_fit: Lines are parallel');
				end
			else
				% m1*x + b1 = m2*x + b2; m2 ~ 0
				% m1*x = m2*x + (b2 - b1)
				% (m1 - m2)*x = (b2 - b1)
				log_f_3dB = (P1_stop(2) - P1_pass(2))/(P1_pass(1) - P1_stop(1));
				f_3dB = 10^log_f_3dB;
			end
			%gain = 10^(P1_pass(2)/20);
			g1 = polyval(P1_stop, log_f_3dB);
			g2 = polyval(P1_pass, log_f_3dB);
			gain = mean([g1, g2]);
			slope = P1_stop(1);
			% Validation
			if( (nargin > 6) && any(varargin{1}) )
				f_pos = f(f >= 0); % Strictly 'non-negative' ...
				log_f = log10(f_pos);
				leg_3db = sprintf('F 3dB: %0.3g Hz', f_3dB);
				leg_stop = sprintf('Stop Band: %0.3g dB/dec', slope);
				leg_pass = sprintf('Pass Band: %0.3g dB', gain);
				figure();
				semilogx(f, 20.*log10(abs(H)), '-k', 'DisplayName', 'Input');
				hold on;
				semilogx(f_pos, polyval(P1_stop, log_f), '-r', 'DisplayName', leg_stop); % 'Stop Band'
				semilogx(f_pos, polyval(P1_pass, log_f), '-b', 'DisplayName', leg_pass); % 'Pass Band'
				semilogx(f_3dB.*[1  1], [g1, g2], '^g', 'DisplayName', leg_3db); % 'F 3dB'
				xlabel('Frequency / Hz');
				ylabel('Magnitude / dB');
				xlim([min(f_pos), max(f_pos)]);
				legend;
				title('Bilinear fit of input data.');
			end
		end
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
			idx = (1:length(Fv))';
			Dat = sortrows([Fv, idx]); % Breaks with Complex inputs
			F_plt = Dat(:,1);
			X_plt = Xv(idx);
			if(F_plt(1) >= 0)
				[X_plt, F_plt] = num.ds_freq_ext(X_plt, F_plt); %#ok<ASGLU> 
			end
			new_plot = ((nargin < 3) || isempty(Mag_Ax));
			if(new_plot)
				Fig = figure();
				Mag_Ax = subplot(2,1,1);
				Phase_Ax = subplot(2,1,2);
			end
			rad2deg = 180/pi;
			semilogx(Mag_Ax, F_plt, 20.*log10(abs(X_plt)), varargin{:}); hold on;
			th = angle(X_plt);
			%th = atan(imag(X_plt)./real(X_plt));
			semilogx(Phase_Ax, F_plt, rad2deg.*(th), varargin{:}); hold on;
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
