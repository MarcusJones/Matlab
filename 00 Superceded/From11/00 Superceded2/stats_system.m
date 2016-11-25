% Script to plot statistics of a given loop, or collection of data points

% MJones - 01 AUG 2009 - Created file
% MJones - 22 AUG 2009 - Update to deal with heirarchical data


function stats_system(states,timeStruct)

for i = 1:length(states)
    stats_Point(statePoint,timeStruct,states{i}.data)
end

% for i = 1:size(TData,2)
%     stats_TRNSYS(trnData(i).name,...
%         trnData(i).header,...
%         trnData(i).units,...
%         trnData(i).datenum,...
%         trnData(i).data,Settings.Range);
% end

end
