
%*************************************************************************************
%                              Digital Psychrometric Chart                           * 
%                                                                                    * 
%                                Main files: psy2.m                                  *
%                         Sub-files: psy.m, psydescription.m                         *
%                                                                                    * 
%                               by:   Wei Fang, Ph.D., Professor                     * 
%                   Dept. of Bio-Industrial Mechatronics Engineering                 *
%                               National Taiwan University                           *
%                                                                                    * 
%*************************************************************************************

clear all;						% clear all variables
option=1
while option~=0
   clc; 							% clear command window
   disp('Software name: Digital Psychrometric Chart (Ver. 1.2)');
   disp('developed  by: Wei Fang, Ph.D.');
   disp('               Professor'); 
   disp('               Dept. of Bio-Industrial Mechatronics Engineering');
   disp('               National Taiwan University');
   fprintf('\n');
   disp('Options: (1) Tdb, rh  (2) Tdb, Twb  (3) Tdb, Pw  (4) Tdb, ah  (5) Tdb, Tdp ');
   fprintf('Select: 0 to quit, 1:5 to run. ');  
   option=input('');
   fprintf('\n');
   if option ~=0 
      out=input(' Patm            (in kPa)= ');
      if isempty(out)
         patm=101.325;
         fprintf(' Patm            (in kPa)=%6.3f \n ', patm);

      else
         patm=out;
      end
      
	   tdb=input('Dry bulb T (in degree C)= ');
   	pws=psy(tdb,0,0,'pws'); 				% in kPa
	   hfg=psy(tdb,0,0,'hfg'); 				% in kJ/kg
      ahoftdb=psy(patm,pws,100,'ah'); 		% in kg/kg
      
      minpw=psy(pws,0.01,0,'pw');  			% rh=0.01% 
      												% pws is maxpw
      minah=psy(patm,pws,0.01,'ah'); 		% rh=0.01%
      maxah=psy(patm,pws,100,'ah'); 		% rh=100%
      mintdp=psy(tdb,minpw,0,'tdp'); 		% in degree C, maxtdp=tdb
      mintwb=psy(tdb,mintdp,0,'twb');		% in degree C, maxtwb=tdb
   end
   
	switch option
   case 1
      	fprintf(' Rel. humidity (within 0 to 100%%) = ' ); 
         rh=input('');
			pw=psy(pws,rh,0,'pw');  			% in kPa
			ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
			tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
			h=psy(tdb,ah,0,'h'); 				% in kJ/kg
			sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
			dos=psy(patm,pws,rh,'dos');		% in kg/kg
			twb=psy(tdb,tdp,0,'twb');			% in degree C
   
	case 2
   		fprintf(' Wet bulb T (within %4.2f to %4.2f degree C) = ', mintwb,tdb);
      	twb=input('');
	      rh=psy(tdb,twb,0,'rh2');
			pw=psy(pws,rh,0,'pw');  			% in kPa
			ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
			tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
			h=psy(tdb,ah,0,'h'); 				% in kJ/kg
			sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
			dos=psy(patm,pws,rh,'dos');		% in kg/kg
      
   case 3
     		fprintf(' Vapor pressure (within %6.4f to %6.4f kPa) = ',minpw,pws);
			pw=input('');
	      rh=pw/pws*100;
			ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
			tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
			h=psy(tdb,ah,0,'h'); 				% in kJ/kg
			sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
			dos=psy(patm,pws,rh,'dos');		% in kg/kg
			twb=psy(tdb,tdp,0,'twb');			% in degree C
      
	case 4
     		fprintf(' Abs. humidity (within %6.5f to %6.5f kg/kg) = ',minah,maxah);
      	ah=input('');
         pw=psy(patm,ah,0,'pw2');				% in kPa
         rh=pw/pws*100;							% in %
         tdp=psy(tdb,pw,0,'tdp'); 			% in degree C
			h=psy(tdb,ah,0,'h'); 				% in kJ/kg
			sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
			dos=psy(patm,pws,rh,'dos');		% in kg/kg
			twb=psy(tdb,tdp,0,'twb');			% in degree C
         
   case 5
   		fprintf(' Dew pt. T (within %4.2f to %4.2f degree C) = ', mintdp,tdb);
         tdp=input('');
         pw=psy(tdp,0,0,'pws'); 				% in kPa
         
         rh=pw/pws*100;
			ah=psy(patm,pws,rh,'ah'); 			% in kg/kg
			h=psy(tdb,ah,0,'h'); 				% in kJ/kg
			sv=psy(patm,tdb,ah,'sv'); 			% in m3/kg
			dos=psy(patm,pws,rh,'dos');		% in kg/kg
			twb=psy(tdb,tdp,0,'twb');			% in degree C
      
	end   % for switch(option)
  
   clc;
   disp('Software name: Digital Psychrometric Chart ver. 1.1');
   disp('developed  by: Wei Fang, Ph.D.');
   disp('               Professor'); 
   disp('               Dept. of Bio-Industrial Mechatronics Engineering');
   disp('               National Taiwan University');
   fprintf('\n');
  
  %---------------------------------------------------------------------------------------
  if option ==0 
      fprintf('\n\n');
      disp('Thank you for using this program.');
      fprintf('\n\n');
   else
      
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
%---------------------------------------------------------------------------------------
	x=t1:1:t2;
	subplot(1,1,1);
	plot(x,k2,x,k3,x,k4,x,k5,x,k6);
	axis([t1,t2,-inf,k2(t3)*1.05]);
	xlabel('dry bulb temperature, ^oC','FontWeight','Bold');
	ylabel('humidity ratio, kg/kg','FontWeight','Bold');
	title('Digital Psychrometric Chart','color',[0 0 1],'FontWeight','Bold','FontSize',18,'Fontname','Chiller');
	hold on;
	h=plot(x,k7);set(h,'linewidth',2);
