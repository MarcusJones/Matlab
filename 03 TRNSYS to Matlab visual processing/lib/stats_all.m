% Script to plot statistics of a given loop, or collection of data points

% MJones - 01 AUG 2009 - Created file
% MJones - 22 AUG 2009 - Update to deal with heirarchical data, modified
% from original


function stats_all(trnData,trnTime)

trnSystems = fieldnames(trnData);

for i = 1:length(trnSystems)
    trnStates = fieldnames(trnData.(trnSystems{i}));
    for j = 1:length(trnStates)
        stats_system(trnData.(trnSystems{i}).(trnStates{j}), trnTime);
    end

end
