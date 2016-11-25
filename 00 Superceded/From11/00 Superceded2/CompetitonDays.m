%% 
clear
display(sprintf(' - Start'))

script_loadSchedules
script_loadEPW
script_expandEPW
script_getTimeStructEPW

%% TimeStruct Schedules
numTimePoints = length(sched.data(:,2));

timeStructSched.time = datenum(...
    2013*ones(numTimePoints,1),...
    epw.data(:,2), ...
    epw.data(:,3),...
    epw.data(:,4),...
    epw.data(:,5),...
    0*ones(numTimePoints,1)...
);

timeStructSched.Range.mask = logical(ones(numTimePoints,1));
timeStructSched.Range.start = timeStructSched.time(1);
timeStructSched.Range.end = timeStructSched

%% Get pData

dataToPlot = {'Dry Bulb Temperature (C)'...
    'Relative Humidity'...
    'Horizontal Infrared Radiation from Sky (Wh/m2)'...
    };

pDataVector = [];
for i = 1:length(dataToPlot)
    pDataVector = [pDataVector get_pData2(epw, dataToPlot{i})];
end

%pDataVector(1)

%testPdata = get_pData2(epw, 'Dry Bulb Temperature (C)');

%% Plot

% Loop over all columns
numberOfData = length(pDataVector);
allAxesHandles = [];

figHandle = figure();
set(figHandle, 'PaperOrientation', 'Portrait');
set(figHandle, 'PaperUnits', 'normalized');
set(figHandle, 'PaperType', 'A3');
%rect = [left, bottom, width, height]
subfigDeltaLeft = -0.05;
subfigDeltaBottom = -0.0;
subfigDeltaWidth =  0.1;
subfigDeltaHeight = 0.05;


for dataIdx = 1:numberOfData
    thisAxisHandle = subplot(numberOfData,1,dataIdx);
    thisPos = get(thisAxisHandle, 'pos');
    thisPos(1) = thisPos(1) + subfigDeltaLeft;
    thisPos(2) = thisPos(2) + subfigDeltaBottom;
    thisPos(3) = thisPos(3) + subfigDeltaWidth;
    thisPos(4) = thisPos(4) + subfigDeltaHeight;
    set(thisAxisHandle, 'pos', thisPos);
    
    plot_pData2(thisAxisHandle, timeStructEPW, pDataVector(dataIdx));
    
    allAxesHandles = [allAxesHandles  thisAxisHandle]
end

datetick2

%plot_pData2(timeStructEPW,testPdata)

%x = ones(1,10)'

%logical(

%% Plot

% Loop over all columns
numberOfData = length(sched.schedules,2)
allAxesHandles = []

figHandle = figure()
set(figHandle, 'PaperOrientation', 'Portrait')
set(figHandle, 'PaperUnits', 'normalized')
set(figHandle, 'PaperType', 'A3')
%rect = [left, bottom, width, height]
subfigDeltaLeft = -0.05
subfigDeltaBottom = -0.0
subfigDeltaWidth =  0.1
subfigDeltaHeight = 0.05

for dataCol = 1:numberOfData
    thisAxisHandle = subplot(numberOfData,1,dataCol);
    thisPos = get(thisAxisHandle, 'pos');
    thisPos(1) = thisPos(1) + subfigDeltaLeft
    thisPos(2) = thisPos(2) + subfigDeltaBottom
    thisPos(3) = thisPos(3) + subfigDeltaWidth;
    thisPos(4) = thisPos(4) + subfigDeltaHeight;
    set(thisAxisHandle, 'pos', thisPos);
    
    allAxesHandles = [allAxesHandles  thisAxisHandle]
end
linkaxes(allAxesHandles) 
  
datetick2

for handleNum = 1:size(allAxesHandles,2)
    set(allAxesHandles(handleNum), 'xTick', []);
end


%area(sched.datenum, sched.schedules(:, 1))


%% (Generation of columns)




display(sprintf('%f, %s',x, datestr(x,'YY-mmm-DD HH:MM:ss') ))

startYear = 2013
startMonth = 10
startDay = 3
for daynum = 0:16 
    for thisHour = 0.5:0.5:24
        x = datenum( ...
        startYear, ... 
        startMonth, ...
        startDay + daynum, ...
        thisHour, ...
        0, ...
        0);
        dayNumDecath = daynum + 11;
        display(sprintf('%i, %f, %s, %s', dayNumDecath, x, datestr(x,'ddd'),datestr( x,'YY-mmm-DD HH:MM:ss') ))
    end
end 