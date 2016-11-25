% function Out=spouw(rho,tau,R,sp,VA,hc1,hc2,hr,rhozw,tauzw,hczw)
% Berekening klimaatraam/tweede huid etc, een geventileerde spouw met evt
% zonwering
%
% Input: rho,tau,R,sp,VA,hc1,hc2,hr,rhozw,tauzw,hczw
% Input R: Re,Rlaag1,Rspouw1,Rlaaag2,Rspouw2,....,Ri  van buiten naar binnen zonder ventilatie 
% en zonwering (dus: aantal 2*lagen+1)
% rho: reflectiefactor per laag van buiten naar binnen, beweegbare zonwering omhoog 
% tau: doorlating per laag van buiten naar binnen, beweegbare zonwering omhoog
% tauzw: doorlating van de zonwering
% sp: spouwnummer van buiten naar binnen (maximaal aantal lagen-1) met de ventilatie en evt zonwering
% hc1: convectieve overdrachtcoefficient aan de buitenzijde van de spouw 
% hc2: convectieve overdrachtcoefficient aan de binnenzijde van de spouw
% hr: stralings overdrachtcoefficient tussen de binnenzijde en de buitenzijde van de spouw
% VA: spouwventilatie in m3/uur per m2 raam
%
% zonwering in geventileerde spouw
% rhozw: reflectiefactor van de zonwering
% tauzw: doorlatingsfactor van de zonwering
% hczw: totale convectieve overdrachtscoeff zonwering-spouwlucht
%
% Output: Out(k,:)=[U0,Ui,VAi,Ue,VAe,ZTA,CFr,ZTAextra]; k==1: zonder zonwering, k==2 met zonwering
% U0: U-waarde zonder ventilatie
% Ui: (schijnbare) U-waarde indien de binnenlucht in de spouw stroomt 
% VAi schijnbare extra ventilatie door afgekoelde binnenlucht die terug naar binnen
% gaat m3/hr/m2 (positief)
% Ue: (schijnbare) U-waarde indien de buitenlucht in de spouw stroomt
% VAe schijnbare vermindering van ventilatie door opwarming van buitenlucht die naar 
% binnen gaat m3/hr/m2 (negatief)
% ZTA,CFr: ZTA en convectiefactor
% ZTAextra als de lucht uit de spouw naar binnen gaat (extra ZTA maar volledig convectief) 
% 
% 
% Binnenlucht die via de spouw weer terug naar binnen gaat: Lucht wordt
% extra afgekoeld en moet weer verwarmd worden. Als de lucht naar buiten
% gaat is dat niet zo dus extra verlies VAi% qtrans=Ui(Te-Ti),qventextra =VAi(Te-Ti)/3
% Buitenlucht die via de spouw weer terug naar buiten gaat: Lagere U-waarde
% door afkoeling van de spouw. Als die lucht naar binnen gaat is die wat
% voorverwarmd dus t.o.v normale ventilatielucht is er warmteterugwinning.
% Verondersteld wordt dat de ventilatie door de spouw een onderdeel is van 
% de totale ventilatie van het vertrek, er is nu dus sprake van winst
% qtrans=Ue(Te-Ti), qventextra = VAe(Te-Ti)/3 (VAe is negatief)
% Door de stromende lucht wordt de ZTA verminderd. Als deze lucht naar binnen stroomt
% komt de geabsorbeerde zonnewarmte wel binnen (convectief): ZTAextra 
% Dus als de lucht naar binnen stroomt is de fictieve ZTA: ZTA+ZTAextra en de convectiefactor (CFr*ZTA+ZTAextra)/(ZTA+ZTAextra)
% 
clear all
%Example

rho=[0.01,0.01,0.01];
tau=[0.9, 0.9, 0.9];

%buiten naar binnen (R(1)=Re)
R=[0.04 0.05 0.13 0.05 0.16 0.05 0.13];
Va=100/3600;
%geventileerde spouw R=1/hr links/rechts =1/hc na sp begint spouw
sp=2;
hc1=3;
hc2=3;
hr=5;
rho0=1.2;
cp=1000;
% zonwering in geventileerde spouw
rhozw=0.2;
tauzw=0.5;
%totale convectieve overdrachtscoeff zonwering-spouwlucht
hczw=10;
Te=0;
Ti=20;
Ez=100;

