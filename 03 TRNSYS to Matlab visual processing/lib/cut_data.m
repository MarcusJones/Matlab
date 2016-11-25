function [trnData trnTime] = cut_data(trnData,trnTime,settings)


clippingMask = trnTime.time >= datenum(settings.simControl.dataRangeStart);

trnTime.time = trnTime.time(clippingMask);
trnTime.hours = trnTime.hours(clippingMask);
%trnTime.operationMask = trnTime.operationMask(clippingMask);
%trnTime.mask = trnTime.mask(clippingMask);

trnSystems = fieldnames(trnData);
% Loop through the statepoints and clip each vector
for i = 1:length(trnSystems)
    trnStates = fieldnames(trnData.(trnSystems{i}));
    % Loop through the state numbers
    for j = 1:length(trnStates)
        % Loop through the state properties (columns)
        for k = 1:length(trnData.(trnSystems{i}).(trnStates{j}))
            trnData.(trnSystems{i}).(trnStates{j}){k}.data = trnData.(trnSystems{i}).(trnStates{j}){k}.data(clippingMask,:);
        end
    end
end

