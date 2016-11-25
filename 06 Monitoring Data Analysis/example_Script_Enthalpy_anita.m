clear all

load waterProps;

% sourceData=ADPRead('D:\L Matlab\06 Monitoring Data Analysis\Sample Data\Solarsystem_January_Original.xls');

sourceData=ADPRead('D:\L Matlab\06 Monitoring Data Analysis\Sample Data\ALL_hourly.xlsx');

ADPGetFromHeader(sourceData.header,'Solar')

% Enthalpy going into solar collector
% Temperature
sol.n17.T = sourceData.data(:,17); % [°C]
% Mass flow
sol.n17.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n17.se = enthalpyWater(waterProps, sol.n17.T); % [kJ/kg]
% Absolute enthalpy
sol.n17.ef = sol.n17.se.*sol.n17.mf; % [kJ/s] or [kW]

% Enthalpy leaving solar collector
% Temperature
sol.n15.T = sourceData.data(:,15); % [°C]
% Mass flow
sol.n15.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n15.se = enthalpyWater(waterProps, sol.n15.T); % [kJ/kg]
% Absolute enthalpy
sol.n15.ef = sol.n15.se.*sol.n15.mf; % [kJ/s]

% Useful energy gain of solar collector
ef_solarGain = sol.n15.ef - sol.n17.ef;

% Solar irradiance onto solar collector
Gi_solar_spec = sourceData.data(:,10); % [kW/m2]
areaSolar = 100; % [m2]
Gi_solar_inc = Gi_solar_spec .* areaSolar; % [kW]

% Efficiency of solar collector
eta_solar = ef_solarGain ./ Gi_solar_inc; % [-]

% Example for enthalpy of moist air
rh_example1 = sourceData.data(:,15); % [- (%)]
T_example1 = sourceData.data(:,13); % [°C]
mf_example1 = 1000; % [kg/s]
x_example1 = humidityRatio(T_example1,101.3,rh_example1); % [kg/kg]
se_example1 = enthalpyMoistAir(T_example1,x_example1); % [kJ/kg]
ef_example1 = se_example1.*mf_example1; % [kW]

% Exhaust inlet for sorption rotor
% Column 133=RH & 132=T

% Exhaust outlet for sorption rotor
% Column 134=RH &
% Column 122=RH & 121=T

% Supply outlet for sorption rotor
% Column 124=RH & 123=T 134=T

% Supply inlet for sorption rotor

% Supply flow rate
% Col  = 114

% Exhaust flow rate
% Col  = 115

% columnNumbers = ADPGetFromHeader(sourceData.header,'°C');
% 
% temperatureData = sourceData.data(:,columnNumbers);
% 
% massFlowData = ones(size(temperatureData)).*1000; % [kg/hr]
% 
% enthData = enthalpyDataWater(temperatureData,massFlowData);
% 
% %absEnthData = specEnthData.data.*
% 
% ADPDisp(data2)

% temperature = data(:,10); % [°C]
% 
% massflow1 = ones(size(time)).*1000; % [kg/hr]
% 
% % This is the Absolute enthalpy! 
% absEnthalpy = enthalpyWater(temperature); % [kJ/kg]
% 
% enthalpyFlow = massflow1.*absEnthalpy; % []
% 
% plotyy(time,temperature,time,enthalpyFlow); %
% datetick2