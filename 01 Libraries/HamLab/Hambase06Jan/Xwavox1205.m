function [Output]=Xwavox0404(Profiles,InClimate,InBuil,Control)
%
% ---------------------------------------------------------------------------
%----------------------------------------------------------------------------
% 
% ----------------------------------------------------------------------------
% met link luchtstroom tussen ruimten  alleen ingaande luchtstromen Linkv (rho*c*qv)
% Uitvoer in Output.Ta;.Tcom,.Tx;.Qplant,.Vent;.Zon;.Trans;.Qint;.Twflh1;.RHa;
% Output.Gplant;.Gint;.RHwflh1;.Enr;.Lnr;.Tset;.Twall1;.Twindowi;.RHwall1;
% Output.RHwindowi;.Twall2;.Twindowe;.RHwall2;.RHwindowe;
% nog  regelingen opstoken,met delay 12-2-00 
% zonnestraling Enr op vlak oriennr, atmosferische straling Lnr op vlak oriennr
% oct2003 Fout iteratie hygrostat hersteld:Temperatuur nooit boven Tsetmax door hygrostat maar wel beneden Tset

frdis=3/4;

gref=InClimate.gref;
idag1=InClimate.idag1;
kli=InClimate.kli;
LAT=InClimate.LAT;
LSMLON=InClimate.LSMLON;
date=InClimate.date;
aantaldagen=InClimate.aantaldagen;
nin=InClimate.nin;
interhour=InClimate.interhour;

zone=InBuil.zone;
Or=InBuil.Or;
wandex=InBuil.wandex;
window=InBuil.window;
Obstruc=InBuil.Obstruc;
wandi0=InBuil.wandi0;
glas=InBuil.glas;
vol=InBuil.vol;
CFfbi=InBuil.CFfbi;
fbv0=InBuil.fbv;
Linkv=InBuil.Linkv;
oriennr=InBuil.oriennr;

etaww0=Control.etaww;
Twws0=Control.Twws;
CFh=Control.CFh;
fpmax=Control.Qpmax;
fcmax0=Control.Qcmax;
CFset=Control.CFset;
etainst=Control.etainst;
CFint=Control.CFint;
Gmax=Control.Gmax;
Gmin=Control.Gmin;
CFcontrol=Control.CFcontrol';
delTstook=Control.delTstook/interhour;
hygrostat=Control.hygrostat(:,1)';
Tsetminhygrostat=Control.hygrostat(:,2)';
Tsetmaxhygrostat=Control.hygrostat(:,3)';

Flheat=Control.Flheat;

% Qmax=CFcontrol(1)*Qpmax+CFcontrol(2)*Qstook*;
CFcontroli(2,:)=CFcontrol(2,:).^1/interhour;
CFcontroli(1,:)=CFcontrol(1,:).*(eps+1-CFcontroli(2,:))./(eps*interhour+1-CFcontrol(2,:));

zonetot=length(zone);

