function [found varColumn] = get_var_column(statePoint,variable)
found = 0;
% Loop through the variables
try
    for k = 1 : length(statePoint.header)
        searchVariable = regexp(variable, '\w+', 'match');
        searchVariable = searchVariable{1};
        if strcmp(searchVariable,statePoint.header{k})
            varColumn=statePoint.data(:,k);
            found = 1;
        end
    end
catch
    statePoint
    variable
    rethrow(lasterror)
end

if found
    return
else
    found = 0;
    return
end

