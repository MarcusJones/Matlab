function y=numbers(s,name,savename,demand);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copyright Jos van Schijndel and Marco Martens, Technische Universiteit Eindhoven, The Netherlands
% june 16, 2005
% s: sensor
% name: title to put above graph
% savename: file will be saved to disk under this name
% demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%             'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%             or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tin=s(:,1);
RHin=s(:,3);
tin=s(:,10);
sdate=datevec(tin(1));
starttime=datenum(sdate(1),sdate(2),sdate(3),0,0,0);
edate=datevec(tin(length(tin)));
endtime=datenum(edate(1),edate(2),edate(3)+1,0,0,0);
daypoints=max(find(tin(:)<=datenum(sdate(1),sdate(2),sdate(3)+1,sdate(4),sdate(5),sdate(6))))-1;
hourpoints=round(daypoints/24);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demands (minimum T, maximum T, deltaT 1h, deltaT 24h, minimum RH, maximum RH, deltaRH 1h, deltaRH 24 h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting current demand into T, p and x-information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Teis([1:(demands(2)-demands(1))*2+3])=[[demands(1):1:demands(2)] [demands(2):-1:demands(1)] demands(1)];
d3=length(Teis)-1;
for d=[1:(d3/2)]
peis([d])=6.11*exp(17.08*Teis(d)./(234.18+Teis(d)))*demands(5);
peis([d3/2+d])=6.11*exp(17.08*Teis(d3/2+d)./(234.18+Teis(d3/2+d)))*demands(6);
end
peis(d3+1)=peis(1);
for d2=[1:(length(Teis))]
xeis(d2)=611*peis(d2)./(101300-peis(d2));
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=[hourpoints+1:(length(Tin))]                              % calculates hourly difference between min and max for each value
deltah1(i)=range([Tin([i-hourpoints:i])]);
deltah2(i)=range([RHin([i-hourpoints:i])]);
end
for i=[daypoints+1:(length(Tin))]                             % calculates daily difference between min and max for each value
deltad1(i)=range([Tin([i-daypoints:i])]);
deltad2(i)=range([RHin([i-daypoints:i])]);
end
for i=[1:hourpoints]                                             % adds 3 NaN-values to make sure the lengths are the same
deltah1(i)=NaN;                                         % hourly difference air temperature (including line 30)
deltah2(i)=NaN;                                         % hourly difference air temperature (including line 30)
end
for i=[1:daypoints]
deltad1(i)=NaN;
deltad2(i)=NaN;
end
Terrmin=find(Tin<demands(1));                        % finds cells where T is smaller than min
Terrminplot=[NaN NaN;NaN NaN];
for i=[1:length(Terrmin)]
TerrminploRH(1,i)=tin(Terrmin(i));
Terrminplot(2,i)=Tin(Terrmin(i));
end
Terrmax=find(Tin>demands(2));                        % finds cells where T is larger than max
Terrmaxplot=[NaN NaN;NaN NaN];
for i=[1:length(Terrmax)]
Terrmaxplot(1,i)=tin(Terrmax(i));
Terrmaxplot(2,i)=Tin(Terrmax(i));
end
RHerrmin=find(RHin<demands(5));                       % finds cells where RH is smaller than min
RHerrminplot=[NaN NaN;NaN NaN];
for i=[1:length(RHerrmin)]
RHerrminplot(1,i)=tin(RHerrmin(i));
RHerrminplot(2,i)=RHin(RHerrmin(i));
end
RHerrmax=find(RHin>demands(6));                       % finds cells where RH is larger than max
RHerrmaxplot=[NaN NaN;NaN NaN];
for i=[1:length(RHerrmax)]
RHerrmaxplot(1,i)=tin(RHerrmax(i));
RHerrmaxplot(2,i)=RHin(RHerrmax(i));
end
Terrhmax=find(deltah1(:)>demands(3));                   % finds cells where delta T is larger than max per hour
Terrhplot=[NaN NaN;NaN NaN];
for i=[1:length(Terrhmax)]
Terrhplot(1,i)=tin(Terrhmax(i));
Terrhplot(2,i)=deltah1(Terrhmax(i));
end
Terrdmax=find(deltad1(:)>demands(4));                   % finds cells where delta T is larger than max per 24 hours
Terrdplot=[NaN NaN;NaN NaN];
for i=[1:length(Terrdmax)]
Terrdplot(1,i)=tin(Terrdmax(i));
Terrdplot(2,i)=deltad1(Terrdmax(i));
end
RHerrhmax=find(deltah2(:)>demands(7));                  % finds cells where delta RH is larger than max per hour
RHerrhplot=[NaN NaN;NaN NaN];
for i=[1:length(RHerrhmax)]
RHerrhplot(1,i)=tin(RHerrhmax(i));
RHerrhplot(2,i)=deltah2(RHerrhmax(i));
end
RHerrdmax=find(deltad2(:)>demands(8));                  % finds cells where delta RH is larger than max per 24 hours
RHerrdplot=[NaN NaN;NaN NaN];
for i=[1:length(RHerrdmax)]
RHerrdplot(1,i)=tin(RHerrdmax(i));
RHerrdplot(2,i)=deltad2(RHerrdmax(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots error figure (numerical)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure                                                  % figure containing errors
axis off
text1=sprintf('T < %d ºC',demands(1));
text2=sprintf('T > %d ºC',demands(2));
text3=sprintf('RH < %d %%',demands(5));
text4=sprintf('RH > %d %%',demands(6));
text5=sprintf('DThour > %d ºC',demands(3));
text6=sprintf('DT24h > %d ºC',demands(4));
text7=sprintf('DRHhour > %d %%',demands(7));
text8=sprintf('DRH24h > %d %%',demands(8));
text(-0.1,1,text1)
text(0.05,1,text2)
text(0.2,1,text3)
text(0.35,1,text4)
text(0.5,1,text5)
text(0.65,1,text6)
text(0.8,1,text7)
text(0.95,1,text8)
text(-0.1,0.95,num2str(length(Terrmin)/hourpoints))
text(-0.1,0.92,num2str(100*length(Terrmin)/(length(Tin)),3))
text(0.05,0.95,num2str(length(Terrmax)/hourpoints))
text(0.05,0.92,num2str(100*length(Terrmax)/(length(Tin)),3))
text(0.2,0.95,num2str(length(RHerrmin)/hourpoints))
text(0.2,0.92,num2str(100*length(RHerrmin)/(length(Tin)),3))
text(0.35,0.95,num2str(length(RHerrmax)/hourpoints))
text(0.35,0.92,num2str(100*length(RHerrmax)/(length(Tin)),3))
text(0.5,0.95,num2str(length(Terrhmax)/hourpoints))
text(0.5,0.92,num2str(100*length(Terrhmax)/(length(Tin)),3))
text(0.65,0.95,num2str(length(Terrdmax)/hourpoints))
text(0.65,0.92,num2str(100*length(Terrdmax)/(length(Tin)),3))
text(0.8,0.95,num2str(length(RHerrhmax)/hourpoints))
text(0.8,0.92,num2str(100*length(RHerrhmax)/(length(Tin)),3))
text(0.95,0.95,num2str(length(RHerrdmax)/hourpoints))
text(0.95,0.92,num2str(100*length(RHerrdmax)/(length(Tin)),3))
time1=unique(floor(tin(Terrmin)));
if isempty(time1)==0
if length(time1)<=38
   text(-0.1,0.9,datestr(time1,'dd/mm'),'VerticalAlignment','top')
elseif length(time1)<=76
    text(-0.1,0.9,datestr(time1([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(-0.05,0.9,datestr(time1([39:length(time1)]),'dd/mm'),'VerticalAlignment','top')
else text(-0.1,0.9,datestr(time1([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(-0.05,0.9,datestr(time1([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0,0.9,datestr(time1([77:length(time1)]),'dd/mm'),'VerticalAlignment','top')
end
end
time2=unique(floor(tin(Terrmax)));
if isempty(time2)==0
if length(time2)<=38
   text(0.05,0.9,datestr(time2,'dd/mm'),'VerticalAlignment','top')
elseif length(time2)<=76
    text(0.05,0.9,datestr(time2([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.1,0.9,datestr(time2([39:length(time2)]),'dd/mm'),'VerticalAlignment','top')
else text(0.05,0.9,datestr(time2([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.1,0.9,datestr(time2([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0.15,0.9,datestr(time2([77:length(time2)]),'dd/mm'),'VerticalAlignment','top')
end
end
time3=unique(floor(tin(RHerrmin)));
if isempty(time3)==0
if length(time3)<=38
   text(0.2,0.9,datestr(time3,'dd/mm'),'VerticalAlignment','top')
elseif length(time3)<=76
    text(0.2,0.9,datestr(time3([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.25,0.9,datestr(time3([39:length(time3)]),'dd/mm'),'VerticalAlignment','top')
else text(0.2,0.9,datestr(time3([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.25,0.9,datestr(time3([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0.3,0.9,datestr(time3([77:length(time3)]),'dd/mm'),'VerticalAlignment','top')
end
end
time4=unique(floor(tin(RHerrmax)));
if isempty(time4)==0
if length(time4)<=38
   text(0.35,0.9,datestr(time4,'dd/mm'),'VerticalAlignment','top')
elseif length(time4)<=76
    text(0.35,0.9,datestr(time4([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.4,0.9,datestr(time4([39:length(time4)]),'dd/mm'),'VerticalAlignment','top')
else text(0.35,0.9,datestr(time4([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.4,0.9,datestr(time4([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0.45,0.9,datestr(time4([77:length(time4)]),'dd/mm'),'VerticalAlignment','top')
end
end
time5=unique(floor(tin(Terrhmax)));
if isempty(time5)==0
if length(time5)<=38
   text(0.5,0.9,datestr(time5,'dd/mm'),'VerticalAlignment','top')
elseif length(time5)<=76
    text(0.5,0.9,datestr(time5([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.55,0.9,datestr(time5([39:length(time5)]),'dd/mm'),'VerticalAlignment','top')
else text(0.5,0.9,datestr(time5([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.55,0.9,datestr(time5([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0.6,0.9,datestr(time5([77:length(time5)]),'dd/mm'),'VerticalAlignment','top')
end
end
time6=unique(floor(tin(Terrdmax)));
if isempty(time6)==0
if length(time6)<=38
   text(0.65,0.9,datestr(time6,'dd/mm'),'VerticalAlignment','top')
elseif length(time6)<=76
    text(0.65,0.9,datestr(time6([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.7,0.9,datestr(time6([39:length(time6)]),'dd/mm'),'VerticalAlignment','top')
else text(0.65,0.9,datestr(time6([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.7,0.9,datestr(time6([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0.75,0.9,datestr(time6([77:length(time6)]),'dd/mm'),'VerticalAlignment','top')
end
end
time7=unique(floor(tin(RHerrhmax)));
if isempty(time7)==0
if length(time7)<=38
   text(0.8,0.9,datestr(time7,'dd/mm'),'VerticalAlignment','top')
elseif length(time7)<=76
    text(0.8,0.9,datestr(time7([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.85,0.9,datestr(time7([39:length(time7)]),'dd/mm'),'VerticalAlignment','top')
else text(0.8,0.9,datestr(time7([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(0.85,0.9,datestr(time7([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(0.9,0.9,datestr(time7([77:length(time7)]),'dd/mm'),'VerticalAlignment','top')
end
end
time8=unique(floor(tin(RHerrdmax)));
if isempty(time8)==0
if length(time8)<=38
   text(0.95,0.9,datestr(time8,'dd/mm'),'VerticalAlignment','top')
elseif length(time8)<=76
    text(0.95,0.9,datestr(time8([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(1,0.9,datestr(time8([39:length(time8)]),'dd/mm'),'VerticalAlignment','top')
else text(0.95,0.9,datestr(time8([1:38]),'dd/mm'),'VerticalAlignment','top')
    text(1,0.9,datestr(time8([39:76]),'dd/mm'),'VerticalAlignment','top')
    text(1.05,0.9,datestr(time8([77:length(time8)]),'dd/mm'),'VerticalAlignment','top')
end
end
t6=text(0.5,-0.07,sprintf('%s, %s to %s',dem,datestr(floor(starttime)),datestr(ceil(endtime))));% places dates-text at the right position
set(t6,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center')% sets fontsize and alignment
q=text(0.5,1.07,([name]));
set(q,'FontSize',20,'VerticalAlignment','top','HorizontalAlignment','center');
orient landscape
fig=sprintf('%snumbers',savename);                           % creates unique name for this figure
if exist(datestr(floor(now)),'file')==0
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))
print('-dtiff','-r250',fig);
cd ..