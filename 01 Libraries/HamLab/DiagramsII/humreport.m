function y=humreport(hourpoints,savename,varargin)
% humreport(hourpoints,savename,name,rh,minrh,maxrh,hourrh,dayrh,name,rh,...)
for i=1:round(length(varargin)/6)
REPORT(i).name=varargin{6*i-5};
REPORT(i).rh=varargin{6*i-4};
REPORT(i).minrh=varargin{6*i-3};
REPORT(i).maxrh=varargin{6*i-2};
REPORT(i).hourrh=varargin{6*i-1};
REPORT(i).dayrh=varargin{6*i};
end

map=zeros(101,3);
map(:,1)=[ones(1,50) 1:-1/50:0]'; 
map(:,2)=[0:1/100:1]';
map(:,3)=zeros(101,1);

fact=round(length(varargin)/6)+2;
fz1=min([10 150/fact]);

figure
axis off
for i=0:fact
line([0 1],[i/fact i/fact],'LineWidth',1.5,'Color',[0.6 0.6 0.6])
end
line([0 0],[0 1],'LineWidth',1.5,'Color',[0.6 0.6 0.6])
line([1 1],[0 1],'LineWidth',1.5,'Color',[0.6 0.6 0.6])
line([0.4 0.4],[(fact-0.8)/fact 1/fact],[0.05 0.05],'LineWidth',1.5,'Color',[0.5 0.5 0.5])
line([0.7 0.7],[(fact-0.8)/fact 1/fact],[0.05 0.05],'LineWidth',1.5,'Color',[0.5 0.5 0.5])
hold on
surf([0.1 0.1;0.9 0.9],[0.25/fact 0.75/fact;0.25/fact 0.75/fact],[-1 -1;0 0],'LineStyle','None','FaceColor','interp')
text(0.09,0.5/fact,0.05,'0 %','Fontsize',fz1,'HorizontalAlignment','right')
text(0.91,0.5/fact,0.05,'100 %','Fontsize',fz1,'HorizontalAlignment','left')
line([0.20 0.20],[(fact-length(varargin)/6-1)/fact 1],'LineWidth',1.5,'Color',[0.6 0.6 0.6])
line([0.90 0.90],[(fact-length(varargin)/6-1)/fact 1],'LineWidth',1.5,'Color',[0.6 0.6 0.6])
text(0.01,(fact-0.3)/fact,0.05,'Ruimtenaam','Fontsize',fz1+4,'HorizontalAlignment','left');
text(0.55,(fact-0.3)/fact,0.05,'Bereik absoluut en procentueel','Fontsize',fz1+4,'HorizontalAlignment','center');
text(0.95,(fact-0.3)/fact,0.05,'Delta','Fontsize',fz1+4,'HorizontalAlignment','center');
text(0.925,(fact-0.7)/fact,0.05,'uur','Fontsize',fz1,'HorizontalAlignment','center');
text(0.975,(fact-0.7)/fact,0.05,'dag','Fontsize',fz1,'HorizontalAlignment','center');
text(0.4,(fact-0.7)/fact,0.05,'min','Fontsize',fz1,'HorizontalAlignment','center');
text(0.7,(fact-0.7)/fact,0.05,'max','Fontsize',fz1,'HorizontalAlignment','center');
title([savename '   Relatieve Vochtigheid Rapport'],'Fontsize',fz1+6)
for i=1:length(varargin)/6
roomtext=REPORT(i).name;
a=length(find(REPORT(i).rh<REPORT(i).minrh));
b=length(find(REPORT(i).rh>REPORT(i).maxrh));
c=length(find(REPORT(i).rh>-100));
d=nanmin(REPORT(i).rh);
e=nanmean(REPORT(i).rh);
f=nanmax(REPORT(i).rh);
g=REPORT(i).minrh;
h=REPORT(i).maxrh;
if a/c<=0.3%tekst % onderschrijding
    text(0.395-0.3*min([0.6 a/c]),(fact-i-0.75)/fact,0.05,[num2str(100*a/c,3) ' %'],'Fontsize',fz1,'HorizontalAlignment','right');
else     text(0.405-0.3*min([0.6 a/c]),(fact-i-0.75)/fact,0.05,[num2str(100*a/c,3) ' %'],'Fontsize',fz1,'HorizontalAlignment','left');
end
if b/c<=0.3%tekst % overschrijding
    text(0.705+0.3*min([0.6 b/c]),(fact-i-0.75)/fact,0.05,[num2str(100*b/c,3) ' %'],'Fontsize',fz1,'HorizontalAlignment','left');
else text(0.695+0.3*min([0.6 b/c]),(fact-i-0.75)/fact,0.05,[num2str(100*b/c,3) ' %'],'Fontsize',fz1,'HorizontalAlignment','right');
end
text(0.55,(fact-i-0.75)/fact,0.05,[num2str(100*(1-(a+b)/c),3) ' %'],'Fontsize',fz1,'HorizontalAlignment','center');
text(0.395,(fact-i-0.5)/fact,0.05,[num2str(g) ' %RH'],'Color',[0.4 0.4 0.4],'FontSize',fz1,'HorizontalAlignment','right')
text(0.705,(fact-i-0.5)/fact,0.05,[num2str(h) ' %RH'],'Color',[0.4 0.4 0.4],'FontSize',fz1,'HorizontalAlignment','left')

if (d-g)/(h-g)>=-0.3% min waarde
    text(0.395+0.3*max([-0.6 (d-g)/(h-g)]),(fact-i-0.25)/fact,0.05,[num2str(d,3) '%RH'],'Fontsize',fz1,'HorizontalAlignment','right');
