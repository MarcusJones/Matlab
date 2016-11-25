%
% Program name: psy1.m 
%
clear all
clc
t1=1;t2=40;  
y1=zeros(1,t2); y2=zeros(t1,t2); y3=zeros(1,t2); 
y4=zeros(1,t2); y5=zeros(1,t2);
for i=t1:t2
   y1(i)=psy(i,0,0,'pws');
end

x=t1:1:t2; % x is dry bulb temperature Tdb
subplot(2,1,1);
plot(x,y1);
xlabel('dry bulb temperature, degree C');
ylabel('saturation partial pressure, kPa');
grid on;

for i=t1:t2    
   %  i  is Tdb and y1(i) is Pws (saturated vapor pressure)
   patm=101.325; %1 atm = 101.325 kPa
   rh1=100;	y2(i)=psy(patm,y1(i),rh1,'ah');
   rh2=80;	y3(i)=psy(patm,y1(i),rh2,'ah');
   rh3=50;	y4(i)=psy(patm,y1(i),rh3,'ah');
   rh4=20;	y5(i)=psy(patm,y1(i),rh4,'ah');
end   
subplot(2,1,2);
plot(x,y2,x,y3,x,y4,x,y5);
xlabel('dry bulb temperature, degree C');
ylabel('humidity ratio, kg/kg');
legend('100%','80%','50%','20%',2);
grid on;
%pause;

%-------------------------------------------------------------------------
% given patm, Tdb, rh 
%
fprintf('\n\nGiven patm, Tdb, rh, --> derive others .............\n\n');
patm=101.325; 				%in kPa
tdb=33.95; 						% in degree C
rh=0.01;  						% in %

pws=psy(tdb,0,0,'pws'); 		% in kPa
hfg=psy(tdb,0,0,'hfg'); 			% in kJ/kg
pw=psy(pws,rh,0,'pw');  		% in kPa
ah=psy(patm,pws,rh,'ah'); 		% in kg/kg
tdp=psy(tdb,pw,0,'tdp'); 		% in degree C
h=psy(tdb,ah,0,'h'); 			% in kJ/kg
sv=psy(patm,tdb,ah,'sv'); 		% in m3/kg
dos=psy(patm,pws,rh,'dos');		% in kg/kg
twb=psy(tdb,tdp,0,'twb');		% in degree C
THI1=psy(tdb,twb,0,'THI1');
THI2=psy(tdb,tdp,0,'THI2');
DI=psy(tdb,tdp,0,'DI');

z=zeros(1,15);
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;z(13)=THI1;z(14)=THI2;z(15)=DI;

for i=1:15
   [cont,unit]=psydescription(i);
   fprintf('%s =  %10.4f  %s \n', cont, z(i),unit);
end
%pause;
%-------------------------------------------------------------------------
% given patm, Tdb, Twb 
%
fprintf('\n\nGiven patm, Tdb, Twb, --> derive others .............\n\n');

patm=101.325; 				%in kPa
tdb=30; 						% in degree C
twb=20;						% in degree C

pws=psy(tdb,0,0,'pws'); 		% in kPa
hfg=psy(tdb,0,0,'hfg'); 			% in kJ/kg
rh=psy(tdb,twb,0,'rh2');			% in %

pw=psy(pws,rh,0,'pw');  		% in kPa
ah=psy(patm,pws,rh,'ah'); 		% in kg/kg
tdp=psy(tdb,pw,0,'tdp'); 		% in degree C
h=psy(tdb,ah,0,'h'); 			% in kJ/kg
sv=psy(patm,tdb,ah,'sv'); 		% in m3/kg
dos=psy(patm,pws,rh,'dos');		% in kg/kg
%twb=psy(tdb,tdp,0,'twb');		% in degree C
THI1=psy(tdb,twb,0,'THI1');
THI2=psy(tdb,tdp,0,'THI2');
DI=psy(tdb,tdp,0,'DI');

z=zeros(1,15);
z(1)=patm; z(2)=tdb; z(3)=twb;z(4)=tdp; z(5)=rh; 
z(6)=dos;z(7)=pws; z(8)=pw;z(9)=ah; z(10)=h; 
z(11)=sv; z(12)=hfg;z(13)=THI1;z(14)=THI2;z(15)=DI;

for i=1:15
   [cont,unit]=psydescription(i);
   fprintf('%s =  %10.4f  %s \n', cont, z(i),unit);
end
%pause;
%-----------------------------------------------------------------
% given twb, rh, find tdb
%
twb=15;   % in deg.C
rh=0.01;  % in %
twbcal=999;
tdb=twb;
   if rh<100,
     while  abs(twb-twbcal)>0.05 
      	  tdb= tdb + 0.05;
	  pws=psy(tdb,0,0,'pws');
	  pw=pws*rh/100;
   	  tdp=psy(tdb,pw,0,'tdp');
          twb2=psy(tdb,tdp,0,'twb');
          twbcal=twb2;
       end
       fprintf('\nGiven twb= %5.2f C, rh= %5.2f,  derive tdb= %5.2f C \n', twb, rh,tdb);
  end
%
%-----------------------------------------------------------------
% given sv, rh, find tdb   
% 不太準，以0.0001為誤差判斷標準時，rh=0.01時尚稱準確，rh=50%or100%則誤差大。
%
%
patm=101.325;	% in kPa
sv=0.88;  		% in m3/kg
rh=100;			% in %
svcal=0;
tdb=0;
   if rh<=100,
     while  abs(sv-svcal)>0.0001
        tdb= tdb + 0.05;
        pws=psy(tdb,0,0,'pws');
        ah=psy(patm, pws,rh,'ah');
        svcal=psy(patm,tdb,ah,'sv');
      end
      fprintf('\nGiven sv= %4.2f m3/kg, rh= %5.2f, derive tdb= %5.2f C \n\n', sv, rh,tdb);

  end

%