%-------------------------------------------------------------
Lc0=rho0*cp*Va;
ncon=length(R);

%--------------------Zonder zonwering----------------------------
ae=1-rho-sqrt(tau.*(1-rho));
ai=sqrt(tau.*(1-rho))-tau;
nlagen=length(rho);

k=find(tau==0);
tau(k)=eps;
a=1./tau;
b=-rho./tau;
d=tau.*(1-b.^2);

%[Lv(1),Lv(2)](n)=[1/tau,-rho/tau;rho/tau,tau-rho^2/tau][Lv(1),Lv(2)](n+1)  Lv(1) van
%binnenoppervlak Lv(2) naar binnenoppervlak
Lv=[1;0];
for i=[nlagen:-1:1]
    A=[a(i) b(i); -b(i) d(i)];
    ali(i)=ai(i)*Lv(2);
    ale(i)=ae(i)*Lv(2);
    Lv= A*Lv;
    ali(i)=ali(i)+ae(i)*Lv(1);
    ale(i)=ale(i)+ai(i)*Lv(1);
end
Tautot=1/Lv(1);
reftot=Lv(2)/Lv(1);

abcon1(1:2:ncon-2)=ale/Lv(1);
abcon1(2:2:ncon-1)=ali/Lv(1);

abcon(2*sp+2:ncon)=abcon1(2*sp+1:ncon-1);
abcon(1:2*sp)=abcon1(1:2*sp);

%-------------------------------------------------

L(1:2*sp)=1./R(1:2*sp);
L(2*sp+1)=hc1;
L(2*sp+2)=hc2;
L(2*sp+3:ncon+1)=1./R(2*sp+2:ncon);

C=diag(L(1:ncon))+diag(L(2:ncon+1))-diag(L(2:ncon),-1)-diag(L(2:ncon),1);
C(2*sp,2*sp)=C(2*sp,2*sp)+hr;
C(2*sp,2*sp+2)=C(2*sp,2*sp+2)-hr;
C(2*sp+2,2*sp+2)=C(2*sp+2,2*sp+2)+hr;
C(2*sp+2,2*sp)=C(2*sp+2,2*sp)-hr;
Bq=zeros(ncon,1);
Bq(1)=L(1);
T=C\Bq;
U0=L(1)*(1-T(1));

C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)+2*Lc0;
Bq(1)=0;
Bq(2*sp+1)=2*Lc0;
T=C\Bq;
Uv=2*Lc0*(1-T(2*sp+1))/T(2*sp+1);
C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)-2*Lc0;

s=Uv/(Lc0+eps);
Lc=Uv*(1-exp(-s))/(s-1+exp(-s));
C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)+Lc;

%--------------buitenlucht in spouw--------------------
Bq=[Te*L(1);zeros(ncon-2,1);Ti*L(ncon+1)];
Bq(2*sp+1)=Lc*Te;
Ttrans=C\Bq;
qtrans=L(ncon+1)*(Ttrans(ncon)-Ti);
Ue=-qtrans/(Ti-Te);
qventuit=Lc*(Te-Ttrans(2*sp+1));
VAe=qventuit/(rho0*cp*(Ti-Te));
%------binnenlucht in spouw----------------
Bq(2*sp+1)=Lc*Ti;
Ttrans=C\Bq;
qtrans=L(ncon+1)*(Ttrans(ncon)-Ti);
Ui=-qtrans/(Ti-Te);
qventuit=Lc*(Ti-Ttrans(2*sp+1));
VAi=qventuit/(rho0*cp*(Ti-Te));
%------------zon-------------------------------------------------
Bq=abcon'*Ez;
Tzon=C\Bq;
qzon=L(ncon+1)*Tzon(ncon);
tau1=qzon/Ez;
ZTAextra=Lc*(Tzon(2*sp+1))/Ez;
ZTA=Tautot+tau1;
CFr=(L(ncon+1)-5)*Tzon(ncon)/Ez/ZTA;

Out(1,:)=[U0,Ui,3600*VAi,Ue,3600*VAe,ZTA,CFr,ZTAextra];
%-------------------------------------------------------------



