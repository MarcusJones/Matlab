function plot_barh(barDataSets,legendVals,plotDef)

plotDef.legend = legendVals

numSets = size(barDataSets,2);
numVals = size(barDataSets(1).vals,2);


matrix = [];
for idx = 1:numSets
    matrix = [matrix barDataSets(idx).vals'];
    labels = barDataSets(idx).heads;
end


figure;
handle = axes;
barh(handle,matrix);

if isfield(plotDef,'legend')
    if isfield(plotDef,'legPos') && ~isempty(plotDef.legPos)
        legLocation = plotDef.legPos;
    else
        legLocation = 'NorthEast';
    end
    legend(handle,plotDef.legend,'interpreter', 'none','Location',legLocation);

else
    plotDef.legend = func_get_labels(dataFrame,dataMask,legendDefinition);
end


%%

func_annotate(handle, plotDef)

set(gca,'YTickLabel',labels);
set(gca,'box','on');

set(gca, 'YLim',[0 numVals + 1])
%legend(legendVals)

end
