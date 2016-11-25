% Function - Load the TRNSYS output files
% MJones - 01 AUG 2009 - Created file
% MJones - 22 AUG 2009 Changed file to only work with trnsys files, and
% restructured the data into systems and points. Extensive use of dynamic
% structure labelling, also created a universal time vector trnTime
% Mjones - 06 OCT 2009 - Added enthalpy processing

% trnData is converted into trnData
% trnData - .sys1 - stateType1 - (point1)
%                                   - (point2)
%                                   - (pointn)
%                      - stateType2 - (points)
%                .sys2 - ... etc
%                .sysN - ... etc

% Inputs:
% directory - the target directory
% search - the file search profile ie/ *.out
% Returns: Heirarchical organization

function [y z]= load_trn_files(settings)


tStartLoadFiles=tic;


%% File IO
% Load files

% Used for post-processing
load WaterProps
load AirProps

% Load descriptions
try
    descFile=fopen(settings.fileIO.descriptionsFile);
    descAll=textscan(descFile,'%s %s %s %s', 'delimiter', '_-');
    fclose(descFile);
    description.system = descAll{1};
    description.type = descAll{2};
    description.number = descAll{3};
    description.text = descAll{4};
catch
    disp('No description file found?')
    rethrow(lasterror)
end

% List the files in the directory
files = dir(settings.fileIO.searchMask);

% Read the files into trnFiles structure
DELIMITER = '\t'; % TAB delimeted
HEADERLINES = 2;
trnFiles = [];

h = waitbar(0,'Loading files into active memory');
for i = 1:length(files)
    waitbar(i/length(files));
    fileToRead = fullfile([settings.fileIO.trnsysProjectDirectory, 'OUT' ],files(i).name);
    % Load time array
    if strcmpi(files(i).name, 'Time.out');
        timeTemp = importdata(fileToRead, DELIMITER, HEADERLINES);
        trnTime.hours = timeTemp.data(:,1);
        % Convert the hours into a MATLAB Datenum
        % Coordinate the warm up hours with a buffer year
        simulationStartVector = datevec(settings.simControl.simulationStart);
        trnTime.time = datenum(simulationStartVector(1),0,0,trnTime.hours,0,0);
        % Skip this file from now on, store the Time position
        timePos = i;
    else
        currTrnFile = importdata(fileToRead, DELIMITER, HEADERLINES);
        currTrnFile.colheaders = currTrnFile.textdata(2,:);
        trnFiles = [trnFiles currTrnFile];
    end
end
close(h)

files = vertcat(files(1:timePos-1), files(timePos+1:end));

disp(sprintf(' - Loaded %i files from %s',i,settings.fileIO.searchMask));

clear fileToRead DELIMITER HEADERLINES search directory timeTemp
%% Load files
% Loop through these files and start organizing the data into a structure
h = waitbar(0,'Structuring files (flat)');
for i = 1:length(trnFiles)
    waitbar(i/length(trnFiles));
    % Load file name
    trnFiles(i).name = files(i).name;
    
    % Split the name of the file
    splitLabel = regexp(trnFiles(i).name, '\_', 'split');
    if length(splitLabel)  ~= 3
        
    end
    
    trnFiles(i).type = splitLabel{2};
    trnFiles(i).system = splitLabel{1};
    
    % The regex discards the '.out' that is carried by the name of the
    % file
    trnFiles(i).number = regexp(splitLabel{3}, '\.', 'split');
    % After the match, the result is a cell (1x1)
    % Address that element, which is a char, and converts
    % this char into a num
    trnFiles(i).number = str2num(trnFiles(i).number{1});
    
    % The column headers are the first index of the textdata array
    hdr = char(trnFiles(i).textdata(1,1));
    
    % Collect tokens that are any number of non-white space characters
    trnFiles(i).header = regexp(hdr, '\S+', 'match');
    
    % The units are contained in .colheaders
    trnFiles(i).units = trnFiles(i).colheaders;
    
    % Remove the first column (hours), no longer needed
    trnFiles(i).data(:,1) = [];
    trnFiles(i).header(:,1) = []; % Remove the corresponding hours header
    trnFiles(i).units(:,1) = []; % And the corresponding units
    
    % Add description if available
    trnFiles(i).description = [trnFiles(i).system '.' trnFiles(i).type '.' num2str(trnFiles(i).number)];
    for j = 1:length(description.system)
        if regexpi(trnFiles(i).system, description.system{j})
            if regexpi(trnFiles(i).type, description.type{j})
                if trnFiles(i).number == str2num(description.number{j});
                    trnFiles(i).description = description.text{j};
                end
            end
        end
    end
