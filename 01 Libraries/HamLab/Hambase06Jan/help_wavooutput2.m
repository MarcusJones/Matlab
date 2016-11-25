%
%                WAVO  OUTPUT
%      
% ---------------------------------------------------------------------------------
%
% Output.Tcom:  'operative' indoor temperature;
% Output.Tx:    fictive temperature for transmission heat loss;
% Output.RHa:   relative indoor humidity;
% Output.Ta:    indoor air temperature;
% Output.Tr:    mean radiant temperature;
% Output.Qplant:    hourly energy use in Wh, positive 'heating', negative 'cooling' ;
% Output.Gplant:    hourly energy use for latent cooling Wh;
% Output.Trans: hourly transmission heat loss in Wh;
% Output.Vent:  hourly ventilation heat loss in Wh;
% Output.Zon:   hourly solar energy released indoors in Wh;
% Output.Qint:  casual gains [W]
% Output.Gint:  vapour production [kg/s];  
% Output.figain: hourly total heat gains: solar+casual Wh;
% Output.Tw:    mean wall interior surface temperature (glazings excluded);
% Output.RHw:   mean relative humidity at the wall surface;
% Output.Tglas: mean interior surface temperature of glazing;
% Output.Transglas: hourly conduction heat loss by glazingin Wh;
% Output.Cx1: 1 Heat capacitance of room (see wavodoc)[W/sK];
% Output.Cx2: 2 Heat capacitance of room [W/sK];
% Output.Lnr: atmospheric radiation on surface with oriennr [W/m2] (see wavofun);
% Output.Enr: solar radiation on surface with oriennr  [W/m2] (see wavofun);
%
% InBuil.oriennr: orID for Output.Lnr and Output.Enr
%
% The file InClimate.kli contains the hourly values of the weather data for the
%   whole calculation period.
%
% InClimate.kli(:,1): Diffuse solar radiation [W/m2];
% InClimate.kli(:,2): 10*air temperature outside;
% InClimate.kli(:,3): Direct solar radiation (plane normal to the direction)[W/m2];
% InClimate.kli(:,4): cloud cover 1...8;
% InClimate.kli(:,5): 100*relative humidity outside;
% InClimate.LAT: latitude;
% InClimate.SMLON: difference local longitude and Local Standard time Meridian;
% InClimate.gref: albedo of environment;
% InClimate.idag1: %number of days preceeding the calculation date with Sunday 1jan 1968 ,0h
% InClimate.date: year,month,day,weekday(1==Monday),hour (when daylight-savings
%  time starts hour=24 is followed by hour=2 and when it ends there are two times an hour=1
% InClimate.aantaldagen: number of days calculated;
% InClimate.nin; number of extra days calculated before starting the calculation period
%
% If the climate file is mt1970(:,:)then: InClimate.kli=mt1970(:,[1,2,3,9,6])
%
% The file Profiles contains the hourly values of the profiles for each
% zone of the whole calculation period
%
% Profiles.periode(zone,hour): period 1, 2, 3, etc (see BASE file)   
% Profiles.Ersu(zone,hour):irradiance level for sun blinds [W/m2]
% Profiles.vvminu(zone,hour): the ventilation [1/hr]
% Profiles.vvmaxu(zone,hour): the ventilation [1/hr] in case free cooling
% Profiles.Tvsu(zone,hour): treshold [oC] for free cooling, for each period
% Profiles.Tsetu(zone,hour): setpoint [oC] switch for heating
% Profiles.Tsetmaxu(zone,hour): setpoint [oC] switch for cooling
% Profiles.Qintu(zone,hour): casual heat gains [W]
% Profiles.Gintu(zone,hour): moisture gains [kg/s]
% Profiles.rvminu(zone,hour): setpoint [%] switch humidification
% Profiles.rvmaxu(zone,hour): setpoint [%] switch dehumidification
%
% Control.etainst: overall efficiency (%) of heating system, default value 72
% InBuil.zone : zonenr.
% InBuil.Linkv: airflows (m3/h) Linkv(j,i):from zone i to -->zone j
%
%
% matprop = matpropf(l,matnr);
%
% l     = thickness (meter)
% matnr = number of the material (see below) matprop= [thickness,heat
% conductivity,density,heat capacity,emmissivity,diffusion resistance
%    factor,vapour capacity*10^7] 
%       or [l,lambda,rho,C,eps,mu,ksi,bv.10^7].
% In case of an air cavity (matnr=2 or 3 or 4) the heat conductivity is
% calculated with lambda=thickness/Rcav 
% The surface resistances for vapour transfer (m2s/kg) are calculated in hambasefun
% with the Lewis-relation from Ri and Re. They can be changed: con{ctyp}.Zvi
% and con{ctyp}.Zve. This might be necessary if there is a vapourtight 
% coating (Zv is larger) or if the surface is very irregular (Zv is smaller)  
%
% Profiles can be changed for each hour of the calculation period. A m-file
% that can be used for this is given in the text of this help-file.
if 1==0
    % The property names of the changed values end with 'ch' 
    % E.g. maandch=1;dagch=11; zonech=1; Tsetuch from 12 till 17 hour =19C ;
    k=find(InClimate(:,2)==maandch&InClimate(:,3)==dagch&(InClimate(:,5)>12&InClimate(:,5)<=17));
    Profiles.Tsetu(zonech,k)=Tsetuch;
end

help help_wavooutput2