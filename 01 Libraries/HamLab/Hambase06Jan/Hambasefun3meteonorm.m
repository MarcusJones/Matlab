%WAVOFUN  Simulation of WaVo Building Model
%  
% usage  [Control,Profiles,InClimate,InBuil]=Hambasefun3meteonorm(BASE),
%
% BASE is a cellstructure containing building and systems data, see example1.m
% Meteofile from meteonorm 
% This file is an interface between BASE and WaVo
% dec2004/sept2005 see line 62
%
%
function [Control,Profiles,InClimate,InBuil]=Hambasefun3meteonorm(BASE)
% ------------------------------------------------------------------------
%
%                Warmte en vocht  
% Simulatie voor warmte en vocht in het binnenklimaat + energieverbruik
%
% ----------------------------------------------------------------------------
%
zone1=find(cellfun('isempty',BASE.Vol)==0);
kzone=1;
for i=1:length(zone1)
    if BASE.Vol{zone1(i)}~=0
        zone(kzone)=zone1(i);
        kzone=kzone+1; 
    else
        warning(' there is a zone without volume')
    end
end

% Aantal inslingerdagen
nin=3;
%luchtstromen tussen zones vertrek i-->vertrek j Linkv(j,i)in m3/uur
Linkv=zeros(max(zone),max(zone));
% het totale installatierendement (bijv 72%)
etainst=72;
%----------------------------------------------------------------------------
% PART 4 : Heating, cooling, humidification, dehumidification 
% ----------------------------------------------------------------------------
for i=zone
    Qpmax(i)=BASE.Plant{i}(1);
    Qcmax(i)=BASE.Plant{i}(2);
    Gmax(i)=BASE.Plant{i}(3);
    Gmin(i)=BASE.Plant{i}(4);
    vol(i)=BASE.Vol{i};
    CFset(i)=BASE.convfac{i}(2);
    CFint(i)=BASE.convfac{i}(3);
    CFh(i)=BASE.convfac{i}(1);
    etaww(i)=BASE.heatexch{i}(1);
    Twws(i)=BASE.heatexch{i}(2);
    fbv(i)=BASE.furnishings{i}(1);
    CFfbi(i)=BASE.furnishings{i}(2);
end

% ---------------------------------------------------------------------------------
% maken weerfile kli=zeros(1,5) en uurfile voor Profiles celarray
% ---------------------------------------------------------------------------------
maand=BASE.Period(2);
dag=BASE.Period(3);
aantaldagen=BASE.Period(4);
% gref = albedo
gref=0.2;
% view site meteonorm
Latitude=-1.18;
Longitude=-36.45;
Time_zone=-3;
Time_difference=-30;
nin=3;
% user defined meteonorm:
% [year, diffuse radiation horizontal, air temperature, beam radiation, cloud cover
% fraction, relative humidity]
% units: temperature 1/10 C
meteofile='Nairhour.dat';
%--------------------------------------------------------------------------
% LAT = Latitude [graden] 
InClimate.LAT=Latitude;
% LON = Local Longitude [graden] oost is positief
LON=-Longitude;
% LSM = Local Standard time Meridian [graden] oost is positief
LSM=-15*Time_zone;
InClimate.LSMLON=LSM-LON;
InClimate.gref=gref;
InClimate.nin=nin;
InClimate.aantaldagen=aantaldagen;
klim=load(meteofile); 
jaar=klim(1,1)
kli1=klim(:,[2:6]);
kli2=kli1;
date1=klim(:,1)';
date2=date1+1;
clear klim;
maanddag=[0 31 59 90 120 151 181 212 243 273 304 334 365];
% idag1=0 voor 1 jan
if maand>=3&length(date1)==8784
    idagj=maanddag(maand)+dag;
else
    idagj=maanddag(maand)+dag-1;
end
indx1=idagj*24;

%TEST
%SST(1,:)=[1987,4,28,4,29]
%SST(2,:)=[1988,4,3,4,3]

SST=BASE.DSTime;

