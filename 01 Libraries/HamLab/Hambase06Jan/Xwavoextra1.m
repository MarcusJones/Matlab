%dec2004
% Het uur kan in meerdere ('interhour') tijdsintervallen verdeeld worden: 
InClimate.interhour=1;
%--------------------------------------------------------------------------
%                WAVO  OUTPUT 
% ---------------------------------------------------------------------------------

% Rij: 1 tot (aantal uren) x interhour, Kolom: 1 tot aantal zones
%  
% Output.Tcom:  'operative' indoor temperature;
% Output.Tx:    fictive temperature for transmission heat loss;
% Output.RHa:   relative indoor humidity;
% Output.Ta:    indoor air temperature;
% Output.Qplant:    hourly energy use in Wh, positive 'heating', negative 'cooling' ;
% Output.Gplant:    hourly energy use for latent cooling Wh;
% Output.Trans: hourly transmission heat loss in Wh;
% Output.Vent:  hourly ventilation heat loss in Wh;
% Output.Zon:   hourly solar energy released indoors in Wh;
% Output.Qint:  casual gains [W]
% Output.Gint:  vapour production [kg/s];  
% Output.Twflh1: surface temperature floor heating
% Output.RHwflh1: surface relative humidity floor heating
% Output.Tset:  set temperature (changes when hygrostatic control);
%
% oppervlakte condities: 1 en 2 en i en e binnen en buitenopp
% Rij: 1 tot (aantal uren) x interhour, Kolom: 1 tot aantal wanden
% Output.Twall1(nninter,:)=Twall1;
% Output.RHwall1(nninter,:)=rvwall1;
% Output.Twall2(nninter,:)=Twall2;
% Output.RHwall2(nninter,:)=rvwall2;
% Rij: 1 tot (aantal uren) x interhour, Kolom: 1 tot aantal ramen
% Output.Twindowi(nninter,:)=Twdowi;
% Output.RHwindowi(nninter,:)=rvwindowi;
% Output.Twindowe(nninter,:)=Twdowe;
% Output.RHwindowe(nninter,:)=rvwindowe;
%
% Rij: 1 tot (aantal uren) x interhour, Kolom: 1 tot aantal orientaties
% Output.Lnr: atmospheric radiation on surface with oriennr [W/m2];
% Output.Enr: solar radiation on surface with oriennr  [W/m2];
%
% Output.U=Building.U;
% InBuil.oriennr: orID for Output.Lnr and Output.Enr
%
% The file InClimate.kli contains the hourly values of the weather data for the
%   whole calculation period.
%
% InClimate.kli(:,1:5)=mt'year'(:,[1 2 3 9 6]) 
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
% InClimate.nin; number of inslinger' days
% InClimate.interhour; subdivision of an hour (niet voor wavo) 
%
%
% The file Profiles contains the hourly values of the profiles for each
% zone of the whole calculation period and the 
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
%
%
% Profiles can be changed for each hour of the calculation period. A m-file
% that can be used for this is given in the text of this help-file.
if 1==0
    % The property names of the changed values end with 'ch' 
    % E.g. maandch=1;dagch=11; zonech=1; Tsetuch from 12 till 17 hour =19C ;
    k=find(InClimate.date(:,2)==maandch&InClimate.date(:,3)==dagch&(InClimate.date(:,5)>12&InClimate.date(:,5)<=17));
    Profiles.Tsetu(zonech,k)=Tsetuch;
end

zone=InBuil.zone;
zonemax=max(zone);

% Qmax(zonenr)=CFcontrol(zonenr,1)*Qpmax(zonenr)+CFcontrol(zonenr,2)*Qstook*(zonenr);
% bijv. CFcontrol(zonenr,2)=1-CFcontrol(zonenr,1)=0
% Factoren <=1 en voor een tijdsinterval van 1 uur
% Format: CFcontrol(zonenr,1:2)
CFcontrol=zeros(zonemax,2);
CFcontrol(:,1)=1;
%CFcontrol(1,:)=[0.4,0.6];
Control.CFcontrol=CFcontrol(zone,:);

% Geleidelijk opstoken met een gegeven temperatuurstijging per uur. Als dit niet gewenst is 
% hier een groot getal invoeren (bijv. 100). Bij hygrostatische regeling wordt dit uitgeschakeld
delTstook(1:zonemax)=100;
%delTstook(1)=10;   % opstoken met max. 10 kelvin per uur
Control.delTstook=delTstook(zone);

%-------------------------------------------------------------------
% HYGROSTATISCHE REGELING
%----------------------------------------------------------------------------
% Indien de temperatuur met de relatieve vochtigheid wordt geregeld (hygrostatische regeling) dan zal:
% de settemperatuur groter worden als de opgegeven temperatuur Tsetmin om de RV niet boven rvmax uit te laten
% stijgen of lager worden om de RV niet onder rvmin te laten zakken. Deze stijging kan maximaal tot de opgegeven
% Tsetmaxhygrostat gaan en minimaal tot Tsetminhygrostat. Er is geen koeling bij hygrostatische regeling mogelijk.
% Als er koeling wordt airco verondersteld en is deze regeling niet voor de hand liggend.
% is zijn er i.h.a. andere methoden f beperkt worden door het opgegeven 
% Er kan niet tegelijkertijd nog bevochtigd of ontvochtigd worden.
% Het kan nodig zijn de free cooling uit te schakelen omdat de temperatuur in het stookseizoen boven de 
% drempel komt waarbij deze wordt ingeschakeld.
% Bij hygrostatische regeling moet per zone ingevuld worden: hygrostat(zone,:)=[1,Tsetminhygrostat,Tsetmaxhygrostat];
% Geen hygrostatische regeling altijd eerste kolom ==0, dus
% hygrostat(zone,:)=[0,Tsetminhygrostat,Tsetmaxhygrostat];

