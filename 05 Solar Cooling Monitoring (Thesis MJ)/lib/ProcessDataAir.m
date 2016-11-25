% This script generates air state properties at three positions within the
% air flow path using the ambient, and two outlet T/RH sensors
% RH and T data is expanded to include W (humidity ratio) and H (enthalpy)
% using Ashrae correlations found in the following functions;
% function EnthalpyAir=EnthalpyAir(TC,W)
% function Wratio=Wratio(T,p,phi)
% Air.Amb - Ambient Sensor
% Air.Proc1 - AIL supplied sensor
% Air.Proc2 - SCL supplied sensor
% Air.Proc - Best sensor values, see '080611 Calibration report.pdf'

% Assumption;
AmbPres = 101300; % [Pa] Atmospheric pressure is constant at 1 atm

% Ambient air data
Air.Amb.Pres = AmbPres*ones(length(DatedData(:,1)),1);
Air.Amb.Temp = DatedData(:,L.Tamb_C);
Air.Amb.RH = DatedData(:,L.RHamb);
Air.Amb.W = Wratio(DatedData(:,L.Tamb_C),AmbPres,DatedData(:,L.RHamb));
Air.Amb.H = EnthalpyAir(DatedData(:,L.Tamb_C),Air.Amb.W);

% Original AIL supplied sensor
Air.Proc1.Pres = real(AmbPres*ones(length(DatedData(:,1)),1));
Air.Proc1.Temp = real(DatedData(:,L.T_fan));
Air.Proc1.RH = real(DatedData(:,L.RH_fan));
Air.Proc1.W = real(Wratio(DatedData(:,L.T_fan),AmbPres,DatedData(:,L.RH_fan)));
Air.Proc1.H = EnthalpyAir(DatedData(:,L.T_fan),Air.Proc1.W);

% Calibrated sensor air data (in duct)
Air.Proc2.Pres = AmbPres*ones(length(DatedData(:,1)),1);
Air.Proc2.Temp = DatedData(:,L.Tcal);
Air.Proc2.RH = DatedData(:,L.RHcal);
Air.Proc2.W = Wratio(DatedData(:,L.Tcal),AmbPres,DatedData(:,L.RHcal));
Air.Proc2.H = EnthalpyAir(DatedData(:,L.Tcal),Air.Proc2.W);

% This is the final outlet condition used, based on the sensor calibration
Air.Proc.Pres = Air.Proc1.Pres; % This is assumed pressure
Air.Proc.Temp = Air.Proc2.Temp; % Use SCL sensor
Air.Proc.RH = Air.Proc1.RH; % Use the AIL sensor
Air.Proc.W = Wratio(Air.Proc.Temp,AmbPres,Air.Proc.RH);
Air.Proc.H = EnthalpyAir(Air.Proc.Temp,Air.Proc.W);

% A 10k thermistor was added to the outlet of the regenerator
Air.Reg.Temp = DatedData(:,39);

% Flow rate as given by AMS
Air.FlowLPS = ...
    DatedData(:,L.RuskinAir)...   % 
    ;

% Convert flow rate [L/s] to [kg/h]
Air.FlowKH = Air.FlowLPS * 60 * 60 / 1000 .* ... % Convert to m3/hr
    interp1(AirProps.Temp,AirProps.Dens,... % Lookup table
    (Air.Proc.Temp + Air.Amb.Temp)/2, ... % Average air temperature
    'pchip');

% Recalibrate the air flow - AMS gives inacurate data
Air.FlowKH = Air.FlowKH .* 1.54;

% A regenerator flow rate of 430 cfm was measured 
Air.FlowRegenKH = 430 * 0.4718 * 60 * 60 / 1000 .* ... % Convert to m3/hr
    interp1(AirProps.Temp,AirProps.Dens,... % Lookup table
    (Air.Reg.Temp + Air.Amb.Temp)./2, ... % This is the average air temperature
    'pchip');

Air.FlowRegenKH = Air.FlowRegenKH.*(Air.Reg.Temp./Air.Reg.Temp);

clear AmbPres