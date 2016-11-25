%% Main

clear

% Set the environment paths
addpath('D:\Scripting\All Scripts\L Matlab\11 Post Process TRNSYS\');
addpath(genpath('D:\Scripting\All Scripts\L Matlab\01 Libraries\'));

% Set the environment path to include the ../FIG folder for this project
%addpath('D:\Freelance\086_SmartCampus1\FIG\');
%addpath('D:\Freelance\086_SmartCampus1\FIG\');

thisDataFilePath = 'D:\Freelance\086_SmartCampus1\FIG\';
thisDataFilePath = 'D:\Freelancing\086_SmartCampus1\FIG\';
%loadThis = 'test';
%loadThis = '29AugBasis';
%loadThis = 'aug29_ImmerVerschattung';
loadThis = 'final';
loadThis = 'finalIdeal';

thisDataFile = [thisDataFilePath loadThis];

load(thisDataFile);
clear thisDataFile loadThis thisDataFilePath

%% Create synthetic time

% Clip mask
time.clipStart = datenum([2013 00 00 01 00 00]);
time.clipEnd = datenum([2014 00 00 00 00 00]);

% Synthetic time
numRows = size(dataFrame.data,1)


time.syntheticTime = zeros(numRows,6);
hoursVec = [0:1:numRows-1]';
time.syntheticTime = [time.syntheticTime(:,1:3) hoursVec time.syntheticTime(:,5:end)];
time.syntheticTime(:,1) = 2013;
time.time = datenum(time.syntheticTime);

% Mask - all
mask.all = logical(ones(size(time.time,1),1));

% Mask - hours 7/16 
hourFractions=time.time-floor(time.time);
startHour = 07;
endHour = 16;
startTime=datenum(0,0,0,startHour,0,0);
stopTime=datenum(0,0,0,endHour,0,0);
mask.hours = ((hourFractions>=startTime) & (hourFractions<=stopTime));

% Mask - focus
startTime=datenum(2013,8,1,0,0,0);
stopTime=datenum(2013,8,8,0,0,0);
mask.focus = ((time.time>=startTime) & (time.time<=stopTime));

% Mask - early Jan
startTime=datenum(2013,1,5,0,0,0);
stopTime=datenum(2013,1,12,0,0,0);
mask.cold = ((time.time>=startTime) & (time.time<=stopTime));


% Mask - weekend
wkd = [];
for i = 1:size(time.time,1)
    satSun = strcmp('Sat',datestr(time.time(i),'ddd')) | strcmp('Sun',datestr(time.time(i),'ddd'));
    wkd = [wkd satSun];
end
mask.weekend = logical(wkd)';

% Mask - workhours
mask.workhours = mask.hours & ~mask.weekend;

%% TESTING
% Get a frame
searchStruct = {{'pointType','.'}};
searchStruct = {{'pointType','Pow'}};
testMask = func_selection(dataFrame,searchStruct);

% Statistical summary
legendDef = {'system','pointType','number','description','units'};
func_print_stats(time,dataFrame,mask.all,testMask,legendDef);

% Box plot overview
legendDef = {'Serial'};
searchStruct = {{'Serial','.'}};
testMask = func_selection(dataFrame,searchStruct);
plot_box(time,dataFrame,mask.all,testMask,legendDef);

% Time series
plotDef.xLabel = '';
plotDef.yLabel = 'kW';
plotDef.title = 'Title';
plot_time_series(time,dataFrame,mask.all,testMask,legendDef,plotDef);

% Histogram
searchStruct = {{'labels','T'},{'description','Buero'}};
testMask = func_selection(dataFrame,searchStruct);
bins = 0:.1:40;
plotDef.xLabel = 'Temp C';
plotDef.yLabel = 'Freq';
plotDef.title = 'Title';
plot_histogram_lines(time,dataFrame,mask.all,testMask,legendDef,plotDef,bins);

% Overtimes
plotDef.xLabel = 'Temp C';
plotDef.yLabel = 'Freq';
plotDef.title = 'Title';
plot_over_temp(time,dataFrame,mask.all,testMask,legendDef,plotDef,bins);