%---------------------------------------------------------------------------------------
	pwsoftwb=psy(twb,0,0,'pws');
	pwsoftdb=psy(tdb,0,0,'pws');
	ahoftdb=psy(patm,pwsoftdb,100,'ah');
	ahoftwb1=psy(patm,pwsoftwb,100,'ah'); 		% in kg/kg
	ahoftwb2=psy(patm,pwsoftdb,rh,'ah');		% in kg/kg
%---------------------------------------------------------------------------------------
% given t2 as tdb and twb --> derive ahoft2
	pwsoft2=psy(t2,0,0,'pws');
	newt2=t2;rh2=0;
	while rh2<=0 					% when constant wb line did not reach t2, find newt2
   	rh2=psy(newt2,twb,0,'rh2');
	   newt2=newt2-0.1;
	end   
	ahoft2=psy(patm,pwsoft2,rh2,'ah');		% in kg/kg
%---------------------------------------------------------------------------------------
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
%if ahoftwb2 < ahoftwb1 & ahoftwb1 < ahoftdb
%   set(gca,'ytick',[ahoftwb2 ahoftwb1 ahoftdb],'XGrid','on','YGrid','on');
%else
%   set(gca,'ytick',[ahoftdb],'XGrid','on','YGrid','on');
%end
grid on;
%---------------------------------------------------------------------------------------
	line([twb newt2],[ahoftwb1 ahoft2],'linewidth',2); 	% draw const. wb line
	line([tdb],[ahoftwb2],'marker','o','linewidth',2);		% draw the assigned point
%-------------------------------------------------display calculated info.
if twb-tdp>2
	textcont=['\leftarrow' 'Twb=' num2str(twb,4)];
	text(twb,ahoftwb1,textcont,'HorizontalAlignment','left','color',[1 0 0],'FontWeight','Bold');
end
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
%---------------------------------------------------------------------------------------
	z=zeros(1,13);
	z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
	z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
	z(11)=sv; z(12)=hfg;
	%z(13)=THI1;z(14)=THI2;z(15)=DI;
%---------------------------------------------------------------------------------------
	textcont='';
	for i=1:12
   	[cont,unit]=psydescription(i);
	   fprintf('%s =  %10.5f  %s \n', cont, z(i), unit);
   	text(t1+1,k2(t3)*(1-0.04*(i-1)),cont,'HorizontalAlignment','left','color',[0 0 1]);
	   text(t1+1+t3/12,k2(t3)*(1-0.04*(i-1)),num2str(z(i),5),'HorizontalAlignment','left','color',[1 0 0]);
   	text(t1+2+t3/6,k2(t3)*(1-0.04*(i-1)),unit,'HorizontalAlignment','left','color',[0 0 1]);
	end
	hold off;
	fprintf('\n');
	disp('  Switch to Figure No. 1 for the graphical display of the Psychrometric Chart');
	fprintf('\n  Press Enter to continue.');
	pause;
	clc;
%---------------------------------------------------------------------------------------
end	% if option ~=0
end 	% for while   
%---------------------------------------------------------------------------------------
