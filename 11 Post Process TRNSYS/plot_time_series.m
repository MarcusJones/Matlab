function plot_time_series(timeStruct,dataFrame,timeMask,dataMask,legendDefinition, plotDef)

    

%% Plot
figure;
handle = axes;
plot(handle,timeStruct.time(timeMask),dataFrame.data(timeMask,dataMask));
theTimeVector = timeStruct.time(timeMask);

if isfield(plotDef,'legend')
    plotDef.legend = plotDef.legend;
else
    plotDef.legend = func_get_labels(dataFrame,dataMask,legendDefinition);
end


%thisLegend = func_get_labels(dataFrame,dataMask,legendDefinition);
%legend(thisLegend,'interpreter', 'none')

%%

func_annotate(handle, plotDef);

datetick2
set(gca,'XLim',[theTimeVector(1) theTimeVector(end)]);

if isfield(plotDef,'legend')
    if isfield(plotDef,'legPos') && ~isempty(plotDef.legPos)
        legLocation = plotDef.legPos;
    else
        legLocation = 'NorthEast';
    end
    legend(handle,plotDef.legend,'interpreter', 'none','Location',legLocation);
else
end


%get(gcf,'Children')
%num = findall(gcf,'type','axes');
%get(gca)
%datetick2

%%

