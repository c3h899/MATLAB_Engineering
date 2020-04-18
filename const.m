%% Universal Constants
% https://physics.nist.gov/cuu/Constants/Table/allascii.txt
% 
% [Classical Mechanics]
% g        : (standard) acceleration due to gravity [m/s^2]
% G        : Gravitational Constant [m^3/(kg*s^2)]
% 
% [Weights]
% mP       : Mass Proton [kg]
% mN       : Mass Neutron [kg]
% mE       : Mass Electron [kg]
% 
% [Chemistry]
% fCs      : Hyperfine transition frequency of Cs-133
% Na       : Avogadro constant [1/mol]
% R        : Molar Gas Constant [J/(mol*k)]
% Vm100    : Molar Volume of ideal gas [m^3/mol] (100K)
% Vm       : Molar Volume of ideal gas [m^3/mol] (STP)
% 
% [Energy]
% kB       : (EXACT) Boltzmann Constant [J/k]
% kBeV     : (EXACT) Boltzmann Constant [eV/k]
% kBHz     : (EXACT) Boltzmann Constant [Hz/k]
% 
% [EnM]
% epsilon0 : Permittivity of Free Space [F/m]
% kE       : Coulomb Constant [N*m^2/C^2]
% mu0      : Permeability of Free Space [H/m]
% c0       : Speed of Light in Vaccuum [m/s]
% eta0     : Intrinsic Impedance of Free Space [Ohm]
% qE       : (EXACT) Charge of an Electron [C]
% qp       : Elementary Charge [C]
% 
% [Universal]
% H        : (EXACT) Plank's Constant [J s]
% Hbar     : Reduced Planck Constant [J s]
% HeV      : (EXACT) Plank's Constant [eV s]
% HeVbar   : Reduced Plank's Constant [eV s]
%
% Last Updated for 2018 CODATA
classdef const
    properties (Constant)
        % Classical Mechanics
        g = 9.80665; % (Standard) Acceleration Due to Gravity [m/s^2]
        G = 6.67430.*10^(-11); % Gravitational Constant [m^3/(kg*s^2)]
        
        % Weights
        mP = 1.67262192369.*10^(-27); % Mass Proton [kg]
        mN = 1.67492749804.*10^(-27); % Mass Neutron [kg]
        mE = 9.1093837015.*10^(-31); % Mass Electron [kg]
        
        % Chemistry
		fCs = 9192631770; % (EXACT) Hyperfine transition frequency of Cs-133
        Na = 6.02214076.*10^(23); % (EXACT) Avogadro constant [1/mol]
        R = 8.314462618; % (EXACT) Molar Gas Constant [J/(mol*k)]
        Vm100 = 22.71095464.*10^(-3); % Molar Volume of ideal gas [m^3/mol] (100K)
		Vm = 22.41396954.*10^(-3); % Molar Volume of ideal gas [m^3/mol] (STP)
		
        % Energy
        kB = 1.380649.*10^(-23); % (EXACT) Boltzmann Constant [J/k]
        kBeV = 8.617333262.*10^(-5); % (EXACT) Boltzmann Constant [eV/k]
        kBHz = 2.083661912.*10^(10); % (EXACT) Boltzmann Constant [Hz/k]
        
        % EnM
        epsilon0 = 8.8541878128E-12; % Permittivity of Free Space [F/m]
		kE = 1/(4*pi*const.epsilon0); % Coulomb Constant [N*m^2/C^2]
        mu0 =  1.25663706212E-6; % Permeability of Free Space [H/m]
        c0 = 299792458; % (EXACT) Speed of Light in Vaccuum [m/s]
        eta0 = const.mu0*const.c0; % Intrinsic Impedance of Free Space [Ohm]
        qE = -1.602176634.*10^(-19); % (EXACT) Charge of an Electron [C]
		qP = abs(const.qE); % Charge of a Proton [C]
		
		% Universal
		H = 6.62607015.*10^(-34); % (EXACT) Plank's Constant [J s]
		Hbar = const.H/(2*pi); % Reduced Planck Constant [J s]
		HeV = const.H/const.qP; % (EXACT) Plank's Constant [eV s]
		HeVbar = const.HeV/(2*pi); % Reduced Plank's Constant [eV s]
    end
end