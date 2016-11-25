% START FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure - 
figure  % A three window plot
hold on

% Start  sub plot plot
% 
a1 = subplot(3,1,1);
plot(Date(TimeMask),...
        [...
        Cold.Temp(TimeMask,1),Cold.Temp(TimeMask,2)...
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
%ylim([10 35]);
title('Cold temperatures')
legend(...
    Cold.HdrTemp(1,:),Cold.HdrTemp(2,:)...    
    )
% End plot


% Start  sub plot plot
% 
a2 = subplot(3,1,2);
plot(Date(TimeMask),...
        [...
        Hot.Temp(TimeMask,1),Hot.Temp(TimeMask,2)...
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
%ylim([10 35]);
title('Hot temperatures')
legend(...
    Hot.HdrTemp(1,:),Hot.HdrTemp(2,:)...    
    )
% End plot

% Start  sub plot plot
% 
a3 = subplot(3,1,3);
plot(Date(TimeMask),...
        [...
        Cold.Temp(TimeMask,2) - Cold.Temp(TimeMask,1)...
        Hot.Temp(TimeMask,2) - Hot.Temp(TimeMask,1)...        
        ],'LineWidth',2)
datetick('x',DateFormat1)
ylabel('Temperature [C]')
xlabel('Time')
%ylim([10 35]);
title('Change in Temeperatures')
legend(...
    'dT Cold','dT Hot'...    
    )
% End plot


linkaxes([a1 a2 a3], 'x');
hold off

% End plot
% END FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear a1 a2 a3