function [Return, Error] = std_resistor(Val_in,E,mode)
	% std_resistor(Val_in, E, mode)
	% Returns nearest resistor value based on specified seletion rules.
    % Val_in : Value for which a corresponding value should be chosen.
    % E : (Optional) IEC table to compare against.
    %   Supports: 192, 96, 48, 24, 12, 6, 3 (IEC60063)
    %   Defaults to 24
    % mode : (Optional) Comparison mode for choosing value to return
	%	-2 : Returns nearest value below supplied input
	%	-1 : Returns nearest value at or below supplied input
	%	 0 : Returns value whose error is minimized
	%	 1 : Returns nearest value at or above supplied input
	%	 2 : Returns nearest value above supplied input
    %   Defaults to 0

    %% Support for Variable input precision
    if nargin < 2
        E = 24;
    end
    if nargin < 3
        mode = 0;
    end

	%% Decompose into Scientific Notation
	Val_pow = log10(Val_in); % Common Log of Input Value
	Exponent = 10.^floor(Val_pow); % Extract Base-10 Exponent
	Mantissa = Val_in./(Exponent); % Extract Base-10 Mantissa

	%% Map to Common Values
	Comm = IEC60063(Mantissa,E,0);

	%% Construct Resulting Resistor Value
	Return = Comm.*Exponent;
    Error = abs((Val_in - Return)/Val_in);
end
