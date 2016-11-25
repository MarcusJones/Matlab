function y=week(s,c,name,figname,yyyy,ww)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aangepast aan folders: niet verplaatsen !!!
% timeplot for all data for one sensor, but only during one week
% a week is specified by a year and a weeknumber 
% January 13, 2005, TUE, PBE, MM
% week(sensor,climate,title,filename,year,week)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dagen=floor((yyyy-1)/4);
opgeschoven=yyyy+dagen;
a=-opgeschoven+7*floor(opgeschoven/7)+3;
global dstat wstat starttime endtime                  % sets dstat and wstat to be global (these are created by 'statistics')
starttime=datenum(yyyy,1,7*ww-7+a,0,0,0);             % sets starttime to match weeknumber
endtime=datenum(yyyy,1,7*ww+a,0,0,0);                 % sets endtime to match weeknumber
sensor=reduce(s,starttime,endtime);                   % renames and reduces first sensor
c=reduce(c,starttime,endtime);                        % renames and reduces climate sensor
statistics(sensor,0,0,0,1,1);                         % runs statistics for this sensor
cdate=datevec(sensor(1,10));
for i=[1:7];
daylabel1(i)=datenum(cdate(1),cdate(2),cdate(3)-1+i,12,0,0);
end
daylabel2=(['  Monday ';' Tuesday ';'Wednesday';' Thursday';'  Friday ';' Saturday';'  Sunday ']);
daypoints=max(find(sensor(:,10)<=datenum(cdate(1),cdate(2),cdate(3)+1,cdate(4),cdate(5),cdate(6))))-1;
hourpoints=round(daypoints/24);
m=reduce(s,starttime-1,endtime+1);
ts=floor(datestr(starttime));
te=floor(datestr(endtime));
dates=sprintf('WEEK %d, %d, %s to %s',ww,yyyy,ts,te);
aa=length(s(1,:));
figure                                                % starts new figure window
subplot(3,1,1)                                        % starts new subplot in current figure, time against temperatures
if aa==20
plot(sensor(:,10),sensor(:,1),'k-',sensor(:,10),sensor(:,2),'g-.',sensor(:,10),sensor(:,9),'r-.',c(:,10),c(:,1),'b:',c(:,10),c(:,9),'y-',sensor(:,10),sensor(:,11),'c-',sensor(:,10),sensor(:,12),'k-',sensor(:,10),sensor(:,19),'k:')
d=legend('Tair','Tsurf1','Tdew','Tclimate','Tdew cli','Tin','Tsurf2','Tdewin');
elseif aa==26
plot(sensor(:,10),sensor(:,1),'k-',sensor(:,10),sensor(:,2),'g-.',sensor(:,10),sensor(:,9),'r-.',c(:,10),c(:,1),'b:',c(:,10),c(:,9),'y-',sensor(:,10),sensor(:,11),'c-',sensor(:,10),sensor(:,12),'k-',sensor(:,10),sensor(:,19),'k:',sensor(:,10),sensor(:,21),'m-',sensor(:,10),sensor(:,26),'m:')
d=legend('Tair','Tsurf2','Tdew','Tclimate','Tdew cli','Tin','Tsurf2','Tdewin','Tgap','Tdewgap');
else
plot(sensor(:,10),sensor(:,1),'k-',sensor(:,10),sensor(:,2),'g-.',sensor(:,10),sensor(:,9),'r-.',c(:,10),c(:,1),'b:');%,c(:,10),c(:,9),'y-')
d=legend('Tair','Tsurface','Tdew','Tclimate');%,'Tdew cli');
end
axis([starttime endtime 0 35])
datetick('x','dd/mm','keeplimits')
ylabel(['Temperature [ºC]'])
for i=[1:7]
dait=text(daylabel1(i),0,sprintf('%s',daylabel2(i,:)));
set(dait,'FontSize',7,'VerticalAlignment','top','HorizontalAlignment','center')
end
q=title([name]);
set(q,'FontSize',20);
set(d,'FontSize',7);
grid
subplot(3,1,2)                                        % starts new subplot in current figure, time against relative humidity
if aa==20
plot(sensor(:,10),sensor(:,3),'k-',sensor(:,10),sensor(:,4),'g-.',c(:,10),c(:,3),'b:',sensor(:,10),sensor(:,13),'c-',sensor(:,10),sensor(:,14),'k-',sensor(:,10),sensor(:,20),'k:')
e=legend('RHair','RHsurf1','RHclimate','RHin','RHsurf2','RHs2in');
elseif aa==26
plot(sensor(:,10),sensor(:,3),'k-',sensor(:,10),sensor(:,4),'g-.',c(:,10),c(:,3),'b:',sensor(:,10),sensor(:,13),'c-',sensor(:,10),sensor(:,14),'k-',sensor(:,10),sensor(:,20),'k:',sensor(:,10),sensor(:,22),'m-')
e=legend('RHair','RHsurface','RHclimate','RHin','RHsurf2','RHs2in','RHgap');
else
plot(sensor(:,10),sensor(:,3),'k-',sensor(:,10),sensor(:,4),'g-.',c(:,10),c(:,3),'b:')
e=legend('RHair','RHsurface','RHclimate');
end
axis([starttime endtime 20 100])
datetick('x','dd/mm','keeplimits')
for i=[1:7]
dait=text(daylabel1(i),20,sprintf('%s',daylabel2(i,:)));
set(dait,'FontSize',7,'VerticalAlignment','top','HorizontalAlignment','center')
end
ylabel(['Relative Humidity [% RH]'])
set(e,'FontSize',7);
grid
subplot(3,1,3)                                        % starts new subplot in current figure, time against specific humidity
if aa==20
plot(sensor(:,10),sensor(:,8),'k-',c(:,10),c(:,8),'b-.',sensor(:,10),sensor(:,18),'g-')
g=legend('x air','x climate','x in');
elseif aa==26
plot(sensor(:,10),sensor(:,8),'k-',c(:,10),c(:,8),'b-.',sensor(:,10),sensor(:,18),'g-',sensor(:,10),sensor(:,25),'m-.')
g=legend('x air','x climate','x in','x gap');
else
plot(sensor(:,10),sensor(:,8),'k-',c(:,10),c(:,8),'b-.')
g=legend('x air','x climate');
end
axis([starttime endtime 0 12])
datetick('x','dd/mm','keeplimits')
for i=[1:7]
dait=text(daylabel1(i),0,sprintf('%s',daylabel2(i,:)));
set(dait,'FontSize',7,'VerticalAlignment','top','HorizontalAlignment','center')
end
ylabel(['Specific Humidity [g/kg]'])
t6=text((starttime+endtime)/2,-2,dates);
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')
set(g,'FontSize',7)
grid
NewPosition=[0 0 'PaperSize'];
orient tall
fig=sprintf('%s%dw%dtime',figname,yyyy,ww);           % gives output a unique name
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..
s1=7*ww-7+a;                                          % day to start statistics
s2=7*ww-6+a;                                          % day to stop statistics
s3=7*ww-5+a;                                          % day to stop statistics
s4=7*ww-4+a;                                          % day to stop statistics
s5=7*ww-3+a;                                          % day to stop statistics
s6=7*ww-2+a;                                          % day to stop statistics
s7=7*ww-1+a;                                          % day to stop statistics
startdate=datevec(sensor(1,10));
if startdate(1)/4-round(startdate(1)/4)==0
    maxday=366;
