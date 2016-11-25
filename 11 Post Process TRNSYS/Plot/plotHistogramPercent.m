function plotHistogramPercent(timeStruct,dataStruct,dataMask,binEdges)

startTitleString = datestr(timeStruct.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(timeStruct.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = ['TITLE HERE', ', from ', ...
    startTitleString ' to  ' endTitleString];

data = dataStruct.data(timeStruct.Mask,dataMask);

[freqCount,binLocs] = hist(data,binEdges);
normCount = freqCount;
columnSums = sum(freqCount);
for i = 1:numel(columnSums)
  normCount(:,i) = normCount(:,i)./columnSums(i);
end

bar(binLocs,normCount * 100,'histc')

units = dataStruct.headers(dataStruct.rows.units,dataMask);
systems = dataStruct.headers(dataStruct.rows.system,dataMask);
types = dataStruct.headers(dataStruct.rows.pointType,dataMask);
numbers = dataStruct.headers(dataStruct.rows.number,dataMask);
headers = dataStruct.headers(dataStruct.rows.headers,dataMask);
descriptions = dataStruct.headers(dataStruct.rows.description,dataMask);

ylabel('Percentage');


xlabel(units{1});

legend(strcat(systems, ' ', types, ' ',  ...
' ', numbers, ' ', headers),'interpreter', 'none')
% strtrim(pStruct.Units), ...
% I hid this for now! -MJ
legend('hide');
