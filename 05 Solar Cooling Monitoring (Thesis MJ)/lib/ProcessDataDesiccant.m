
%Import raw data from excel measurement file
fileToRead = 'D:\L Scripts\02L Matlab\05 Solar Cooling Monitoring (Thesis MJ)\Data\RawData\All Concentration.csv';
DELIMITER = ',';
HEADERLINES = 0;
rawdata = importdata(fileToRead, DELIMITER, HEADERLINES);

% Convert excel date serial into matlab format
%MatlabDate = x2mdate(rawdata(:,1));
MatlabDate = rawdata(:,1);
rawdata(:,1) = MatlabDate;

% Assume desiccant constant for all time before first measurement
StartRow = [DatedData(1,1),...
    rawdata(1,2),...
    rawdata(1,3),...
    rawdata(1,4),...
    rawdata(1,5),...
    rawdata(1,6),...    
    rawdata(1,7),...
    rawdata(1,8),...
    rawdata(1,9)...
    ];

% Assume desiccant constant for all time after last measurement
EndRow = [DatedData(length(DatedData(:,1)),1),...
    rawdata(length(rawdata(:,1)),2),...    
    rawdata(length(rawdata(:,1)),3),...    
    rawdata(length(rawdata(:,1)),4),...    
    rawdata(length(rawdata(:,1)),5),...    
    rawdata(length(rawdata(:,1)),6),...    
    rawdata(length(rawdata(:,1)),7),...    
    rawdata(length(rawdata(:,1)),8),...    
    rawdata(length(rawdata(:,1)),9),...    
    ];

% Append these 2 rows
rawdata = vertcat(StartRow, rawdata, EndRow);

% Interpolate the concentration data
Des.C.ConcIn = MinuteFit(rawdata(:,1),rawdata(:,3),DatedData(:,1));
Des.C.ConcOut = MinuteFit(rawdata(:,1),rawdata(:,5),DatedData(:,1));
Des.R.ConcIn = MinuteFit(rawdata(:,1),rawdata(:,7),DatedData(:,1));
Des.R.ConcOut = MinuteFit(rawdata(:,1),rawdata(:,9),DatedData(:,1));

% Interpolate the density data
Des.C.DensIn = MinuteFit(rawdata(:,1),rawdata(:,2),DatedData(:,1));
Des.C.DensOut = MinuteFit(rawdata(:,1),rawdata(:,4),DatedData(:,1));
Des.R.DensIn = MinuteFit(rawdata(:,1),rawdata(:,6),DatedData(:,1));
Des.R.DensIn = MinuteFit(rawdata(:,1),rawdata(:,8),DatedData(:,1));

% Append temperatures
Des.C.TempIn = DatedData(:,L.TDesCIn);
Des.C.TempOut = DatedData(:,L.TDesCOut);
Des.R.TempIn = DatedData(:,L.TDesRIn);
Des.R.TempOut = DatedData(:,L.TDesROut);
Des.HX.TempIn = DatedData(:,L.TDesHIn);
Des.HX.TempOut = DatedData(:,L.TDesHOut);
Des.Sump.Temp = DatedData(:,L.TDesSump);

% Append flow rates
Des.C.FlowLPM = DatedData(:,L.LPMdesC);
Des.R.FlowLPM = DatedData(:,L.LPMdesR);

% Convert  conditioner flow rate from [L/m] to [kg/h]
for i = 1:length(Des.C.TempIn)
    Des.C.FlowKH(i) = DensLiCl(Des.C.TempIn(i),Des.C.ConcIn(i))*...
        Des.C.FlowLPM(i)/1000*60;
end

% Transpose
Des.C.FlowInKH  = Des.C.FlowKH'; % [kg/hr]
Des.C.FlowKH = 0;

% Convert regenerator flow rate from [L/m] to [kg/h]
for i = 1:length(Des.C.TempIn)
    Des.R.FlowKH(i) = DensLiCl(Des.R.TempIn(i),Des.R.ConcIn(i))*...
        Des.R.FlowLPM(i)/1000*60;
end

% Transpose
Des.R.FlowInKH  = Des.R.FlowKH'; % [kg/hr]
Des.R.FlowKH = 0;

clear fileToRead DELIMITER HEADERLINES labels MatlabDate...
    rawdata StartRow EndRow i Des.C.FlowKH Des.R.FlowKH