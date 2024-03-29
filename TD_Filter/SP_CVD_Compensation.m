classdef SP_CVD_Compensation < TD_Filter
	% Provides an assortment of analytic operations for compensation of
	% harware capacitive voltage dividers (CVD's). The following operations
	% are supported based on the present needs:
	% Comp=	Alpha*Inp_X + 
	%		Beta*Integral(Inp_X) + 
	%		Gamma*Integral(Integral(Inp_X)) + 
	%		Delta*Convolution{ Inp_X, exp(-2*pi*f3db*t) }
	%		Epsilon*Convolution{ Inp_X, sqrt(t) }
	% These additional terms accomodate a less ideal response, 
	% and repeated roots. Both beneficial to compensation.
	% Corefficients are specified as: [alpha, beta, gamma, delta, f3db, epsilon]
	% ---
	% Note/Warning:
	% Signal X(t) is not detrended failure to ensure zero-mean null signals
	% will be detrimental to integration results.
	properties
		CVD;
	end
	methods
		function Obj = SP_CVD_Compensation(Name, Desc, CVD)
			% Populates filter with relevant data
			Obj.Name = sprintf('(CVD) %s', Name);
			Obj.Desc = sprintf('(CVD) %s', Desc);
			Obj.CVD = CVD;
		end
		function [Y, Tp] = process(obj, T, X)
			% Apply Frequency-Domain Model, if present
			if( ~isempty(obj.CVD) )
				% Proportional Term
				Y = obj.CVD(1).*X;
				% Integral Response
				if( (obj.CVD(2) ~= 0) || (obj.CVD(3) ~= 0) ) % Integral Response
					X_dx = cumtrapz(T, X);
					% First Integral Term
					if(obj.CVD(2) ~= 0)
						Y = Y + obj.CVD(2).*X_dx;
					end
					% Second Integral Term
					if(obj.CVD(3) ~= 0)
						Y = Y + obj.CVD(3).*cumtrapz(T, X_dx);
					end
				end
				% Convolutional Response ( exp[w*t] )
				if(obj.CVD(4) ~= 0) % Convolution Term
					dt = mean(diff(T)); % Todo: Support Non-Uniform Times Steps
					len_t = length(T);
					valid = 1:len_t;
					wt = (-2*pi*obj.CVD(5)*dt).*( 0:1:(len_t - 1) );
					conv_temp = dt.*conv(X, exp(wt), 'full');
					Y = Y + obj.CVD(4).*conv_temp(valid)';
				end
				% Convolutional Response ( sqrt[t] )
				if(obj.CVD(6) ~= 0) % Convolution Term
					dt = mean(diff(T)); % Todo: Support Non-Uniform Times Steps
					len_t = length(T);
					valid = 1:len_t;
					ct = (dt).*( 0:1:(len_t - 1) );
					conv_temp = dt.*conv(X, sqrt(ct), 'full');
					Y = Y + obj.CVD(6).*conv_temp(valid)';
				end
			else
				Y = X;
			end
			Tp = T;
		end
	end
end
