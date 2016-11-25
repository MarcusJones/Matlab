function stats = func_print_stats(time,dataFrame,timeMask,dataMask,legendDefinition)

[Y, M, D, H, MN, S] = datevec(time.time(2)-time.time(1));

Interval = H + MN/60 + S/3600;

%% Get legend rows
headerRows = [];
headerTypes = {};
for idxHead = 1:size(legendDefinition,2)
    desiredHead = legendDefinition{idxHead};
    % EXACT match!!!
    desiredHead = strcat('^', desiredHead, '$');
    headerTypes = [headerTypes, desiredHead];
    
    flgFound = logical(0);
    % Get the row number of the desiredHead
    for idxHeaderDef = 1:size(dataFrame.headerDef,1)
        thisHeaderDef = dataFrame.headerDef{idxHeaderDef,1};
        %if ~isempty(regexp(desiredHead, thisHeaderDef, 'match'))
        if ~isempty(regexp(thisHeaderDef,desiredHead, 'match'))
            %display(strcat(thisHeaderDef,thisHeaderDef))
            headerRows = [headerRows dataFrame.headerDef{idxHeaderDef,2}];
            flgFound = logical(1);
            break
        end
    end
    allHeads = []
    for i = 1:size(dataFrame.headerDef,1)
        allHeads = [allHeads , ' ', dataFrame.headerDef{i}]
    end
    assert(flgFound, strcat('Did not find ', desiredHead, ' in labels:', allHeads ))
    % Found headerMask
    assert(logical(exist('headerRows','var')));
end

%% 
% Print legend heads
jprintf(-1,'****** Time step %.2f hours ********\n', Interval);
for idx = 1:size(headerTypes,2)
    jprintf(-1,'%10s, ',headerTypes{idx});
end

% Print stats heads
statHeads = {
    'integ',...
    'mean',...
    'max',...
    'maxTime',...
    'min',...
    'minTime'};
for idx = 1:size(statHeads,2)
    jprintf(-1,'%10s, ',statHeads{idx});
end

jprintf(-1,'\n',statHeads{idx});

framedData = dataFrame.data(timeMask,dataMask);
framedHead = dataFrame.headers(headerRows,dataMask);
%temp = dataFrame.headers(:,dataMask)
assert(size(framedData,2) == size(framedHead,2));

for idxCol = 1:size(framedData,2)
    for idxRow = 1:size(framedHead,1)
        %jprintf(-1,'%10s, ',framedHead{idxRow,idxCol});
        jprintf(-1,'%s, ',framedHead{idxRow,idxCol});
    end
    
    jprintf(-1,'%10.5f, ',sum(framedData(:,idxCol))*Interval);    
    jprintf(-1,'%10.5f, ',mean(framedData(:,idxCol)));
    jprintf(-1,'%10.5f, ',max(framedData(:,idxCol)));
    
    maxTimeMask = framedData(:,idxCol) == max(framedData(:,idxCol));
    maxTimes = time.time(maxTimeMask);
    maxTimeStr = datestr(maxTimes(1));
    jprintf(-1,'%10s, ',maxTimeStr);      
    
    jprintf(-1,'%10.5f, ',min(framedData(:,idxCol)));    

    minTimeMask = framedData(:,idxCol) == min(framedData(:,idxCol));
    minTimes = time.time(minTimeMask);
    minTimeStr = datestr(minTimes(1));
    jprintf(-1,'%10s, ',minTimeStr);   
    
    jprintf(-1,'\n',statHeads{idx});    
end

