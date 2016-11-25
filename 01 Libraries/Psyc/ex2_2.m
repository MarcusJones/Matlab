function ex2_2
Tdb=20;% in deg.C
RH=50;% in %
pa=101.325; % in kPa

pws=psy(Tdb,0,0,'pws');% in kPa
W=psy(pa,pws,RH,'ah');
WS=psy(pa,pws,100,'ah');

eval('clc');
fprintf('\n Ex2_2: Given');
fprintf('\n\n   patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %',RH);
fprintf('\n\n Solution to example 2-2 of TextBook');
fprintf('\n\n   Pws =%9.2f Pa',pws*1000);
fprintf('\n   W   =%9.5f kg vapor/kg DA',W);
fprintf('\n   Ws  =%9.5f kg vapor/kg DA',WS);
DOS=W/WS;
fprintf('\n   DOS=%9.3f %% \n',DOS);



