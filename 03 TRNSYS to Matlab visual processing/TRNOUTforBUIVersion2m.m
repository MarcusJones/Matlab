% NOTES: Space in WINDOW balance file causes error - eliminate

clear

disp('*** Script START ***')

% IMPORTANT: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify the directory containing the ini file, typically the TRNSYS
% project root directory
iniFile = [ 'D:\L SZDLC TRN\TRNVIS.ini'];
% iniFile = [ 'D:\L Ebase TRN\TRNVIS.ini'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set this flag to run the TRNSYS .dck file before processing the data
runDeckFile = 0;

% Set the full filename and path of the initialization file here
% Change to current directory of current file
settings.currFile = mfilename;
settings.currFilePath = mfilename('fullpath');
settings.currFilePath = ...
    settings.currFilePath(1:length(settings.currFilePath) ...
    -length(settings.currFile));
cd(settings.currFilePath);
localLibDir = [pwd, '\lib'];
cd ..;
genLibDir = [pwd, '\01 Libraries'];

% Set the environment path to include the ../lib folder
addpath(genpath(localLibDir));
addpath(genpath(genLibDir));

settings = load_settings(iniFile);

%clear currFile currFilePath iniFile genLibDir localLibDir


%Function needs function [y z]= load_trn_files(directory,search)
%List the files in the directory

balDirectory = [settings.fileio.trnsysprojdir, 'HVAC\'];
%balDirectory = 'T:\04 Reports\Building 20091014\Comparison Design BaseLine\0Pers\';
search = settings.fileio.searchMaskBUI;
%search = 'T:\04 Reports\Building 20091014\Comparison Design BaseLine\0Pers\*.BAL'

%% File IO
files = dir(search);
filesToRead = {};
fileNames ={};
for i = 1:length(files)
    fileName = fullfile(balDirectory,files(i).name);

    %newDir = 'T:\04 Reports\Building 20091014\Comparison Design BaseLine\0Pers\';
    %fileName = fullfile(files,files(i).name);
    if (~isempty(regexp(fileName, 'SUMMARY')) || ~isempty(regexp(fileName, 'zone')))
    else
        filesToRead = [filesToRead fileName];
        fileNames = [fileNames files(i).name];
    end
end

clear files
%
% buiFiles = [];
%
% % Read the files into trnFiles structure
% for i = 1:length(files)
%     fileToRead = fullfile(balDirectory,files(i).name);
%     DELIMITER = ' '; % TAB delimeted
%     HEADERLINES = 2;
%     if (~isempty(regexp(fileToRead, 'SUMMARY')) || ~isempty(regexp(fileToRead, 'zone')))
%     else
%         buiFiles = [buiFiles importdata(fileToRead, DELIMITER, HEADERLINES)]
%         %buiFiles(i) = importdata(fileToRead, DELIMITER, HEADERLINES);
%         disp(sprintf('loaded %s', files(i).name));
%     end
% end
%disp(sprintf('loaded %i BAL files',i));

%%



for iBalFiles = 1 : length (filesToRead)
    allBalHdrs{iBalFiles} = {};

    allBalDatas{iBalFiles} = {};
    allBalUnits{iBalFiles} = {};

    balFile = filesToRead{iBalFiles};
    try

        balFile=fopen(filesToRead{iBalFiles});

        formatStringHdr = '%s %s %*s';
        for i = 1:11
            formatStringHdr = [formatStringHdr ' %s'];
        end
        balHdr=textscan(balFile,formatStringHdr,2);

        for iHeader = 1:length(balHdr)
            allBalHdrs{iBalFiles} = [allBalHdrs{iBalFiles} balHdr{iHeader}(1)];
            allBalUnits{iBalFiles} = [allBalUnits{iBalFiles} balHdr{iHeader}(2)];
        end
        formatString = '%f %f %*s';
        for i = 1:11
            formatString = [formatString ' %f'];
        end
        balAll=textscan(balFile,formatString);
        allBalDatas{iBalFiles} = [allBalDatas{iBalFiles} balAll];
        fclose(balFile);

    catch
        disp('No description file found?')
        rethrow(lasterror)
    end
end

for i = 1 : length(allBalHdrs)
    allBalances{i}.name = fileNames{i};
    allBalances{i}.data = allBalDatas{i};
    allBalances{i}.headers = allBalHdrs{i};
    allBalances{i}.units = allBalUnits{i};
end
clear allBalHdrs allBalUnits
clear formatString formatStringHdr genLibDir
clear fileNames allBalDatas allBalHdrs i runDeckFile
clear localLibDir search iBalFiles balFile balDirectory balAll
clear ans balHdr fileName filesToRead iniFile


%% Unit conversion
disp(sprintf(' - Unit conversion;'));
%trnSystems = fieldnames(trnData);
% Lopp through the balances
for iBalance = 1:length(allBalances)

    %    bal = fieldnames(trnData.(trnSystems{i}));
    %disp(sprintf('     - System \''%s\'' containing;', trnSystems{i}));

    % Loop through the balance file columns
            cntConvert = 0;
    for iBalColumn = 1:length(allBalances{iBalance}.headers)



        % Found kJ/hr
        if ~isempty(regexp(allBalances{iBalance}.units{iBalColumn}, 'kJ/hr', 'match'))
            allBalances{iBalance}.data{iBalColumn} = ...
                allBalances{iBalance}.data{iBalColumn}./3600;
            
            allBalances{iBalance}.units{iBalColumn} = '[kW]';
            
            %trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,m) = ...
            %    trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,m)./3600;
            %trnData.(trnSystems{i}).(trnStates{j}){k}.units{m} = '[kW]';
            % disp(sprintf ...
            % ('     - Converted kJ/hr to kW in column %i for system %s, state %s,;',...
            % m,trnSystems{i},trnData.(trnSystems{i}).(trnStates{j}){k}.type));
            cntConvert = cntConvert + 1;
        end



        if cntConvert
            %disp(sprintf ...
            %    ('     - Converted kJ/hr to kW for %i %s state(s) in system \''%s\'';',...
            %    cntConvert,trnData.(trnSystems{i}).(trnStates{j}){k}.type,trnSystems{i}));


        end
    end
end
if cntConvert
    disp(sprintf('     - Converted kJ/hr to kW'));
end


%% Plot
headers = [];
units = [];
for i = 1:length(allBalances{1}.headers)
    hold on
    plot(allBalances{1}.data{1},allBalances{1}.data{i})
    headers = [headers, allBalances{1}.headers(i)];
    units = [units, allBalances{1}.units(i)];
end

legend(strcat(headers, '_', units), 'interpreter', 'none');

clear headers units iHeader i





%% Get balance for one column
%[balHeader balSum] = get_balSum(balHdr,balAll,searchHdr)
% labels = {};
% barY = [];
% for i = 1:length(allBalances)
%     allBalances{i}
%     %[balHeader balSum] = get_balSum(balHdr,balAll,'QCOOL');
%     labels = [labels allBalances{i}.name];
%     [dum barYtemp] = get_balSum(allBalances{i}.header,allBalances{i}.data,'QCOOL');
%     barY = [barY barYtemp./3600000];
% end
% bar0=barY
% bar1600=barY
% y = bar0
% y = bar1600
% [bar0' bar1600']
% y = ans'
% y2 = y
%
% %y = [A1 A2; B1 B2; C1 C2];
% %labels = {'Design' 'b' 'Baseline'}
%
%
% bar(y,'grouped')
% set(gca,'xticklabel',labels)
%
%
% %            set(h,'xlabel',bData.desc)








% %% Post-Processing
% for i = 1:length(buiFiles)
%
%     buiFiles(i).name = files(i).name;
%     % Split the name of the file
%     splitLabel = regexp(buiFiles(i).name, '\_', 'split');
%     buiFiles(i).domain = splitLabel{1};
%     buiFiles(i).region = splitLabel{2};
%     if ~isempty(regexp(buiFiles(i).region, '\.', 'match'))
%         buiFiles(i).region = strrep(buiFiles(i).region, '.BAL', '');
%     else
%
%     end
%
%     regexp(buiFiles(i).name, '\d+', 'match')
%
%
%
%
%     buiFiles(i).number = regexp(buiFiles(i).name, '\d+', 'match');
%
%     if ~isempty(buiFiles(i).number)
%         buiFiles(i).number = str2num(buiFiles(i).number{1});
%     else
%
%     end
%
%     % Collect the header and units
%     currHdrLine = buiFiles(i).textdata(1,:);
%     currUnitLine = buiFiles(i).textdata(2,:);
%
%     % Split on the | character
%     splitHdrLine = regexp(currHdrLine, '\|', 'split');
%     splitUnitLine = regexp(currUnitLine, '\|', 'split');
%
%     % Split each header
%     splitHdrLine = regexp(splitHdrLine{1}{2}, '\s+', 'split');
%     splitUnitLine = regexp(splitUnitLine{1}{2}, '\s+', 'split');
%
%     % The first character is blank, skip
%     for j = 2:length(splitHdrLine)
%         if splitHdrLine{j}
%             buiFiles(i).header{j-1} = splitHdrLine{j};
%             buiFiles(i).units{j-1} = splitUnitLine{j};
%         else
%             % Found a blank cell, skip
%         end
%
%     end
% end
%
% % Now we have a flat representation of the buiFiles, the next step is to
% % analyze the files, ask what domains and points are being considered, and
% % organize this information into a heirarchy
% balData = {};
%
% for i = 1:length(buiFiles)
%
%     % Check to see if the system in this i'th file is in our heirarchy yet
%     % and add it to the heirarchy if not already listed
%     if ~isfield(balData,buiFiles(i).domain)
%         % This is a new system, add this to the struct;
%         balData = setfield(balData, buiFiles(i).domain, {});
%     end
%
%     % Also create a new statepoint type in the structure if the state
%     % point does not currently exist
%     if ~isfield(balData.(buiFiles(i).domain), buiFiles(i).region)
%         balData.(buiFiles(i).domain) = ...
%             setfield(balData.(buiFiles(i).domain), buiFiles(i).region, {});
%     end
%
%     % Finally, append the entire dataset into the current level of
%     % heirarchy
%     balData.(buiFiles(i).domain).(buiFiles(i).region) = ...
%         [balData.(buiFiles(i).domain).(buiFiles(i).region) buiFiles(i)];
% end
%
%
%
% %for i