% Function - Load settings file
% MJones
% Loads an INI file into the settings structure
% Important fields:
% search path
% Date range
% Also a flag to use the date range, or complete range

function y = load_settings(iniFile)

% Load the settings
settings = ini2structUpperCase(iniFile);

%% Assemble full file search mask (To search for TRNSYS output files)
settings.fileIO.searchMask = fullfile(settings.fileIO.trnsysProjectDirectory,...
    ['OUT\', '*', settings.fileIO.fileExtension]);

settings.fileIO.searchMaskBUI = fullfile(settings.fileIO.trnsysProjectDirectory,...
    ['HVAC\', '*', '.BAL']);


%% ini2struct defaults to string input, convert start & stop to numbers;
%settings.dateRange.useEntire = str2num(settings.dateRange.useEntire);
% settings.clippingRange.start = datenum(...
%     settings.clippingRange.year1, ...
%     settings.clippingRange.month1, ...
%     settings.clippingRange.day1, ...
%     settings.clippingRange.hour1, ...
%     settings.clippingRange.min1, ...
%     settings.clippingRange.sec1 ...
%     );
% settings.clippingRange.end = datenum(...
%     settings.clippingRange.year2, ...
%     settings.clippingRange.month2, ...
%     settings.clippingRange.day2, ...
%     settings.clippingRange.hour2, ...
%     settings.clippingRange.min2, ...
%     settings.clippingRange.sec2 ...
%     );

%% Timestep control
% Timestep to step
%stepSeconds = settings.simControl.stepSeconds;
% Timestep to print
%printSeconds = 5*60;

stepSecondsTotal = ...
    settings.simControl.stepSeconds + ...
    settings.simControl.stepMinutes*60;

printSecondsTotal = ...
    settings.simControl.printSeconds + ...
    settings.simControl.printMinutes*60;

settings.simControl.timeStepStr = [int2str(stepSecondsTotal) '/3600'];
settings.simControl.timeStep = stepSecondsTotal/3600;
settings.simControl.printIntervalStr = [int2str(printSecondsTotal) '/3600'];
settings.simControl.printInterval = printSecondsTotal/3600;
%printIntervalMultiplier = printInterval / timeStep;

%% Simulation duration control
%settings.simControl.simulationStart
%settings.simControl.simulationStop
%settings.simControl.dataRangeStart

settings.simControl.simulationTotalHours = (datenum(settings.simControl.simulationStop) - ...
    datenum(settings.simControl.simulationStart)) * 24;

[Y, M, D, H, min, s] = datevec(settings.simControl.simulationStart);

settings.simControl.warmUpHours = datenum([Y, 12, 31, 24, 0, 0] - [Y, M, D, H, min, s])* 24;

settings.simControl.simulationStartHour = 8760 - settings.simControl.warmUpHours;
settings.simControl.simulationStopHour = settings.simControl.simulationStartHour + settings.simControl.simulationTotalHours;

%simulationStart = 21-Dec-2009 00:00:00
%simulationStop = 31-Dec-2010 24:00:00
%# To cut any warm up days;
%dataRangeStart = 31-Dec-2009 24:00:00





% settings.simControl.simulationStartHourWithWarmUp = settings.simControl.simulationStartHour - settings.simControl.warmUpHours;
% settings.simControl.simulationStopHourWithWarmUp = settings.simControl.simulationStopHour;
% settings.simControl.flagBufferYear = 0;
% % If the warm up hours go into a prior year, adjust as follows
% if settings.simControl.simulationStartHourWithWarmUp < 0
%     settings.simControl.flagBufferYear = 1;
%     settings.simControl.simulationStartHourWithWarmUp = 8760 + settings.simControl.simulationStartHourWithWarmUp;
%     settings.simControl.simulationStopHourWithWarmUp = settings.simControl.simulationStopHour + 8760;
% end

settings.simControl.simulationTotalHours = settings.simControl.simulationStopHour - settings.simControl.simulationStartHour;
settings.simControl.numberTimeSteps = settings.simControl.simulationTotalHours / settings.simControl.timeStep;

y = settings;

end

