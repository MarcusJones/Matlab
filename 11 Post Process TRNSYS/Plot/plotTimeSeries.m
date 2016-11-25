function plotTimeSeries(timeStruct,dataStruct,timeMask,dataMask)

startTitleString = datestr(timeStruct.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(timeStruct.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = ['TITLE HERE', ', from ', ...
    startTitleString ' to  ' endTitleString];

set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0; 46/255 139/255 87/255],...
        'DefaultAxesLineStyleOrder',{'-','--'});

% plot(timeStruct.time(timeMask),dataStruct.data(timeMask,dataMask),...
%     'LineWidth',1,...
%     'LineStyle','none',...
%     'Marker','o',...
%     'MarkerSize',3)

plot(timeStruct.time(timeMask),dataStruct.data(timeMask,dataMask))

units = dataStruct.headers(dataStruct.rows.units,dataMask);
systems = dataStruct.headers(dataStruct.rows.system,dataMask);
types = dataStruct.headers(dataStruct.rows.pointType,dataMask);
numbers = dataStruct.headers(dataStruct.rows.number,dataMask);
headers = dataStruct.headers(dataStruct.rows.headers,dataMask);
descriptions = dataStruct.headers(dataStruct.rows.description,dataMask);

ylabel(units{1});

legend(strcat(systems, ' ', types, ' ',  ...
' ', numbers, ' ', headers, ' ',descriptions),'interpreter', 'none')
% strtrim(pStruct.Units), ...
% I hid this for now! -MJ
legend('hide');

datetick2;
theTimeVector = timeStruct.time(timeMask);
set(gca,'XLim',[theTimeVector(1) theTimeVector(end)]);
