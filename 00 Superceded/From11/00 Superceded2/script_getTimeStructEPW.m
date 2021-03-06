numTimePoints = length(epw.data(:,2));

timeStructEPW.time = datenum(...
    2013*ones(numTimePoints,1),...
    epw.data(:,2), ...
    epw.data(:,3),...
    epw.data(:,4),...
    epw.data(:,5),...
    0*ones(numTimePoints,1)...
);

timeStructEPW.Range.mask = logical(ones(numTimePoints,1));
timeStructEPW.Range.start = timeStructEPW.time(1);
timeStructEPW.Range.end = timeStructEPW.time(end);