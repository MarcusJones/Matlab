function [time,data,header]=ADPRead(varargin)
%Reads data from xls/xlsx files provided by the energybase database
%[TIME,DATA,HEADER]=ADPread opens a dialogue to select a xls/xlsx file(s) and then seperates it
%into matrix of data DATA, the corresponding series of timenumbers TIME and
%a cell array of ten header lines; if more then one file was selected, it creates DATA and TIME matrices from all files using ADPStitch,
%and the HEADER of the first file
%
%[TIME,DATA,HEADER]=ADPread('Filename') reads the xls/xlsx file x and seperates it
%into matrix of data DATA, the corresponding series of timenumbers TIME and
%a cell array of ten header lines
%
%[TIME,DATA,HEADER]=ADPread('Filename1','Filename2') reads the xls/xlsx
%files and creates DATA and TIME matrices from all files using ADPStitch,
%and the HEADER of the first file
%
%See also ADPStitch, ADPDisp, ADPExtract, ADPParseExcelTexts

if nargin>0
    %if input was given, write it into a structures
    x=cell(nargin,1);
    for i=1:nargin
        x{i}=varargin{i};
    end
    Z=nargin;
else
    %if not display a small GUI
    [x,mypath]=uigetfile({'*.xls*'},'Select Data File to read','Multiselect','on');
    % if jsut a single file was selected, put it into a cell for
    % consistency
    if ischar(x)
        x={x};
    end
    Z=length(x);
end
time=cell(size(x));
data=cell(size(x));
stringin=[];
%read the data and parse it
for i=1:Z
    if nargin>0
        [data{i},text]=xlsread(x{i});
    else
        [data{i},text]=xlsread([mypath,'/',x{i}]);
    end
    [time{i},header]=ADPParseExcelTexts(text);
    stringin=[stringin,'time{',num2str(i),'},data{',num2str(i),'},'];
end
%delete the last comma from the string
stringin(end)=[];
%put everything together if necessary
if Z>1
    eval(['[time,data]=ADPStitch(',stringin,');']);
else
    time=time{1};
    data=data{1};
end
    