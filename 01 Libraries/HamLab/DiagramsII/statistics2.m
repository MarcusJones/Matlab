function y=statistics2(s,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculates statistical values for each parameter
% varargin = yearstat,seasondiv,seasonstat,monthdiv,monthstat,weekdiv,weekstat,daydiv,daystat:
%          1=calculate, everything else = don't calculate
%          e.g. [s,0,0,0,0,0,0,1,1,1) only calculates weekly division and daily statistics (daily division is needed)
% june 16, 2005, TUe, PBE, MM
% 8 december 2005: jaarkolom toegevoegd (i+4) en onderscheid per gemeten jaar.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(varargin)==9
    caly=varargin{1};                                                          % calculate year statistics?
    divs=varargin{2};                                                          % divide into seasons?
    cals=varargin{3};                                                          % calculate season statistics?
    divm=varargin{4};                                                          % divide into months?
    calm=varargin{5};                                                          % calculate month statistics?
    divw=varargin{6};                                                          % divide into weeks?
    calw=varargin{7};                                                          % calculate week statistics?
    divd=varargin{8};                                                          % divide into days?
    cald=varargin{9};                                                          % calculate day statistics?
else
    caly=1;                                                                    % calculate years
    divs=1;                                                                    % divide into seasons
    cals=1;                                                                    % calculate seasons
    divm=1;                                                                    % divide into months
    calm=1;                                                                    % calculate months
    divw=1;                                                                    % divide into weeks
    calw=1;                                                                    % calculate weeks
    divd=1;                                                                    % divide into days
    cald=1;                                                                    % calculate days
end    
global yearvec
i=length(s(1,:));                                                              % counts number of columns
k=length(s(:,1));                                                              % counts number of rows
sdate=datevec(s(1,10));                                                        % creates vector containing start date
edate=datevec(s(k,10));                                                        % creates vector containing end date
yearvec=[sdate(1):edate(1)];                                                   % creates vector containing all years
daypoints=max(find(s(:,10)<=datenum(sdate(1),sdate(2),sdate(3)+1,sdate(4),sdate(5),sdate(6))));
for y=yearvec
    name=sprintf('y%d',y);
    eval(['global ' name 'astat ' name 'sstat ' name 'mstat ' name 'wstat ' name 'dstat ' name 'dat ' name 'seasons ' name 'months ' name 'weeks ' name 'days';])
    if (y/4-round(y/4))==0                                                     % if year = leap year this statement is true
    eval([name 'monthday([1:13])=([0 31 60 91 121 152 182 213 244 274 305 335 366]);'])
    else                                                                       % if year isn't leap year
    eval([name 'monthday([1:13])=([0 31 59 90 120 151 181 212 243 273 304 334 365]);'])
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics entire period
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
per=find(s(:,10)>=datenum(y,1,1,0,0,0) & s(:,10)<=datenum(y,12,31,23,59,59));
eval([name 'dat=s(per,:);'])
eval(['a=datevec(' name 'dat(:,10));'])                                        % converts date to yyyy mm dd hh mm ss
eval([name 'dat(:,i+1)=a(:,2);'])                                              % adds column containing monthnumbers
eval([name 'dat(:,i+2)=a(:,3);'])                                              % adds column containing day of the month
for m=1:length(per)
eval([name 'dat(m,i+3)=' name 'monthday(' name 'dat(m,i+1))+' name 'dat(m,i+2);'])
end
if caly==1
for j=[1:i]                                                                    % calculates for each parameter for the entire period:
eval([name 'astat(1,j)=min(' name 'dat(:,j));'])                               % minimum value
eval([name 'astat(2,j)=max(' name 'dat(:,j));'])                               % maximum value
eval([name 'astat(3,j)=nanmean(' name 'dat(:,j));'])                           % average value ignoring Non-a-Number
eval([name 'astat(4,j)=range(' name 'dat(:,j));'])                             % total range
eval([name 'astat(5,j)=nanmedian(' name 'dat(:,j));'])                         % median value, ignoring Not-a-Numbers
eval([name 'astat(6,j)=nanstd(' name 'dat(:,j));'])                            % standarddeviation,ignoring Not-a-Numbers
eval([name 'astat(7,j)=(nanstd(' name 'dat(:,j))^2);'])                        % variance, ignoring Not-a-Numbers
end
end
clear j per
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each season
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if divs==1
eval([name 'seasons=ones(daypoints*92,i,4)*NaN;'])                             % creates empty seasons-matrix, containing Not-a-Numbers
for s1=[1:4]                                                                   % divides data into 4 parts, for each season a different part
    if s1==1;                                                                  % every part is stored in a new layer in the 3D matrix
        eval(['s2=find(' name 'dat(:,i+3)<81 | ' name 'dat(:,i+3)>=356);'])    % days containing winterdata
    elseif s1==2;
        eval(['s2=find(' name 'dat(:,i+3)>=81 & ' name 'dat(:,i+3)<173);'])    % days containing springdata
    elseif s1==3;
        eval(['s2=find(' name 'dat(:,i+3)>=173 & ' name 'dat(:,i+3)<265);'])   % days containing summerdata
    elseif s1==4;
        eval(['s2=find(' name 'dat(:,i+3)>=265 & ' name 'dat(:,i+3)<356);'])   % days containing autumndata
    end
    eval([name 'seasons([1:length(s2)],[1:i],s1)=' name 'dat(s2,[1:i]);'])     % fills 3D matrix
end
end
if cals==1
for s3=[1:i]
for s4=[1:4]                                                                   % calculates for each parameter for each season:
eval([name 'sstat(1,s3,s4)=min([' name 'seasons(:,s3,s4)]);'])                 % minimum value
eval([name 'sstat(2,s3,s4)=max([' name 'seasons(:,s3,s4)]);'])                 % maximum value
eval([name 'sstat(3,s3,s4)=nanmean([' name 'seasons(:,s3,s4)]);'])             % average value, ignoring Not-a-Numbers
eval([name 'sstat(4,s3,s4)=range([' name 'seasons(:,s3,s4)]);'])               % total range
eval([name 'sstat(5,s3,s4)=nanmedian([' name 'seasons(:,s3,s4)]);'])           % median value, ignoring Not-a-Numbers
eval([name 'sstat(6,s3,s4)=nanstd([' name 'seasons(:,s3,s4)]);'])              % standarddeviation, ignoring Not-a-Numbers
eval([name 'sstat(7,s3,s4)=(nanstd([' name 'seasons(:,s3,s4)])^2);'])          % variance, ignoring Not-a-Numbers
end
end
end
clear s1 s2 s3 s4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each month
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if divm==1
eval([name 'months=ones(daypoints*31,i,12)*NaN;'])                             % creates empty months-matrix, containing Not-a-Numbers
for m1=[1:12]                                                                  % number of months
    eval(['m2=find(' name 'dat(:,i+1)==m1);'])                                 % finds data for each month
    eval([name 'months([1:length(m2)],[1:i],m1)=' name 'dat(m2,[1:i]);'])      % stores data for each month into a different layer of the 3D matrix
end
end
if calm==1
for m3=[1:i]
for m4=[1:12]                                                                  % calculates for each parameter for each month:
eval([name 'mstat(1,m3,m4)=min([' name 'months(:,m3,m4)]);'])                  % minimum value
eval([name 'mstat(2,m3,m4)=max([' name 'months(:,m3,m4)]);'])                  % maximum value
eval([name 'mstat(3,m3,m4)=nanmean([' name 'months(:,m3,m4)]);'])              % average value, ignoring Not-a-Numbers
eval([name 'mstat(4,m3,m4)=range([' name 'months(:,m3,m4)]);'])                % total range
eval([name 'mstat(5,m3,m4)=nanmedian([' name 'months(:,m3,m4)]);'])            % median value, ignoring Not-a-Numbers
eval([name 'mstat(6,m3,m4)=nanstd([' name 'months(:,m3,m4)]);'])               % standarddeviation, ignoring Not-a-Numbers
eval([name 'mstat(7,m3,m4)=(nanstd([' name 'months(:,m3,m4)])^2);'])           % variance, ignoring Not-a-Numbers
end
end
end
clear m1 m2 m3 m4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each week
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if divw==1;
op=sdate(1)+floor(((sdate(1)-1)/4));                                           % calculates startday of a week for 01-01-0000
a=-op+7*floor(op/7)+3;                                                         % shifts startday to be between december 27 and january 2
eval([name 'weeks=ones(daypoints*7,i,53)*NaN;'])                               % creates empty weeks-matrix, containing Not-a-Numbers
for w1=[1:53]                                                                  % number of weeks
eval(['w2=find(' name 'dat(:,i+3)==((7*w1)-7+a)| ' name 'dat(:,i+3)==((7*w1)-6+a)| ' name 'dat(:,i+3)==((7*w1)-5+a)| ' name 'dat(:,i+3)==((7*w1)-4+a)| ' name 'dat(:,i+3)==((7*w1)-3+a)| ' name 'dat(:,i+3)==((7*w1)-2+a)| ' name 'dat(:,i+3)==((7*w1)-1+a));'])
eval([name 'weeks([1:length(w2)],[1:i],w1)=' name 'dat(w2,[1:i]);'])           % stores data for each week into a different layer of the 3D matrix
end
end
if divw==1
for w3=[1:i]
for w4=[1:53]                                                                  % calculates for each parameter for each week:
eval([name 'wstat(1,w3,w4)=min([' name 'weeks(:,w3,w4)]);'])                   % minimum value
eval([name 'wstat(2,w3,w4)=max([' name 'weeks(:,w3,w4)]);'])                   % maximum value
eval([name 'wstat(3,w3,w4)=nanmean([' name 'weeks(:,w3,w4)]);'])               % average value, ignoring Not-a-Numbers
eval([name 'wstat(4,w3,w4)=range([' name 'weeks(:,w3,w4)]);'])                 % total range
eval([name 'wstat(5,w3,w4)=nanmedian([' name 'weeks(:,w3,w4)]);'])             % median value, ignoring Not-a-Numbers
eval([name 'wstat(6,w3,w4)=nanstd([' name 'weeks(:,w3,w4)]);'])                % standarddeviation, ignoring Not-a-Numbers
eval([name 'wstat(7,w3,w4)=(nanstd([' name 'weeks(:,w3,w4)])^2);'])            % variance, ignoring Not-a-Numbers
end
end
end
clear w1 w2 w3 w4 op aa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics each day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if divd==1
eval([name 'days=ones(daypoints,i,' name 'monthday(13))*NaN;'])                % creates empty days-matrix, containing Not-a-Numbers
for d1=[1:366]                                                                 % counts number of days (leap year)
    eval(['d2=find(' name 'dat(:,i+3)==d1);'])                                 % finds data for each day
    eval([name 'days([1:length(d2)],[1:i],d1)=' name 'dat(d2,[1:i]);'])        % stores data for each day into a different layer of the 3D matrix
end
end
if cald==1
for d3=[1:i]
for d4=[1:(eval([name 'monthday(13)']))]                                       % calculates for each parameter for each day:
eval([name 'dstat(1,d3,d4)=min([' name 'days(:,d3,d4)]);'])                    % minimum value
eval([name 'dstat(2,d3,d4)=max([' name 'days(:,d3,d4)]);'])                    % maximum value
eval([name 'dstat(3,d3,d4)=nanmean([' name 'days(:,d3,d4)]);'])                % average value, ignoring Not-a-Numbers
eval([name 'dstat(4,d3,d4)=range([' name 'days(:,d3,d4)]);'])                  % total range
eval([name 'dstat(5,d3,d4)=nanmedian([' name 'days(:,d3,d4)]);'])              % median value, ignoring Not-a-Numbers
eval([name 'dstat(6,d3,d4)=nanstd([' name 'days(:,d3,d4)]);'])                 % standarddeviation, ignoring Not-a-Numbers
eval([name 'dstat(7,d3,d4)=(nanstd([' name 'days(:,d3,d4)])^2);'])             % variance, ignoring Not-a-Numbers
end
end
end
clear d1 d2 d3 d4
end