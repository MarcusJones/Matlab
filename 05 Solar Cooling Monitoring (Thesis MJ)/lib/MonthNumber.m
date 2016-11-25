function MonthNumber = MonthNumber(Day)

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
    MonthNumber = 1;
elseif Day <= 60
    MonthNumber = 2;
elseif Day <= 91
    MonthNumber = 3;   
elseif Day <= 121
    MonthNumber = 4;    
elseif Day <= 152
    MonthNumber = 5;    
elseif Day <= 182
    MonthNumber = 6;    
elseif Day <= 213
    MonthNumber = 7;    
elseif Day <= 244
    MonthNumber = 8;
elseif Day <= 274
    MonthNumber = 9;
elseif Day <= 305
    MonthNumber = 10;
elseif Day <= 335
    MonthNumber = 11;    
elseif Day <= 366
    MonthNumber = 12;    
else 
    MonthNumber = -1;
end

end
