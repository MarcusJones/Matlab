
%%Retreive a single state point


%% Study of the Soil Air Heat exchanger system
soilAirHXTemps = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'T');
soilAirHXHumid = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'w');
soilAirHXMassFlows = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'mf');
soilAirHXCntrl = get_pData(get_state_points2(trnData,'SHX','Cntrl','all'),'y');
soilAirHXEnth = get_pData(get_state_points2(trnData,'SHX','MoistAir','all'),'hf');
soilAirHXCooling = get_pData(get_state_points2(trnData,'SHX','ThermalPower','all'),'hf');

plot_pData_array(trnTime,[soilAirHXTemps soilAirHXMassFlows soilAirHXCntrl],settings);
plot_pData_array(trnTime,[soilAirHXTemps soilAirHXEnth soilAirHXCntrl soilAirHXCooling],settings);

clear soilAirHXTemps soilAirHXHumid soilAirHXMassFlows soilAirHXCntrl

%% Study of the all AHU systems
tempSystems = {'Office' 'Theatre', 'Exhibition', 'Toilets'};
%tempSystems = {'Exhibition'};
tempSystems = {'Exhibition'};
tempSystems = {'Office'}
tempSystems = {'VAVOffice'}
tempSystems = {'VAVExh'}
tempSystems = {'VAVcentral'}

tempSystems = {'Toilets'}

trnTime = set_operation_mask(trnTime,1);
trnTime = set_operation_mask(trnTime,0);

for iSystems = 1:length(tempSystems)
    airTemps = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'T');
    airHumid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'w');
    airFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'mf');
%     CSFluid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'T');
    enthalpyFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'hf');
    control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Cntrl','all'),'y');
%    plot_pData_array(trnTime,[airTemps airHumid airFlow control enthalpyFlow])
        plot_pData_array(trnTime,[airTemps airHumid airFlow control ],settings)
    clear airTemps airHumid airFlow control
end

% Study of cooling coils in office
% officeCoolCoils = get_pData(get_state_points2(trnData,'Office','Fluid','all'),'T');
% officeCoolCoilsFlow = get_pData(get_state_points2(trnData,'Office','Fluid','all'),'mf');

%% Study of the VAV systems
tempSystems = {'VAVOffice'}
tempSystems = {'VAVExh'}
tempSystems = {'VAVToilets'}
tempSystems = {'VAVEntrance'}
tempSystems = {'VAVTheatre'}
tempSystems = {'BLVCC'}

trnTime = set_operation_mask(trnTime,1);

for iSystems = 1:length(tempSystems)
    airTemps = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'T');
    airHumid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'w');
    airFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'mf');
    enthalpyFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'hf');
    control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Cntrl','all'),'y');
    plot_pData_array(trnTime,[airTemps airHumid airFlow control ],settings)
    clear airTemps airHumid airFlow control
end

%mass flow balance check

airFlow1 = get_pData(get_state_points2(trnData,'VAVOffice','MoistAir',4),'mf');
airFlow2 = get_pData(get_state_points2(trnData,'VAVOffice','MoistAir',8),'mf');
airFlow3 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',4),'mf');
airFlow4 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',8),'mf');
airFlow5 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',12),'mf');
airFlow6 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',16),'mf');
airFlow7 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',20),'mf');
airFlow8 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',24),'mf');
airFlow9 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',28),'mf');
airFlow10 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',32),'mf');
airFlow11 = get_pData(get_state_points2(trnData,'VAVExh','MoistAir',36),'mf');
airFlow12 = get_pData(get_state_points2(trnData,'VAVTheatre','MoistAir',4),'mf');
airFlow13 = get_pData(get_state_points2(trnData,'VAVEntrance','MoistAir',4),'mf');
airFlow14 = get_pData(get_state_points2(trnData,'VAVToilet','MoistAir',4),'mf');
airFlow15 = get_pData(get_state_points2(trnData,'VAVToilet','MoistAir',8),'mf');
airFlow16 = get_pData(get_state_points2(trnData,'VAVToilet','MoistAir',12),'mf');
sum=airFlow1.Data+airFlow2.Data+airFlow3.Data+airFlow4.Data+airFlow5.Data+airFlow6.Data+airFlow7.Data+airFlow8.Data+airFlow9.Data+airFlow10.Data+airFlow11.Data+airFlow12.Data+airFlow13.Data+airFlow14.Data+airFlow15.Data+airFlow16.Data

