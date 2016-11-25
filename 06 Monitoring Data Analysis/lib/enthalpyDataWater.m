function enthData = enthalpyDataWater(temperatureData,massFlowData)

load waterProps_new;

%temperatures = dataStruct.data(:,columnNumbers);

enthalpyData = enthalpyWater(waterProps, temperatureData);

newHeader = temperatureData.header;

newHeader(5,:) = {'kJ/kg'};

newHeader(6,:) = {'Computed'};

newHeader(7,:) = {'Matlab'};

newHeader([3,4,9],:) = {'Enthalpy'};

enthData.data = h;
enthData.header = newHeader;
enthData.time = dataStruct.time;
