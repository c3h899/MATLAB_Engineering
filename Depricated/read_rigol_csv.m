function [Record] = read_rigol_csv(dir, file_name)
	% Open the file (to extract the header)
	fq_fname = sprintf('%s\\%s', dir, file_name);
	fid = fopen(fq_fname);
	Header = split(fgetl(fid),',');
	fclose(fid);
	
	% num_cols
	num_cols = size(Header,1);
	
	% Search for Last, Non-Empty Column
	num_blank = 0;
	is_empty = isempty(Header{(num_cols - num_blank)});
	while( (num_blank < (num_cols - 2) ) && (is_empty) )
		num_blank = num_blank + 1;
		is_empty = isempty(Header{(num_cols - num_blank)});
	end
	
	% t0
	t0_str = strtrim(split(Header{(end - num_blank - 1)},'='));
	t0 = str2double(t0_str{2});
	
	% tInc
	tinc_str = strtrim(split(Header{(end - num_blank)},'='));
	tinc = str2double(tinc_str{2});
	
	% Measured Values
	in_dat = readmatrix(fq_fname, 'ExpectedNumVariables', (num_cols - num_blank - 2));
	
	% Reconstruct Time Vector
	t_vec = (1:size(in_dat,1))'.*tinc + t0;
	
	Record = struct(...
		'file_name', file_name, ...
		'num_cols', size(in_dat,2), ...
		'num_rows', size(in_dat,1), ...
		't0', t0, ...
		'tinc', tinc, ...
		'time', t_vec, ...
		'wav', in_dat ...
	);
end
