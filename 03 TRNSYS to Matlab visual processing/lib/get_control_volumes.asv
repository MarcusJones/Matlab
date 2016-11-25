
function cvData = get_cv_data(trnData,trnTime,snapTime)


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

%
% Load control volumes
cvFile = 'D:\L SZDLC TRN\HVAC\Control Volumes2.txt';
try
    cvFile=fopen(cvFile);
    cvAll=textscan(cvFile,'%s %f %f %s %s ', 'delimiter', '(,):=');
    fclose(cvFile);
catch
    disp('No description file found?')
    rethrow(lasterror)
end

cv = {};

for i = 1 : length (cvAll{1})
    cv{i}.type = cvAll{1}{i};
    cv{i}.x = cvAll{2}(i);
    cv{i}.y = cvAll{3}(i);
    cv{i}.title = cvAll{4}{i};
    cv{i}.equation = cvAll{5}{i};
end

%idx = logical(1)
% Remove commented lines
for i = 1 : length(cv)
    idx(i) = logical(1);
    if ~isempty(regexp(cv{i}.type, '%', 'match'))
        idx(i) = 0;
    end
end

cv = cv(idx);

for i = 1 : length (cv)
    splitEq = regexp(cv{i}.equation, '-', 'split');
    cv{i}.inlets = regexp(splitEq{1}, '+', 'split');
    cv{i}.outlets = splitEq(2:end);
end

% Loop through the cv's
for i = 1 : length(cv)
    % loop through the inlets
    cv{i}.inletData = [];
    for j = 1:length(cv{i}.inlets)
        splitInlet = regexp(cv{i}.inlets{j}, '\.', 'split');
        % Remove leading or trailing white space!!!
        searchSystem = splitInlet{1};
        searchSystem = regexp(searchSystem, '\w+', 'match');
        searchSystem = searchSystem{1};
        searchGroup = splitInlet{2};
        searchGroup = regexp(searchGroup, '\w+', 'match');
        searchGroup = searchGroup{1};
        searchState = str2num(splitInlet{3});
        searchVariable = cv{i}.type;
        % Get the state point
        foundPoint = get_state_point(trnData,searchSystem,searchGroup,searchState);
        % Get the data column for the specified variable
        [foundVarCol varCol] = get_var_column(foundPoint,searchVariable);
        if foundVarCol
            cv{i}.inletData = [cv{i}.inletData varCol];
        end
    end
    % loop through the outlets
    cv{i}.outletData = [];
    for j = 1:length(cv{i}.outlets)
        splitOutlet = regexp(cv{i}.outlets{j}, '\.', 'split');
        % Remove leading or trailing white space!!!
        searchSystem = splitOutlet{1};
        searchSystem = regexp(searchSystem, '\w+', 'match');
        searchSystem = searchSystem{1};
        searchGroup = splitOutlet{2};
        searchGroup = regexp(searchGroup, '\w+', 'match');
        searchGroup = searchGroup{1};
        searchState = str2num(splitOutlet{3});
        searchVariable = cv{i}.type;
        % Get the state point
        foundPoint = get_state_point(trnData,searchSystem,searchGroup,searchState);
        % Get the data column for the specified variable
        [foundVarCol varCol] = get_var_column(foundPoint,searchVariable);
        if foundVarCol
            cv{i}.outletData = [cv{i}.outletData varCol];
        end
    end
end

% Loop through the cv's
for i = 1 : length(cv)
    if isempty(cv{i}.inletData)
       cv{i}.inletData = zeros(length(cv{i}.outletData));
    end
    if isempty(cv{i}.outletData)
       cv{i}.outletData = zeros(length(cv{i}.inletData));
    end
    cv{i}.balanceVector = sum(cv{i}.inletData,2) - sum(cv{i}.outletData,2);
    cv{i}.balanceAverage = mean(cv{i}.balanceVector);
    cv{i}.balanceSnap = cv{i}.balanceVector(indSnap);
end

cvData = cv;

return 

%[Found Vec] = get_var_column(get_state_point(trnData,'CTCC','Fluid',6),'T')
%[Found Vec] = get_var_column(get_state_point(trnData,'CTCC','Fluid',10),'T')%

%[Found Vec] = get_var_column(get_state_point(trnData,'Office','Fluid',3),'T')



