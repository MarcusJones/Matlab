% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Flow rates

figure  % A three window plot
hold on

% Start  sub plot plot
% 2 desiccant flow rates
a1 = subplot(5,1,1);
plot(Date(TimeMask),...
        [...
        Des.C.FlowInKH(TimeMask),Des.R.FlowInKH(TimeMask)...
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Flow Rate [kg/hr]')
xlabel('Time')
ylim([0 500]);
title('Desiccant Flow Rates')
legend(...
    'Conditioner desiccant flow', 'Regenerator desiccant flow'...    
    )
% End plot

% 2 water flow rates
a2 = subplot(5,1,2);
plot(Date(TimeMask),...
        [...
        Hot.FlowKH(TimeMask),Cold.FlowKH(TimeMask)...
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Flow rate [kg/hr]')
xlabel('Time')
ylim([0 10000]);
title('Air Absolute Humdities')
legend(...
    'Hot water flow','Cold water flow'...    
    )
% End plot

% Electricity Consumption
a3 = subplot(5,1,3);
plot(Date(TimeMask),...
        ...
        Energy.Elec(TimeMask)...
        ,'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Electricity Consumption [kW]')
xlabel('Time')
title('Electricity Consumption Rate')
legend(...
    'Electricity consumption'...    
    )
% End plot

% Air Flow
a4 = subplot(5,1,4);
plot(Date(TimeMask),...
        ...
        Air.FlowKH(TimeMask)...
        ,'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Air Flow [kg/hr]')
xlabel('Time')
title('Air flow rate')
legend(...
    'Air flow rate'...    
    )
hold off

a5 = subplot(5,1,5);
plot(Date(TimeMask),...
        ...
        Energy.Gas(TimeMask)...
        ,'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Gas Consumption [LPM]')
xlabel('Time')
ylim([0 200]);
title('Gas Consumption Rate')
legend(...
    'Gas flow rate'...    
    )
linkaxes([a1 a2 a3 a4 a5], 'x');
hold off


% End plot

% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2 a3 a4