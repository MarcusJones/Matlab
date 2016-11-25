function plotOverTemperature(timeStruct,dataStruct,timeMask,dataMask,binEdges)

startTitleString = datestr(timeStruct.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(timeStruct.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = ['TITLE HERE', ', from ', ...
    startTitleString ' to  ' endTitleString];

data = dataStruct.data(timeMask,dataMask);


[binnedData, b] = histc(data,binEdges);
%sum(binnedData)
%bar(binnedData)

lookAheadSums = [];
for i = 1:size(binEdges,2)
    thisBin = binEdges(i);
    lookAheadSums = vertcat(lookAheadSums, sum(binnedData(i:end,:),1));
end

% plot(binEdges,lookAheadSums,'-*')
plot(binEdges,lookAheadSums,'-')
newLabels = {};
for i = 1:size(binEdges,2)
    newLabels = [newLabels sprintf('>%i °C',binEdges(i)-1)];
    newLabels = [newLabels binEdges(i)];    
end
% set(gca,'XTickLabel',newLabels);
ylabel('Haufigkeit [Stunden]');
legend(['Eck', ]);



units = dataStruct.headers(dataStruct.rows.units,dataMask);
systems = dataStruct.headers(dataStruct.rows.system,dataMask);
types = dataStruct.headers(dataStruct.rows.pointType,dataMask);
numbers = dataStruct.headers(dataStruct.rows.number,dataMask);
headers = dataStruct.headers(dataStruct.rows.headers,dataMask);
descriptions = dataStruct.headers(dataStruct.rows.description,dataMask);

%xlabel(units{1});

legend(strcat(systems, ' ', types, ' ',  ...
' ', numbers, ' ', headers, ' ',descriptions),'interpreter', 'none')
% strtrim(pStruct.Units), ...
% I hid this for now! -MJ
legend('hide');













% %[freqCount,binLocs] = hist(data,binEdges);
% % normCount = freqCount;
% % columnSums = sum(freqCount);
% % for i = 1:numel(columnSums)
% %   normCount(:,i) = normCount(:,i)./columnSums(i);
% % end
% 
% % plot(binLocs, normCount * 100)
% plot(binLocs, freqCount)
% 
% units = dataStruct.headers(dataStruct.rows.units,dataMask);
% systems = dataStruct.headers(dataStruct.rows.system,dataMask);
% types = dataStruct.headers(dataStruct.rows.pointType,dataMask);
% numbers = dataStruct.headers(dataStruct.rows.number,dataMask);
% headers = dataStruct.headers(dataStruct.rows.headers,dataMask);
% descriptions = dataStruct.headers(dataStruct.rows.description,dataMask);
% 
% ylabel('Häufigkeit');
% 
% 
% xlabel(units{1});
% 
% legend(strcat(systems, ' ', types, ' ',  ...
% ' ', numbers, ' ', headers, ' ',descriptions),'interpreter', 'none')
% % strtrim(pStruct.Units), ...
% % I hid this for now! -MJ
% legend('hide');

% legend(strcat(systems, ' ', types, ' ',  ...
% ' ', numbers, ' ', headers),'interpreter', 'none')
% % strtrim(pStruct.Units), ...
% % I hid this for now! -MJ
% legend('hide');
