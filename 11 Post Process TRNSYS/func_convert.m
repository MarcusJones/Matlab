function converted_df = func_convert(df, headdef, previous_unit, new_unit, factor)

    %inHeaderDef = searchStruct{idxSearch}{1};
    % Get the row number of the matched headerDef 
    for idxHeaderDef = 1:size(df.headerDef,2)
        thisHeaderDef = df.headerDef{1,idxHeaderDef};
        if ~isempty(regexp(thisHeaderDef, headdef, 'match'))
            %headerMask = thisHeaderDef;
            %headerRow = dataStruct.headerDef{idxHeaderDef,2};
            headerRow = idxHeaderDef;
        end
    end
    % Found headerMask
    assert(logical(exist('headerRow','var')));

    data_col_mask = logical(zeros(1,size(df.headers,2)));
    
    % Now, loop over the selected header row
    for idxCol = 1:size(df.headers,2)
        thisHeader = df.headers{headerRow,idxCol};
        if ~isempty(regexp(thisHeader, previous_unit, 'match'))
            data_col_mask(idxCol) = 1;
        end                
    end
    
    df.headers(headerRow,data_col_mask) = {new_unit};
    
    df.data(:,data_col_mask) = df.data(:,data_col_mask) * factor;
    
    %selectedDataMask = logical(ones(size(dataStruct.headers,2),1))';
    %for idxMask = 1:size(blankMask,1)
    %    selectedDataMask = selectedDataMask & blankMask(idxMask,:);
    %end
    

    display(sprintf('Converted %i columns from %s to %s factor %f',sum(data_col_mask), previous_unit, new_unit,factor))
    
    converted_df = df;