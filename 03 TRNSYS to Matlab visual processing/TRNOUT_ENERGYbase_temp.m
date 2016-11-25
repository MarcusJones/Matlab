%% TRNSYS -> MATLAB Visualization script
% Description
% This script reads in PROPERLY FORMATTED TRNSYS .out files, with units
% All files in target directory are loaded (Set in INI file).
% Unit conversions are possible: [kJ/h] to [kW]
% Results are plotted and statistics are generated
% This script is designed to work with output from type 25b - user supplied
% units.

%% File IO

%pause(4*60*60)
%pause(3*60*60)
%pause(1*60*60)
%pause(10*60)

clear

% Set this flag to run the TRNSYS .dck file before processing the data
flagRunDeckFile = 0;
flagChangeWeather = 0;
flagLoadCustomPoints = 0;
flagCheckDckErrors = 0;
updateSVGDiagrams = 0;
timeReport = 0;
averageTrnData = 0;
flagMaskOn =0;
flagSaveWorkspace = 0;
flagCutData = 0;

tStartTotal=tic;

% logFH = fopen('Y:\03 Daten\SavedSimulationResults\lastLog.txt','w');
% fprintf(logFH, 'Started simulation at %s \n',datestr(now))
% fclose(logFH)

disp('*** Script START ***')

% IMPORTANT: 4
% Specify the directory containing the ini file, typically the TRNSYS
% project root directory

% iniFile = 'D:\L SZDLC TRN\TRNVIS.ini';
iniFile = 'D:\L_ENERGYbase_TRN\TRNVIS.ini';
%iniFile = 'D:\L SZDLC TRN\TRNVIS Solar ABS.ini';
%iniFile = 'D:\L SZDLC TRN\TRNVIS Baseline.ini';

% descriptionsFile = 'D:\L SZDLC TRN\PROCESS\Descriptions.txt';
% descriptionsFile = 'D:\L SZDLC TRN\PROCESS\DescriptionsBL.txt';
descriptionsFile = 'D:\L_ENERGYbase_TRN\PROCESS\Descriptions.txt';

% customPointsFile = 'D:\L SZDLC TRN\PROCESS\CustomPoints.txt';
% customPointsFile = 'D:\L SZDLC TRN\PROCESS\CustomPointsBL.txt';
customPointsFile = 'D:\L_ENERGYbase_TRN\CustomPointsBL.txt';

%customPointsFile = 'D:\L SZDLC TRN\PROCESS\CustomPoints Solar Thermal Alone.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

settings = load_settings(iniFile);

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

clear currFile currFilePath iniFile genLibDir localLibDir

%% Create and load data
%
% % Optional: Run the TRNSYS deck file

tStartTRNSYS=tic;

if flagRunDeckFile

    % Force the weather file
    if flagChangeWeather
        replaceinfile('Al_Ain_5cold5hot.met','AL_Buraymi.met',settings.fileio.trnsysrunfile,'-nobak');
    end
    %replaceinfile('AL_Buraymi.met','Al_Ain_5cold5hot.met',settings.fileio.trnsysrunfile);

    % Delete the OUT files
    delete(settings.fileio.searchMask);

    %replaceinfile('VERSION','..\WEA\AL_Buraymi.met',settings.fileio.trnsysrunfile)
    %VERSION
    settings.fileio.trnsysrunprog = 'D:\Apps\Trnsys16_1\Exe\TRNExe.exe';
    trnExe = [settings.fileio.trnsysrunprog, ' ', ...
        '"' settings.fileio.trnsysrunfile, '"', ' /n'];
    % /n switch removes end dialog
    dos(trnExe)
    disp(sprintf(' - Executed %s',trnExe));
end

if flagCheckDckErrors
    disp(sprintf(' - Checking for execution errors in log file'));
    fin = fopen(settings.fileio.trnsyslogfile);
    logFile.cntLines = 0;
    logFile.notConverged = 0;
    logFile.errors = 0;
    while ~feof(fin)
        logFile.cntLines = logFile.cntLines + 1;
        %disp(logFile.cntLines)
        s = fgetl(fin);
        if ~isempty(regexp(s, 'The inputs to the listed units have not converged at this timestep.', 'once' ))
            logFile.notConverged = logFile.notConverged + 1;
        end
        if ~isempty(regexp(s, '*** Fatal Error', 'once' ))
            logFile.errors = logFile.errors +1;
        end
    end
    fclose(fin);

    if logFile.errors
        error('The .dck file had an error, aborting run!');
    end
    disp(sprintf(' - %f convergence warnings',logFile.notConverged));
