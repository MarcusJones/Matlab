function [Xvin,fgvoud,rvin,Hum]=Xsolvo1202(fgv,Lvt,Lvv,link,Ca,fgvoud,...
   fbv0,rvmin,rvmax,Xvin,Ta,Xe,Gint,maxuurv,Gmax,Gmin)

% Oplossen van hygrisch model

% De grootheden Ta,en Xvin rvin en Hum zijn voor uurgemiddeld 
ex1=2.71828182845904;
facsat=2340/611;
Xsm=611*0.62e-5;

hulp=17.08*Ta./(234.18+Ta);
f=find(Ta<0);
hulp(f)=22.44*Ta(f)./(272.44+Ta(f));
hulpex1=ex1.^hulp;
Xsa=Xsm*hulpex1;

fgv1=fgv+Lvv'*Xe+Gint;
Cva=Ca.*(1+fbv0*facsat./hulpex1)/1000;
R1=Cva+0.5*Lvv'+0.5*Lvt;
S1=fgvoud+0.5*fgv1;
Xvin0=S1./R1;

Xvin1=Xvin;
n2=R1.*Xsa;
drvmin=Gmax./n2;
drvmax=Gmin./n2;

for nuur=1:maxuurv
   S12=0.5*((link/1000)*(0.8*Xvin+0.2*Xvin1)')';
   Xvin1=Xvin;
   Xvinh=Xvin0+S12./R1;
   rvinh=Xvinh./Xsa;
   rvmin1=min(rvmin,rvinh+drvmin);
   rvmax1=max(rvmax,rvinh+drvmax);
   rvin=rvinh+(rvinh<rvmin1).*(rvmin1-rvinh)+(rvinh>rvmax1).*(rvmax1-rvinh);
   Xvin=rvin.*Xsa;
end;
fgvoud=0.5*fgv1+(Cva-0.5*Lvv'-0.5*Lvt).*Xvin+S12;
Gextra=(rvin-rvinh).*n2;
%kJ/s
Hum=2500*Gextra;
