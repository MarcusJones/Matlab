function  snapIdx = find_snaptime_index(trnTime, snapTime)


% Find the time snapshot index
if ((trnTime.time(1) <= snapTime) && (trnTime.time(end) >= snapTime))
    idxTime = trnTime.time >= snapTime;
    indSnap = find(idxTime);
    try
        snapIdx = indSnap(1);
    catch
        error(['Can''t find time ', snapTimeStr, ' in time array!'])
        rethrow(lasterror);
    end
else
    error(...
        [dateStr(snapTime,0), ' is not between ' , dateStr(trnTime.time(1),0),...
        ' and ' dateStr(trnTime.time(end),0)]);
end