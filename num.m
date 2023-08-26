classdef num
% Provides useful routines for numerical analysis in MATLAB
% Numerical analysis
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [test] = approx_equal(A, B, tol)
			tol2 = tol*(1 + 5e-4*tol);
			if all(abs(A - B) <= tol2, [1, 2, 3])
				test = true;
			else
				test = false;
			end
		end
		function [val2] = approx_zero(val, tol)
			if( num.approx_equal(val, 0, tol) )
				val2 = 0;
			else
				val2 = val;
			end
		end
		function [mom] = four_moments(x)
		% Statistical Moments of a Sample Distribution
		% Returns Sample [Mean, Varience, Skewness, Kurtosis]
			Mu = mean(x); % Mean
			Var = var(x); % Varience
			Sk = skewness(x); % Sample Skewness
			Kr = kurtosis(x); % Sample Kurtosis
			mom = [Mu, Var, Sk, Kr];
		end
		function [fit] = goodness_of_fit(o,f)
		% Goodness of Fit Metrics
		% goodness_of_fit(O,P)
		% O is the observation.
		% P is the prediction.
		% Returns [R-Squared Correlation, Reduced Chi-Squared Goodness of Fit,
		%    Root-Mean-Squared Error, Standard Deviation of the Error]
			N = length(o);
			if(length(o) == length(f))
				% Standard Deviation of Error
				res = o - f; % Error/Residuals
				resBar = sum(res)/N;
				SigmaE = sqrt(sum((res-resBar).^2)/(N-1));	
				% Coefficient of Determination (R-Squared)
				yBar = sum(o)/N;
				SStot = sum((o - yBar).^2);
				SSres = sum((res).^2);
				R2 = 1 - SSres/SStot;
				% Reduced Chi-Squared Test
				Sigma2 = SStot/N;
				X2 = SSres/Sigma2;
				% Root Mean Squared Error
				RMSE = sqrt(SSres/N);
			else
				fprintf('Error\n');
				R2 = -1; X2 = -1; RMSE = -1; SigmaE = -1;
				% Valid Responses will NEVER be Negative
			end
			fit = [R2, X2, RMSE, SigmaE];
		end
		function [D] = derivative(x,y,n)
		% Derivative
		% Returns numerical approximation of d^N/dx^N [ f(x) ]
		% Support for Matrix of 3 or more dimensions is not implemented.
		% Returns vector of same size as X, padded with NaN's
		% D = derivative(X,Y,N)
		% X is x coordinates of the evaluation.
		% Y is evaluation of the function f(x).
		% N (Optional) is the order of the derivative
		% Differentiation is performed along the major dimension
			if nargin < 3 % Populate Optional Order of derivative.
				n = 1;
			end
			s = size(x);
			if(s(1) >= s(2)) % (Preferred) difference successive rows
				s(1) = n;
				Dy = [nan(s); diff(y,n,1)];
				s(1) = 1;
				Dx = [nan(s); diff(x,1,1).^n];
			else % Differentiat successive columns
				s(2) = n;
				Dy = [nan(s), diff(y,n,2)];
				s(2) = 1;
				Dx = [nan(s), diff(x,1,2).^n];
			end
			D = Dy./Dx;
		end
		function [E2] = mse(o,p)
		% Mean Squared Error
		% E2 = MSE(P,O)
		% O is the observation.
		% P is the prediction.
			if(size(p) == size(o))
				E2 = 1/length(p).*sum((o - p).^2);
			else
				fprintf('Error: Invalid Input (MSE) Dimension Miss-Match');
			end
		end
		function [R2] = r_squared(o,p)
		% R-Squared Correlation Coeffecient
		% R2 = Rsquared(O,P)
		% O is the observation.
		% P is the regression.
			o_bar = sum(o)./length(o);
			ss_tot = sum((o - o_bar).^2);
			ss_res = sum((o - p).^2);
			R2 = 1 - ss_res./ss_tot;
		end
	end
end