%% function plot_pData(trnTime,pStruct)
% M. Jones - 03 Sep 09 - Created function
% Plot a 'pStruct', a properly formed structure with all necessary plot
% information

% Inputs:
%dataStruct - A struct with;
% .header - A cell array of labels
% .data - A column matrix of data
% .units - A cell array of units

%systemStateVar - The name of the header required

% Intermediate:
% pData: A column matrix of all points of interest
% pNames: A corresponding cell array with the number of the point stored
% pUnits: A corresponding cell array with the units of the point stored

% Outputs:
% pStruct - Formed structure for data plots



function pStruct = func_get_pData(dataStruct,systemStateVar)

% Get data


idxVariable = 0;

% Find the index of the state variable within all arrays
for i = 1:length(dataStruct.header)
    if strcmp(dataStruct.header{i}, systemStateVar)
        idxVariable = i;
        break
    end
end

% If the variable is not found, print an error
if ~idxVariable
    disp (['ERROR Could not find ''', systemStateVar]);
end


pData = [];
pUnits = [];
pHeaders = [];
% Assemble the arrays
for i = 1:length(dataStruct)
    pData = [pData, dataStruct.data(:,idxVariable)];
    pUnits = [pUnits, dataStruct.units(:,idxVariable)];
    pHeaders = [pHeaders, dataStruct.header(:,idxVariable)];

end

pTitle = [' - '];


pYLabel = [pHeaders{1}, ' ' pUnits{1}];


pStruct.Data = pData;
pStruct.Units = pUnits;
pStruct.Headers = pHeaders;
pStruct.Title = pTitle;
pStruct.yLabel = pYLabel;


end