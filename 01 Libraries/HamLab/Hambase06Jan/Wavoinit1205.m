function [Varu,Building,Control,Elan,x0]=Wavoinit1205(InClimate,InBuil,Control)

% met link luchtstroom tussen ruimten  alleen ingaande luchtstromen Linkv (rho*c*qv)
% max vermogen fpmax met momentane geleiding via wanden(Ldet), 2de orde
% met bevochtigen(latente warmte),weekendverlaging,zomertijd, vertrekconvectiefactor
% nog  regelingen opstoken,met delay 12-2-00 
% vertraging correct 03-2004 Ri Re cor dec2005 orr0 
zonetot=length(InBuil.zone);
Or=InBuil.Or;
wandex=InBuil.wandex;
window=InBuil.window;
Obstruc=InBuil.Obstruc;
wandi0=InBuil.wandi0;
wandia=InBuil.wandia;
wandin=InBuil.wandin;
con=InBuil.con;
glas=InBuil.glas;
vol=InBuil.vol;
CFfbi=InBuil.CFfbi;
fbv0=InBuil.fbv;
Linkv=InBuil.Linkv;
CFh=Control.CFh';
fpmax=Control.Qpmax;
CFset=Control.CFset';
CFint=Control.CFint';

%-------------------------------------------------------------------------
%_____Gebouw_______________________________________________________________
%-----------------------------------------------------------------------

% ---------------------------------------------------------------------------------

[Building,Elan,Atotzg]=rczonef1205(con,zonetot,wandex,wandia,wandi0,wandin);

aLex=Building.aLex;
aLi=Building.aLi;
aLin1=Building.aLin1;
Iex=Building.Iex;
Iin=Building.Iin;
Ii0=Building.Ii0;
Ldetae0=Building.Ldetae0;
Ldetai0=Building.Ldetai0;

tempi0=wandi0(:,4)';
kex=wandex(:,1)';%zone
or0=wandex(:,4)';
Aglas0=window(:,2)';
kw=window(:,1)';%wandex
orr0=or0(kw);     %de orientaties v/d ramen
kow=kex(kw);         %zone
Iow=zeros(zonetot,length(kow));
for i=1:zonetot
    Iow(i,:)=(kow==i);
end
Aglas=Aglas0*Iow';
Atot=Atotzg+Aglas;

if ~isempty(find(Aglas+Atot==0))
    error('There is a zone with neither walls nor windows')
end
% ---------------------------------------------------------------------------------

Ca=1200*vol;

hr=5;
%Re=0.04;
%Ri=0.13;
Ri=Building.Rimean;
hcv=1./Ri-hr;
%hcv=1/0.13-5;
hrx=hr+1;
%htotx=1/0.13+1;
htotx=1./Ri+1; 

% Berekening verwarmingsstroom factor andere bronnen:
Lxa=(Atot.*hcv).*(htotx./hrx);
Elan.Lrcvx=Atotzg'.*htotx';

bele0=window(:,4)';
kwindow=window(:,3)'; %glastype

