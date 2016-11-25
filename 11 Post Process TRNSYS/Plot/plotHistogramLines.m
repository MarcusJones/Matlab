function plotHistogramLines(timeStruct,dataStruct,timeMask,dataMask,binEdges)

startTitleString = datestr(timeStruct.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(timeStruct.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = ['TITLE HERE', ', from ', ...
    startTitleString ' to  ' endTitleString];

data = dataStruct.data(timeMask,dataMask)

[freqCount,binLocs] = hist(data,binEdges)
% normCount = freqCount;
% columnSums = sum(freqCount);
% for i = 1:numel(columnSums)
%   normCount(:,i) = normCount(:,i)./columnSums(i);
% end

% plot(binLocs, normCount * 100)
plot(binLocs, freqCount)

units = dataStruct.headers(dataStruct.rows.units,dataMask);
systems = dataStruct.headers(dataStruct.rows.system,dataMask);
types = dataStruct.headers(dataStruct.rows.pointType,dataMask);
numbers = dataStruct.headers(dataStruct.rows.number,dataMask);
headers = dataStruct.headers(dataStruct.rows.headers,dataMask);
descriptions = dataStruct.headers(dataStruct.rows.description,dataMask);

ylabel('Häufigkeit');


xlabel(units{1});

legend(strcat(systems, ' ', types, ' ',  ...
' ', numbers, ' ', headers, ' ',descriptions),'interpreter', 'none')
% strtrim(pStruct.Units), ...
% I hid this for now! -MJ
legend('hide');

% legend(strcat(systems, ' ', types, ' ',  ...
% ' ', numbers, ' ', headers),'interpreter', 'none')
% % strtrim(pStruct.Units), ...
% % I hid this for now! -MJ
% legend('hide');