end

tElapsedTRNSYS=toc(tStartTRNSYS)/60;

clear trnExe runDeckFile0

%logFH = fopen('Y:\03 Daten\SavedSimulationResults\lastLog.txt','a');
%fprintf(logFH, 'Passed the trnsys execution section at %s \n',datestr(now))
%fclose(logFH)
% Load the TRNSYS files into the TData struct
[trnData trnTime] = ...
    load_trn_files(settings.fileio.trnsysprojdir,...
    settings.fileio.searchMask,descriptionsFile);
% Load custom points
if flagLoadCustomPoints
    trnData = load_custom_points(trnData,customPointsFile);
end
%trnData = load_custom_points(trnData,'D:\L SZDLC TRN\PROCESS\CustomPointsTemp.txt');


% Perform unit conversion DISABLED!
% TData = convert_units(TData);

% Set the range for plotting
trnTime = set_range(trnTime,...
    settings.Range.start,settings.Range.end,...
    settings.Range.useEntire);

% Set the mask for plotting
trnTime = set_operation_mask(trnTime,flagMaskOn);

[Y, M, D, H, MN, S] = datevec(trnTime.time(2)-trnTime.time(1));
trnTime.intervalHours = H + MN/60 + S/3600;
clear Y M D H MN S

%logFH = fopen('Y:\03 Daten\SavedSimulationResults\lastLog.txt','a');
%fprintf(logFH, 'Passed the load files section at %s \n',datestr(now))
%fclose(logFH)

%% Snapshot time
snapTime = datenum(2000, 00, 02, 12, 00, 0);

%% Cut the data
if flagCutData
    script_cut_trndata
end
%% Statistics
% stats_all(trnData, trnTime);

%% Psychrometric plot of ALL systems
%Scr_plot_pschro

%% Time series plots
%Scr_time_series_plot

%% Bar chart plots
%get_barData(trnTime,trnData,searchSystem,searchState)
%bData = get_barData(trnTime,trnData,'CTCC','Power');
%plot_barData(trnTime,bData);

%% State point investigation
% state_point_investigate_script
% energy_base_analysis
% Power analysis
% script_energy_plotting
% script_zone_conditioning_eval
% script_final_results


%% Control Volumes Section
%ControlVolScript

%% SVG Section
% %script_SVG_create
tStartSVG =tic;
if updateSVGDiagrams
    snapTime = datenum(2010, 07, 20, 16, 00, 0);
    svg_modify_all(trnData, trnTime, settings, snapTime)
    %    snapTime = datenum(2010, 02, 15, 12, 00, 0);
    %    svg_modify_all(trnData, trnTime, settings, snapTime)
end
tElapsedSVG=toc(tStartSVG)/60;

%logFH = fopen('Y:\03 Daten\SavedSimulationResults\lastLog.txt','a');
%fprintf(logFH, 'Passed the SVG at %s \n',datestr(now))
%fclose(logFH)

if averageTrnData
    script_average_all
end

%% Store the workspace for later!

if flagSaveWorkspace
    try
        saveWorkSpaceTarget = ['Y:\03 Daten\SavedSimulationResults\' datestr(now,'yyyy-mm-dd-HH-MM') '.mat'];
        save(saveWorkSpaceTarget)
        disp(sprintf(' - Saved the workspace to %s', saveWorkSpaceTarget));
        clear saveWorkSpaceTarget
        logFH = fopen('Y:\03 Daten\SavedSimulationResults\lastLog.txt','a');
        fprintf(logFH, 'Successfully saved workspace at %s \n',datestr(now))
        fclose(logFH)
    catch
        disp('Can''t save Workspace!!!!!!!!!!!!!!!');
        %rethrow(lasterror)
    end
end

%logFH = fopen('Y:\03 Daten\SavedSimulationResults\lastLog.txt','a');
%fprintf(logFH, 'Passed the save workspace section at %s \n',datestr(now))
%fclose(logFH)

%% clean up, report
if timeReport
    script_end_report
end

disp('*** Script END ***')



% trnDataOrig = trnData
% trnTimeOrig = trnTime
% trnData = trnData2
% trnTime = trnTime2