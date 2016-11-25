function ADPDisp(time,data,header,varargin)
%plot data from the imported by ADPread from the Energybase Database
%ADPDips(TIME,DATA,HEADER) displays displays DATA vs TIME read, using the
%Header for labeling
%
%
%ADPDips(TIME,DATA,HEADER, varargin)
%displays displays DATA vs TIME read; in VARGIN the user can specify any
%number of explicit column numbers, units or parts of names to be displayed; if
%ommmited ADPDisp plots all columns
%
%Example: ADPDips(DATA,TIME,HEADER, [3,4],'Pumpe') will display the 3rd and
%4th colum and all colums having 'Pumpe' as part of their name in the the
%colums

% see also ADPRead, ADPStitch, ADPExtract

%first see to it that the input is in order
if ~isvector(time) || ~isfloat(time)
    error('Time has to be a vector');
end
if ~isfloat(data)
    error('Data has to be a matrix');
end
l=size(header) ;
if nargin<4
    todisplay=1:l(2);
else
    todisplay=ADPGetFromHeader(header,varargin);
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
plot(time,data(:,todisplay)');
datetick2('x');
builtlegend=cell(centrallength,1);
for i=1:centrallength
    builtlegend{i}=[header{10,todisplay(i)},'[',header{5,todisplay(i)},']'];
end
legend(builtlegend);
    function output_txt = fc(obj,event_obj)
        % Display the position of the data cursor
        % obj          Currently not used (empty)
        % event_obj    Handle to event object
        % output_txt   Data cursor text string (string or cell array of strings).
        pos = get(event_obj,'Position');
        output_txt = {['Datum: ',datestr(pos(1),'dd.mm')],...
            ['Uhrzeit: ',datestr(pos(1),'HH:MM')],...
            ['Wert: ',num2str(pos(2))]};
    end
end