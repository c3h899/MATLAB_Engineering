classdef color
% Provides color schemes for use with MATLAB plotting routines
	properties(Constant)
	end
	methods(Access = public, Static = true)
		function N = from_hex(hex_str)
			% Converts from hexstring (e.g. 00AAFF) to (0...1) tripple
			Chars = char(hex_str); % Ensure operation
			N = [hex2dec(Chars(1:2)), hex2dec(Chars(3:4)), hex2dec(Chars(5:6))]./255;
		end
		function c = linear(srgb)
			lt = (srgb <= 0.04045);
			k1 = 1/12.92;
			k2 = 1/1.055;
			c = (k1.*srgb).*(lt) + (((srgb + 0.055).*k2).^2.4).*(~lt);
			% https://entropymine.com/imageworsener/srgbformula/
		end
		function c = linear_8bit(srgb)
			% Converts to Linear from 8-bit SRGB Values (0 ... 255)
			c = color.linear(srgb./255);
		end
		function c = linear_hex(hex_str)
			% Converts to Linear from 8-bit SRGB Values as hexstring (e.g. 00AAFF)
			SRGB = color.from_hex(hex_str);
			c = color.linear(SRGB);
		end
		function c = srgb(linI)
			lt = (linI <= 0.0031308);
			c = (linI.*12.92).*(lt) + (1.055.*linI.^(1/2.4) - 0.055).*(~lt);
			% https://entropymine.com/imageworsener/srgbformula/
		end
		function c = srgb_hex(hex_str)
			% Reports (0...1) tripple from 8-bit SRGB hexstring (e.g. 00AAFF)
			c = color.from_hex(hex_str);
		end
	end
	methods(Static = true)
		function C = error_color(dec)
		% First order Color Bar
		% Logarithmic Absolute Scale
		% X < 00.00001 : Dark-Blue
		% X = 00.00010 : Blue
		% X = 00.00100 : Cyan
		% X = 00.01000 : Green
		% X = 00.10000 : Yellow
		% X = 01.00000 : Red
		% X > 10.00000 : Dark Red
			C = color.spectrum( (1/6).*(5 + log10(dec)) );
		end
		function C = spectrum(dec)
		% Produces RGB color-pairs for inputs of [0,1]
		% X < 0.0 : Dark-Blue
		% X = 1/2 : Blue
		% X = 1/3 : Cyan
		% X = 1/2 : Green
		% X = 2/3 : Yellow
		% X = 5/6 : Red
		% X > 1.0 : Dark Red
			C = zeros(size(dec,1),3); % Storage Array
			c1_6 = 1/6; c1_3 = 1/3; c2_3 = 2/3; c5_6 = 5/6;
			for ii = 1:length(dec)
				% Assuming Linear RGB Intensity Values
				switch true
					case (dec(ii) <= 0) % Under
						r = 0; g = 0;
						b = 0.25;
					case ((0 < dec(ii)) && (dec(ii) <= c1_6)) % Fade
						r = 0; g = 0;
						b = 0.25 + 4.5*dec(ii);
					case ((c1_6 < dec(ii)) && (dec(ii) <= c1_3))
						r = 0; b = 1;
						g = 6*dec(ii) - 1;
					case ((c1_3 < dec(ii)) && (dec(ii) <= 0.5))
						r = 0; g = 1;
						b = 3 - 6*dec(ii);
					case ((0.5 < dec(ii)) && (dec(ii) <= c2_3))
						g = 1; b = 0;
						r = 6*dec(ii) - 3;
					case ((c2_3 < dec(ii)) && (dec(ii) <= c5_6))
						r = 1; b = 0;
						g = 5 - 6*dec(ii);
					case ((c5_6 < dec(ii)) && (dec(ii) <=  1))  % Fade
						g = 0; b = 0;
						r = 4.75 - 4.5*dec(ii);
					case (  1 < dec(ii)) % Excess
						r = 0.25; g = 0; b = 0;
					otherwise % SHOULD NEVER BE REACHED
						r = 1; g = 1; b = 1;
				end
				% Correct for sRGB Encoding
				% gamma = 1/2.2;
				% C(ii,:) = [r g b]; %color.srgb([r,g,b]);
				C(ii,:) = [color.srgb(r) color.srgb(g) color.srgb(b)]; %color.srgb([r,g,b]);
			end
		end
	end
end
