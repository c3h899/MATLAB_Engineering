classdef (Abstract) TD_Filter < handle
	% Time-Domain Filter Provides an abstract model of a time-domain
	% Signal processer or other filter.
	% The Failure State of a TD_Filter will be to return the unprocessed
	% input as output and (optionally) throw a warning or error.
	properties
		Name; % (Text) Name of the Model
		Desc; % (Text) Description of the Model
	end
	methods (Abstract)
		[Y, Tp] = process(obj, T, X); % Implements Signal Processor
			% Where Column Vectors, [T]ime and [X](t) are provided
			% Returns [X, T] of the processed signal abuses Copy-on-Write
			% to simplify use case of permuting/non-permuting T
	end
end
