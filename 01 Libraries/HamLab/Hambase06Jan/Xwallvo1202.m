function [rvlaag,Xlaag]=Xwallvo1202(kwall,xcons,Mnieuw,CCV,CCVo,Fv,Xvin,Xe0,Xei0,kbin,kbuit)


Xref=2340*0.62e-5;
Xim=Xvin(kbin);
Xem=[Xe0,Xei0,Xvin(kbuit)];

for kwaex=1:length(kwall)
   kc=kwall(kwaex);
   nlvi=xcons(kc,6);
   nlve=xcons(kc,7);
   somnl=xcons(kc,1);
   somnlv=somnl+nlvi+nlve;

   Cv=CCV{kc}; 
   Cvn=CCVo{kwaex};
   Mn=Mnieuw{kwaex};
   alvn=Cvn./Cv;
   r=Xim(kwaex)*eye(somnlv,1)*xcons(kc,4); 
   r(somnlv)=Xem(kwaex)*xcons(kc,5);
   Xn=Fv{kwaex}+Mn\r; %luchtvochtgehaltes
   rv=(Xn.*alvn/Xref);% rel vocht per tijdstip
   rvlaag{kwaex}=rv;
   Xlaag{kwaex}=Xn;
end
