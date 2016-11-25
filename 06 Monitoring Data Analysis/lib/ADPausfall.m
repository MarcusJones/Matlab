function locations=ADPausfall(structin,intervall,varargin)
%Displays possible faulty time series for data from the ADP Database
%ADPausfall(STRUCTIN,INTERVALL);
%searches the ADP structure STRUCTIN for timeseries where a sensor reports
%the same value for a time of INTERVALL and displays the results. INTERVALL consist of a number and
%the letters 'd','h' and 'm' for days, hours and minutes
%
%l=ADPausfall(STRUCTIN,INTERVALL);
%searches the ADP structure STRUCTIN for timeseries where a sensor reports
%the same value for a time of INTERVALL and displays the results. INTERVALL consist of a number and
%the letters 'd','h' and 'm' for days, hours and minutes and gives a matrix
%l where all violations are marked as TRUE
%
%
%ADPausfall(STRUCTIN,INTERVALL,SELECTION)
%does the same, with the sensors to check specified by the user in
%selection with the column number, name or part there off or physical unit
%
%example
%ADPausfall(A17,'30m') displays all startingpoints and duration where a
%sensor in A17 has the same value for more then 30 minutes
%
%See also ADPRead, ADPRangeTest, ADPDisp, ADPExtract
if ~isADPstruct(structin)
    error('this function only works for ADP structures');
end
groesse=size(structin.data);
locations=false(groesse);
if nargin>2
    todo=ADPGetFromHeader(structin.header,varargin);
else
    todo=1:groesse(2);
end
% compute how many seconds the specified intervall is or give an error
% message if nothing is selected
if ~isempty(regexp(intervall,'h','once'))
    limit=str2double(intervall(1:(regexp(intervall,'h','once')-1)))*3600;
    unitstr=' hours';
    unitdiv=3600;
elseif ~isempty(regexp(intervall,'m','once'))
    limit=str2double(intervall(1:(regexp(intervall,'m','once')-1)))*60;
    unitstr=' minutes';
    unitdiv=60;
elseif ~isempty(regexp(intervall,'d','once'))
    limit=str2double(intervall(1:(regexp(intervall,'d','once')-1)))*24*3600;
    unitstr=' days';
    unitdiv=24*3600;
else
    error('Time has to be in days (''d''), hours (''m'') or minutes (''m'')');
end
% compute intervall between te timesteps and give an error if the
% condtion would always apply automatically between two steps
deltat=(structin.time(2:end)-structin.time(1:(end-1)))*24*3600;
if min(deltat)>limit
    error('Intervall between data is bigger then the critical time.');
end
format='dd:mm:yy HH:MM';
%sequentially go throught the data in columns; if the data stays the same
%for longer then the critucal intervall, give a warning as soon as the data
%changes again, then reset counter
for j=todo
    x=structin.data(1,j);
    active=false;
    current=1;
    for i=2:groesse(1)
        if structin.data(i,j)~=x
            if sum(deltat(current:(i-1)))>limit
                if active==false
                    disp([structin.header{10,j},':']);
                    active=true;
                end
                disp(['Constant Values at ', num2str(structin.data(current,j)),' ',structin.header{5,j},' from ',datestr(structin.time(current),format),...
                    ' for ',num2str(sum(deltat(current:(i-1)))/unitdiv),unitstr]);
                locations(current:(i-1),j)=true;
            end;
            current=i;
            x=structin.data(i,j);
        end
    end
    if current==1
        disp([structin.header{10,j},':']);
        disp(['Has Value ', num2str(structin.data(current,j)), ' during the whole period']);
    end
end