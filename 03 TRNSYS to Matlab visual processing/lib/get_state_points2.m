function statePoints2 = get_state_points2(trnData,searchSystem,searchGroup,x)

% A robust method to return any number of state points
% Pass 'Described' through x to return only described points

% Test data
%searchSystem = 'SHX';
%searchGroup = 'MoistAir';
%x = 'all';
%x = [1 5 7];
%x = 'described';
%

todisplay=[];

if ~iscell(x)
    x={x};
end

for i=1:length(x)
    current=x{i};
    % first handle vectors, which can be colums or rows
    if isvector(current) && ~ischar(current)
        if round(current)==current
            try
                todisplay=[todisplay,current];
            catch
                todisplay=[todisplay,current'];
            end
        else
            error('Vector of Colums to plot contains non-integer Values');
        end
    else
        if ischar(current)
            if ~isempty(regexpi(current,'described','once'))
                %check
                for nStates = 1:length(trnData.(searchSystem).(searchGroup))
                   currDesc = trnData.(searchSystem).(searchGroup){nStates}.description;
                   if isempty(regexp(currDesc,'^.+\..+\..+'))
                       todisplay = [todisplay,nStates];
                   end
                end
            end
            if ~isempty(regexpi(current,'all','once'))
                todisplay=1:length(trnData.(searchSystem).(searchGroup));
            end
        end
    end
end





statePoints2 = {};

found = 0;
% Loop through the systems
trnSystems = fieldnames(trnData);
for iSystems = 1:length(trnSystems)
    if strcmp(trnSystems(iSystems),searchSystem)
        trnGroup = fieldnames(trnData.(trnSystems{iSystems}));
        % Loop through the state groups
        for iGroups = 1:length(trnGroup)
            if strcmp(trnGroup(iGroups),searchGroup)
                % Loop through the state numbers
                for nStates = 1:length(trnData.(trnSystems{iSystems}).(trnGroup{iGroups}))
                    for nToDisplay = 1:length(todisplay)
                        if todisplay(nToDisplay) == trnData.(trnSystems{iSystems}).(trnGroup{iGroups}){nStates}.number
                            statePoints2 = [statePoints2 trnData.(trnSystems{iSystems}).(trnGroup{iGroups}){nStates}];
                            found = 1;
                        end
                    end
                end
            end
        end
    end
end

if found
    return
else
    statePoints2 = 0;
    return
end