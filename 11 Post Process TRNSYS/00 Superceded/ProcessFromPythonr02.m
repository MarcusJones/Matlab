%% Main

clear

thisDataFile = 'D:\Dropbox\00 Decathlon Development\MatlabOutput\output2.mat';
test.mat
%thisDataFile = 'D:\Dropbox\00 Decathlon Development\02 Modeling update (shades)\output.mat';
load(thisDataFile);
clear thisDataFile
%report_state_points(trnData);

{'header','T'}{'system','beuro'}

theData.rows.system           = 1;
theData.rows.pointType        = 2;
theData.rows.number           = 3;
theData.rows.headers          = 4;                 
theData.rows.description      = 5;
theData.rows.units            = 6;
theData.rows.sourceFilePath   = 7;


%% Work with the time

% Clip mask
time.clipStart = datenum([2013 00 00 01 00 00]);
time.clipEnd = datenum([2014 00 00 00 00 00]);

% Get the datenum
time.time = datenum(time.timeColumns);

% Synthetic time
time.syntheticTime = zeros(8760,6)
time.syntheticTime = [time.syntheticTime(:,1:3) [0:8759]' time.syntheticTime(:,5:end)];
time.syntheticTime(:,1) = 2013
time.time = datenum(time.syntheticTime);

% Hard cut all the data using clipStart and clipEnd
%[trnData time] = func_cutData(trnData,time);

% Set a time mask
time.Mask = logical(ones(size(time.time,1),1));


%% TESTING
% Work with new flat structure
searchSystem = '';
searchPointType = '';
searchNumber = '';
searchHeader = 'T'
searchUnits = '';

% Prototype: selectData(dataStruct,rows,searchSystem,searchPointType,searchNumber,searchHeader,searchUnits)
%sum(thisMask)


%% Smartcampus Weather
dataMask = selectData(theData,'ZAMG Hohe Warte 2003.epw','','',' DryBulb','');

plotTimeSeries(time,theData,dataMask);

binSize = -20:5:40;
plotHistogram(time,theData,dataMask,binSize);

