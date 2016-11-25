% This script 
Perf.C.TC = Enthalpy.Cond.Air.In - Enthalpy.Cond.Air.Out;
Perf.C.LC = Enthalpy.Cond.WA_Air;
Perf.C.SC = ...
    Air.FlowKH.*(... % Flow rate [kg/hr]
    Air.Amb.Temp.* ... % Temp [C]
    interp1(AirProps.Temp,AirProps.SpecHeat,Air.Amb.Temp,'pchip') ... % Cp [kJ/kg/degC]
    - ...
    Air.Proc.Temp.* ... % Temp [C]
    interp1(AirProps.Temp,AirProps.SpecHeat,Air.Proc.Temp,'pchip') ... % Cp [kJ/kg/degC]
    ); % [kJ/hr]    

Perf.C.TC_SCLC = Perf.C.LC + Perf.C.SC;

Perf.C.SHR = Perf.C.SC./Perf.C.TC;

Perf.C.LHR = Perf.C.LC./Perf.C.TC;