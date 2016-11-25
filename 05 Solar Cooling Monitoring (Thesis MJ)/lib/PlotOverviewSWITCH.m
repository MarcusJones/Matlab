% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Temps, RHs, Flow rates
figure  % A three window plot
hold on

% Start  sub plot plot
% 6 temperatures; ambient - process, cool in - out, hot in - out
a1 = subplot(2,1,1);
plot(DatedData(TimeMask,1),...
        [...
        DatedData(TimeMask,L.Tamb_C),DatedData(TimeMask,L.T_fan),...

        ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Temperature [C]')
xlabel('Time')
ylim([0 40]);
title('Temperature change in airstream')
legend(...
    'Ambient','Process',...
    Headers(L.TCoolIn,:),Headers(L.TCoolOut,:),...
    Headers(L.THotIn,:),Headers(L.THotOut,:)...
    )
% End plot

% Start sub plot
% 3 Relative humidities; ambient, process, calibrated
a2 = subplot(2,1,2);
plot(DatedData(TimeMask,1),[...
    DatedData(TimeMask,L.RHamb)...
    DatedData(TimeMask,L.RH_fan)...

    ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Relative Humidity [%]')
xlabel('Time')
ylim([0 100]);
title('Relative humidity change in air stream')
legend(...
    'Ambient',...
    'Process'...
    )
% End plot

% Start sub plot
% 4 Flow rates; DesC, DesR, Cool, Hot
a3 = subplot(3,1,3);
plot(DatedData(TimeMask,1),[...
    DatedData(TimeMask,L.LPMdesC),DatedData(TimeMask,L.LPMdesR),...
    DatedData(TimeMask,L.LPMCool),DatedData(TimeMask,L.LPMHot)...
    ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Flow Rates [LPM]')
xlabel('Time')
ylim([0 200]);
title('Flow rates - need to average hot/cold meters')
legend(...
    Headers(L.LPMdesC,:),Headers(L.LPMdesR,:),...
    Headers(L.LPMCool,:),Headers(L.LPMHot,:)...
    )
linkaxes([a1 a2 a3], 'x');
hold off

% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2 a3