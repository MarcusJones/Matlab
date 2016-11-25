function PSchart
   global patm
   global rh
   global tdb

pws=psy(tdb,0,0,'pws'); 			% in kPa
%hfg=psy(tdb,0,0,'hfg'); 				% in kJ/kg
pw=psy(pws,rh,0,'pw');  			% in kPa
ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
%ahoftdb=psy(patm,pws,100,'ah'); 	% in kg/kg
tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
%h=psy(tdb,ah,0,'h'); 				% in kJ/kg
sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
%dos=psy(patm,pws,rh,'dos');			% in kg/kg
twb=psy(tdb,tdp,0,'twb');			% in degree C
%THI1=psy(tdb,twb,0,'THI1');
%THI2=psy(tdb,tdp,0,'THI2');
%DI=psy(tdb,tdp,0,'DI');

t1=round(tdp);     			% lower limit of the X axis, an integer number
t2=round(tdb)+10;					% upper limit of the X axis
t3=t2-t1+1;
k1=zeros(1,t3); k2=zeros(1,t3); k3=zeros(1,t3); k4=zeros(1,t3);k5=zeros(1,t3);k6=zeros(1,t3);
k7=zeros(1,t3);
for k=1:t3  				% draw the psy-chart with rh curves
  i=t1+k-1;
  %  In here,  i  is Tdb and k1(k) is Pws (saturated vapor pressure)
  k1(k)=psy(i,0,0,'pws');
  k2(k)=psy(patm,k1(k),100,'ah');
  k3(k)=psy(patm,k1(k),80,'ah');
  k4(k)=psy(patm,k1(k),60,'ah');
  k5(k)=psy(patm,k1(k),40,'ah');
  k6(k)=psy(patm,k1(k),20,'ah');
  k7(k)=psy(patm,k1(k),rh,'ah');     % user assigned rh curve
end
  %-----------------------------------------------
x=t1:1:t2;
subplot(1,1,1);
plot(x,k2,x,k3,x,k4,x,k5,x,k6);
axis([t1,t2,-inf,k2(t3)*1.05]);
xlabel('dry bulb temperature, ^oC','FontWeight','Bold');
ylabel('humidity ratio, kg/kg','FontWeight','Bold');
title('Digital Psychrometric Chart','color',[0 0 1],'FontWeight','Bold','FontSize',18,'Fontname','Chiller');
hold on;
h=plot(x,k7);set(h,'linewidth',2);

%-------------------------------------------------
pwsoftwb=psy(twb,0,0,'pws');
pwsoftdb=psy(tdb,0,0,'pws');
ahoftdb=psy(patm,pwsoftdb,100,'ah');
ahoftwb1=psy(patm,pwsoftwb,100,'ah'); 		% in kg/kg
ahoftwb2=psy(patm,pwsoftdb,rh,'ah');		% in kg/kg
% given t2 as tdb and twb --> derive ahoft2
pwsoft2=psy(t2,0,0,'pws');
newt2=t2;rh2=0;
while rh2<=0 
   rh2=psy(newt2,twb,0,'rh2');
   newt2=newt2-0.1;
end   
ahoft2=psy(patm,pwsoft2,rh2,'ah');		% in kg/kg
%----------------------------------------------------------------------------------
%given sv, rh=100% find tdb1
newtdb1=tdb; svnew1=0;
while abs(svnew1-sv)>0.001
   newtdb1=newtdb1-0.1;
   pwsofsv1=psy(newtdb1,0,0,'pws');
   ahofsv1=psy(patm,pwsofsv1,100,'ah'); 	
   svnew1=psy(patm,newtdb1,ahofsv1,'sv');
end
%given sv, rh=0.01% find tdb2
newtdb2=tdb; svnew2=0;
while abs(svnew2-sv)>0.001
   newtdb2=newtdb2+0.1;
   pwsofsv2=psy(newtdb2,0,0,'pws');
   ahofsv2=psy(patm,pwsofsv2,0.01,'ah'); 	
   svnew2=psy(patm,newtdb2,ahofsv2,'sv'); 
end
%-----------------------------------------------draw const. sv line
line([newtdb1 newtdb2],[ahofsv1 ahofsv2],'linewidth',2);  
textcont=['\leftarrow' 'SV=' num2str(sv,4)];
text(newtdb1,ahofsv1,textcont,'HorizontalAlignment','left','color',[1 0 0],'FontWeight','Bold');
%-----------------------------------------------draw const. Tdb line
line([tdb tdb],[0 ahoftdb],'linewidth',2);  
textcont=['Tdb=' num2str(tdb,4) '\rightarrow' ];
text(tdb,0,textcont,'HorizontalAlignment','right','color',[1 0 0],'FontWeight','Bold');
%-------------------------------------------------draw const. absolute humidity line
%set(gca)
set(gca,'ytick',[ahoftwb2 ahoftwb1 ahoftdb],'XGrid','on','YGrid','on');
%grid on;
%-------------------------------------------------
line([twb newt2],[ahoftwb1 ahoft2],'linewidth',2); 	% draw const. wb line
line([tdb],[ahoftwb2],'marker','o','linewidth',2);		% draw the assigned point
%-------------------------------------------------display calculated info.
textcont=['\leftarrow' 'Twb=' num2str(twb,4)];
text(twb,ahoftwb1,textcont,'HorizontalAlignment','left','color',[1 0 0],'FontWeight','Bold');
textcont=['\leftarrow' 'Tdp=' num2str(tdp,4)];
text(tdp,ahoftwb2,textcont,'HorizontalAlignment','left','color',[1 0 0],'FontWeight','Bold');
textcont=['RH=' num2str(rh) '%\rightarrow'];
text(t2,k7(t3),textcont,'HorizontalAlignment','right','color',[1 0 0],'FontWeight','Bold');
%-------------------------------------------------display rh
textcont=['100%\rightarrow'];
text(t2,k2(t3),textcont,'HorizontalAlignment','right','color',[0 0 0],'FontWeight','Bold');
textcont=['80%\rightarrow'];
text(t2,k3(t3),textcont,'HorizontalAlignment','right','color',[0 0 0],'FontWeight','Bold');
textcont=['60%\rightarrow'];
text(t2,k4(t3),textcont,'HorizontalAlignment','right','color',[0 0 0],'FontWeight','Bold');
textcont=['40%\rightarrow'];
text(t2,k5(t3),textcont,'HorizontalAlignment','right','color',[0 0 0],'FontWeight','Bold');
textcont=['20%\rightarrow'];
text(t2,k6(t3),textcont,'HorizontalAlignment','right','color',[0 0 0],'FontWeight','Bold');
%------------------------------------------------- display Pw
text(t2+0.1,k2(t3)*1.05,'Pw,kPa','HorizontalAlignment','left','FontWeight','Bold');
textcont=num2str(k1(t3));
text(t2,k2(t3),textcont,'HorizontalAlignment','left');
textcont=num2str(k1(t3)*0.8);
text(t2,k3(t3),textcont,'HorizontalAlignment','left');
textcont=num2str(k1(t3)*0.6);
text(t2,k4(t3),textcont,'HorizontalAlignment','left');
textcont=num2str(k1(t3)*0.4);
text(t2,k5(t3),textcont,'HorizontalAlignment','left');
textcont=num2str(k1(t3)*0.2);
text(t2,k6(t3),textcont,'HorizontalAlignment','left');
textcont=num2str(k1(t3)*rh/100);
text(t2,k7(t3),textcont,'HorizontalAlignment','left');

textcont=num2str(pw);
text(t2,ah,textcont,'HorizontalAlignment','left','color',[1 0 0],'FontWeight','Bold');

hold off;
