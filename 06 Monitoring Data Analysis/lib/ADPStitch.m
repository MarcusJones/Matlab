function structout=ADPStitch(varargin)
%Stitches together two datasets retrieved from the ADP Database
%[TIMEOUT,DATAOUT]=ADPstitch(varargin)
%produces a single datablock DATAOUT and a single timeseries TIMEOUT for a
%pair of inputs, taking data from the first occurence of a datenumber
%
%[TIMEOUT,DATAOUT]=ADPstitch(varargin)
%produces a single datablock DATAOUT and a single timeseries TIMEOUT
%from multiple input series taking data from the first occurence of a datenumber
%
%see also unique, ADPread, ADPDisp

%see if there is the right number of imputs
datastore=[];
timestore=[];
structout=varargin{1};
if nargin>1
    for i=1:nargin
        if ~isADPstruct(varargin{i})
            error('this function only can be used for the ADP structures');
        end
    end
    %if more then two inputs, continue putting them together
    for i=1:nargin
        datastore=[datastore;varargin{i}.data];
        timestore=[timestore;varargin{i}.time];
    end
    [timeout,indexes,trash]=unique(timestore);
    structout.data=datastore(indexes,:);
	structout.time=timeout;
end
