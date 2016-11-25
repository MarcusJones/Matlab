function [dataStruct time] = cut_data(dataStruct,time)


clippingMask = (time.time >= time.clipStart) & (time.time <= time.clipEnd);


time.time = time.time(clippingMask);
%time.hours = time.hours(clippingMask);
%time.operationMask = time.operationMask(clippingMask);
%time.mask = time.mask(clippingMask);

theSystems = fieldnames(dataStruct);
% Loop through the statepoints and clip each vector
for i = 1:length(theSystems)
    trnStates = fieldnames(dataStruct.(theSystems{i}));
    % Loop through the state numbers
    for j = 1:length(trnStates)
        % Loop through the state properties (columns)
        for k = 1:length(dataStruct.(theSystems{i}).(trnStates{j}))
            dataStruct.(theSystems{i}).(trnStates{j}){k}.data = dataStruct.(theSystems{i}).(trnStates{j}){k}.data(clippingMask,:);
        end
    end
end

