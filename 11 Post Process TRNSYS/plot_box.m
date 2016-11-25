function plot_box(timeFrame,dataFrame,timeMask,dataMask,legendDefinition)
%% Plot 
boxplot(dataFrame.data(timeMask,dataMask),'orientation','horizontal') 

%% Annotate
thisLegend = func_get_labels(dataFrame,dataMask,legendDefinition);

set(gca,'Ytick',1:size(thisLegend,2))
set(gca,'Yticklabel',thisLegend)
