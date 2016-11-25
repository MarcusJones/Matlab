function pStruct = get_pDataNew(dataStruct,searchSystem,searchGroup,searchNumber,headerSearch)

% First, collect the state points
thesePoints = get_state_points3(dataStruct,searchSystem,searchGroup,searchNumber);


% Check the data columns for all statePoints
% Loop over flattened points
for iPoint = 1:length(thesePoints)
    currentPoint = thesePoints{iPoint};
    % Loop over headers 
    found = 0;
    for iHead = 1:length(currentPoint.headers)
        thisHead = currentPoint.headers{iHead};
        if strcmp(thisHead,headerSearch)
            found = 1;
            break
        end
    end
    %if ~found
    %    error('Cant find that header anywhere');
    %end
end

pData = [];
pUnits = [];
pHeaders = [];
pNames = {};
pDescriptions = {};
for iPoint = 1:length(thesePoints)
    currentPoint = thesePoints{iPoint};
    for i = 1:length(currentPoint.headers)
        if strcmp(currentPoint.headers{i}, headerSearch)
            idxDataColumn = i;
            pData = [pData, currentPoint.data(:,idxDataColumn)];
            pUnits = [pUnits, currentPoint.units(:,idxDataColumn)];
            pHeaders = [pHeaders, currentPoint.headers(:,idxDataColumn)];
            pDescriptions = [pDescriptions, currentPoint.description];
            pNames = [pNames, num2str(currentPoint.number)];
         
            
        end
    end
end

pTitle = [searchSystem, ' - ', searchGroup];

pYLabel = [pHeaders{1}, ' ', pUnits{1}];

pStruct.Data = pData;
pStruct.Units = pUnits;
pStruct.Headers = pHeaders;
pStruct.Names = pNames;
pStruct.Title = pTitle;
pStruct.yLabel = pYLabel;
pStruct.Descriptions = pDescriptions;


return

% theseHeaders = trnData.(allSystemNames{iSystem}).(trnGroups{iGroup}){stateNum}.headers;
% for iHead = 1:length(theseHeaders)
%     if strcmp(theseHeaders{iHead},headerSearch)
%         found = 1;
%         display(sprintf('%s.%s.%i %s',searchSystem, searchGroup,searchNumber,headerSearch));                                
%     end
% end