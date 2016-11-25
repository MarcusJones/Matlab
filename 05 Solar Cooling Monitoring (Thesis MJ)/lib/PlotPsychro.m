% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Temps, Ws, Enthalpies
figure  % A three window plot
hold on

% Start sub plot
% 3 Relative humidities; ambient, process, calibrated
a1 = subplot(3,1,1);
 plot(DatedData(TimeMask,1),[...
     Air.Amb(TimeMask,2),...
     Air.Proc(TimeMask,2)...
     ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',13)
ylabel('Temperature [C]')
xlabel('Time')
ylim([0 50])
title('Relative humidity change in air stream (RHcal not currently used)')
legend(...
    Air.HdrAmb(2,:),...
    Air.HdrProc(2,:)...
    )
% End plot

% Start sub plot
% W
a2 = subplot(3,1,2);
plot(DatedData(TimeMask,1),[...
    Air.Amb(TimeMask,4),...
    Air.Proc(TimeMask,4)...
    ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Absolute Humidity Ratio [kg/kg]')
xlabel('Time')
ylim([0 .02])
title('Humidity ratio channge through air stream')
legend(...
    Air.HdrAmb(4,:),...
    Air.HdrProc(4,:)...
    )

hold off

% Start sub plot
% h
a3 = subplot(3,1,3);
plot(DatedData(TimeMask,1),[...
    Air.Amb(TimeMask,5),...
    Air.Proc(TimeMask,5)...
    ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Enthalpy [kJ/kg]')
xlabel('Time')
ylim([0 75])
title('Enthalpy change in air stream')
legend(...
    Air.HdrAmb(5,:),...
    Air.HdrProc(5,:)...
    )
linkaxes([a1 a2 a3], 'x');
hold off