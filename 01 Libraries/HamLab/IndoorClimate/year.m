function y=year(s,c,name,savename,yyyy,demand)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copyright Jos van Schijndel and Marco Martens, Technische Universiteit Eindhoven, The Netherlands
% june 16, 2005
% s: sensor (10 columns)
% c: climate (10 columns)
% name: title to put above graph
% savename: file will be saved to disk under this name
% demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%             'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%             or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tmins1=min(s(:,1));
Tmins2=min(s(:,2));
Tmin=5*floor(0.2*min([Tmins1 Tmins2 15]));
Tmaxs1=max(s(:,1));
Tmaxs2=max(s(:,2));
Tmax=5*ceil(0.2*max([Tmaxs1 Tmaxs2 25]));
RHmins1=min(s(:,3));
RHmins2=min(s(:,4));
RHmin=5*floor(0.2*min([RHmins1 RHmins2 40]));
RHmaxs1=max(s(:,3));
RHmaxs2=max(s(:,4));
RHmax=5*ceil(0.2*max([RHmaxs1 RHmaxs2 60]));
dagen=floor((yyyy-1)/4);
opgeschoven=yyyy+dagen;
a=-opgeschoven+7*floor(opgeschoven/7)+3;
for i=[1:53];
weeklabel(1,i)=datenum(yyyy,1,7*i-5+a,12,0,0);
weeklabel(2,i)=i;
end
global astat mstat starttime endtime seasons          % sets dstat and wstat to be global (these are created by 'statistics')
starttime=datenum(yyyy,1,1,0,0,0);                    % sets starttime to match weeknumber
endtime=datenum(yyyy,12,31,0,0,0);                    % sets endtime to match weeknumber
sensor=reduce(s,starttime,endtime);                   % renames and reduces first sensor
c=reduce(c,starttime,endtime);                        % renames and reduces climate sensor
ts=floor(datestr(starttime));
te=floor(datestr(endtime));
dates=sprintf('YEAR %d, %s to %s',yyyy,ts,te);
aa=length(s(1,:));
figure                                                % starts new figure window
subplot(2,1,1)                                        % starts new subplot in current figure, time against temperatures
if aa==20
plot(sensor(:,10),sensor(:,1),'k-',sensor(:,10),sensor(:,2),'g-.',sensor(:,10),sensor(:,9),'r-.',c(:,10),c(:,1),'b:',c(:,10),c(:,9),'y-',sensor(:,10),sensor(:,11),'c-',sensor(:,10),sensor(:,12),'k-',sensor(:,10),sensor(:,19),'k:')
d=legend('Tair','Tsurf1','Tdew','Tclimate','Tdew cli','Tin','Tsurf2','Tdewin');
elseif aa==26
plot(sensor(:,10),sensor(:,1),'k-',sensor(:,10),sensor(:,2),'g-.',sensor(:,10),sensor(:,9),'r-.',c(:,10),c(:,1),'b:',c(:,10),c(:,9),'y-',sensor(:,10),sensor(:,11),'c-',sensor(:,10),sensor(:,12),'k-',sensor(:,10),sensor(:,19),'k:',sensor(:,10),sensor(:,21),'m-',sensor(:,10),sensor(:,26),'m:')
d=legend('Tair','Tsurf2','Tdew','Tclimate','Tdew cli','Tin','Tsurf2','Tdewin','Tgap','Tdewgap');
else
plot(sensor(:,10),sensor(:,1),'k-',sensor(:,10),sensor(:,2),'g-.',sensor(:,10),sensor(:,9),'r-.',c(:,10),c(:,1),'b:');
d=legend('Tair','Tsurface','Tdew','Tclimate');
end
axis([(starttime) (endtime) -10 40])
for ww=[1:53]
t1=text(weeklabel(1,ww),-15,num2str(ww));
set(t1,'FontSize',8,'VerticalAlignment','top','HorizontalAlignment','center')
end
datetick('x','mm','keeplimits')
ylabel(['Temperature [ºC]'])
q=title([name]);
set(q,'FontSize',20);
set(d,'FontSize',7);
grid
subplot(2,1,2)                                        % starts new subplot in current figure, time against relative humidity
if aa==20
plot(sensor(:,10),sensor(:,3),'k-',sensor(:,10),sensor(:,4),'g-.',c(:,10),c(:,3),'b:',sensor(:,10),sensor(:,13),'c-',sensor(:,10),sensor(:,14),'k-',sensor(:,10),sensor(:,20),'k:')
ee=legend('RHair','RHsurf1','RHclimate','RHin','RHsurf2','RHs2in');
elseif aa==26
plot(sensor(:,10),sensor(:,3),'k-',sensor(:,10),sensor(:,4),'g-.',c(:,10),c(:,3),'b:',sensor(:,10),sensor(:,13),'c-',sensor(:,10),sensor(:,14),'k-',sensor(:,10),sensor(:,20),'k:',sensor(:,10),sensor(:,22),'m-')
ee=legend('RHair','RHsurface','RHclimate','RHin','RHsurf2','RHs2in','RHgap');
else
plot(sensor(:,10),sensor(:,3),'k-',sensor(:,10),sensor(:,4),'g-.',c(:,10),c(:,3),'y:')
ee=legend('RHair','RHsurface','RHclimate');
end
axis([(starttime-1) (endtime+1) 0 100])
for ww=[1:53]
t1=text(weeklabel(1,ww),-10,num2str(ww));
set(t1,'FontSize',8,'VerticalAlignment','top','HorizontalAlignment','center')
end
datetick('x','mm','keeplimits')
ylabel(['Relative Humidity [% RH]'])
set(ee,'FontSize',7);
t13=text((starttime+endtime)/2,-14,dates);
set(t13,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')
grid
NewPosition=[0 0 'PaperSize'];
orient landscape
fig=sprintf('%s%dtime',savename,yyyy);                 % gives output a unique name
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..
statistics(sensor,1,0,1,0,0);                         % runs statistics for this sensor
monthtemp(:,[1:12])=mstat(:,1,[1:12]);                % daily average for air temperature
monthtsurf(:,[1:12])=mstat(:,2,[1:12]);               % daily average for surface temperature
monthRH(:,[1:12])=mstat(:,3,[1:12]);                  % daily average for air RH
figure                                                % creates new figure
subplot(3,1,1)                                        % subplot temperatures (air/surface and daily/hourly)
axis off
q=text(0.5,1.25,([name]));
set(q,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center');
text(-0.15,1,'Tair')
text(-0.05,1,'January')
text(0.04,1,'February')
text(0.13,1,'March')
text(0.22,1,'April')
text(0.31,1,'May')
text(0.40,1,'June')
text(0.49,1,'July')
text(0.58,1,'August')
text(0.67,1,'September')
text(0.76,1,'October')
text(0.85,1,'November')
text(0.94,1,'December')
text(1.03,1,'YEAR')
legend0=(['min    ';'max    ';'average';'range  ';'median ';'stdev  ';'var    ']);
text(-0.15,0.45,legend0)
text(-0.05,0.45,num2str(monthtemp(:,1),3))
text(0.04,0.45,num2str(monthtemp(:,2),3))
text(0.13,0.45,num2str(monthtemp(:,3),3))
text(0.22,0.45,num2str(monthtemp(:,4),3))
text(0.31,0.45,num2str(monthtemp(:,5),3))
text(0.40,0.45,num2str(monthtemp(:,6),3))
text(0.49,0.45,num2str(monthtemp(:,7),3))
text(0.58,0.45,num2str(monthtemp(:,8),3))
text(0.67,0.45,num2str(monthtemp(:,9),3))
text(0.76,0.45,num2str(monthtemp(:,10),3))
text(0.85,0.45,num2str(monthtemp(:,11),3))
text(0.94,0.45,num2str(monthtemp(:,12),3))
text(1.03,0.45,num2str(astat(:,1),3))
subplot(3,1,2)                                        % subplot temperatures (air/surface and daily/hourly)
axis off
text(-0.15,1,'RHair')
text(-0.05,1,'January')
text(0.04,1,'February')
text(0.13,1,'March')
text(0.22,1,'April')
text(0.31,1,'May')
text(0.40,1,'June')
text(0.49,1,'July')
text(0.58,1,'August')
text(0.67,1,'September')
text(0.76,1,'October')
text(0.85,1,'November')
text(0.94,1,'December')
text(1.03,1,'YEAR')
legend0=(['min    ';'max    ';'average';'range  ';'median ';'stdev  ';'var    ']);
text(-0.15,0.45,legend0)
text(-0.05,0.45,num2str(monthRH(:,1),3))
text(0.04,0.45,num2str(monthRH(:,2),3))
text(0.13,0.45,num2str(monthRH(:,3),3))
text(0.22,0.45,num2str(monthRH(:,4),3))
text(0.31,0.45,num2str(monthRH(:,5),3))
text(0.40,0.45,num2str(monthRH(:,6),3))
text(0.49,0.45,num2str(monthRH(:,7),3))
text(0.58,0.45,num2str(monthRH(:,8),3))
text(0.67,0.45,num2str(monthRH(:,9),3))
text(0.76,0.45,num2str(monthRH(:,10),3))
text(0.85,0.45,num2str(monthRH(:,11),3))
text(0.94,0.45,num2str(monthRH(:,12),3))
text(1.03,0.45,num2str(astat(:,3),3))
subplot(3,1,3)                                        % subplot temperatures (air/surface and daily/hourly)
axis off
text(-0.15,1,'Tsurface')
text(-0.05,1,'January')
text(0.04,1,'February')
text(0.13,1,'March')
text(0.22,1,'April')
text(0.31,1,'May')
text(0.40,1,'June')
text(0.49,1,'July')
text(0.58,1,'August')
text(0.67,1,'September')
text(0.76,1,'October')
text(0.85,1,'November')
text(0.94,1,'December')
text(1.03,1,'YEAR')
legend0=(['min    ';'max    ';'average';'range  ';'median ';'stdev  ';'var    ']);
text(-0.15,0.45,legend0)
text(-0.05,0.45,num2str(monthtsurf(:,1),3))
text(0.04,0.45,num2str(monthtsurf(:,2),3))
text(0.13,0.45,num2str(monthtsurf(:,3),3))
text(0.22,0.45,num2str(monthtsurf(:,4),3))
text(0.31,0.45,num2str(monthtsurf(:,5),3))
text(0.40,0.45,num2str(monthtsurf(:,6),3))
text(0.49,0.45,num2str(monthtsurf(:,7),3))
text(0.58,0.45,num2str(monthtsurf(:,8),3))
text(0.67,0.45,num2str(monthtsurf(:,9),3))
text(0.76,0.45,num2str(monthtsurf(:,10),3))
text(0.85,0.45,num2str(monthtsurf(:,11),3))
text(0.94,0.45,num2str(monthtsurf(:,12),3))
text(1.03,0.45,num2str(astat(:,2),3))
ts=floor(datestr(starttime));                         % rounds startdate to startday (without hh/mm/ss)
te=floor(datestr(endtime));                           % rounds enddate to endday (without hh/mm/ss)
t6=text(0.5,-0.2,dates);                              % places dates-text at the right position
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
grid                                                  % sets grid
NewPosition=[0 0 'PaperSize'];                        % sets paper margins to be 0
orient landscape                                      % stretches figure to portraitsize
fig=sprintf('%s%dstat',savename,yyyy);                 % creates unique name for this figure
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..
figure                                                % Histograms
subplot(2,2,1)
nx=hist(sensor(:,1),[Tmin:0.2:Tmax]);
fx=nx/sum(nx);
bar([Tmin:0.2:Tmax],100*fx)
grid
span=nanmax([5*ceil(20*max(fx)) 1]);
axis([Tmin Tmax 0 span]);
title(['Air temperature'])
xlabel(['Temperatures [width = 0.2 ºC]'])
ylabel(['Percentage of measurements [%]'])
subplot(2,2,2)
nx=hist(sensor(:,2),[Tmin:0.2:Tmax]);
fx=nx/sum(nx);
bar([Tmin:0.2:Tmax],100*fx)
grid
span=nanmax([5*ceil(20*max(fx)) 1]);
axis([Tmin Tmax 0 span]);
title(['Surface temperature'])
xlabel(['Temperatures [width = 0.2 ºC]'])
ylabel(['Percentage of measurements [%]'])
q=text(Tmin-(Tmax-Tmin)/4,span*1.2,([name]));
set(q,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center');
subplot(2,2,3)
nx=hist(sensor(:,3),[RHmin:1:RHmax]);
fx=nx/sum(nx);
bar([RHmin:1:RHmax],100*fx)
grid
span=nanmax([5*ceil(20*max(fx)) 1]);
axis([RHmin RHmax 0 span]);
title(['Relative Humidity of the air'])
xlabel(['Relative Humidity [width = 1 %RH]'])
ylabel(['Percentage of measurements [%]'])
subplot(2,2,4)
nx=hist(sensor(:,4),[RHmin:1:RHmax]);
fx=nx/sum(nx);
bar([RHmin:1:RHmax],100*fx)
grid
span=nanmax([5*ceil(20*max(fx)) 1]);
axis([RHmin RHmax 0 span]);
title(['Relative Humidity near surface'])
xlabel(['Relative Humidity [width = 1 %RH]'])
ylabel(['Percentage of measurements [%]'])
t6=text(RHmin-(RHmax-RHmin)/4,-span/5,dates);         % places dates-text at the right position
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
orient landscape
fig=sprintf('%s%dhistogram',savename,yyyy);            % creates unique name for this figure
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..
fig2=sprintf('%s%d',savename,yyyy);
mollierdensity(sensor,name,fig2,demand)
errtime(sensor,name,fig2,demand)
numbers(sensor,name,fig2,demand)