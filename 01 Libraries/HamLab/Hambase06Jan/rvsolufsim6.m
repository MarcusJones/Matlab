function [Pvin,Px,rvin,rvwand,Hum,CvaPi,C1P1,C2P2]=rvsolufsim6(Pe,Ta,Tw,Gint,maxuurv,rvmin,rvmax,Lvv,Pvin,CvaPi,C1P1,C2P2,Elan,Gmin,Gmax)
 %regel 65 dec2005     
   fbv0=Elan.fbv0;
   link=Elan.Link;
   Ca=Elan.Ca/3600;
   Cv1=Elan.Cv1/3600;
   Cv2=Elan.Cv2/3600;
   alv1n=Elan.alv1n;
   alv2n=Elan.alv2n;

%# scalar ex1 nuur Psref
% Oplossen van hygrisch model

% De temperaturen Ta,Tx en Tw worden beschouwd als 'uurgemiddelden',
% Ca is door 3600 gedeeld
als=0.6;
ex1=2.71828182845904;
Psref=2340;
Pe=Pe*Psref;
hulp=17.08*Ta./(234.18+Ta);
f=find(Ta<0);
hulp(f)=22.44*Ta(f)./(272.44+Ta(f));
Psa=611*ex1.^hulp;
Cva=Ca.*(1+fbv0*Psref./Psa)/als;

hulp=17.08*Tw./(234.18+Tw);
f=find(Tw<0);
hulp(f)=22.44*Tw(f)./(272.44+Tw(f));
Psm=611*ex1.^hulp;
Prel=Psref./Psm;
alvn1=1-exp(-alv1n./Prel);
alvn2=1-exp(-alv2n./Prel);
Lv1=alvn1.*Prel.*Cv1;
Lv2=alvn2.*Prel.*Cv2;
aC1P1=alvn1.*C1P1;
aC2P2=alvn2.*C2P2;
%g1=alvn1*(Cv1Pa-c1P1)
%g2=alvn2*(Cv2Pa-c2P2)
noemer=(Cva+Lv1+Lv2+Lvv);

Pvin00=(CvaPi+aC1P1+aC2P2+Lvv*Pe+Gint/(0.62e-8))./noemer;

Pvin1=Pvin;
n2=noemer.*Psa*(0.62e-8);
drvmin=Gmax./n2;
drvmax=Gmin./n2;

for nuur=1:maxuurv
   S12=link*(0.8*Pvin+0.2*Pvin1);
   Pvin1=Pvin;
   Pvinh=Pvin00+S12./noemer;
   rvinh=Pvinh./Psa;
   rvmin1=min(rvmin,rvinh+drvmin);
   rvmax1=max(rvmax,rvinh+drvmax);
   rvin=rvinh+(rvinh<rvmin1).*(rvmin1-rvinh)+(rvinh>rvmax1).*(rvmax1-rvinh);
   Pvin=rvin.*Psa;
   %rvin-rvinh
end;
%noemer*(0.62e-8)
Gextra=(rvin-rvinh).*n2;
C1P1=C1P1+Lv1.*Pvin-aC1P1;
C2P2=C2P2+Lv2.*Pvin-aC2P2;
Px=(aC1P1+aC2P2)./(Lv1+Lv2);

CvaPi=Pvin.*Cva/als-CvaPi*(1-als)/als;
%CvaPi=2*Pvin.*Cva-CvaPi;
rvwand=Px./Psm;
Hum=2500*1000*Gextra;
