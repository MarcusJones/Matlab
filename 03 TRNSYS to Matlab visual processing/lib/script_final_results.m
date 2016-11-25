%% PLOT Study of the Soil Air Heat exchanger system
soilAirHXTemps = get_pData(get_state_points2(trnData,'SHX','MoistAir',[1 3]),'T');
soilAirHXHumid = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'w');
soilAirHXMassFlows = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'mf');
soilAirHXCntrl = get_pData(get_state_points2(trnData,'SHX','Cntrl',1),'y');
soilAirHXEnth = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'hf');
soilAirHXCooling = get_pData(get_state_points2(trnData,'SHX','ThermalPower','all'),'hf');

plot_pData_array(trnTime,[soilAirHXTemps soilAirHXCntrl])

clear soilAirHXTemps soilAirHXHumid soilAirHXMassFlows soilAirHXCntrl

trnData.SHX.Power(3) = trnData.SHX.ThermalPower(1)
trnData.SHX.Power{3}.data = trnData.SHX.Power{3}.data .* (trnData.SHX.Power{3}.data <= 0)
trnData.SHX.Power{3}.data = -trnData.SHX.Power{3}.data

bData = get_bar_data(trnData,{'SHX'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

%% PLOT the AHU systems
tempSystems = {'Office' 'Theatre', 'Exhibition', 'Toilets'};
%tempSystems = {'Exhibition'};
%tempSystems = {'Exhibition'};
tempSystems = {'Office'}
tempSystems = {'Toilets'};
%tempSystems = {'Toilets'}

%trnTime = set_operation_mask(trnTime,1);
%trnTime = set_operation_mask(trnTime,0);

for iSystems = 1:length(tempSystems)
    airTemps = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'T');
    airHumid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'w');
    airFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'mf');
    %     CSFluid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'T');
    enthalpyFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'hf');
    control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Cntrl','all'),'y');
    %    plot_pData_array(trnTime,[airTemps airHumid airFlow control enthalpyFlow])
    %plot_pData_array(trnTime,[airTemps airHumid airFlow control ])
    plot_pData_array(trnTime,[airTemps airHumid control ])
    clear airTemps airHumid airFlow control
end

% Study of cooling coils in office
% officeCoolCoils = get_pData(get_state_points2(trnData,'Office','Fluid','all'),'T');
% officeCoolCoilsFlow = get_pData(get_state_points2(trnData,'Office','Fluid','all'),'mf');

%% PLOT Psychrometric charting

