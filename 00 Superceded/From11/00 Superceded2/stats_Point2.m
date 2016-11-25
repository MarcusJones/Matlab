% This function calculates basic statistical information on the "data"
% structure and displays results in a text window using the 3rd party
% "jprintf" library. It will calculate over a specified range
%
% INPUTS: 
% name 
% header cell array
% units cell array
% time vector
% data vector array
% Range structure
%
% OUTPUTS: (No real function outputs, only text display)
% true integral of each data vactor given spacing of time vector 
% mean of each data vector
% peak of each data vector

function stats_Point2(statePoint,timeStruct)

%Range
[Y, M, D, H, MN, S] = datevec(timeStruct.time(2)-timeStruct.time(1));

jprintf(-1,'******* %s %s %i *******\n', statePoint.system, statePoint.type,statePoint.number);
jprintf(-1,' %s \n', statePoint.description);


Interval = H + MN/60 + S/3600;

name = [' Stats from ' datestr(timeStruct.rangeStart, 'dd-mmmm-yy HH:MM') ' to  ' datestr(timeStruct.rangeEnd, 'dd-mmmm-yy HH:MM')];

jprintf(-1,'Time step: %.3f hours\n', Interval);
jprintf(-1,'%s \n', name);
jprintf(-1,'%20s %6s %20s %20s %20s %20s\n', 'Variable', 'Units', 'Integral (hours)', 'Mean', 'Max', 'Min');

for i = 1:size(statePoint.headers,2)
    TIntegral(i) = sum(statePoint.data(timeStruct.mask,i))*Interval;
    TMean(i) = mean(statePoint.data(timeStruct.mask,i));
    TPeak(i) = max(statePoint.data(timeStruct.mask,i));
    TMin(i) = min(statePoint.data(timeStruct.mask,i));
    jprintf(-1,'%20s %6s %20.5f %20.5f %20.5f %20.5f\n', char(statePoint.headers(i)), char(statePoint.units(i)), TIntegral(i), TMean(i), TPeak(i), TMin(i));
end
jprintf(-1,'\n\n');

clear TSum TMean TPeak name

% sprintf