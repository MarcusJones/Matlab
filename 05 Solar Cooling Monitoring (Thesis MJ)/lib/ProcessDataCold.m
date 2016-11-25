% This script compiles the cold water state data
% Cold.Temp.In [C]
% Cold.Temp.Out [C]
% Cold.Flow [L/m]
% Cold.FlowAvg [L/m]
% Cold.FlowKH [kg/h]

Cold.Temp.In = DatedData(:,L.TCoolIn);
Cold.Temp.Out = DatedData(:,L.TCoolOut);

% Original flow data
Cold.FlowLPM = DatedData(:,L.LPMCool); % [L/min]

% Smooth out data
j = 1;
AvgPrd = 6; % Even number!
for i = 1:AvgPrd:length(DatedData(:,L.LPMCool))-AvgPrd
    StartIndx = i;
    EndIndx = i + AvgPrd;
    ColdAverage(j) = SimpleAverage(DatedData(:,L.LPMCool), 0, StartIndx, EndIndx);
    ColdDate(j) = DatedData(i+AvgPrd/2,1);
    j = j + 1;
end

clear j i StartIndx EndIndx AvgPrd

% Interpolate
Cold.FlowLPM_Avg = MinuteFit(ColdDate,ColdAverage,DatedData(:,1));

clear ColdAverage ColdDate 

% Convert from [L/m] to [kg/h]
Cold.FlowKH = Cold.FlowLPM_Avg./1000.*...
    interp1(WaterProps.Temp,WaterProps.Dens,Cold.Temp.Out,'pchip').*60;

clear FlowAvg Cold.FlowAvg i 