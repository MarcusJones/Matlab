function ex2_6
Tdb=20;% in deg.C
RH=50;% in %
pa=101.325; % in kPa

pws=psy(Tdb,0,0,'pws');% in kPa
pw=RH/100*pws;           % in kPa
tdp=psy(Tdb,pw,0,'tdp');
twb=psy(Tdb,tdp,0,'twb');
twb2=psy(Tdb,pw,pa,'twb2');
eval('clc');

fprintf('\n Ex2_6: Given');
fprintf('\n\n   Patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %',RH);

fprintf('\n\n Solution to example 2-6 of TextBook');
fprintf('\n\n   Twb =%9.3f deg.C using regression equation ',twb);
fprintf('\n   Twb =%9.3f deg.C using iteration algorithm \n',twb2);

%--------------------------
pa=89.874; % in kPa  Elevation at 1000 m

pws=psy(Tdb,0,0,'pws');% in kPa
pw=RH/100*pws;           % in kPa
tdp=psy(Tdb,pw,0,'tdp');
twb=psy(Tdb,tdp,0,'twb');
twb2=psy(Tdb,pw,pa,'twb2');

fprintf('\n Ex2_6: Given');
fprintf('\n\n   Patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %',RH);

fprintf('\n\n Solution to example 2-6 of TextBook');
fprintf('\n\n   Twb =%9.3f deg.C using regression equation ',twb);
fprintf('\n   Twb =%9.3f deg.C using iteration algorithm \n',twb2);
fprintf('\n The regression equation is only good for conditions at sea level, i.e. Patm = 101.325 kPa \n');





