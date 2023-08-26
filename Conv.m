%% Conversion Factors into SI base Units
% Based on NIST Special Publication 811 (2008 Edition)
% https://www.nist.gov/pml/special-publication-811
% Accessed Prior to 2018-4-15

classdef Conv %ert
    properties (Constant)
       % Acceleration [m/s^2]
		g_m2ps = 9.80665.*10^(0); % g [m/s^2]
		ftps2_m2ps = 3.048.*10^(-1); % ft/s^2 [m/s^2]
		gal_m2ps = 1.0.*10^(-2); % gal [m/s^2]
		inps2_m2ps = 2.54.*10^(-2); % in/s^2 [m/s^2]

        % Angle [rad]
		deg_Rad = 1.745329.*10^(-2); % Degree [rad]
		mil_Rad = 9.817477.*10^(-4); % Mil [rad]
		min_Rad = 2.908882.*10^(-4); % Minute (') [rad]
		rev_Rad = 6.283185.*10^(0); % Revolution (r) [rad]
		sec_Rad = 4.848137.*10^(-6); % Second ('') [rad]

		% Area [m^2]
		acre_m2 = 4.046873.*10^(3); % Acre (U.S. Survey) [m^2]
		b_m2 = 1.0.*10^(-28); % Barn (b) [m^2]
		ha_m2 = 1.0.*10^(4); % Hectare (ha) [m^2]
		mi2_m2 = 2.589988.*10^(6); % Square Mile (mi^2) [m^2]

		% Energy [J]
		cal_J = 4.1868.*10^(0); % Calorie (cal) [J]
		eV_J = 1.602176.*10^(-19); % Electronvolt (eV) [J]
		ftlb_J =  4.214011.*10^(-2); % Foot Poundal (ft*lb) [J]
		kcal_J = 4.1868.*10^(3); % kilocalorie (kcal) [J]
		TNT_J = 4.184.*10^(9); % Ton of TNT (Energy Equivalent) [J]

		% Force [N]
		dyn_N = 1.0.*10^(-5); % Dyne (dyn) [N]
		kgf_N = 9.80665.*10^(0); % Kilogram-Force (kgf) [N]
		lbf_N = 4.448222.*10^(0); % Pound-Force (lbf) [N]
		tonf_N = 8.896443.*10^(3); % Ton-Force (2000 lbf) [N]

		% Length [m]
		A_m = 1.0.*10^(-10); % Angstrom (A) [m]
		ft_m = 3.048.*10^(-1); % Foot (ft) [m]
		ftSur_m = 3.048006.*10^(-1); % Foot (U.S. Survey) (ft) [m]
		in_m = 2.54.*10^(-2); % Inch (in) [m]
		ly_m = 9.46073.*10^(15); % Light Year (l.y.) [m]
		mi_m = 1.609344.*10^(3); % Mile (mi) [m]
		miSur_m = 1.609347.*10^(3); % Mile (U.S. Survey Foot) (mi) [m]
		miNaut_m = 1.852.*10^(3); % Mile, Nautical [m]
		pc_m = 3.085678.*10^(16); % Parsec (pc) [m]
		pica_m = 4.233333.*10^(-3); % Pica (Computer) (1/6 in) [m]
		lp_m = 1.616229.*10^(-35); % Planck Length (lp) [m]
		pt_m = 3.527778.*10^(-4); % Point (Computer) (1/72 in) [m]
		rd_m = 5.029210.*10^(0); % Rod (U.S. Survey) (rd) [m]
		yd_m = 9.144.*10^(-1); % Yard (yd) [m]

		% Mass [kg]
		gr_kg = 6.479891.*10^(-5); % Grain (gr) [kg]
		oz_kg = 2.834952.*10^(-2); % Ounce (Avoirdupois) (oz) [kg]
		ozTr_kg = 3.110348.*10^(-2); % Ounce (Troy) (oz) [kg]
		slug_kg = 1.459390.*10^(1); % Slug (Slug) [kg]
		tonL_kg = 1.016047.*10^(3); % Ton, Long (2240 lb) [kg]
		tonM_kg = 1.0.*10^(3); % Ton, Metric (t) [kg]
		ton_kg = 9.071847.*10^(2); % Ton, Short (2000 lb) [kg]

		% Force [N*m]
		lbfft_Nm = 1.355818.*10^(0); % Pound-Force Foot (lbf*ft) [N*m]
		lbfin_Nm = 1.129848.*10^(-1); % Pound-Force Inch (lbf*in) [N*m]

		% Power [W]
		hp55_w = 7.456999.*10^(2); % Horsepower (550 lbf/s) [W]
		hpB_w = 9.80950.*10^(3); % Horsepower (Boiler) [W]
		hpE_w = 7.46.*10^(2); % Horsepower (Electric) [W]
		hpM_w = 7.354988.*10^(2); % Horsepower (Metric) [W]
		hpU_w = 7.4570.*10^(2); % Horsepower (U.K.) [W]
		hpW_w = 7.46043.*10^(2); % Horsepower (Water) [W]

		% Pressure [Pa]
		atm_Pa = 1.01325.*10^(5); % Atmosphere, Standard (atm) [Pa]
		at_Pa = 9.80665.*10^(4); % Atmosphere, Technical (at) [Pa]
		bar_Pa = 1.0.*10^(5); % Bar (bar) [Pa]
		cmHg_Pa = 1.333224.*10^(3); % Centimeter of mercury (cmHg) [Pa]
		inHg_Pa = 3.386389.*10^(3); % Inch of Mercury (inHg) [Pa]
		inH2O_Pa = 2.490889.*10^(2); % Inch of Water (inH_2O) [Pa]
		PSI_Pa = 6.894757.*10^(3); % PSI (lbf/in^2) [Pa]
		torr_Pa = 1.333224.*10^(2); % Torr (torr) [Pa]

		% Radiology [...]
		Ci_Bq = 3.7.*10^(10); % Curie (Ci) [Bq]
		rad_Gy = 1.0.*10^(-2); % Rad (Absorbed Dose) (rad) [Gy]
		rem_Sv = 1.0.*10^(-2); % Rem (rem) [Sv]
		R_Qpkg = 2.58.*10^(-4); % Roentgen (R) [q/kg]

		% Time [s]
		day_s = 8.64.*10^(4); % Day (d) [s]
		hr_s = 3.6.*10^(3); % Hour (h) [s]
		min_s = 6.0.*10^(1); % Minute (min) [s]
		yr_s = 3.1536.*10^(7); % Year (365 days) [s]

		% Volume [m^3]
		bbl_m3 = 1.589873.*10^(-1); % Barrel [42 Gallons (U.S.)](bbl) [m^3]
		bu_m3 = 3.523907.*10^(-2); % Bushel (U.S.) (bu) [m^3]
		cord_m3 = 3.624556.*10^(0); % Cord (128 ft^3) [m^3]
		cup_m3 = 2.365882.*10^(-4); % Cup (U.S.) [m^3]
		floz_m3 = 2.957353.*10^(-5); % Fluid Ounce (U.S.) (fl oz) [m^3]
		gam_m3 = 3.785412.*10^(-3); % Gallon (U.S.) (gal) [m^3]
		L_m3 = 1.0.*10^(-3); % Liter (L) [m^3]
		ptDry_m3 = 5.506105.*10^(-4); % Pint (U.S. Dry) (dry pt) [m^3]
		ptLiq_m3 = 4.731765.*10^(-4); % Pint (U.S. Liquid) (liq pt) [m^3]
		qtDruy_m3 = 1.101221.*10^(-3); % Quart (U.S. Dry) (dry qt) [m^3]
		qtLiq_m3 = 9.463529.*10^(-4); % Quart (U.S. Liquid) (liq qt) [m^3]
		tbsp_m3 = 1.478676.*10^(-5); % Tablespoon [m^3]
		tsp_m3 = 4.928922.*10^(-6); % Teaspoon [m^3]
    end
	methods(Static = true)
		% Temperatures
		function [K] = degC_degK(tempC)
			K = tempC + 273.15;
		end
		function [K] = degF_degK(tempF)
			K = (tempF - 32)./1.8 + 273.15;
		end
		function [K] = degR_degK(tempR)
			K = tempR./1.8;
		end
		function [C] = degK_degC(tempK)
			C = tempK - 273.15;
		end
		function [F] = degK_degF(tempK)
			(tempK - 273.15).*1.8 + 32;
		end
		function [R] = degK_degR(tempK)
			R = tempK.*1.8;
		end
		function [C] = degF_degC(tempF)
			C = (tempF - 32)./1.8;
		end
		% Change in Temperature
		function [DK] = deltaC_deltaK(deltaC)
			DK = deltaC;
		end
		function [DK] = deltaF_deltaK(deltaF)
			DK = deltaF./1.8;
		end
		function [DK] = deltaR_deltaK(deltaR)
			DK = deltaR./1.8;
		end
		function [DC] = deltaK_deltaC(deltaK)
			DC = deltaK;
		end
		function [DF] = deltaK_deltaF(deltaK)
			DF = deltaK.*1.8
		end
		function [DR] = deltaK_deltaR(deltaK)
			DR = deltaK.*1.8
		end
		function [DC] = deltaF_deltaC(deltaF)
			DC = deltaF./1.8;
		end
	end
end
