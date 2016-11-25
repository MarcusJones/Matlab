function plot_over_temp(timeStruct,dataFrame,timeMask,...
    dataMask,legendDefinition,plotDef,binEdges)

[binnedData, b] = histc(dataFrame.data(timeMask,dataMask),binEdges);
%sum(binnedData)
%bar(binnedData)

lookAheadSums = [];
for i = 1:size(binEdges,2)
    thisBin = binEdges(i);
    lookAheadSums = vertcat(lookAheadSums, sum(binnedData(i:end,:),1));
end


figure;
handle = axes;
plot(handle,binEdges,lookAheadSums,'-')


if isfield(plotDef,'legend')
    plotDef.legend = plotDef.legend;
else
    plotDef.legend = func_get_labels(dataFrame,dataMask,legendDefinition);
end



%%

func_annotate(handle, plotDef);

if isfield(plotDef,'legend')
    if isfield(plotDef,'legPos') && ~isempty(plotDef.legPos)
        legLocation = plotDef.legPos;
    else
        legLocation = 'NorthEast';
    end
    legend(handle,plotDef.legend,'interpreter', 'none','Location',legLocation);
else
end



% 
% 
% %% Annotate
% newLabels = {};
% oldLabels = get(gca,'XTickLabel');
% for i = 1:size(oldLabels,1)
%     newLabels = [newLabels sprintf('>%s °C', oldLabels(i,:) )];
%     %newLabels = [newLabels binEdges(i)];    
% end
% 
% set(gca,'XTickLabel',newLabels);
% ylabel(plotDef.yLabel);
% xlabel(plotDef.xLabel);
% 
% thisLegend = func_get_labels(dataFrame,dataMask,legendDefinition);
% legend(thisLegend);
% 

