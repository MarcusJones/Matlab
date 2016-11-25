%written and copyrighted by Ted Ngai www.tedngai.net 
%version 0.1 Apr 2010

%Diurnal Swing
x1 = 1:365;
dbtMax = max(dbt);
dbtMin = min(dbt);
dbtDiff = dbtMax - dbtMin;
dptMax = max(dpt);
dptMin = min(dpt);
dptDiff = dptMax - dptMin;
rhMax = max(rh);
rhMin = min(rh);
rhDiff = rhMax - rhMin;
ghradMax = max(ghrad);
ghradMin = min(ghrad);
ghradDiff = ghradMax - ghradMin;
dnradMax = max(dnrad);
dnradMin = min(dnrad);
dnradDiff = dnradMax - dnradMin;
dhradMax = max(dhrad);
dhradMin = min(dhrad);
dhradDiff = dhradMax - dhradMin;
hiradMax = max(hirad);
hiradMin = min(hirad);
hiradDiff = hiradMax - hiradMin;
wspdMax = max(wspd);
%rainMax=rainMax*0.03937;
rainMax = max(rain);
svpMax = max(svp);
svpMin = min(svp);
amvpMax = max(amvp);
amvpMin = min(amvp);
kgprkgMax = max(kgprkg);
kgprkgMin = min(kgprkg);
kgmMax = max(kgm);
kgmMin = min(kgm);
gmMax = max(gm);
gmMin = min(gm);
hcMax = max(hc);
hcMin = min(hc);
