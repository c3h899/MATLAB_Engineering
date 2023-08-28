classdef fio
% Provides useful routines for File Input/Output (IO)
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [files] = list_of_files(path, extension)
			% Takes a path and file extension and provides a list of records
			% within said directory that match the specified extension.
			% TODO: Extend to more complex search patterns
			files = {dir(sprintf('%s\\*.%s', path, extension)).name};
		end
		function [json] = read_json(fname)
			% Reads JSON record and returns struct of data contained within
			fid = fopen(fname);
			str = char(fread(fid,inf)'); 
			fclose(fid);
			json = jsondecode(str);
		end
	end
end