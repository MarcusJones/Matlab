function y=mollierdensity2(time,temp,rh,name,savename,demand,varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copyright Jos van Schijndel and Marco Martens, Technische Universiteit Eindhoven, The Netherlands
% june 16, 2005
% time: timevector (column) or [starttime timestep] in days after Christ and seconds
% temp: temperature vector (column) [ºC]
% rh:   relative humidity vector (column) [%RV]
% name: title to put above graph
% savename: file will be saved to disk under this name
% demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%             'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%             or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
% varargin: if there's an extra input which has value 1, the histograms won't be plotted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(varargin)>=1
    if varargin{1}==1
    histo=0;
end
else histo=1;
end
%%%%%%%%% demands
if length(demand)==8
if demand=='thomson1';                                % indoor climate according to Thomson class 1
demands([1:8])=[19 24 1 1 50 55 5 5];
dem=(['Indoor climate compared to Thomson class 1']);
demleg=(['Thomson class 1';'min T  =  19 ºC';'max T  =  24 ºC';'DeltaTh =  1 ºC';'DeltaT24 = 1 ºC';'min RH  =  50 %';'max RH  =  55 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
elseif demand=='thomson2';                            % indoor climate according to Thomson class 2
demands([1:8])=[-20 60 NaN NaN 40 70 NaN NaN];
dem=(['Indoor climate compared to Thomson class 2']);
demleg=(['Thomson class 2';'min RH  =  40 %';'max RH  =  70 %']);
else demands=demand;
dem=(['Indoor climate compared to demand']);
demleg=(['Demand         ';'min T  =     ºC';'max T  =     ºC';'DeltaTh =    ºC';'DeltaT24 =   ºC';'min RH  =     %';'max RH  =     %';'DeltaRHh =    %';'DeltaRH24 =   %']);
demleg(2,13-length(sprintf('%d',demand(1))):12)=sprintf('%d',demand(1));
demleg(3,13-length(sprintf('%d',demand(2))):12)=sprintf('%d',demand(2));
demleg(4,13-length(sprintf('%d',demand(3))):12)=sprintf('%d',demand(3));
demleg(5,13-length(sprintf('%d',demand(4))):12)=sprintf('%d',demand(4));
demleg(6,14-length(sprintf('%d',demand(5))):13)=sprintf('%d',demand(5));
demleg(7,14-length(sprintf('%d',demand(6))):13)=sprintf('%d',demand(6));
demleg(8,14-length(sprintf('%d',demand(7))):13)=sprintf('%d',demand(7));
demleg(9,14-length(sprintf('%d',demand(8))):13)=sprintf('%d',demand(8));
end
elseif length(demand)==7
if demand=='comfort';                                 % indoor climate according to CCI Lafontaine
demands([1:8])=[20 26 NaN NaN 30 70 NaN NaN];
dem=(['Indoor climate compared to comfort standards']);
demleg=(['Comfort        ';'min T  =  20 ºC';'max T  =  26 ºC';'min RH  =  30 %';'max RH  =  70 %']);
elseif demand=='ashraea';                             % indoor climate according to ASHRAE A
demands([1:8])=[15 25 2 2 45 55 5 5];
dem=(['Indoor climate compared to ASHRAE A']);
demleg=(['ASHRAE A       ';'min T  =  15 ºC';'max T  =  25 ºC';'DeltaTh =  2 ºC';'DeltaT24 = 2 ºC';'min RH  =  45 %';'max RH  =  55 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
elseif demand=='ashraeb';                             % indoor climate according to ASHRAE B
demands([1:8])=[15 25 5 5 40 60 10 10];
dem=(['Indoor climate compared to ASHRAE B']);
demleg=(['ASHRAE B       ';'min T  =  15 ºC';'max T  =  25 ºC';'DeltaTh =  5 ºC';'DeltaT24 = 5 ºC';'min RH  =  40 %';'max RH  =  60 %';'DeltaRHh = 10 %';'DeltaRH24 = 10%']);
elseif demand=='ashraec';                             % indoor climate according to ASHRAE C
demands([1:8])=[15 25 NaN NaN 25 75 NaN NaN];
dem=(['Indoor climate compared to ASHRAE C']);
demleg=(['ASHRAE C       ';'min T  =  15 ºC';'max T  =  25 ºC';'min RH  =  25 %';'max RH  =  75 %']);
elseif demand=='ashraed';                             % indoor climate according to ASHRAE D
demands([1:8])=[15 25 NaN NaN 0 75 NaN NaN];
dem=(['Indoor climate compared to ASHRAE D']);
demleg=(['ASHRAE D       ';'min T  =  15 ºC';'max T  =  25 ºC';'min RH  =   0 %';'max RH  =  75 %']);
else disp('unknown demand')
end
elseif length(demand)==5
if demand=='jutte';                                   % indoor climate according to Ton Jütte
demands([1:8])=[2 25 3 3 48 55 2 3];
dem=(['Indoor climate compared to Ton Jütte']);
demleg=(['Ton Jütte      ';'min T  =  02 ºC';'max T  =  25 ºC';'DeltaTh =  3 ºC';'DeltaT24 = 3 ºC';'min RH  =  48 %';'max RH  =  55 %';'DeltaRHh =  2 %';'DeltaRH24 = 3 %']);
else disp('unknown demand')
end
elseif length(demand)==3
if demand=='rgd';                                     % indoor climate according to RGD Deltaplan
demands([1:8])=[18 20 2 2 50 60 5 5];
dem=(['Indoor climate compared to RGD Deltaplan']);
demleg=(['RGD Deltaplan  ';'min T  =  18 ºC';'max T  =  20 ºC';'DeltaTh =  2 ºC';'DeltaT24 = 2 ºC';'min RH  =  50 %';'max RH  =  60 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
elseif demand=='cci';                                 % indoor climate according to CCI Lafontaine
demands([1:8])=[20 25 1.5 1.5 35 58 3 3];
dem=(['Indoor climate compared to CCI Lafontaine']);
demleg=(['Lafontaine CCI ';'min T  =  20 ºC';'max T  =  25 ºC';'DeltaTh= 1,5 ºC';'DeltaTd= 1,5 ºC';'min RH  =  35 %';'max RH  =  58 %';'DeltaRHh =  3 %';'DeltaRH24 = 3 %']);
else disp('unknown demand')
end
elseif length(demand)==11
if demand=='mecklenburg';                             % indoor climate according to Marion Mecklenburg
demands([1:8])=[20 23 5 5 35 60 5 5];
dem=(['Indoor climate compared to Marion Mecklenburg']);
demleg=(['Mecklenburg, M.';'min T  =  20 ºC';'max T  =  23 ºC';'DeltaTh =  5 ºC';'DeltaT24 = 5 ºC';'min RH  =  35 %';'max RH  =  60 %';'DeltaRHh =  5 %';'DeltaRH24 = 5 %']);
else disp('unknown demand')
end
else disp('unknown demand')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sizetime=size(time);
if sizetime(1)==1 & sizetime(2)==2
   for i=1:length(temp)
       tin(i,1)=time(1)+datenum(0,0,0,0,0,(i-1)*time(2));
   end
else tin=time;
end
psat=611*exp(17.08*temp(:)./(234.18+temp(:)));        % maximum vapour pressure at given air temperature [Pa]
f=find(temp<0);
psat(f)=611*exp(22.44*temp(f)./(272.44+temp(f)));
pact=0.01*psat(:).*rh(:);                             % actual vapour pressure [Pa]
xin=611*pact(:)./(101300-pact(:));                    % specific humidity [g/kg]
%%% DEFINE COLORMAP
map2=zeros(100,3);
map2(1,[1:3])=[0 0.66 1];                             % histogramcolor
for i=[1:22]
map2(i+1,[1:3])=1/255*[173-162*(i-1)/21 227-111*(i-1)/21 250-89*(i-1)/21];     % defines new colormap winter (lightblue to darkblue)
map2(i+23,[1:3])=1/255*[255-94*(i-1)/21 197-106*(i-1)/21 120-120*(i-1)/21];    % defines new colormap autumn (lightbrown to darkbrown)
map2(i+45,[1:3])=1/255*[156-140*(i-1)/21 247-125*(i-1)/21 148-142*(i-1)/21];   % defines new colormap spring (lightgreen to darkgreen)
map2(i+67,[1:3])=1/255*[255-8*(i-1)/21 190-175*(i-1)/21 200-185*(i-1)/21];     % defines new colormap summer (orange to red)
end
map2(90,[1:3])=[0 0.66 1];                            % left
map2(91,[1:3])=[0 1 1];                               % color 10% RH
map2(92,[1:3])=[0 1 0.66];                            % color 20% RH
map2(93,[1:3])=[0 1 0.33];                            % color 30% RH
map2(94,[1:3])=[0 1 0];                               % color 40% RH
map2(95,[1:3])=[0.33 1 0];                            % color 50% RH
map2(96,[1:3])=[0.66 1 0];                            % color 60% RH
map2(97,[1:3])=[1 1 0];                               % color 70% RH
map2(98,[1:3])=[1 0.66 0];                            % color 80% RH
map2(99,[1:3])=[1 0.33 0];                            % color 90% RH
map2(100,[1:3])=[1 0 0];                              % color 100% RH
%%% DEFINE WHICH SURFACE
global astat seasons sstat months mstat weeks wstat days dstat
hulp(:,1)=temp;
hulp(:,2)=NaN;
hulp(:,3)=rh;
hulp(:,4)=NaN;
hulp(:,5)=NaN;
hulp(:,6)=NaN;
hulp(:,7)=NaN;
hulp(:,8)=xin;
hulp(:,9)=NaN;
hulp(:,10)=tin;
statistics(hulp,0,1,0,1,0)                          % statistics
sdate=datevec(tin(1));                                                      % finds first date/time point
starttime=datenum(sdate(1),sdate(2),sdate(3),0,0,0);                        % calculates starttime
edate=datevec(tin(length(tin)));                                            % finds last date/time point
endtime=datenum(edate(1),edate(2),edate(3)+1,0,0,0);                        % calculates endtime
daypoints=max(find(tin(:)<=datenum(sdate(1),sdate(2),sdate(3)+1,sdate(4),sdate(5),sdate(6))))-1;
hourpoints=round(daypoints/24);                                             % calculates number of points a day/hour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting current demand into T, p and x-information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Teis([1:(demands(2)-demands(1))*2+3])=[[demands(1):1:demands(2)] [demands(2):-1:demands(1)] demands(1)];
d3=length(Teis)-1;                                                          % calculates T and x for the given demand
for d=[1:(d3/2)]
peis([d])=6.11*exp(17.08*Teis(d)./(234.18+Teis(d)))*demands(5);
peis([d3/2+d])=6.11*exp(17.08*Teis(d3/2+d)./(234.18+Teis(d3/2+d)))*demands(6);
end
peis(d3+1)=peis(1);
for d2=[1:(length(Teis))]
xeis(d2)=611*peis(d2)./(101300-peis(d2));
end 
heis(1:length(Teis))=90.1;
Thelp(1:33)=(-1:1:31);
hhelp(1:33)=90;
for i=1:33
pmineis(i)=6.11*exp(17.08*Thelp(i)./(234.18+Thelp(i)))*demands(5);
pmaxeis(i)=6.11*exp(17.08*Thelp(i)./(234.18+Thelp(i)))*demands(6);
xmineis(i)=611*pmineis(i)./(101300-pmineis(i));
xmaxeis(i)=611*pmaxeis(i)./(101300-pmaxeis(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots Mollierdiagram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=[1:11]                                          % sets temperature matrix, 1 cell = 1 degree
    for h=[1:81]                                      % -20 up to 60 degrees Celsius
    Tmol(h,j)=(h-21);
    end
end
for i=[1:81];
RHmol(i,[1:11])=[0:0.1:1];                            % sets humidity matrix, in steps of 10%
end
for k=[1:11]                                          % calculates p for each temperature and humidity
    for l=[1:20]
    pmol(l,k)=611*exp(22.44*Tmol(l,1)./(272.44+Tmol(l,1)))*RHmol(l,k);
    end
    for l=[21:81]
    pmol(l,k)=611*exp(17.08*Tmol(l,1)./(234.18+Tmol(l,1)))*RHmol(l,k);
    end
    for m=[1:81]
    xmol(m,k)=611*pmol(m,k)./(101300-pmol(m,k));      % calculates moisture content for each p
    end
end
for i=[1:81];
RHmol(i,[1:11])=[90:1:100];                           % overrules humidity matrix, in steps of 10% of RHmax
end
adeltah1=0.01;
adeltah2=0.01;
adeltad1=0.01;
adeltad2=0.01;
sdeltah1=0.01;
sdeltah2=0.01;
sdeltad1=0.01;
sdeltad2=0.01;
wdeltah1=0.01;
wdeltah2=0.01;
wdeltad1=0.01;
wdeltad2=0.01;
pdeltah1=0.01;
pdeltah2=0.01;
pdeltad1=0.01;
pdeltad2=0.01;
figure                                                % opens new plot window
if histo==0
    subplot(1,1,1)
else
    subplot(4,5,[1 2 3 4 6 7 8 9 11 12 13 14 16 17 18 19])% devides plotwindow in parts
end
contour(xmol,Tmol,RHmol,RHmol(1,:));                  % plots isoRHlines in plot
axis([0 25 -1 31]);                                   % sets axis xmin, xmax, Tmin, Tmax
NewPosition=[0 0 'PaperSize'];                        % sets paper margins to zero
orient landscape                                      % stretches figure to A4-size
hold on                                               % freezes figure (so other plots can be put in without deleting previous plots)
t1=title(name);                                       % sets title
set(t1,'FontSize',20);                                % sets fontsize of title
xlabel(['Specific Humidity [g/kg]'])                  % sets x-label
ylabel('Dry Bulb Temperature [ºC]')                   % sets y-label
text(xmol(48,2),27,'10%')                             % creates text label for each isoRHline
text(xmol(48,3),27,'20%')
text(xmol(48,4),27,'30%')
text(xmol(48,5),27,'40%')
text(xmol(48,6),27,'50%')
text(xmol(48,7),27,'60%')
text(xmol(48,8),27,'70%')
text(xmol(48,9),27,'80%')
text(xmol(48,10),27,'90%')
text(xmol(48,11),27,'100%')
text(20.75,24,'Total Distribution','Color',1/255*[0 0 0])
line([21.75 21.75],[20.5 23.5],[0 0],'Color',1/255*[150 150 150])
line([23.25 23.25],[20.5 23.5],[0 0],'Color',1/255*[150 150 150])
line([20.75 24.25],[21.5 21.5],[0 0],'Color',1/255*[150 150 150])
line([20.75 24.25],[22.5 22.5],[0 0],'Color',1/255*[150 150 150])
text(22.5,22,sprintf('%d %%',round(100*length(find(temp(:)>=demands(1) & temp(:)<=demands(2) & rh(:)>=demands(5) & rh(:)<=demands(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
text(24,23,sprintf('%d %%',round(100*length(find(temp(:)>demands(2) & rh(:)>demands(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,23,sprintf('%d %%',round(100*length(find(temp(:)>demands(2) & rh(:)>=demands(5) & rh(:)<=demands(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,23,sprintf('%d %%',round(100*length(find(temp(:)>demands(2) & rh(:)<demands(5)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,22,sprintf('%d %%',round(100*length(find(temp(:)>=demands(1) & temp(:)<=demands(2) & rh(:)<demands(5)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,21,sprintf('%d %%',round(100*length(find(temp(:)<demands(1) & rh(:)<demands(5)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,21,sprintf('%d %%',round(100*length(find(temp(:)<demands(1) & rh(:)>=demands(5) & rh(:)<=demands(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,21,sprintf('%d %%',round(100*length(find(temp(:)<demands(1) & rh(:)>demands(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,22,sprintf('%d %%',round(100*length(find(temp(:)>=demands(1) & temp(:)<=demands(2) & rh(:)>demands(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle');
%%%autumn
xautumn=seasons(:,8,4);
tautumn=seasons(:,1,4);
rautumn=seasons(:,3,4);
if length(find(tautumn>=0))>=1
aminT=floor(min(tautumn));                            % finds minimum T
amaxT=ceil(max(tautumn));                             % finds maximum T
aminX=floor(min(xautumn));                            % finds minimum x
amaxX=ceil(max(xautumn));                             % finds maximum x
aYX=[tautumn xautumn];
aY=aminT:0.2:amaxT;
aX=aminX:0.2:amaxX;
aY2=aY(1:(length(aY)-1))+0.1;
aX2=aX(1:(length(aX)-1))+0.1;
aresult=hist2d(aYX,aY,aX);
[axjes, atemp] = meshgrid(aX2, aY2);
apercresult=100*aresult/sum(sum(aresult));            % percentage of total points is calculated
apercresult(find(apercresult==0))=NaN;                % 0-values are replaced by NaN's
aRHmax=max(max(apercresult));                         % finds maximum percentage (to set colors)
autumn=25+(22/aRHmax)*apercresult;
text(22.5,4,'Autumn Distribution','Color',1/255*[110 60 6],'HorizontalAlignment','center')
line([21.75 21.75],[0.5 3.5],'Color',1/255*[255 197 120])
line([23.25 23.25],[0.5 3.5],'Color',1/255*[255 197 120])
line([20.75 24.25],[1.5 1.5],'Color',1/255*[255 197 120])
line([20.75 24.25],[2.5 2.5],'Color',1/255*[255 197 120])
text(22.5,2,sprintf('%d %%',round(100*length(find(tautumn(:)>=demands(1) & tautumn(:)<=demands(2) & rautumn(:)>=demands(5) & rautumn(:)<=demands(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
text(24,3,sprintf('%d %%',round(100*length(find(tautumn(:)>demands(2) & rautumn(:)>demands(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,3,sprintf('%d %%',round(100*length(find(tautumn(:)>demands(2) & rautumn(:)>=demands(5) & rautumn(:)<=demands(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,3,sprintf('%d %%',round(100*length(find(tautumn(:)>demands(2) & rautumn(:)<demands(5)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,2,sprintf('%d %%',round(100*length(find(tautumn(:)>=demands(1) & tautumn(:)<=demands(2) & rautumn(:)<demands(5)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,1,sprintf('%d %%',round(100*length(find(tautumn(:)<demands(1) & rautumn(:)<demands(5)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,1,sprintf('%d %%',round(100*length(find(tautumn(:)<demands(1) & rautumn(:)>=demands(5) & rautumn(:)<=demands(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,1,sprintf('%d %%',round(100*length(find(tautumn(:)<demands(1) & rautumn(:)>demands(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,2,sprintf('%d %%',round(100*length(find(tautumn(:)>=demands(1) & tautumn(:)<=demands(2) & rautumn(:)>demands(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle');
surf(axjes,atemp,autumn,'EdgeColor',1/255*[255 197 120]); % plots little surfaces for each T and x
w10([1:13])=wstat(3,8,[39:51]);
w11([1:13])=wstat(3,1,[39:51]);
w12([1:13])=[90 90 90 90 90 90 90 90 90 90 90 90 90];
plot3(w10,w11,w12,'+','color',1/255*[110 60 6],'LineWidth',[1.5]) % plots weekly autumn average purple
for i=[hourpoints+1:(length(tautumn))]                    % calculates hourly difference between min and max
adeltah1(i)=range([tautumn([i-hourpoints:i])]);
adeltah2(i)=range([rautumn([i-hourpoints:i])]);
end
for i=[daypoints+1:(length(tautumn))]                     % calculates daily difference between min and max
adeltad1(i)=range([tautumn([i-daypoints:i])]);
adeltad2(i)=range([rautumn([i-daypoints:i])]);
end
for i=[1:hourpoints]                                  % adds 3 NaN-values to make sure the lengths are the same
adeltah1(i)=NaN;                                       % hourly difference air temperature (including line 30)
adeltah2(i)=NaN;                                       % hourly difference air temperature (including line 30)
end
for i=[1:daypoints]
adeltad1(i)=NaN;
adeltad2(i)=NaN;
end
end
%%%summer
xsummer=seasons(:,8,3);
tsummer=seasons(:,1,3);
rsummer=seasons(:,3,3);
if length(find(tsummer>=0))>=1
sminT=floor(min(tsummer));                            % finds minimum T
smaxT=ceil(max(tsummer));                             % finds maximum T
sminX=floor(min(xsummer));                            % finds minimum x
smaxX=ceil(max(xsummer));                             % finds maximum x
sYX=[tsummer xsummer];
sY=sminT:0.2:smaxT;
sX=sminX:0.2:smaxX;
sY2=sY(1:(length(sY)-1))+0.1;
sX2=sX(1:(length(sX)-1))+0.1;
sresult=hist2d(sYX,sY,sX);
[sxjes, stemp] = meshgrid(sX2, sY2);
spercresult=100*sresult/sum(sum(sresult));            % percentage of total points is calculated
spercresult(find(spercresult==0))=NaN;                % 0-values are replaced by NaN's
sRHmax=max(max(spercresult));                         % finds maximum percentage (to set colors)
summer=68+(22/sRHmax)*spercresult;
text(22.5,9,'Summer Distribution','Color',1/255*[201 8 8],'HorizontalAlignment','center')
line([21.75 21.75],[5.5 8.5],'Color',1/255*[255 190 200])
line([23.25 23.25],[5.5 8.5],'Color',1/255*[255 190 200])
line([20.75 24.25],[6.5 6.5],'Color',1/255*[255 190 200])
line([20.75 24.25],[7.5 7.5],'Color',1/255*[255 190 200])
text(22.5,7,sprintf('%d %%',round(100*length(find(tsummer(:)>=demands(1) & tsummer(:)<=demands(2) & rsummer(:)>=demands(5) & rsummer(:)<=demands(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
text(24,8,sprintf('%d %%',round(100*length(find(tsummer(:)>demands(2) & rsummer(:)>demands(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,8,sprintf('%d %%',round(100*length(find(tsummer(:)>demands(2) & rsummer(:)>=demands(5) & rsummer(:)<=demands(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,8,sprintf('%d %%',round(100*length(find(tsummer(:)>demands(2) & rsummer(:)<demands(5)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,7,sprintf('%d %%',round(100*length(find(tsummer(:)>=demands(1) & tsummer(:)<=demands(2) & rsummer(:)<demands(5)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,6,sprintf('%d %%',round(100*length(find(tsummer(:)<demands(1) & rsummer(:)<demands(5)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,6,sprintf('%d %%',round(100*length(find(tsummer(:)<demands(1) & rsummer(:)>=demands(5) & rsummer(:)<=demands(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,6,sprintf('%d %%',round(100*length(find(tsummer(:)<demands(1) & rsummer(:)>demands(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,7,sprintf('%d %%',round(100*length(find(tsummer(:)>=demands(1) & tsummer(:)<=demands(2) & rsummer(:)>demands(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle');
surf(sxjes,stemp,summer,'EdgeColor',1/255*[255 190 200]); % plots little surfaces for each T and x
w7([1:13])=wstat(3,8,[26:38]);
w8([1:13])=wstat(3,1,[26:38]);
w9([1:13])=[90 90 90 90 90 90 90 90 90 90 90 90 90];
plot3(w7,w8,w9,'>','color',1/255*[201 8 8],'LineWidth',[1.5])     % plots weekly summer average red
for i=[hourpoints+1:(length(tsummer))]                    % calculates hourly difference between min and max
sdeltah1(i)=range([tsummer([i-hourpoints:i])]);
sdeltah2(i)=range([rsummer([i-hourpoints:i])]);
end
for i=[daypoints+1:(length(tautumn))]                     % calculates daily difference between min and max
sdeltad1(i)=range([tsummer([i-daypoints:i])]);
sdeltad2(i)=range([rsummer([i-daypoints:i])]);
end
for i=[1:hourpoints]                                  % adds 3 NaN-values to make sure the lengths are the same
sdeltah1(i)=NaN;                                       % hourly difference air temperature (including line 30)
sdeltah2(i)=NaN;                                       % hourly difference air temperature (including line 30)
end
for i=[1:daypoints]
sdeltad1(i)=NaN;
sdeltad2(i)=NaN;
end
end
%%%spring
xspring=seasons(:,8,2);
tspring=seasons(:,1,2);
rspring=seasons(:,3,2);
if length(find(tspring>=0))>=1
pminT=floor(min(tspring));                            % finds minimum T
pmaxT=ceil(max(tspring));                             % finds maximum T
pminX=floor(min(xspring));                            % finds minimum x
pmaxX=ceil(max(xspring));                             % finds maximum x
pYX=[tspring xspring];
pY=pminT:0.2:pmaxT;
pX=pminX:0.2:pmaxX;
pY2=pY(1:(length(pY)-1))+0.1;
pX2=pX(1:(length(pX)-1))+0.1;
presult=hist2d(pYX,pY,pX);
[pxjes, ptemp] = meshgrid(pX2, pY2);
ppercresult=100*presult/sum(sum(presult));            % percentage of total points is calculated
ppercresult(find(ppercresult==0))=NaN;                % 0-values are replaced by NaN's
pRHmax=max(max(ppercresult));                         % finds maximum percentage (to set colors)
spring=46+(22/pRHmax)*ppercresult;
text(22.5,14,'Spring Distribution','Color',1/255*[11 77 5],'HorizontalAlignment','center')
line([21.75 21.75],[10.5 13.5],'Color',1/255*[156 247 148])
line([23.25 23.25],[10.5 13.5],'Color',1/255*[156 247 148])
line([20.75 24.25],[11.5 11.5],'Color',1/255*[156 247 148])
line([20.75 24.25],[12.5 12.5],'Color',1/255*[156 247 148])
text(22.5,12,sprintf('%d %%',round(100*length(find(tspring(:)>=demands(1) & tspring(:)<=demands(2) & rspring(:)>=demands(5) & rspring(:)<=demands(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
text(24,13,sprintf('%d %%',round(100*length(find(tspring(:)>demands(2) & rspring(:)>demands(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,13,sprintf('%d %%',round(100*length(find(tspring(:)>demands(2) & rspring(:)>=demands(5) & rspring(:)<=demands(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,13,sprintf('%d %%',round(100*length(find(tspring(:)>demands(2) & rspring(:)<demands(5)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,12,sprintf('%d %%',round(100*length(find(tspring(:)>=demands(1) & tspring(:)<=demands(2) & rspring(:)<demands(5)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,11,sprintf('%d %%',round(100*length(find(tspring(:)<demands(1) & rspring(:)<demands(5)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,11,sprintf('%d %%',round(100*length(find(tspring(:)<demands(1) & rspring(:)>=demands(5) & rspring(:)<=demands(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,11,sprintf('%d %%',round(100*length(find(tspring(:)<demands(1) & rspring(:)>demands(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,12,sprintf('%d %%',round(100*length(find(tspring(:)>=demands(1) & tspring(:)<=demands(2) & rspring(:)>demands(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle');
surf(pxjes,ptemp,spring,'EdgeColor',1/255*[156 247 148]); % plots little surfaces for each T and x
w4([1:13])=wstat(3,8,[13:25]);
w5([1:13])=wstat(3,1,[13:25]);
w6([1:13])=[90 90 90 90 90 90 90 90 90 90 90 90 90];
plot3(w4,w5,w6,'*','color',1/255*[11 77 5],'LineWidth',[1.5])     % plots weekly spring average orange
for i=[hourpoints+1:(length(tspring))]                    % calculates hourly difference between min and max
pdeltah1(i)=range([tspring([i-hourpoints:i])]);
pdeltah2(i)=range([rspring([i-hourpoints:i])]);
end
for i=[daypoints+1:(length(tspring))]                     % calculates daily difference between min and max
pdeltad1(i)=range([tspring([i-daypoints:i])]);
pdeltad2(i)=range([rspring([i-daypoints:i])]);
end
for i=[1:hourpoints]                                  % adds 3 NaN-values to make sure the lengths are the same
pdeltah1(i)=NaN;                                       % hourly difference air temperature (including line 30)
pdeltah2(i)=NaN;                                       % hourly difference air temperature (including line 30)
end
for i=[1:daypoints]
pdeltad1(i)=NaN;
pdeltad2(i)=NaN;
end
end
%%%winter
xwinter=seasons(:,8,1);
twinter=seasons(:,1,1);
rwinter=seasons(:,3,1);
if length(find(twinter>=0))>=1
wminT=floor(min(twinter));                            % finds minimum T
wmaxT=ceil(max(twinter));                             % finds maximum T
wminX=floor(min(xwinter));                            % finds minimum x
wmaxX=ceil(max(xwinter));                             % finds maximum x
wYX=[twinter xwinter];
wY=wminT:0.2:wmaxT;
wX=wminX:0.2:wmaxX;
wY2=wY(1:(length(wY)-1))+0.1;
wX2=wX(1:(length(wX)-1))+0.1;
wresult=hist2d(wYX,wY,wX);
[wxjes, wtemp] = meshgrid(wX2, wY2);
wpercresult=100*wresult/sum(sum(wresult));            % percentage of total points is calculated
wpercresult(find(wpercresult==0))=NaN;                % 0-values are replaced by NaN's
wRHmax=max(max(wpercresult));                         % finds maximum percentage (to set colors)
winter=2+(22/wRHmax)*wpercresult;
text(22.5,19,'Winter Distribution','Color',1/255*[3 51 148],'HorizontalAlignment','center')
line([21.75 21.75],[15.5 18.5],'Color',1/255*[173 227 250])
line([23.25 23.25],[15.5 18.5],'Color',1/255*[173 227 250])
line([20.75 24.25],[16.5 16.5],'Color',1/255*[173 227 250])
line([20.75 24.25],[17.5 17.5],'Color',1/255*[173 227 250])
text(22.5,17,sprintf('%d %%',round(100*length(find(twinter(:)>=demands(1) & twinter(:)<=demands(2) & rwinter(:)>=demands(5) & rwinter(:)<=demands(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
text(24,18,sprintf('%d %%',round(100*length(find(twinter(:)>demands(2) & rwinter(:)>demands(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,18,sprintf('%d %%',round(100*length(find(twinter(:)>demands(2) & rwinter(:)>=demands(5) & rwinter(:)<=demands(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,18,sprintf('%d %%',round(100*length(find(twinter(:)>demands(2) & rwinter(:)<demands(5)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,17,sprintf('%d %%',round(100*length(find(twinter(:)>=demands(1) & twinter(:)<=demands(2) & rwinter(:)<demands(5)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(21,16,sprintf('%d %%',round(100*length(find(twinter(:)<demands(1) & rwinter(:)<demands(5)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5,16,sprintf('%d %%',round(100*length(find(twinter(:)<demands(1) & rwinter(:)>=demands(5) & rwinter(:)<=demands(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,16,sprintf('%d %%',round(100*length(find(twinter(:)<demands(1) & rwinter(:)>demands(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24,17,sprintf('%d %%',round(100*length(find(twinter(:)>=demands(1) & twinter(:)<=demands(2) & rwinter(:)>demands(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
surf(wxjes,wtemp,winter,'EdgeColor',1/255*[173 227 250]); % plots little surfaces for each T and x
w1([1:14])=wstat(3,8,[52 53 1:12]);
w2([1:14])=wstat(3,1,[52 53 1:12]);
w3([1:14])=[90 90 90 90 90 90 90 90 90 90 90 90 90 90];
plot3(w1,w2,w3,'o','color',1/255*[3 51 148],'LineWidth',[1.5])    % plots weekly winter average blue 
for i=[hourpoints+1:(length(twinter))]                    % calculates hourly difference between min and max
wdeltah1(i)=range([twinter([i-hourpoints:i])]);
wdeltah2(i)=range([rwinter([i-hourpoints:i])]);
end
for i=[daypoints+1:(length(tautumn))]                     % calculates daily difference between min and max
wdeltad1(i)=range([twinter([i-daypoints:i])]);
wdeltad2(i)=range([rwinter([i-daypoints:i])]);
end
for i=[1:hourpoints]                                  % adds 3 NaN-values to make sure the lengths are the same
wdeltah1(i)=NaN;                                       % hourly difference air temperature (including line 30)
wdeltah2(i)=NaN;                                       % hourly difference air temperature (including line 30)
end
for i=[1:daypoints]
wdeltad1(i)=NaN;
wdeltad2(i)=NaN;
end
end
%%%ALL SEASONS
grid;                   
tekst=text(7.5,0,demleg,'VerticalAlignment','bottom');
view(2)
colormap(map2)                                        % applies new colormap
plot3(xeis,Teis,heis,'-','color',[.4 .4 1],'LineWidth',[1.5]) % plots demands into mollierdiagram
plot3(xmineis,Thelp,hhelp,'-','color',[.4 .4 1])
plot3(xmaxeis,Thelp,hhelp,'-','color',[.4 .4 1])
line([0 xmol(demands(1)+21,11)],[demands(1) demands(1)],[90 90],'color',[.4 .4 1])
line([0 xmol(demands(2)+21,11)],[demands(2) demands(2)],[90 90],'color',[.4 .4 1])
for i=1:20
wa(1,i)=12.5;
wa(2,i)=13.5;
wb(1,i)=0+(i-1)/19;
wb(2,i)=0+(i-1)/19;
wc(1,i)=i+25;
wc(2,i)=i+25;
pb(1,i)=1.1+(i-1)/19;
pb(2,i)=1.1+(i-1)/19;
pc(1,i)=i+68;
pc(2,i)=i+68;
sb(1,i)=2.2+(i-1)/19;
sb(2,i)=2.2+(i-1)/19;
sc(1,i)=i+47;
sc(2,i)=i+47;
ab(1,i)=3.3+(i-1)/19;
ab(2,i)=3.3+(i-1)/19;
ac(1,i)=i+3;
ac(2,i)=i+3;
end
surf(wa,wb,wc,'LineStyle','None')                     % legend color winter
plot3(13,8.2,90,'o','color',1/255*[3 51 148],'LineWidth',[1.5])
text(14,3.8,'winter values')
text(14,8.2,'winter weekly average')
surf(wa,pb,pc,'LineStyle','None')                     % legend color spring
plot3(13,7.1,90,'*','color',1/255*[11 77 5],'LineWidth',[1.5])
text(14,2.7,'spring values')
text(14,7.1,'spring weekly average')
surf(wa,sb,sc,'LineStyle','None')                     % legend color summer
plot3(13,6,90,'>','color',1/255*[201 8 8],'LineWidth',[1.5])
text(14,1.6,'summer values')
text(14,6,'summer weekly average')
surf(wa,ab,ac,'LineStyle','None')                     % legend color autumn
plot3(13,4.9,90,'+','color',1/255*[110 60 6],'LineWidth',[1.5])
text(14,0.5,'autumn values')
text(14,4.9,'autumn weekly average')
t6=text(12.5,-3.5,sprintf('%s, %s to %s',dem,datestr(floor(starttime)),datestr(ceil(endtime))));
set(t6,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center');

if histo==1
subplot(4,5,5)                                        % new subplot
wh1=hist(wdeltah1,[0:0.5:10]);
ph1=hist(pdeltah1,[0:0.5:10]);
sh1=hist(sdeltah1,[0:0.5:10]);
ah1=hist(adeltah1,[0:0.5:10]);
wz1=wh1/sum(wh1);
pz1=ph1/sum(ph1);
sz1=sh1/sum(sh1);
az1=ah1/sum(ah1);
for i=1:21
    span(i)=[wz1(i)+pz1(i)+az1(i)+sz1(i)];
end
bar([0:0.5:10],25*[wz1;az1;pz1;sz1]','stacked')
grid
span=5*ceil(5*(max(span)));
axis([0 10 0 span]);                                  % sets axis
if demands(3)>=0
tover=100*(length(find(wdeltah1>demands(3)))+length(find(pdeltah1>demands(3)))+length(find(sdeltah1>demands(3)))+length(find(adeltah1>demands(3))))/(length(find(wdeltah1>=-1))+length(find(pdeltah1>=-1))+length(find(sdeltah1>=-1))+length(find(adeltah1>=-1))); % counts percentage out of limits
text(11,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0])              % creates text containing this percentage
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltah1>demands(3)))/length(find(wdeltah1>=-1)); % counts percentage out of limits
text(11,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148])              % creates text containing this percentage
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltah1>demands(3)))/length(find(pdeltah1>=-1)); % counts percentage out of limits
text(11,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5])             % creates text containing this percentage
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltah1>demands(3)))/length(find(sdeltah1>=-1)); % counts percentage out of limits
text(11,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8])             % creates text containing this percentage
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltah1>demands(3)))/length(find(adeltah1>=-1)); % counts percentage out of limits
text(11,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6])             % creates text containing this percentage
end
text(11,span*0.85,'out of limits:')                    % text
text(11,span,'Percentage')                       % text
line1=line([demands(3);demands(3)],[0;100]);          % plots vertical line at demand
set(line1,'Color',[.4 .4 1],'LineWidth',1.5);         % sets parameters for this line
end
title(['Delta T hour'])                               % title
ylabel(['Percentage [%]'])                            % y-label

subplot(4,5,10)
wh2=hist(wdeltah2,[0:1:20]);
ph2=hist(pdeltah2,[0:1:20]);
sh2=hist(sdeltah2,[0:1:20]);
ah2=hist(adeltah2,[0:1:20]);
wz2=wh2/sum(wh2);
pz2=ph2/sum(ph2);
sz2=sh2/sum(sh2);
az2=ah2/sum(ah2);
for i=1:21
    span(i)=[wz2(i)+pz2(i)+az2(i)+sz2(i)];
end
bar([0:1:20],25*[wz2;az2;pz2;sz2]','stacked')
grid
span=5*ceil(5*(max(span)));
axis([0 20 0 span]);
if demands(7)>=0
tover=100*(length(find(wdeltah2>demands(7)))+length(find(pdeltah2>demands(7)))+length(find(sdeltah2>demands(7)))+length(find(adeltah2>demands(7))))/(length(find(wdeltah2>=-1))+length(find(pdeltah2>=-1))+length(find(sdeltah2>=-1))+length(find(adeltah2>=-1))); % counts percentage out of limits
text(22,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0])
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltah2>demands(7)))/length(find(wdeltah2>=-1));
text(22,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148])
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltah2>demands(7)))/length(find(pdeltah2>=-1));
text(22,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5])
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltah2>demands(7)))/length(find(sdeltah2>=-1));
text(22,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8])
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltah2>demands(7)))/length(find(adeltah2>=-1));
text(22,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6])
end
text(22,span*0.85,'out of limits:')
text(22,span,'Percentage')
line1=line([demands(7);demands(7)],[0;100]);
set(line1,'Color',[.4 .4 1],'LineWidth',2);
end
title(['Delta RH hour'])
ylabel(['Percentage [%]'])

subplot(4,5,15)
wd1=hist(wdeltad1,[0:0.5:10]);
pd1=hist(pdeltad1,[0:0.5:10]);
sd1=hist(sdeltad1,[0:0.5:10]);
ad1=hist(adeltad1,[0:0.5:10]);
wz3=wd1/sum(wd1);
pz3=pd1/sum(pd1);
sz3=sd1/sum(sd1);
az3=ad1/sum(ad1);
for i=1:21
    span(i)=[wz3(i)+pz3(i)+az3(i)+sz3(i)];
end
bar([0:0.5:10],25*[wz3;az3;pz3;sz3]','stacked')
grid
span=5*ceil(5*(max(span)));
axis([0 10 0 span]);
if demands(4)>=0
tover=100*(length(find(wdeltad1>demands(4)))+length(find(pdeltad1>demands(4)))+length(find(sdeltad1>demands(4)))+length(find(adeltad1>demands(4))))/(length(find(wdeltad1>=-1))+length(find(pdeltad1>=-1))+length(find(sdeltad1>=-1))+length(find(adeltad1>=-1))); % counts percentage out of limits
text(11,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0])
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltad1>demands(4)))/length(find(wdeltad1>=-1));
text(11,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148])
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltad1>demands(4)))/length(find(pdeltad1>=-1));
text(11,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5])
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltad1>demands(4)))/length(find(sdeltad1>=-1));
text(11,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8])
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltad1>demands(4)))/length(find(adeltad1>=-1));
text(11,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6])
end
text(11,span*0.85,'out of limits:')
text(11,span,'Percentage')
line1=line([demands(4);demands(4)],[0;100]);
set(line1,'Color',[.4 .4 1],'LineWidth',2);
end
title(['Delta T 24 hours'])
ylabel(['Percentage [%]'])

subplot(4,5,20)
wd2=hist(wdeltad2,[0:1:20]);
pd2=hist(pdeltad2,[0:1:20]);
sd2=hist(sdeltad2,[0:1:20]);
ad2=hist(adeltad2,[0:1:20]);
wz4=wd2/sum(wd2);
pz4=pd2/sum(pd2);
sz4=sd2/sum(sd2);
az4=ad2/sum(ad2);
for i=1:21
    span(i)=[wz4(i)+pz4(i)+az4(i)+sz4(i)];
end
bar([0:1:20],25*[wz4;az4;pz4;sz4]','stacked')
grid
span=5*ceil(5*(max(span)));
axis([0 20 0 span]);
if demands(8)>=0
tover=100*(length(find(wdeltad2>demands(8)))+length(find(pdeltad2>demands(8)))+length(find(sdeltad2>demands(8)))+length(find(adeltad2>demands(8))))/(length(find(wdeltad2>=-1))+length(find(pdeltad2>=-1))+length(find(sdeltad2>=-1))+length(find(adeltad2>=-1))); % counts percentage out of limits
text(22,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0])
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltad2>demands(8)))/length(find(wdeltad2>=-1));
text(22,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148])
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltad2>demands(8)))/length(find(pdeltad2>=-1));
text(22,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5])
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltad2>demands(8)))/length(find(sdeltad2>=-1));
text(22,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8])
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltad2>demands(8)))/length(find(adeltad2>=-1));
text(22,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6])
end
text(22,span*0.85,'out of limits:')
text(22,span,'Percentage')
line1=line([demands(8);demands(8)],[0;100]);
set(line1,'Color',[.4 .4 1],'LineWidth',2);
end

title(['Delta RH 24 hours'])
ylabel(['Percentage [%]'])                            % creates text containing figure name, startdate, enddate, what
end
fig=sprintf('%smolden',savename);                           % creates unique name for this figure
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..