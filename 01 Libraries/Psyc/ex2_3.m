function ex2_3
Tdb=20;% in deg.C
RH=50;% in %
pa=101.325; % in kPa

pws=psy(Tdb,0,0,'pws');% in kPa
ah=psy(pa,pws,RH,'ah');
sv=psy(pa,Tdb,ah,'sv');

header(Tdb,RH,pa);

fprintf('\n\n Solution: ');
fprintf('\n\n   sv =%9.2f m3/kg \n',sv);
end

function header(Tdb,RH,pa)
eval('clc');
fprintf('\n Ex2_3: Given');
fprintf('\n\n   Patm =%10.3f kPa',pa);
fprintf('\n   Tdb =%10.2f deg.C',Tdb);
fprintf('\n   RH  =%10.2f %',RH);

end 

