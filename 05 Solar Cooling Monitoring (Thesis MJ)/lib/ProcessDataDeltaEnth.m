% This script compiles the enthalpy change of the thermal flows

dEnthalpy.Des.RegenH = 'Desiccant Regenerator dE';
dEnthalpy.Des.CondH = 'Conditioner dE';
dEnthalpy.Hot.RegenH = 'Hot water regenerator dE';
dEnthalpy.Cold.CondH = 'Cold water conditioner dE';

% Enthalpy change of heating water through regenerator
dEnthalpy.Hot.Regen = ...
    Hot.FlowAvgKH .* (...      % Flow rate [kg/hr]
    Hot.Temp(:,2).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Hot.Temp(:,2),'pchip') - ... % Enthalpy out
    Hot.Temp(:,1).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Hot.Temp(:,1),'pchip') ... % Enthalpy in
    ); % kJ/hr

% Enthalpy change of cooling water through conditioner
dEnthalpy.Cold.Cond = ...
    Cold.FlowAvgKH .* (...      % Flow rate [kg/hr]
    Cold.Temp(:,2).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Cold.Temp(:,2),'pchip') - ... % Enthalpy out
    Cold.Temp(:,1).*interp1(WaterProps.Temp,WaterProps.SpecHeat,Cold.Temp(:,1),'pchip') ... % Enthalpy in
    ); % kJ/hr

% Enthalpy change of process air through conditioner
dEnthalpy.Air.Proc = ...
    Air.FlowAvgKH.*( ...    % Flow rate [kg/hr]
    Air.Proc(:,5) - Air.Amb(:,5) ... % Enthalpy change
    );

% Enthalpy change of desiccant stream through conditioner
% Depends on concentration! 
dEnthalpy.Des.Cond = ...
    Des.C.FlowKH.*( ...    % Flow rate [kg/hr]
    Des.Temp(:,2).*CpLiCl(Des.Temp(:,2),Des.Conc(:,3)) - ... % Enthalpy out
    Des.Temp(:,1).*CpLiCl(Des.Temp(:,1),Des.Conc(:,1)) ... % Enthalpy in
    ); % kJ/hr

% Enthalpy change of desiccant stream through regenerator
% Depends on concentration! 
dEnthalpy.Des.Reg = ...
    Des.R.FlowKH.*( ...    % Flow rate [kg/hr]
    Des.Temp(:,4).*CpLiCl(Des.Temp(:,4),Des.Conc(:,3)) - ... % Enthalpy out
    Des.Temp(:,3).*CpLiCl(Des.Temp(:,3),Des.Conc(:,1)) ... % Enthalpy in
    ); % kJ/hr



% 
% 
% Hot.HdrFlow = char(...
%     'HotFlow'... 
%     );
% 
% % Ambient air data
% Hot.Temp = [...
%     DatedData(:,L.THotIn),... % Regen inlet
%     DatedData(:,L.THotOut),...  %Ambient RH
%     ];
% 
% Hot.Flow = ...
%     DatedData(:,L.LPMHot)...
%     ;
% 
% % Write the average flow
% for i = 1:length(Hot.Flow)
%     if Hot.Flow(i) ~= 0;
%         Hot.FlowAvg(i) = FlowAvg;
%     else 
%         Hot.FlowAvg(i) = 0;
%     end
% end
% 
% Hot.FlowAvg = Hot.FlowAvg';
% 
% clear FlowAvg