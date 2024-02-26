classdef oscope
% Provides useful routines for reading oscilloscope data
% Class will strive to return data as structs as such:
% 'file_name', (Text) the Input Path Specified
% 'num_cols', (Number) Count of columns in 'wav'
% 'num_rows', (Number) Count of rows in 'wav'
% 't0', (Number) Time in Seconds corresponding to zero of data
% 'dt', (Number) Delta Time in Seconds, Sampling Period
% 'time', (Column Vector) Time in Seconds, time vector
% 'wav', (Matrix) Tabular data where columns denote channels (measurements)
% 	and rows denote common sampling times specified by 'time'
	properties(Constant)
	end
	methods(Access = private, Static = true)
	end
	methods(Static = true)
		function [Record] = read_rigol_csv_a(path_name)
			% Common to Modern [Circa 2010+] Rigol Oscilloscopes
			% Parses a Pattern consisting of a simple, tabular data
			% comma delimited columns of data with matching times.
			% ---
			% Note: Designation '_a' is based on this being the 1st
			% file pattern used by the manufacture that I have encountered.
			in_dat = readmatrix(path_name);
			dt = mean(diff(in_dat(:,1)));
			% Build the Output Record
			Record = struct(...
				'file_name', path_name, ...
				'num_cols', size(in_dat,2) - 1, ...
				'num_rows', size(in_dat,1), ...
				't0', in_dat(1,1), ... % [s] Has no special value
				'dt', dt, ...
				'time', in_dat(:,1), ... % [s] Measurement Times
				'wav', in_dat(:,2:end) ... % [V] Measured Signals
			);
		end
		function [Record] = read_rigol_csv_b(path_name)
			% Common to Modern [Circa 2020+] Rigol Oscilloscopes
			% Parses a Pattern consisting of a single header line and
			% comma delimited columns of data (optionally) without
			% matching times, only step and t0 provided.
			% ---
			% Note: Designation '_b' is based on this being the 2nd
			% file pattern used by the manufacture that I have encountered.
			fid = fopen(path_name);	% Open the file (to extract the header)
			Header = split(fgetl(fid),',');
			fclose(fid);
			% num_cols
			num_cols = size(Header,1);
			non_col_entries = 0; % Count of Header entries which are not column labels.
			% Search for Last, Non-Empty Column
			is_empty = isempty(Header{num_cols});
			while( (num_cols > 2) && (is_empty) )
				num_cols = num_cols - 1;
				is_empty = isempty(Header{num_cols});
			end
			% Check for Time Column
			has_time_vector = strcmp(Header{1},'Time(s)');
			% Check for [tInc] Specified (Should be present if t0 present)
			tInc_exp = '\s*tInc\s*=\s*(?<tInc>[-+]?([0-9]*[.])?[0-9]+([eE][-+]?\d+)?)';
			% Expect entry will be in last (non-empty) position.
			tInc_rg = regexp(Header{num_cols}, tInc_exp, 'names');
			if( ~isempty(tInc_rg) )
				has_tInc = true;
				non_col_entries = non_col_entries + 1;
				tInc = str2double(tInc_rg.tInc);
			elseif(has_time_vector)
				has_tInc = false;
				tInc = 0; % Dummy Value; Will be Re-Calculated
			else
				error('read_rigol_csv2: Failed to identify time information (t0)');
			end
			% Check for [t0] Specified (Should be present if tInc present)
			t0_exp = '\s*t0\s*=\s*(?<t0>[-+]?([0-9]*[.])?[0-9]+([eE][-+]?\d+)?)';
			% Expect entry will be in (last - 1) (non-empty) position.
			t0_rg = regexp(Header{num_cols - 1}, t0_exp, 'names');
			if( ~isempty(t0_rg) )
				has_t0 = true;
				non_col_entries = non_col_entries + 1;
				t0 = str2double(t0_rg.t0);
			elseif(has_time_vector)
				has_t0 = false;
				t0 = 0; % Dummy Value; Will be Re-Calculated
			else
				error('read_rigol_csv2: Failed to identify time information (t0)');
			end
			num_cols = num_cols - non_col_entries;
			% Measured Values
			in_dat = readmatrix(path_name, 'ExpectedNumVariables', (num_cols));
			% Handle Time Vector
			if(has_time_vector)
				t_vec = in_dat(:,1);
				dt_cmp = mean(diff(t_vec));
				if( has_tInc )
					if( abs((dt_cmp - tInc)/tInc) >= 1e-6 ) % Error Exceeds 1 PPM
						error('read_rigol_csv: tInc inconsistent');
					end
				else
					tInc = dt_cmp; % Calculate based on recovered formula
				end
				t0_cmp = t_vec(1) - dt_cmp;
				if( has_t0 )
					if( abs((t0_cmp - t0)/t0) >= 1e-6 ) % Error Exceeds 1 PPM
						warning('read_rigol_csv: t0 inconsistent (Ignore if data saved from SCREEN)');
					end
				else
					t0 = t0_cmp; % Calculate based on recovered formula
				end
				wav_dat = in_dat(:,2:end);
			else
				t_vec = (1:size(in_dat,1))'.*tInc + t0;
				wav_dat = in_dat;
			end
			% Report Data
			Record = struct(...
				'file_name', path_name, ...
				'num_cols', size(wav_dat,2), ...
				'num_rows', size(wav_dat,1), ...
				't0', t0, ...
				'dt', tInc, ...
				'time', t_vec, ...
				'wav', wav_dat ...
			);
		end
		function [] = import_rigol_csv_folder(dir, of_name)
			in_csv = fio.list_of_files(dir, 'csv');
			sz = size(in_csv,2);
			dat = cell(sz,1);
			for ii = 1:sz
				path_name = sprintf('%s\\%s', dir, in_csv{ii});
				dat{ii} = oscope.read_rigol_csv_b(path_name);
			end
			save(string(of_name), 'dat');	
		end
	end
end
