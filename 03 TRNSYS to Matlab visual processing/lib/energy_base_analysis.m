
%%Retreive a single state point


%% Study of Zone Air
ZoneTemps1 = get_pData(get_state_points2(trnData,'Ebene1OG','ZoneAir','all'),'T');
ZoneMoisture1 = get_pData(get_state_points2(trnData,'Ebene1OG','ZoneAir','all'),'W');
ZoneTemps2 = get_pData(get_state_points2(trnData,'Ebene2OG','ZoneAir','all'),'T');
ZoneMoisture2 = get_pData(get_state_points2(trnData,'Ebene2OG','ZoneAir','all'),'W');
ZoneTemps3 = get_pData(get_state_points2(trnData,'Ebene3OG','ZoneAir','all'),'T');
ZoneMoisture3 = get_pData(get_state_points2(trnData,'Ebene3OG','ZoneAir','all'),'W');
ZoneTemps4 = get_pData(get_state_points2(trnData,'Ebene4OG','ZoneAir','all'),'T');
ZoneMoisture4 = get_pData(get_state_points2(trnData,'Ebene4OG','ZoneAir','all'),'W');
plot_pData_array(trnTime,[ZoneTemps1 ZoneMoisture1 ZoneTemps2 ZoneMoisture2 ZoneTemps3 ZoneMoisture3 ZoneTemps4 ZoneMoisture4])
plot_pData_array(trnTime,[ZoneTemps3])
clear ZoneTemps


%% Study of heat pump and well system
HP_Temp = get_pData(get_state_points2(trnData,'Heatpump','Fluid','all'),'T');
HP_massflow = get_pData(get_state_points2(trnData,'Heatpump','Fluid','all'),'mf');
HP_ThermalPower = get_pData(get_state_points2(trnData,'Heatpump','ThermalPower','all'),'Ef');
%HP_Power = get_pData(get_state_points2(trnData,'Heatpump','Power','all'),'Ef');
HX_Temp = get_pData(get_state_points2(trnData,'Heatexchanger','Fluid','all'),'T');
HX_massflow = get_pData(get_state_points2(trnData,'Heatexchanger','Fluid','all'),'mf');
HX_ThermalPower = get_pData(get_state_points2(trnData,'Heatexchanger','ThermalPower','all'),'Ef');
%Pump_Power = get_pData(get_state_points2(trnData,'Pump','Power','all'),'Ef');
plot_pData_array(trnTime,[HP_Temp HP_massflow HP_ThermalPower])
plot_pData_array(trnTime,[HP_ThermalPower])
%% Study of the CCA NW string


CCA_Temps_NW = get_pData(get_state_points2(trnData,'CCANW','Fluid','all'),'T');
CCA_massflow_NW = get_pData(get_state_points2(trnData,'CCANW','Fluid','all'),'mf');
CCA_Ent_NW = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'hf');

plot_pData_array(trnTime,[CCA_Temps_NW CCA_massflow_NW CCA_Ent_NW])

plotyy_pData(trnTime,CCA_Temps_NW,CCA_massflow_NW)

%% Study of the CCA SW string


CCA_Temps_SW = get_pData(get_state_points2(trnData,'CCASW','Fluid','all'),'T');
CCA_massflow_SW = get_pData(get_state_points2(trnData,'CCASW','Fluid','all'),'mf');
CCA_Ent_SW = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'hf');

plot_pData_array(trnTime,[CCA_Temps_SW CCA_massflow_SW CCA_Ent_SW])

plotyy_pData(trnTime,CCA_Temps_SW,CCA_massflow_SW)

%% Study of the CCA NE string


CCA_Temps_NE = get_pData(get_state_points2(trnData,'CCANE','Fluid','all'),'T');
CCA_massflow_NE = get_pData(get_state_points2(trnData,'CCANE','Fluid','all'),'mf');
CCA_Ent_NE = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'hf');

