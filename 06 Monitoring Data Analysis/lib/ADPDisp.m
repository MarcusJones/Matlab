function ADPDisp(structin,varargin)
%plot data from the imported by ADPread from the Energybase Database
%ADPDips(STRUCTIN) displays displays DATA vs TIME read, using the
%Header for labeling
%
%ADPDips(STRUCTIN, varargin)
%displays displays DATA vs TIME read; in VARGIN the user can specify any
%number of explicit column numbers, units or parts of names to be displayed; if
%ommmited ADPDisp plots all columns
%
%Example: ADPDips(STRUCTIN, [3,4],'Pumpe') will display the 3rd and
%4th colum and all colums having 'Pumpe' as part of their name in the the
%colums

% see also ADPRead, ADPStitch, ADPExtract

%first see to it that the input is in order
if ~isADPstruct(structin)
    error('only ADP structure can be displayed');
end
l=size(structin.header) ;
if nargin<2
    todisplay=1:l(2);
else
    todisplay=ADPGetFromHeader(structin.header,varargin);
end
centrallength=length(todisplay);
if centrallength==0
    error('No valid time series were specified');
end
% sort and remove doubles, then display with the 10th row entries of the
% header as legend and custom datatip showing date, time and value of a
% datapoint
k=figure;
m=datacursormode(k);
set(m,'Updatefcn',@fc);
plot(structin.time,structin.data(:,todisplay)');
datetick2('x');
builtlegend=cell(centrallength,1);
for i=1:centrallength
    builtlegend{i}=[structin.header{10,todisplay(i)},'[',structin.header{5,todisplay(i)},']'];
end
legend(builtlegend);
    function output_txt = fc(obj,event_obj)
        % Display the position of the data cursor
        % obj          Currently not used (empty)
        % event_obj    Handle to event object
        % output_txt   Data cursor text string (string or cell array of strings).
        pos = get(event_obj,'Position');
        output_txt = {['Date: ',datestr(pos(1),'dd.mm')],...
            ['Time: ',datestr(pos(1),'HH:MM')],...
            ['Value: ',num2str(pos(2))]};
    end
end