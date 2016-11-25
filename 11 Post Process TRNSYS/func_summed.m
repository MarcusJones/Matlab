function sumStruct = func_summed(time,dataStruct,timeMask,dataMask,customDesc);
% Selection
% allBu = selectDataRegexp(theData,...
%     'Bldg','','','Ef','','Buero');
% coolAll = selectDataRegexp(theData,'Bldg','','','Ef','','Ideal Cool');
% coolBu = allBu & coolAll;
% sum(coolBu)
% theData.headers(:,coolBu)
%plotTimeSeries(time,theData,mask.all,coolBu);
%print_stats00(time,theData,mask.all,coolBu);


dataSelection = dataStruct.data(timeMask,dataMask);
summedData.data = sum(dataSelection,2);
dataSelectHeads = dataStruct.headers(:,dataMask); % DUMMY HEAD
summedData.headers = dataSelectHeads(:,1);
summedData.headers{7} = customDesc;
%summedData.headerDef = dataStruct.headerDef;
%summedData.rows = dataStruct.rows;

sumStruct.data = [dataStruct.data summedData.data];
sumStruct.headers = [dataStruct.headers summedData.headers];
sumStruct.headerDef = dataStruct.headerDef;
