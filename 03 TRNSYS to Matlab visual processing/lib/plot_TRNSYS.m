% This function calculates plots a data vector array over a time vector
% over a given range
%
% INPUTS:
% name
% header cell array
% units cell array
% time vector
% data vector array
% Range structure
%
% OUTPUTS: (No real function outputs, only plot display)
% A formatted plot

function plot_TRNSYS(name,header,units,time,data,Range)
figure
hold on

% Start  sub plot plot
% temperatures;
a1 = subplot(1,1,1);
plot(time(Range.mask),...
    [...
    data(Range.mask,:) ...
    ],'LineWidth',1)
%set(gca,'XTick',[1,2,3,4,5,6]) % Doesn't work?
% Use datetick2 for date zooming
datetick2 %('x',DateFormat1), 
ylabel('Various Units')
xlabel('Time')
%ylim([0 100]);
name = [name ' from ' datestr(Range.start, 'dd-mmmm-yy HH:MM') ' to  ' datestr(Range.end, 'dd-mmmm-yy HH:MM')];
title(name)
legend(strcat(header,units))
% Can't set limits when using datetick2
%xlim([Date(TimeMask(1)), Date(TimeMask(length(TimeMask)))]) 
% End plot
