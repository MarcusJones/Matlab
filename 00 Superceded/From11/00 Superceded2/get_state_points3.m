function statePoints = get_state_points2(dataStruct,searchSystem,searchGroup,x)
% A robust method to return any number of state points

% Test data
%searchSystem = 'SHX';
%searchGroup = 'MoistAir';
%x = 'all'; - Return all
%x = [1 5 7]; - 
%x = 'described';
%


if isnumeric(x)
    returnPts = x;
elseif ischar(x)
    if ~isempty(regexpi(x,'all','once'))
        %returnPts=1:length(dataStruct.(searchSystem).(searchGroup));
        % Just return them all...
        statePoints = dataStruct.(searchSystem).(searchGroup)
        return
    else
        error('Unknown string, use only "all"');
    end
else
    error('Unknown parameter');
end

statePoints = {};

found = 0;
% Loop through the systems
trnSystems = fieldnames(dataStruct);
for iSystems = 1:length(trnSystems)
    if strcmp(trnSystems(iSystems),searchSystem)
        % FOUND system
        trnGroup = fieldnames(dataStruct.(trnSystems{iSystems}));
        % Loop through the state groups
        for iGroups = 1:length(trnGroup)
            if strcmp(trnGroup(iGroups),searchGroup)
                % FOUND state type
                
                % Loop through the desired state numbers
                for nToReturn = 1:length(returnPts)
                    desiredPointNum = returnPts(nToReturn);
                    %display(sprintf('Checking for point %i',desiredPointNum))
                    % Check for a match in all points
                    found = 0;
                    for nStates = 1:length(dataStruct.(trnSystems{iSystems}).(trnGroup{iGroups}))
                        currentPoint = dataStruct.(trnSystems{iSystems}).(trnGroup{iGroups}){nStates};
                        
                        %display(sprintf('Comparing to %i',currentPoint.number))
                        if desiredPointNum == currentPoint.number
                            statePoints = [statePoints dataStruct.(trnSystems{iSystems}).(trnGroup{iGroups}){nStates}];
                            found = 1;
                            %display(sprintf('Found: %i, break',returnPts(nToReturn)))
                            % Found it, break out and 
                            break
                        end
                        

                    end
                    
                    if ~found
                        error(sprintf('This point doesnt exist: %i',desiredPointNum))
                    end                    
                end
                
            end
        end
    end
end

if found
    return
end

% todisplay=[];
% 
% if ~iscell(x)
%     x={x};
% end
% 
% for i=1:length(x)
%     current=x{i};
%     % first handle vectors, which can be colums or rows
%     if isvector(current) && ~ischar(current)
%         if round(current)==current
%             try
%                 todisplay=[todisplay,current];
%             catch
%                 todisplay=[todisplay,current'];
%             end
%         else
%             error('Vector of Colums to plot contains non-integer Values');
%         end
%     else
%         if ischar(current)
%             if ~isempty(regexpi(current,'described','once'))
%                 %check
%                 for nStates = 1:length(dataStruct.(searchSystem).(searchGroup))
%                    currDesc = dataStruct.(searchSystem).(searchGroup){nStates}.description;
%                    if isempty(regexp(currDesc,'^.+\..+\..+'))
%                        todisplay = [todisplay,nStates];
%                    end
%                 end
%             end
%             if ~isempty(regexpi(current,'all','once'))
%                 todisplay=1:length(dataStruct.(searchSystem).(searchGroup));
%             end
%         end
%     end
% end
