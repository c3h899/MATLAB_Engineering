%% Regexp
% Extended Routines for Use of MATLAB's Regular Expression Platform

classdef regex
	methods (Static)
		function [str] = number_groups(pattern)
			% Numbers the unnamed capture groups
			% MATLABifies convention regex syntax
			% Ignores anonymous capture groups
			unnamed = '(?<!\\)(?=\([^?])[\(]';
			count = 1;
			p = @counter; % (!) NEEDED for regexprep (!)
			function str = counter
				str = sprintf('%i',count);
				count = count + 1;
			end
			str = regexprep(pattern,unnamed,'(?<U${p()}>');
		end
		function [tab] = table(cell_array,pattern)
			% Regular Expression to Table
			% Parses a cell array of records according to regular expression.
			% Returns a table where capture groups are stored as variables.
			%    cell_array : Cell Array of Records
			%    pattern : Regular Expression Defining Capture Groups
			% Un-named capture groups will be captioned U# in order presented.
			final_pattern = regex.number_groups(pattern);
			% Evaluate Regular Expression
			struc = regexp(cell_array,final_pattern,'names');
			% Construct Cell Array of Data
			fn = fieldnames(struc{1,1});
			ca = cell(numel(struc),numel(fn));
			for jj = 1:numel(fn) % Iterated through named capture groups
				for ii = 1:numel(struc) % Iterate through cell array
					% Attempt to convert input data to numeric format
					%   if successful : store the numeric data.
					%   else : store original string.
					val_str = struc{ii}.(fn{jj});
					val_num = str2double(val_str);
					if(isnan(val_num))
						ca{ii,jj} = val_str;
					else
						ca{ii,jj} = val_num;
					end
				end
			end
			% Convert Cell Array to Table
			tab = cell2table(ca,'VariableNames',fn);
		end
	end
end