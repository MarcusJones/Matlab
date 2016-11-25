%
% Program name: thi_chart.m  
% Related subprograms: pschart.m and psy.m
%
global patm
global rh
global tdb

patm=101.325; %1 atm = 101.325 kPa
tdb=30;
rh=50;

h1=findobj('tag','CHART');  close(h1);
figure('tag','CHART','Resize','on','MenuBar','none',...
   'Name','Digital Psychrometric Chart','NumberTitle','off',...
   'Position',[100,100,520,420]);

pschart;
hold on;

thi=[60 65,70,75,80,85,90]; 
%THI2 = tdb + .36 *tdp + 41.2;   %... eq. from ASAE STANDARD
% find 1st point given tdb=tdp and rh=100%
tdb1=(thi-41.2)/1.36;
rh=100;
for i=1:1:length(thi)
	pwsoftdb1(i)=psy(tdb1(i),0,0,'pws');
	ahoftdb1(i)=psy(patm,pwsoftdb1(i),rh,'ah');
end
%
% find 2nd point, assuming Pw2=0.2 kPa, looking for Tdb2
%
pw2=0.2;
tdb2=zeros(1,length(thi));
for xi=1:1:length(thi)
   if xi>1,x=tdb2(i-1);else x=15;end
   while x<=80
	tdp2=psy(x,pw2,0,'tdp');
   tdp_target=(thi(xi)-x-41.2)/0.36;
   delt_tdp=abs(tdp2-tdp_target);
   if delt_tdp<=0.1, 
      tdb2(xi)=x;
%      fprintf('i=%2.0f, thi =%3.0f delt_tdp=%5.2f \n',xi,thi(xi),delt_tdp);
   end
   x=x+0.1;
	end   
end
for i=1:1:length(thi)
	ahoftdb2(i)=0.62198*pw2/(patm-pw2);
   h=line([tdb1(i),tdb2(i)],[ahoftdb1(i),ahoftdb2(i)]);

   if i==1, set(h,'Color',[1 0 0],'Linewidth',3);end
   if i==2, set(h,'Color',[0 1 0],'Linewidth',3);end
   if i==3, set(h,'Color',[0 0 1],'Linewidth',3);end
   if i==4, set(h,'Color',[0 1 1],'Linewidth',3);end
   if i==5, set(h,'Color',[0.3 1 0],'Linewidth',3);end
   if i==6, set(h,'Color',[0 0 0],'Linewidth',3);end
   if i==7, set(h,'Color',[0 0.1 0.3],'Linewidth',3);end
   
   if i>2, 
      thival=['THI=',num2str(thi(i)),'\rightarrow' ];
      text(tdb1(i),ahoftdb1(i),thival,'HorizontalAlignment','right',...
         'color',[0 0 0],'FontWeight','Bold');
   else
      thival=['\leftarrow','THI=',num2str(thi(i))];
      text(tdb2(i),ahoftdb2(i),thival,'HorizontalAlignment','left',...
         'color',[0 0 0],'FontWeight','Bold');
   end

end

