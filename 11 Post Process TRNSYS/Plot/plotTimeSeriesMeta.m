function plotTimeSeriesMeta(timeStruct,dataFrame,timeMask,dataMask,legendDefinition, unitsDef)

startTitleString = datestr(timeStruct.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(timeStruct.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = ['TITLE HERE', ', from ', ...
    startTitleString ' to  ' endTitleString];

%% Plot
plot(timeStruct.time(timeMask),dataFrame.data(timeMask,dataMask))

%% Get legend rows
headerRows = [];
for idxHead = 1:size(legendDefinition,2)
    desiredHead = legendDefinition{idxHead};
    % Get the row number of the desiredHead 
    for idxHeaderDef = 1:size(dataFrame.headerDef,1)
        thisHeaderDef = dataFrame.headerDef{idxHeaderDef,1};
        if ~isempty(regexp(desiredHead, thisHeaderDef, 'match'))
            %headerMask = thisHeaderDef;
            headerRows = [headerRows dataFrame.headerDef{idxHeaderDef,2}];
        end
    end
    % Found headerMask
    assert(logical(exist('headerRows','var')));
end

thisLegendMatrix = dataFrame.headers(headerRows,dataMask);

thisLegend = {}
for idxVar = 1:size(thisLegendMatrix,2)
    thisLegendEntry = thisLegendMatrix(:,idxVar)
    thisLegendString = '';
    for idxElement = 1:size(thisLegendEntry,1)
        thisLegendString = [thisLegendString ' ' thisLegendEntry{idxElement}];
    end
    thisLegend = [thisLegend thisLegendString];
end 

ylabel(unitsDef);

legend(thisLegend,'interpreter', 'none')

datetick2;
theTimeVector = timeStruct.time(timeMask);
set(gca,'XLim',[theTimeVector(1) theTimeVector(end)]);
