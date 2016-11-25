%% Load Schedules

sheduleFileName =  'Schedules r02.xlsx';
scheduleFilePath = 'D:\Dropbox\SD-Engineering\Calendar and schedules';
scheduleFileSheet = 'Main';

[rawData.num,rawData.txt,rawData.raw] = xlsread([scheduleFilePath '\' sheduleFileName] ,scheduleFileSheet);

sched.header = rawData.txt(1, 6:end);

sched.datenum = rawData.num(:,1);

sched.data = rawData.num(:,6:end);
sched.data(isnan(sched.data)) = 0;

sched.units = {}
for i = 1:size(sched.data,2)
    sched.units = [sched.units '-'];
end

%clear rawData

clearvars -except sched epw epwExp

display(sprintf(' - Loaded schedules'))

