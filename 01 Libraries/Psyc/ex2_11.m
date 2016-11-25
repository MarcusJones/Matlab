% Program name: ex2_11.m  (p.29 of Textbook)
% Related subprograms: psy.m
clear all
clc
patm=101.325; %1 atm = 101.325 kPa
tdb=[5, 20];        %in degC
rh=[80,50];         %in %
vol=[0.2, 0.8];     %in m^3/s
for i=1:1:2
    pws(i)=psy(tdb(i),0,0,'pws');       %Pws (saturated vapor pressure)
    hfg=psy(tdb(i),0,0,'hfg'); 			% in kJ/kg
    ah(i)=psy(patm,pws(i),rh(i),'ah'); 	% in kg/kg
    h(i)=psy(tdb(i),ah(i),0,'h'); 		% in kJ/kg
    sv(i)=psy(patm,tdb(i),ah(i),'sv'); 	% in m^3/kg
    mflow(i)=vol(i)/sv(i);              % in kg/s
end  
ah3=(mflow(1)*ah(1)+mflow(2)*ah(2))/(mflow(1)+mflow(2));
tdb3=(mflow(1)*tdb(1)+mflow(2)*tdb(2))/(mflow(1)+mflow(2));
h3a=(mflow(1)*h(1)+mflow(2)*h(2))/(mflow(1)+mflow(2));
pws3=psy(tdb3,0,0,'pws');
pw3=psy(patm,ah3,0,'pw2');
rh3=psy(pw3,pws3,0,'rh');

tdp3=psy(tdb3,pw3,0,'tdp'); 
h3b=psy(tdb3,ah3,0,'h'); 
sv3=psy(patm,tdb3,ah3,'sv'); 	
twb3=psy(tdb3,tdp3,0,'twb');
twb3b=psy(tdb3,pw3,patm,'twb2');

vol3=sv3*(mflow(1)+mflow(2));   % in m^3/s
disp('Ex2_11, 12. (p.29 of Textbook)');fprintf('\n');
disp('given:');
fprintf('  tdb_1  =  %10.5f, tdb_2  =   %10.5f    deg.C \n',tdb(1),tdb(2));
fprintf('  rh_1   =  %10.5f, rh_2   =   %10.5f    %% \n',rh(1),rh(2));
fprintf('  vol_1  =  %10.5f, vol_2  =   %10.5f    m^3/s \n\n',vol(1),vol(2));
disp('Derive:');
fprintf('  W_1    =  %10.5f, W_2    =   %10.5f    kg/kgDA \n',ah(1),ah(2));
fprintf('  h_1    =  %10.5f, h_2    =   %10.5f    kJ/kgDA \n',h(1),h(2));
fprintf('  sv_1   =  %10.5f, sv_2   =   %10.5f    m^3/kgDA \n',sv(1),sv(2));
fprintf('  mflow_1=  %10.5f, mflow_2=   %10.5f    kg/s \n\n',mflow(1),mflow(2));   
disp('After mixing:');
fprintf('  Tdb_3  =  %10.5f  deg.C (calculated from mixing)\n',tdb3); 
fprintf('  Twb_3  =  %10.5f  deg.C (using regression eq.), %10.5f deg.C (using iteration algorithm) \n',twb3, twb3b); 
fprintf('  Tdp_3  =  %10.5f  deg.C \n',tdp3); 
fprintf('  rh_3   =  %10.5f  %% \n',rh3); 
fprintf('  ah_3   =  %10.5f  kg/kg (calculated from mixing)\n',ah3); 
fprintf('  sv_3   =  %10.5f  m^3/kgDA \n',sv3); 
fprintf('  dsty_3 =  %10.5f  kgDA/m^3 \n',1/sv3); 
fprintf('  h_3a   =  %10.5f  kJ/kg (calculated from mixing) \n',h3a); 
fprintf('  h_3b   =  %10.5f  kJ/kg (calculated from equations)\n',h3b); 
fprintf('  vol_3  =  %10.5f  m^3/s \n\n',vol3); 
