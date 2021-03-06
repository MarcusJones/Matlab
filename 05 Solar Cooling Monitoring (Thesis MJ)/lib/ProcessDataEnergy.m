% This script compiles the enthalpy change of the thermal flows

dEnthalpy.Des.RegenH = 'Desiccant Regenerator dE';
dEnthalpy.Des.CondH = 'Conditioner dE';
dEnthalpy.Hot.RegenH = 'Hot water regenerator dE';
dEnthalpy.Cold.CondH = 'Cold water conditioner dE';

dEnthalpy.Hot.Regen = ...
    Hot.FlowAvgKH .* (...      % Flow rate
    Hot.Temp(:,2).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Hot.Temp(:,2),'pchip') - ... % Enthalpy out
    Hot.Temp(:,1).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Hot.Temp(:,1),'pchip') ... % Enthalpy in
    );
    
dEnthalpy.Cold.Cond = ...
    Cold.FlowAvgKH .* (...      % Flow rate
    Cold.Temp(:,2).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Cold.Temp(:,2),'pchip') - ... % Enthalpy out
    Cold.Temp(:,1).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Cold.Temp(:,1),'pchip') ... % Enthalpy in
    );

dEnthalpy.Air.Proc = ...
    (Air.Proc(:,5) - Air.Amb(:,5)) ...
    );


Hot.HdrFlow = char(...
    'HotFlow'... 
    );

% Ambient air data
Hot.Temp = [...
    DatedData(:,L.THotIn),... % Regen inlet
    DatedData(:,L.THotOut),...  %Ambient RH
    ];

Hot.Flow = ...
    DatedData(:,L.LPMHot)...
    ;

% Write the average flow
for i = 1:length(Hot.Flow)
    if Hot.Flow(i) ~= 0;
        Hot.FlowAvg(i) = FlowAvg;
    else 
        Hot.FlowAvg(i) = 0;
    end
end

Hot.FlowAvg = Hot.FlowAvg';

clear FlowAvg