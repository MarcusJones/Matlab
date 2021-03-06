% This analysis only meant for an EXAMPLE of a 1st law analysis of the
% solar thermal system of ENERGYbase!
% MJones AIT - 20 Nov 2009 - Creation of file
% MJones AIT - 25 Nov 2009 - Update

%% Load data
clear all

load '.\Properties\waterProps';

SolarJanuaryData=ADPRead('D:\L Scripts\02L Matlab\06 Monitoring Data Analysis\Sample Data\Solarsystem_January_Original.xls');

%% Quick check of temperatures ...
ADPDisp(SolarJanuaryData,'Solar-27 prim�rTemp.RL','Solar-24 prim�rTemp.VL') 

%% Data: State point for flow into solar collector;
% Temperature 
% Sensor name: Solar-27 prim�rTemp.RL
sol.n27.col = ADPGetFromHeader(SolarJanuaryData.header,'Solar-27 prim�rTemp.RL');
sol.n27.T = SolarJanuaryData.data(:,sol.n27.col); % [�C]
% Mass flow
% Assumption!!!!
sol.n27.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n27.se = enthalpyWater(waterProps, sol.n27.T); % [kJ/kg]
% Absolute enthalpy
sol.n27.ef = sol.n27.se.*sol.n27.mf; % [kJ/s] or [kW]

%% Data: State point for flow leaving solar collector
% Sensor name: Solar-24 prim�rTemp.VL
% Temperature
sol.n24.col = ADPGetFromHeader(SolarJanuaryData.header,'Solar-24 prim�rTemp.VL');
sol.n24.T = SolarJanuaryData.data(:,sol.n24.col); % [�C]
% Mass flow
% Assumption!!!!
sol.n24.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n24.se = enthalpyWater(waterProps, sol.n24.T); % [kJ/kg]
% Absolute enthalpy
sol.n24.ef = sol.n24.se.*sol.n24.mf; % [kJ/s]

%% Data: State point for solar irradiance onto solar collector
% Example only, find the right sensor!!!
% Assumption;
Gi_solar_spec = 0.700; % [kW/m2]
% Assumption;
areaSolar = 100; % [m2]
% Assumption;
Gi_solar_inc = Gi_solar_spec .* areaSolar; % [kW]

%% Initial analysis
%Temperature change across collector;
figure
plot(SolarJanuaryData.time,sol.n24.T-sol.n27.T)
datetick2
legend('Delta T')
title('Temperature change across solar collector');

%% First Law analysis
% Useful energy gain of solar collector
figure
ef_solarGain = sol.n24.ef - sol.n27.ef;
plot(ef_solarGain)
datetick2
legend('Delta Enthalpy Flow (ASSUMPTIONS!)')
title('Energy gain across solar collector (ASSUMPTIONS!)');
% Efficiency of solar collector

% Assumption;
figure
eta_solar = ef_solarGain ./ Gi_solar_inc; % [-]
plot(eta_solar)
datetick2
legend('Efficiency (ASSUMPTIONS!)')
title('Efficiency of solar collector (ASSUMPTIONS!)');
