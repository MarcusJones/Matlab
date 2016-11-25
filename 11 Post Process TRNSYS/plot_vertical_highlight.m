function plot_vertical_highlight(timeStruct,dataFrame,timeMask,dataMask,highlightMask)
% Area weekend
hold on
limits = get(gca,'YLim');
minY = limits(1);
maxY = limits(2);
totalMask = highlightMask.*timeMask;

%thisHand = area(timeStruct.time(timeMask),totalMask(timeMask).*maxY,'FaceColor',[1 1 0.6863],'lineStyle','none');
timeValues = timeStruct.time(timeMask);
yAxesValues = totalMask(timeMask).*maxY;

yAxesValuesZeroMask = yAxesValues == 0;
yAxesValues(yAxesValuesZeroMask) = minY;

%thisHand = fill(timeValues,yAxesValues,'r');
%thisHand = area(timeValues,yAxesValues.*maxY);
%thisHand = area(timeStruct.time(timeMask),totalMask(timeMask).*maxY)
thisHand = area(timeStruct.time(timeMask),yAxesValues)
set(thisHand,'BaseValue',minY);


set(thisHand,'FaceColor',[1 1 0.6863]);
set(thisHand,'lineStyle','none');

% Highlight moved under lines
uistack(thisHand,'bottom');

% Axes grid on top
set(gca, 'Layer','top');


%time.time(mask.focus),35*mask.weekend(mask.focus

% Plot three temps
%plot(time.time(mask.focus),allTempsSet(mask.focus,:));
% Highlight crit
%plot(time.time(critical),buroVec(critical,:),'lineStyle','none','marker','.','markersize',20);
%ylabel('Temperature [°C]')
%legend({'Innentemperature', 'Umgebungstemperature', 'Umgebung - 6', 'Uberschritten' })
%datetick2
