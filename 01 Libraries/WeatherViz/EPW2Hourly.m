%written and copyrighted by Ted Ngai www.tedngai.net 
%version 0.1 Apr 2010

%Read EPW into hourly data

x=1:8760;
x=x';

%dry bulb temperature (c)
dbt = data(:,6);
%dew point temperature (c)
dpt = data(:,7);
%relative humidity (%)
rh = data(:,8);
%horizontal infrared radiation from sky (Wh/m2)
hirad = data(:,12);
%global horizontal radiation (Wh/m2)
ghrad = data(:,13);
%direct normal radiation (Wh/m2)
dnrad = data(:,14);
%diffuse horizontal radiation (Wh/m2)
dhrad = data(:,15);
%global horizontal illuminance (lux)
ghillum = data(:,16);
%direct normal illuminance (lux)
dnillum = data(:,17);
%diffuse horizontal illuminance (lux)
dhillum = data(:,18);
%wind direction (deg)
wdir = data(:,20);
%wind speed (m/s)
wspd = data(:,21);
%sky cover (%)
skycov = data(:,22);
%rainfall (mm)
rain = data(:,28);
%aerosol optical depth (thousandths)
aerosol = data(:,29);

%calculate wetbulb temperature assuming sea level pressure 1013.25 mbar
%formula from NOAA http://www.srh.noaa.gov/epz/?n=wxcalc_rh


%the follow equations are from
%http://www.natmus.dk/cons/tp/atmcalc/atmoclc1.htm
%saturation vapour pressure, ps, in pascals
svp = 610.78*exp(dbt./(dbt+238.3)*17.2694);
%actual water vapour pressure, pa
amvp = svp.*rh/100;
%water content or absolute humidity kg/water vapour / kg dry air
kgprkg = 0.622*(10^-5)*amvp;
%water contect or absolute humidity kg/m3 dry air
kgm = 0.002167 * amvp./(dbt+273.16);
gm = 1000.*kgm;
%the enthalpy of moist air, in kJ/kg
hc = (1.007*dbt-0.026)+kgprkg.*(2501+1.84*dbt);