else maxday=365;
end
if s1<1
    s1new=maxday+s1;
    s1=s1new;
end
if s2<1
    s2new=maxday+s2;
    s2=s2new;
end
if s3<1
    s3new=maxday+s3;
    s3=s3new;
end
if s4<1
    s4new=maxday+s4;
    s4=s4new;
end
if s5<1
    s5new=maxday+s5;
    s5=s5new;
end
if s6<1
    s6new=maxday+s6;
    s6=s6new;
end
if s7<1
    s7new=maxday+s7;
    s7=s7new;
end
if s1>maxday
    s1new=s1-maxday;
    s1=s1new;
end
if s2>maxday
    s2new=s2-maxday;
    s2=s2new;
end
if s3>maxday
    s3new=s3-maxday;
    s3=s3new;
end
if s4>maxday
    s4new=s4-maxday;
    s4=s4new;
end
if s5>maxday
    s5new=s5-maxday;
    s5=s5new;
end
if s6>maxday
    s6new=s6-maxday;
    s6=s6new;
end
if s7>maxday
    s7new=s7-maxday;
    s7=s7new;
end
daytemp(:,[1:7])=dstat(:,1,[s1 s2 s3 s4 s5 s6 s7]);   % daily average for air temperature
daytsurf(:,[1:7])=dstat(:,2,[s1 s2 s3 s4 s5 s6 s7]);  % daily average for surface temperature
dayRH(:,[1:7])=dstat(:,3,[s1 s2 s3 s4 s5 s6 s7]);     % daily average for air RH
for i=[1:length(sensor(:,10))]                        % calculates hourly difference between min and max
deltatemp(i)=range([m([daypoints+i-hourpoints:daypoints+i],1)]);
deltatsurf(i)=range([m([daypoints+i-hourpoints:daypoints+i],2)]);
deltaRH(i)=range([m([daypoints+i-hourpoints:daypoints+i],3)]);
deltaRHsurf(i)=range([m([daypoints+i-hourpoints:daypoints+i],4)]);
end
for i=[1:length(sensor(:,10))]                        % calculates daily difference between min and max
dayt(i)=range([m([i:daypoints+i],1)]);
days(i)=range([m([i:daypoints+i],2)]);
dayReH(i)=range([m([i:daypoints+i],3)]);
dayReHsurf(i)=range([m([i:daypoints+i],4)]);
end
figure                                                % creates new figure
subplot(4,1,1)                                        % subplot temperatures (air/surface and daily/hourly)
plot(sensor(:,10),dayt,'k-.',sensor(:,10),days,'g-.',sensor(:,10),deltatemp,'k-',sensor(:,10),deltatsurf,'g-')
dd=legend('Tair, past 24h','Tsurf, past 24h','Tair, past 1h','Tsurf, past 1h');
set(dd,'FontSize',7);
datetick('x','dd/mm','keeplimits')
for i=[1:7]
dayt=text(daylabel1(i),0,sprintf('%s',daylabel2(i,:)));
set(dayt,'FontSize',7,'VerticalAlignment','top','HorizontalAlignment','center')
end
ylabel(['Delta Temperature [ºC]'])
a=title([name]);
set(a,'FontSize',20);
grid
subplot(4,1,2)                                        % subplot temperatures (air/surface and daily/hourly)
plot(sensor(:,10),dayReH,'k-.',sensor(:,10),dayReHsurf,'g-.',sensor(:,10),deltaRH,'k-',sensor(:,10),deltaRHsurf,'g-')
ee=legend('RHair, past 24h','RHsurf, past 24h','RHair, past 1h','RHsurf, past 1h');
set(ee,'FontSize',7);
datetick('x','dd/mm','keeplimits')
for i=[1:7]
dayt=text(daylabel1(i),0,sprintf('%s',daylabel2(i,:)));
set(dayt,'FontSize',7,'VerticalAlignment','top','HorizontalAlignment','center')
end
ylabel(['Delta Relative Humidity [% RH]'])
grid
subplot(6,1,4)                                        % subplot temperatures (air/surface and daily/hourly)
axis off
text(-0.09,1,'Tair')
text(0.05,1,'Monday')
text(0.19,1,'Tuesday')
text(0.33,1,'Wednesday')
text(0.47,1,'Thursday')
text(0.61,1,'Friday')
text(0.75,1,'Saturday')
text(0.89,1,'Sunday')
text(1.03,1,'WEEK')
legend0=(['min    ';'max    ';'average';'range  ';'median ';'stdev  ';'var    ']);
text(-0.09,0.45,legend0)
text(0.05,0.45,num2str(daytemp(:,1),3))
text(0.19,0.45,num2str(daytemp(:,2),3))
text(0.33,0.45,num2str(daytemp(:,3),3))
text(0.47,0.45,num2str(daytemp(:,4),3))
text(0.61,0.45,num2str(daytemp(:,5),3))
text(0.75,0.45,num2str(daytemp(:,6),3))
text(0.89,0.45,num2str(daytemp(:,7),3))
text(1.03,0.45,num2str(wstat(:,1,ww),3))
subplot(6,1,5)                                        % subplot temperatures (air/surface and daily/hourly)
axis off
text(-0.09,1,'RHair')
text(0.05,1,'Monday')
text(0.19,1,'Tuesday')
text(0.33,1,'Wednesday')
text(0.47,1,'Thursday')
text(0.61,1,'Friday')
text(0.75,1,'Saturday')
text(0.89,1,'Sunday')
text(1.03,1,'WEEK')
legend1=(['min    ';'max    ';'average';'range  ';'median ';'stdev  ';'var    ']);
text(-0.09,0.45,legend1)
text(0.05,0.45,num2str(dayRH(:,1),3))
text(0.19,0.45,num2str(dayRH(:,2),3))
text(0.33,0.45,num2str(dayRH(:,3),3))
text(0.47,0.45,num2str(dayRH(:,4),3))
text(0.61,0.45,num2str(dayRH(:,5),3))
text(0.75,0.45,num2str(dayRH(:,6),3))
text(0.89,0.45,num2str(dayRH(:,7),3))
text(1.03,0.45,num2str(wstat(:,3,ww),3))
subplot(6,1,6)                                        % subplot temperatures (air/surface and daily/hourly)
axis off
text(-0.09,1,'Tsurface')
text(0.05,1,'Monday')
text(0.19,1,'Tuesday')
text(0.33,1,'Wednesday')
text(0.47,1,'Thursday')
text(0.61,1,'Friday')
text(0.75,1,'Saturday')
text(0.89,1,'Sunday')
text(1.03,1,'WEEK')
legend2=(['min    ';'max    ';'average';'range  ';'median ';'stdev  ';'var    ']);
text(-0.09,0.45,legend2)
text(0.05,0.45,num2str(daytsurf(:,1),3))
text(0.19,0.45,num2str(daytsurf(:,2),3))
text(0.33,0.45,num2str(daytsurf(:,3),3))
text(0.47,0.45,num2str(daytsurf(:,4),3))
text(0.61,0.45,num2str(daytsurf(:,5),3))
text(0.75,0.45,num2str(daytsurf(:,6),3))
text(0.89,0.45,num2str(daytsurf(:,7),3))
text(1.03,0.45,num2str(wstat(:,2,ww),3))
ts=floor(datestr(starttime));                         % rounds startdate to startday (without hh/mm/ss)
te=floor(datestr(endtime));                           % rounds enddate to endday (without hh/mm/ss)
t6=text(0.5,-0.2,dates);                              % places dates-text at the right position
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
grid                                                  % sets grid
NewPosition=[0 0 'PaperSize'];                        % sets paper margins to be 0
orient tall                                           % stretches figure to portraitsize
fig=sprintf('%s%dw%dstat',figname,yyyy,ww);           % creates unique name for this figure
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..