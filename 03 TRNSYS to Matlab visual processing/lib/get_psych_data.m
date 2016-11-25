% Script to plot statistics of a given loop, or collection of data points

% MJones - 01 AUG 2009 - Created file
% MJones - 22 AUG 2009 - Update to deal with heirarchical data, modified
% from original


function psyData = get_psych_data(trnData,trnTime,searchSystem,searchTime)

snapTimeStr = datestr(searchTime,0);

% Find the time snapshot index
if ((trnTime.time(1) <= searchTime) && (trnTime.time(end) >= searchTime))
    idxTime = trnTime.time >= searchTime;
    indSnap = find(idxTime);
    try
        indSnap = indSnap(1);
    catch
        error(['Can''t find time ', snapTimeStr, ' in time array!'])
        rethrow(lasterror);
    end
else
    error(...
    [dateStr(searchTime,0), ' is not between ' , dateStr(trnTime.time(1),0),...
    ' and ' dateStr(trnTime.time(end),0)]);
end

% Store the names of the systems
trnSystems = fieldnames(trnData);
% Loop through the systems
for i = 1:length(trnSystems)
    % Look for the system
    if (strcmp(trnSystems{i},searchSystem))
        psyData.system = searchSystem;
        % Store the names of the states
        trnStates = fieldnames(trnData.(trnSystems{i}));
        % Loop through the sates
        for j = 1:length(trnStates)
            % Check for a psychrometric state, defined by the system name
            if strcmp(trnStates{j},'MoistAir')
                % Rename the current system-state array
                currSys = trnData.(trnSystems{i}).(trnStates{j});
                % Initialize the temperature, humidity, and label
                Tv = [];
                Wv = [];
                numbers = {};
                descriptions = {};
                labels = {}
                % Loop through each point in the system-state
                for k = 1:length(currSys)
                    % Assemble T, w, name
                    % 'T' is first column, 'w' is second of .data array
                    Tv = [Tv currSys{k}.data(indSnap,1)];
                    Wv = [Wv currSys{k}.data(indSnap,2)];
                    numbers = [numbers ['' int2str(currSys{k}.number)]];
                    descriptions = [descriptions currSys{k}.description]
                    labels = [labels numbers{k} descriptions{k}]
                end
            end
        end
    end
end

psyData.T = Tv;
psyData.w = Wv;
psyData.labels = labels;
psyData.time = snapTimeStr;
psyData.numbers = numbers;

