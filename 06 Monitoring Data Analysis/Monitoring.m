% Monitoring data script
% M. Jones - v1, 31 Aug 09 - Created file

clear

fileToRead = 'D:\L Scripts\02L Matlab\06 Monitoring Data Analysis\AllData2.csv';

delimiter = ';'; % .CSV
headerLines = 10;

file = importdata(fileToRead, delimiter, headerLines);

time = file.data(:,1)+ 695422;

labels = regexp(file.textdata(end), ';', 'split');

for i = 1:length(labels{1})
    disp(labels{1}(i));
end


% Store the systems into this array
%systemCollection = {};

% for i = 1:length(file.colheaders)
%     splitLabel = regexp(file.colheaders(i), '-', 'split');
%     system = splitLabel{1}{1};
%     if system % There
%         if ~isfield(system,systemCollection)
%             % This is a new system, add this to the struct;
%             systemCollection = setfield(systemCollection, system, {});
%         end
%     end
% end
% 
% xlsread