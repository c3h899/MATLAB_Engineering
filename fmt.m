classdef fmt
% Provides useful routines for formatting in MATLAB
	properties(Constant)
		% Colors
		fig_bg_color = [1 1 1]; % White
		% Fonts
		font = 'CartoGothic Pro Book'; % Font
		font_size_leg = 18; % Legend Font Size
		font_size_ax = 24; % Axis Font Size
		% Lines
		line_width = 2; % Line Width
		marker_size = 8; % Marker Size
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [ret] = auto_axis(y, margin, interval, tollerance)
			% Attempts to Automatically Scale Axis Limits (Single Variable)
			% Provides Rudamentary Outlire Protection
			% margin : (0.15) decimal fraction to exceed minimum and maximum value
			% interval : (0.95) decimal fraction of dataset to contain
			%   *Centered about the median*
			% tollerance : (0.50) decimal fraction describing maximum
			% deviation of dataset from specified interval
			if (nargin < 4)
				tollerance = 0.50;
			end
			if (nargin < 3)
				interval = 0.95;
			end
			if (nargin < 2)
				margin = 0.15;
			end
			% Auto Scale Algorithm
			dat_min = min(y);
			dat_max = max(y);
			% Target Margin
			delta = 2*margin;
			const = 1 - margin;
			% Target Percent of Data to be Captured
			lower_lim = (1 - interval)/2;
			upper_lim = 1 - lower_lim;
			% Empirical CDF
			u = sort(y);
			len_plus = length(u) + 1;
			for ii = length(u):-1:1
				v(ii) = sum(u <= u(ii))./len_plus;
			end
			ecdf_min = u(find((v >= lower_lim),1,'first'));
			ecdf_max = u(find((v <= upper_lim),1,'last'));
			% Padout Tollerance
			errMin = abs((ecdf_min - dat_min)/dat_min);
			errMax = abs((ecdf_max - dat_max)/dat_max);
			% Outlier Mitigation
			if((errMax <= tollerance) || (ecdf_min == ecdf_max) || isnan(errMax))
				uMax = (const + delta*(dat_max > 0))*dat_max;
			else
				uMax = (const + delta*(ecdf_max > 0))*ecdf_max;
			end
			if((errMin <= tollerance) || (ecdf_min == ecdf_max) || isnan(errMin))
				uMin = (const + delta*(dat_min < 0))*dat_min;
			else
				uMin = (const + delta*(ecdf_min < 0))*ecdf_min;
			end
			% Correction for Zero
			if( abs(uMax) < (1E-18) )
				margin_actual = abs((dat_min - uMin)/dat_min);
				uMax = -(margin_actual)*dat_min;
			end
			if( abs(uMin) < (1E-18) )
				margin_actual = abs((dat_max - uMax)/dat_max);
				uMin = -(margin_actual)*dat_max;
			end
			ret = [uMin uMax];
		end
		function [fig] = figure(fig)
		% figure(AX) Formats Current Plot
		%   (Optional) AX Plot Axis
		%   Uses Current Axis if none Specified
		%
		% Formats (Figures) acording to modest standards
		% (Figure)
			% Recursively calls fmt_plot for all axis
			if(nargin < 1)
				fig = gcf; % Use Current Figure, if none Specified
			end
			
			for ii = 1:length(fig)
				fig(ii).Color = fmt.fig_bg_color; % Set Background Color to White
				ax = findobj(fig, 'Type', 'Axes');
				if( ~isempty(ax) )
					fmt.plot(ax);
				end
			end
		end
		function [ax] = plot(ax)
		% plot(AX) Formats Current Plot
		%   (Optional) AX Plot Axis
		%   Uses Current Axis if none Specified
		%
		% Formats (Common Plot Object(s)) acording to modest standards
		% Currently Supports: Axis, Legends, Lines
		%
		% Formatting Applied:
		% (Globally)
		%   Changes Font
		% (Axis)
		%   Ensures Grid is Enabled
		%   Sets Font Size
		%   Unbolds Title
		% (Legends)
		%   Sets Font Size
		% (Lines)
		%   Sets Line Widths
		%   Sets Marker Size
			if(nargin < 1)
				ax = gca; % Use Current Axis, if none Specified
			end
			
			for ii = 1:length(ax)
				% Format Axis
				grid(ax(ii),'on'); % Ensure Grid
				ax(ii).FontName = fmt.font;
				ax(ii).FontSize = fmt.font_size_ax;
				ax(ii).TitleFontWeight = 'normal';

				% Format Legend
				leg = findobj(ax(ii), 'Type', 'Legend');
				if( ~isempty(leg) )
					leg.FontName = fmt.font;
					leg.FontSize = fmt.font_size_leg;
				end

				% Format Lines
				lines = findall(ax(ii),'Type','Line');
				for jj = 1:length(lines)
					lines(jj).LineWidth = fmt.line_width;
					lines(jj).MarkerSize = fmt.marker_size;
				end
			end
		end
		function [str] = prefix_num(Val_in,precission)
		% prefix_num(Val_in, precision)
		% Returns value formatted as string using metric prefixes
		% Val_in : Input Value to be formatted
		% precision : (Optional) argument specifying significance
		% without specification, a default value of 3 significant figures is used.

			%% Support for Variable input precision
			if nargin < 2
				precission = 3;
			end

			%% Decompose into Scientific Notation
			Val_pow = log10(Val_in); % Common Log of Input Value
			Exp = floor(Val_pow); % Extract Base-10 Power
			Exponent = 10.^Exp; % Extract Base-10 Exponent
			Mantissa = Val_in./(Exponent); % Extract Base-10 Mantissa

			%% If Possible Name Prefix
			if(Exp >= 21) % Too Big
				prefix = '';
			elseif(Exp >= 18) % Exa-
				prefix = 'E';
			elseif(Exp >= 15) % Peta-
				prefix = 'P';
			elseif(Exp >= 12) % Tera-
				prefix = 'T';
			elseif(Exp >= 9) % Giga-
				prefix = 'G';
			elseif(Exp >= 6) % Mega-
				prefix = 'M';
			elseif(Exp >= 3) % Kilo-
				prefix = 'k';
			elseif(Exp >= 0) % (Unit)
				prefix = '';
			elseif(Exp >= -3) % milli-
				prefix = 'm';
			elseif(Exp >= -6) % micro-
				prefix = 'u';
			elseif(Exp >= -9) % nano- 
				prefix = 'n';
			elseif(Exp >= -12) % pico- 
				prefix = 'p';
			elseif(Exp >= -15) % femto- 
				prefix = 'f';
			elseif(Exp >= -18) % atto-
				prefix = 'a';
			else % Too Small
				prefix = '';
			end

			if((Exp >= 21) || (Exp < -18))
				% Out-of-defined range
				str = sprintf('%0.2e',Val_in);
			else
				if(Exp >= 0)
					switch(mod(Exp,3))
						case 0
							fmat = sprintf('%%1.%if%%s',precission-1);
							str = sprintf(fmat,Mantissa,prefix);
						case 1
							fmat = sprintf('%%2.%if%%s',precission-2);
							str = sprintf(fmat,Mantissa*10,prefix);
						case 2
							fmat = sprintf('%%3.%if%%s',precission-3);
							str = sprintf(fmat,Mantissa*100,prefix);
					end
				elseif(Exp < 0)
					switch(mod(abs(Exp),3))
						case 0
							fmat = sprintf('%%1.%if%%s',precission-1);
							str = sprintf(fmat,Mantissa,prefix);
						case 1
							fmat = sprintf('%%3.%if%%s',precission-3);
							str = sprintf(fmat,Mantissa*100,prefix);
						case 2
							fmat = sprintf('%%2.%if%%s',precission-2);
							str = sprintf(fmat,Mantissa*10,prefix);
					end
				end
			end
		end
		function [caption] = sig_fig(Val_In,Nsig)
		% sig_fig(Val_in, Nsig)
		% Returns cell array of value(s) formatted as string using metric prefixes
		% Val_in : Input Value(s) to be formatted
		% Nsig : (Optional) argument specifying number of significant figures
		% without specification, a default value of 3 significant figures is used.

			%% Support for Variable input precision
			if nargin < 2
				precission = 3;
			end
			
			% Resolve Exponent from FP Number
			Exp = floor(log10(abs(Val_In))); % (Order of) Most Significant Digit
			% Symmetric Half-Up Rounding
			Nshift = Exp + 1 - Nsig; % Base-10 Bias Shift
			A_star_abs = fix((abs(Val_In.*10.^(-Nshift)) + 0.5));
			A_round_abs = A_star_abs.*(10.^Nshift);
			% Resolve Mantissa from FP Number
			Mant_Abs = A_round_abs.*10.^(-Exp);
			% Formatting Considerations
			A_align = 3*floor((1/3).*Exp);
			Common_Base = ones(size(Val_In)).*max(A_align);
			Exp_Diff = Exp - Common_Base; % Exponent of Mantissa Reflected in Float
				% Exp_Diff + 1 = Number of Digits Before the Decimal
			Mant_Abs_Float = Mant_Abs.*(10.^Exp_Diff); % Floating Point Value to be accompanied by a common base
			% Absolute Length Maximums
			Max_Before_Dec = max(Exp) - Common_Base(1);
			Max_After_Dec = Nsig - (min(Exp) - Common_Base(1) + 1);
			% Auto Sign Char Compensation
			ws_char = 32;
			if(min(Val_In) < 0)
				char_neg = '-';
				char_pos = ws_char;
			else
				char_neg = '-'; % error case
				char_pos = '';
			end	
			% Iterate through list
			caption = cell(length(Val_In),1);
			for ii = 1:length(Val_In)
				int_dig = Exp_Diff(ii) + 1; % Number of Digits Before the Decimal
				% Correct for Sign
				if(Val_In(ii) < 0)
					sign_char = char_neg;
				else
					sign_char = char_pos;
				end
				
				% Leading character count
				if(Mant_Abs_Float(ii) < 1.0)
					leading_char = Max_Before_Dec;
				else
					leading_char = Max_Before_Dec - int_dig + 1;	
				end
				% Significant digit pain
				if( int_dig < Nsig )
					%leading_sig = (int_dig);
					trailing_sig = (Nsig - int_dig);
					trailing_char = Max_After_Dec - trailing_sig;
					fmt_code = sprintf('%s%c%%#%i.%if%s%%s\n', repelem(ws_char, leading_char), ...
						sign_char, int_dig, trailing_sig, repelem(ws_char, trailing_char));
				elseif(int_dig == Nsig)
					fmt_code = sprintf('%s%c%%#%i.0f%s%%s\n', ...
						repelem(ws_char, leading_char), sign_char, Max_Before_Dec, ...
						repelem(ws_char, Max_After_Dec));
				else
					if( mod(floor(Mant_Abs_Float(ii)),10) ~= 0 )
						fmt_code = sprintf('%c%c%%%i.0f%s%%s\n', ws_char, ...
							sign_char, Max_Before_Dec, repelem(ws_char, Max_After_Dec));
					else
						% Screwey Edge Case
						Mant_Abs_Float(ii) = Mant_Abs_Float(ii)/10;
						Common_Base(ii) = Common_Base(ii) + 1;
						num_dec = min(1, Nsig - 1);
						fmt_code = sprintf('%s%c%%#%i.%if%s%%s\n', ...
							repelem(ws_char, leading_char),	sign_char, ...
							Max_Before_Dec, num_dec, repelem(ws_char, Max_After_Dec + (1 - num_dec)));
					end
				end
				exp_str = sprintf('\\times10^{%i}', Common_Base(ii));
				%exp_str = sprintf('E%i', Common_Base(ii));
				caption{ii} = sprintf(fmt_code, Mant_Abs_Float(ii), exp_str);
			end

		end
		function [ret] = tight_axis(x)
			ret = [min(x) max(x)];
		end
	end
end
