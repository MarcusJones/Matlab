function statePoint = get_state_point(trnData,searchSystem,searchGroup,searchNumber)

%searchSystem = 'CTCC';
%searchGroup = 'Fluid';
%searchNumber = 1;
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
                    if searchNumber == trnData.(trnSystems{iSystems}).(trnGroup{iGroups}){nStates}.number
                        statePoint = trnData.(trnSystems{iSystems}).(trnGroup{iGroups}){nStates};
                        found = 1;
                    end
                end
            end
        end
    end
end

if found
    return
else
    statePoint = 0;
    return
end

