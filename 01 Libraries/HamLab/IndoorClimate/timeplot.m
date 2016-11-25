function y=timeplot(s,c,name,figname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots given parameter(s) against time
% december 16, 2004, TUe, PBE, MM
% timeplot(sensor,sensor for outside climate,title,filename) plots sensor readings against time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
starttime=s(1,10);
endtime=s(length(s(:,10)),10);
ts=floor(datestr(starttime));
te=floor(datestr(endtime));
dates=sprintf('startdate: %s, enddate: %s',ts,te);
aa=length(s(1,:));
figure                                                % starts new figure window
subplot(4,1,1)                                        % starts new subplot in current figure, time against temperatures
if aa==20
plot(s(:,10),s(:,1),'r-',s(:,10),s(:,2),'g-',s(:,10),s(:,9),'r:',c(:,10),c(:,1),'b-',c(:,10),c(:,9),'b:',s(:,10),s(:,11),'c-',s(:,10),s(:,12),'k-',s(:,10),s(:,19),'k:')
d=legend('Tair','Tsurf1','Tdew','Tclimate','Tdew cli','Tin','Tsurf2','Tdewin');
elseif aa==26
plot(s(:,10),s(:,1),'r-',s(:,10),s(:,2),'g-',s(:,10),s(:,9),'r:',c(:,10),c(:,1),'b-',c(:,10),c(:,9),'b:',s(:,10),s(:,11),'c-',s(:,10),s(:,12),'k-',s(:,10),s(:,19),'k:',s(:,10),s(:,21),'m-',s(:,10),s(:,26),'m:')
d=legend('Tair','Tsurf2','Tdew','Tclimate','Tdew cli','Tin','Tsurf2','Tdewin','Tgap','Tdewgap');
else
plot(s(:,10),s(:,1),'r-',s(:,10),s(:,2),'g-',s(:,10),s(:,9),'r:',c(:,10),c(:,1),'b-',c(:,10),c(:,9),'b:')
d=legend('Tair','Tsurface','Tdew','Tclimate','Tdew cli');
end
if aa>19
minT=floor(min(min([s(:,1) s(:,2) s(:,9) c(:,1) c(:,9) s(:,11) s(:,12) s(:,19)])));
maxT=ceil(max(max([s(:,1) s(:,2) s(:,9) c(:,1) c(:,9) s(:,11) s(:,12) s(:,19)])));
else
minT=floor(min(min([s(:,1) s(:,2) s(:,9) c(:,1) c(:,9)])));
maxT=ceil(max(max([s(:,1) s(:,2) s(:,9) c(:,1) c(:,9)])));
end
axis([starttime endtime minT maxT]);
datetick('x','dd/mm','keeplimits')
ylabel(['Temperature [ºC]'])
a=title([name]);
set(a,'FontSize',20);
set(d,'FontSize',7);
grid
subplot(4,1,2)                                        % starts new subplot in current figure, time against relative humidity
if aa==20
plot(s(:,10),s(:,3),'r-',s(:,10),s(:,4),'g-',c(:,10),c(:,3),'b-',s(:,10),s(:,13),'c-',s(:,10),s(:,14),'k-',s(:,10),s(:,20),'k:')
e=legend('RHair','RHsurf1','RHclimate','RHin','RHsurf2','RHs2in');
elseif aa==26
plot(s(:,10),s(:,3),'r-',s(:,10),s(:,4),'g-',c(:,10),c(:,3),'b-',s(:,10),s(:,13),'c-',s(:,10),s(:,14),'k-',s(:,10),s(:,20),'k:',s(:,10),s(:,22),'m-')
e=legend('RHair','RHsurface','RHclimate','RHin','RHsurf2','RHs2in','RHgap');
else
plot(s(:,10),s(:,3),'r-',s(:,10),s(:,4),'g-',c(:,10),c(:,3),'b-')
e=legend('RHair','RHsurface','RHclimate');
end
if aa>19
minT=floor(min(min([s(:,3) s(:,4) c(:,3) s(:,13) s(:,14) s(:,20)])));
maxT=ceil(max(max([s(:,3) s(:,4) c(:,3) s(:,13) s(:,14) s(:,20)])));
else
minT=floor(min(min([s(:,3) s(:,4) c(:,3)])));
maxT=ceil(max(max([s(:,3) s(:,4) c(:,3)])));
end
axis([starttime endtime minT maxT]);
datetick('x','dd/mm','keeplimits')
ylabel(['Relative Humidity [% RH]'])
set(e,'FontSize',7);
grid
subplot(4,1,3)                                        % starts new subplot in current figure, time against vapour pressures
if aa==20
plot(s(:,10),s(:,5),'r:',s(:,10),s(:,6),'g:',s(:,10),s(:,7),'r-',c(:,10),c(:,7),'b-',s(:,10),s(:,15),'c:',s(:,10),s(:,16),'k:',s(:,10),s(:,17),'c-')
f=legend('p sat,air','p sat,surf1','p air','p climate','p sat,in','p sat,surf2','p in');
elseif aa==26
plot(s(:,10),s(:,5),'r:',s(:,10),s(:,6),'g:',s(:,10),s(:,7),'r-',c(:,10),c(:,7),'b-',s(:,10),s(:,15),'c:',s(:,10),s(:,16),'k:',s(:,10),s(:,17),'c-',s(:,10),s(:,23),'m:',s(:,10),s(:,24),'m-')
f=legend('p sat,air','p sat,surf1','p air','p climate','p sat,in','p sat,surf2','p in','p sat,gap','p gap');
else
plot(s(:,10),s(:,5),'r:',s(:,10),s(:,6),'g:',s(:,10),s(:,7),'r-',c(:,10),c(:,7),'b-')
f=legend('p sat,air','p sat,surface','p air','p climate');
end
if aa>19
minT=floor(min(min([s(:,5) s(:,6) s(:,7) c(:,7) s(:,15) s(:,16) s(:,17)])));
maxT=ceil(max(max([s(:,5) s(:,6) s(:,7) c(:,7) s(:,15) s(:,16) s(:,17)])));
else
minT=floor(min(min([s(:,5) s(:,6) s(:,7) c(:,7)])));
maxT=ceil(max(max([s(:,5) s(:,6) s(:,7) c(:,7)])));
end
axis([starttime endtime minT maxT]);
datetick('x','dd/mm','keeplimits')
ylabel(['Vapour Pressure [Pa]'])
set(f,'FontSize',7)
grid
subplot(4,1,4)                                        % starts new subplot in current figure, time against moisture content
if aa==20
plot(s(:,10),s(:,8),'r-',c(:,10),c(:,8),'b-',s(:,10),s(:,18),'k-')
g=legend('x air','x climate','x in');
elseif aa==26
plot(s(:,10),s(:,8),'r-',c(:,10),c(:,8),'b-',s(:,10),s(:,18),'k-',s(:,10),s(:,25),'m-')
g=legend('x air','x climate','x in','x gap');
else
plot(s(:,10),s(:,8),'r-',c(:,10),c(:,8),'b-')
g=legend('x air','x climate');
end
if aa>19
minT=floor(min(min([s(:,8) c(:,8) s(:,18)])));
maxT=ceil(max(max([s(:,8) c(:,8) s(:,18)])));
else
minT=floor(min(min([s(:,8) c(:,8)])));
maxT=ceil(max(max([s(:,8) c(:,8)])));
end
axis([starttime endtime minT maxT]);
datetick('x','dd/mm','keeplimits')
ylabel(['Specific Humidity [g/kg]'])
b=xlabel([dates]);
set(b,'FontSize',16,'VerticalAlignment','top')
set(g,'FontSize',7)
grid
NewPosition=[0 0 'PaperSize'];
orient tall
b=sprintf('%stime',figname);
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',b);
cd ..