end
close(h)

% Cleanup
trnFiles = rmfield(trnFiles, 'textdata');
trnFiles = rmfield(trnFiles, 'colheaders');
clear files splitLabel hdr description descriptionsFile descAll

%% Arrage files
% Now we have a flat representation of the trnFiles, the next step is to
% analyze the files, ask what systems and points are being considered, and
% organize this information into a heirarchy

trnData = {};

h = waitbar(0,'Structuring files (hierarchy)');
for i = 1:length(trnFiles)
    waitbar(i/length(trnFiles));
    % Check to see if the system in this i'th file is in our heirarchy yet
    % and add it to the heirarchy if not already listed
    if ~isfield(trnData,trnFiles(i).system)
        % This is a new system, add this to the struct;
        trnData = setfield(trnData, trnFiles(i).system, {});
    end
    
    % Also create a new statepoint type in the structure if the state
    % point does not currently exist
    if ~isfield(trnData.(trnFiles(i).system), trnFiles(i).type)
        trnData.(trnFiles(i).system) = ...
            setfield(trnData.(trnFiles(i).system), trnFiles(i).type, {});
    end
    nStates = 0;
    % How many state points are in this system.group?
    for j = 1:length(trnFiles)
        % Increment the count for a unique 'system' and 'type'
        if (strcmp(trnFiles(j).system,trnFiles(i).system) && strcmp(trnFiles(j).type,trnFiles(i).type))
            nStates = nStates + 1;
        end
    end
    
    % Pre-allocate the state point array
    if isempty(trnData.(trnFiles(i).system).(trnFiles(i).type))
        trnData.(trnFiles(i).system).(trnFiles(i).type) = cell(1, nStates);
    end
    
    % Finally, append the entire dataset into the current level of
    % heirarchy
    trnData.(trnFiles(i).system).(trnFiles(i).type){trnFiles(i).number} = trnFiles(i);
    
    %
    %
    %         trnData.(trnFiles(i).system).(trnFiles(i).type){2} = ...
    %         [trnData.(trnFiles(i).system).(trnFiles(i).type) trnFiles(i)];
end
close(h)

%% Post Processing
% In this section, expand the state points to provide more information

