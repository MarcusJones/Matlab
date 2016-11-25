function ex2_5
Tdb=20;% in deg.C
RH=50;
pa=101.325; % in kPa

pws=psy(Tdb,0,0,'pws');% in kPa
ah=psy(pa,pws,RH,'ah');
h=psy(Tdb,ah,0,'h');


eval('clc');

fprintf('\n Ex2_5: Given');
fprintf('\n\n   patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %%',RH);

fprintf('\n\n Solution to example 2-5 of TextBook');

fprintf('\n\n   h=%9.3f kJ/kg \n',h);