tempSystems = {'VAVcentral'}
for iSystems = 1:length(tempSystems)
    airTemps = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'T');
    airHumid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'w');
    airFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'mf');
    CSFluid = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'T');
    enthalpyFlow = get_pData(get_state_points2(trnData,tempSystems{iSystems},'MoistAir','all'),'hf');
    control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Cntrl','all'),'y');
    Power = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Power','all'),'Ef');
%    plot_pData_array(trnTime,[airTemps airHumid airFlow control enthalpyFlow])
        plot_pData_array(trnTime,[airTemps airHumid airFlow control Power],settings)
    clear airTemps airHumid airFlow control Power
end



tempSystems = {'BLVCC'}
for iSystems = 1:length(tempSystems)
    Control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Control','all'),'y');
    FluidTemp = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'T');
    FluidMass = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'mf');
    Power = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Power','all'),'Ef');
    %    plot_pData_array(trnTime,[airTemps airHumid airFlow control enthalpyFlow])
    plot_pData_array(trnTime,[FluidTemp FluidMass Power Control],settings)
    clear FluidTemp FluidMass Power Control
end
Power = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Power','all'),'Ef');
sum(Power.Data(:,6))


tempSystems = {'BLCT'}
for iSystems = 1:length(tempSystems)
    Control = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Control','all'),'y');
    FluidTemp = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'T');
    FluidMass = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Fluid','all'),'mf');
    Power = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Power','all'),'Ef');
    %    plot_pData_array(trnTime,[airTemps airHumid airFlow control enthalpyFlow])
    plot_pData_array(trnTime,[FluidTemp FluidMass Power Control],settings)
    clear FluidTemp FluidMass Power Control
end

tempSystems = {'VAVReheat'}
for iSystems = 1:length(tempSystems)
    ReheatPower = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Power','all'),'Ef');
    plot_pData_array(trnTime,[ReheatPower],settings)
    clear ReheatPower
end
ReheatPower = get_pData(get_state_points2(trnData,tempSystems{iSystems},'Power','all'),'Ef');
plot( sum(ReheatPower.Data,2))
plot(ReheatPower.Data)

%% Psychrometric charting

