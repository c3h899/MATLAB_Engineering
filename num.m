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
		function [Xds, Fds] = ds_freq_ext(X, F, has_zero)
			% Generates a douple sided frequency spectrum
			% assuming a monotonic, increasing, real-valued signal.
			% if (has_zero) X(1) is assumed to correspond with 0 Hz.
			% otherwise the value at 0 Hz is assumed.
			if(has_zero)
				Xds = [flip(conj(X(2:end))); abs(X(1)); X(2:end)];
				Fds = [-1.*flip(F(2:end)); F];
			else
				Xds = [flip(conj(X)); abs(X(1)); X];
				Fds = [-1.*flip(F); 0; F];
			end
		end
		function [Y_comp] = fd_compensation(comp, X, freq)
			% Applies frequency-domain compensation based on input object comp
			% Assumes comp is a structure containing a double-sided frequency
			% response structure containging fields 'freq' and 'H_inv'.
			% Returns Y_comp = X*H_inv(freq) at all specified frequencies
			% Enforces phase at 0 Hz is 0.
			H_cor = interp1(comp.freq, comp.H, freq, "linear", 1);
			X_int = reshape(X,size(H_cor));
			Y_comp = reshape(X_int.*H_cor, size(X));
			DC = find(freq == 0);
			Y_comp(DC) = abs(Y_comp(DC));
		end
		function [Y, F] = fft_ext(X, Dt, varargin)
		% Wrapper for FFT function which includes procedural generation of
		% freqeuncy axis as well as the fourier transform of X.
		% (Inputs)
		% X : Variable to be transformed
		% Dt : (Constant) Time step between points [s]
		% N : (Optional) Manually specified FFT length
		% (Outputs) [Y, F]
		% Y : FFT{X}
		% F : Frequency Spectrum
		%	Warning: The frequency vector is non-monotonic
		%	This may be corrected by invoking the fftshift() function.
			if(nargin < 3)
				len_x = length(X);
			else
				len_x = varargin{1};
			end
			Fs = 1/Dt;
			Y = fft(X, len_x);
			% FFT Function: https://www.mathworks.com/help/matlab/ref/fft.html
			
			Nq = Fs/2;
			df = Fs/len_x;
			% https://www.mathworks.com/matlabcentral/answers/88685-how-to-obtain-the-frequencies-from-the-fft-function
			% See response by Wayne King	
			if(num.is_odd(len_x))
				% Generate the interval (-Fs/2, Fs/2)
				res = df/2;
				F = reshape(ifftshift( (res-Nq):df:(Nq-res) ), size(Y));
			else
				% Generate the interval [-Fs/2, Fs/2)
				df = Fs/len_x;
				res = df/2;
				F = reshape(ifftshift( -Nq:df:(Nq - df) ), size(Y));
				warning('fft_ext: Use of odd-length signals is encouraged.');
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
		function [L] = is_odd(A)
		% Logical Test if number is odd-valued
			L = (rem(A,2) == 1);
		end
		function [L] = is_even(A)
		% Logical Test if number is even-valued
			L = (rem(A,2) == 0);
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
		function [Xsq] = root_filter(F, X)
			% (Attempts) to generate a square root filter from input signal
			% This is important for converting 2-way measurments to 1-way.
			r = abs(X);
			th = (0.5).*unwrap(angle(X));
			
			% (Patch)
			% Zeros the phase at F == 0
			zero_idx = find(F == 0, 1, 'first');
			if(isempty(zero_idx))
				warning('root_filter: O Hz Phase compensation failed.');
				err = abs(F);
				zero_idx = find(err == min(err), 1, 'first');
			end
			th = th - th(zero_idx);
			
			% Calculate the complex root
			phase = cos(th) + 1i.*sin(th);
			Xsq = sqrt(r).*phase;
		end
		function [Sm] = smooth_complex(X, span, method)
			mag = smooth(abs(X), span, method);
			phase = exp(1i.*smooth(unwrap(angle(X)), span, 'rloess'));
			Sm = mag.*phase;
		end
		function [dt] = xcorr_fit(vec, ref, t_step, max_dt)
			% Maximizes cross correlation of vec(t - dt) and ref(t)
			max_lag = floor(max_dt/t_step);
			[c, lag] = xcorr(vec, ref, max_lag);
			%stem(lag, c);
			lags = lag(c == max(c));
			abs_lag = abs(lags);
			dt = t_step*lags( find(abs_lag == min(abs_lag),1,'first') );
		end
		function [Yp, pre] = zm_det(y, t, t0, t1)
			% Interval (t0, t1), t0 < t1 defines a zero-mean precursor
			% The mean of the precursor is subtracted from y(t) to form y'(t)
			pre = (t > t0) & (t < t1);
			Yp = y - mean(y(pre));
		end
		function [Yp, pre] = zm_det_int(y, t, t0, t1)
			% Takes a uniformly sampled y(t) and returns a detrended anti-derivative
			% Interval (t0, t1), t0 < t1 defines a zero-mean precursor
			% The mean of the precursor is subtracted from y(t) to form y'(t)
			% The anti-derivative Y' of y'(t) is evaluated to form Yp
			[yd, pre] = zm_det(y, t, t0, t1);
			dt = mean(diff(t));
			Yp = dt.*cumtrapz(yd);
		end
	end
end