plot_pData_array(trnTime,[CCA_Temp_NE CCA_massflow_NE CCA_Ent_NE])

plotyy_pData(trnTime,CCA_Temp_NE,CCA_massflow_NE)

%% Study of the CCA SE string


CCA_Temps_SE = get_pData(get_state_points2(trnData,'CCASE','Fluid','all'),'T');
CCA_massflow_SE = get_pData(get_state_points2(trnData,'CCASE','Fluid','all'),'mf');
CCA_Ent_SE = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'hf');

plot_pData_array(trnTime,[CCA_Temp_SE CCA_massflow_SE CCA_Ent_SE])

plotyy_pData(trnTime,CCA_Temp_SE,CCA_massflow_SE)


%% Study of the CCA in Zones 3OG_09 and 3OG_07

Solar = get_pData(get_state_points2(trnData,'Sol','Irrad','all'),'all');
CCA_Temp = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'T');
CCA_massflow = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'mf');
CCA_Ent = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'hf');
HX_Temp = get_pData(get_state_points2(trnData,'Heatexchanger','Fluid','all'),'T');
HX_massflow = get_pData(get_state_points2(trnData,'Heatexchanger','Fluid','all'),'mf');
HX_ThermalPower = get_pData(get_state_points2(trnData,'Heatexchanger','ThermalPower','all'),'Ef');
% Pump_Power = get_pData(get_state_points2(trnData,'Pump','Power','all'),'Ef');
plot_pData_array(trnTime,[CCA_Temp CCA_massflow CCA_Ent])

plotyy_pData(trnTime,CCA_Temp,CCA_massflow)

hf = get_pData(get_state_points2(trnData,'CCA3OG','Fluid','all'),'hf')
sum(hf.Data(:,5)-hf.Data(:,7))/4
sum(hf.Data(:,6)-hf.Data(:,8))/4
        
QCCA_3OG09=(hf.Data(:,5)-hf.Data(:,7));
QCCA_3OG07=(hf.Data(:,6)-hf.Data(:,8));
QCCA_3OG07h=QCCA_3OG07(1:(end-1));
QCCA_3OG07h=reshape(QCCA_3OG07h,4,length(QCCA_3OG07h)/4);
QCCA_3OG07h=sum(QCCA_3OG07h);
QCCA_3OG09h=QCCA_3OG09(1:(end-1));
QCCA_3OG09h=reshape(QCCA_3OG09h,4,length(QCCA_3OG09h)/4);
QCCA_3OG09h=sum(QCCA_3OG09h);


sum(QCCA_3OG09h)
sum(QCCA_3OG07h)
QCCA_3OG09h=QCCA_3OG09h';
QCCA_3OG07h=QCCA_3OG07h';
QCCA=[QCCA_3OG09 QCCA_3OG07];
QCCAplot2 = get_pData(get_state_points2(trnData,'Sol','Irrad','all'),'all');
plot_pData_array(trnTime,[QCCAplot2])
plot(QCCA)
%% Study of heat pump and well system
HP_Temp = get_pData(get_state_points2(trnData,'Heatpump','Fluid','all'),'T');
HP_massflow = get_pData(get_state_points2(trnData,'Heatpump','Fluid','all'),'mf');
HP_ThermalPower = get_pData(get_state_points2(trnData,'Heatpump','ThermalPower','all'),'Ef');
HX_Temp = get_pData(get_state_points2(trnData,'Heatexchanger','Fluid','all'),'T');
HX_massflow = get_pData(get_state_points2(trnData,'Heatexchanger','Fluid','all'),'mf');
HX_ThermalPower = get_pData(get_state_points2(trnData,'Heatexchanger','ThermalPower','all'),'Ef');
% Pump_Power = get_pData(get_state_points2(trnData,'Pump','Power','all'),'Ef');
plot_pData_array(trnTime,[HP_Temp HP_massflow HP_ThermalPower HX_Temp HX_massflow HX_ThermalPower])


