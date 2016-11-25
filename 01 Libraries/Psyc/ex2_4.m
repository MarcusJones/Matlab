function ex2_4
Tdb=20;% in deg.C
RH=50;% in %
pa=101.325; % in kPa

pws=psy(Tdb,0,0,'pws');% in kPa
pw=RH/100*pws;           % in kPa
tdp=psy(Tdb,pw,0,'tdp');

eval('clc');

fprintf('\n Ex2_4: Given');
fprintf('\n\n   patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %%',RH);

fprintf('\n\n Solution to example 2-4 of TextBook');

fprintf('\n\n   Tdp=%9.3f deg.C \n',tdp);