disp(sprintf(' - Post processing;'));
trnSystems = fieldnames(trnData);
for i = 1:length(trnSystems)
    trnStates = fieldnames(trnData.(trnSystems{i}));
    %disp(sprintf('     - System \''%s\'' containing;', trnSystems{i}));
    for j = 1:length(trnStates)
        % Found a 'Fluid' group - add enthalpy
        if (strcmp(trnStates{j},'Fluid'))
            % Loop over each state point in the group
            for k = 1:length(trnData.(trnSystems{i}).(trnStates{j}))
                % Extract the temperature [C]
                try
                    T = trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,1);
                catch
                    disp(sprintf('Check that outfile %i exists', k));
                    rethrow(lasterror)
                end
                % Extract the mass flow rate [kg/hr]
                mf = trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,2);
                % Find the specific heat at this temperature [kJ/(kg.'C)]
                Cp = ...
                    interp1(WaterProps.Temp,WaterProps.SpecHeat,T,'pchip');
                % The equation for enthalpy flow rate
                hf = mf.*Cp.*T; % [kJ/hr]
                % Append this to the data matrix
                trnData.(trnSystems{i}).(trnStates{j}){k}.data = ...
                    [trnData.(trnSystems{i}).(trnStates{j}){k}.data hf];
                % Add the header
                trnData.(trnSystems{i}).(trnStates{j}){k}.header = ...
                    [trnData.(trnSystems{i}).(trnStates{j}){k}.header...
                    'hf'];
                % Add the units too
                trnData.(trnSystems{i}).(trnStates{j}){k}.units = ...
                    [trnData.(trnSystems{i}).(trnStates{j}){k}.units...
                    '[kJ/hr]'];
            end
            %            disp(sprintf ...
            %                ('     - Enthalpy added for %i Fluid points in system %s;',k,trnSystems{i}));
        end
        % Found a 'Fluid' group - add enthalpy
        if (strcmp(trnStates{j},'MoistAir'))
            %             % Loop over each state point in the group
            for k = 1:length(trnData.(trnSystems{i}).(trnStates{j}))
                % Extract the temperature [C]
                try
                    T = trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,1);
                catch
                    disp(sprintf('Check that outfile %i exists', k));
                    rethrow(lasterror)
                end
                % Extract the humidity ratio [kg/kg]
                w = trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,2);
                % Extract the mass flow rate [kg/hr]
                mf = trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,3);
                % Find the specific heat at this temperature [kJ/(kg.'C)]
                H = EnthalpyAir(T,w);
                % The equation for enthalpy flow rate
                hf = mf.*H; % [kJ/hr]
                % Append this to the data matrix
                trnData.(trnSystems{i}).(trnStates{j}){k}.data = ...
                    [trnData.(trnSystems{i}).(trnStates{j}){k}.data hf];
                % Add the header
                trnData.(trnSystems{i}).(trnStates{j}){k}.header = ...
                    [trnData.(trnSystems{i}).(trnStates{j}){k}.header...
                    'hf'];
                % Add the units too
                trnData.(trnSystems{i}).(trnStates{j}){k}.units = ...
                    [trnData.(trnSystems{i}).(trnStates{j}){k}.units...
                    '[kJ/hr]'];
            end
        end
    end
    %            disp(sprintf ...
    %                ('     - Enthalpy added for %i Fluid points in system %s;',k,trnSystems{i}));
end

disp(sprintf('     - Enthalpy added for Fluid & Moist Air points'));


%% Unit conversion
disp(sprintf(' - Unit conversion;'));
trnSystems = fieldnames(trnData);
% Lopp through the systems
for i = 1:length(trnSystems)
    trnStates = fieldnames(trnData.(trnSystems{i}));
    %disp(sprintf('     - System \''%s\'' containing;', trnSystems{i}));
    % Loop through the state groups
    for j = 1:length(trnStates)
        % Loop through the state numbers
        cntConvert = 0;
        for k = 1:length(trnData.(trnSystems{i}).(trnStates{j}))
            % Loop through the state properties (columns)
            
            for m = 1:length(trnData.(trnSystems{i}).(trnStates{j}){k}.units)
                % Found kJ/hr
                if strcmp(regexp(trnData.(trnSystems{i}).(trnStates{j}){k}.units{m}, 'kJ/hr', 'match'),'kJ/hr')
                    trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,m) = ...
                        trnData.(trnSystems{i}).(trnStates{j}){k}.data(:,m)./3600;
                    trnData.(trnSystems{i}).(trnStates{j}){k}.units{m} = '[kW]';
                    % disp(sprintf ...
                    % ('     - Converted kJ/hr to kW in column %i for system %s, state %s,;',...
                    % m,trnSystems{i},trnData.(trnSystems{i}).(trnStates{j}){k}.type));
                    cntConvert = cntConvert + 1;
                end
            end
            
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

% Load custom points
if settings.processControl.flagLoadCustomPoints
    trnData = load_custom_points(trnData,settings.fileIO.customPointsFile);
end

tElapsedLoadFiles=toc(tStartLoadFiles)/60;

logThis(sprintf('Loaded files, %.1fm elapsed',tElapsedLoadFiles),settings)


% All done
y = trnData;
z = trnTime;

end