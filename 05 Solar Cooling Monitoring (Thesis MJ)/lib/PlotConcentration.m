% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Temps, RHs, Concentrations
figure  % A three window plot
hold on

% Start  sub plot plot
% 6 temperatures; ambient - process, cool in - out, hot in - out
a1 = subplot(3,1,1);
plot(DatedData(TimeMask,1),...
        [...
        DatedData(TimeMask,L.Tamb_C),DatedData(TimeMask,L.T_fan),...
        DatedData(TimeMask,L.TCoolIn),DatedData(TimeMask,L.TCoolOut),...
        DatedData(TimeMask,L.THotIn),DatedData(TimeMask,L.THotOut)...
        ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Temperature [C]')
xlabel('Time')
ylim([0 100])
title('Air, cold water, hot water temperatures, in/out')
legend(...
    Headers(L.Tamb_C,:),Headers(L.T_fan,:),...
    Headers(L.TCoolIn,:),Headers(L.TCoolOut,:),...
    Headers(L.THotIn,:),Headers(L.THotOut,:)...
    )
% End plot

% Start sub plot
% 3 Relative humidities; ambient, process, calibrated
a2 = subplot(3,1,2);
plot(DatedData(TimeMask,1),[...
    DatedData(TimeMask,L.RHamb)...
    DatedData(TimeMask,L.RH_fan)...
    DatedData(TimeMask,L.RHcal)...
    ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Relative Humidity [%]')
xlabel('Time')
ylim([0 100])
title('Relative humidity change in air stream (RHcal not currently used)')
legend(...
    Headers(L.RHamb,:),...
    Headers(L.RH_fan,:),...
    Headers(L.RHcal,:)...
    )
% End plot

% Start sub plot
% 4 Flow rates; DesC, DesR, Cool, Hot

a3 = subplot(3,1,3);
plot(DatedData(TimeMask,1),[...
    Des.Conc(TimeMask,1),...
    Des.Conc(TimeMask,2),...
    Des.Conc(TimeMask,3),...
    Des.Conc(TimeMask,4)...
    ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',15)
ylabel('Desiccant Concentration [%]')
xlabel('Time')
title('Concentrations at conditioner/regenerator inlet/outlet')
legend(...
    Des.ConcHdr(1,:),...
    Des.ConcHdr(2,:),...
    Des.ConcHdr(3,:),...
    Des.ConcHdr(4,:)...
    )
linkaxes([a1 a2 a3], 'x');
grid on
hold off

% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2 a3