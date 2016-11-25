function structout=ADPReadDir(varargin)
% reads all the xls files in a directory and combines them into one big ADP
% dataset consisting of header, time and data
%
%STRUCTOUT=ADPReadDir lets the user select a directory
%with a small GUI and then parses all xls/xlsx files in the directory into
%one big ADP structure using ADPStitch
%
%STRUCTOUT=ADPReadDir('dirname') does the same with a
%user specified directory
%
%see als ADPRead, ADPStitch, ADPDisp

% first see of there is a user specified directory
if nargin>0
    mydir=varargin{1};
    if ~ischar(mydir);
        error('no valid string for directory given');
    end
else
    %if not, use the ui supplied by matlab
    mydir=uigetdir('.','Select a directory to parse for ADP Data Files');
end
%get all xls/xlsx files
dircontent=dir([mydir,'/*xls*']);
numfiles=length(dircontent);
time=cell(numfiles,1);
data=cell(numfiles,1);
stringin=[];
%read them and construct a string to pass to ADPStitch
for i=1:numfiles
    [time{i},data{i},structout.header]=ADPRead([mydir,'/',dircontent(i).name]);
    stringin=[stringin,'time{',num2str(i),'},data{',num2str(i),'},'];
end
%delete the last comma from the string
stringin(end)=[];
%put everything together if necessary
if numfiles>1
    eval(['[structout.time,structout.data]=ADPStitch(',stringin,');']);
else
    structout.time=time{1};
    structout.data=data{1};
end