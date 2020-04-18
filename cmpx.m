%% Complex Mathematics Tools
% Adapted from Prior Need

classdef cmpx %ert
    properties (Constant)
        rad_deg = 180./pi;
    end
    methods (Static)
        % Returns Complex Number as a Formatted String in R,Theta Form
        function [s] = strPol(z)
            r = abs(z);
            theta = cmpx.rad_deg.*angle(z);
            s = sprintf('%E @ %fº',r,theta);
        end  
        % Return Complex Number as a Formatted String in A + jB Form
        function [s] = strRect(z)
            A = real(z);
            B = imag(z);
            if(A~=0)
                if(B>0)
                    s = sprintf('%E + j*%E',A,abs(B));
                elseif(B<0)
                    s = sprintf('%E - j*%E',A,abs(B));
                else % (B == 0)
                    s = sprintf('%E',A);
                end
            else %(A==0)
                if(B~=0)
                    s = sprintf('%E*j',B);
                else
                    s = '0.000000';
                end
            end
        end
    end
end