%get_psych_data(trnData,trnTime,searchSystem,searchTime
datestr(snapTime)
%snapTime = datenum(2000, 09,

snapTime = datenum(2000, 07, 15, 12, 00, 0);

searchTime=snapTime;
Psy1 = get_psych_data(trnData,trnTime,'Exhibition',searchTime);
plot_psyData(Psy1);
Psy2 = get_psych_data(trnData,trnTime,'Theatre',searchTime);
plot_psyData(Psy2);


%% Study of the zone air nodes

zoneTemps = get_pData(get_state_points2(trnData,'ZoneAir','ZoA','all'),'T');
zoneHumidities = get_pData(get_state_points2(trnData,'ZoneAir','ZoA','all'),'w');
plot_pData_array(trnTime,[zoneTemps zoneHumidities],settings);

%trnflowMassFlow = get_pData(get_state_points2(trnData,'trnflow','MassFlow','all'),'mf');
%plot_pData_array(trnTime,[trnflowMassFlow]);


%% Study of the Conventional chiller & cooling distribution system

temperatures = get_pData(get_state_points2(trnData,'CTCC','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'CTCC','Fluid','all'),'mf');
tanks = get_pData(get_state_points2(trnData,'CTCC','Tank','all'),'all');
thermalPower = get_pData(get_state_points2(trnData,'CTCC','ThermalPower','all'),'all');
Power = get_pData(get_state_points2(trnData,'CTCC','Power','all'),'all');

plot_pData_array(trnTime,[temperatures thermalPower massFlows],settings)
plot_pData_array(trnTime,[temperatures thermalPower Power],settings)

plot_pData_array(trnTime,[tanks])

%% Study of the solar cooling system
%trnTime = set_operation_mask(trnTime,0);
temperatures = get_pData(get_state_points2(trnData,'Sol','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'Sol','Fluid','all'),'mf');
tanks = get_pData(get_state_points2(trnData,'Sol','Tank','all'),'all');
thermalPower = get_pData(get_state_points2(trnData,'Sol','ThermalPower','all'),'all');
control = get_pData(get_state_points2(trnData,'Sol','Cntrl','all'),'all');
%get_state_points2(trnData,'Sol','Irrad','all')

plot_pData_array(trnTime,[temperatures, temperatures, massFlows,control],settings);
plot_pData_array(trnTime,[temperatures, massFlows,control],settings);
plot_pData_array(trnTime,[thermalPower],settings);
plot_pData_array(trnTime,[tanks],settings);
supplyFromTank = get_state_points2(trnData,'Sol','Fluid',11);
returnToTank = get_state_points2(trnData,'Sol','Fluid',14);
supplyFromTank = supplyFromTank{1};
returnToTank = returnToTank{1};
tankDeltaT = supplyFromTank.data(:,1) - returnToTank.data(:,1);
tankDeltah = supplyFromTank.data(:,3) - returnToTank.data(:,3);
plot(tankDeltaT)
plot(tankDeltah)

secondaryCntrl = get_state_points2(trnData,'Sol','Cntrl',[2])
length(secondaryCntrl{1}.data(secondaryCntrl{1}.data==1))*5/60/24

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

plot_pData_array(trnTime,[temperatures massFlows power],settings)

%% Study of the cooling tower network

temperatures1 = get_pData(get_state_points2(trnData,'CoolNet','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'CoolNet','Fluid','all'),'mf');
power = get_pData(get_state_points2(trnData,'CoolNet','Power','all'),'Ef');
control = get_pData(get_state_points2(trnData,'CoolNet','Cntrl','all'),'all');

temperatures2 = get_pData(get_state_points2(trnData,'CoolNet','MoistAir','all'),'T');
humidity = get_pData(get_state_points2(trnData,'CoolNet','MoistAir','all'),'w');

plot_pData_array(trnTime,[temperatures1 temperatures2 power control],settings)


%plot_pData_array(trnTime,[temperatures humidity])


%AmbientAir = get_state_points2(trnData,'CoolNet','MoistAir',1);
%AmbientAir(

%% Study of the Distribution network
temperatures = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'T');
massFlows = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'mf');

plot_pData_array(trnTime,[temperatures massFlows],settings)
clear temperatures massFlows

%% Study of PV system
pvPow = get_pData(get_state_points2(trnData,'PV','Power','all'),'Ef');
massFlows = get_pData(get_state_points2(trnData,'Dist','Fluid','all'),'mf');

plot_pData_array(trnTime,[pvPow],settings)

%%

% % Air side
% officeAirTemps = get_pData(get_state_points2(trnData,'Office','MoistAir','all'),'T');
% officeAirHumid = get_pData(get_state_points2(trnData,'Office','MoistAir','all'),'w');
% officeAirFlow = get_pData(get_state_points2(trnData,'Office','MoistAir','described'),'mf');
% officeControl = get_pData(get_state_points2(trnData,'Office','Cntrl','all'),'y');
% plot_pData_array(trnTime,[officeAirTemps officeAirHumid officeAirFlow officeControl ])



%plot_pData_array(trnTime,[officeAirTemps officeAirHumid])
%plot_pData_array(trnTime,[officeControl])

%plot_pData_array(trnTime,[ officeAirTemps officeControl soilAirHXTemps])

%plot_pData_array(trnTime,[officeCoolCoils officeCoolCoilsFlow])

%officeReheatTemps = get_pData(get_state_points2(trnData,'Office','Fluid',[5 6 9 10]),'T');
%officeReheatMassflow = get_pData(get_state_points2(trnData,'Office','Fluid',[5 6 9 10]),'mf');
%plot_pData_array(trnTime,[ officeReheatTemps officeReheatMassflow])

%trnData.SHX.MoistAir{1}.data(:,2)

%hist(ans,50)

%plot_pData_array(trnTime,soilAirHXTemps)

% plot_pData(trnTime,get_pData(get_state_points2(trnData,'SHX','MoistAir','described'),'T')) 
% plot_pData(trnTime,get_pData(get_state_points2(trnData,'Office','MoistAir','described'),'T'))
% plotbrowser
% plot_pData(trnTime,get_pData(get_state_points2(trnData,'Office','MoistAir','described'),'w'))

%psychTime1 = dateNum(2000, 01, 01, 12, 00, 0);
%psyData1 = get_psych_data(trnData,trnTime,'Office',psychTime1);
%PlotH = plot_psyData(psyData1);

%HOLD plot.
%plot_psyData(psyData1,PlotH)


% % Note: Can accept 'ALL' as an input!!
% % Example:
% pStruct = get_pData(AirIn,'all');
% 
% dTAir=AirOut.data(:,1) - AirIn.data(:,1);
% dwAir = AirOut.data(:,2) - AirIn.data(:,2);



% plot_pData(TIME STRUCTURE, PLOT STRUCTURE)
% Example:
%  plot_pData(trnTime,get_pData(trnData.SHX.MoistAir,'mf'))


% plotyy_pData(TIME STRUCTURE, PLOT STRUCTURE1, PLOT STRUCTURE2)
% Example:
% plotyy_pData(trnTime,pStruct2,pStruct3)

%plot(trnData.Office.MoistAir{3}.data)


%%
% statePointCT1 = get_state_point(trnData,'CoolNet','Fluid',1);
% statePointCT8 = get_state_point(trnData,'CoolNet','Fluid',8);
% statePointCT21 = get_state_point(trnData,'CTCC','Fluid',21);
% statePointCT2 = get_state_point(trnData,'CTCC','Fluid',2);
% statePointOf1 =  get_state_point(trnData,'Office','Fluid',1);
% statePointOf2 =  get_state_point(trnData,'Office','Fluid',2);
% mean(statePointOf1.data(2))
% mean(statePointOf2.data(2))
% %plot(statePoint.data(:,1))
% plot( ...
% [statePointCT1.data(:,1)...
% statePointCT8.data(:,1)...
% statePointCT21.data(:,1)...
% statePointCT2.data(:,1)]...
% )
% 
%
% plot( ...
% [statePointCT1.data(:,2)...
% statePointCT8.data(:,2)...
% statePointCT21.data(:,2)...
% statePointCT2.data(:,2)]...
% )
%get_state_point(trnData,'CTCC','Fluid',6)
%get_state_point(trnData,'CTCC','Fluid',7)
% get_state_point(trnData,'CTCC','Fluid',6);
% get_state_point(trnData,'CTCC','Fluid',7);
% AirIn = get_state_point(trnData,'Office','MoistAir',4);
% AirOut = get_state_point(trnData,'Office','MoistAir',5);
% WaterIn = get_state_point(trnData,'Office','Fluid',11);
% WaterOut = get_state_point(trnData,'Office','Fluid',3);
% get_state_point(trnData,'CTCC','Fluid',6)

% Study of office dehumidification coil
% officeDehT = get_pData(get_state_points2(trnData,'Office','Fluid',[8 7]),'T');
% officeDehmf = get_pData(get_state_points2(trnData,'Office','Fluid',[8 7]),'mf');
% plot_pData_array(trnTime,[officeDehT officeDehmf])