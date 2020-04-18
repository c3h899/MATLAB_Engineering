classdef gradient
% Provides arbitrary linear gradient specification
	properties
		I;
		Stop;
	end
	methods
		function obj = gradient(inten,stop)
			[obj.Stop,indx] = sort(stop);
			obj.I = inten(indx,:);
		end
		function c = color(obj, val)
			c = zeros(size(val,2),3);
			for ii = 1:length(c)
				if(val(ii) <= obj.Stop(1))
					linI = obj.I(1,:);
				elseif(val(ii) >= obj.Stop(end))
					linI = obj.I(end,:);
				else
					kUpper = find(obj.Stop > val(ii),1);
					kLower = kUpper - 1;
					m = (obj.I(kUpper,:) - obj.I(kLower,:))./(obj.Stop(kUpper) - obj.Stop(kLower));
					linI = obj.I(kLower,:) + m.*(val(ii) - obj.Stop(kLower));
				end
				for jj = 1:3
					if (linI(jj) <= 0.0031308)
						c(ii,jj) = linI(jj)*12.92;
					else
						c(ii,jj) = 1.055*linI(jj)^(1/2.4) - 0.055;
					end
				end
			end
		end
	end
end