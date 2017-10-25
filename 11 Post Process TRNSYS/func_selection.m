function selectedDataMask = func_selection(and_or, dataStruct,searchStruct)

%     searchStruct = {{'pointType','.'}};
    
    numSearches = size(searchStruct,1);
    blankMask = logical(zeros(size(dataStruct.headers,2),numSearches))';
    
    for idxSearch = 1:size(searchStruct,1)
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
    
    if strcmp(and_or,'and') 
        %selectedDataMask = logical(ones(size(dataStruct.headers,2),1))';
        selectedDataMask = blankMask(1,:);
        for idxMask = 1:size(blankMask,1)
            selectedDataMask = selectedDataMask & blankMask(idxMask,:);
        end
    elseif strcmp(and_or,'or') 
        %selectedDataMask = logical(ones(size(dataStruct.headers,2),1))';
        selectedDataMask = blankMask(1,:);
        for idxMask = 1:size(blankMask,1)
            selectedDataMask = selectedDataMask | blankMask(idxMask,:);
        end
    else
        error('Use "and" or "or" only' )
    end
    
    sum(blankMask')
    display(sprintf('Found %i',sum(selectedDataMask)))