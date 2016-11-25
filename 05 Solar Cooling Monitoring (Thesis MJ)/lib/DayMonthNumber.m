function DayMonthNumber = DayMonthNumber(Day)

% Converts julian day number into ordinal month
% Written for 2008, which is a leap year

%Month	Day	hour	hour
%JAN	1	0	744
%FEB	32	744	1416
%MAR	60	1416	2160
%APR	91	2160	2880
%MAY	121	2880	3624
%JUN	152	3624	4344
%JUL	182	4344	5088
%AUG	213	5088	5832
%SEP	244	5832	6552
%OCT	274	6552	7296
%NOV	305	7296	8016
%DEC	335	8016	8760

if Day <= 31 
    DayMonthNumber = Day;
elseif Day <= 60
    DayMonthNumber = Day - 31;
elseif Day <= 91
    DayMonthNumber = Day - 60;   
elseif Day <= 121
    DayMonthNumber = Day - 91;    
elseif Day <= 152
    DayMonthNumber = Day - 121;    
elseif Day <= 182
    DayMonthNumber = Day - 152;    
elseif Day <= 213
    DayMonthNumber = Day - 182;    
elseif Day <= 244
    DayMonthNumber = Day - 213;
elseif Day <= 274
    DayMonthNumber = Day - 244;
elseif Day <= 305
    DayMonthNumber = Day - 274;
elseif Day <= 335
    DayMonthNumber = Day - 305;    
elseif Day <= 366
    DayMonthNumber = Day - 335;    
else 
    DayMonthNumber = -1;
end

end
