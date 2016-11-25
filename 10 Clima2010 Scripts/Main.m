
% MJones AIT - 11 Dec 2009 - Creation of file

%% Load data
clear all

newPath = 'P:\2500NEU\03 Projects\02 Current projects\2.50.00220.1.0 SolarCooling Monitor (Preisler)\Daten\Paper_clima2010';

%AllDatap1=ADPRead('b:\part1.xlsx');
%AllDatap2=ADPRead('b:\part2.xlsx');

AllDatap1=ADPRead([newPath '\part1.xlsx']);
AllDatap2=ADPRead([newPath '\part2.xlsx']);

AllData.time = AllDatap1.time;
AllData.data = [AllDatap1.data AllDatap2.data];
AllData.header = [AllDatap1.header AllDatap2.header];



clear AllDatap1 AllDatap2

%ADPDisp(AllData, 'RH')

Ln = length(AllData.time);

% Assumption;
pressure = 101300; % [Pa]
densityWater = 1000; % [kg/m³]
densityAir = 1.2; % [kg/m³]

% The index where the old sensor data ends!
MC = 6814;
Gap1 = 2527;
Gap2 = 3978;


%% Analysis: LA01 Flow Rates
% Supply; LA01-14
LA01.SupplyFlow.vfCol = ADPGetFromHeader(AllData.header,'LA01-14');
% Decision: 1 & 2
LA01.SupplyFlow.vf = vertcat(AllData.data(1:MC,LA01.SupplyFlow.vfCol(1)), AllData.data(MC+1:end,LA01.SupplyFlow.vfCol(2)));
LA01.SupplyFlow.mf = LA01.SupplyFlow.vf.*densityAir;
% Exhaust; LA01-15
LA01.ExhaustFlow.vfCol = ADPGetFromHeader(AllData.header,'LA01-15');
% Decision: Merge both
LA01.ExhaustFlow.vf = vertcat(AllData.data(1:MC,LA01.ExhaustFlow.vfCol(1)), AllData.data(MC+1:end,LA01.ExhaustFlow.vfCol(2)));
LA01.ExhaustFlow.mf = LA01.ExhaustFlow.vf.*densityAir;

%% Analysis: LA02 Flow Rates
% Supply; LA02-14
LA02.SupplyFlow.vfCol = ADPGetFromHeader(AllData.header,'LA02-14');
LA02.SupplyFlow.vf = AllData.data(:,LA02.SupplyFlow.vfCol);
LA02.SupplyFlow.mf = LA02.SupplyFlow.vf.*densityAir;
% Exhaust; LA02-15
LA02.ExhaustFlow.vfCol = ADPGetFromHeader(AllData.header,'LA02-15');
% Decision: Merge both
LA02.ExhaustFlow.vf = AllData.data(:,LA02.ExhaustFlow.vfCol);
LA02.ExhaustFlow.mf = LA02.ExhaustFlow.vf.*densityAir;

plot(AllData.time, [LA02.SupplyFlow.mf, LA02.ExhaustFlow.mf, LA01.SupplyFlow.mf, LA01.ExhaustFlow.mf])
legend('LA02.SupplyFlow.mf', 'LA02.ExhaustFlow.mf', 'LA01.SupplyFlow.mf', 'LA01.ExhaustFlow.mf')
datetick2

% LA01 & LA02 supply flows are connected to SAME SENSOR
% LA01 & LA02 exhaust are very similar over MC+ period!
% Assume LA01 & LA02 flows are SAME

LA02.SupplyFlow.mf = LA01.SupplyFlow.mf;
LA02.ExhaustFlow.mf = LA01.ExhaustFlow.mf;

%% Ambient conditions
LA01.Ambient.Tcol = ADPGetFromHeader(AllData.header,'LA01-01');
% Only operable after october!!!
LA01.Ambient.T = AllData.data(:,LA01.Ambient.Tcol);

% Now we look at the weather station data; one sensor is available with T;
LA01.Ambient.Tcol = ADPGetFromHeader(AllData.header,'WS-10');
LA01.Ambient.T = AllData.data(:,LA01.Ambient.Tcol);

LA01.Ambient.RHcol = ADPGetFromHeader(AllData.header,'LA01-06');
% Decision: Merge Columns 1 & 2!
% LA01.Ambient.RH = AllData.data(:,LA01.Ambient.RHcol);
LA01.Ambient.RH = vertcat(AllData.data(1:MC,LA01.Ambient.RHcol(1)), AllData.data(MC+1:end,LA01.Ambient.RHcol(2)));


