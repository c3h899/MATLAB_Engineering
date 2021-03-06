classdef circ
% Provides useful routines for circuit design and reallization
% Provides component selection based on nearest standard values
    properties
	end
	methods(Access = private, Static = true)
		function [Ret] = IEC60063(Value,E,mode)
			% IEC60063(Value,E,mode) Returns nearest IEC60063 value
			% Value: Input for comparison; expect a value in the range [1.0, 10.0)
			% E: IEC table to compare against; supports: 192, 96, 48, 24, 12, 6, 3
			% mode: Comparison mode for choosing value to return
			%	-2 : Returns nearest value below supplied input
			%	-1 : Returns nearest value at or below supplied input
			%	 0 : Returns value whose error is minimized
			%	 1 : Returns nearest value at or above supplied input
			%	 2 : Returns nearest value above supplied input

			%% Inter-value Spacing
			% First Interval will have 3 values, all subsequent intervals will have 2.
			search_interval = [64, 32, 16, 8, 4, 2, 1];
			len_step = 7; % length(search_interval);

			%% Look-up Tables
			if(E == 192) % E192
				step = 1;
				sorted = [1.00, 1.01, 1.02, 1.04, 1.05, 1.06, 1.07, 1.09, 1.10, 1.11,...
					1.13, 1.14, 1.15, 1.17, 1.18, 1.20, 1.21, 1.23, 1.24, 1.26, 1.27, 1.29,...
					1.30, 1.32, 1.33, 1.35, 1.37, 1.38, 1.40, 1.42, 1.43, 1.45, 1.47, 1.49,...
					1.50, 1.52, 1.54, 1.56, 1.58, 1.60, 1.62, 1.64, 1.65, 1.67, 1.69, 1.72,...
					1.74, 1.76, 1.78, 1.80, 1.82, 1.84, 1.87, 1.89, 1.91, 1.93, 1.96, 1.98,...
					2.00, 2.03, 2.05, 2.08, 2.10, 2.13, 2.15, 2.18, 2.21, 2.23, 2.26, 2.29,...
					2.32, 2.34, 2.37, 2.40, 2.43, 2.46, 2.49, 2.52, 2.55, 2.58, 2.61, 2.64,...
					2.67, 2.71, 2.74, 2.77, 2.80, 2.84, 2.87, 2.91, 2.94, 2.98, 3.01, 3.05,...
					3.09, 3.12, 3.16, 3.20, 3.24, 3.28, 3.32, 3.36, 3.40, 3.44, 3.48, 3.52,...
					3.57, 3.61, 3.65, 3.70, 3.74, 3.79, 3.83, 3.88, 3.92, 3.97, 4.02, 4.07,...
					4.12, 4.17, 4.22, 4.27, 4.32, 4.37, 4.42, 4.48, 4.53, 4.59, 4.64, 4.70,...
					4.75, 4.81, 4.87, 4.93, 4.99, 5.05, 5.11, 5.17, 5.23, 5.30, 5.36, 5.42,...
					5.49, 5.56, 5.62, 5.69, 5.76, 5.83, 5.90, 5.97, 6.04, 6.12, 6.19, 6.26,...
					6.34, 6.42, 6.49, 6.57, 6.65, 6.73, 6.81, 6.90, 6.98, 7.06, 7.15, 7.23,...
					7.32, 7.41, 7.50, 7.59, 7.68, 7.77, 7.87, 7.96, 8.06, 8.16, 8.25, 8.35,...
					8.45, 8.56, 8.66, 8.76, 8.87, 8.98, 9.09, 9.20, 9.31, 9.42, 9.53, 9.65,...
					9.76, 9.88];
				len_sort = 192;
			elseif(E == 96) % E96
				step = 2;
				sorted = [1.00, 1.02, 1.05, 1.07, 1.10, 1.13, 1.15, 1.18, 1.21, 1.24,...
					1.27, 1.30, 1.33, 1.37, 1.40, 1.43, 1.47, 1.50, 1.54, 1.58, 1.62, 1.65,...
					1.69, 1.74, 1.78, 1.82, 1.87, 1.91, 1.96, 2.00, 2.05, 2.10, 2.15, 2.21,...
					2.26, 2.32, 2.37, 2.43, 2.49, 2.55, 2.61, 2.67, 2.74, 2.80, 2.87, 2.94,...
					3.01, 3.09, 3.16, 3.24, 3.32, 3.40, 3.48, 3.57, 3.65, 3.74, 3.83, 3.92,...
					4.02, 4.12, 4.22, 4.32, 4.42, 4.53, 4.64, 4.75, 4.87, 4.99, 5.11, 5.23,...
					5.36, 5.49, 5.62, 5.76, 5.90, 6.04, 6.19, 6.34, 6.49, 6.65, 6.81, 6.98,...
					7.15, 7.32, 7.50, 7.68, 7.87, 8.06, 8.25, 8.45, 8.66, 8.87, 9.09, 9.31,...
					9.53, 9.76];
				len_sort = 96;
			elseif(E == 48) % E48
				step = 3;
				sorted = [1.00, 1.05, 1.10, 1.15, 1.21, 1.27, 1.33, 1.40, 1.47, 1.54,...
					1.62, 1.69, 1.78, 1.87, 1.96, 2.05, 2.15, 2.26, 2.37, 2.49, 2.61, 2.74,...
					2.87, 3.01, 3.16, 3.32, 3.48, 3.65, 3.83, 4.02, 4.22, 4.42, 4.64, 4.87,...
					5.11, 5.36, 5.62, 5.90, 6.19, 6.49, 6.81, 7.15, 7.50, 7.87, 8.25, 8.66,...
					9.09, 9.53];
				len_sort = 48;
			elseif(E == 24) % E24
				step = 4;
				sorted = [1.0, 1.1, 1.2, 1.3, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.7, 3.0,...
					3.3, 3.6, 3.9, 4.3, 4.7, 5.1, 5.6, 6.2, 6.8, 7.5, 8.2, 9.1];
				len_sort = 24;
			elseif(E == 12) % E12
				step = 5;
				sorted = [1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2];
				len_sort = 12;
			elseif(E == 6) % E6
				step = 6;
				sorted = [1.0, 1.5, 2.2, 3.3, 4.7, 6.8];
				len_sort = 6;
			else % E3
				step = 7;
				sorted = [1.0, 2.2, 4.7];
				len_sort = 3;
			end

			%% Search
			[~,ii] = find(sorted <= Value, 1, 'last' );

			%% Extended Selection Functionality
			switch(mode)
				case -2 % Nearest Value Below
					if(sorted(ii) == Value)
						if(ii >= 2)
							Ret = sorted(ii-1); % Typical Previous Value Case
						else
							Ret = sorted(len_sort)/10; % Wrap Around Case
						end
					else
						Ret = sorted(ii); % Result is Less than Value
					end
				case -1 % Nearest Value at-or Below
					if(sorted(ii) <= Value)
						Ret = sorted(ii); % Result is Less than or Equivalent to Value
					else
						if(ii >= 2)
							Ret = sorted(ii-1); % Typical Previous Value Case
						else
							Ret = sorted(len_sort)/10; % Wrap Around Case
						end
					end
				case 0 % Minimization of Error
					% Nearest Value
					Err_At = abs((Value - sorted(ii))./Value); % Error, At or Below target
					% Nearest Value Below
					if( ii >= 2 )
						jj = sorted(ii - 1); % General Next Value Case
					else
						jj = sorted(len_sort)/10; % Wrap Around Case
					end
					Err_Below = abs((Value - jj)./Value); % Error, Below target
					% Nearest Value Above
					if( ii <= (len_sort-1) )
						kk = sorted(ii + 1); % General Next Value Case
					else
						kk = sorted(1)*10; % Wrap Around Case
					end
					Err_High = abs((Value - kk)./Value); % Error, Above target
					% Down selection of edges
					if(Err_Below <= Err_High)
						cmp = jj;
						cmp_err = Err_Below;
					else
						cmp = kk;
						cmp_err = Err_High;
					end
					% Comparison of edge and (nearest point below)
					if(Err_At <= cmp_err)
						Ret = sorted(ii);
					else
						Ret = cmp;
					end
				case 1 % Nearest Value at-or Above
					if(sorted(ii) >= Value)
						Ret = sorted(ii);
					else
						if( ii <= (len_sort-1) )
							Ret = sorted(ii+1); % General Next Value Case
						else
							Ret = sorted(1)*10; % Wrap Around Case
						end
					end
				case 2 % Nearest Value Above
					if(sorted(ii) > Value)
						Ret = sorted(ii);
					else
						if( ii <= (len_sort-1) )
							Ret = sorted(ii+1); % General Next Value Case
						else
							Ret = sorted(1)*10; % Wrap Around Case
						end
					end
			end
		end
		function [Mant, Exp] = sci_notation(Val_in)
			%% Decompose into Scientific Notation
			Val_pow = log10(Val_in); % Common Log of Input Value
			Exp = 10.^floor(Val_pow); % Extract Base-10 Exponent
			Mant = Val_in./(Exp); % Extract Base-10 Mantissa
		end
	end
	methods(Static = true)
		function [Return, Error] = C(Val_in,E,mode)
			% C(Val_in, E, mode)
			% Returns nearest capacitor value based on specified seletion rules.
			% Val_in : Input for which a corresponding value should be chosen.
			% E : (Optional) IEC table to compare against.
			%	Supports: 192, 96, 48, 24, 12, 6, 3 (IEC60063)
			%	Defaults to 12
			% mode : (Optional) Comparison mode for choosing value to return
			%	-2 : Returns nearest value below supplied input
			%	-1 : Returns nearest value at or below supplied input
			%	 0 : Returns value whose error is minimized
			%	 1 : Returns nearest value at or above supplied input
			%	 2 : Returns nearest value above supplied input
			%	Defaults to 1

			%% Support for Variable input precision
			if nargin < 2
				E = 12;
			end
			if nargin < 3
				mode = 1;
			end

			%% Decompose into Scientific Notation
			[Mantissa, Exponent] = circ.sci_notation(Val_in);

			%% Map to Common Values
			Comm = circ.IEC60063(Mantissa,E,mode);

			%% Construct Resulting Resistor Value
			Return = Comm.*Exponent;
			Error = abs((Val_in - Return)/Val_in);
		end
		function [Return, Error] = L(Val_in,E,mode)
			% L(Val_in, E, mode)
			% Returns nearest inductor value based on specified seletion rules.
			% Val_in : Input for which a corresponding value should be chosen.
			% E : (Optional) IEC table to compare against.
			%	Supports: 192, 96, 48, 24, 12, 6, 3 (IEC60063)
			%	Defaults to 24
			% mode : (Optional) Comparison mode for choosing value to return
			%	-2 : Returns nearest value below supplied input
			%	-1 : Returns nearest value at or below supplied input
			%	 0 : Returns value whose error is minimized
			%	 1 : Returns nearest value at or above supplied input
			%	 2 : Returns nearest value above supplied input
			%   Defaults to 1

			%% Support for Variable input precision
			if nargin < 2
				E = 24;
			end
			if nargin < 3
				mode = 1;
			end

			%% Decompose into Scientific Notation
			[Mantissa, Exponent] = circ.sci_notation(Val_in);

			%% Map to Common Values
			Comm = circ.IEC60063(Mantissa,E,mode);

			%% Construct Resulting Resistor Value
			Return = Comm.*Exponent;
			Error = abs((Val_in - Return)/Val_in);
		end
		function [ret] = Pot_Divider(Rpot, Vsource, Vlow, Vhigh)
			% pot_divider(Rpot, Vsource, Vlow, Vhigh)
			% Design for trim pot ladder ( [Vsource] -- [R1] -- [Pot] -- [R2] -- [Gnd] )
			% Returns [R1, R2, Vlow, Vhigh]
			% Rpot : Potentiometer Resistance Rating
			% Vsource : Voltage applied to the top of the ladder
			% Vlow : Desired minimum voltage at minimum of potentiometer range
			% Vhigh : Desired maximum voltage at maximum of potentiometer range

			%% Design Parameters
			% Principle Design Calculation
			A = [[1, (1 - Vsource/Vlow)]; [1, (1 - Vsource/Vhigh)]];
			B = [-Rpot; (Vsource/Vhigh - 1)*Rpot];
			R = A\B;
			% Component Matching
			R1 = [circ.R(R(1), 24, -1), circ.R(R(1), 24, 1)];
			R3 = [circ.R(R(2), 24, -1), circ.R(R(2), 24, 1)];

			%% Boundary Point Optimization
			Vl = @(r1, r3) Vsource*(r3)/(r1 + Rpot + r3);
			VL = [[Vl(R1(1), R3(1)), Vl(R1(2), R3(1))]; [Vl(R1(1), R3(2)), Vl(R1(2), R3(2))]];
			Vh = @(r1, r3) Vsource*(Rpot + r3)/(r1 + Rpot + r3);
			VH = [[Vh(R1(1), R3(1)), Vh(R1(2), R3(1))]; [Vh(R1(1), R3(2)), Vh(R1(2), R3(2))]];
			% Error Minimization
			VL_Err = (VL - Vlow)./Vlow;
			VH_Err = (VH - Vhigh)./Vhigh;
			Err = sqrt(VL_Err.*VL_Err + VH_Err.*VH_Err);
			[ii, jj] = find( Err == min(min(Err)) );

			%% Final Design Suggestion
			ret = [R1(ii,jj), R3(ii,jj), VL(ii,jj), VH(ii,jj)];
			fprintf('R1   = %s Ohm\n', fmt.prefix_num(R1(ii,jj),2));
			fprintf('Rpot = %s Ohm\n', fmt.prefix_num(Rpot,2));
			fprintf('R3   = %s Ohm\n', fmt.prefix_num(R3(ii,jj),2));
			fprintf('Vmin = %0.2f V\n', VL(ii,jj));
			fprintf('Vmax = %0.2f V\n', VH(ii,jj));
		end
		function [Return, Error] = R(Val_in,E,mode)
			% R(Val_in, E, mode)
			% Returns nearest resistor value based on specified seletion rules.
			% Val_in : Input for which a corresponding value should be chosen.
			% E : (Optional) IEC table to compare against.
			%	Supports: 192, 96, 48, 24, 12, 6, 3 (IEC60063)
			%	Defaults to 24
			% mode : (Optional) Comparison mode for choosing value to return
			%	-2 : Returns nearest value below supplied input
			%	-1 : Returns nearest value at or below supplied input
			%	 0 : Returns value whose error is minimized
			%	 1 : Returns nearest value at or above supplied input
			%	 2 : Returns nearest value above supplied input
			%	Defaults to 0

			%% Support for Variable input precision
			if nargin < 2
				E = 24;
			end
			if nargin < 3
				mode = 0;
			end

			%% Decompose into Scientific Notation
			[Mantissa, Exponent] = circ.sci_notation(Val_in);

			%% Map to Common Values
			Comm = circ.IEC60063(Mantissa,E,mode);

			%% Construct Resulting Resistor Value
			Return = Comm.*Exponent;
			Error = abs((Val_in - Return)/Val_in);
		end
	end
end