% -------------------------------------------------------------------------------------
% Or: ki aantal orientaties,unieke combinatie orientatie met belemmering is
% extra orientatie, uitbreiding ki tot li (ki + extra combinaties in 
% orbel(k=orientatienr,l=schaduwnr),rijnummer is type 
% opslag van nummer in orr0 i.p.v. or0
% voor dichte wanden alleen or0, voor ramen orr0
k1=[sort(bele0),0];
k2=find(diff(k1)~=0);
kschaduw=k1(k2);

if max(kschaduw)>0;
    Building.wschad=shadowf0502(Obstruc,kschaduw);
else
    Building.wschad(1,:)=[0 1 2 0 0];
end;

ki=length(Or(:,1));
onr=ki;
orbel(1:onr,:)=[(1:onr)' zeros(onr,1)];
morbel=zeros(onr,length(Building.wschad(:,1)));
for i=1:length(kow)
    k=orr0(i);
    l=bele0(i);
    if l>0
        if morbel(k,l)==0
            onr=onr+1;
            morbel(k,l)=onr;
            orr0(i)=onr;
            orbel(onr,:)=[k l];
        else
            orr0(i)=morbel(k,l);
        end
    end;
end;

% ramen
Uglas=glas.Uglas(kwindow);
CFr0=glas.CFr(kwindow);
ZTA=glas.ZTA(kwindow);
ZTAw=glas.ZTAw(kwindow);
CFrw0=glas.CFrw(kwindow);
Uglasw=glas.Uglasw(kwindow);
Riglas=glas.Ri(kwindow);
Riglasw=glas.Riw(kwindow);

CFr=CFr0.*(1-CFfbi(kow))+CFfbi(kow);% correctie meubels
Tglas0=ZTA.*Aglas0;
%een gedeelte gaat weer terug door het raam naar buiten
cor=(Tglas0.*(1-CFr)*Iow'./Atot)*Iow;
CFrnew=CFr./(1-(1-CFr).*cor);
Building.Tglas0=Tglas0.*(1-(1-CFr).*cor);
Building.Facr00=CFrnew-(1-CFrnew).*hcv(kow)/hrx;
Building.Lglas0=Uglas.*Aglas0./(1-Uglas.*(Riglas-1./(1./Riglas+1)));%correctie Ri

CFrw=CFrw0.*(1-CFfbi(kow))+CFfbi(kow);
Tglasw0=ZTAw.*Aglas0;
cor=(Tglas0.*(1-CFr)*Iow'./Atot)*Iow;
CFrwnew=CFrw./(1-(1-CFrw).*cor);
Building.Tglasw0=Tglasw0.*(1-(1-CFrw).*cor);
Building.Facrw0=CFrwnew-(1-CFrwnew).*hcv(kow)/hrx;
Building.Lglasw0=Uglasw.*Aglas0./(1-Uglasw.*(Riglasw-1./(1./Riglasw+1)));

%Building.Riglas=Riglas;
Building.Reglas=glas.Re(kwindow);
%Building.Riglasw=Riglasw;
Building.Reglasw=glas.Rew(kwindow);
Building.glaseps=glas.eps(kwindow);

Building.Ca =Ca;
Elan.Ca =Ca';
Building.Iow=Iow;
Building.orbel=orbel;
Building.Or=Or;
Building.or0=or0;
Building.orr0=orr0;
Building.zonetot=zonetot;
Building.tempi0=tempi0;
Elan.fbv0=fbv0';
Elan.Lxa=Lxa';
Building.Atot=Atot;
Building.Aglas=Aglas;

%_einde gebouw_________________________________________________________________________________________

%------------------------------------------------------------------------------
%______regeling en installatie_________________________________________________________________
%-------------------------------------------------------------------------------


% Berekening verwarmingsstroom factor andere bronnen:

Elan.Facp=CFh-(1-CFh).*hcv'/hrx;
Control.Faci=CFint-(1-CFint).*hcv'/hrx;
Elan.Facset=CFset-(1-CFset).*hcv'/hrx;

% de maximale verwarmingscapaciteit
Lvmina=Ca.*Control.maxvvmin/3600;
Lex0=1+(sum(aLex)-1)./(1-aLex(1,:)-aLex(2,:))+Ldetae0;
Li0=1+(sum(aLi)-1)./(1-aLi(1,:)-aLi(2,:))+Ldetai0;
fpmax=(fpmax(1)>0).*fpmax+((fpmax==-2)*1.5+(fpmax==-1)*50).*...
    ((Lvmina+Building.Lglas0*Iow')*(20+10)+(Lex0*(20+10))*Iex'+(Li0.*(20-tempi0))*Ii0');

Elan.Link=(Linkv-diag(sum(Linkv')))/3;
Control.Qpmax=fpmax;

%------------------------------------------------------------------------------

%Initialisatie--------------------------------------------------------------------------------
Psref=2340;
ex1=2.71828182845904;

Te=InClimate.kli(1,2)/10;
phi=InClimate.kli(1,5)/100;
macht=17.08*Te/(234.18+Te);
if Te<0
    macht=22.44*Te/(272.44+Te);
end;
Pse=611*ex1^macht;
Pex=phi*Pse;

% temperaturen in de zone :
Ta=10*ones(zonetot,1);
Tx=Ta;
% Temperatuur in de wand (niet opp temp!) :
Tp=Ta;
Tq=Ta;
% Relatieve vochtigheid in de zone :
rvin=0.5*ones(zonetot,1);
% Dampspanning in de zone in de begintoestand :
hulp=17.08*Ta./(234.18+Ta);
f=find(Ta<0);
hulp(f)=22.44*Ta(f)./(272.44+Ta(f));
Psa=611*ex1.^hulp;
Pvin=Psa.*rvin;
Varu.Pvin=Pvin;

Fx=(Pvin/Psref).*(1+fbv0'*Psref./Psa);
% rv in in de wanden
Fp=rvin;
Fq=rvin;

Varu.Te0=Te*ones(1,zonetot)*Iex;
dTe0=-Tx'*Building.Iex-Varu.Te0;
dTi0=-Tx'*Building.Ii0-Building.tempi0;

% De warmtestroom door de constructies in de begintoestand :
fgex0=dTe0.*(1+(sum(aLex)-1)./(1-aLex(1,:)-aLex(2,:)));
Varu.fgex(1,:)=fgex0;
Varu.fgex(2,:)=fgex0;
for i=3:length(aLex(:,1))
    Varu.fgex(i,:)=dTe0;
end
fgi0=dTi0.*(1+(sum(aLi)-1)./(1-aLi(1,:)-aLi(2,:)));
Varu.fgi(1,:)=fgi0;
Varu.fgi(2,:)=fgi0;
for i=3:length(aLi(:,1))
    Varu.fgi(i,:)=dTi0;
end
if zonetot>=2
    fgxin0=-(Tx'*Iin).*(1+(sum(aLin1)-1)./(1-aLin1(1,:)-aLin1(2,:)));
    Varu.fgin1(1,:)=fgxin0;
    Varu.fgin1(2,:)=fgxin0;
    for i=3:length(aLin1(:,1))
        Varu.fgin1(i,:)=-Tx'*Iin;
    end
else
    Varu.fgin1=0;
end
Varu.fgexsa=0*Varu.fgex;
Varu.Tsolair0=0*dTe0;

Varu.Te=Te;
Varu.Rva=rvin;
Varu.Pe=Pex/Psref;
x0  = [Tp;Tq;Ta;Fp;Fq;Fx];

% ---------------------------------------------------------------------

Building.oriennr=InBuil.oriennr;

%---------------------------------------------