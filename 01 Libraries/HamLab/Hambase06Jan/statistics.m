function y=statistics(s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculates statistical values for each parameter
% january 19, 2005, TUe, PBE, MM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global astat seasons sstat months mstat weeks wstat days dstat
i=length(s(1,:));                                     % counts number of columns
ja=s;                                                 % renames s, s can be matrix containing 10, 20 or 26 columns
k=length(s(:,1));                                     % counts number of rows
startdate=datevec(s(1,10));                           % creates vector containing start date
enddate=datevec(s(k,10));                             % creates vector containing end date
if startdate(1)==enddate(1)                           % if startyear = endyear,
    yyyy=startdate(1);                                % year = startyear
elseif enddate(1)-startdate(1)==1                     % if startyear = endyear - 1
    if enddate(2)>3 & startdate(2)>3                  % and if startmonth and endmonth aren't january or february
        yyyy=enddate(1);                              % year = endyear
    else yyyy=startdate(1);                           % or else year = startyear
    end
else yyyy=4;                                          % if startyear < endyear - 1, always use leap year
end
if (yyyy/4-round(yyyy/4))==0                          % if year = leap year this statement is true
monthday([1:13])=([0 31 60 91 121 152 182 213 244 274 305 335 366]);
else                                                  % if year isn't leap year
monthday([1:13])=([0 31 59 90 120 151 181 212 243 273 304 334 365]);
end
sdate=datevec(s(1,10));                               % finds first date/time point
daypoints=max(find(s(:,10)<=datenum(sdate(1),sdate(2),sdate(3)+1,sdate(4),sdate(5),sdate(6))));
if length(s(:,10))/(daypoints-1)>366
    disp('Datafile is larger than 1 year; equal seasons and weeks will be merged')
    new=ceil(length(s(:,10))/(366*(daypoints-1)))*daypoints;
    daypoints=new;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics entire period
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=[1:k];
a=datevec(s(j,10));                                   % converts date to yyyy mm dd hh mm ss
ja(j,i+1)=a(2);                                       % adds column containing monthnumbers
ja(j,i+2)=a(3);                                       % adds column containing day of the month
ja(j,i+3)=a(3)+monthday(a(2));                        % adds column containing day of the year
end
for j=[1:i]                                           % calculates for each parameter for the entire period:
astat(1,j)=min(s(:,j));                               % minimum value
astat(2,j)=max(s(:,j));                               % maximum value
astat(3,j)=nanmean(s(:,j));                           % average value ignoring Non-a-Number
astat(4,j)=range(s(:,j));                             % total range
astat(5,j)=nanmedian(s(:,j));                         % median value, ignoring Not-a-Numbers
astat(6,j)=nanstd(s(:,j));                            % standarddeviation,ignoring Not-a-Numbers
astat(7,j)=(nanstd(s(:,j))^2);                        % variance, ignoring Not-a-Numbers
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each season
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


seasons=ones(daypoints*92,i,4)*NaN;                   % creates empty seasons-matrix, containing Not-a-Numbers


for s1=[1:4]                                          % divides data into 4 parts, for each season a different part
    if s1==1;                                         % every part is stored in a new layer in the 3D matrix
        s2=find(ja(:,i+3)<81 | ja(:,i+3)>=356);       % days containing winterdata
    elseif s1==2;
        s2=find(ja(:,i+3)>=81 & ja(:,i+3)<173);       % days containing springdata
    elseif s1==3;
        s2=find(ja(:,i+3)>=173 & ja(:,i+3)<265);      % days containing summerdata
    elseif s1==4;
        s2=find(ja(:,i+3)>=265 & ja(:,i+3)<356);      % days containing autumndata
    end
    seasons([1:length(s2)],[1:i],s1)=ja(s2,[1:i]);    % fills 3D matrix
end
for s3=[1:i]
for s4=[1:4]                                          % calculates for each parameter for each season:
sstat(1,s3,s4)=min([seasons(:,s3,s4)]);               % minimum value
sstat(2,s3,s4)=max([seasons(:,s3,s4)]);               % maximum value
sstat(3,s3,s4)=nanmean([seasons(:,s3,s4)]);           % average value, ignoring Not-a-Numbers
sstat(4,s3,s4)=range([seasons(:,s3,s4)]);             % total range
sstat(5,s3,s4)=nanmedian([seasons(:,s3,s4)]);         % median value, ignoring Not-a-Numbers
sstat(6,s3,s4)=nanstd([seasons(:,s3,s4)]);            % standarddeviation, ignoring Not-a-Numbers
sstat(7,s3,s4)=(nanstd([seasons(:,s3,s4)])^2);        % variance, ignoring Not-a-Numbers
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each month
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
months=ones(daypoints*31,i,12)*NaN;                   % creates empty months-matrix, containing Not-a-Numbers
for m1=[1:12]                                         % number of months
    m2=find(ja(:,i+1)==m1);                           % finds data for each month
    months([1:length(m2)],[1:i],m1)=ja(m2,[1:i]);     % stores data for each month into a different layer of the 3D matrix
end
for m3=[1:i]
for m4=[1:12]                                         % calculates for each parameter for each month:
mstat(1,m3,m4)=min([months(:,m3,m4)]);                % minimum value
mstat(2,m3,m4)=max([months(:,m3,m4)]);                % maximum value
mstat(3,m3,m4)=nanmean([months(:,m3,m4)]);            % average value, ignoring Not-a-Numbers
mstat(4,m3,m4)=range([months(:,m3,m4)]);              % total range
mstat(5,m3,m4)=nanmedian([months(:,m3,m4)]);          % median value, ignoring Not-a-Numbers
mstat(6,m3,m4)=nanstd([months(:,m3,m4)]);             % standarddeviation, ignoring Not-a-Numbers
mstat(7,m3,m4)=(nanstd([months(:,m3,m4)])^2);         % variance, ignoring Not-a-Numbers
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each week
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opgeschoven=startdate(1)+floor(((startdate(1)-1)/4)); % calculates startday of a week for 01-01-0000
aaaa=-opgeschoven+7*floor(opgeschoven/7)+3;           % shifts startday to be between december 27 and january 2
weeks=ones(daypoints*7,i,53)*NaN;                     % creates empty weeks-matrix, containing Not-a-Numbers
for w1=[1:53]                                         % number of weeks
w2=find(ja(:,i+3)==((7*w1)-7+aaaa)| ja(:,i+3)==((7*w1)-6+aaaa)| ja(:,i+3)==((7*w1)-5+aaaa)| ja(:,i+3)==((7*w1)-4+aaaa)| ja(:,i+3)==((7*w1)-3+aaaa)| ja(:,i+3)==((7*w1)-2+aaaa)| ja(:,i+3)==((7*w1)-1+aaaa));          % finds data for each week (ATTENTION: only valid for 2004)
weeks([1:length(w2)],[1:i],w1)=ja(w2,[1:i]);          % stores data for each week into a different layer of the 3D matrix
end
for w3=[1:i]
for w4=[1:53]                                         % calculates for each parameter for each week:
wstat(1,w3,w4)=min([weeks(:,w3,w4)]);                 % minimum value
wstat(2,w3,w4)=max([weeks(:,w3,w4)]);                 % maximum value
wstat(3,w3,w4)=nanmean([weeks(:,w3,w4)]);             % average value, ignoring Not-a-Numbers
wstat(4,w3,w4)=range([weeks(:,w3,w4)]);               % total range
wstat(5,w3,w4)=nanmedian([weeks(:,w3,w4)]);           % median value, ignoring Not-a-Numbers
wstat(6,w3,w4)=nanstd([weeks(:,w3,w4)]);              % standarddeviation, ignoring Not-a-Numbers
wstat(7,w3,w4)=(nanstd([weeks(:,w3,w4)])^2);          % variance, ignoring Not-a-Numbers
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
days=ones(daypoints,i,monthday(13))*NaN;              % creates empty days-matrix, containing Not-a-Numbers
for d1=[1:366]                                        % counts number of days (leap year)
    d2=find(ja(:,i+3)==d1);                           % finds data for each day
    days([1:length(d2)],[1:i],d1)=ja(d2,[1:i]);       % stores data for each day into a different layer of the 3D matrix
end
for d3=[1:i]
for d4=[1:monthday(13)]                                        % calculates for each parameter for each day:
dstat(1,d3,d4)=min([days(:,d3,d4)]);                  % minimum value
dstat(2,d3,d4)=max([days(:,d3,d4)]);                  % maximum value
dstat(3,d3,d4)=nanmean([days(:,d3,d4)]);              % average value, ignoring Not-a-Numbers
dstat(4,d3,d4)=range([days(:,d3,d4)]);                % total range
dstat(5,d3,d4)=nanmedian([days(:,d3,d4)]);            % median value, ignoring Not-a-Numbers
dstat(6,d3,d4)=nanstd([days(:,d3,d4)]);               % standarddeviation, ignoring Not-a-Numbers
dstat(7,d3,d4)=(nanstd([days(:,d3,d4)])^2);           % variance, ignoring Not-a-Numbers
end
end