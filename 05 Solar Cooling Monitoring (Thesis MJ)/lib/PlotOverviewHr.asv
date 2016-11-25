% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Temps, RHs, Conc
figure  % A three window plot
hold on

% Start  sub plot plot
% temperatures; 
a1 = subplot(5,1,1);
plot(Hr.DT,...
        [...
        Hr.C.Air.Temp.In,...
        Hr.C.Air.Temp.Out,...
        Hr.R.Air.Temp.Out...
        ],'-o')
datetick2('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
ylim([0 100]);
title('Air, cold water, hot water temperatures, in/out')
legend(...
    'Ambient','Process Out','Scav Out' ...
    )

% End plot

% Start sub plot
% 3 absolute humidities; ambient, process, calibrated
a2 = subplot(5,1,2);
plot(Hr.DT,[...
    Hr.C.Air.W.In,...
    Hr.C.Air.W.Out,...
    Hr.R.Air.W.Out...
    ],'-o')
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',DateFormat1)
ylabel('Absolute Humidity [%]')
xlabel('Time')
ylim([0 0.06]);
title('Absolute humidities  in air stream')
legend(...
    'Ambient','Process Out','Scav Out' ...
    )
% End plot


% Start sub plot
% 
a3 = subplot(5,1,3);
plot(Hr.DT,[...
    Hr.R.COP...
    ],'-o')
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick2('x',DateFormat1)
ylabel('COP')
xlabel('Time')
ylim([0 1]);
title('COP')
legend(...
    'COP' ...
    )
% End plot
    
% Start sub plot
% 
a4 = subplot(5,1,4);
plot(Date(TimeMask),[...
    Hot.FlowKH(TimeMask),Cold.FlowKH(TimeMask) ...
],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',DateFormat1)
ylabel('Flow [kg/hr]')
xlabel('Time')
% ylim([0 200]);
title('Water flow rates ')
legend(...
 'Hot','Cold'...
    )
    
% Start sub plot
% 
a5 = subplot(5,1,5);
plot(Date(TimeMask),[...
    Perf.C.WA_Des(TimeMask),Perf.R.WR_Des(TimeMask), ...
    Perf.C.WA_Air(TimeMask),Perf.R.WR_Air(TimeMask) ...
],'LineWidth',2)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',DateFormat1)
ylabel('Flow [kg/hr]')
xlabel('Time')
ylim([0 50]);
title('Water ab/desorption rates ')
legend(...
 'WA_Air','WA_Des','WR_Air','WR_Des'...
    )

linkaxes([a1 a2 a3 a4 a5], 'x');
hold off
    
% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2 a3 a4 a5