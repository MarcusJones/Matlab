%% Expand EPW data
%written and copyrighted by Ted Ngai www.tedngai.net 
%version 0.1 Apr 2010

%Read EPW into hourly data

hoursVec=1:8760;
hoursVec=hoursVec';

%dry bulb temperature (c)
epwExpanded.dbt = epw.data(:,6);
%dew point temperature (c)
epwExpanded.dpt = epw.data(:,7);
%relative humidity (%)
epwExpanded.rh = epw.data(:,8);
%horizontal infrared radiation from sky (Wh/m2)
epwExpanded.hirad = epw.data(:,12);
%global horizontal radiation (Wh/m2)
epwExpanded.ghrad = epw.data(:,13);
%direct normal radiation (Wh/m2)
epwExpanded.dnrad = epw.data(:,14);
%diffuse horizontal radiation (Wh/m2)
epwExpanded.dhrad = epw.data(:,15);
%global horizontal illuminance (lux)
epwExpanded.ghillum = epw.data(:,16);
%direct normal illuminance (lux)
epwExpanded.dnillum = epw.data(:,17);
%diffuse horizontal illuminance (lux)
epwExpanded.dhillum = epw.data(:,18);
%wind direction (deg)
epwExpanded.wdir = epw.data(:,20);
%wind speed (m/s)
epwExpanded.wspd = epw.data(:,21);
%sky cover (%)
epwExpanded.skycov = epw.data(:,22);
%rainfall (mm)
epwExpanded.rain = epw.data(:,28);
%aerosol optical depth (thousandths)
epwExpanded.aerosol = epw.data(:,29);

%calculate wetbulb temperature assuming sea level pressure 1013.25 mbar
%formula from NOAA http://www.srh.noaa.gov/epz/?n=wxcalc_rh


%the follow equations are from
%http://www.natmus.dk/cons/tp/atmcalc/atmoclc1.htm
%saturation vapour pressure, ps, in pascals

epwExp.data = [];
epwExp.header = {};

epwExpanded.svp = 610.78*exp(epwExpanded.dbt./(epwExpanded.dbt+238.3)*17.2694);
epwExp.data = [epwExp.data epwExpanded.svp];
epwExp.header = [epwExp.header 'svp'];

%actual water vapour pressure, pa
epwExpanded.amvp = epwExpanded.svp.*epwExpanded.rh/100;
epwExp.data = [epwExp.data epwExpanded.amvp];
epwExp.header = [epwExp.header 'amvp'];

%water content or absolute humidity kg/water vapour / kg dry air
epwExpanded.kgprkg = 0.622*(10^-5)*epwExpanded.amvp;
epwExp.data = [epwExp.data epwExpanded.kgprkg];
epwExp.header = [epwExp.header 'kgprkg'];

%water contect or absolute humidity kg/m3 dry air
epwExpanded.kgm = 0.002167 * epwExpanded.amvp./(epwExpanded.dbt+273.16);
epwExp.data = [epwExp.data epwExpanded.kgm];
epwExp.header = [epwExp.header 'kgm'];

epwExpanded.gm = 1000.*epwExpanded.kgm;
epwExp.data = [epwExp.data epwExpanded.gm];
epwExp.header = [epwExp.header 'gm'];

%the enthalpy of moist air, in kJ/kg
epwExpanded.hc = (1.007*epwExpanded.dbt-0.026)+epwExpanded.kgprkg.*(2501+1.84*epwExpanded.dbt);
epwExp.data = [epwExp.data epwExpanded.hc];
epwExp.header = [epwExp.header 'hc'];


epwExp.units = {}
for i = 1:size(epwExp.data,2)
    epwExp.units = [epwExp.units '-'];
end

clearvars -except sched epw epwExp


display(sprintf(' - Expanded EPW Weather'))