LA01.Ambient.x = humidityRatio(LA01.Ambient.T,pressure,LA01.Ambient.RH); % [kg/kg]
% Specific enthalpy
LA01.Ambient.se = enthalpyMoistAir(LA01.Ambient.T,LA01.Ambient.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.Ambient.ef = LA01.Ambient.se .* LA01.SupplyFlow.mf;

%% Supply for LA01 system
LA01.Supply.Tcol = ADPGetFromHeader(AllData.header,'LA01-02');
% Decision; merge 1st and 2nd;
LA01.Supply.T = vertcat(AllData.data(1:MC+1,LA01.Supply.Tcol(1)), AllData.data(MC+2:end,LA01.Supply.Tcol(2)));

LA01.Supply.RHcol = ADPGetFromHeader(AllData.header,'LA01-07');
% Decision; merge 1st and 2nd;
AllData.data(:,LA01.Supply.RHcol)
LA01.Supply.RH = vertcat(AllData.data(1:MC,LA01.Supply.RHcol(1)), AllData.data(MC+1:end,LA01.Supply.RHcol(2)));


LA01.Supply.x = humidityRatio(LA01.Supply.T,pressure,LA01.Supply.RH); % [kg/kg]
% Specific enthalpy
LA01.Supply.se = enthalpyMoistAir(LA01.Supply.T,LA01.Supply.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.Supply.ef = LA01.Supply.se .* LA01.SupplyFlow.mf;

plot(AllData.time,LA01.Supply.ef - LA01.Ambient.ef)
datetick2
%% Supply for LA02 system
LA02.Supply.Tcol = ADPGetFromHeader(AllData.header,'LA02-02');

% Decision; merge 1st and 2nd;
LA02.Supply.T = vertcat(AllData.data(1:MC,LA02.Supply.Tcol(1)), AllData.data(MC+1:end,LA02.Supply.Tcol(2)));

LA02.Supply.RHcol = ADPGetFromHeader(AllData.header,'LA02-07');
% Decision; merge 1st and 2nd;
LA02.Supply.RH = vertcat(AllData.data(1:MC,LA02.Supply.RHcol(1)), AllData.data(MC+1:end,LA02.Supply.RHcol(2)));


LA02.Supply.x = humidityRatio(LA02.Supply.T,pressure,LA02.Supply.RH); % [kg/kg]
% Specific enthalpy
LA02.Supply.se = enthalpyMoistAir(LA02.Supply.T,LA02.Supply.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA02.Supply.ef = LA02.Supply.se .* LA02.SupplyFlow.mf;

plot(AllData.time,LA02.Supply.ef - LA01.Ambient.ef)
datetick2

%% Analysis: LA01 Sorption rotor
% Supply inlet for sorption rotor
% *** Temperature ***
% Sensor name: LA01-21
LA01.n2.Tcol = ADPGetFromHeader(AllData.header,'LA01-21');
% Decision: LA01-21 Zulufttemp.1 vor Sorptionsrotor
LA01.n2.T = AllData.data(:,LA01.n2.Tcol(:,2));
% *** RH ***
% sensor name: LA01-22
LA01.n2.RHcol = ADPGetFromHeader(AllData.header,'LA01-22');
% Decision: MERGE ( ALT_LA01-22 ZuluftRHvorSorptionsrotor & LA01-22 Zuluftfeuchte.1 vor Sorptionsrotor )
LA01.n2.RH = vertcat(AllData.data(1:MC,LA01.n2.RHcol(1)), AllData.data(MC+1:end,LA01.n2.RHcol(3)));
% Absolute humidity
LA01.n2.x = humidityRatio(LA01.n2.T,pressure,LA01.n2.RH); % [kg/kg]
% Specific enthalpy
LA01.n2.se = enthalpyMoistAir(LA01.n2.T,LA01.n2.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.n2.ef = LA01.n2.se .* LA01.SupplyFlow.mf;
LA01.n2.mask = zeros(length(AllData.time),1);
LA01.n2.mask(MC+1:Ln) = 1;
LA01.n2.mask = logical(LA01.n2.mask);

% Supply outlet for sorption rotor
% Temperature
% Sensor name: LA01-23
LA01.n3.Tcol = ADPGetFromHeader(AllData.header,'LA01-23');
% Decision: MERGE (ALT_LA01-23 ZuluftTemp.nachSorptionsrotor & LA01-23 Zulufttemp.1 nach Sorptionsrotor)
LA01.n3.T = vertcat(AllData.data(1:MC,LA01.n3.Tcol(1)),AllData.data(MC+1:end,LA01.n3.Tcol(3)));
% RH
% sensor name: LA01-24
LA01.n3.RHcol = ADPGetFromHeader(AllData.header,'LA01-24');
% Decision: 1st and 3rd
LA01.n3.RH = vertcat(AllData.data(1:MC,LA01.n3.RHcol(1)),AllData.data(MC+1:end,LA01.n3.RHcol(3)));
% Absolute humidity
LA01.n3.x = humidityRatio(LA01.n3.T,pressure,LA01.n3.RH); % [kg/kg]
% Specific enthalpy
LA01.n3.se = enthalpyMoistAir(LA01.n3.T,LA01.n3.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.n3.ef = LA01.n3.se .* LA01.SupplyFlow.mf;
LA01.n3.mask = ones(length(AllData.time),1);
LA01.n3.mask(Gap1:Gap2) = 0;
LA01.n3.mask = logical(LA01.n3.mask);


% Exhaust inlet for sorption rotor
% Temperature
% Sensor name: LA01-32
LA01.n23.Tcol = ADPGetFromHeader(AllData.header,'LA01-32');
% Decision: Use 2nd
LA01.n23.T = AllData.data(:,LA01.n23.Tcol(2));
% RH
% sensor name: LA01-33
LA01.n23.RHcol = ADPGetFromHeader(AllData.header,'LA01-33');
% Decision: Use 2nd
LA01.n23.RH = AllData.data(:,LA01.n23.RHcol(2));
% Absolute humidity
LA01.n23.x = humidityRatio(LA01.n23.T,pressure,LA01.n23.RH); % [kg/kg]
% Specific enthalpy
LA01.n23.se = enthalpyMoistAir(LA01.n23.T,LA01.n23.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.n23.ef = LA01.n23.se .* LA01.ExhaustFlow.mf;
LA01.n23.mask = zeros(length(AllData.time),1);
LA01.n23.mask(MC+1:Ln) = 1;
LA01.n23.mask = logical(LA01.n2.mask);


% Exhaust stream outlet for sorption rotor
% Temperature
% Sensor name: LA01-34
LA01.n24.Tcol = ADPGetFromHeader(AllData.header,'LA01-34');
% Decision: Use 2nd
LA01.n24.T = AllData.data(:,LA01.n24.Tcol(2));
% RH
% sensor name: LA01-35
LA01.n24.RHcol = ADPGetFromHeader(AllData.header,'LA01-35');
% Decision: Use 2nd
LA01.n24.RH = AllData.data(:,LA01.n24.RHcol(2));
% Absolute humidity
LA01.n24.x = humidityRatio(LA01.n24.T,pressure,LA01.n24.RH); % [kg/kg]
% Specific enthalpy
LA01.n24.se = enthalpyMoistAir(LA01.n24.T,LA01.n24.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA01.n24.ef = LA01.n24.se .* LA01.ExhaustFlow.mf;
LA01.n24.mask = ones(length(AllData.time),1);
LA01.n24.mask(Gap1:Gap2) = 0;
LA01.n24.mask = logical(LA01.n3.mask);

plot(AllData.time, [LA01.n2.mask , LA01.n3.mask , LA01.n23.mask , LA01.n24.mask]);
legend( 'LA01.n2' , 'LA01.n3 ' ,'LA01.n23' , 'LA01.n24');
datetick2



%% Analysis: LA02 Sorption rotor
% Supply inlet for sorption rotor
% *** Temperature ***
% Sensor name: LA02-21
LA02.n2.Tcol = ADPGetFromHeader(AllData.header,'LA02-21');
% Decision: 2nd
LA02.n2.T = AllData.data(:,LA02.n2.Tcol(:,2));
% *** RH ***
% sensor name: LA02-22
LA02.n2.RHcol = ADPGetFromHeader(AllData.header,'LA02-22');
% Decision: 1st
LA02.n2.RH = AllData.data(:,LA02.n2.RHcol(1));
% % Absolute humidity
LA02.n2.x = humidityRatio(LA02.n2.T,pressure,LA02.n2.RH); % [kg/kg]
% % Specific enthalpy
LA02.n2.se = enthalpyMoistAir(LA02.n2.T,LA02.n2.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA02.n2.ef = LA02.n2.se .* LA02.SupplyFlow.mf;
LA02.n2.mask = zeros(length(AllData.time),1);
LA02.n2.mask(MC+1:Ln) = 1;
LA02.n2.mask = logical(LA02.n2.mask);

% Supply outlet for sorption rotor
% Temperature
% Sensor name: LA02-23
LA02.n3.Tcol = ADPGetFromHeader(AllData.header,'LA02-23');
% Decision: 1st
LA02.n3.T = AllData.data(:,LA02.n3.Tcol(1));
% RH
% sensor name: LA02-24
LA02.n3.RHcol = ADPGetFromHeader(AllData.header,'LA02-24');
% Decision: 1st
LA02.n3.RH = AllData.data(:,LA02.n3.RHcol(1));
% Absolute humidity
LA02.n3.x = humidityRatio(LA02.n3.T,pressure,LA02.n3.RH); % [kg/kg]
% Specific enthalpy
LA02.n3.se = enthalpyMoistAir(LA02.n3.T,LA02.n3.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA02.n3.ef = LA02.n3.se .* LA02.SupplyFlow.mf;
LA02.n3.mask = zeros(length(AllData.time),1);
LA02.n3.mask(MC+1:Ln) = 1;
LA02.n3.mask = logical(LA02.n3.mask);

% Exhaust inlet for sorption rotor
% Temperature
% Sensor name: LA02-32
LA02.n23.Tcol = ADPGetFromHeader(AllData.header,'LA02-32');
% Decision: Use 2nd
LA02.n23.T = AllData.data(:,LA02.n23.Tcol(2));
% RH
% sensor name: LA02-33
LA02.n23.RHcol = ADPGetFromHeader(AllData.header,'LA02-33');
% Decision: Use 2nd
LA02.n23.RH = AllData.data(:,LA02.n23.RHcol(2));
% Absolute humidity
LA02.n23.x = humidityRatio(LA02.n23.T,pressure,LA02.n23.RH); % [kg/kg]
% Specific enthalpy
LA02.n23.se = enthalpyMoistAir(LA02.n23.T,LA02.n23.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA02.n23.ef = LA02.n23.se .* LA02.ExhaustFlow.mf;
LA02.n23.mask = zeros(length(AllData.time),1);
LA02.n23.mask(MC+1:Ln) = 1;
LA02.n23.mask = logical(LA02.n23.mask);


% Exhaust stream outlet for sorption rotor
% Temperature
% Sensor name: LA02-34
LA02.n24.Tcol = ADPGetFromHeader(AllData.header,'LA02-34');
% Decision: Use 2nd
LA02.n24.T = AllData.data(:,LA02.n24.Tcol(2));
% RH
% sensor name: LA02-35
LA02.n24.RHcol = ADPGetFromHeader(AllData.header,'LA02-35');
% Decision: Use 2nd
LA02.n24.RH = AllData.data(:,LA02.n24.RHcol(2));
% Absolute humidity
LA02.n24.x = humidityRatio(LA02.n24.T,pressure,LA02.n24.RH); % [kg/kg]
% Specific enthalpy
LA02.n24.se = enthalpyMoistAir(LA02.n24.T,LA02.n24.x); % [kJ/kg]
% Absolute enthalpy (flow)
LA02.n24.ef = LA02.n24.se .* LA02.ExhaustFlow.mf;
LA02.n24.mask = ones(length(AllData.time),1);
LA02.n24.mask(MC+1:Ln) = 1;
LA02.n24.mask = logical(LA02.n24.mask);

%Total = LA02.n2.mask & LA02.n3.mask & LA02.n23.mask & LA02.n24.mask;

%% LA02 Electrical consumption

LA02.Elec.gesamtCol = ADPGetFromHeader(AllData.header,'LA02-37');
% Decision: Use 2nd
LA02.Elec.gesamt = AllData.data(:,LA02.Elec.gesamtCol);

%% LA02 Hot Water Consumption


LA02.HW.EMeterCol = ADPGetFromHeader(AllData.header,'LA02-40');
% Decision: Use 2nd
LA02.HW.EMeter = AllData.data(:,LA02.HW.EMeterCol);


LA02.HW.TinCol = ADPGetFromHeader(AllData.header,'LA02-45');
% Decision: Use 2nd
LA02.HW.Tin = AllData.data(:,LA02.HW.TinCol);

LA02.HW.ToutCol = ADPGetFromHeader(AllData.header,'LA02-49');
% Decision: Use 2nd
LA02.HW.Tout = AllData.data(:,LA02.HW.ToutCol);

LA02.HW.Pump1Col = ADPGetFromHeader(AllData.header,'x3');
% Decision: Use 2nd
LA02.HW.Tout = AllData.data(:,LA02.HW.ToutCol);


%% Analysis: Solar thermal flow rates
sol.Flow1.UCol = ADPGetFromHeader(AllData.header,'Solar-01');
sol.Flow1.U = AllData.data(:,sol.Flow1.UCol);

sol.Flow1.iUsCol = ADPGetFromHeader(AllData.header,'Solar-02');
sol.Flow1.iUs = AllData.data(:,sol.Flow1.iUsCol);

sol.Flow1.PresCol = ADPGetFromHeader(AllData.header,'Solar-03');
sol.Flow1.Pres = AllData.data(:,sol.Flow1.PresCol);

sol.Flow1.CntrlCol = ADPGetFromHeader(AllData.header,'Solar-04');
sol.Flow1.Cntrl = AllData.data(:,sol.Flow1.CntrlCol);

sol.Flow2.UCol = ADPGetFromHeader(AllData.header,'Solar-05');
sol.Flow2.U = AllData.data(:,sol.Flow2.UCol);

sol.Flow2.iUsCol = ADPGetFromHeader(AllData.header,'Solar-06');
sol.Flow2.iUs = AllData.data(:,sol.Flow2.iUsCol);

sol.Flow2.CntrlCol = ADPGetFromHeader(AllData.header,'Solar-07');
sol.Flow2.Cntrl = AllData.data(:,sol.Flow2.CntrlCol);

plot(AllData.time, [sol.Flow1.Cntrl, sol.Flow2.Cntrl]);
datetick2

%% Analysis: Solar thermal fluid
load waterProps;
waterProps = WaterProps;

% Enthalpy going into solar collector
% Temperature
sol.n3.Tcol = ADPGetFromHeader(AllData.header,'Solar-27');
sol.n3.T = AllData.data(:,sol.n3.Tcol);
% Mass flow
sol.n3.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n3.se = enthalpyWater(waterProps, sol.n3.T); % [kJ/kg]
% Absolute enthalpy
sol.n3.ef = sol.n3.se.*sol.n3.mf; % [kJ/s] or [kW]

% Enthalpy leaving solar collector
% Temperature
sol.n1.Tcol = ADPGetFromHeader(AllData.header,'Solar-24');
sol.n1.T = AllData.data(:,sol.n1.Tcol);
% Mass flow
sol.n1.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n1.se = enthalpyWater(waterProps, sol.n1.T); % [kJ/kg]
% Absolute enthalpy
sol.n1.ef = sol.n1.se.*sol.n1.mf; % [kJ/s]

% % Useful energy gain of solar collector
% ef_solarGain = sol.n15.ef - sol.n17.ef;
% 
% % Solar irradiance onto solar collector
% Gi_solar_spec = sourceData.data(:,10); % [kW/m2]
% areaSolar = 100; % [m2]
% Gi_solar_inc = Gi_solar_spec .* areaSolar; % [kW]
% 
% % Efficiency of solar collector
% eta_solar = ef_solarGain ./ Gi_solar_inc; % [-]
% 
% 
% plot(AllData.time, sol.n3.T )
% datetick2




% 
% % Assumption;
% pressure = 101300; % [Pa]
% 
% %% Data: Flow rates
% % Fresh air flow rate
% % Flow rate
% % Sensor name: LA02-14
% LA01.FreshFlow.vfCol = ADPGetFromHeader(LA01data.header,'LA01-14');
% LA01.FreshFlow.vf = LA01data.data(:,LA01.FreshFlow.vfCol);
% % Assumption (density);
% LA01.FreshFlow.mf = LA01.FreshFlow.vf.* 1.2;
% 
% % Exhaust flow rate
% % Flow rate
% % Sensor name: LA01-14
% LA01.ExhFlow.vfCol = ADPGetFromHeader(LA01data.header,'LA01-15');
% LA01.ExhFlow.vf = LA01data.data(:,LA01.ExhFlow.vfCol);
% % Assumption (density);
% LA01.ExhFlow.mf = LA01.ExhFlow.vf .* 1.2;
% 
% %% Data: Statepoints
% % Supply inlet for sorption rotor
% % Temperature
% % Sensor name: LA01-21
% LA01.FreshIn.Tcol = ADPGetFromHeader(LA01data.header,'LA01-21');
% LA01.FreshIn.T = LA01data.data(:,LA01.FreshIn.Tcol);
% % RH
% % sensor name: LA01-22
% LA01.FreshIn.RHcol = ADPGetFromHeader(LA01data.header,'LA01-22');
% LA01.FreshIn.RH = LA01data.data(:,LA01.FreshIn.RHcol);
% % Absolute humidity
% LA01.FreshIn.x = humidityRatio(LA01.FreshIn.T,pressure,LA01.FreshIn.RH); % [kg/kg]
% % Specific enthalpy
% LA01.FreshIn.se = enthalpyMoistAir(LA01.FreshIn.T,LA01.FreshIn.x); % [kJ/kg]
% % Absolute enthalpy (flow)
% LA01.FreshIn.ef = LA01.FreshIn.se .* LA01.FreshFlow.mf;
% 
% 
% % Supply outlet for sorption rotor
% % Temperature
% % Sensor name: LA01-23
% LA01.FreshOut.Tcol = ADPGetFromHeader(LA01data.header,'LA01-23');
% LA01.FreshOut.T = LA01data.data(:,LA01.FreshOut.Tcol);
% % RH
% % sensor name: LA01-24
% LA01.FreshOut.RHcol = ADPGetFromHeader(LA01data.header,'LA01-24');
% LA01.FreshOut.RH = LA01data.data(:,LA01.FreshOut.RHcol);
% % Absolute humidity
% LA01.FreshOut.x = humidityRatio(LA01.FreshOut.T,pressure,LA01.FreshOut.RH); % [kg/kg]
% % Specific enthalpy
% LA01.FreshOut.se = enthalpyMoistAir(LA01.FreshOut.T,LA01.FreshOut.x); % [kJ/kg]
% % Absolute enthalpy (flow)
% LA01.FreshOut.ef = LA01.FreshOut.se .* LA01.FreshFlow.mf;
% 
% 
% % Exhaust inlet for sorption rotor
% % Temperature
% % Sensor name: LA01-32
% LA01.ExhIn.Tcol = ADPGetFromHeader(LA01data.header,'LA01-32');
% LA01.ExhIn.T = LA01data.data(:,LA01.ExhIn.Tcol);
% % RH
% % sensor name: LA01-33
% LA01.ExhIn.RHcol = ADPGetFromHeader(LA01data.header,'LA01-33');
% LA01.ExhIn.RH = LA01data.data(:,LA01.ExhIn.RHcol);
% % Absolute humidity
% LA01.ExhIn.x = humidityRatio(LA01.ExhIn.T,pressure,LA01.ExhIn.RH); % [kg/kg]
% % Specific enthalpy
% LA01.ExhIn.se = enthalpyMoistAir(LA01.ExhIn.T,LA01.ExhIn.x); % [kJ/kg]
% % Absolute enthalpy (flow)
% LA01.ExhIn.ef = LA01.ExhIn.se .* LA01.ExhFlow.mf;
% 
% 
% % Exhaust stream outlet for sorption rotor
% % Temperature
% % Sensor name: LA01-34
% LA01.ExhOut.Tcol = ADPGetFromHeader(LA01data.header,'LA01-34');
% LA01.ExhOut.T = LA01data.data(:,LA01.ExhOut.Tcol);
% % RH
% % sensor name: LA01-35
% LA01.ExhOut.RHcol = ADPGetFromHeader(LA01data.header,'LA01-35');
% LA01.ExhOut.RH = LA01data.data(:,LA01.ExhOut.RHcol);
% % Absolute humidity
% LA01.ExhOut.x = humidityRatio(LA01.ExhOut.T,pressure,LA01.ExhOut.RH); % [kg/kg]
% % Specific enthalpy
% LA01.ExhOut.se = enthalpyMoistAir(LA01.ExhOut.T,LA01.ExhOut.x); % [kJ/kg]
% % Absolute enthalpy (flow)
% LA01.ExhOut.ef = LA01.ExhOut.se .* LA01.ExhFlow.mf;
% 
% 
% %% Initial analysis
% % Exhaust and Fresh air flow rates for LA01
% figure
% plot(LA01data.time,[LA01.FreshFlow.mf,LA01.ExhFlow.mf])
% datetick2
% legend('Exhuast stream flow','Fresh air stream flow')
% title('Exhaust and Fresh air flow rates for LA01')
% ylabel('kg/hr')
% 
% % Sorption rotor temperatures for LA01
% figure
% plot(LA01data.time,[LA01.FreshIn.T,LA01.FreshOut.T,LA01.ExhIn.T,LA01.ExhOut.T])
% datetick2
% legend('Fresh in','Fresh out','Exh in', 'Exh out')
% title('Sorption rotor temperatures for LA01')
% ylabel('°C')
% 
% % Sorption rotor absolute humidities for LA01
% figure
% plot(LA01data.time,[LA01.FreshIn.x,LA01.FreshOut.x,LA01.ExhIn.x,LA01.ExhOut.x])
% datetick2
% legend('Fresh in','Fresh out','Exh in', 'Exh out')
% title('Sorption rotor absolute humidities for LA01')
% ylabel('kg/kg')
% 
% %% First Law analysis
% % Enthalpy change across fresh air
% LA01.Fresh.DetlaEf = LA01.FreshOut.ef - LA01.FreshIn.ef;
% figure 
% plot(LA01data.time,LA01.Fresh.DetlaEf);
% datetick2
% title('Enthalpy change across fresh air stream of sorption rotor, LA01')
% ylabel('kJ/hr')
% 
% % Enthalpy change across exhaust air
% LA01.Exhaust.DetlaEf = LA01.ExhOut.ef - LA01.ExhIn.ef;
% figure 
% plot(LA01data.time,LA01.Exhaust.DetlaEf);
% datetick2
% title('Enthalpy change across exhaust air stream of sorption rotor, LA01')
% ylabel('kJ/hr')
% 
% % Enthalpy balance for sorption rotor 
% LA01.RotorEnthalpyBalance = LA01.FreshIn.ef + LA01.ExhIn.ef - LA01.FreshOut.ef - LA01.ExhOut.ef;

% clear all
% 
% load waterProps;
% 
% % sourceData=ADPRead('D:\L Matlab\06 Monitoring Data Analysis\Sample Data\Solarsystem_January_Original.xls');
% 
% sourceData=ADPRead('D:\L Matlab\06 Monitoring Data Analysis\Sample Data\ALL_hourly.xlsx');
% 
% ADPGetFromHeader(sourceData.header,'Solar')
% 

% 
% % Example for enthalpy of moist air
% rh_example1 = sourceData.data(:,15); % [- (%)]
% T_example1 = sourceData.data(:,13); % [°C]
% mf_example1 = 1000; % [kg/s]
% x_example1 = humidityRatio(T_example1,101.3,rh_example1); % [kg/kg]
% se_example1 = enthalpyMoistAir(T_example1,x_example1); % [kJ/kg]
% ef_example1 = se_example1.*mf_example1; % [kW]
% 
% % Exhaust inlet for sorption rotor
% % Column 133=RH & 132=T
% 
% % Exhaust outlet for sorption rotor
% % Column 134=RH &
% % Column 122=RH & 121=T
% 
% % Supply outlet for sorption rotor
% % Column 124=RH & 123=T 134=T
% 
% % Supply inlet for sorption rotor
% 
% % Supply flow rate
% % Col  = 114
% 
% % Exhaust flow rate
% % Col  = 115
% 
% % columnNumbers = ADPGetFromHeader(sourceData.header,'°C');
% % 
% % temperatureData = sourceData.data(:,columnNumbers);
% % 
% % massFlowData = ones(size(temperatureData)).*1000; % [kg/hr]
% % 
% % enthData = enthalpyDataWater(temperatureData,massFlowData);
% % 
% % %absEnthData = specEnthData.data.*
% % 
% % ADPDisp(data2)
% 
% % temperature = data(:,10); % [°C]
% % 
% % massflow1 = ones(size(time)).*1000; % [kg/hr]
% % 
% % % This is the Absolute enthalpy! 
% % absEnthalpy = enthalpyWater(temperature); % [kJ/kg]
% % 
% % enthalpyFlow = massflow1.*absEnthalpy; % []
% % 
% % plotyy(time,temperature,time,enthalpyFlow); %
% % datetick2