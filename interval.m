classdef interval
	% INTERVAL Simple routines for defining continuous intervals 
	% Sets will be treated as inclusive, and specified as [start, end]
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function U = union(A,B)
			% UNION returns the continuous union of intervals A,B
			% i.e. if (A union B) != (Cmin, Cmax), NaN is returned
			if(B(1) <= A(1))
				if(A(1) <= B(2)); U(1) = B(1); else; U(1) = nan(1); end
			else % ( B(1) > A(1) )
				if(B(1) <= A(2)); U(1) = A(1); else; U(1) = nan(1); end
			end
			if(B(2) <= A(2))
				if(A(1) <= B(2)); U(2) = A(2); else; U(2) = nan(1); end
			else % ( B(2) > A(2) )
				if(B(1) <= A(2)); U(2) = B(2); else; U(2) = nan(1); end
			end
		end
		function I = intersection(A,B)
			% INTERSECTION returns the intersection of intervals A,B
			if(B(1) <= A(1))
				if(A(1) <= B(2)); I(1) = A(1); else; I(1) = nan(1); end
			else % ( B(1) > A(1) )
				if(B(1) <= A(2)); I(1) = B(1); else; I(1) = nan(1); end
			end
			if(B(2) <= A(2))
				if(A(1) <= B(2)); I(2) = B(2); else; I(2) = nan(1); end
			else % ( B(2) > A(2) )
				if(B(1) <= A(2)); I(2) = A(2); else; I(2) = nan(1); end
			end
		end
		function R = random_float(rows,cols,exp_range)
			% RANDOM_FLOAT returns matrix of random floating point numbers
			% Returned Values will take the form (+/-)mantissa*10^exponent
			% Where mantissia \in (1,10) and exponent \in [exp_range]
			% rows, cols defines the number of elements in the matrix
			% exp_range [smallest INTEGER power of 10, largest INTEGER power of 10]
			% NOTE: This routine will NEVER return exactly 0.
			Exp = randi((exp_range(2)-exp_range(1)+1),rows,cols)+(exp_range(1)-1);
			Mant = randi(9,rows,cols) + rand(rows,cols);
			Sign = 2.*(randi(2,rows,cols)-1.5);
			R = Sign.*Mant.*(10.^(Exp));
		end
	end
end

