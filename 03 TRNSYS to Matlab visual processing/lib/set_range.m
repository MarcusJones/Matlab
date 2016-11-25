% function settings = set_range(settings,time,useEntire)
% MJones - 22 Aug 2009 - updated for new structure & time vector
%

function y = set_range(trnTime,startVal,endVal,useEntire)

if useEntire
    trnTime.Range.mask = 1:length(trnTime.time);
    trnTime.Range.start = trnTime.time(1);
    trnTime.Range.end = trnTime.time(end);
    disp(sprintf(' - Data range set to entire range; \n    %s to %s', ...
        datestr(trnTime.Range.start, 'dd-mmmm-yy HH:MM'),...
        datestr(trnTime.Range.end, 'dd-mmmm-yy HH:MM')));
else
    startC = find(trnTime.time==startVal); % Use specified start
    endC = find(trnTime.time==endVal); % Use specified end
    trnTime.Range.mask = startC:endC; % Define time mask 
    % (the elements of the time vector which should be used)
    disp(sprintf(' - Data range set to entire range %s to %s', ...
        datestr(startVal, 'dd-mmmm-yy HH:MM'),...
        datestr(endVal, 'dd-mmmm-yy HH:MM')));
end

[Y, M, D, H, MN, S] = datevec(trnTime.time(2)-trnTime.time(1));

trnTime.interval = H + MN/60 + S/3600;

y = trnTime;
end
