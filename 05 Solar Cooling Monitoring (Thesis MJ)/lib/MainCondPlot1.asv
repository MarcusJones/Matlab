% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - Temps, RHs, Conc
Fig = figure;  % A three window plot

hold on

grid on

DayForPlot = 16;

DayStr = int2str(DayForPlot);

Title1 = ['Conditioner Performance - July ' DayStr];

% Create textbox
% annotation(Fig,'textbox',...
%     'String',Title1,...
%     'FontSize',16,...
%     'FitBoxToText','off',...
%     'EdgeColor','none',...
%     'Position',[0.1 0.9 0.9 0.1]);


% set(Fig, 'Name','July 10')

% Load times
% Load first range of dates for data
% N = datenum(Y, M, D, H, MN, S)
Start = datenum(2008, 7, DayForPlot, 7, 10, 0);
End = datenum(2008, 7, DayForPlot, 17, 50, 0);
StartIndx = find(Hr.DT>=Start);
EndIndx = find(Hr.DT>=End);
Hr.Mask = StartIndx(1):(EndIndx(1)-1);

datevec(Hr.DT(EndIndx(1)))
datevec(Hr.DT(StartIndx(1)))
DateFormat1 = 15;

datevec(Hr.DT)
% Start  sub plot plot
% temperatures; 
a1 = subplot(3,1,1);
p1 = plot(Hr.DT(Hr.Mask),...
        [...
        Hr.C.TC(Hr.Mask)/3600, ...
        Hr.C.LC(Hr.Mask)/3600, ...
        Hr.C.SC(Hr.Mask)/3600 ...
        ]);
set(p1(1),'Marker','o','LineStyle',':');
set(p1(2),'Marker','s','LineStyle',':');
set(p1(3),'Marker','d','LineStyle',':');    
datetick('x',DateFormat1)
ylabel('Cooling [kW]')
xlabel('Time')
ylim([-10 50]);
title(Title1)
legend(...
    'Total','Latent','Sensble' ...
    )
%set(gca,'XTick',Hr.Ticks) % Doesn't work?
% End plot

% Start sub plot
% 3 temps; ambient, process, calibrated
a2 = subplot(3,1,2);
p1 = plot(Hr.DT(Hr.Mask),[...
    Hr.C.Air.Temp.In(Hr.Mask),...
    Hr.C.Air.Temp.Out(Hr.Mask),...
    ]);
set(p1(1),'Marker','^','LineStyle','--');
set(p1(2),'Marker','s','LineStyle','--');
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
datetick('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
 ylim([10 35]);
title('Temperatures')
legend(...
    'Ambient','Process Out' ...
    )
% End plot

% Start sub plot
% 3 absolute humidities; ambient, process, calibrated
a3 = subplot(3,1,3);
p1 = plot(Hr.DT(Hr.Mask),[...
    Hr.C.Air.W.In(Hr.Mask),...
    Hr.C.Air.W.Out(Hr.Mask),...
    ]);
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
set(p1(1),'Marker','^','LineStyle','--');
set(p1(2),'Marker','s','LineStyle','--');
datetick('x',DateFormat1)
ylabel('Absolute Humidity [%]')
xlabel('Time')
ylim([0 0.02]);
title('Absolute humidities in process air stream')
legend(...
    'Ambient','Process Out' ...
    )
% End plot

linkaxes([a1 a2 a3], 'x');


% xlim([Hr.DT(StartIndx(1)) Hr.DT(EndIndx(1)-1)]);

set(a1,'XGrid','on','YGrid','on');
set(a2,'XGrid','on','YGrid','on');
set(a3,'XGrid','on','YGrid','on');

% set(Fig,'PaperPositionMode', 'manual');

hold off
    
% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clear a1 a2 a3 