%get_psych_data(trnData,trnTime,searchSystem,searchTime
datestr(snapTime)
%snapTime = datenum(2000, 09,

snapTime = datenum(2010, 07, 20, 16, 00, 0);

searchTime=snapTime;
Psy1 = get_psych_data(trnData,trnTime,'Exhibition',searchTime);
plot_psyData(Psy1);
Psy2 = get_psych_data(trnData,trnTime,'Theatre',searchTime);
plot_psyData(Psy2);


%% PLOT Study of the zone air nodes
% Average office
trnData.ZoneAir.ZoA(19) = trnData.ZoneAir.ZoA(18)
trnData.ZoneAir.ZoA{19}.data =  (trnData.ZoneAir.ZoA{14}.data + trnData.ZoneAir.ZoA{15}.data)./2
trnData.ZoneAir.ZoA{19}.description = 'Office average';
trnData.ZoneAir.ZoA{19}.number = 19;

% Average Exhib
trnData.ZoneAir.ZoA(20) = trnData.ZoneAir.ZoA(18)
trnData.ZoneAir.ZoA{20}.data = (trnData.ZoneAir.ZoA{1}.data + trnData.ZoneAir.ZoA{3}.data + trnData.ZoneAir.ZoA{7}.data)./3
trnData.ZoneAir.ZoA{20}.description =  'Theatre average';
trnData.ZoneAir.ZoA{20}.number = 20;

% Average Toi
trnData.ZoneAir.ZoA(21) = trnData.ZoneAir.ZoA(18)
trnData.ZoneAir.ZoA{21}.data =  (trnData.ZoneAir.ZoA{11}.data + trnData.ZoneAir.ZoA{12}.data + trnData.ZoneAir.ZoA{13}.data)./3
trnData.ZoneAir.ZoA{21}.description =  'Exhibition average';
trnData.ZoneAir.ZoA{21}.number = 21;

trnData.ZoneAir.ZoA(22) = trnData.ZoneAir.ZoA(18)
trnData.ZoneAir.ZoA(23) = trnData.ZoneAir.ZoA(18)
trnData.ZoneAir.ZoA(24) = trnData.ZoneAir.ZoA(18)
trnData.ZoneAir.ZoA(25) = trnData.ZoneAir.ZoA(18)


trnData.ZoneAir.ZoA{22}.data = (trnData.ZoneAir.ZoA{16}.data - 25) ./5 + 25
trnData.ZoneAir.ZoA{23}.data = (trnData.ZoneAir.ZoA{19}.data - 25) ./5 + 25
trnData.ZoneAir.ZoA{24}.data = (trnData.ZoneAir.ZoA{20}.data - 25) ./5 + 25
trnData.ZoneAir.ZoA{25}.data = (trnData.ZoneAir.ZoA{21}.data - 25) ./5 + 25

%get_state_points2(trnData,'ZoneAir','ZoA',[22 23 24 25])

zoneTemps = get_pData(get_state_points2(trnData,'ZoneAir','ZoA',[22 23 24 25]),'T');
zoneTemps = get_pData(get_state_points2(trnData,'ZoneAir','ZoA',[16 19 20 21]),'T');
zoneHumidities = get_pData(get_state_points2(trnData,'ZoneAir','ZoA',[16 19 20 21]),'w');
plot_pData_array(trnTime,[zoneTemps zoneHumidities]);


%% Study of the Conventional chiller & cooling distribution system

temperatures = get_pData(get_state_points2(trnData,'CTCC','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'CTCC','Fluid','all'),'mf');
tanks = get_pData(get_state_points2(trnData,'CTCC','Tank','all'),'all');
thermalPower = get_pData(get_state_points2(trnData,'CTCC','ThermalPower','all'),'all');
Power = get_pData(get_state_points2(trnData,'CTCC','Power','all'),'all');

plot_pData_array(trnTime,[temperatures thermalPower massFlows])
plot_pData_array(trnTime,[temperatures Power])

plot_pData_array(trnTime,[tanks])

%% Study of the solar cooling system
trnTime = set_operation_mask(trnTime,0);
temperatures = get_pData(get_state_points2(trnData,'Sol','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'Sol','Fluid','all'),'mf');
tanks = get_pData(get_state_points2(trnData,'Sol','Tank','all'),'all');
thermalPower = get_pData(get_state_points2(trnData,'Sol','ThermalPower','all'),'all');
control = get_pData(get_state_points2(trnData,'Sol','Cntrl','all'),'all');
%get_state_points2(trnData,'Sol','Irrad','all')

plot_pData_array(trnTime,[temperatures, massFlows,control]);
plot_pData_array(trnTime,[thermalPower]);
plot_pData_array(trnTime,[tanks]);
supplyFromTank = get_state_points2(trnData,'Sol','Fluid',11);
returnToTank = get_state_points2(trnData,'Sol','Fluid',14);
supplyFromTank = supplyFromTank{1};
returnToTank = returnToTank{1};
tankDeltaT = supplyFromTank.data(:,1) - returnToTank.data(:,1);
tankDeltah = supplyFromTank.data(:,3) - returnToTank.data(:,3);
plot(tankDeltaT)
plot(tankDeltah)

%% Study of the solar primary loop
GIncTotal = get_state_points2(trnData,'Sol','ThermalPower',2);
Qusable = get_state_points2(trnData,'Sol','ThermalPower',6);

Qusable = Qusable{1};
GIncTotal = GIncTotal{1};

etaColl = Qusable.data ./ GIncTotal.data;


temperatures = get_pData(get_state_points2(trnData,'Sol','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'Sol','Fluid','all'),'mf');
power = get_pData(get_state_points2(trnData,'Sol','Power','all'),'Ef');
%control = get_pData(get_state_points2(trnData,'CoolNet','Power','all'),'ef');

plot_pData_array(trnTime,[temperatures massFlows power])

%% Study of the cooling tower network

temperatures1 = get_pData(get_state_points2(trnData,'CoolNet','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'CoolNet','Fluid','all'),'mf');
power = get_pData(get_state_points2(trnData,'CoolNet','Power','all'),'Ef');
control = get_pData(get_state_points2(trnData,'CoolNet','Cntrl','all'),'all');

temperatures2 = get_pData(get_state_points2(trnData,'CoolNet','MoistAir','all'),'T');
humidity = get_pData(get_state_points2(trnData,'CoolNet','MoistAir','all'),'w');

plot_pData_array(trnTime,[temperatures1 temperatures2 power control])

% 
% temperatures = get_pData(get_state_points2(trnData,'CoolNet','Fluid',[1 9]),'T');
% 
% trnData.CoolNet.Fluid(9) = trnData.CoolNet.Fluid(1)
% trnData.CoolNet.Fluid{9}.data = trnData.CoolNet.Fluid{1}.data - trnData.CoolNet.Fluid{8}.data
% %massFlows = get_pData(get_state_points2(trnData,'CoolNet','Fluid','all'),'mf');
% power = get_pData(get_state_points2(trnData,'CoolNet','Power','all'),'Ef');
% %control = get_pData(get_state_points2(trnData,'CoolNet','Cntrl','all'),'all');
% 
% trnData.CoolNet.Power(4) = trnData.CoolNet.Power(1)
% trnData.CoolNet.Power{4}.data = trnData.CoolNet.Power{1}.data + trnData.CoolNet.Power{2}.data + trnData.CoolNet.Power{3}.data
% trnData.CoolNet.Power{4}.data = trnData.CoolNet.Power{4}.data * 5.6 % (To normalize the curve to 16.8 kW)
% trnData.CoolNet.Power{4}.data = trnData.CoolNet.Power{4}.data * 4 % (To factor the adiabatic pre-cool mode)
% 
% % trnData.CoolNet.Power{1}.data = trnData.CoolNet.Power{1}.data * 2 % (To normalize the curve to 16.8 kW)
% % trnData.CoolNet.Power{2}.data = trnData.CoolNet.Power{2}.data * 2 % (To normalize the curve to 16.8 kW)
% % trnData.CoolNet.Power{3}.data = trnData.CoolNet.Power{3}.data * 2 % (To normalize the curve to 16.8 kW)
% 
% plot_pData_array(trnTime,[temperatures power])

%% Study of the Distribution network
temperatures = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'mf');
thermals = get_pData(get_state_points2(trnData,'Dist','ThermalPower','all'),'hf');

plot_pData_array(trnTime,[temperatures thermals])
clear temperatures massFlows

%% Study of PV system
pvPow = get_pData(get_state_points2(trnData,'PV','Power','all'),'Ef');
massFlows = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'mf');

plot_pData_array(trnTime,[pvPow])

%% Study of All energy
powers = get_pData(get_state_points2(trnData,'LEEDSum','Power','all'),'Ef');

plot_pData_array(trnTime,[powers])

Starting = trnTime.time >= datenum([2010 07 01 20 00 00])
Ending = trnTime.time <= datenum([2010 07 01 21 00 00])
Starting & Ending

trnTime.mask = ((trnTime.time >= datenum([2010 07 20 00 00 00])) & (trnTime.time <= datenum([2010 07 21 00 00 00])))
%set_operation_mask(trnTime,flagMaskOn);

%trnTime.operationMask
%rnTime


bData = get_bar_data(trnData,{'LEEDSum'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

plot_peaksData2D(bData, trnTime)
datetick2

bData = get_bar_data(trnData,{'PowerSum'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'CTCC','Sol','CoolNet'},'Power','all');
plot_barData2D(bData, trnTime)
plot_barDataMonthly(bData, trnTime)

bData = get_bar_data(trnData,{'CTCC'},'ThermalPower','all');
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

thermalLosses = TotalIncRad - Qusable;

[Qusable thermalLosses; AbsCold Cold712]

subplot(1,2,1)
bar([Qusable thermalLosses; 0 0 ],'stack')
legend('Converted solar thermal energy', 'Excess solar')
XLabel('Solar thermal system')
YLabel('Thermal energy [kWh]')

subplot(1,2,2)
bar([AbsCold Cold712; 0 0 ],'stack')
XLabel('Concrete core demand')
YLabel('Thermal energy [kWh]')
legend('Absorption chiller', 'Conventional chiller')


bar([TotalIncRad Qusable AbsCold Cold712 TotalCCALoad]);
labels = {'Total radiation', 'Thermal heat', 'Chilled water', 'Extra chilled water', 'Total load'}

set(gca,'XTickLabel',labels);

rotateticklabel(gca,90);
%[1333.90270152871;2303.96645117350;295.383475520773;405.317909337682;-1213
%.89860922270;367.954398859992;367.183599687411;]



%% Post processing section!!!!!!!!

%% Convert

dirPrimatives = 'Y:\04 Reports\20100331 EA1 Scientific\Primitives\CurrentExport';
print_pdf(dirPrimatives)

% This one is BETTER!
dirPrimatives = 'Y:\04 Reports\20100331 EA1 Scientific\Primitives\CurrentExport';
export_fig(dirPrimatives,'-pdf')
%% Operation time
trnTime = set_operation_mask(trnTime,1);
trnTime = set_operation_mask(trnTime,0);

%% Apply months to bottem
% get year

PlaceMonthLabels = 275;
PlaceMonthLabels = input('Y axis position for month labels: ')

startYear = datevec(trnTime.time(1));
startYear = startYear(1);

monthMarks = [];
monthLabels = {};
monthLines =[];
for i = 1:13
    monthLines = [monthLines datenum([startYear i 01 0 0 0])];
    monthMarks = [monthMarks datenum([startYear i 15 0 0 0])];
    monthLabels{i} =[datestr([startYear i 1 0 0 0],'mmm')];
end

set(gca,'XTick',monthLines)
%set(gca,'XTickLabel',monthLabels)

% Place the text labels
t = text(monthMarks(1:12),PlaceMonthLabels*ones(1,length(monthMarks(1:12))),monthLabels(1:12));
set(t,'HorizontalAlignment','center','VerticalAlignment','middle');
set(t,'HorizontalAlignment','center','VerticalAlignment','middle');

% Remove the default labels
set(gca,'XTickLabel','')

%% Set page settings

axisLabelFontSize = 20;
axisFontSize = 20;

% Size options
set( gcf                       , ...
    'PaperUnits'   , 'centimeters' );
set( gcf                       , ...
    'PaperPosition'   , [-4.0450490624999995 3.463408020833333 29.690131354166663 20.99195395833333]);
set( gcf                       , ...
    'PaperSize'   , [21.573594999999997 27.91877]);
set( gcf                       , ...
    'PaperType'   ,'A4');
set( gcf                       , ...
    'PaperOrientation'   ,'portrait');
set( gcf                       , ...
    'Name'   ,'TestName');
set( gcf                       , ...
    'Position',[1756,151,1123,794;]);

% Hide Title
titleHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'title');
set(cell2mat(titleHandles),'Visible'   , 'off' );

% Color options
set( gcf                       , ...
    'Color',[1 1 1]);

% Line formatting
set( findobj(gcf,'-depth',2,'Type','line')                    , ...
    'LineWidth'   , 2 );
set( findobj(gcf,'-depth',2,'Type','line')                    , ...
    'LineStyle'   , '-' );

% Axis formatting
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'Box'   , 'off' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'XGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'YGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'ZGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'FontSize'   , axisFontSize );
set( findobj(gcf,'type','axes')                      , ...
    'FontName'   , 'Helvetica' );
xLabelHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'xlabel');
set(cell2mat(xLabelHandles),'FontSize'   , axisLabelFontSize );
set(cell2mat(xLabelHandles),'FontName'   , 'Helvetica');
yLabelHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'ylabel');
set(cell2mat(yLabelHandles),'FontSize'   , axisLabelFontSize );
set(cell2mat(yLabelHandles),'FontName'   , 'Helvetica');

set( findobj('Type','text')                    , ...
    'FontSize'   , 20 );
set( findobj('Type','text')                    , ...
    'FontName'   , 'AvantGarde' );



% set(get(findobj(gcf,'-depth',1,'Type','axes'),'xlabel'), ...
%     'FontSize'   , 10 );
% 
% 
% 
% 
% set( findobj('FontSize')                    , ...
%     'FontSize'   , 50 );
% set( findobj(gcf,'-depth',1,'Type','')                    , ...
%     'FontSize'   , 10 );
% 
% 
% allAxes = findobj(gcf,'-depth',1,'Type','axes')
% 
% allTexts = findobj('Type','annotation')
% 
% get(gco)
% 
% get(allTexts(3))
% 
% new1 = get(gcf)
% 
% get(objs(1))
% get(objs(4))
% 
% get(gcf,'Children')
% 
% get(gcf,'CurrentAxes')
% 
% findobj(gcf,'type','axes')
% 
% set(findobj('Type','line'),'Color','k')
% 
% hTitle  = title ('My Publication-Quality Graphics');
% hXLabel = xlabel('Length (m)'                     );
% hYLabel = ylabel('Mass (kg)'                      );
% 
% set( findobj(gcf,'type','axes')                      , ...
%     'FontName'   , 'Helvetica' );
% 
% set( findobj('type','text')                      , ...
%     'FontSize'   , 20 );
% 
% set( findobj(gcf,'type','axes')                      , ...
%     'FontSize'   , 20 );
% set([hTitle, hXLabel, hYLabel], ...
%     'FontName'   , 'AvantGarde');
% %set([hLegend, gca]             , ...
% %    'FontSize'   , 8           );
% set([hXLabel, hYLabel]  , ...
%     'FontSize'   , 20         );
% set( hTitle                    , ...
%     'FontSize'   , 12          , ...
%     'FontWeight' , 'bold'      );
% findobj(gcf,'type','axes')
% 
