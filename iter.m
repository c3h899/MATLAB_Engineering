classdef iter
% Provides commonly used macros for iteration over sets of data.
	methods(Static = true)
		% Containers sized to match input
		function mat = mat_size_of(A)
			mat = zeros(size(A));
		end
		function cel = cell_size_of(A)
			cel = cell(size(A));
		end
	
		% Index Vectors
		function vect = vect_indicies(A)
			% iter.vect_indicies(A)
			% Returns vector of indicies 1...longest dimmension
			% Returns 0 if input is empty
			lengths = max(size(A));
			if(lengths > 0)
				vect = 1:1:lengths;
			else
				vect = 0;
			end
		end
		function vect = col_indicies(A)
			% iter.col_indicies(A)
			% Returns vector of indicies 1...last column index
			vect = 1:1:iter.size(A,2); % Maximize code re-use
		end
		function vect = plane_indicies(A)
			% iter.plane_indicies(A)
			% Returns vector of indicies 1...last plane
			vect = 1:1:iter.size(A,3); % Maximize code re-use
		end
		function vect = row_indicies(A)
			% iter.row_indicies(A)
			% Returns vector of indicies 1...last row index
			vect = 1:1:iter.size(A,1); % Maximize code re-use
		end
		
		% Verbose Size Macros
		function num = num_cols(A)
			% iter.num_cols(A)
			% Returns number of columns in A
			num = iter.size(A,2);
		end
		function num = num_planes(A)
			% iter.num_planes(A)
			% Returns number of planes in A
			num = iter.size(A,3);
		end
		function num = num_rows(A)
			% iter.num_rows(A)
			% Returns number of rows in A
			num = iter.size(A,1);
		end
	end	
	methods(Access = private, Static = true)
		% Intermediate Dimmensioning Function
		% Only exists to allow modifications to size behavior
		function dimm = size(A,n)
			dimm = size(A,n);
		end
	end
end
