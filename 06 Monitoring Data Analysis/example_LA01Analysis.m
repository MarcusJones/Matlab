% This analysis only meant for an EXAMPLE of a 1st law analysis of the
% LA01 air handling system of ENERGYbase!
% MJones AIT - 20 Nov 2009 - Creation of file
% MJones AIT - 25 Nov 2009 - Update

%% Load data
clear all

LA01data=ADPRead('D:\L Scripts\02L Matlab\06 Monitoring Data Analysis\Sample Data\LA01test.xls');

% Assumption;
pressure = 101300; % [Pa]

%% Data: Flow rates
% Fresh air flow rate
% Flow rate
% Sensor name: LA01-14
LA01.FreshFlow.vfCol = ADPGetFromHeader(LA01data.header,'LA01-14');
LA01.FreshFlow.vf = LA01data.data(:,LA01.FreshFlow.vfCol);
% Assumption (density);
LA01.FreshFlow.mf = LA01.FreshFlow.vf.* 1.2;

% Exhaust flow rate
% Flow rate
% Sensor name: LA01-14
LA01.ExhFlow.vfCol = ADPGetFromHeader(LA01data.header,'LA01-15');
LA01.ExhFlow.vf = LA01data.data(:,LA01.ExhFlow.vfCol);
% Assumption (density);
LA01.ExhFlow.mf = LA01.ExhFlow.vf .* 1.2;

%% Data: Statepoints
% Supply inlet for sorption rotor
% Temperature
% Sensor name: LA01-21
LA01.FreshIn.Tcol = ADPGetFromHeader(LA01data.header,'LA01-21');
LA01.FreshIn.T = LA01data.data(:,LA01.FreshIn.Tcol);
% RH
% sensor name: LA01-22
LA01.FreshIn.RHcol = ADPGetFromHeader(LA01data.header,'LA01-22');
LA01.FreshIn.RH = LA01data.data(:,LA01.FreshIn.RHcol);
% Absolute humidity
LA01.FreshIn.x = humidityRatio(LA01.FreshIn.T,pressure,LA01.FreshIn.RH); % [kg/kg]
% Specific enthalpy
LA01.FreshIn.se = enthalpyMoistAir(LA01.FreshIn.T,LA01.FreshIn.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.FreshIn.ef = LA01.FreshIn.se .* LA01.FreshFlow.mf;


% Supply outlet for sorption rotor
% Temperature
% Sensor name: LA01-23
LA01.FreshOut.Tcol = ADPGetFromHeader(LA01data.header,'LA01-23');
LA01.FreshOut.T = LA01data.data(:,LA01.FreshOut.Tcol);
% RH
% sensor name: LA01-24
LA01.FreshOut.RHcol = ADPGetFromHeader(LA01data.header,'LA01-24');
LA01.FreshOut.RH = LA01data.data(:,LA01.FreshOut.RHcol);
% Absolute humidity
LA01.FreshOut.x = humidityRatio(LA01.FreshOut.T,pressure,LA01.FreshOut.RH); % [kg/kg]
% Specific enthalpy
LA01.FreshOut.se = enthalpyMoistAir(LA01.FreshOut.T,LA01.FreshOut.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.FreshOut.ef = LA01.FreshOut.se .* LA01.FreshFlow.mf;


% Exhaust inlet for sorption rotor
% Temperature
% Sensor name: LA01-32
LA01.ExhIn.Tcol = ADPGetFromHeader(LA01data.header,'LA01-32');
LA01.ExhIn.T = LA01data.data(:,LA01.ExhIn.Tcol);
% RH
% sensor name: LA01-33
LA01.ExhIn.RHcol = ADPGetFromHeader(LA01data.header,'LA01-33');
LA01.ExhIn.RH = LA01data.data(:,LA01.ExhIn.RHcol);
% Absolute humidity
LA01.ExhIn.x = humidityRatio(LA01.ExhIn.T,pressure,LA01.ExhIn.RH); % [kg/kg]
% Specific enthalpy
LA01.ExhIn.se = enthalpyMoistAir(LA01.ExhIn.T,LA01.ExhIn.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.ExhIn.ef = LA01.ExhIn.se .* LA01.ExhFlow.mf;


% Exhaust stream outlet for sorption rotor
% Temperature
% Sensor name: LA01-34
LA01.ExhOut.Tcol = ADPGetFromHeader(LA01data.header,'LA01-34');
LA01.ExhOut.T = LA01data.data(:,LA01.ExhOut.Tcol);
% RH
% sensor name: LA01-35
LA01.ExhOut.RHcol = ADPGetFromHeader(LA01data.header,'LA01-35');
LA01.ExhOut.RH = LA01data.data(:,LA01.ExhOut.RHcol);
% Absolute humidity
LA01.ExhOut.x = humidityRatio(LA01.ExhOut.T,pressure,LA01.ExhOut.RH); % [kg/kg]
% Specific enthalpy
LA01.ExhOut.se = enthalpyMoistAir(LA01.ExhOut.T,LA01.ExhOut.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.ExhOut.ef = LA01.ExhOut.se .* LA01.ExhFlow.mf;


%% Initial analysis
% Exhaust and Fresh air flow rates for LA01
figure
plot(LA01data.time,[LA01.FreshFlow.mf,LA01.ExhFlow.mf])
datetick2
legend('Exhuast stream flow','Fresh air stream flow')
title('Exhaust and Fresh air flow rates for LA01')
ylabel('kg/hr')

% Sorption rotor temperatures for LA01
figure
plot(LA01data.time,[LA01.FreshIn.T,LA01.FreshOut.T,LA01.ExhIn.T,LA01.ExhOut.T])
datetick2
legend('Fresh in','Fresh out','Exh in', 'Exh out')
title('Sorption rotor temperatures for LA01')
ylabel('°C')

% Sorption rotor absolute humidities for LA01
figure
plot(LA01data.time,[LA01.FreshIn.x,LA01.FreshOut.x,LA01.ExhIn.x,LA01.ExhOut.x])
datetick2
legend('Fresh in','Fresh out','Exh in', 'Exh out')
title('Sorption rotor absolute humidities for LA01')
ylabel('kg/kg')

%% First Law analysis
% Enthalpy change across fresh air
LA01.Fresh.DetlaEf = LA01.FreshOut.ef - LA01.FreshIn.ef;
figure 
plot(LA01data.time,LA01.Fresh.DetlaEf);
datetick2
title('Enthalpy change across fresh air stream of sorption rotor, LA01')
ylabel('kJ/hr')

% Enthalpy change across exhaust air
LA01.Exhaust.DetlaEf = LA01.ExhOut.ef - LA01.ExhIn.ef;
figure 
plot(LA01data.time,LA01.Exhaust.DetlaEf);
datetick2
title('Enthalpy change across exhaust air stream of sorption rotor, LA01')
ylabel('kJ/hr')

% Enthalpy balance for sorption rotor 
LA01.RotorEnthalpyBalance = LA01.FreshIn.ef + LA01.ExhIn.ef - LA01.FreshOut.ef - LA01.ExhOut.ef;