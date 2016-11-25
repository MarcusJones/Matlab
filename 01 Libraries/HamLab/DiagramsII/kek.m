function y=kek(temp,rh,interval,ystart,mstart,dstart,hstart,minstart,sstart,name,demname,mint,maxt,uurt,dagt,minrh,maxrh,uurrh,dagrh,varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y=kek(s,which,name,savename,demname,demand,varargin);
% copyright Jos van Schijndel and Marco Martens, Technische Universiteit Eindhoven, The Netherlands
% june 16, 2005
% s: sensor
% which: 1 = air
%        2 = surface
%        3 = supply air
%        4 = surface 2
%        5 = surface 2 directly hit by supply air
%        6 = cavity
% name: title to put above graph
% savename: file will be saved to disk under this name
% demname: name of the demand to compare with
% demand: demand numbers [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
% varargin: Taxismin    minimum T on vertical axis (standard -1)
%           Taxismax    maximum T on vertical axis (standard 31)
%           Twidth      T in between squares (standard 0.2)
%           Xwidth      X in between squares (standard 0.2)
%           histograms  on / off  1 / 0 (standard on)
%           Adan curve  on / off  1 / 0 (standard off)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
demand=[mint maxt uurt dagt minrh maxrh uurrh dagrh];
if isempty(varargin)==0
if isempty(varargin(1))==1
Taxismin=-1;
else Taxismin=varargin{1};
end
if isempty(varargin(2))==1
Taxismax=31;
else Taxismax=varargin{2};
end
if isempty(varargin(3))==1
Twidth=0.2;
else Twidth=varargin{3};
end
if isempty(varargin(4))==1
Xwidth=0.2;
else Xwidth=varargin{4};
end
if length(varargin)>=5
histo=varargin{5};
else histo=1;
end
if length(varargin)>=6
    adan=varargin{6};
end
if length(varargin)>=7;
    BASE=varargin{7};
else BASE=[];
end
if length(varargin)>=8;
    Output=varargin{8};
else Output=[];
end
if length(varargin)>=9;
    zonenr=varargin{9};
else zonenr=[];
end
else Taxismin=-1;
Taxismax=31;
Twidth=0.2;
Xwidth=0.2;
histo=1;
adan=0;
end
% bij niet-constante tijdstap: (wel nog aanpassen van deltagrafieken)
if interval==-1;
    tin=ystart;
else for i=1:length(temp)
tin(i,1)=datenum(ystart,mstart,dstart,hstart,minstart,sstart+(i-1)*interval);
end
end
Tb=Taxismax-Taxismin;
%%%%% INPUT %%%%% INPUT %%%%% INPUT %%%%% INPUT %%%%% INPUT %%%%% INPUT %%%%% INPUT %%%%%
%%%%%%%%% demands
dem=([sprintf('Indoor climate compared to %s',demname)]);
demleg=(['                   ';'T minimum =      ºC';'T maximum =      ºC';'DeltaThour =     ºC';'DeltaTday  =     ºC';'RH minimum =      %';'RH maximum =      %';'DeltaRHhour =     %';'DeltaRHday  =     %']);
demleg(1,1:length(demname))=sprintf('%s',demname);
demleg(2,17-length(sprintf('%2.1f',demand(1))):16)=sprintf('%2.1f',demand(1));
demleg(3,17-length(sprintf('%2.1f',demand(2))):16)=sprintf('%2.1f',demand(2));
demleg(4,17-length(sprintf('%2.1f',demand(3))):16)=sprintf('%2.1f',demand(3));
demleg(5,17-length(sprintf('%2.1f',demand(4))):16)=sprintf('%2.1f',demand(4));
demleg(6,18-length(sprintf('%2.1f',demand(5))):17)=sprintf('%2.1f',demand(5));
demleg(7,18-length(sprintf('%2.1f',demand(6))):17)=sprintf('%2.1f',demand(6));
demleg(8,18-length(sprintf('%2.1f',demand(7))):17)=sprintf('%2.1f',demand(7));
demleg(9,18-length(sprintf('%2.1f',demand(8))):17)=sprintf('%2.1f',demand(8));
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
sdate=datevec(tin(1));                                                      % finds first date/time point
starttime=datenum(sdate(1),sdate(2),sdate(3),0,0,0);                        % calculates starttime
edate=datevec(tin(length(tin)));                                            % finds last date/time point
endtime=datenum(edate(1),edate(2),edate(3)+1,0,0,0);                        % calculates endtime
daypoints=max(find(tin(:)<=datenum(sdate(1),sdate(2),sdate(3)+1,sdate(4),sdate(5),sdate(6))))-1;
hourpoints=round(daypoints/24);                                             % calculates number of points a day/hour
yearvec=sdate(1):edate(1);
% statistics(hulp,0,1,0,1,0) weggehaald op 8 december 2005

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting current demand into T, p and x-information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Teis([1:(demand(2)-demand(1))*2+3])=[[demand(1):1:demand(2)] [demand(2):-1:demand(1)] demand(1)];
d3=length(Teis)-1;                                                          % calculates T and x for the given demand
for d=[1:(d3/2)]
peis([d])=6.11*exp(17.08*Teis(d)./(234.18+Teis(d)))*demand(5);
peis([d3/2+d])=6.11*exp(17.08*Teis(d3/2+d)./(234.18+Teis(d3/2+d)))*demand(6);
end
peis(d3+1)=peis(1);
for d2=[1:(length(Teis))]
xeis(d2)=611*peis(d2)./(101300-peis(d2));
end 
heis(1:length(Teis))=90.1;
Thelp(1:Tb+1)=(Taxismin:1:Taxismax);
hhelp(1:Tb+1)=90;
for i=1:Tb+1
pmineis(i)=6.11*exp(17.08*Thelp(i)./(234.18+Thelp(i)))*demand(5);
pmaxeis(i)=6.11*exp(17.08*Thelp(i)./(234.18+Thelp(i)))*demand(6);
xmineis(i)=611*pmineis(i)./(101300-pmineis(i));
xmaxeis(i)=611*pmaxeis(i)./(101300-pmaxeis(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots Mollierdiagram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=[1:11]                                          % sets temperature matrix, 1 cell = 1 degree
    for h=[1:(Tb+1)]                                      % -20 up to 60 degrees Celsius
    Tmol(h,j)=(h+Taxismin-1);
    end
end
for i=[1:length(Tmol(:,1))];
RHmol(i,[1:11])=[0:0.1:1];                            % sets humidity matrix, in steps of 10%
end
for k=[1:11]                                          % calculates p for each temperature and humidity
    ismin=find(Tmol(:,k)<0);
    if isempty(ismin)==0
        for l=[1:length(ismin)]
        pmol(l,k)=611*exp(22.44*Tmol(l,1)./(272.44+Tmol(l,1)))*RHmol(l,k);
        end
    end
    isplus=find(Tmol(:,k)>=0);
    if isempty(isplus)==0
        for l=[length(ismin)+1:length(ismin)+length(isplus)]
        pmol(l,k)=611*exp(17.08*Tmol(l,1)./(234.18+Tmol(l,1)))*RHmol(l,k);
        end
    end
    for m=[1:length(Tmol(:,1))]
    xmol(m,k)=611*pmol(m,k)./(101300-pmol(m,k));      % calculates moisture content for each p
    end
end
Xaxismin=min(min(xmol));
Xaxismax=ceil(max(max(xmol)));
Xb=Xaxismax-Xaxismin;
for i=[1:length(Tmol(:,1))];
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
    subplot(4,25,[1:19 26:44 51:69 76:94])% devides plotwindow in parts
end
contour(xmol,Tmol,RHmol,RHmol(1,:));                  % plots isoRHlines in plot
axis([Xaxismin Xaxismax Taxismin Taxismax]);          % sets axis xmin, xmax, Tmin, Tmax
NewPosition=[0 0 'PaperSize'];                        % sets paper margins to zero
hold on                                               % freezes figure (so other plots can be put in without deleting previous plots)
t1=title(name);                                       % sets title
set(t1,'FontSize',20);                                % sets fontsize of title
xlabel(['Specific Humidity [g/kg]'],'FontSize',10)                  % sets x-label
ylabel('Dry Bulb Temperature [ºC]','FontSize',10)                   % sets y-label
zoek=find(Tmol(:,1)==(Taxismax-1));
text(xmol(zoek,2),Taxismax-1,'10%','FontSize',8)                             % creates text label for each isoRHline
text(xmol(zoek,3),Taxismax-1,'20%','FontSize',8)
text(xmol(zoek,4),Taxismax-1,'30%','FontSize',8)
text(xmol(zoek,5),Taxismax-1,'40%','FontSize',8)
text(xmol(zoek,6),Taxismax-1,'50%','FontSize',8)
text(xmol(zoek,7),Taxismax-1,'60%','FontSize',8)
text(xmol(zoek,8),Taxismax-1,'70%','FontSize',8)
text(xmol(zoek,9),Taxismax-1,'80%','FontSize',8)
text(xmol(zoek,10),Taxismax-1,'90%','FontSize',8)
text(xmol(zoek,11),Taxismax-1,'100%','FontSize',8)
text(Xaxismin,Taxismin,0,' copyright TU/e 2006','FontSize',8,'Color',[0.6 0.6 0.6],'VerticalAlignment','bottom');
text(Xaxismin,Taxismax,0,' copyright TU/e 2006','FontSize',8,'Color',[0.6 0.6 0.6],'VerticalAlignment','top');
text(Xaxismax,Taxismin,0,'copyright TU/e 2006 ','FontSize',8,'Color',[0.6 0.6 0.6],'VerticalAlignment','bottom','HorizontalAlignment','right');
text(Xaxismax,Taxismax,0,'copyright TU/e 2006 ','FontSize',8,'Color',[0.6 0.6 0.6],'VerticalAlignment','top','HorizontalAlignment','right');
text(0.88*Xb,0.79*Tb+Taxismin,'Total Distribution','Color',1/255*[0 0 0],'HorizontalAlignment','center','FontSize',8)
line([0.85*Xb 0.85*Xb],[0.66*Tb+Taxismin 0.78*Tb+Taxismin],[0 0],'Color',1/255*[150 150 150])
line([0.91*Xb 0.91*Xb],[0.66*Tb+Taxismin 0.78*Tb+Taxismin],[0 0],'Color',1/255*[150 150 150])
line([0.79*Xb 0.97*Xb],[0.7*Tb+Taxismin 0.7*Tb+Taxismin],[0 0],'Color',1/255*[150 150 150])
line([0.79*Xb 0.97*Xb],[0.74*Tb+Taxismin 0.74*Tb+Taxismin],[0 0],'Color',1/255*[150 150 150])
text(0.88*Xb,0.72*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)>=demand(1) & temp(:)<=demand(2) & rh(:)>=demand(5) & rh(:)<=demand(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold','FontSize',8);
text(0.94*Xb,0.76*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)>demand(2) & rh(:)>demand(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.76*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)>demand(2) & rh(:)>=demand(5) & rh(:)<=demand(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.76*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)>demand(2) & rh(:)<demand(5)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.72*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)>=demand(1) & temp(:)<=demand(2) & rh(:)<demand(5)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.68*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)<demand(1) & rh(:)<demand(5)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.68*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)<demand(1) & rh(:)>=demand(5) & rh(:)<=demand(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.68*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)<demand(1) & rh(:)>demand(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.72*Tb+Taxismin,sprintf('%d %%',round(100*length(find(temp(:)>=demand(1) & temp(:)<=demand(2) & rh(:)>demand(6)))/length(find(temp(:)>-100)))),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
% STATISTICS toegevoegd op 8 december 2005
for y=yearvec
    name1=sprintf('y%d',y);
    eval(['global ' name1 'astat ' name1 'sstat ' name1 'mstat ' name1 'wstat ' name1 'dstat ' name1 'dat ' name1 'seasons ' name1 'months ' name1 'weeks ' name1 'days';])
end
statistics2(hulp,0,1,0,0,0,1,1,0,0);
xautumn=[];
tautumn=[];
rautumn=[];
xwinter=[];
twinter=[];
rwinter=[];
xspring=[];
tspring=[];
rspring=[];
xsummer=[];
tsummer=[];
rsummer=[];
w1=[];
w2=[];
w3=[];
w4=[];
w5=[];
w6=[];
w7=[];
w8=[];
w9=[];
w10=[];
w11=[];
w12=[];
for y=yearvec;
    name1=sprintf('y%d',y);
eval(['xwinter=[xwinter;' name1 'seasons(:,8,1)];']);
eval(['twinter=[twinter;' name1 'seasons(:,1,1)];']);
eval(['rwinter=[rwinter;' name1 'seasons(:,3,1)];']);
eval(['xspring=[xspring;' name1 'seasons(:,8,2)];']);
eval(['tspring=[tspring;' name1 'seasons(:,1,2)];']);
eval(['rspring=[rspring;' name1 'seasons(:,3,2)];']);
eval(['xsummer=[xsummer;' name1 'seasons(:,8,3)];']);
eval(['tsummer=[tsummer;' name1 'seasons(:,1,3)];']);
eval(['rsummer=[rsummer;' name1 'seasons(:,3,3)];']);
eval(['xautumn=[xautumn;' name1 'seasons(:,8,4)];']);
eval(['tautumn=[tautumn;' name1 'seasons(:,1,4)];']);
eval(['rautumn=[rautumn;' name1 'seasons(:,3,4)];']);
eval(['w1n(1,[1:14])=' name1 'wstat(3,8,[52 53 1:12]);']);
eval(['w2n(1,[1:14])=' name1 'wstat(3,1,[52 53 1:12]);']);
eval(['w3n(1,[1:14])=[90 90 90 90 90 90 90 90 90 90 90 90 90 90];']);
eval(['w4n(1,[1:13])=' name1 'wstat(3,8,[13:25]);']);
eval(['w5n(1,[1:13])=' name1 'wstat(3,1,[13:25]);']);
eval(['w6n(1,[1:13])=[90 90 90 90 90 90 90 90 90 90 90 90 90];']);
eval(['w7n(1,[1:13])=' name1 'wstat(3,8,[26:38]);']);
eval(['w8n(1,[1:13])=' name1 'wstat(3,1,[26:38]);']);
eval(['w9n(1,[1:13])=[90 90 90 90 90 90 90 90 90 90 90 90 90];']);
eval(['w10n(1,[1:13])=' name1 'wstat(3,8,[39:51]);']);
eval(['w11n(1,[1:13])=' name1 'wstat(3,1,[39:51]);']);
eval(['w12n(1,[1:13])=[90 90 90 90 90 90 90 90 90 90 90 90 90];']);
w1=[w1 w1n];
w2=[w2 w2n];
w3=[w3 w3n];
w4=[w4 w4n];
w5=[w5 w5n];
w6=[w6 w6n];
w7=[w7 w7n];
w8=[w8 w8n];
w9=[w9 w9n];
w10=[w10 w10n];
w11=[w11 w11n];
w12=[w12 w12n];
end
%%%autumn
if length(find(tautumn>=0))>=1
aminT=floor(min(tautumn))-1;                            % finds minimum T
amaxT=ceil(max(tautumn))+1;                             % finds maximum T
aminX=floor(min(xautumn))-1;                            % finds minimum x
amaxX=ceil(max(xautumn))+1;                             % finds maximum x
aYX=[tautumn xautumn];
aY=aminT-0.5*Twidth:Twidth:amaxT+0.5*Twidth;
aX=aminX-0.5*Xwidth:Xwidth:amaxX+0.5*Xwidth;
aY2=aY(1:(length(aY)-1));
aX2=aX(1:(length(aX)-1));
aresult=hist2d(aYX,aY,aX);
[axjes, atemp] = meshgrid(aX2, aY2);
apercresult=100*aresult/sum(sum(aresult));            % percentage of total points is calculated
apercresult(find(apercresult==0))=NaN;                % 0-values are replaced by NaN's
aRHmax=max(max(apercresult));                         % finds maximum percentage (to set colors)
autumn=25+(21/aRHmax)*apercresult;
text(0.88*Xb,0.15*Tb+Taxismin,'Autumn Distribution','Color',1/255*[110 60 6],'HorizontalAlignment','center','FontSize',8)
line([0.85*Xb 0.85*Xb],[0.02*Tb+Taxismin 0.14*Tb+Taxismin],'Color',1/255*[255 197 120])
line([0.91*Xb 0.91*Xb],[0.02*Tb+Taxismin 0.14*Tb+Taxismin],'Color',1/255*[255 197 120])
line([0.79*Xb 0.97*Xb],[0.06*Tb+Taxismin 0.06*Tb+Taxismin],'Color',1/255*[255 197 120])
line([0.79*Xb 0.97*Xb],[0.1*Tb+Taxismin 0.1*Tb+Taxismin],'Color',1/255*[255 197 120])
text(0.88*Xb,0.08*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)>=demand(1) & tautumn(:)<=demand(2) & rautumn(:)>=demand(5) & rautumn(:)<=demand(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold','FontSize',8);
text(0.94*Xb,0.12*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)>demand(2) & rautumn(:)>demand(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.12*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)>demand(2) & rautumn(:)>=demand(5) & rautumn(:)<=demand(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.12*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)>demand(2) & rautumn(:)<demand(5)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.08*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)>=demand(1) & tautumn(:)<=demand(2) & rautumn(:)<demand(5)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.04*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)<demand(1) & rautumn(:)<demand(5)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.04*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)<demand(1) & rautumn(:)>=demand(5) & rautumn(:)<=demand(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.04*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)<demand(1) & rautumn(:)>demand(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.08*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tautumn(:)>=demand(1) & tautumn(:)<=demand(2) & rautumn(:)>demand(6)))/length(find(tautumn(:)>-100)))),'Color',1/255*[110 60 6],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
surf(axjes,atemp,autumn,'EdgeColor',1/255*[255 197 120],'FaceColor','interp'); % plots little surfaces for each T and x
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
if length(find(tsummer>=0))>=1
sminT=floor(min(tsummer))-1;                            % finds minimum T
smaxT=ceil(max(tsummer))+1;                             % finds maximum T
sminX=floor(min(xsummer))-1;                            % finds minimum x
smaxX=ceil(max(xsummer))+1;                             % finds maximum x
sYX=[tsummer xsummer];
sY=sminT-0.5*Twidth:Twidth:smaxT+0.5*Twidth;
sX=sminX-0.5*Xwidth:Xwidth:smaxX+0.5*Xwidth;
sY2=sY(1:(length(sY)-1));
sX2=sX(1:(length(sX)-1));
sresult=hist2d(sYX,sY,sX);
[sxjes, stemp] = meshgrid(sX2, sY2);
spercresult=100*sresult/sum(sum(sresult));            % percentage of total points is calculated
spercresult(find(spercresult==0))=NaN;                % 0-values are replaced by NaN's
sRHmax=max(max(spercresult));                         % finds maximum percentage (to set colors)
summer=68+(21/sRHmax)*spercresult;
text(0.88*Xb,0.31*Tb+Taxismin,'Summer Distribution','Color',1/255*[201 8 8],'HorizontalAlignment','center','FontSize',8)
line([0.85*Xb 0.85*Xb],[0.18*Tb+Taxismin 0.3*Tb+Taxismin],'Color',1/255*[255 190 200])
line([0.91*Xb 0.91*Xb],[0.18*Tb+Taxismin 0.3*Tb+Taxismin],'Color',1/255*[255 190 200])
line([0.79*Xb 0.97*Xb],[0.22*Tb+Taxismin 0.22*Tb+Taxismin],'Color',1/255*[255 190 200])
line([0.79*Xb 0.97*Xb],[0.26*Tb+Taxismin 0.26*Tb+Taxismin],'Color',1/255*[255 190 200])
text(0.88*Xb,0.24*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)>=demand(1) & tsummer(:)<=demand(2) & rsummer(:)>=demand(5) & rsummer(:)<=demand(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold','FontSize',8);
text(0.94*Xb,0.28*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)>demand(2) & rsummer(:)>demand(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.28*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)>demand(2) & rsummer(:)>=demand(5) & rsummer(:)<=demand(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.28*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)>demand(2) & rsummer(:)<demand(5)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.24*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)>=demand(1) & tsummer(:)<=demand(2) & rsummer(:)<demand(5)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.2*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)<demand(1) & rsummer(:)<demand(5)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.2*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)<demand(1) & rsummer(:)>=demand(5) & rsummer(:)<=demand(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.2*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)<demand(1) & rsummer(:)>demand(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.24*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tsummer(:)>=demand(1) & tsummer(:)<=demand(2) & rsummer(:)>demand(6)))/length(find(tsummer(:)>-100)))),'Color',1/255*[201 8 8],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
surf(sxjes,stemp,summer,'EdgeColor',1/255*[255 190 200],'FaceColor','interp'); % plots little surfaces for each T and x
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
if length(find(tspring>=0))>=1
pminT=floor(min(tspring))-1;                            % finds minimum T
pmaxT=ceil(max(tspring))+1;                             % finds maximum T
pminX=floor(min(xspring))-1;                            % finds minimum x
pmaxX=ceil(max(xspring))+1;                             % finds maximum x
pY=pminT-0.5*Twidth:Twidth:pmaxT+0.5*Twidth;
pX=pminX-0.5*Xwidth:Xwidth:pmaxX+0.5*Xwidth;
pY2=pY(1:(length(pY)-1));
pX2=pX(1:(length(pX)-1));
pYX=[tspring xspring];
presult=hist2d(pYX,pY,pX);
[pxjes, ptemp] = meshgrid(pX2, pY2);
ppercresult=100*presult/sum(sum(presult));            % percentage of total points is calculated
ppercresult(find(ppercresult==0))=NaN;                % 0-values are replaced by NaN's
pRHmax=max(max(ppercresult));                         % finds maximum percentage (to set colors)
spring=46+(21/pRHmax)*ppercresult;
text(0.88*Xb,0.47*Tb+Taxismin,'Spring Distribution','Color',1/255*[11 77 5],'HorizontalAlignment','center','FontSize',8)
line([0.85*Xb 0.85*Xb],[0.34*Tb+Taxismin 0.46*Tb+Taxismin],'Color',1/255*[156 247 148])
line([0.91*Xb 0.91*Xb],[0.34*Tb+Taxismin 0.46*Tb+Taxismin],'Color',1/255*[156 247 148])
line([0.79*Xb 0.97*Xb],[0.38*Tb+Taxismin 0.38*Tb+Taxismin],'Color',1/255*[156 247 148])
line([0.79*Xb 0.97*Xb],[0.42*Tb+Taxismin 0.42*Tb+Taxismin],'Color',1/255*[156 247 148])
text(0.88*Xb,0.4*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)>=demand(1) & tspring(:)<=demand(2) & rspring(:)>=demand(5) & rspring(:)<=demand(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold','FontSize',8);
text(0.94*Xb,0.44*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)>demand(2) & rspring(:)>demand(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.44*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)>demand(2) & rspring(:)>=demand(5) & rspring(:)<=demand(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.44*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)>demand(2) & rspring(:)<demand(5)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.4*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)>=demand(1) & tspring(:)<=demand(2) & rspring(:)<demand(5)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.36*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)<demand(1) & rspring(:)<demand(5)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.36*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)<demand(1) & rspring(:)>=demand(5) & rspring(:)<=demand(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.36*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)<demand(1) & rspring(:)>demand(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.4*Tb+Taxismin,sprintf('%d %%',round(100*length(find(tspring(:)>=demand(1) & tspring(:)<=demand(2) & rspring(:)>demand(6)))/length(find(tspring(:)>-100)))),'Color',1/255*[11 77 5],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
surf(pxjes,ptemp,spring,'EdgeColor',1/255*[156 247 148],'FaceColor','interp'); % plots little surfaces for each T and x
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
if length(find(twinter>=0))>=1
wminT=floor(min(twinter))-1;                            % finds minimum T
wmaxT=ceil(max(twinter))+1;                             % finds maximum T
wminX=floor(min(xwinter))-1;                            % finds minimum x
wmaxX=ceil(max(xwinter))+1;                             % finds maximum x
wYX=[twinter xwinter];
wY=wminT-0.5*Twidth:Twidth:wmaxT+0.5*Twidth;
wX=wminX-0.5*Xwidth:Xwidth:wmaxX+0.5*Xwidth;
wY2=wY(1:(length(wY)-1));
wX2=wX(1:(length(wX)-1));
wresult=hist2d(wYX,wY,wX);
[wxjes, wtemp] = meshgrid(wX2, wY2);
wpercresult=100*wresult/sum(sum(wresult));            % percentage of total points is calculated
wpercresult(find(wpercresult==0))=NaN;                % 0-values are replaced by NaN's
wRHmax=max(max(wpercresult));                         % finds maximum percentage (to set colors)
winter=2+(21/wRHmax)*wpercresult;
text(0.88*Xb,0.63*Tb+Taxismin,'Winter Distribution','Color',1/255*[3 51 148],'HorizontalAlignment','center','FontSize',8)
line([0.85*Xb 0.85*Xb],[0.5*Tb+Taxismin 0.62*Tb+Taxismin],'Color',1/255*[173 227 250])
line([0.91*Xb 0.91*Xb],[0.5*Tb+Taxismin 0.62*Tb+Taxismin],'Color',1/255*[173 227 250])
line([0.79*Xb 0.97*Xb],[0.54*Tb+Taxismin 0.54*Tb+Taxismin],'Color',1/255*[173 227 250])
line([0.79*Xb 0.97*Xb],[0.58*Tb+Taxismin 0.58*Tb+Taxismin],'Color',1/255*[173 227 250])
text(0.88*Xb,0.56*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)>=demand(1) & twinter(:)<=demand(2) & rwinter(:)>=demand(5) & rwinter(:)<=demand(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold','FontSize',8);
text(0.94*Xb,0.6*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)>demand(2) & rwinter(:)>demand(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.6*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)>demand(2) & rwinter(:)>=demand(5) & rwinter(:)<=demand(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.6*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)>demand(2) & rwinter(:)<demand(5)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.56*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)>=demand(1) & twinter(:)<=demand(2) & rwinter(:)<demand(5)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.82*Xb,0.52*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)<demand(1) & rwinter(:)<demand(5)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.88*Xb,0.52*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)<demand(1) & rwinter(:)>=demand(5) & rwinter(:)<=demand(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.52*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)<demand(1) & rwinter(:)>demand(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
text(0.94*Xb,0.56*Tb+Taxismin,sprintf('%d %%',round(100*length(find(twinter(:)>=demand(1) & twinter(:)<=demand(2) & rwinter(:)>demand(6)))/length(find(twinter(:)>-100)))),'Color',1/255*[3 51 148],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
surf(wxjes,wtemp,winter,'EdgeColor',1/255*[173 227 250],'FaceColor','interp'); % plots little surfaces for each T and x
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
set(gca,'FontSize',8);
grid;                   
text(0.25*Xb,0.02*Tb+Taxismin,100,demleg,'VerticalAlignment','bottom','FontSize',8);
view(2)
colormap(map2)                                        % applies new colormap
plot3(xeis,Teis,heis,'-','color',[.4 .4 1],'LineWidth',[1.5]) % plots demand into mollierdiagram
plot3(xmineis,Thelp,hhelp,'-','color',[.4 .4 1])
plot3(xmaxeis,Thelp,hhelp,'-','color',[.4 .4 1])
zoek=find(Tmol(:,1)==demand(1));
line([0 xmol(zoek,11)],[demand(1) demand(1)],[90 90],'color',[.4 .4 1])
zoek=find(Tmol(:,1)==demand(2));
line([0 xmol(zoek,11)],[demand(2) demand(2)],[90 90],'color',[.4 .4 1])
for i=1:20
wa(1,i)=0.5*Xb;
wa(2,i)=0.54*Xb;
wb(1,i)=(0.02+(i-1)/475)*Tb+Taxismin;
wb(2,i)=(0.02+(i-1)/475)*Tb+Taxismin;
wc(1,i)=i+25;
wc(2,i)=i+25;
pb(1,i)=(0.07+(i-1)/475)*Tb+Taxismin;
pb(2,i)=(0.07+(i-1)/475)*Tb+Taxismin;
pc(1,i)=i+68;
pc(2,i)=i+68;
sb(1,i)=(0.12+(i-1)/475)*Tb+Taxismin;
sb(2,i)=(0.12+(i-1)/475)*Tb+Taxismin;
sc(1,i)=i+47;
sc(2,i)=i+47;
ab(1,i)=(0.17+(i-1)/475)*Tb+Taxismin;
ab(2,i)=(0.17+(i-1)/475)*Tb+Taxismin;
ac(1,i)=i+3;
ac(2,i)=i+3;
end
surf(wa,wb,wc,'LineStyle','None')                     % legend color winter
plot3(0.52*Xb,0.39*Tb+Taxismin,90,'o','color',1/255*[3 51 148],'LineWidth',[1.5])
text(0.55*Xb,0.19*Tb+Taxismin,'winter values','FontSize',8)
text(0.55*Xb,0.39*Tb+Taxismin,'winter weekly average','FontSize',8)
surf(wa,pb,pc,'LineStyle','None')                     % legend color spring
plot3(0.52*Xb,0.34*Tb+Taxismin,90,'*','color',1/255*[11 77 5],'LineWidth',[1.5])
text(0.55*Xb,0.14*Tb+Taxismin,'spring values','FontSize',8)
text(0.55*Xb,0.34*Tb+Taxismin,'spring weekly average','FontSize',8)
surf(wa,sb,sc,'LineStyle','None')                     % legend color summer
plot3(0.52*Xb,0.29*Tb+Taxismin,90,'>','color',1/255*[201 8 8],'LineWidth',[1.5])
text(0.55*Xb,0.09*Tb+Taxismin,'summer values','FontSize',8)
text(0.55*Xb,0.29*Tb+Taxismin,'summer weekly average','FontSize',8)
surf(wa,ab,ac,'LineStyle','None')                     % legend color autumn
plot3(0.52*Xb,0.24*Tb+Taxismin,90,'+','color',1/255*[110 60 6],'LineWidth',[1.5])
text(0.55*Xb,0.04*Tb+Taxismin,'autumn values','FontSize',8)
text(0.55*Xb,0.24*Tb+Taxismin,'autumn weekly average','FontSize',8)
t6=text(0.5*Xb,-0.08*Tb+Taxismin,sprintf('%s, %s to %s',dem,datestr(floor(starttime)),datestr(ceil(endtime))));
set(t6,'FontSize',14,'VerticalAlignment','top','HorizontalAlignment','center');
caxis([1 100]);
%%% ENERGY AND POWER
if ~isempty(BASE) & ~isempty(Output) & ~isempty(zonenr)
[Em3m3,PWm3]=enpowfun(BASE,Output,zonenr);
% bevochtiging
if Em3m3(3)>0 & PWm3(3)>0
zoek1=find(Tmol(:,1)==round((demand(1)+demand(2))/2));
text(xmol(zoek1,floor(demand(5)/10)+1),0.03*Tb+(demand(1)+demand(2))/2,100,'Energy [m³gas/m³building]','Color',[0 0 0],'HorizontalAlignment','right','FontSize',5)
text(xmol(zoek1,floor(demand(5)/10)+1),0.01*Tb+(demand(1)+demand(2))/2,100,sprintf('%5.2f',Em3m3(3)),'Color',[0 0 0],'HorizontalAlignment','right','FontSize',7)
text(xmol(zoek1,floor(demand(5)/10)+1),-0.01*Tb+(demand(1)+demand(2))/2,100,'Power [W/m³building]','Color',[0 0 0],'HorizontalAlignment','right','FontSize',5)
text(xmol(zoek1,floor(demand(5)/10)+1),-0.03*Tb+(demand(1)+demand(2))/2,100,sprintf('%5.2f',PWm3(3)),'Color',[0 0 0],'HorizontalAlignment','right','FontSize',7)
end
% ontvochtiging
if Em3m3(4)>0 & PWm3(4)>0
zoek1=find(Tmol(:,1)==round((demand(1)+demand(2))/2));
text(xmol(zoek1,ceil(demand(6)/10)+1),0.03*Tb+(demand(1)+demand(2))/2,100,'Energy [m³gas/m³building]','Color',[0 0 0],'HorizontalAlignment','left','FontSize',5)
text(xmol(zoek1,ceil(demand(6)/10)+1),0.01*Tb+(demand(1)+demand(2))/2,100,sprintf('%5.2f',Em3m3(4)),'Color',[0 0 0],'HorizontalAlignment','left','FontSize',7)
text(xmol(zoek1,ceil(demand(6)/10)+1),-0.01*Tb+(demand(1)+demand(2))/2,100,'Power [W/m³building]','Color',[0 0 0],'HorizontalAlignment','left','FontSize',5)
text(xmol(zoek1,ceil(demand(6)/10)+1),-0.03*Tb+(demand(1)+demand(2))/2,100,sprintf('%5.2f',PWm3(4)),'Color',[0 0 0],'HorizontalAlignment','left','FontSize',7)
end
% verwarming
if Em3m3(1)>0 & PWm3(1)>0
zoek1=find(Tmol(:,1)==round(demand(1)));
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,-0.03*Tb+demand(1),100,'Energy [m³gas/m³building]','Color',[0 0 0],'HorizontalAlignment','center','FontSize',5)
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,-0.05*Tb+demand(1),100,sprintf('%5.2f',Em3m3(1)),'Color',[0 0 0],'HorizontalAlignment','center','FontSize',7)
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,-0.07*Tb+demand(1),100,'Power [W/m³building]','Color',[0 0 0],'HorizontalAlignment','center','FontSize',5)
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,-0.09*Tb+demand(1),100,sprintf('%5.2f',PWm3(1)),'Color',[0 0 0],'HorizontalAlignment','center','FontSize',7)
end
% koeling
if Em3m3(2)>0 & PWm3(2)>0
zoek1=find(Tmol(:,1)==round(demand(2)));
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,0.09*Tb+demand(2),100,'Energy [m³gas/m³building]','Color',[0 0 0],'HorizontalAlignment','center','FontSize',5)
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,0.07*Tb+demand(2),100,sprintf('%5.2f',Em3m3(1)),'Color',[0 0 0],'HorizontalAlignment','center','FontSize',7)
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,0.05*Tb+demand(2),100,'Power [W/m³building]','Color',[0 0 0],'HorizontalAlignment','center','FontSize',5)
text((xmol(zoek1,floor(demand(5)/10)+1)+xmol(zoek1,ceil(demand(6)/10)+1))/2,0.03*Tb+demand(2),100,sprintf('%5.2f',PWm3(1)),'Color',[0 0 0],'HorizontalAlignment','center','FontSize',7)
end
end
%%% ADAN CURVE
if adan==1
line([1.57 1.71 1.87 2.04 2.23 2.43 2.64 2.85 3.05 3.28 3.51 3.73 3.96 4.20 4.45 4.72 5.01 5.31 5.63 5.97 6.33 6.71 7.11 7.54 7.99 8.47 8.99 9.53 10.11 10.73 11.38 12.09 12.83 13.63 14.49 15.40 16.38 17.42 18.54 19.74 21.03 22.42 23.90 25.50 27.22 29.07 31.06 33.20 35.52 38.01 40.71 43.62 46.77 50.17 53.86 57.86 62.19 66.90],[-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47],[90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90],'Color',[.6 .6 .6],'LineWidth',1.5);
line([0.51*Xb 0.53*Xb],[0.44*Tb+Taxismin 0.44*Tb+Taxismin],[90 90],'color',[.6 .6 .6],'LineWidth',[2])
text(0.55*Xb,0.44*Tb+Taxismin,'fungal growth curve','FontSize',8)
end
%%% END ADAN

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
set(gca,'FontSize',8);
if demand(3)>=0
tover=100*(length(find(wdeltah1>demand(3)))+length(find(pdeltah1>demand(3)))+length(find(sdeltah1>demand(3)))+length(find(adeltah1>demand(3))))/(length(find(wdeltah1>=-1))+length(find(pdeltah1>=-1))+length(find(sdeltah1>=-1))+length(find(adeltah1>=-1))); % counts percentage out of limits
text(11,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0],'FontSize',8)              % creates text containing this percentage
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltah1>demand(3)))/length(find(wdeltah1>=-1)); % counts percentage out of limits
text(11,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148],'FontSize',8)              % creates text containing this percentage
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltah1>demand(3)))/length(find(pdeltah1>=-1)); % counts percentage out of limits
text(11,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5],'FontSize',8)             % creates text containing this percentage
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltah1>demand(3)))/length(find(sdeltah1>=-1)); % counts percentage out of limits
text(11,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8],'FontSize',8)             % creates text containing this percentage
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltah1>demand(3)))/length(find(adeltah1>=-1)); % counts percentage out of limits
text(11,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6],'FontSize',8)             % creates text containing this percentage
end
text(11,span*0.85,'out of limits:','FontSize',8)                    % text
text(11,span,'Percentage','FontSize',8)                       % text
line1=line([demand(3);demand(3)],[0;100]);          % plots vertical line at demand
set(line1,'Color',[.4 .4 1],'LineWidth',1.5);         % sets parameters for this line
end
title(['Delta T hour'],'FontSize',9)                               % title
ylabel(['Percentage [%]'],'FontSize',8)                            % y-label

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
set(gca,'FontSize',8);
if demand(7)>=0
tover=100*(length(find(wdeltah2>demand(7)))+length(find(pdeltah2>demand(7)))+length(find(sdeltah2>demand(7)))+length(find(adeltah2>demand(7))))/(length(find(wdeltah2>=-1))+length(find(pdeltah2>=-1))+length(find(sdeltah2>=-1))+length(find(adeltah2>=-1))); % counts percentage out of limits
text(22,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0],'FontSize',8)
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltah2>demand(7)))/length(find(wdeltah2>=-1));
text(22,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148],'FontSize',8)
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltah2>demand(7)))/length(find(pdeltah2>=-1));
text(22,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5],'FontSize',8)
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltah2>demand(7)))/length(find(sdeltah2>=-1));
text(22,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8],'FontSize',8)
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltah2>demand(7)))/length(find(adeltah2>=-1));
text(22,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6],'FontSize',8)
end
text(22,span*0.85,'out of limits:','FontSize',8)
text(22,span,'Percentage','FontSize',8)
line1=line([demand(7);demand(7)],[0;100]);
set(line1,'Color',[.4 .4 1],'LineWidth',2);
end
title(['Delta RH hour'],'FontSize',9)
ylabel(['Percentage [%]'],'FontSize',8)

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
set(gca,'FontSize',8);
if demand(4)>=0
tover=100*(length(find(wdeltad1>demand(4)))+length(find(pdeltad1>demand(4)))+length(find(sdeltad1>demand(4)))+length(find(adeltad1>demand(4))))/(length(find(wdeltad1>=-1))+length(find(pdeltad1>=-1))+length(find(sdeltad1>=-1))+length(find(adeltad1>=-1))); % counts percentage out of limits
text(11,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0],'FontSize',8)
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltad1>demand(4)))/length(find(wdeltad1>=-1));
text(11,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148],'FontSize',8)
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltad1>demand(4)))/length(find(pdeltad1>=-1));
text(11,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5],'FontSize',8)
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltad1>demand(4)))/length(find(sdeltad1>=-1));
text(11,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8],'FontSize',8)
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltad1>demand(4)))/length(find(adeltad1>=-1));
text(11,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6],'FontSize',8)
end
text(11,span*0.85,'out of limits:','FontSize',8)
text(11,span,'Percentage','FontSize',8)
line1=line([demand(4);demand(4)],[0;100]);
set(line1,'Color',[.4 .4 1],'LineWidth',2);
end
title(['Delta T 24 hours'],'FontSize',9)
ylabel(['Percentage [%]'],'FontSize',8)

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
set(gca,'FontSize',8);
if demand(8)>=0
tover=100*(length(find(wdeltad2>demand(8)))+length(find(pdeltad2>demand(8)))+length(find(sdeltad2>demand(8)))+length(find(adeltad2>demand(8))))/(length(find(wdeltad2>=-1))+length(find(pdeltad2>=-1))+length(find(sdeltad2>=-1))+length(find(adeltad2>=-1))); % counts percentage out of limits
text(22,span*0.7,sprintf('total  %d %%',round(tover)),'color',[0 0 0],'FontSize',8)
if length(find(twinter>=0))>=1
wover=100*length(find(wdeltad2>demand(8)))/length(find(wdeltad2>=-1));
text(22,span*0.55,sprintf('winter %d %%',round(wover)),'color',1/255*[3 51 148],'FontSize',8)
end
if length(find(tspring>=0))>=1
pover=100*length(find(pdeltad2>demand(8)))/length(find(pdeltad2>=-1));
text(22,span*0.4,sprintf('spring %d %%',round(pover)),'color',1/255*[11 77 5],'FontSize',8)
end
if length(find(tsummer>=0))>=1
sover=100*length(find(sdeltad2>demand(8)))/length(find(sdeltad2>=-1));
text(22,span*0.25,sprintf('summer %d %%',round(sover)),'color',1/255*[201 8 8],'FontSize',8)
end
if length(find(tautumn>=0))>=1
aover=100*length(find(adeltad2>demand(8)))/length(find(adeltad2>=-1));
text(22,span*0.1,sprintf('autumn %d %%',round(aover)),'color',1/255*[110 60 6],'FontSize',8)
end
text(22,span*0.85,'out of limits:','FontSize',8)
text(22,span,'Percentage','FontSize',8)
line1=line([demand(8);demand(8)],[0;100]);
set(line1,'Color',[.4 .4 1],'LineWidth',2);
end
title(['Delta RH 24 hours'],'FontSize',9)
ylabel(['Percentage [%]'],'FontSize',8)                            % creates text containing figure name, startdate, enddate, what
end
datum=datevec(now);
data='20000000';
data(1:4)=num2str(datum(1));
maand=num2str(datum(2));
dag=num2str(datum(3));
if length(maand)==2
    data(5:6)=maand;
else data(6)=maand;
end
if length(dag)==2
    data(7:8)=dag;
else data(8)=dag;
end
if exist(['KEK' data])==7
    cd(['KEK' data]);
else mkdir(['KEK' data])
    cd(['KEK' data]);
end
print('-dtiff','-r250',['KEK' name]);
cd .. 