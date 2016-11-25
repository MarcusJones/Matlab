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

function stats_TRNSYS(name,header,units,time,data,Range)

%Range
[Y, M, D, H, MN, S] = datevec(time(2)-time(1));

Interval = H + MN/60 + S/3600;
name = [' Stats for ' name ' from ' datestr(Range.start, 'dd-mmmm-yy HH:MM') ' to  ' datestr(Range.end, 'dd-mmmm-yy HH:MM')];

jprintf(-1,'Time step: %.3f hours\n', Interval);
jprintf(-1,'%s \n', name);
jprintf(-1,'%020s %6s %20s %20s %20s %20s\n', 'Variable', 'Units', 'Integral (hours)', 'Mean', 'Max', 'Min');
for i = 1:size(header,2)
    TIntegral(i) = sum(data(Range.mask,i))*Interval;
    TMean(i) = mean(data(Range.mask,i));
    TPeak(i) = max(data(Range.mask,i));
    TMin(i) = max(data(Range.mask,i));
    jprintf(-1,'%20s %6s %20.5f %20.5f %20.5f %20.5f\n', char(header(i)), char(units(i)), TIntegral(i), TMean(i), TPeak(i), TMin(i));
end
jprintf(-1,'\n\n');

clear TSum TMean TPeak name

% sprintf