% ---------------------------------------------------------------------------------
Linkdag=(Linkv-diag(sum(Linkv')))/3;

%aantal iteratiestappen per uur bij link door lucht is 5 door constr is 2
maxuur=1;
maxuurv=1;
if sum(sum(abs(Linkdag)))~=0
    maxuur=5;
    maxuurv=5;
end

[MM,CC,RR,Building,xcons,MMV,CCV,RRV,kex0,maxuur,kwall,kbin,Awand,kbuit]...
    =Xmat1204(InBuil,frdis,interhour,maxuur);

% ---------------------------------------------------------------------------------

%hr=5;
Ri=Building.Rimean;
hcv=1./Ri-5;
hrx=6;
htotx=1./Ri+1; 
ex1=2.71828182845904;
Xsm=611*0.62e-5;
pii=pi;
r=pii/180;
Psref=2340;
facsat=2340/611;

% ---------------------------------------------------------------------------------

Ca=interhour*1200*vol/3600;
weekfun=Profiles.weekfun;
iterrel=max(hygrostat);
%rvsetnieuw=0.5;

hygrostat1=max(hygrostat)+1;
%delTstook=(100-delTstook).*(hygrostat>0)+delTstook;
% Berekening verwarmingsstroom factor andere bronnen:
Facp=CFh-(1-CFh).*hcv/hrx;
Faci=CFint-(1-CFint).*hcv/hrx;
Facset=CFset-(1-CFset).*hcv/hrx;

nnmax=length(kli(:,1));

%--------------------------------------------------------------------------------
% wanden
%----------------------------------------------------------------------------

Iex=Building.Iex;
Iwand1=Building.Iwand1;
Iwand2=Building.Iwand2;
Ii0=Building.Ii0;
Reeb0=Building.Reeb0;
Reab0=Building.Reab0;

Li=Building.Li;
Le=Building.Le;
Lie=Building.Lie;
Output.U=Building.U;
Li0=Building.Li0;
Lex0=Building.Lex0;
Liecex0=Building.Liecex0;
Liec00=Building.Liec00;
Atotzg=Building.Atotzg;
Lx=Building.Lx;
Ldet=Building.Ldet;
tempi0=wandi0(:,4)';

%---------------------------------------------------------------------------------------
%RAMEN
%-----------------------------------------------------------------------------------------



bele0=window(:,4)';
Aglas0=window(:,2)'+eps;
kwindow=window(:,3)';%glastype
kw=window(:,1)';    %wandex
kex=wandex(:,1)';%zone
kow=kex(kw);         %zone
or0=wandex(:,4)';
orr0=or0(kw);     %de orientaties

Uglas=glas.Uglas(kwindow);
CFr0=glas.CFr(kwindow);
ZTA=glas.ZTA(kwindow);
ZTAw=glas.ZTAw(kwindow);
CFrw0=glas.CFrw(kwindow);
Uglasw=glas.Uglasw(kwindow);

Riglas=glas.Ri(kwindow);
Reglas=glas.Re(kwindow);
Riglasw=glas.Riw(kwindow);% weerstand van zonwering naar binnen
Reglasw=glas.Rew(kwindow);
Riwa=glas.Riwa(kwindow); % weerstand van glas met zonwering en spouw naar binnen
Rewa=glas.Rewa(kwindow);
glaseps=glas.eps(kwindow);

Iow=zeros(zonetot,length(kow));
for i=1:zonetot
    Iow(i,:)=(kow==i);
end
Aglas=Aglas0*Iow';
Atot=Atotzg+Aglas;
% Or: ki aantal orientaties,unieke combinatie orientatie met belemmering is
% extra orientatie, uitbreiding ki tot li (ki + extra combinaties in 
% orbel(k=orientatienr,l=schaduwnr),rijnummer is type 
% opslag van nummer in orr0 i.p.v. or0
% voor dichte wanden alleen or0, voor ramen orr0
ki=length(Or(:,1));
orbel(1:ki,:)=[(1:ki)' zeros(ki,1)];% orbel(k=orientatienr,l=schaduwnr),rijnummer is type

if max(bele0)>0;
    k1=[sort(bele0),0];
    k2=find(diff(k1)~=0);
    kschaduw=k1(k2);
    
    wschad=shadowf0502(Obstruc,kschaduw);
    onr=ki;
    morbel=zeros(onr,length(wschad(:,1)));
    for i=1:length(kow)
        k=orr0(i);
        l=bele0(i);
        if l>0
            if morbel(k,l)==0
                onr=onr+1;
                morbel(k,l)=onr;
                orr0(i)=onr;
                orbel(onr,:)=[k l];
            end;
        end;
    end;
    
else
    wschad(1,:)=[0 1 2 0 0];
end;

% voor dichte wanden alleen or0(1:ki), voor ramen orr0(1:li)
CFr=CFr0.*(1-CFfbi(kow))+CFfbi(kow); % correctie meubels 
Tglas0=ZTA.*Aglas0;
%een gedeelte gaat weer terug door het raam naar buiten
%cor=1-(1-CFr).*Tglas0.*(1-CFr)*Iow'./Atot;
cor=(Tglas0.*(1-CFr)*Iow'./Atot)*Iow;
Tglas0=Tglas0.*(1-(1-CFr).*cor);
%Tglas0=Tglas0.*(cor(kow));
CFrnew=CFr./(1-(1-CFr).*cor);
Facr00=CFrnew-(1-CFrnew).*(hcv(kow))/hrx;
%Lglas0=Uglas(kwindow).*Aglas0./(1-Uglas(kwindow).*(Ri(kow)-1./htotx(kow)));
Lglas0=Uglas.*Aglas0./(1-Uglas.*(Riglas-1./(1./Riglas+1)));

CFrw=CFrw0.*(1-CFfbi(kow))+CFfbi(kow);
Tglasw0=ZTAw.*Aglas0;
%cor=1-(1-CFrw).*Tglasw0.*(1-CFrw)*Iow'./Atot;
cor=(Tglas0.*(1-CFrw)*Iow'./Atot)*Iow;
%Tglasw0=Tglasw0.*(cor(kow));
Tglasw0=Tglasw0.*(1-(1-CFrw).*cor);
CFrwnew=CFrw./(1-(1-CFrw).*cor);
Facrw0=CFrwnew-(1-CFrwnew).*(hcv(kow))/hrx;
%Lglasw0=Uglasw(kwindow).*Aglas0./(1-Uglasw(kwindow).*(Ri(kow)-1./htotx(kow)));
Lglasw0=Uglasw.*Aglas0./(1-Uglasw.*(Riglasw-1./(1./Riglasw+1)));

Rig=Riglas./Aglas0;
Regz=Reglas./Aglas0;
Rigw=Riwa./Aglas0;
Regw=Rewa./Aglas0;

Lxa=(Atot.*hcv).*(htotx/hrx);
Lrcvx=Atotzg.*htotx;

% -------------------------------------------------------------------------------------
% Initialisatie
% ---------------------------------------------------

% De uitvoerfile
Ener3=zeros(1,zonetot);

Te=kli(1,2)/10;
Ta=15*ones(1,zonetot);
Tx=Ta;
Te0=Te*kex0;
Tcom=Ta;

phi=kli(1,5)/100;
macht=17.08*Te/(234.18+Te);
if Te<0
    macht=22.44*Te/(272.44+Te);
end;
Xse=Xsm*ex1^macht; 
Xe=phi*Xse;
Xe0=Xe*kex0;%dampdruk buiten
macht=17.08*tempi0./(234.18+tempi0);
f=find(tempi0<0);
macht(f)=22.44*tempi0(f)./(272.44+tempi0(f));
Xei0=Xsm*ex1.^macht;%dampdruk constante temp (verzadiging)

rvin=0.5*ones(1,zonetot);% Relatieve vochtigheid in de zone
hulp=17.08*Ta./(234.18+Ta);
f=find(Ta<0);
hulp(f)=22.44*Ta(f)./(272.44+Ta(f));
hulpex1=ex1.^hulp;
Xsa=Xsm*hulpex1;
Xvin=Xsa.*rvin;% Dampspanning in de zone in de begintoestand

Cva=Ca.*(1+fbv0*facsat./hulpex1)/1000;

T1=Tx(kbin);
T2=[Te0,tempi0,Tx(kbuit)];
Xv1=Xvin(kbin);
Xv2=[Xe0,Xei0,Xvin(kbuit)];

% dampspanning en de temp in de constructies in de begintoestand

[fg,F,fgv,CCVo,Fv,Lvt,Xlaag]=Xinitwavo1202(MM,RR,CC,kwall,T1,T2,Iwand1,Iwand2,...
    xcons,MMV,RRV,CCV,Xv1,Xv2,frdis);

% De uitvoerfile
lwa=length(kbin);
Tw1old=15*ones(1,lwa);
Tw2old=15*ones(1,lwa);
rvw1old=0.7*ones(1,lwa);
rvw2old=0.7*ones(1,lwa);
wallTeRH=zeros(nnmax,4*lwa+4*length(kow));

% end wanden----------------------------------------------------------------------------

% stookcapaciteit---------------------------------------------------------------------------------

k=find(fcmax0==1);
fcmax0(k)=-100000000000000;
%Berekening maximale stookcapaciteit
%Ca is al door 3 gedeeld
Lvmin=Ca.*Control.maxvvmin/interhour;
fpmax0=(fpmax(1)>0).*fpmax+((fpmax==-2)*1.5+(fpmax==-1)*50).*...
    ((Lvmin+Lglas0*Iow')*(20+10)+(Lex0*(20+10))*Iex'+(Li0.*(20-tempi0))*Ii0');
% end stookcapaciteit---------------------------------------------------------------------------------

fgvoud=0.5*fgv+0.5*Lvmin.*(Xe-Xvin)/1000+(Cva-0.5*Lvt).*Xvin;

% wandverwarming ---------------------------------------------------------------------------------
% responsiefactoren: quit=respfacq(1)qin+respfacq(2)qin*+respfacq(4)qin**+
%   respfacq(3)quit*+respfacq(5)quit**    (*tijdstap terug)
% Tin=respfacT(1)qin+respfacT(2)qin*+respfacT(4)qin**+respfacT(3)Tin*+
%   respfacT(5)Tin**
% vloerverwarminginitialisatie
delfigain2=zeros(1,zonetot);
delfigain=zeros(1,zonetot);
Facpcon=Facp;
Facpcon2=Facp;
fpmax1=zeros(1,zonetot);
fcmax1=zeros(1,zonetot);
basis=ones(1,zonetot);

if isempty(Flheat)
    vloer=0; 
else
    vloer=1;
    Twflhold=zeros(1,zonetot);
    rvwflhold=zeros(1,zonetot);
    [conheatcool1,CFhcon,CFhcon2,basis]=Xinitflh1202(Flheat,interhour,RR,InBuil,zonetot);
    delTvloerin=zeros(1,zonetot);
    Tvec=zeros(zonetot,4);
    qvec=zeros(zonetot,4);
    qvec2=zeros(zonetot,4);
    Facpcon=CFhcon-(1-CFhcon).*hcv/hrx;
    Facpcon2=CFhcon2-(1-CFhcon2).*hcv/hrx;
    Facp=basis.*Facp+(1-basis).*Facpcon;
end;

%warmte door vloerverwarming uit vloer (W)
fpflh=zeros(1,zonetot);
fpflh2=zeros(1,zonetot); 
Twflh1=zeros(1,zonetot);
Twflh=zeros(1,zonetot);
rvwflh1=zeros(1,zonetot);
rvwflh=zeros(1,zonetot);

Output.Ta=zeros(nnmax*interhour,zonetot);
Output.Tcom=zeros(nnmax*interhour,zonetot);
Output.Tx=zeros(nnmax*interhour,zonetot);
Output.Vent=zeros(nnmax*interhour,zonetot);
Output.Qplant=zeros(nnmax*interhour,zonetot);
Output.Zon=zeros(nnmax*interhour,zonetot);
Output.Trans=zeros(nnmax*interhour,zonetot);
Output.Qint=zeros(nnmax*interhour,zonetot);
Output.Twflh1=zeros(nnmax*interhour,zonetot);
Output.RHa=zeros(nnmax*interhour,zonetot);
Output.Gplant=zeros(nnmax*interhour,zonetot);
Output.Gint=zeros(nnmax*interhour,zonetot);
Output.RHwflh1=zeros(nnmax*interhour,zonetot);

Output.Twall1=zeros(nnmax*interhour,length(kwall));
Output.Enr=zeros(nnmax*interhour,length(oriennr));
Output.Lnr=zeros(nnmax*interhour,length(oriennr));
Output.Tset=zeros(nnmax*interhour,zonetot);
Output.Twindowi=zeros(nnmax*interhour,length(kwindow));
Output.RHwall1=zeros(nnmax*interhour,length(kwall));
Output.RHwindowi=zeros(nnmax*interhour,length(kwindow));
Output.Twall2=zeros(nnmax*interhour,length(kwall));
Output.Twindowe=zeros(nnmax*interhour,length(kwindow));
Output.RHwall2=zeros(nnmax*interhour,length(kwall));
Output.RHwindowe=zeros(nnmax*interhour,length(kwindow));

% ---------------------------------------------------------------------------------


% ----------------------------------------------------------------------------
% DEEL2  : UURLIJKSE SIMULATIE
% ----------------------------------------------------------------------------
% h = fwaitbar2(0,aantaldagen,['XWAV01202']);
for id=1:aantaldagen+nin
    if id <= nin+1
        iday1=idag1;
        nn=0;
    end
    
    iday1=iday1+1;
    
    klizo(1:24,1:5)=kli(nn+1:nn+24,:);
    
    [Esol,Lrad]=zonfunf(iday1,LSMLON,LAT,orbel,klizo,Or,gref,wschad);
    
    Ers0=Profiles.Ersu(:,nn+1:nn+24);
    rvmin0=Profiles.rvminu(:,nn+1:nn+24)/100;
    rvmax0=Profiles.rvmaxu(:,nn+1:nn+24)/100;
    Tset0=Profiles.Tsetu(:,nn+1:nn+24);
    Qint0=Profiles.Qintu(:,nn+1:nn+24);
    Gint0=Profiles.Gintu(:,nn+1:nn+24);
    Tsetmax0=Profiles.Tsetmaxu(:,nn+1:nn+24);
    Tvs0=Profiles.Tvsu(:,nn+1:nn+24);
    Lvmin0=diag(Ca)*Profiles.vvminu(:,nn+1:nn+24)/interhour;
    Lvmax0=diag(Ca)*Profiles.vvmaxu(:,nn+1:nn+24)/interhour;   
    % ---------------------------------------------------------------------------------
    %uurloop
    for uur=1:24
        
        link=Linkdag;
        rvmin=rvmin0(:,uur)';
        rvmax=rvmax0(:,uur)';
        Tsetu=Tset0(:,uur)';
        Qint=Qint0(:,uur)';
        Gint=Gint0(:,uur)';
        Tsetmax=Tsetmax0(:,uur)';
        Tvs=Tvs0(:,uur)';
        Lvmin=Lvmin0(:,uur);
        Lvmax=Lvmax0(:,uur);
        
        nn=nn+1;
        
        Qtot=Esol(uur,:);
        Ltot=Lrad(uur,:);
        
        Te=klizo(uur,2)/10;
        phi=klizo(uur,5)/100;
        macht=17.08*Te/(234.18+Te);
        if Te<0
            macht=22.44*Te/(272.44+Te);
        end;
        Xse=Xsm*ex1^macht;
        Xe=phi*Xse;
        Xe0=Xe*kex0;
        Qt0=Qtot(or0);
        Lu0=Ltot(or0);
        Qts0=Qtot(orr0);
        Lus0=Ltot(orr0);
        Te0=Te+(Reab0.*Qt0-Reeb0.*Lu0); 
        fgtrans0=Te0*Liecex0'+tempi0*Liec00'; 
        
        % ----------------------------------------------------------------------------
        
        for inhour=1:interhour  %Interhourloop
            i=find(Ta>Tvs);
            Ers=1500*ones(1,zonetot);
            Ers(i)=Ers0(i);
            % Alleen zonwering als het te warm is (25 C)
            
            ZTA0=Tglas0; % Zonwering ZTA en 'convectiefactor'
            Facr=Facr00;
            Lglas=Lglas0;
            Rigl=Rig;
            Regl=Regz;
            
            i=find(Qts0>Ers(kow));
            ZTA0(i)=Tglasw0(i);
            Facr(i)=Facrw0(i);
            Lglas(i)=Lglasw0(i);
            Lgtot=Lglas*Iow';
            Rigl(i)=Rigw(i);
            Regl(i)=Regw(i);
            
            Ezon0=Qts0.*ZTA0;
            fizona=(Ezon0.*Facr)*Iow';
            fizonx=(Ezon0.*(1-Facr))*Iow';
            Zon=fizona+fizonx;
            
            % De warmtestroom naar Tx :
            % solair=Te + (ab*Qtot - eb*L)/25
            fglas=(Lglas.*(Te-glaseps.*Lus0.*Reglas))*Iow';
            %fglas=(Lglas.*(Te))*Iow';
            fgtrans=fg+fgtrans0; 
            
            % ----------------------------------------------------------------------------
            
            %Free cooling: Ta is een vector 1,2,3 en ook Lvv
            Lvv=Lvmin;
            Lv=Lvv;
            k=find((Ta>Te) & (Ta<Twws0));
            Lv(k)=Lvv(k).*(1-etaww0(k))';
            i=find(Ta>Tvs);
            Lv(i)=Lvmax(i);
            Lvv(i)=Lv(i);
            Lvv=Lvv/1000;
            % Bepaling winst door zon en interne warmteproductie
            figainx=fizonx+Qint.*(1-Faci)+(1-Facpcon).*fpflh+(1-Facpcon2).*fpflh2;
            figaina=Qint.*Faci+fizona+Facpcon.*fpflh+Facpcon2.*fpflh2;
            
            fpmax20=CFcontroli(1,:).*fpmax0+CFcontroli(2,:).*((Ener3>0).*Ener3);
            fpmax00=min([fpmax0;fpmax20]);
            % opstoken met delTstook
            Tsetmin=min(Tsetu,Tcom+delTstook);
            Tset=(Tcom-Tsetmin).*(hygrostat>0)+Tsetmin;
            
            rvmax1=(1-rvmax).*(hygrostat>0)+rvmax;
            rvmin1=(0-rvmin).*(hygrostat>0)+rvmin;
            %Tsetmax1=(50-Tsetmax).*(hygrostat>0)+Tsetmax;
            fpmax1=fpmax1.*(1-basis)+basis.*fpmax00;
            fcmax1=fcmax1.*(1-basis)+basis.*fcmax0;
            iteratie=1;
            %-------------------------------------------------------------------------------------------
            
            while iteratie>iterrel/10
                
                figainx1=figainx+(1-Facpcon).*delfigain+(1-Facpcon2).*delfigain2;
                figaina1=figaina+Facpcon.*delfigain+Facpcon2.*delfigain2;
                
                %convectiefactor voor koeling is gelijk aan die voor verwarming
                [Txh,Tah,Tcom,Ener,Trans,Vent]=Xsolwa1202(Lgtot,Lxa,Lx,Facp,Lv,link,Ldet,Ca,...
                    fpmax1,fcmax1,Facset,Tset,Tsetmax,Te,Tx,Ta,figainx1,figaina1,fgtrans,fglas,maxuur);
                
                %berekening in wanden van de nieuwe temperaturen 
                [Tlaagh,fg,Fh,fgvh,Fvh,Lvth,CCVoh,Mnieuw]=Xwallwa1202(xcons,MM,CC,kwall,F,...
                    Txh,Te0,tempi0,MMV,CCV,CCVo,Fv,Xlaag,Iwand1,Iwand2,kbin,kbuit,frdis);
                
                %berekening nieuwe rv in vertrek
                
                [Xvinh,fgvoudh,rvin,Hum]=Xsolvo1202(fgvh,Lvth,Lvv,link,Ca,fgvoud,...
                    fbv0,rvmin1,rvmax1,Xvin,Tah,Xe,Gint,maxuurv,Gmax,Gmin);
                
                %berekening in wanden van de nieuwe rv 
                [rvlaag,Xlaagh]=Xwallvo1202(kwall,xcons,Mnieuw,CCV,CCVoh,Fvh,Xvinh,Xe0,Xei0,kbin,kbuit);
                
                if hygrostat1>1
                    %Xsm=611*0.62e-5;
                    Tsetoud=Tset;
                    Xsaset=min(log(Xvinh./(rvmin+eps)/Xsm),(1708/334.18));
                    Tset1=Facset.*(234.18*Xsaset./(17.08-Xsaset))+(1-Facset).*Tx;
                    %Tset1=min(Tset10,Tsetmax);
                    Xsaset=max(log(Xvinh./rvmax/Xsm),0);
                    Tset2=Facset.*(234.18*Xsaset./(17.08-Xsaset))+(1-Facset).*Tx;
                    Tseth=((Tset1-Tsetmin).*(Tsetmin>Tset1)+(Tset2-Tsetmin).*(Tsetmin<Tset2)).*(hygrostat>0)+Tsetmin;
                    Tset=((Tsetminhygrostat-Tseth).*(Tsetminhygrostat>Tseth)+(Tsetmaxhygrostat-Tseth).*(Tsetmaxhygrostat<Tseth)).*(hygrostat>0)+Tseth;
                    Tsetmax=(1000-Tsetmax).*(hygrostat>0)+Tsetmax;
                    macht=17.08*(Tset-(1-Facset).*Tx)./(234.18*Facset+Tset-(1-Facset).*Tx);
                    %rvsetnieuw=Xvinh./(Xsm*ex1.^macht)
                    iteratie=max(abs(Tsetoud-Tset));
                else
                    iteratie=0;
                end
                iterend=(iteratie<=iterrel/10);
                
                % wandverwarming--------------------------------------------------------------  
                if vloer
                    %iteratie=iteratie-9;%einde vloervw
                    [Twflh,rvwflh,Twflh2,rvwflh2,delTvloerin,Tvec,fpflh,fpflh2,qvec,qvec2,...
                            delfigain,delfigain2,Ener,Ener3,fpmax1,fcmax1]=...
                        Xflh1202(Xvin,delTvloerin,Tvec,fpflh,fpflh2,qvec,qvec2,delfigain,Ener,fpmax1,fcmax1,...
                        conheatcool1,Tlaagh,iterend,basis);
                end
                %end wandverwarming--------------------------------------------------------------  
                
            end %iteratie
            %---------------------------------------------------------------------------------
            
            if vloer
                Twflh1=(Twflh+Twflhold)/2; 
                Twflhold=Twflh;
                rvwflh1=(rvwflh+rvwflhold)/2; 
                rvwflhold=rvwflh;
            else
                Ener3=Ener;
            end
            Tlaag=Tlaagh;
            Xvin=Xvinh;
            Xlaag=Xlaagh;
            Tx=Txh;
            Ta=Tah;
            F=Fh;
            Fv=Fvh;
            CCVo=CCVoh;
            Lvt=Lvth;
            fgv=fgvh;
            fgvoud=fgvoudh;
            %Twdowi=Tx(kow)+Rig.*(Lglas.*(Te-Tx(kow)));
            Twdowi=Tx(kow)+Rig.*(Lglas.*(Te-glaseps.*Lus0.*Reglas-Tx(kow)));
            %Twindowi=Tx(kow)+Rigl.*(Lglas.*(Te-Tx(kow)));
            Twindowi=Tx(kow)+Rigl.*(Lglas.*(Te-glaseps.*Lus0.*Reglas-Tx(kow)));
            macht=17.08*Twindowi./(234.18+Twindowi);
            f=find(Twindowi<0);
            macht(f)=22.44*Twindowi(f)./(272.44+Twindowi(f));
            rvwindowi=Xvin(kow)./(Xsm*ex1.^macht);
            %Twdowe=Tx(kow)+(1-Regz.*Lglas).*(Te-Tx(kow));
            Twdowe=Tx(kow)+(1-Regz.*Lglas).*(Te-glaseps.*Lus0.*Reglas-Tx(kow));
            %Twindowe=Tx(kow)+(1-Regl.*Lglas).*(Te-Tx(kow));
            Twindowe=Tx(kow)+(1-Regl.*Lglas).*(Te-glaseps.*Lus0.*Reglas-Tx(kow));
            macht=17.08*Twindowe./(234.18+Twindowe);
            f=find(Twindowe<0);
            macht(f)=22.44*Twindowi(f)./(272.44+Twindowe(f));
            rvwindowe=Xe./(Xsm*ex1.^macht);
           
            for kwaex=1:length(kwall)
                Tw1(kwaex)=Tlaag{kwaex}(1);
                kc=kwall(kwaex);
                somnl=xcons(kc,1);
                Tw2(kwaex)=Tlaag{kwaex}(somnl);
                somnlv=somnl+xcons(kc,6)+xcons(kc,7);
                rvw1(kwaex)=rvlaag{kwaex}(1);
                rvw2(kwaex)=rvlaag{kwaex}(somnlv);
            end
            
            Twall1=(1-frdis)*Tw1old+frdis*Tw1;
            Tw1old=Tw1;
            Twall2=(1-frdis)*Tw2old+frdis*Tw2;
            Tw2old=Tw2;
            %rv
            rvwall1=(1-frdis)*rvw1old+frdis*rvw1;
            rvw1old=rvw1;
            rvwall2=(1-frdis)*rvw2old+frdis*rvw2;
            rvw2old=rvw2;
            
            Enr=Qtot(oriennr);
            Lnr=Ltot(oriennr);
            
            nninter=(nn-1)*interhour+inhour;
            Output.Ta(nninter,:)=Ta;
            Output.Tcom(nninter,:)=Tcom;
            Output.Tx(nninter,:)=Tx;
            Output.Qplant(nninter,:)=Ener;
            Output.Vent(nninter,:)=Vent;
            Output.Zon(nninter,:)=Zon;
            Output.Trans(nninter,:)=Trans;
            Output.Qint(nninter,:)=Qint;
            Output.Twflh1(nninter,:)=Twflh1;
            Output.RHa(nninter,:)=rvin;
            Output.Gplant(nninter,:)=Hum;
            Output.Gint(nninter,:)=Gint;
            Output.RHwflh1(nninter,:)=rvwflh1';
            Output.Enr(nninter,:)=Enr;
            Output.Lnr(nninter,:)=Lnr;
            Output.Tset(nninter,:)=Tset;
            %oppervlakte condities: 1 en 2 en i en e ninnen en buitenopp
            Output.Twall1(nninter,:)=Twall1;
            Output.Twindowi(nninter,:)=Twdowi;
            Output.RHwall1(nninter,:)=rvwall1;
            Output.RHwindowi(nninter,:)=rvwindowi;
            Output.Twall2(nninter,:)=Twall2;
            Output.Twindowe(nninter,:)=Twdowe;
            Output.RHwall2(nninter,:)=rvwall2;
            Output.RHwindowe(nninter,:)=rvwindowe;
        end %einde interhour
        if date(nn,3)==1&date(nn,5)==1&id>nin
            month=date(nn,2)
        end 
   %     if date(nn,4)==7&date(nn,5)==1&id>nin
   %         fwaitbar2(id-nin-1,aantaldagen,h);
   %     end
    end;% einde uurloop  

end;% einde dagloop
%delete(h)