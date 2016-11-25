function selectedDataMask = selectData(dataStruct,searchSystem,searchPointType,searchNumber,searchHeader,searchUnits,searchDesc)
    
    blankMask = logical(zeros(size(dataStruct.headers,2),1))';
    systemIndices = blankMask;
    pointTypeIndices = blankMask;
    numberIndices = blankMask;
    headerIndices = blankMask;
    unitsIndices = blankMask;
    descIndices = blankMask;
    rows = dataStruct.rows;
    for i = 1:size(dataStruct.headers,2)
        thisSystem = dataStruct.headers{rows.system,i};
        thisPointType = dataStruct.headers{rows.pointType,i};
        thisNumber = int2str(dataStruct.headers{rows.number,i});
        thisHeader = dataStruct.headers{rows.headers,i};
        thisUnit = dataStruct.headers{rows.units,i};
        thisDesc = dataStruct.headers{rows.description,i};
        % Match system
        if searchSystem
            if ~isempty(regexp(thisSystem, searchSystem, 'match'))
                systemIndices(i) = 1;
            end
        else 
            systemIndices(i) = 1;
        end
        % Match point type
        if searchPointType
            if ~isempty(regexp(thisPointType, searchPointType, 'match'))
                pointTypeIndices(i) = 1;
            end
        else 
            pointTypeIndices(i) = 1;
        end    
        % Match number
        if searchNumber
            if ~isempty(regexp(thisNumber, searchNumber, 'match'))
                numberIndices(i) = 1;
            end
        else 
            numberIndices(i) = 1;
        end 
        % Match header
        if searchHeader
            if ~isempty(regexp(thisHeader, searchHeader, 'match'))
                headerIndices(i) = 1;
            end
        else 
            headerIndices(i) = 1;
        end         
        % Match units        
        if searchUnits
            if ~isempty(regexp(thisUnit, searchUnits, 'match'))
                unitsIndices(i) = 1;
            end
        else 
            unitsIndices(i) = 1;
        end     
        % Match descriptions        
        if searchDesc
            if ~isempty(regexp(thisDesc, searchDesc, 'match'))
                descIndices(i) = 1;
            end
        else 
            descIndices(i) = 1;
        end     

    end

    selectedDataMask = systemIndices & pointTypeIndices & ...
        numberIndices & headerIndices & unitsIndices & descIndices;

    display(sprintf('Found %i',sum(selectedDataMask)))