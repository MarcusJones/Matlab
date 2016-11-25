function thisSum = func_compare_sum(time,dataFrame,timeMask,dataMask,legendDefinition)
[Y, M, D, H, MN, S] = datevec(time.time(2)-time.time(1));

Interval = H + MN/60 + S/3600;

%% Get legend rows
headerRows = [];
headerTypes = {};
for idxHead = 1:size(legendDefinition,2)
    desiredHead = legendDefinition{idxHead};
    headerTypes = [headerTypes, desiredHead];
    % Get the row number of the desiredHead 
    for idxHeaderDef = 1:size(dataFrame.headerDef,1)
        thisHeaderDef = dataFrame.headerDef{idxHeaderDef,1};
        %if ~isempty(regexp(desiredHead, thisHeaderDef, 'match'))
        if ~isempty(regexp(thisHeaderDef, desiredHead, 'match'))
            %headerMask = thisHeaderDef;
            %desiredHead 
            %thisHeaderDef
            headerRows = [headerRows dataFrame.headerDef{idxHeaderDef,2}];
        end
    end
    % Found headerMask
    assert(logical(exist('headerRows','var')));
end

framedData = dataFrame.data(timeMask,dataMask);
framedHead = dataFrame.headers(headerRows,dataMask);
assert(size(framedData,2) == size(framedHead,2));

thisSumMatrix = [];
for idxCol = 1:size(framedData,2)
    thisSumMatrix = [thisSumMatrix sum(framedData(:,idxCol))*Interval];
end

thisSum.heads = fliplr(framedHead);
thisSum.vals = fliplr(thisSumMatrix);


end
