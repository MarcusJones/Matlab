function plotBoxOverview(timeStruct,dataStruct,dataMask)

startTitleString = datestr(timeStruct.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(timeStruct.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = ['TITLE HERE', ', from ', ...
    startTitleString ' to  ' endTitleString];

set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0; 46/255 139/255 87/255],...
        'DefaultAxesLineStyleOrder',{'-','--'});

%plot(timeStruct.time(timeStruct.Mask,:),,'LineWidth',1)
boxplot(dataStruct.data(timeStruct.Mask,dataMask))
units = dataStruct.headers(dataStruct.rows.units,dataMask);
systems = dataStruct.headers(dataStruct.rows.system,dataMask);
types = dataStruct.headers(dataStruct.rows.pointType,dataMask);
numbers = dataStruct.headers(dataStruct.rows.number,dataMask);
headers = dataStruct.headers(dataStruct.rows.headers,dataMask);
descriptions = dataStruct.headers(dataStruct.rows.description,dataMask);

numbers = cellfun(@int2str, numbers, 'UniformOutput', 0);

spaces = cell(size(units,2),1)';
aaa = cell(size(units,2),1)';
positions = 1:size(units,2);
newLines = cell(size(units,2),1)';
for i = 1:size(spaces,2)
    spaces{i} = ' ';
    aaa{i} = 'a';
    newLines{i} = '\n';
end

%labels = strcat(systems', spaces', types', spaces', numbers', spaces', headers')

labels = strcat(descriptions', systems', spaces', types', spaces', numbers', spaces', headers');
labels = strcat(descriptions');

set(gca,'Xtick',positions,'Xticklabel',labels)

h = gca;

rotateticklabel(h);
set(gca,'Xticklabel',{[]})
