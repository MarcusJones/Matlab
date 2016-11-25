% Program name: ex2_13.m (p.32 of Textbook)
% Related subprogram: psy.m
% Tdb1 is dry bulb temperature of outdoor environment
% Tdb2=Twb1 is wet bulb temperature of outdoor environment
% Tdb3 is dry bulb temperature after pad
%
clear all
clc
patm=101.325;   % 1 atm = 101.325 kPa
tdb1=35;         % in degC
rh1=25;          % in %
eff=75;         % in %

pws1=psy(tdb1,0,0,'pws');       %Pws (saturated vapor pressure)
pw1=psy(pws1,rh1,0,'pw');  		% in kPa
ah1=psy(patm,pws1,rh1,'ah'); 		% in kg/kg
tdp1=psy(tdb1,pw1,0,'tdp'); 		% in degree C
h1=psy(tdb1,ah1,0,'h'); 			% in kJ/kg
sv1=psy(patm,tdb1,ah1,'sv'); 		% in m3/kg
twb1=psy(tdb1,tdp1,0,'twb');		% in degree C
twb1b=psy(tdb1,pw1,patm,'twb2');

tdb2=twb1;  rh2=100;
twb2=twb1;twb3=twb1;

twb2b=twb1b;twb3b=twb1b;

tdp2=twb1;
pws2=psy(tdb2,0,0,'pws');       %Pws (saturated vapor pressure)
pw2=pws2;
ah2=psy(patm,pws2,rh2,'ah'); 		% in kg/kg

wbd=tdb1-twb1;
tdb3=tdb1-eff*wbd/100;       % tdb3: tdb after pad
ah3=ah1+(ah2-ah1)*eff/100;
tdp3a=tdp1+(tdp2-tdp1)*eff/100;
pw3a=pw1+(pw2-pw1)*eff/100;
pws3=psy(tdb3,0,0,'pws');
pw3b=psy(patm,ah3,0,'pw2');
rh3=psy(pw3b,pws3,0,'rh');
tdp3b=psy(tdb3,pw3b,0,'tdp'); 
h3=psy(tdb3,ah3,0,'h'); 
sv3=psy(patm,tdb3,ah3,'sv'); 	

del_ah=ah3-ah1;
del_ah_vol=del_ah/sv3;

disp('Ex2_13, 14. (p.32 of Textbook)');fprintf('\n');
disp('define point 1: outdoor environment ');
disp('       point 2: outdoor wet bulb point ');
disp('       point 3: after pad point ');;fprintf('\n');
disp('Given:');
fprintf('  patm   =  %10.5f kPa \n',patm);
fprintf('  tdb_1  =  %10.5f deg.C \n',tdb1);
fprintf('  rh_1   =  %10.5f %% \n',rh1);
fprintf('  eff.   =  %10.2f %% (pad efficiency) \n\n',eff);
disp('Derive');
fprintf('  Tdb_1  =  %10.5f, Tdb_2  =  %10.5f  deg.C \n',tdb1,tdb2); 
fprintf('  Twb_1  =  %10.5f, Twb_2  =  %10.5f  deg.C (using regression eq.) \n',twb1,twb2); 
fprintf('  Twb_1  =  %10.5f, Twb_2  =  %10.5f  deg.C (using iteration algorithm) \n',twb1b,twb2b); 
fprintf('  Tdp_1  =  %10.5f, Tdp_2  =  %10.5f  deg.C \n',tdp1,tdp2); 
fprintf('  rh_1   =  %10.5f, rh_2   =  %10.5f  %% \n',rh1,rh2); 
fprintf('  pw_1   =  %10.5f, pw_2   =  %10.5f  kPa \n',pw1,pw2); 
fprintf('  ah_1   =  %10.5f, ah_2   =  %10.5f  Pa \n\n',ah1,ah2); 

disp('After pad:');
fprintf('  Tdb_3  =  %10.5f  deg.C \n',tdb3); 
fprintf('  Twb_3  =  %10.5f  deg.C (using regression eq.), %10.5f deg.C (using iteration algorithm) \n',twb3,twb3b); 
fprintf('  pw_3a  =  %10.5f  kPa (calculated from efficiency)\n',pw3a); 
fprintf('  pw_3b  =  %10.5f  kPa (calculated from equations)\n',pw3b); 
fprintf('  Tdp_3a =  %10.5f  deg.C (calculated from efficiency)\n',tdp3a); 
fprintf('  Tdp_3b =  %10.5f  deg.C (calculated from equations)\n',tdp3b); 
fprintf('  rh_3   =  %10.5f  %% \n',rh3); 
fprintf('  ah_3   =  %10.5f  kg/kg (calculated from efficiency)\n',ah3); 
fprintf('  sv_3   =  %10.5f  m^3/kgDA \n',sv3); 
fprintf('  dsty_3 =  %10.5f  kgDA/m^3 \n',1/sv3); 
fprintf('  h_3    =  %10.5f  kJ/kg \n\n',h3); 
disp('Amount of water need to be added:');
fprintf('  del_ah     =  %10.5f  kg/kgDA\n',del_ah);
fprintf('  del_ah_vol =  %10.5f  kg/m^3DA\n\n',del_ah_vol);
