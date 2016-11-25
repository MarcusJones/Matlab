clear

% Set the full filename and path of the initialization file here
% Change to current directory of current file
Settings.currFile = mfilename;
Settings.currFilePath = mfilename('fullpath');
Settings.currFilePath = ...
    Settings.currFilePath(1:length(Settings.currFilePath) ...
    -length(Settings.currFile));
cd(Settings.currFilePath);
localLibDir = [pwd, '\lib'];
cd ..;
genLibDir = [pwd, '\01 Libraries'];

% Set the environment path to include the ../lib folder
addpath(genpath(localLibDir));
addpath(genpath(genLibDir));

%clear genLibDir localLibDir

Notes                   % Just some comments
LoadRawData             % Loads data and appends the date serial number
LoadDataLabels          % A simple label file for column headers
LoadProperties          % Load water and desiccant solution properties
ProcessDataDesiccant    % Writes desiccant state data into array
ProcessDataAir          % Writes the air state data
ProcessDataHot          % Writes hot water flow  data
ProcessDataCold         % Writes cold water flow data
ProcessDataPrimEnergy   % Writes primary energy usage data
ProcessDataEnth         % Calculates the enthalpy state data 
ReProcessAirW           % Merges outlet states to ambient when machine off
DateTime                % Loads two date ranges and stores date time column
ProcessCooling          % Cooling powers

clear DatedData Headers L i 

%HourSummary             % Smooths data over a specified period
%DaySummary              % Summarizes averages and totals for a day

%MainCondPlot1           % [TC,SC,LC],dTemp,dW for process air
%MainRegPlot1            
%PlotOverviewHr

%PlotdHWvsTin            % a

PlotOverview            % Lvl 2; Temp, RH, Conc
%PlotCondEnth            % Lvl 2; enthalpy balance for the conditioner
%PlotCondWater           % Lvl 2; Water rates, Air/Des calc
%PlotRegenEnth           % Lvl 2; Plot the enthalpy balance for the regenerator
%PlotRegWater            % Lvl 2; Water rates, Air/Des calc
%PlotRegenCOP            % Plot the regenerator thermal COP with hw flow

% PlotAllAir              % Plot of air states UPDATE
%PlotAllFlows            % Plot flow rates UPDATE
%PlotGas
%PlotCOP
%PlotStuff
% PlotHotCold             % Plots hot and cold temperature changes UPDATE

%AndyData                % Exports data summarized over a day

% PlotPsychro             % OLD Psych plot over time mask 1
%PlotConcentration       % Same as overview, but with concentrations instead of flow rates

% Plots a psych chart over mask 2
%TwoPointMollier4(Air.Amb(TimeMask2,2),Air.Amb(TimeMask2,4),Air.Proc(TimeMask2,2),Air.Proc(TimeMask2,4));

