% Script to plot statistics of a given loop, or collection of data points

% MJones - 01 AUG 2009 - Created file
% MJones - 22 AUG 2009 - Update to deal with heirarchical data, modified
% from original


function stats_all(dataStruct,timeStruct)

allSystemNames = fieldnames(dataStruct);

for i = 1:length(allSystemNames)
    trnStates = fieldnames(dataStruct.(allSystemNames{i}));
    for j = 1:length(trnStates)
        stats_system2(dataStruct.(allSystemNames{i}).(trnStates{j}), timeStruct);
    end

end
