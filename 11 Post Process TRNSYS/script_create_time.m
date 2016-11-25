%% Create synthetic time

% Clip mask
time.clipStart = datenum([2013 00 00 01 00 00]);
time.clipEnd = datenum([2014 00 00 00 00 00]);

% Synthetic time
numRows = size(dataFrame.data,1);


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
mask.hoursGen = ((hourFractions>=startTime) & (hourFractions<=stopTime));


% Mask - hours 7/16
hourFractions=time.time-floor(time.time);
startHour = 06;
endHour = 18;
startTime=datenum(0,0,0,startHour,0,0);
stopTime=datenum(0,0,0,endHour,0,0);
mask.hoursMonteur = ((hourFractions>=startTime) & (hourFractions<=stopTime));


% Mask - focus
startTime=datenum(2013,8,1,0,0,0);
stopTime=datenum(2013,8,8,0,0,0);
mask.focus = ((time.time>=startTime) & (time.time<=stopTime));

% Mask - COLD Jan
startTime=datenum(2013,1,20,0,0,0);
stopTime=datenum(2013,1,27,0,0,0);
mask.cold = ((time.time>=startTime) & (time.time<=stopTime));

% Mask - UBER 
startTime=datenum(2013,5,2,0,0,0);
stopTime=datenum(2013,5,9,0,0,0);
mask.uber = ((time.time>=startTime) & (time.time<=stopTime));

% Mask - HOT early 
startTime=datenum(2013,8,4,0,0,0);
stopTime=datenum(2013,8,11,0,0,0);
mask.hot = ((time.time>=startTime) & (time.time<=stopTime));



% Mask - weekend
wkd = [];
for i = 1:size(time.time,1)
    satSun = strcmp('Sat',datestr(time.time(i),'ddd')) | strcmp('Sun',datestr(time.time(i),'ddd'));
    wkd = [wkd satSun];
end
mask.weekend = logical(wkd)';

% Mask - workhours
mask.workhoursGen = mask.hoursGen & ~mask.weekend;
mask.workhoursMont = mask.hoursMonteur & ~mask.weekend;

