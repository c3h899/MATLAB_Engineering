function [str] = metric_prefix(Val_in,precission)
% metric_prefix(Val_in, precission)
% Returns value formatted as string using metric prefixes
% Val_in : Input Value to be formatted
% precission : (Optional) argument specifying significance
% without specification, a default value of 3 significant figures is used.

%% Support for Variable input precision
if nargin < 2
	precission = 3;
end

%% Decompose into Scientific Notation
Val_pow = log10(Val_in); % Common Log of Input Value
Exp = floor(Val_pow); % Extract Base-10 Power
Exponent = 10.^Exp; % Extract Base-10 Expoenent
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

%% Format Output Sting
disp(Mantissa);
disp(Exp);

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
