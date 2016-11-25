%% Load the arrays
trnSystems = fieldnames(trnData);

bData = get_bar_data(trnData,{'LEEDSumBL'},'Power','all');
bData = get_bar_data(trnData,{'LEEDSumBL'},'Power',[1 2 8 9 10 11 12 13 14 15])
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'LEEDSum'},'Power','all');
bData = get_bar_data(trnData,{'LEEDSum'},'Power',[1 2 8 9 10 11 12 13 14 15])
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

plot_barData2D_CustomForReport(bData, LEEDFinalCompare,trnTime)

LEEDFinalCompareHVACLabels = { ...
'Pumps', ...
'Reheat', ...
'Primary Chiller', ...
'Secondary Chiller', ...
'Rotary Exchangers', ...
'Fans', ...
'Cooling Towers'}

plot_barData2D_CustomForReport(bData, LEEDFinalCompareHVAC,trnTime, LEEDFinalCompareHVACLabels)



plot_peaksData2D(bData, trnTime)
bData{1}.data
bDataTotal = 

bData2{1} = bData{1}
for i = 2:15
    bData2{1}.data = bData2{1}.data + bData{i}.data;
end

bData3{1}.data = bData2{1}.data - trnData.PV.Power{1}.data

plot_peaksData2D(bData2, trnTime)

plot(trnTime.time,bData3{1}.data)
datetick2

mean(bData3{1}.data)

max(bData3{1}.data)




datetick2

bData = get_bar_data(trnData,{'SHX'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'PowerSum'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'PowerSum2'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)


bData = get_bar_data(trnData,{'CTCC','Sol','CoolNet'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'CTCC'},'ThermalPower','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'BLVCC'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'CTCC'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'Sol'},'ThermalPower','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'PV'},'Power',1);
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)
plot_barDataDaily(bData, trnTime)


% For the solar cooling system ....
AbsCold = 512.3;
Qusable = 812.8;
Cold712 = 1233.9;
TotalCCALoad = AbsCold + Cold712;
TotalIncRad = 2304.0;

bar([TotalIncRad Qusable AbsCold Cold712 TotalCCALoad]);
labels = {'Total radiation', 'Thermal heat', 'Chilled water', 'Extra chilled water', 'Total load'}

set(gca,'XTickLabel',labels);

rotateticklabel(gca,90);
%[1333.90270152871;2303.96645117350;295.383475520773;405.317909337682;-1213.89860922270;367.954398859992;367.183599687411;]