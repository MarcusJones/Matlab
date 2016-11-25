function y=month(s,c,name,figname,yyyy,mm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% timeplot for all data for one sensor, but only during one month
% a month is specified by a year and a month number
% January 19, 2005, TUE, PBE, MM
% month(sensor,climate,title,filename,year,month,[0;0;0;0;0;0;1;0;0;0])
%                                                 ASHRAE A  Thomson1
%                                                   ASHRAE B  Thomson2
%                                                     ASHRAE C  Deltaplan
%                                                       ASHRAE D  Mecklenburg
%                                                         Jutte     Lafontaine  (only one at a time can be '1')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dagen=floor((yyyy-1)/4);
opgeschoven=yyyy+dagen;
a=-opgeschoven+7*floor(opgeschoven/7)+3;
for i=[1:53];
weeklabel(1,i)=datenum(yyyy,1,7*i-5+a,12,0,0);                  % creates a weeknumber and a weekly average time
weeklabel(2,i)=i;
end
starttime=datenum(yyyy,mm,1,0,0,0);                             % sets starttime to match monthnumber
endtime=datenum(yyyy,mm+1,1,0,0,0);                             % sets endtime to match monthnumber
ws=min(find(weeklabel(1,:)>=starttime-1));                      % calculates minimum weeknumber in month
we=max(find(weeklabel(1,:)<=endtime+1));                        % calculates maximum weeknumber in month
if mm==1                                                        % for the first month to be plotted
    mon=('January');                                            % the monthname should be 'January',
elseif mm==2
    mon=('February');
elseif mm==3
    mon=('March');
elseif mm==4
    mon=('April');
elseif mm==5
    mon=('May');
elseif mm==6
    mon=('June');
elseif mm==7
    mon=('July');
elseif mm==8
    mon=('August');
elseif mm==9
    mon=('September');
elseif mm==10
    mon=('October');
elseif mm==11
    mon=('November');
elseif mm==12
    mon=('December');
end
sensor=reduce(s,starttime,endtime);                             % renames and reduces first sensor
c=reduce(c,starttime,endtime);                                  % renames and reduces climate sensor
fig=sprintf('%s%dm%dtime',figname,yyyy,mm);                     % gives output a unique name
dates=sprintf('%s %d, week %d to %d',mon,yyyy,ws,we);
aa=length(s(1,:));
figure                                                          % starts new figure window
subplot(3,1,1)                                                  % starts new subplot in current figure, time against temperatures
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
for ww=[ws:we]
t1=text(weeklabel(1,ww),-0,num2str(ww));
set(t1,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center')
end
axis([(starttime-1) (endtime+1) 0 30])
datetick('x','dd/mm','keeplimits')
ylabel(['Temperature [ºC]'])
a=title([name]);
set(a,'FontSize',20);
set(d,'FontSize',7);
grid
subplot(3,1,2)                                                  % starts new subplot in current figure, time against relative humidity
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
for ww=[ws:we]
t1=text(weeklabel(1,ww),-0,num2str(ww));
set(t1,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center')
end
axis([(starttime-1) (endtime+1) 0 100])
datetick('x','dd/mm','keeplimits')
ylabel(['Relative Humidity [% RH]'])
set(e,'FontSize',7);
grid
subplot(3,1,3)                                                  % starts new subplot in current figure, time against specific humidity
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
for ww=[ws:we]
t1=text(weeklabel(1,ww),0,num2str(ww));
set(t1,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center')
end
axis([(starttime-1) (endtime+1) 0 12])
datetick('x','dd/mm','keeplimits')
ylabel(['Specific Humidity [g/kg]'])
t6=text((starttime+endtime)/2,-2.4,dates);
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')
set(g,'FontSize',7)
grid
NewPosition=[0 0 'PaperSize'];
orient tall
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..