else text(0.405+0.3*max([-0.6 (d-g)/(h-g)]),(fact-i-0.25)/fact,0.05,[num2str(d,3) '%RH'],'Fontsize',fz1,'HorizontalAlignment','left');
end
line([0.4+0.3*max([-0.6 (d-g)/(h-g)]) 0.4+0.3*max([-0.6 (d-g)/(h-g)])],[(fact-i-0.05)/fact (fact-i-0.45)/fact],'Color',[0 0 0],'LineWidth',1)
if (f-h)/(h-g)>=0.3% max waarde
    text(0.695+0.3*min([0.6 (f-h)/(h-g)]),(fact-i-0.25)/fact,0.05,[num2str(f,3) '%RH'],'Fontsize',fz1,'HorizontalAlignment','right');
else text(0.705+0.3*min([0.6 (f-h)/(h-g)]),(fact-i-0.25)/fact,0.05,[num2str(f,3) '%RH'],'Fontsize',fz1,'HorizontalAlignment','left');
end
line([0.7+0.3*min([0.6 (f-h)/(h-g)]) 0.7+0.3*min([0.6 (f-h)/(h-g)])],[(fact-i-0.05)/fact (fact-i-0.45)/fact],'Color',[0 0 0],'LineWidth',1)
text(0.705+0.3*min([0.6 (e-h)/(h-g)]),(fact-i-0.25)/fact,0.05,[num2str(e,3) '%RH'],'Fontsize',fz1,'HorizontalAlignment','left');
line([0.7+0.3*min([0.6 (e-h)/(h-g)]) 0.7+0.3*min([0.6 (e-h)/(h-g)])],[(fact-i-0.05)/fact (fact-i-0.45)/fact],'Color',[0 0 0],'LineWidth',3)
line([0.4+0.3*max([-0.6 (d-g)/(h-g)]) 0.7+0.3*min([0.6 (f-h)/(h-g)])],[(fact-i-0.4)/fact (fact-i-0.4)/fact],'Color',[0 0 0],'LineWidth',1)
hold on
surf([0.4-0.3*min([0.6 a/c]) 0.7+0.3*min([0.6 b/c]);0.4-0.3*min([0.6 a/c]) 0.7+0.3*min([0.6 b/c])],[(fact-i-1)/fact (fact-i-1)/fact;(fact-i-0.5)/fact (fact-i-0.5)/fact],(1-a-b)/c*[1 1;1 1],'LineStyle','None')


for ii=1:20
roomtext=strrep(roomtext,'  ',' ');
end
text(0.01,(fact-i-0.5)/fact,0.05,roomtext,'Fontsize',fz1+1)


daypoints=hourpoints*24;
for j=[hourpoints+1:(length(REPORT(i).rh))];
    deltah(j)=range([REPORT(i).rh([j-hourpoints:j])]);
end
for j=[daypoints+1:(length(REPORT(i).rh))];
    deltad(j)=range([REPORT(i).rh([j-daypoints:j])]);
end
for j=[1:hourpoints]
deltah(j)=NaN;
end
for j=[1:daypoints]
deltad(j)=NaN;
end
k=length(find(deltah>REPORT(i).hourrh))/length(find(deltah>=0));
m=length(find(deltad>REPORT(i).dayrh))/length(find(deltad>=0));
if k<0.01;k=0;end
if m<0.01;m=0;end
surf([0.9 0.9+0.05*k;0.9 0.9+0.05*k],[(fact-i-0.5)/fact (fact-i-0.5)/fact;(fact-i-1)/fact (fact-i-1)/fact],[-1 -1;-1 -1],'LineStyle','None')
surf([0.9 0.9+0.05*(1-k);0.9 0.9+0.05*(1-k)],[(fact-i-0.5)/fact (fact-i-0.5)/fact;(fact-i-0)/fact (fact-i-0)/fact],[0 0;0 0],'LineStyle','None')
surf([0.95 0.95+0.05*m;0.95 0.95+0.05*m],[(fact-i-0.5)/fact (fact-i-0.5)/fact;(fact-i-1)/fact (fact-i-1)/fact],[-1 -1;-1 -1],'LineStyle','None')
surf([0.95 0.95+0.05*(1-m);0.95 0.95+0.05*(1-m)],[(fact-i-0.5)/fact (fact-i-0.5)/fact;(fact-i-0)/fact (fact-i-0)/fact],[0 0;0 0],'LineStyle','None')
text(0.925,(fact-i-0.25)/fact,0.05,[num2str(100*(1-k),3) ' %'],'FontSize',fz1-1,'HorizontalAlignment','center')
text(0.975,(fact-i-0.25)/fact,0.05,[num2str(100*(1-m),3) ' %'],'FontSize',fz1-1,'HorizontalAlignment','center')
text(0.925,(fact-i-0.75)/fact,0.05,[num2str(100*(k),3) ' %'],'FontSize',fz1-1,'HorizontalAlignment','center')
text(0.975,(fact-i-0.75)/fact,0.05,[num2str(100*(m),3) ' %'],'FontSize',fz1-1,'HorizontalAlignment','center')
text(0.925,(fact-i-0.5)/fact,0.05,[num2str(REPORT(i).hourrh) '%RH'],'Color',[0.4 0.4 0.4],'FontSize',fz1-2,'HorizontalAlignment','center')
text(0.975,(fact-i-0.5)/fact,0.05,[num2str(REPORT(i).dayrh) '%RH'],'Color',[0.4 0.4 0.4],'FontSize',fz1-2,'HorizontalAlignment','center')

end

colormap(map)
fig2=sprintf('RH%s',savename);                     % gives output a unique name
NewPosition=[0 0 'PaperSize'];
orient landscape
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
if exist(['REPORT' data])==7
    cd(['REPORT' data]);
else mkdir(['REPORT' data])
    cd(['REPORT' data]);
end
print('-dtiff','-r250',fig2);
cd .. 