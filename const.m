%% Universal Constants
% https://physics.nist.gov/cuu/Constants/Table/allascii.txt
% Accessed Prior to 2018-4-15

classdef const
	properties (Constant)
		% Classical Mechanics
		g = 9.80665; % Acceleration Due to Gravity [m/s^2]
		G = 6.67384.*10^(-11); % Gravitational Constant [m^3/(kg*s^2)]
		
		% Weights
		mP = 1.672621777.*10^(-27); % Mass Proton [kg]
		mN = 1.674927351.*10^(-27); % Mass Neutron [kg]
		mE = 9.10938291.*10^(-31); % Mass Electron [kg]
		
		% Chemistry
		Na = 6.022140857.*10^(23); % Avogadro constant [1/mol]
		R = 8.3144595; % Molar Gas Constant [J/(mol*k)]
		Vm100 = 22.710947.*10^(-3); % Molar Volume of idal gas [m^3/mol] (100K)
		Vm = 22.413962.*10^(-3); % Molar Volume of idal gas [m^3/mol] (STP)	

		% Energy
		kB = 1.3806488.*10^(-23); % Boltzmann Constant [J/k]
		kBeV = 8.6173303.*10^(-5); % Boltzmann Constant [eV/k]
		kBHz = 2.0836612.*10^(10); % Boltzmann Constant [Hz/k]
		
		% EnM
		epsilon0 = 8.854187817E-12; % Permitivity of Free Space [F/m]
		mu0 =  12.566370614E-7; % Permiability of Free Space [H/m]
		c0 = 299792458; % Speed of Light in Vaccuum [m/s]
		eta0 = 119.9169832.*pi; % Intrinsic Impedance of Free Space [Ohm]
		qE = -1.602176565.*10^(-19); % Charge of an Electron [C]
		
		% Universal Constants
		H = 6.626070040.*10^(-34); % Plank's Constant [J s]
		HeV = 4.135667662.*10^(-15); % Plank's Constant [eV s]
	end
end
