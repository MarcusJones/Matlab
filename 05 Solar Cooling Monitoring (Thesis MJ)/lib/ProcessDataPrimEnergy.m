% This script compiles the primary energy consumption data

% Gas flow rate
Energy.Gas = ...
    DatedData(:,L.LPMNGas)...  % Gas consumption rate
    ;

% Electricity consumpition
Energy.Elec = ...
    DatedData(:,L.Power)...  % Electricty consumption rate
    ;

% On off status, using power > 3.5 kW
for i = 1:length(Energy.Elec)
    if Energy.Elec(i) > 2;
        Energy.OnOff(i,1) = 1;
    else 
        Energy.OnOff(i,1) = 0;
    end
end

clear i