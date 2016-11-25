function ex2_7
eval('clc');
patm=101.325; % in kPa

fprintf('\n  Ex2_7: \n ');

out=input('  Enter Tdb in deg.C: ');
% dry bulb T of air, in deg.C
if isempty(out)
         Tdb=20;
         fprintf(' Tdb = %6.3f deg.C\n ', Tdb);
      else
         Tdb=out;
end
out=input('   Enter RH  in % : ');
% relativehumidity, in %
if isempty(out)
         rh=50;
         fprintf('    RH = %6.3f %%\n ', rh);
      else
         rh=out;
end
out=input('   Amount of heat removed in kJ : ');
if isempty(out)
         q_remove=10;    % amount of heat removed, in kJ
         fprintf(' q_remove = %6.3f kJ\n ', q_remove);
      else
         q_remove=out;
end
out=input('   Amount of air in kg : ');
if isempty(out)
         m_air=1.2;      % amount of air, in kg
         fprintf(' m_air = %6.3f %%kg\n ', m_air);
      else
         m_air=out;
end

cp=1.006;   % specific heat, in kJ/(kg.K)
dT=-1*q_remove/(m_air*cp);
T2=Tdb+dT;
pws=psy(Tdb,0,0,'pws');
pw=rh*pws/100;
tdp=psy(Tdb,pw,0,'tdp');
ah=psy(patm,pws,rh,'ah');
h1=psy(Tdb,ah,0,'h');
if T2<=tdp,
    rh2=100;
    ah3=psy(patm,pw,rh2,'ah');
    h3=psy(tdp,ah3,0,'h');
    q_sensible=h1-h3;
    q_latent=(q_remove/m_air)-(q_sensible);
    hfg=psy(Tdb,0,0,'hfg');
    v_remove=q_latent/hfg;
    ah2=ah3-v_remove;
    pw2=psy(patm,ah2,0,'pw2'); 
    % ----------------------------------------
    T2=psy(pw2,0,0,'tsat')
    T2=psy(pw2,0,0,'tdp2')
    % either one of the equations can be used.
else
    q_sensible=q_remove/m_air;
    q_latent=0;
    pws2=psy(T2,0,0,'pws');
    rh2=pw/pws2*100;
  %  if rh2>100,rh2=100;end
end
fprintf('\nSolution to Example 2_7 and more');
fprintf('\n   Given T = %7.2f deg.C, rh=%7.2f %%, derived Tdp = %7.2f deg.C',Tdb,rh,tdp);
fprintf('\n   After removal of %7.2f kJ among %7.2f kg of air, ie. %7.2f kJ/kg',q_remove,m_air,q_remove/m_air);
if  q_latent>0,
    fprintf('\n   Amount of vapor removed: %7.2f g/kg DA, totally, %7.2f g removed.',...
        v_remove*1000,v_remove*1000*m_air);
end
fprintf('\n   q_sensible= %7.2f kJ/kg, q_latent= %7.2f kJ/kg',q_sensible,q_latent);
fprintf('\n   Final T = %7.2f deg.C, rh=%7.2f %%\n',T2,rh2);

