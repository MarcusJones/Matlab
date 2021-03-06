function trnData = load_custom_points(trnData,customFile)


% Find the time snapshot index

% Load control volumes into customPointsAll

try
    customFileFH=fopen(customFile);
    customPointsAll=textscan(customFileFH,'%s %s %f %s %s %s %s', 'delimiter', '_,=');
    fclose(customFileFH);
catch
    disp('No file found?')
    rethrow(lasterror)
end

custom = {};

for i = 1 : length (customPointsAll{1})
    custom{i}.system = customPointsAll{1}{i};
    custom{i}.type = customPointsAll{2}{i};
    custom{i}.number = customPointsAll{3}(i);
    custom{i}.header = customPointsAll{4}{i};
    custom{i}.units = customPointsAll{5}{i};
    custom{i}.description = customPointsAll{6}{i};
    custom{i}.equation = customPointsAll{7}{i};
end

%idx = logical(1)
% Remove commented lines
for i = 1 : length(custom)
    idx(i) = true;
    if ~isempty(regexp(custom{i}.system, '%', 'match'))
        idx(i) = 0;
    end
end

custom = custom(idx);

%custom2 = custom(idx)

for i = 1 : length (custom)
    splitEq = regexp(custom{i}.equation, '-', 'split');
    custom{i}.inlets = regexp(splitEq{1}, '+', 'split');
    custom{i}.outlets = splitEq(2:end);
end

% Loop through the custom's
for i = 1 : length(custom)
    % loop through the inlets
    custom{i}.inletData = [];
    for j = 1:length(custom{i}.inlets)
        splitInlet = regexp(custom{i}.inlets{j}, '\.', 'split');
        % Remove leading or trailing white space!!!
        searchSystem = splitInlet{1};
        searchSystem = regexp(searchSystem, '\w+', 'match');
        searchSystem = searchSystem{1};
        searchGroup = splitInlet{2};
        searchGroup = regexp(searchGroup, '\w+', 'match');
        searchGroup = searchGroup{1};
        searchState = str2num(splitInlet{3});
        searchVariable = custom{i}.header;
        % Get the state point
        foundPoint = get_state_point(trnData,searchSystem,searchGroup,searchState);
        % Get the data column for the specified variable
        %try
        %if foundPoint
            [foundVarCol varCol] = get_var_column(foundPoint,searchVariable);
        %end
        %catch
        %foundPoint;
        %searchVariable;
        %            rethrow(lasterror)
        %end
        if foundVarCol
            custom{i}.inletData = [custom{i}.inletData varCol];
        end
    end
    % loop through the outlets
    custom{i}.outletData = [];
    for j = 1:length(custom{i}.outlets)
        splitOutlet = regexp(custom{i}.outlets{j}, '\.', 'split');
        % Remove leading or trailing white space!!!
        searchSystem = splitOutlet{1};
        searchSystem = regexp(searchSystem, '\w+', 'match');
        searchSystem = searchSystem{1};
        searchGroup = splitOutlet{2};
        searchGroup = regexp(searchGroup, '\w+', 'match');
        searchGroup = searchGroup{1};
        searchState = str2num(splitOutlet{3});
        searchVariable = custom{i}.header;
        % Get the state point
        foundPoint = get_state_point(trnData,searchSystem,searchGroup,searchState);
        % Get the data column for the specified variable

        if strcmp(class(foundPoint),'struct')
            [foundVarCol varCol] = get_var_column(foundPoint,searchVariable);
        end

        %    j
        %    rethrow(lasterror)

        if foundVarCol
            custom{i}.outletData = [custom{i}.outletData varCol];
        end
    end
end

% Loop through the custom's
for i = 1 : length(custom)
    if isempty(custom{i}.inletData)
        custom{i}.inletData = zeros(length(custom{i}.outletData),1);
    end
    if isempty(custom{i}.outletData)
        custom{i}.outletData = zeros(length(custom{i}.inletData),1);
    end
    custom{i}.data = sum(custom{i}.inletData,2) - sum(custom{i}.outletData,2);
    newData = custom{i}.data;
    custom{i}.name = [custom{i}.system custom{i}.type num2str(custom{i}.number)];
    newName = custom{i}.name;
    newType = custom{i}.type;
    Tsystem = custom{i}.system;
    newNumber = custom{i}.number;
    newHeader = {custom{i}.header};
    newUnits = {custom{i}.units};
    newDescrption = custom{i}.description;

    if ~isfield(trnData, Tsystem)
        trnData = ...
            setfield(trnData, Tsystem, {});
    end

    if ~isfield(trnData.(Tsystem), newType)
        trnData.(Tsystem) = ...
            setfield(trnData.(Tsystem), newType, {});
    end

    trnData.(Tsystem).(newType){newNumber}.data = newData;
    trnData.(Tsystem).(newType){newNumber}.name =newName;
    trnData.(Tsystem).(newType){newNumber}.type = newType;
    trnData.(Tsystem).(newType){newNumber}.system = Tsystem;
    trnData.(Tsystem).(newType){newNumber}.number = newNumber;
    trnData.(Tsystem).(newType){newNumber}.header = newHeader;
    trnData.(Tsystem).(newType){newNumber}.units = newUnits;
    trnData.(Tsystem).(newType){newNumber}.description = newDescrption;
    %    trnData.(newSystem).
    %custom{i}.balanceAverage = mean(custom{i}.balanceVector);
end

disp(sprintf(' - Loaded %i custom points from %s', i, customFile));

%cvData = custom;

return

%[Found Vec] = get_var_column(get_state_point(trnData,'CTCC','Fluid',6),'T')
%[Found Vec] = get_var_column(get_state_point(trnData,'CTCC','Fluid',10),'T')%

%[Found Vec] = get_var_column(get_state_point(trnData,'Office','Fluid',3),'T')



