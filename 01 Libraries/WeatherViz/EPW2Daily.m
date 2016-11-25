%written and copyrighted by Ted Ngai www.tedngai.net 
%version 0.1 Apr 2010

%Read EPW into daily

t = 1:24;
d = 1:365;
[x,y]=meshgrid(d,t);
%dry bulb temperature (c)
dbt = reshape(dbt,24,365);
%dew point temperature (c)
dpt = reshape(dpt,24,365);
%relative humidity (%)
rh = reshape(rh,24,365);
%horizontal infrared radiation from sky (Wh/m2)
hirad = reshape(hirad,24,365);
%global horizontal radiation (Wh/m2)
ghrad = reshape(ghrad,24,365);
%direct normal radiation (Wh/m2)
dnrad = reshape(dnrad,24,365);
%diffuse horizontal radiation (Wh/m2)
dhrad = reshape(dhrad,24,365);
%global horizontal illuminance (lux)
ghillum = reshape(ghillum,24,365);
%direct normal illuminance (lux)
dnillum = reshape(dnillum,24,365);
%diffuse horizontal illuminance (lux)
dhillum = reshape(dhillum,24,365);
%wind direction (deg)
wdir = wdir*pi/180;
%wind speed (m/s)
wspd = reshape(wspd,24,365);
%sky cover (%)
skycov = reshape(skycov,24,365);
%rainfall (mm)
rain = reshape(rain,24,365);
%aerosol optical depth (thousandths)
aerosol = reshape(aerosol,24,365);

%the follow equations are from
%http://www.natmus.dk/cons/tp/atmcalc/atmoclc1.htm
%saturation vapour pressure, ps, in pascals
svp = reshape(svp,24,365);
%actual water vapour pressure, pa
amvp = reshape(amvp,24,365);
%water content or absolute humidity kg/water vapour / kg dry air
kgprkg = reshape(kgprkg,24,365);
%water contect or absolute humidity kg/m3 dry air
kgm = reshape(kgm,24,365);
gm = reshape(gm,24,365);
%the enthalpy of moist air, in kJ/kg
hc = reshape(hc,24,365);

