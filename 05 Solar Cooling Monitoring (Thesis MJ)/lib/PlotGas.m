a1 = subplot(2,1,1);
plot(Date(TimeMask),...
        [...
        Air.Amb.Temp(TimeMask),...
        Air.Proc.Temp(TimeMask),...
        Hot.Temp.In(TimeMask),...
        Cold.Temp.In(TimeMask),...
        Air.
        ],'LineWidth',2);
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick2 ('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
%ylim([0 100]);
title('Air, cold water, hot water temperatures, in/out')
legend(...
    'Ambient','Process','Process 2','Hot In','Cold In'...
    )
%xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])


a2 = subplot(2,1,2);
plot(Date(TimeMask),...
        ...
        Energy.Gas(TimeMask)...
        ,'LineWidth',2)
datetick ('x',DateFormat1)
ylabel('Gas Consumption [LPM]')
xlabel('Time')
ylim([0 200]);
title('Gas Consumption Rate')
%legend(...
%    'Gas flow rate'...    
%    )
linkaxes([a1 a2], 'x');
hold off


