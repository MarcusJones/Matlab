
% Load first range of dates for data
% datestr(DatedData(length(DatedData(:,1)),1) - DatedData(1,1) )
% N = datenum(Y, M, D, H, MN, S)
Start = datenum(2008, 7, 11, 7, 0, 0);
Start = find(Date==Start); % Use specified start
%Start = 1;                           % Or just use start of data 
End =   datenum(2008, 7, 28, 18, 0, 0);
End = find(Date==End); % Use specified ending
%End = length(Date); % Or just use the end of data
TimeMask = Start:End;
DateFormat1 = 0;


datenum(2008, 7, 9, 16, 0, 0)


% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Temps, RHs, Conc
figure  % A three window plot
hold on

% Start  sub plot plot
% temperatures; 
a1 = subplot(5,1,1);
plot(Date(TimeMask),...
        [...
        Air.Amb.Temp(TimeMask),...
        Air.Proc.Temp(TimeMask),...
        Hot.Temp.In(TimeMask),...
        Cold.Temp.In(TimeMask)...
        ],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick2 %('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
ylim([0 100]);
title('Air, cold water, hot water temperatures, in/out')
legend(...
    'Ambient','Process','Process 2','Hot In','Cold In'...
    )
xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])
% End plot

% Start sub plot
% 3 Relative humidities; ambient, process, calibrated
a2 = subplot(5,1,2);
plot(Date(TimeMask,1),[...
    Air.Amb.W(TimeMask).*1000,...
    Air.Proc.W(TimeMask).*1000,...
    ],'LineWidth',2)
ylabel('Relative Humidity [%]')
xlabel('Time')
%ylim([0 100]);
title('Relative humidities  in air stream')
legend(...
    'Ambient RH', ...
    'Process RH', ...
    'Process RH 2'... 
    )
xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])
datetick('x',DateFormat1)
% End plot

% Start sub plot
% 
a3 = subplot(5,1,3);
plot(Date(TimeMask),[...
    Des.C.ConcIn(TimeMask),Des.C.ConcOut(TimeMask),...
    Des.R.ConcIn(TimeMask),Des.R.ConcOut(TimeMask)...
    ],'LineWidth',2)
ylabel('Concentration [%]')
xlabel('Time')
ylim([20 40]);
title('Desiccant Concentration ')
legend(...
 'C in','C out','R in','R out'...
    )
xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])
datetick('x',DateFormat1)
% End plot

xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])    
% Start sub plot
% 
a4 = subplot(5,1,4);
plot(Date(TimeMask),[...
    Hot.FlowKH(TimeMask),Cold.FlowKH(TimeMask) ...
],'LineWidth',2)
ylabel('Flow [kg/hr]')
xlabel('Time')
% ylim([0 200]);
title('Water flow rates ')
legend(...
 'Hot','Cold'...
    )
xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])
datetick('x',DateFormat1)
% End plot

% Start sub plot
% 
a5 = subplot(5,1,5);
plot(Date(TimeMask),[...
    Perf.C.WA_Des(TimeMask),Perf.R.WR_Des(TimeMask), ...
    Perf.C.WA_Air(TimeMask),Perf.R.WR_Air(TimeMask) ...
],'LineWidth',2)
ylabel('Flow [kg/hr]')
xlabel('Time')
ylim([0 50]);
title('Water ab/desorption rates ')
legend(...
 'WA_Air','WA_Des','WR_Air','WR_Des'...
    )
xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))])
datetick('x',DateFormat1)
% End plot

linkaxes([a1 a2 a3 a4 a5], 'x');

hold off
    
% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2 a3 a4 a5