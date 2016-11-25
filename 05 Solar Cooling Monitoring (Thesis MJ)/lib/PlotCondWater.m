% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - 
figure  % A three window plot
hold on

% Start  sub plot plot
% Water absorption in conditioner
a1 = subplot(2,1,1);
plot(Date(TimeMask),...
        [...
            Perf.C.WA_Air(TimeMask), ...
            Perf.C.WA_Des(TimeMask)
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Water flow [kg/hr]')
xlabel('Time')
ylim([0 60]);
title('Conditioner Water Absorption')
legend(...
    'Change in air','Change in solution'...
    )
% End plot

a2 = subplot(2,1,2);
plot(Date(TimeMask),...
        [...
           Perf.C.WA_Air(TimeMask) - ...
            Perf.C.WA_Des(TimeMask)
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Water flow [kg/hr]')
xlabel('Time')
ylim([0 60]);
title('Conditioner Water Balance Variation')
legend(...
    'Air - Solution'...
    )
% End plot

linkaxes([a1 a2], 'x');
hold off

% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2