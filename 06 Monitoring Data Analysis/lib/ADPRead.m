function structout=ADPRead(varargin)
%Reads data from xls/xlsx files provided by the energybase database
%STRUCTOUT=ADPread opens a dialogue to select a xls/xlsx file(s) and then seperates it
%into matrix of data DATA, the corresponding series of timenumbers TIME and
%a cell array of ten header lines; if more then one file was selected, it creates DATA and TIME matrices from all files using ADPStitch,
%and the HEADER of the first file
%
%STRUCTOUT=ADPread('Filename') reads the xls/xlsx file x and seperates it
%into matrix of data DATA, the corresponding series of timenumbers TIME and
%a cell array of ten header lines
%
%STRUCTOUT=ADPread('Filename1','Filename2') reads the xls/xlsx
%files and creates DATA and TIME matrices from all files using ADPStitch,
%and the HEADER of the first file
%
%See also ADPDisp, ADPExtract, ADPParseExcelTexts

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
parts=cell(size(x));
stringin=[];
%read the data and parse it
for i=1:Z
    if nargin>0
        [parts{i}.data,text]=xlsread(x{i});
    else
        [parts{i}.data,text]=xlsread([mypath,'/',x{i}]);
    end
    [parts{i}.time,parts{i}.header]=ADPParseExcelTexts(text);
    stringin=[stringin,'parts{',num2str(i),'},'];
end
%delete the last comma from the string
stringin(end)=[];
%put everything together if necessary
if Z>1
    eval(['structout=ADPStitch(',stringin,');']);
else
    structout.time=parts{i}.time;
    structout.data=parts{i}.data;
    structout.header=parts{1}.header;
end
    