function ex2_1
Tdb=20;% in deg.C
RH=50;% in %
pa=101.325; % in kPa

pws=psy(Tdb,0,0,'pws');% in kPa
pw=RH/100*pws;           % in kPa
W=0.62198*pw/(pa-pw);
WS=0.62198*pws/(pa-pws);

eval('clc');

fprintf('\n Ex2_1: Given');
fprintf('\n\n   Patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %',RH);
fprintf('\n\n Solution to example 2-1 of TextBook');
fprintf('\n\n   Pws =%9.2f Pa',pws*1000);
fprintf('\n   Pw  =%9.2f Pa',pw*1000);
fprintf('\n   W   =%9.5f kg vapor/kg DA',W);

fprintf('\n\n Solution to example 2-2 of TextBook');
fprintf('\n\n   Ws  =%9.5f kg vapor/kg DA',WS);

DOS=W/WS;
fprintf('\n   DOS=%9.3f %%\n ',DOS);