%--------------------Met zonwering----------------------------
rhoz=[rho(1:sp),rhozw,rho(sp+1:nlagen)];
tauz=[tau(1:sp),tauzw,tau(sp+1:nlagen)];
ae=1-rhoz-sqrt(tauz.*(1-rhoz));
ai=sqrt(tauz.*(1-rhoz))-tauz;

nlagen=length(rhoz);
k=find(tauz==0);
tauz(k)=eps;
a=1./tauz;
b=-rhoz./tauz;
d=tauz.*(1-b.^2);
Lv=[1;0];
for i=[nlagen:-1:1]
    A=[a(i) b(i); -b(i) d(i)];
    ali(i)=ai(i)*Lv(2);
    ale(i)=ae(i)*Lv(2);
    Lv= A*Lv;
    ali(i)=ali(i)+ae(i)*Lv(1);
    ale(i)=ale(i)+ai(i)*Lv(1);
end
Tautot=1/Lv(1);
reftot=Lv(2)/Lv(1);

abcon1(1:2:ncon)=ale/Lv(1);
abcon1(2:2:ncon+1)=ali/Lv(1);

abcon(2*sp+2:ncon)=abcon1(2*sp+3:ncon+1);
abcon(1:2*sp)=abcon1(1:2*sp);
abcon(ncon+1)=abcon1(2*sp+1)+abcon1(2*sp+2);

%----------------------------------

C(2*sp,2*sp+2)=C(2*sp,2*sp+2)+hr;
C(2*sp,ncon+1)=-hr;
C(2*sp+2,2*sp)=C(2*sp+2,2*sp)+hr;
C(2*sp+2,ncon+1)=-hr;
C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)-Lc+hczw;
C(2*sp+1,ncon+1)=-hczw;
C(ncon+1,ncon+1)=hczw+2*hr;
C(ncon+1,2*sp+1)=-hczw;
C(ncon+1,2*sp)=-hr;
C(ncon+1,2*sp+2)=-hr;

Bq=zeros(ncon+1,1);
Bq(1)=L(1);
T=C\Bq;
U0=L(1)*(1-T(1));

C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)+2*Lc0;
Bq(1)=0;
Bq(2*sp+1)=2*Lc0;
T=C\Bq;
Uv=2*Lc0*(1-T(2*sp+1))/T(2*sp+1);
C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)-2*Lc0;

s=Uv/(Lc0+eps);
Lc=Uv*(1-exp(-s))/(s-1+exp(-s));
C(2*sp+1,2*sp+1)=C(2*sp+1,2*sp+1)+Lc;

%--------------buitenlucht in spouw--------------------
Bq=[Te*L(1);zeros(ncon-2,1);Ti*L(ncon+1);0];
Bq(2*sp+1)=Lc*Te;
Ttrans=C\Bq;
qtrans=L(ncon+1)*(Ttrans(ncon)-Ti);
Ue=-qtrans/(Ti-Te);
qventuit=Lc*(Te-Ttrans(2*sp+1));
VAe=qventuit/(rho0*cp*(Ti-Te));
%------binnenlucht in spouw----------------
Bq(2*sp+1)=Lc*Ti;
Ttrans=C\Bq;
qtrans=L(ncon+1)*(Ttrans(ncon)-Ti);
Ui=-qtrans/(Ti-Te);
qventuit=Lc*(Ti-Ttrans(2*sp+1));
VAi=qventuit/(rho0*cp*(Ti-Te));
%---------zon----------------------
Bq=abcon'*Ez;
Tzon=C\Bq;
qzon=L(ncon+1)*Tzon(ncon);
tau1=qzon/Ez;
ZTAextra=Lc*(Tzon(2*sp+1))/Ez;
ZTA=Tautot+tau1;
CFr=(L(ncon+1)-5)*Tzon(ncon)/Ez/ZTA;

Out(2,:)=[U0,Ui,3600*VAi,Ue,3600*VAe,ZTA,CFr,ZTAextra];
Out

bar(Out),legend('U0','Ui','3600*VAi','Ue','3600*VAe','ZTA','CFr','ZTAextra')