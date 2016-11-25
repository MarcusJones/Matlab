function selectedDataMask = selectData(dataStruct,searchSystem,searchPointType,searchNumber,searchHeader,searchUnits)
    
    blankMask = logical(zeros(size(dataStruct.headers,2),1))';
    systemIndices = blankMask;
    pointTypeIndices = blankMask;
    numberIndices = blankMask;
    headerIndices = blankMask;
    unitsIndices = blankMask;
    rows = dataStruct.rows;
    for i = 1:size(dataStruct.headers,2)
        thisSystem = dataStruct.headers{rows.system,i};
        thisPointType = dataStruct.headers{rows.pointType,i};
        thisNumber = dataStruct.headers{rows.number,i};
        thisHeader = dataStruct.headers{rows.headers,i};
        thisUnit = dataStruct.headers{rows.units,i};
        
        % Match system
        if searchSystem
            if strcmp(searchSystem, thisSystem)
                systemIndices(i) = 1;
            end
        else 
            systemIndices(i) = 1;
        end
        % Match point type
        if searchPointType
            if strcmp(searchPointType, thisPointType)
                pointTypeIndices(i) = 1;
            end
        else 
            pointTypeIndices(i) = 1;
        end    
        % Match number
        if searchNumber
            if strcmp(searchNumber, thisNumber)
                numberIndices(i) = 1;
            end
        else 
            numberIndices(i) = 1;
        end 
        % Match header
        if searchHeader
            if strcmp(searchHeader, thisHeader)
                headerIndices(i) = 1;
            end
        else 
            headerIndices(i) = 1;
        end         
        % Match units        
        if searchUnits
            if strcmp(searchUnits, thisUnit)
                unitsIndices(i) = 1;
            end
        else 
            unitsIndices(i) = 1;
        end     


    end

    selectedDataMask = systemIndices & pointTypeIndices & ...
        numberIndices & headerIndices & unitsIndices;
