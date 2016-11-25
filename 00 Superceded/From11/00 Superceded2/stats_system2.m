% Script to plot statistics of a given loop, or collection of data points

% MJones - 01 AUG 2009 - Created file
% MJones - 22 AUG 2009 - Update to deal with heirarchical data


function stats_system(states,timeStruct)

for i = 1:length(states)
    currentState = states{i};
    stats_Point2(currentState,timeStruct);
end


end
