% This script compiles the performance parameters

% Water sorption rates
% For conditioner, we can calculate 
Perf.C.WR_Air = Air.FlowInKH.*(Air.Amb.W - Air.Proc.W); % [kg/hr]
Perf.C.WA_Des = Des.C.FlowInKH.*(Des.C.ConcIn./Des.C.ConcOut-1); % [kg/hr]

% Update desiccant data by correcting the outlet flow rate 
Des.C.FlowOutKH = Des.C.FlowInKH + Perf.C.WR_Air;

% Perf.Cond.WA_Air = No sensors for air flow temp/rh change!
Perf.R.WR_Des = Des.R.FlowInKH.*(Des.R.ConcOut./Des.R.ConcIn-1); % [kg/hr]
Des.R.FlowOutKH = Des.R.FlowInKH - Perf.R.WR_Des;

%Perf.Cond.LatentCooling = 