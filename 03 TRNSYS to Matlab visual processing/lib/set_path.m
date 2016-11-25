% Script: Set path for local directory, load the local library and 
% general library
% M. Jones Aug 12, 2009

% Set the full filename and path of the initialization file here
% Change to current directory of current file
Settings.currFile = mfilename;
Settings.currFilePath = mfilename('fullpath');
Settings.currFilePath = Settings.currFilePath(1:length(Settings.currFilePath) ...
    -length(Settings.currFile));
cd(Settings.currFilePath);

localLibDir = [pwd, '\lib'];
cd ..;
genLibDir = [pwd, '\01 Libraries'];

% Set the environment path to include the ../lib folder

addpath(genpath(localLibDir));
addpath(genpath(genLibDir));