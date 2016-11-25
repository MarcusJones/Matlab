%% function plot_pData(trnTime,pStruct)
% M. Jones - 03 Sep 09 - Created function
% Plot a 'pStruct', a properly formed structure with all necessary plot
% information

% Inputs:
%systemState - A system state, \ie: trnData.Office.HA
%systemStateVar - The system state variable \ie: 'T';

% Intermediate:
% pData: A column matrix of all points of interest
% pNames: A corresponding cell array with the number of the point stored
% pUnits: A corresponding cell array with the units of the point stored

% Outputs:
% pStruct - Formed structure for data plots

function pStruct = get_pData(systemState,systemStateVar)

% Get data


idxSystemStateVar1 = 0;

% Find the index of the state variable within all arrays
for i = 1:length(systemState{1}.header)
    if strcmp(systemState{1}.header{i}, systemStateVar)
        idxSystemStateVar = i;
    end
end

% If you want ALL the variables...!
flagAll = regexpi(systemStateVar, '^All$', 'match');
if ~isempty(flagAll)
    idxSystemStateVar = 1:length(systemState{1}.header);
end

% If the variable is not found, print an error
if ~idxSystemStateVar
    disp (['ERROR Could not find ''', systemStateVar, ''' in the ''' ...
        systemState{1}.system, ' - ', systemState{1}.type, ''' state']);
end


pData = [];
pUnits = [];
pHeaders = [];
pNames = {};
pDescriptions = {};
% Assemble the arrays
for i = 1:length(systemState)
    pData = [pData, systemState{i}.data(:,idxSystemStateVar)];
    pUnits = [pUnits, systemState{i}.units(:,idxSystemStateVar)];
    pHeaders = [pHeaders, systemState{i}.header(:,idxSystemStateVar)];
    pDescriptions = [pDescriptions, systemState{i}.description];
    for j = 1:length(systemState{i}.header(:,idxSystemStateVar))
        pNames = [pNames, num2str(systemState{i}.number)];
    end
end

pTitle = [systemState{1}.system, ' - ', systemState{1}.type];

if ~isempty(flagAll)
    pYLabel = 'Various units';
else
    pYLabel = [pHeaders{1}, ' ' pUnits{1}];
end

pStruct.Data = pData;
pStruct.Units = pUnits;
pStruct.Headers = pHeaders;
pStruct.Names = pNames;
pStruct.Title = pTitle;
pStruct.yLabel = pYLabel;
pStruct.Descriptions = pDescriptions;


end