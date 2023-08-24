%% Fast Permutor
% Memory considerate means of generating all combinations of scalar sets
% Takes 1d vectors (V_i) of all desired values of a given variable
% Nominal Memory Efficiency O( SUM(V_i) )
% Nominal Computational Efficiency O( Const ) ... O(Number of Variables)
classdef Fast_Permutor < handle
	properties
		Counts = uint64([]); % Stored as 0-Indexed Values (for SANITY)
		Lens = uint64([]); % Lengths of Variables
		Prods = uint64([]); % Intermediate Results used for conversions
		NumComb = uint64(0); % Total Number of Combinations
		NumVars = uint64(0); % Total Number of Variables
		Vars = {};
	end
	methods
		function obj = Fast_Permutor(varargin)
			obj.NumVars = nargin;
			obj.Vars = varargin;
			% Presize The Tracking Arrays
			obj.Counts = uint64(zeros(nargin,1));
			obj.Lens = uint64(zeros(size(obj.Counts)));
			% Calculate Intermediate Values
			prod = uint64(1); % Product of Lengths
			for ii = (nargin:-1:1)
				vect_len = uint64(length(varargin{ii}));
				obj.Lens(ii) = vect_len;
				obj.Prods(ii) = prod;
				prod = prod*vect_len;
			end
			obj.NumComb = prod;
		end
		function [idx1] = get_var_indx(obj)
			% Returns 1's indexed indicies corresponding to supplied variables
			idx1 = obj.Counts + 1;
		end
		function [vals] = get_perm(obj)
			% Returns Current Permutation
			vals = obj.idx_to_vals(obj.get_var_indx());
		end
		function [] = inc_index(obj, N)
			% Increments current position by N if specified, 1 otherwise
			if( (nargin < 2) || (N == 1) )
				obj.inc_counts();
			else
				ii = obj.count_to_index() + N;
				obj.Counts = obj.map_idx(ii + 1) - 1;
			end
		end
 		function [idx1] = map_idx(obj, idx)
			% Maps a linear count over natural number to indicies of the
			% specified variables.
 			% ASSUMES a 1's Indexed index Variable
 			% Returns a 1's Indexed Vector of Indicies
 			rem = mod(idx - 1, obj.NumComb);
 			idx1 = zeros(obj.NumVars, 1);
 			for ii = 1:(obj.NumVars - 1) % Essentially Long Division
				prod = obj.Prods(ii);
				%quo = idivide(rem, prod); % Floor Gives Invalid Answer
				quo = Fast_Permutor.fast_idiv(rem, prod);
				rem = rem - quo*prod;
				idx1(ii) = quo + 1;				
			end
			idx1(obj.NumVars) = rem + 1;
		end
		function [vals] = perm_idx(obj, idx)
			% Returns the permutation corresponding to the natural numbered
			% counter idx.
			% ASSUMES a 1's Indexed IDX Variable
			vals = obj.idx_to_vals(obj.map_idx(idx));
		end
	end
	methods (Access=private)
		function [ii] = count_to_index(obj)
			% Returns a 0-Indexed number representing the current permutation
			ii = uint64(0);
			for jj = 1:obj.NumVars
				ii = ii + obj.Prods(jj)*obj.Counts(jj);
			end
		end
		function [vals] = idx_to_vals(obj, idx1)
			% Converts 1's indexed IDX to a specific permutation
			vals = cell(obj.NumVars, 1);
			for ii = 1:obj.NumVars
				vals{ii} = obj.Vars{ii}(idx1(ii));
			end
		end
		function [] = inc_counts(obj)
			% Simplistic Ripple Carry Increment
			ii = obj.NumVars;
			carry = 1; % Unconditionally Increment first element
			while( (carry ~= 0) && (ii > 0) )
				[obj.Counts(ii), carry] = Fast_Permutor.mod_increment(obj.Counts(ii), obj.Lens(ii));
				ii = ii - 1;
			end
		end
	end
	methods (Static, Access=private)
		function [value, carry] = mod_increment(value, modulus)
			% Modular Increment with carry flag
			value = mod(value + 1, modulus);
			if(value == 0); carry = 1; else; carry = 0; end
		end
		function [quo] = fast_idiv(Num, Dem)
			quo = (Num.*2 - 1) ./ Dem ./ 2;
		end
	end
end