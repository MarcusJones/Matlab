End = WaterEnd.DataIndex;
Start = WaterStart.DataIndex;

L=End-Start; % this is a built-in MATLAB function that returns the length (# of elements) of the vector x.
sum=0;
for i=Start:End % this loop computes the sum of all elements in array x
    sum=sum+Cold.FlowLPM(TimeMask(i));
end
y=sum/L % the average
format long

plot(Date(TimeMask),...
        [...
        Cold.FlowLPM(TimeMask)...
        ],'LineWidth',2)
%datetick('x',DateFormat1)
ylabel('Flow rate [kg/hr]')
xlabel('Time')
%ylim([0 10000]);
title('Air Absolute Humdities')
legend(...
    'Cold water flow'...    
    )
% End plot