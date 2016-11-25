% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - 
figure  % A three window plot
hold on


% Load first range of dates for data
% datestr(DatedData(length(DatedData(:,1)),1) - DatedData(1,1) )
% N = datenum(Y, M, D, H, MN, S)
Start = datenum(2008, 7, 15, 7, 0, 0);
Start = find(Date==Start); % Use specified start
%Start = 1;                           % Or just use start of data 
End =   datenum(2008, 7, 15, 18, 0, 0);
End = find(Date==End); % Use specified ending
%End = length(Date); % Or just use the end of data
TimeMask = Start:End;
DateFormat1 = 0;

% Start  sub plot plot
% 
a1 = subplot(1,1,1);
plot(Date(TimeMask),...
        [...
            Perf.R.COPth_Des(TimeMask)...
            Perf.R.COPth_Air(TimeMask)...
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('??')
xlabel('Time')
ylim([0 2]);
title('COPs compared')
legend(...
    'From Des','From Air'...
    )
% End plot


% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Average(Perf.R.COPth_Des, 0, x.Position(1), y.Position(2));
Average(Perf.R.COPth_Air, 0, x.Position(1), y.Position(2));

clear a1 a2