function selectedDataMask = func_selection(dataStruct,searchStruct)

%     searchStruct = {{'pointType','.'}};
    
    numSearches = size(searchStruct,2);
    blankMask = logical(zeros(size(dataStruct.headers,2),numSearches))';
    for idxSearch = 1:size(searchStruct,2)
        inHeaderDef = searchStruct{idxSearch}{1};
        % Get the row number of the matched headerDef 
        for idxHeaderDef = 1:size(dataStruct.headerDef,2)
            thisHeaderDef = dataStruct.headerDef{1,idxHeaderDef};
            if ~isempty(regexp(thisHeaderDef, inHeaderDef, 'match'))
                %headerMask = thisHeaderDef;
                %headerRow = dataStruct.headerDef{idxHeaderDef,2};
                headerRow = idxHeaderDef;
            end
        end
        % Found headerMask
        assert(logical(exist('headerRow','var')));
   
        searchPhrase = searchStruct{idxSearch}{2};
        % Now, loop over the selected header row
        for idxCol = 1:size(dataStruct.headers,2)
            thisHeader = dataStruct.headers{headerRow,idxCol};
            if ~isempty(regexp(thisHeader, searchPhrase, 'match'))
                blankMask(idxSearch,idxCol) = 1;
            end                
        end
        
        %display thisHeaderDef
    end
    selectedDataMask = logical(ones(size(dataStruct.headers,2),1))';
    for idxMask = 1:size(blankMask,1)
        selectedDataMask = selectedDataMask & blankMask(idxMask,:);
    end
    

    display(sprintf('Found %i',sum(selectedDataMask)))