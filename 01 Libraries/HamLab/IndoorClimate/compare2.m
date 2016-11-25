function y=compare2(time1,temp1,rh1,time2,temp2,rh2,s1name,s2name,name,figname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% comparison for two different sensors 
% February 11, 2005, TUE, PBE, MM
% compare2(time1,temp1,rh1,time2,temp2,rh2,s1name,s2name,name,figname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1=conversion(temp1,[],rh1,time1);
s2=conversion(temp2,[],rh2,time2);
global astat mstat seasons wstat    % sets dstat and wstat to be global (these are created by 'statistics')
starttime=min([s1(1,10) s2(1,10)]);
endtime=max([s1(length(s1(:,10)),10) s1(length(s1(:,10)),10)]);
start=datevec(starttime);
stop=datevec(endtime);
ts=floor(datestr(datenum(start(1),start(2),start(3),0,0,0)));
te=floor(datestr(datenum(stop(1),stop(2),stop(3),0,0,0)));
dates=sprintf('%s versus %s, %s to %s',s1name,s2name,ts,te);
figure                                                % starts new figure window
subplot(2,1,1)                                        % starts new subplot in current figure, time against temperatures
plot(s1(:,10),s1(:,1),'r-',s1(:,10),s1(:,2),'g-.',s2(:,10),s2(:,1),'b-',s2(:,10),s2(:,2),'m-.');
d=legend(sprintf('Tair %s',s1name),sprintf('Tsurf %s',s1name),sprintf('Tair %s',s2name),sprintf('Tsurf %s',s2name));
maxi=ceil(max([max(s1(:,1)) max(s1(:,2)) max(s2(:,1)) max(s2(:,2))]));
mini=floor(min([min(s1(:,1)) min(s1(:,2)) min(s2(:,1)) min(s2(:,2))]));
axis([(starttime-1) (endtime+1) mini maxi])
datetick('x','dd/mm','keeplimits')
xlabel(['Time [day / month]'])
ylabel(['Temperature [ºC]'])
q=title([name]);
set(q,'FontSize',20);
set(d,'FontSize',7);
grid
subplot(2,1,2)                                        % starts new subplot in current figure, time against relative humidity
plot(s1(:,10),s1(:,3),'r-',s1(:,10),s1(:,4),'g-.',s2(:,10),s2(:,3),'b-',s2(:,10),s2(:,4),'m-.');
ee=legend(sprintf('RHair %s',s1name),sprintf('RHsurf %s',s1name),sprintf('RHair %s',s2name),sprintf('RHsurf %s',s2name));
maxj=floor(max([max(s1(:,3)) max(s1(:,4)) max(s2(:,3)) max(s2(:,4))]));
minj=ceil(min([min(s1(:,3)) min(s1(:,4)) min(s2(:,3)) min(s2(:,4))]));
axis([(starttime-1) (endtime+1) minj maxj])
datetick('x','dd/mm','keeplimits')
ylabel(['Relative Humidity [% RH]'])
set(ee,'FontSize',7);
grid
NewPosition=[0 0 'PaperSize'];
orient landscape
t6=text((starttime+endtime)/2,minj-0.1*maxj,dates);  % places dates-text at the right position
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
fig=sprintf('%scomtime',figname);                 % gives output a unique name
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..
for j=[1:11]                                          % sets temperature matrix, 1 cell = 1 degree
    for h=[1:81]                                      % -20 up to 60 degrees Celsius
    T(h,j)=(h-21);
    end
end
for i=[1:81];
RV(i,[1:11])=[0:0.1:1];                               % sets humidity matrix, in steps of 10%
end
for k=[1:11]                                          % calculates p for each temperature and humidity
    for l=[1:20]
    p(l,k)=611*exp(22.44*T(l,1)./(272.44+T(l,1)))*RV(l,k);
    end
    for l=[21:81]
    p(l,k)=611*exp(17.08*T(l,1)./(234.18+T(l,1)))*RV(l,k);
    end
    for m=[1:81]
    x(m,k)=611*p(m,k)./(101300-p(m,k));               % calculates specific humidity for each p
    end
end
figure
subplot(1,2,1)                                        % Mollier Air Temperature / Humidity
statistics(s1,0,1,0,1,0);
a=1;
b=8;
contour(x,T,RV,RV(1,:));                              % plots isoRHlines in plot
axis([0 25 -1 31]);                       % sets axis xmin, xmax, Tmin, Tmax
NewPosition=[0 0 'PaperSize'];                        % sets paper margins to zero
orient tall                                           % stretches figure to A4-size
hold on                                               % freezes figure (so other plots can be put in without deleting previous plots)
legstr=[];                                            % creates empty matrix to put legenddata in
plot(seasons(:,b,1),seasons(:,a,1),'.','color',[.6 .6 1])% plots winter data light blue
legstr=[legstr;'Winter Measurements  '];
plot(seasons(:,b,2),seasons(:,a,2),'.','color',[1 .8 .5])% plots spring data light orange
legstr=[legstr;'Spring Measurements  '];
plot(seasons(:,b,3),seasons(:,a,3),'.','color',[1 .7 .7])% plots summer data light red
legstr=[legstr;'Summer Measurements  '];
plot(seasons(:,b,4),seasons(:,a,4),'.','color',[.8 .6 .8])% plots light purple
legstr=[legstr;'Autumn Measurements  '];
w1([1:14])=wstat(3,b,[52 53 1:12]);
w2([1:14])=wstat(3,a,[52 53 1:12]);
plot(w1,w2,'o','color',[0 0 .8],'LineWidth',[1.5])    % plots weekly winter average blue 
legstr=[legstr;'Winter Weekly Average'];
w3([1:13])=wstat(3,b,[13:25]);
w4([1:13])=wstat(3,a,[13:25]);
plot(w3,w4,'*','color',[1 .5 .1],'LineWidth',[1.5])   % plots weekly spring average orange
legstr=[legstr;'Spring Weekly Average'];
w5([1:13])=wstat(3,b,[26:38]);
w6([1:13])=wstat(3,a,[26:38]);
plot(w5,w6,'>','color',[.8 0 0],'LineWidth',[1.5])    % plots weekly summer average red
legstr=[legstr;'Summer Weekly Average'];
w7([1:13])=wstat(3,b,[39:51]);
w8([1:13])=wstat(3,a,[39:51]);
plot(w7,w8,'+','color',[.6 0 .6],'LineWidth',[1.5])   % plots weekly autumn average purple
legstr=[legstr;'Autumn Weekly Average'];
xlabel(['Specific Humidity [g/kg]'])
ylabel('Dry Bulb Temperature [ºC]')
l=legend([legstr],4 );                                % creates legend containing all legstrings in lower right corner
set(l,'FontSize',7);                                  % sets legend fontsize to 7
text(x(48,2),27,'10%')                 % creates text label for each isoRHline
text(x(48,3),27,'20%')
text(x(48,4),27,'30%')
text(x(48,5),27,'40%')
text(x(48,6),27,'50%')
text(x(48,7),27,'60%')
text(x(48,8),27,'70%')
text(x(48,9),27,'80%')
text(x(48,10),27,'90%')
text(x(48,11),27,'100%')
t=text(x(48,2),29,s1name);
set(t,'FontSize',15);
grid;                                                 % turns grid on
hold off;
subplot(1,2,2)                                        % Mollier Surface Temperature / Humidity
statistics(s2,0,1,0,1,0);
a=1;
b=8;
contour(x,T,RV,RV(1,:));                              % plots isoRHlines in plot
axis([0 25 -1 31]);                       % sets axis xmin, xmax, Tmin, Tmax
NewPosition=[0 0 'PaperSize'];                        % sets paper margins to zero
orient tall                                           % stretches figure to A4-size
hold on                                               % freezes figure (so other plots can be put in without deleting previous plots)
legstr=[];                                            % creates empty matrix to put legenddata in
plot(seasons(:,b,1),seasons(:,a,1),'.','color',[.6 .6 1])% plots winter data light blue
legstr=[legstr;'Winter Measurements  '];
plot(seasons(:,b,2),seasons(:,a,2),'.','color',[1 .8 .5])% plots spring data light orange
legstr=[legstr;'Spring Measurements  '];
plot(seasons(:,b,3),seasons(:,a,3),'.','color',[1 .7 .7])% plots summer data light red
legstr=[legstr;'Summer Measurements  '];
plot(seasons(:,b,4),seasons(:,a,4),'.','color',[.8 .6 .8])% plots light purple
legstr=[legstr;'Autumn Measurements  '];
w1([1:14])=wstat(3,b,[52 53 1:12]);
w2([1:14])=wstat(3,a,[52 53 1:12]);
plot(w1,w2,'o','color',[0 0 .8],'LineWidth',[1.5])    % plots weekly winter average blue 
legstr=[legstr;'Winter Weekly Average'];
w3([1:13])=wstat(3,b,[13:25]);
w4([1:13])=wstat(3,a,[13:25]);
plot(w3,w4,'*','color',[1 .5 .1],'LineWidth',[1.5])   % plots weekly spring average orange
legstr=[legstr;'Spring Weekly Average'];
w5([1:13])=wstat(3,b,[26:38]);
w6([1:13])=wstat(3,a,[26:38]);
plot(w5,w6,'>','color',[.8 0 0],'LineWidth',[1.5])    % plots weekly summer average red
legstr=[legstr;'Summer Weekly Average'];
w7([1:13])=wstat(3,b,[39:51]);
w8([1:13])=wstat(3,a,[39:51]);
plot(w7,w8,'+','color',[.6 0 .6],'LineWidth',[1.5])   % plots weekly autumn average purple
legstr=[legstr;'Autumn Weekly Average'];
xlabel(['Specific Humidity [g/kg]'])
ylabel('Dry Bulb Temperature [ºC]')
l=legend([legstr],4 );                                % creates legend containing all legstrings in lower right corner
set(l,'FontSize',7);                                  % sets legend fontsize to 7
text(x(48,2),27,'10%')                 % creates text label for each isoRHline
text(x(48,3),27,'20%')
text(x(48,4),27,'30%')
text(x(48,5),27,'40%')
text(x(48,6),27,'50%')
text(x(48,7),27,'60%')
text(x(48,8),27,'70%')
text(x(48,9),27,'80%')
text(x(48,10),27,'90%')
text(x(48,11),27,'100%')
t=text(x(48,2),29,s2name);
set(t,'FontSize',15);
grid;
q=text(-5,33,([name]));
set(q,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center');
t6=text(-5,-3,dates);  % places dates-text at the right position
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
orient landscape
fig=sprintf('%scommol',figname);              % creates unique name for this figure
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..
figure                                                % Histograms
subplot(4,2,1)
nx=hist(s1(:,1),[mini:0.2:maxi]);
fx=nx/sum(nx);
a=bar([mini:0.2:maxi],100*fx);
set(a,'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
grid
span1=5*ceil(20*nanmax(fx));
axis([mini maxi 0 span1]);
ylabel(['Percentage [%]'])
text(mini+0.05*(maxi-mini),0.9*span1,sprintf('%s Air Temperature',s1name))
subplot(4,2,3)
nx=hist(s2(:,1),[mini:0.2:maxi]);
fx=nx/sum(nx);
a=bar([mini:0.2:maxi],100*fx);
set(a,'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
grid
span3=5*ceil(20*nanmax(fx));
axis([mini maxi 0 span3]);
ylabel(['Percentage [%]'])
text(mini+0.05*(maxi-mini),0.9*span3,sprintf('%s Air Temperature',s2name))
subplot(4,2,2)
nx=hist(s1(:,2),[mini:0.2:maxi]);
fx=nx/sum(nx);
a=bar([mini:0.2:maxi],100*fx);
set(a,'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
grid
axis([mini maxi 0 span1]);
ylabel(['Percentage [%]'])
q=text(mini-(maxi-mini)/4,span1*1.4,([name]));
set(q,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center');
text(mini+0.05*(maxi-mini),0.9*span1,sprintf('%s Surface Temperature',s1name))
subplot(4,2,4)
nx=hist(s2(:,2),[mini:0.2:maxi]);
fx=nx/sum(nx);
a=bar([mini:0.2:maxi],100*fx);
set(a,'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
grid
axis([mini maxi 0 span3]);
ylabel(['Percentage [%]'])
text(mini+0.05*(maxi-mini),0.9*span3,sprintf('%s Surface Temperature',s2name))
subplot(4,2,5)
nx=hist(s1(:,3),[minj:1:maxj]);
fx=nx/sum(nx);
a=bar([minj:1:maxj],100*fx);
set(a,'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
grid
span5=5*ceil(20*nanmax(fx));
axis([minj maxj 0 span5]);
ylabel(['Percentage [%]'])
text(minj+0.05*(maxj-minj),0.9*span5,sprintf('%s Air Relative Humidity',s1name))
subplot(4,2,7)
nx=hist(s2(:,3),[minj:1:maxj]);
fx=nx/sum(nx);
a=bar([minj:1:maxj],100*fx);
set(a,'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
grid
span7=5*ceil(20*nanmax(fx));
axis([minj maxj 0 span7]);
ylabel(['Percentage [%]'])
text(minj+0.05*(maxj-minj),0.9*span7,sprintf('%s Air Relative Humidity',s2name))
subplot(4,2,6)
nx=hist(s1(:,4),[minj:1:maxj]);
fx=nx/sum(nx);
a=bar([minj:1:maxj],100*fx);
set(a,'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
grid
axis([minj maxj 0 span5]);
ylabel(['Percentage [%]'])
text(minj+0.05*(maxj-minj),0.9*span5,sprintf('%s Surface Relative Humidity',s1name))
subplot(4,2,8)
nx=hist(s2(:,4),[minj:1:maxj]);
fx=nx/sum(nx);
a=bar([minj:1:maxj],100*fx);
set(a,'FaceColor',[0 0 1],'EdgeColor',[0 0 1])
grid
axis([minj maxj 0 span7]);
ylabel(['Percentage [%]'])
text(minj+0.05*maxj,0.9*span7,sprintf('%s Surface Relative Humidity',s2name))
t6=text(minj-(maxj-minj)/4,-span7/5,dates);         % places dates-text at the right position
set(t6,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
orient landscape
fig=sprintf('%scomhist',figname);            % creates unique name for this figure
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..