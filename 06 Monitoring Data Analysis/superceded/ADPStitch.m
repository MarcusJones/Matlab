function [timeout dataout]=ADPStitch(time1,data1,time2,data2,varargin)
%Stitches together two datasets retrieved from the ADP Database
%[TIMEOUT,DATAOUT]=ADPstitch(TIME1,DATA1,TIME2,DATA2)
%produces a single datablock DATAOUT and a single timeseries TIMEOUT for a
%pair of inputs, taking data from the first occurence of a datenumber
%
%[TIMEOUT,DATAOUT]=ADPstitch(TIME1,DATA1,TIME2,DATA2,TIME3,DATA3,...)
%produces a single datablock DATAOUT and a single timeseries TIMEOUT
%from multiple input series taking data from the first occurence of a datenumber
%
%see also unique, ADPread, ADPDisp, ADPExtract

%see if there is the right number of imputs
if ~mod(nargin,2)==0
    error('Pairs of Time and Data are needed');
end
datastore=[data1;data2];
timestore=[time1;time2];
%if more then two inputs, continue putting them together
if nargin>4
    for i=1:((nargin-4)/2)
        datastore=[datastore;varargin{i*2}];
        timestore=[timestore;varargin{i*2-1}];
    end
end
[timeout,indexes,trash]=unique(timestore);
dataout=datastore(indexes,:);