if SST==1|SST==0
    %dagen waarop de zomertijd begint vanaf ref in rekenperiode
    % begin zomertijd laatste weekend in maart
    jaar1=[jaar:jaar+ceil(aantaldagen/365)];
    izt1= maanddag(4)+1-ceil(mod(jaar1,4)/4)- mod((floor(5*jaar1/4)+4 ),7)-1;
    %Einde zomertijd (vanaf 1996),laatste weekend in oktober:
    izt2=maanddag(11)+1-ceil(mod(jaar1,4)/4)- mod((floor((5*jaar1)/4)+1 ),7)-1;
else 
    izt1=(maanddag(SST(:,2))'+SST(:,3)-1+(mod(SST(:,1),4)==0).*ceil((SST(:,2)-2)/12))';
    izt2=(maanddag(SST(:,4))'+SST(:,5)-1+(mod(SST(:,1),4)==0).*ceil((SST(:,4)-2)/12))';
end
if izt1(1)<idagj&izt2(1)>=idagj
    izt1(1)=idagj;
end
% geen zomertijd dezelfde datum voor begin en einde
if SST==0
    izt2=izt1;
end

%aantal dagen vanaf zondag 1jan 0h 1968 tot 1jan 0h jaar
iday1jaar=366+floor(365.25*(jaar-1969));
iday11=idagj+iday1jaar;
InClimate.idag1=iday11+0.5;

wdag=mod(iday11,7);
tijd=0; 
idagm=dag;
maandj=maand;
ijaar=1;
iz1=izt1(ijaar);
iz2=izt2(ijaar);

%Van de invoer Profiles (per dag , weekfun!, 3 perioden)wordt een uurfile gemaakt
%zonetot=length(zone);

zonetot=length(zone);
if isfield(BASE,'dayper')
    kprof=find(cellfun('isempty',BASE.dayper)==0);
    for i=kprof
        periode(i,:)=BASE.dayper{i};
    end
else
    error('No Profiles !!!!!')
end   

for i=1:zonetot
    wfun(i,:)=BASE.weekfun{zone(i)};
end
Profiles.weekfun=wfun;
wdag=mod(iday11,7);
tijd=0; 
date=zeros(aantaldagen*24,5);
for id=1:aantaldagen
    
    if maandj>=2&length(date1)==8784
        leap=1;
    else
        leap=0;
    end
    
    if idagj==maanddag(maandj+1)+leap
        maandj=maandj+1;
        idagm=1;
        if maandj==13;
            maandj=1;
            jaar=jaar+1;
            ijaar=ijaar+1
            idagj=0;
            eval(['load mt',num2str(jaar)]);
            eval(['kli2=mt',num2str(jaar),'(:,[1 2 3 9 6]);']);
            eval(['clear mt',num2str(jaar)]);
            date2(1:length(kli2(:,1)))=jaar;
            kli1=[kli1;kli2];  
            date1=[date1,date2];
            iz1=izt1(ijaar);
            iz2=izt2(ijaar);
        end
    end
    
    if wdag==7
        wdag=0;
    end;
    
    wdag=wdag+1;
    %wkfun=wfun(:,wdag);     %wkfun(zone) Profiles nr op een bepaalde dag
    
    if idagj==iz1&idagj~=iz2
        hour=[2:24];
        tijd=max(tijd)+[1:23];
    elseif idagj~=iz1&idagj==iz2
        hour=[1,1:24];
        tijd=max(tijd)+[1:25];
    else
        hour=[1:24];
        tijd=max(tijd)+[1:24];
    end
    date(tijd,5)=hour';
    date(tijd,4)=wdag;
    date(tijd,3)=idagm;
    date(tijd,2)=maandj;
    
    if id==aantaldagen
        h=max(tijd)-aantaldagen*24;
        kh=length(tijd); %23 of 24 of 25 dgn
        
        if h==1
            hour=[1:kh-1];
            tijd(kh)=[];
            date(max(tijd),:)=[];
        elseif  h==-1
            hour=[1:kh,1];
            
            date(max(tijd)+1,5)=1;
            date(max(tijd)+1,4)=wdag+1;
            date(max(tijd),3)=idagm;
            date(max(tijd),2)=maandj;
            tijd(kh+1)=max(tijd)+1;
        end;
    end
    idagm=idagm+1;
    idagj=idagj+1;
    
    wkfun=wfun(:,wdag);     %wkfun(zone) Profiles nr op een bepaalde dag
    
    for i=1:zonetot
        k=wkfun(i);
        lper=length(periode(k,:));
        peri=lper*ones(1,24);%peri(zone,1:24) per uur periodenr 1, 2 of 3  
        for iper=1:lper-1
            peri(periode(k,iper)+1:periode(k,iper+1))=iper;
        end
        perih=peri(hour);
        Profiles.periode(i,tijd)=perih;
        Profiles.Ersu(i,tijd)=BASE.Ers{k};
        Profiles.rvminu(i,tijd)=BASE.RVmin{k}(perih);
        Profiles.rvmaxu(i,tijd)=BASE.RVmax{k}(perih);
        Profiles.Tsetu(i,tijd)=BASE.Tsetmin{k}(perih);
        Profiles.Qintu(i,tijd)=BASE.Qint{k}(perih);
        Profiles.Gintu(i,tijd)=BASE.Gint{k}(perih);
        Profiles.Tsetmaxu(i,tijd)=BASE.Tsetmax{k}(perih); 
        Profiles.Tvsu(i,tijd)=BASE.Tfc{k}(perih);
        Profiles.vvminu(i,tijd)=BASE.vvmin{k}(perih); 
        Profiles.vvmaxu(i,tijd)=BASE.vvmax{k}(perih);
    end 
    
end
date(:,1)=date1(indx1+1:indx1+aantaldagen*24)';
InClimate.date=date;
InClimate.kli=kli1(indx1+1:indx1+aantaldagen*24,:);

Control.maxvvmin=max(Profiles.vvminu');

% ------------------------------------------------------------------------
% Opslaan in cellarrays: Control,InBuil
% -------------------------------------------------------------------------
if isfield(BASE,'Con')
    
    kCon=find(cellfun('isempty',BASE.Con)==0);
    
    for i=kCon,
        nconstructie=length(BASE.Con{i});
        ltel=[2:2:(nconstructie-3)];
        mattel=ltel+1;
        l=BASE.Con{i}(ltel);
        con{i}.matprop = matpropf(l,BASE.Con{i}(mattel));
        Ri=BASE.Con{i}(1);
	    Re=BASE.Con{i}(nconstructie-2);
	    eb=BASE.Con{i}(nconstructie);
        con{i}.Ri=Ri;   
        con{i}.Re=Re; 
        con{i}.ab=BASE.Con{i}(nconstructie-1);
        con{i}.eb=eb;
        if Ri>=1/5;
        con{i}.Zvi=1000*Ri;                %Lewis relatie gebruikt (m2s/kg)
        else
        con{i}.Zvi=1000/(1/Ri-5);          %binnen wordt altijd eb=0.9 gebruikt
        end
        if 1/Re<=5*eb/0.9
        con{i}.Zve=1000*Re;
        else
        con{i}.Zve=1000/(1/Re-5*eb/0.9);
        end
        k=find(con{i}.matprop(:,2)==0);
        if ~isempty(k)
            error(' One matID is not defined !!!!!')
        end
    end 
else
    error(' No Construction data !!!!!')
end

if isfield(BASE,'Or')
    kOr=find(cellfun('isempty',BASE.Or)==0);
    for i=kOr
        Or(i,:)=BASE.Or{i};
    end 
else
    warning(' No Orientations !!!!!') 
    Or(1,:)=[90 0];
end

if isfield(BASE,'Glas')
    kglas=find(cellfun('isempty',BASE.Glas)==0);
    for i=kglas
        glas.Uglas(i)=BASE.Glas{i}(1);
        glas.CFr(i)=BASE.Glas{i}(2);
        glas.ZTA(i)=BASE.Glas{i}(3);
        glas.ZTAw(i)=BASE.Glas{i}(4);
        glas.CFrw(i)=BASE.Glas{i}(5);
        glas.Uglasw(i)=BASE.Glas{i}(6);
    end 
else
    warning(' No Glazing data!!!!!')
    glas.Uglas(1)=5.9;
    glas.CFr(1)=0.01;
    glas.ZTA(1)=0.8;
    glas.ZTAw(1)=0.8;
    glas.CFrw(1)=0.01;
    glas.Uglasw(1)=5.9;
    kglas=1;
end

%wandex(:,:)= [zonenr, surf, conID,	orID,bridge, exID]
if isfield(BASE,'wallex')
    k1x=find(cellfun('isempty',BASE.wallex)==0);
    kx=1;
    
    for ic=k1x
        for i=1:zonetot
            kzone=zone(i);
            if BASE.wallex{ic}(1)==kzone&BASE.wallex{ic}(2)~=0
                wandex(kx,:)=[i BASE.wallex{ic}(2:5) ic];
                
                k=find(kCon==wandex(kx,3));
                if isempty(k)
                    error('external wall with non-existing construction type!!!!!') 
                end
                k=find(kOr==wandex(kx,4));
                if isempty(k)
                    error('external wall with non-existing orientation!!!!!') 
                end
                kx=kx+1;
            end
        end
    end
end
if ~exist('wandex')
    warning(' zone(s) with no external constructions !!!!!') 
    wandex=[zone(1), 0, kCon(1), 1, 0, 1];
end

%window0(:,:)= [exID,    surf,	glaID,   shaID]
if isfield(BASE,'window')
    kwindow=find(cellfun('isempty',BASE.window)==0);
    kwi=1;
    
    for i=kwindow
        lw=find(wandex(:,6)'==BASE.window{i}(1));
        if ~isempty(lw)
            window0(kwi,:)=[lw BASE.window{i}(2:4)];
            wandex(lw,2)=wandex(lw,2)-window0(kwi,2);
            if wandex(lw,2)<0
                error('The window surface area is larger than the surface of the wall');
            end;
            
            k=find(kglas==window0(kwi,3));
            if isempty(k)
                error('external wall with non-existing glazing type!!!!!') 
            end
            kwi=kwi+1;
        end
    end
end
if ~exist('window0')
    warning(' No Windows !!!!!') 
    window0 = [1, 0, kglas , 0];
end

%wandi0(:,:) =[zonenr, surf,   conID, temp,    bridge, i0ID]
if isfield(BASE,'walli0')
    k10=find(cellfun('isempty',BASE.walli0)==0);
    k0=1;
    
    for ic=k10
        for i=1:zonetot
            kzone=zone(i);
            if BASE.walli0{ic}(1)==kzone&BASE.walli0{ic}(2)~=0
                wandi0(k0,:)=[i BASE.walli0{ic}(2:5) ic];
                k=find(kCon==wandi0(k0,3));
                if isempty(k)
                    error('wall adjacent to a constant temperature zone with non-existing construction type!!!!!')
                end
                k0=k0+1;
            end
        end
    end
end
if ~exist('wandi0')
    warning(' No walls adjacent to a constant temperature zone!!!!!') 
    wandi0=[zone(1), 0, kCon(1), 0, 0, 1];
end

%wandia(:,:) =[zonenr, surf,conID, iaID ];
if isfield(BASE,'wallia')
    k1a=find(cellfun('isempty',BASE.wallia)==0);
    ka=1;
    for ic=k1a
        for i=1:zonetot
            kzone=zone(i);
            if BASE.wallia{ic}(1)==kzone&BASE.wallia{ic}(2)~=0
                wandia(ka,:)=[i BASE.wallia{ic}(2:3) ic];
                k=find(kCon==wandia(ka,3));
                if isempty(k)
                    error(' adiabatic wall with non-existing construction type!!!!!') 
                end
                ka=ka+1;
            end
        end
    end
end
if ~exist('wandia')
    warning(' No adiabatic walls !!!!!')
    wandia=[zone(1), 0, kCon(1), 1];
end

%wand in(:,:) =[zonenr1,	zonenr2,	surf,		conID, inID];
if isfield(BASE,'wallin')
    k1i=find(cellfun('isempty',BASE.wallin)==0);
    ki=1;
    for ic=k1i
        for i=1:zonetot
            kzone=zone(i);
            for j=1:zonetot
                kzone2=zone(j);
                if BASE.wallin{ic}(1)==kzone&BASE.wallin{ic}(2)==kzone2&BASE.wallin{ic}(3)~=0
                    wandin(ki,:)=[i j BASE.wallin{ic}(3:4) ic];
                    k=find(kCon==wandin(ki,4));
                    if isempty(k)
                        error(' internal wall with non-existing construction type!!!!!') 
                    end
                    ki=ki+1;
                end
            end
        end
    end
end
if ~exist('wandin')
    warning(' No internal walls !!!!') 
    wandin=[zone(1), zone(1), 0,kCon(1), 1];
end

% nieuweconstructies toevoegen om zone-volgorde te corrigeren 
k=size(con);
maxcon=k(2);
k=find(wandin(:,1)-wandin(:,2)>0);
for l=1:length(k)
    kl=k(l);
    wandin11=wandin(kl,2);
    wandin(kl,2)=wandin(kl,1);
    wandin(kl,1)=wandin11;
    maxcon=maxcon+1;
    h=size(con{wandin(kl,4)}.matprop);
    con{maxcon}.matprop = con{wandin(kl,4)}.matprop(h(1):-1:1,:);
    con{maxcon}.Ri= con{wandin(kl,4)}.Re;
    con{maxcon}.Re=con{wandin(kl,4)}.Ri;
    con{maxcon}.ab=con{wandin(kl,4)}.ab; 
    con{maxcon}.eb=con{wandin(kl,4)}.eb; 
    con{maxcon}.Zvi=con{wandin(kl,4)}.Zvi;
    con{maxcon}.Zve=con{wandin(kl,4)}.Zve;
    wandin(kl,4)=maxcon;
end 

kwallex=wandex(:,3)'; %constructie
kwall0=wandi0(:,3)';
kwallia=wandia(:,3)';
kwallin=wandin(:,4)';
kwall=[wandex(:,3)',wandi0(:,3)',wandia(:,3)',wandin(:,4)']; %conconstructietypes
k1=[sort(kwall),0];
k2=find(diff(k1)~=0);
wand=k1(k2); %gebruikte contypes
khulpwand=zeros(1,max(kwall));
khulpwand(wand)=[1:length(wand)];
%kwallnew=khulpwand(kwall);
wandex(:,3)=khulpwand(kwallex)';
wandi0(:,3)=khulpwand(kwall0)';
wandia(:,3)=khulpwand(kwallia)';
wandin(:,4)=khulpwand(kwallin)';

for i=1:length(wand)
    conn{i}=con{wand(i)};
end
clear con

%----------------------------------------------------------------------------------

InBuil.zone=zone;
InBuil.Or=Or;
InBuil.wandex=wandex;
InBuil.window=window0;
InBuil.Obstruc=BASE.shad;
InBuil.wandi0=wandi0;
InBuil.wandia=wandia;
InBuil.wandin=wandin;
InBuil.con=conn;
InBuil.glas=glas;
InBuil.vol=vol(zone);
InBuil.fbv=fbv(zone);
InBuil.CFfbi=CFfbi(zone);
InBuil.Linkv=Linkv(zone,zone);
InBuil.oriennr=1; %irradiation on surface with oriennr in output

clear wandex wandi0 wandia wandin
Control.etaww=etaww(zone);
Control.Twws=Twws(zone);
Control.CFh=CFh(zone);
Control.Qpmax=Qpmax(zone);
Control.Qcmax=Qcmax(zone);
Control.CFset=CFset(zone);
Control.etainst=etainst;
Control.CFint=CFint(zone);
Control.Gmax=Gmax(zone);
Control.Gmin=Gmin(zone);

if exist('CFcontrol','var')
    Control.CFcontrol=CFcontrol(zone,:);
end
if exist('delTstook','var')
    Control.delTstook=delTstook(zone);
end
if exist('hygrostat','var')
    Control.hygrostat=hygrostat(zone);
end
if exist('Flheat','var')
    Control.Flheat=Flheat;
end
