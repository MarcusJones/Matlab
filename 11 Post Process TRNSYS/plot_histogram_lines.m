function plot_histogram_lines(timeStruct,dataFrame,timeMask,...
    dataMask,legendDefinition,plotDef,binEdges)

%% Plot
[freqCount,binLocs] = hist(dataFrame.data(timeMask,dataMask),binEdges);
plot(binLocs, freqCount);

%% Annotate
ylabel(plotDef.yLabel);
xlabel(plotDef.xLabel);
title(plotDef.title);

thisLegend = func_get_labels(dataFrame,dataMask,legendDefinition);
legend(thisLegend,'interpreter', 'none')


