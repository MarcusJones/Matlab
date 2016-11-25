function [Tlaag,fg,F,fgv,Fv,Lxv,CCVo,Mnieuw]=Xwallwa1202(xcons,MM,CC,kwall,F,Txh,Te00,tempi0,MMV,CCV,CCVo,Fv,Xlaag,k1,k2,kbin,kbuit,frdis)

%fgv en Lxv
%Vanaf wandoppervlak fgxi=A*FF(1)*Lq+Lie(Te-Ti)-LiTi
%fgxe=A*FF*Lq+Lie(Ti-Te)-LeTe
ex1=2.71828182845904;
facsat=2340/611;
Xref=2340*0.62e-5;
Ti0=Txh(kbin);
Te0=[Te00,tempi0,Txh(kbuit)];

for kwaex=1:length(kwall)
   kc=kwall(kwaex);
   Cq=CC{kc};
   somnl=xcons(kc,1);
   M=MM{kc};
   r=Ti0(kwaex)*eye(somnl,1)*xcons(kc,2);
   r(somnl)=Te0(kwaex)*xcons(kc,3);
   T=F{kwaex}+M\r;
   FF=M\(Cq.*T);
   
   F{kwaex}=(1-1/frdis)*T+FF/frdis;
   qi1(kwaex)=FF(1)*xcons(kc,2);
   qe1(kwaex)=FF(somnl)*xcons(kc,3);
   
   Cv=CCV{kc}; %onafh van temp
   nlvi=xcons(kc,6);
   nlve=xcons(kc,7);
   somnlv=somnl+nlvi+nlve;
   T1=[T(1),T(1)+2.^(-nlvi:-1)*(T(2)-T(1)),T(2:somnl-1)',...
         T(somnl-1)+(1-2.^(-1:-1:-nlve))*(T(somnl)-T(somnl-1)),T(somnl)];
   hulp=17.08*T1./(234.18+T1);
   f=find(T1<0);
   hulp(f)=22.44*T1(f)./(272.44+T1(f));
   Cvn=facsat*Cv.*ex1.^(-hulp)';
   Cvo=CCVo{kwaex};
   
   Mn=MMV{kc}+diag(Cvn);

   Xo=Xlaag{kwaex};
   FFv=Mn\((frdis*Cvo+(1-frdis)*Cvn).*Xo);
   
   Fv{kwaex}=(1-1/frdis)*Xo+FFv/frdis;
   gi1(kwaex)=FFv(1)*xcons(kc,4);
   ge1(kwaex)=FFv(somnlv)*xcons(kc,5);
   CCVo{kwaex}=Cvn;
   
   r=eye(somnlv,1);
   r(somnlv)=1;
   cvtie=Mn\r;
   Liv(kwaex)=(1-frdis*cvtie(1)*xcons(kc,4))*xcons(kc,4);
   Lev(kwaex)=(1-frdis*cvtie(somnlv)*xcons(kc,5))*xcons(kc,5);
   Tlaag{kwaex}=T;
   Mnieuw{kwaex}=Mn;
end;
fg=qi1*k1'+qe1*k2';
fgv=gi1*k1'+ge1*k2';
Lxv=Liv*k1'+Lev*k2';
