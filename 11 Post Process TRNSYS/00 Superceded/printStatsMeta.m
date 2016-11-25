function stats = printStatsMeta(time,dataStruct,timeMask,dataMask)

%Range
lineTemplateHeader = ['%10s, %10s, %15s, %5s, %5s, %20s, %20s, '];
dataMatrix = dataStruct.data(timeMask,dataMask);
headerMatrix = dataStruct.headers(:,dataMask);
headerDefs = dataStruct.headerDef;

lineTemplateStats = ['%6s, %6s, %10s, %5s, %5s, %20s, %20s, '];

[Y, M, D, H, MN, S] = datevec(time.time(2)-time.time(1));

jprintf(-1,'**************\n');
Interval = H + MN/60 + S/3600;
jprintf(-1,'Time step: %.3f hours\n', Interval);

integralVec = sum(dataMatrix)*Interval;
meanVec = mean(dataMatrix);
maxVec = max(dataMatrix);
minVec = min(dataMatrix);

maxTimeVec = cell(1,size(dataMatrix,2));
for i = 1:size(dataMatrix,2)
    maxTimeMask = dataMatrix(:,i) == maxVec(i);
    thisMaxTimeVec = time.time(maxTimeMask);
    if ~isa(thisMaxTimeVec, 'double')
        error('Multiple max or min not supported')
    end
    maxTimeVec{i} = datestr(thisMaxTimeVec(1));
end

minTimeVec = cell(1,size(dataMatrix,2));
for i = 1:size(dataMatrix,2)
    minTimeMask = dataMatrix(:,i) == minVec(i);
    thisMinTimeVec = time.time(minTimeMask);
    if ~isa(thisMaxTimeVec, 'double')
        error('Multiple max or min not supported')
    end
    minTimeVec{i} = datestr(thisMinTimeVec(1));
end

jprintf(-1,['%6s, %6s, %6s, %5s, %5s, %20s, %20s, %6s, %6s, %6s, %10s, %6s, %10s, \n'],...
    'head',...
    'units',...
    'point',...
    'system',...
    'type',...
    'number',...
    'desc',...
    'integ',...
    'mean',...
    'max',...
    'maxTime',...
    'min',...
    'minTime'...
    );

jprintf(-1,'\n');

for i = 1:size(dataMatrix,2)
    jprintf(-1,lineTemplateHeader,headerMatrix{:,i});    
    jprintf(-1,'%6.2f, %6.2f, %6.2f, %10s, %6.2f, %10s, ',...
    integralVec(i),...
    meanVec(i),...
    maxVec(i),...
    maxTimeVec{i},...
    minVec(i),...
    minTimeVec{i}...
    );
    jprintf(-1,'\n');

end