hygrostat=zeros(zonemax,3);
%hygrostat(1,:)=[1,0,30];
Control.hygrostat=hygrostat(zone,:);

%-------------------------------------------------------------------
% Wand/VLOERVERWARMING&KOELING
%----------------------------------------------------------------------------
Flheat=[];

% per zone kan maar een wand(deel) voor wandverwarming of koeling worden ingevoerd. Indien de wand zich
% tussen twee zones bevindt zal regeling van de verwarming zich bevinden in de zone die in de 
% eerste kolom van het wandtype wordt opgegeven. 
% Indien systeem niet aanwezig is, niets invoeren of % voor Flheat.....
% Bij verschillende zones met wandverwarming wordt Flheat een array [ .., ..]
% Flheat.br afstand tussen pijpen
% Rvw-s:warmteweerstand tussen pijpenregister en wandoppervlak in hetzelfde vertrek 
% oppervlakte
% Tmax:maximale invoertemperatuur voor het verwarmingsregister, bijc 50C, bij koeling is dit de minimale
% temperatuur, bij wandverwarming als basisverwarming is dit de watertemperatuur die er constant is 
% Rflow=(Taanvoer-Tretour)/qflhmax, qflhmax=(Taanvoer+Tretour)/(R11*2)
% Taanvoer,Tretour verschil aanvoer- resp retourtemperatuur met binnentemperatuur bij ontwerpcondities
% Ri: totale warmteoverdrachtscoeff als de verwarming/koeling aan is,(bijv. 1/13)in
% het vertrek waar de regeling is (eerste getal van wandin etc,soms constructie omdraaien!). Het aandeel convectieve
% warmte wordt berekend met 1-5*Ri: Dus Ri>0.2!!!    
% Re: totale warmteoverdrachtscoeff als de verwarming/koeling aan is aan de andere zijde  
% code voor wandtype:'-1:wandex, 0:wandi0, -2:wandia, >=1:wandin en Ri zit aan zone die voorop staat in wandin;
% rangnr de wand mag niet aan zones grenzen die niet in het project worden gesimuleerd
% qmax aan warmte per m2 dat maximaal geleverd wordt vanaf het oppervlak: qmax=13*(Topp-Tset)bijv.100 W/m2
% indien koeling hier negatief vermogen geven
% Met fig=1 wordt een figuur van de responsiefactoren gemaakt (met pauze, dus toets indrukken om verder te gaan) 
% Responsiefactoren nodig voor wandverwarming/koeling
% respfac=[Ri,Re,Rvw_s,respfacqup,respfacTin,respsfaqdown]
% responsiefactoren: quit=respfacq(1)qin+respfacq(2)qin*+respfacq(4)qin**+
%   respfacq(3)quit*+respfacq(5)quit**    (*tijdstap terug)
% Tin=respfacT(1)qin+respfacT(2)qin*+respfacT(4)qin**+respfacT(3)Tin*+
%   respfacT(5)Tin**
% optimale resp maximale oppervlaktetemp: lopen:22-25,stilstaan:23-27,zitten;25-29:badkamer;27-31
% Als de wandverwarming een basisverwarming is (dus nog een extra verwarming) dan per zone basis=1
if 1==0
    Flheat.br=0.3;
    Flheat.Rvw_s=0.015/0.8+0.1/1.7;
    Flheat.oppervlakte=2*(5.1*9-5);
    Flheat.Tmax=15;
    Flheat.Rflow=(30-20)/100;
    Flheat.Ri=0.1;
    Flheat.Re=1;
    Flheat.wandtyp=0;
    Flheat.wandnr=1;
    Flheat.qmax=100;
    Flheat.fig=0;
    Flheat.basis=0; 
end

if exist('Flheat','var')
    Control.Flheat=Flheat;
end

% Riw extra warmteweerstand aan de binnenzijde als gevolg van de zonwering,Rew aan de
% buitenzijde (voor condensatieberekeningen)  

if isfield(BASE,'Glas')
    kglas=find(cellfun('isempty',BASE.Glas)==0);
    for i=kglas
        InBuil.glas.Riw(i)=1/BASE.Glas{i}(6)-1/BASE.Glas{i}(1); %binnenzonwering
        InBuil.glas.Rew(i)=0*(1/BASE.Glas{i}(6)-1/BASE.Glas{i}(1));%buitenzonwering
    end 
else
    InBuil.glas.Riw(1)=0;
    InBuil.glas.Rew(1)=0;
end

% InBuil.glas.Riw(1)=0;
% InBuil.glas.Rew(1)=0;
