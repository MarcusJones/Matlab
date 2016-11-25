function ADPausfall(time,data,header,intervall,varargin)
%Displays possible faulty time series for data from the ADP Database
%%ADPausfall(time,data,header,intervall,varargin)
groesse=size(data);
if nargin>4
    todo=ADPGetfromHeader(header,varargin);
else
    todo=1:groesse(2);
end
dataintervall=datevec(time(2)-time(1))*[365.25*24*3600;365.25/12*24*3600;24*3600;3600;60;1];

if ~isempty(regexp(intervall,'h','once'))
    limit=str2double(intervall(1:(regexp(intervall,'h','once')-1)))*3600;
    unitstr=' Stunden';
    unitdiv=3600;
elseif ~isempty(regexp(intervall,'m','once'))
    limit=str2double(intervall(1:(regexp(intervall,'m','once')-1)))*60;
    unitstr=' Minuten';
    unitdiv=60;
elseif ~isempty(regexp(intervall,'d','once'))
    limit=str2double(intervall(1:(regexp(intervall,'d','once')-1)))*24*3600;
    unitstr=' Tage';
    unitdiv=24*3600;
else
    error('Time has to be in days (''d''), hours (''m'') or minutes (''m'')');
end
if dataintervall>limit
    error('Intervall between data is smaller then the critical time.');
end
zaehler=0;
format='dd:mm:yy HH:MM';
for j=todo
    x=data(1,j);
    zaehler=0;
    disp([header{10,j},':']);
    for i=2:groesse(1)
        if data(i,j)==x
            zaehler=zaehler+1;
        else
            if zaehler*dataintervall>limit
                disp(['Gleicher Werte ab ',datestr(time(i-zaehler),format),...
                    ' für ',num2str(zaehler*dataintervall/unitdiv),unitstr]);
            end;
            zaehler=1;
            x=data(i,j);
        end
    end
end