% This script shows you the range of dates for the data

FirstDate = datestr(DatedData(1,1))
LastDate = datestr(DatedData(length(DatedData(:,1)),1))

FirstDate = datevec(DatedData(1,1));
LastDate = datevec(DatedData(length(DatedData(:,1)),1));

Months = LastDate(2) - FirstDate(2)
Days = LastDate(3) - FirstDate(3)
Hours = LastDate(4) - FirstDate(4)
Minutes = LastDate(5) - FirstDate(5)

% datestr(DatedData(length(DatedData(:,1)),1) - DatedData(1,1) )
% N = datenum(Y, M, D, H, MN, S)
% Start = datenum(2008, 6, 13, HH(i), MM(i), 0);
% End

% find(Air.Amb(:,2)==26.0400)
