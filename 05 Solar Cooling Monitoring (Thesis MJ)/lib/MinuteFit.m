function y = MinuteFit(time,Y,Range)

% This function fits a nonstandard desiccant list into a minute by minute
% Time is the desiccant time data
% Y is the corresponding value


% Minutes = time(length(time))-time(1);
% Minutes = datevec(Minutes);

%datevec(time(1))
%datevec(time(length(time)))

% if Minutes(2) ~= 0
%     'ERROR - Months not well interpolated in desiccant data!'
% end

% Minutes = Minutes(3)*1440 + Minutes(4)*60 + Minutes(5);

% xi = time(1):1/1440:time(length(Y));

y = interp1(time,Y,Range,'linear');

% Plot the fit
% hold off
% 
% plot(time,Y,'o')
% hold on
% plot(xi,y,'.')

