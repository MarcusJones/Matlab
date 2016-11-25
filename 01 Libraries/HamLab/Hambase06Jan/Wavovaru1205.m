function [Control,Varu]=Wavovaru1205(nn,Tx,Ta,Varu,Profiles,Building,Control,InClimate)

ex1=2.71828182845904;  
% ----------------------------------------------------------------uurloop 
%variabele nn (urenteller van 1 tot aantaldagen*24),klizo(24 uren v/d dag)
% maart 2004 vertraging correct

id=fix((nn-1)/24)+1;
uur=nn-24*(id-1);

if uur==1
    iday1=InClimate.idag1+id;
    if iday1==366;
        iday1=1;
    end;
    
    klizo(1:24,1:5)=InClimate.kli((id-1)*24+1:id*24,:);
    
    [Esol,Lrad]=Zonfunf(iday1,InClimate.LSMLON,InClimate.LAT,Building.orbel,klizo,...
        Building.Or,InClimate.gref,Building.wschad);
    
    Varu.Esol=Esol;
    Varu.Lrad=Lrad;
    
end

Varu.Te=InClimate.kli(nn,2)/10;
phi=InClimate.kli(nn,5)/100;
macht=17.08*Varu.Te/(234.18+Varu.Te);
if Varu.Te<0
    macht=22.44*Varu.Te/(272.44+Varu.Te);
end;
Pse=611*ex1^macht;
Varu.Pe=phi*Pse/2340;

Lvmin=diag(Building.Ca/3600)*Profiles.vvminu(:,nn);
Lvmax=diag(Building.Ca/3600)*Profiles.vvmaxu(:,nn);
Control.Tsetmin=Profiles.Tsetu(:,nn);
Control.Tsetmax=Profiles.Tsetmaxu(:,nn);
Varu.Qint=Profiles.Qintu(:,nn);
Varu.Gint=Profiles.Gintu(:,nn);
Control.rvmin=Profiles.rvminu(:,nn)/100;
Control.rvmax=Profiles.rvmaxu(:,nn)/100;

%Free cooling: Ta is een vector 1,2,3 en ook Lvv
Lvv=Lvmin;
Lv=Lvv;
Ers=1500*ones(1,Building.zonetot);
k=find((Ta>Varu.Te) & (Ta<Control.Twws'));
Lv(k)=Lvv(k).*(1-Control.etaww(k)');
i=find(Ta>Profiles.Tvsu(:,nn));
Lv(i)=Lvmax(i);
Lvv(i)=Lv(i);
Varu.Lvv=Lvv;
Varu.Lv=Lv;

% Alleen zonwering als het te warm is (25 C)
Ers(i)=Profiles.Ersu(i,nn)';
Qtot=Varu.Esol(uur,:);
Ltot=Varu.Lrad(uur,:);
Qt0=Qtot(Building.or0);
Lu0=Ltot(Building.or0);
Qts0=Qtot(Building.orr0);
Lus0=Ltot(Building.orr0);

% Zonwering ZTA en 'convectiefactor'
ZTA0=Building.Tglas0;
Facr=(Building.Facr00);
Lglas=Building.Lglas0;
%Riglas=Building.Riglas;
Reglas=Building.Reglas;
glaseps=Building.glaseps;

i=find(Qts0>Ers*Building.Iow);
ZTA0(i)=Building.Tglasw0(i);
Facr(i)=Building.Facrw0(i);
Lglas(i)=Building.Lglasw0(i);
%Riglas(i)=Building.Riglasw(i);
Reglas(i)=Building.Reglasw(i);
%glaseps(i)=Building.glaseps(i);

Varu.Lgtot=Building.Iow*Lglas';
Ezon0=Qts0'.*ZTA0';
Varu.Zon=Building.Iow*Ezon0;

% Bepaling winst door zon en interne warmteproductie
Varu.figainx=Building.Iow*(Ezon0.*(1-Facr'))+Varu.Qint.*(1-Control.Faci);
Varu.figaina=Varu.Qint.*Control.Faci+Building.Iow*(Ezon0.*Facr');

%wanden
n=length(Building.aLex(:,1));
dthulp=-(Tx'*Building.Iex-Varu.Te0);
dela=[Varu.fgex(1:2,:);dthulp;Varu.fgex(3:n-1,:)];
fgxe=sum(Building.aLex.*dela);
Varu.fgex=[fgxe;dela(1,:);dela(3:n,:)];

dthulp=Varu.Tsolair0;
dela2=[Varu.fgexsa(1:2,:);dthulp;Varu.fgexsa(3:n-1,:)];
fgxesa=sum(Building.aLex.*dela2);
Varu.fgexsa=[fgxesa;dela2(1,:);dela2(3:n,:)];

n=length(Building.aLi(:,1));
dthulp=-(Tx'*Building.Ii0-Building.tempi0);
dela3=[Varu.fgi(1:2,:);dthulp;Varu.fgi(3:n-1,:)];
fgxi=sum(Building.aLi.*dela3);
Varu.fgi=[fgxi;dela3(1,:);dela3(3:n,:)];

Varu.Te0=Varu.Te-Building.Reeb0.*Lu0; 
Varu.Tsolair0=Building.Reab0.*Qt0; 
Varu.Tglase=Building.Iow*(Lglas'.*(Varu.Te'-glaseps'.*Lus0'.*Reglas'))./(Varu.Lgtot+eps);
fgtrans=Building.Iex*(fgxe'+(Building.Ldetae0.*Varu.Te0)')+Building.Ii0*(fgxi'+(Building.Ldetai0.*Building.tempi0)');
Varu.fzonab=Building.Iex*(fgxesa'+(Building.Ldetae0.*Varu.Tsolair0)');

if Building.zonetot >=2
    n=length(Building.aLin1(:,1));
    dthulp=-Tx'*Building.Iin;
    dela4=[Varu.fgin1(1:2,:);dthulp;Varu.fgin1(3:n-1,:)];
    fgxin=sum(Building.aLin1.*dela4);
    Varu.fgin1=[fgxin;dela4(1,:);dela4(3:n,:)];
    fgtrans=fgtrans+Building.Iin*fgxin';
end;
Varu.fgtrans=fgtrans;
Varu.Enr=Qtot(Building.oriennr);
Varu.Lnr=Ltot(Building.oriennr);
