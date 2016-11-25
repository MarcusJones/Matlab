% Filename: Table2_2.m (p.20 of Textbook)
% Related subprograms: psy.m, psydescription.m 
% given patm, Tdb, rh 
%
function Table2_2
clear 
clc

P=[101.325  101.325  101.325  89.874  89.874  61.64]; %in kPa
T=[20 20 -10 10  20 20];      								% in deg.C
R=[50 80 50 20 50 50 ];        								% in %  


for i=1:1:6;

tdb=T(i); patm=P(i);  rh=R(i);

fprintf('\n\nGiven patm, Tdb, rh, --> derive others .............\n\n');    
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
end
