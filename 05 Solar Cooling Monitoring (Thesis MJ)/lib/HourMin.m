function [HOUR,MIN] = HourMin(HHMM)

% Convert HHMM to HH, MM

% Convert to string
str = int2str(HHMM);

% Check length
Lngth = size(str);
Lngth = Lngth(2);

% Pad zeroes
if Lngth <= 1 
    str = strcat('000',str);
elseif Lngth <= 2 
    str = strcat('00',str);
elseif Lngth <= 3
    str = strcat('0',str);
end

HH = str(1:2);
MM = str(3:4);

HOUR = str2num(HH);
MIN = str2num(MM);

end
