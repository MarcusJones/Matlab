%% Main

clear

%load('D:\Dropbox\00 Decathlon Development\02 Modeling update (shades)\output.mat');
load('D:\Dropbox\00 Decathlon Development\02 Modeling update (shades)\output2.mat');

%report_state_points(trnData);

%% Work with the time
% Get the datenum
time.time = datenum(time.timeColumns);
% Set the first clip
time.clipStart = datenum([2013 00 00 01 00 00]);
time.clipEnd = datenum([9999 00 00 00 00 00]);

% Hard cut all the data using clipStart and clipEnd
[trnData time] = func_cutData(trnData,time);

% Set a mask

%% TESTING
%Select one variable from a structure (one column)
searchSystem = 'Vent';
searchGroup = 'MoistAir';
searchNumber = 'all';
searchNumber = 1;
searchNumber = [1 2 3 7];
headerSearch = 'T';

ventPlotData = get_pDataNew(trnData,'Vent','MoistAir','all','T')


%%
if 0
    found = 0;
    allSystemNames = fieldnames(trnData);
    for iSystem = 1:length(allSystemNames)
        if strcmp(allSystemNames(iSystem),searchSystem)
            % FOUND searchSystem
            % Loop through the state groups
            trnGroups = fieldnames(trnData.(allSystemNames{iSystem}));
            for iGroup = 1:length(trnGroups)
                if strcmp(trnGroups(iGroup),searchGroup)
                    % FOUND searchGroup
                    % Loop through the state numbers
                    for stateNum = 1:length(trnData.(allSystemNames{iSystem}).(trnGroups{iGroup}))
                        if trnData.(allSystemNames{iSystem}).(trnGroups{iGroup}){stateNum}.number == searchNumber
                            % FOUND searchNumber
                            % Check the data columns
                            theseHeaders = trnData.(allSystemNames{iSystem}).(trnGroups{iGroup}){stateNum}.headers;
                            for iHead = 1:length(theseHeaders)
                                if strcmp(theseHeaders{iHead},headerSearch)
                                    found = 1;
                                    display(sprintf('%s.%s.%i %s',searchSystem, searchGroup,searchNumber,headerSearch));                                
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if ~found
        display(sprintf('NOT FOUND %s.%s.%i %s',searchSystem, searchGroup,searchNumber,headerSearch));                                
    end
end



%% OLD
% Process the headerSearch first - check for 'all', or a vector, or text
x = headerSearch
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
            %catch
                %todisplay=[todisplay,current'];
            end
        else
            error('Vector of Colums to plot contains non-integer Values');
        end
    else
        if ischar(current)
            if ~isempty(regexpi(current,'described','once'))
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