%% Study of the all AHU systems
% tempSystems = {'Office' 'Theatre', 'Exhibition', 'Toilets'};
% tempSystems = {'Exhibition'};
% 
% for iSystems = 1:length(tempSystems)
%     airTemps = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'T');
%     airHumid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'w');
%     airFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'mf');
%     enthalpyFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'hf');
%     control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Cntrl','all'),'y');
%     plot_pData_array(trnTime,[airTemps airHumid airFlow control enthalpyFlow])
%     clear airTemps airHumid airFlow control
% end
% 
% % Study of cooling coils in office
% % officeCoolCoils = get_pData(get_state_points2(trnData,'Office','Fluid','all'),'T');
% % officeCoolCoilsFlow = get_pData(get_state_points2(trnData,'Office','Fluid','all'),'mf');
% 
% %% Study of the Conventional chiller & cooling distribution system
% 
% temperatures = get_pData(get_state_points2(trnData,'CTCC','Fluid','all'),'T');
% massFlows = get_pData(get_state_points2(trnData,'CTCC','Fluid','all'),'mf');
% tanks = get_pData(get_state_points2(trnData,'CTCC','Tank','all'),'all');
% thermalPower = get_pData(get_state_points2(trnData,'CTCC','ThermalPower','all'),'all');
% 
% plot_pData_array(trnTime,[temperatures thermalPower])
% 
% plot_pData_array(trnTime,[tanks])
% 
% %% Study of the Distribution network
% temperatures = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'T');
% massFlows = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'mf');
% 
% plot_pData_array(trnTime,[temperatures massFlows])
% clear temperatures massFlows
% %% Energy consumption
% 
% 
% bDataCTCC = get_state_points2(trnData,'Office','Power','all');
% 
% barArray = [];
% barHdr = [];
% barDesc = {};
% 
% %Loop through the power states
% for bIdx = 1:length(bDataCTCC)
%     barSystem = bDataCTCC{bIdx};
%     barArray = [barArray barSystem.data];
%     barHdr = [barHdr barSystem.number];
%     barDesc = [barDesc barSystem.description];
% end
% barData = sum(barArray)*trnTime.intervalHours;
% 
% bData.array = barArray;
% bData.hdr = barHdr;
% bData.desc = barDesc;
% bData.data = barData;
% bData.system = 'System name...';
% 
% 
% plot_barData(trnTime,bData)
% 
% 
% powers = get_pData(get_state_points2(trnData,'Office','Power','all'),'Ef');
% massFlow = get_pData(get_state_points2(trnData,'Office','MoistAir','all'),'mf');
% plot_pData_array(trnTime,[powers, massFlow])
% 
% %%
% 
% % % Air side
% % officeAirTemps = get_pData(get_state_points2(trnData,'Office','MoistAir','all'),'T');
% % officeAirHumid = get_pData(get_state_points2(trnData,'Office','MoistAir','all'),'w');
% % officeAirFlow = get_pData(get_state_points2(trnData,'Office','MoistAir','described'),'mf');
% % officeControl = get_pData(get_state_points2(trnData,'Office','Cntrl','all'),'y');
% % plot_pData_array(trnTime,[officeAirTemps officeAirHumid officeAirFlow officeControl ])
% 
% 
% 
% %plot_pData_array(trnTime,[officeAirTemps officeAirHumid])
% %plot_pData_array(trnTime,[officeControl])
% 
% %plot_pData_array(trnTime,[ officeAirTemps officeControl soilAirHXTemps])
% 
% %plot_pData_array(trnTime,[officeCoolCoils officeCoolCoilsFlow])
% 
% %officeReheatTemps = get_pData(get_state_points2(trnData,'Office','Fluid',[5 6 9 10]),'T');
% %officeReheatMassflow = get_pData(get_state_points2(trnData,'Office','Fluid',[5 6 9 10]),'mf');
% %plot_pData_array(trnTime,[ officeReheatTemps officeReheatMassflow])
% 
% %trnData.SHX.MoistAir{1}.data(:,2)
% 
% %hist(ans,50)
% 
% %plot_pData_array(trnTime,soilAirHXTemps)
% 
% % plot_pData(trnTime,get_pData(get_state_points2(trnData,'SHX','MoistAir','described'),'T')) 
% % plot_pData(trnTime,get_pData(get_state_points2(trnData,'Office','MoistAir','described'),'T'))
% % plotbrowser
% % plot_pData(trnTime,get_pData(get_state_points2(trnData,'Office','MoistAir','described'),'w'))
% 
% %psychTime1 = dateNum(2000, 01, 01, 12, 00, 0);
% %psyData1 = get_psych_data(trnData,trnTime,'Office',psychTime1);
% %PlotH = plot_psyData(psyData1);
% 
% %HOLD plot.
% %plot_psyData(psyData1,PlotH)
% 
% 
% % % Note: Can accept 'ALL' as an input!!
% % % Example:
% % pStruct = get_pData(AirIn,'all');
% % 
% % dTAir=AirOut.data(:,1) - AirIn.data(:,1);
% % dwAir = AirOut.data(:,2) - AirIn.data(:,2);
% 
% 
% 
% % plot_pData(TIME STRUCTURE, PLOT STRUCTURE)
% % Example:
% %  plot_pData(trnTime,get_pData(trnData.SHX.MoistAir,'mf'))
% 
% 
% % plotyy_pData(TIME STRUCTURE, PLOT STRUCTURE1, PLOT STRUCTURE2)
% % Example:
% % plotyy_pData(trnTime,pStruct2,pStruct3)
% 
% %plot(trnData.Office.MoistAir{3}.data)
% 
% 
% %%
% % statePointCT1 = get_state_point(trnData,'CoolNet','Fluid',1);
% % statePointCT8 = get_state_point(trnData,'CoolNet','Fluid',8);
% % statePointCT21 = get_state_point(trnData,'CTCC','Fluid',21);
% % statePointCT2 = get_state_point(trnData,'CTCC','Fluid',2);
% % statePointOf1 =  get_state_point(trnData,'Office','Fluid',1);
% % statePointOf2 =  get_state_point(trnData,'Office','Fluid',2);
% % mean(statePointOf1.data(2))
% % mean(statePointOf2.data(2))
% % %plot(statePoint.data(:,1))
% % plot( ...
% % [statePointCT1.data(:,1)...
% % statePointCT8.data(:,1)...
% % statePointCT21.data(:,1)...
% % statePointCT2.data(:,1)]...
% % )
% % 
% %
% % plot( ...
% % [statePointCT1.data(:,2)...
% % statePointCT8.data(:,2)...
% % statePointCT21.data(:,2)...
% % statePointCT2.data(:,2)]...
% % )
% %get_state_point(trnData,'CTCC','Fluid',6)
% %get_state_point(trnData,'CTCC','Fluid',7)
% % get_state_point(trnData,'CTCC','Fluid',6);
% % get_state_point(trnData,'CTCC','Fluid',7);
% % AirIn = get_state_point(trnData,'Office','MoistAir',4);
% % AirOut = get_state_point(trnData,'Office','MoistAir',5);
% % WaterIn = get_state_point(trnData,'Office','Fluid',11);
% % WaterOut = get_state_point(trnData,'Office','Fluid',3);
% % get_state_point(trnData,'CTCC','Fluid',6)
% 
% % Study of office dehumidification coil
% % officeDehT = get_pData(get_state_points2(trnData,'Office','Fluid',[8 7]),'T');
% % officeDehmf = get_pData(get_state_points2(trnData,'Office','Fluid',[8 7]),'mf');
% % plot_pData_array(trnTime,[officeDehT officeDehmf])