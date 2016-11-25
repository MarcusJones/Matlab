function [fg,F,fgv,CCvo,Fv,Lxv,Xlaag]=Xinitwavo1202(MM,RR,CC,kwall,Ti0,Te0,k1,k2,xcons,MMV,RRV,CCV,Xi0,Xe0,frdis)
%Vanaf wandoppervlak fgxi=A*FF(1)*Lq+Lie(Te-Ti)-LiTi
%fgxe=A*FF*Lq+Lie(Ti-Te)-LeTe
%T van binnen naar buiten
ex1=2.71828182845904;
facsat=2340/611;

for kwaex=1:length(kwall)
   kc=kwall(kwaex);
   M=MM{kc};
   Cq=CC{kc};
   Lq=RR{kc};
   somnl=length(Lq)-1;
   R0=cumsum(1./Lq);
   T=(Ti0(kwaex)+(Te0(kwaex)-Ti0(kwaex))*R0(1:somnl)/R0(somnl+1));
   FF=M\(Cq.*T);
   
   F{kwaex}=T*(1-1/frdis)+FF/frdis;
   qi1(kwaex)=FF(1)*Lq(1);
   qe1(kwaex)=FF(somnl)*Lq(somnl+1);
   
   Lvq=RRV{kc};
   somnlv=length(Lvq)-1;
   Rv0=cumsum(1./Lvq);
   Xo=(Xi0(kwaex)+(Xe0(kwaex)-Xi0(kwaex))*Rv0(1:somnlv)/Rv0(somnlv+1));
   
   Cv=CCV{kc}; %onafh v temp
   nlvi=xcons(kc,6);
   nlve=xcons(kc,7);
   %somnlv=somnl+nlvi+nlve;
   T1=[T(1),T(1)+2.^(-nlvi:-1)*(T(2)-T(1)),T(2:somnl-1)',...
         T(somnl-1)+(1-2.^(-1:-1:-nlve))*(T(somnl)-T(somnl-1)),T(somnl)];
   hulp=17.08*T1./(234.18+T1);
   f=find(T1<0);
   hulp(f)=22.44*T1(f)./(272.44+T1(f));
   Cvn=CCV{kc}.*(facsat*ex1.^(-hulp))';
   Mn=MMV{kc}+diag(Cvn);
   FFv=Mn\(Cvn.*Xo);
   
   Fv{kwaex}=(1-1/frdis)*Xo+FFv/frdis;
   gi1(kwaex)=FFv(1)*Lvq(1);
   ge1(kwaex)=FFv(somnlv)*Lvq(somnlv+1);
   CCvo{kwaex}=Cvn;
   
   r=eye(somnlv,1);
   r(somnlv)=1;
   cvtie=Mn\r;
   Liv(kwaex)=(1-frdis*cvtie(1)*xcons(kc,4))*xcons(kc,4);
   Lev(kwaex)=(1-frdis*cvtie(somnlv)*xcons(kc,5))*xcons(kc,5);
   Xlaag{kwaex}=Xo;
   nlvi=xcons(kc,6);
   nlve=xcons(kc,7);
   somnl=xcons(kc,1);
   somnlv=somnl+nlvi+nlve;
   
   
   
end;
fg=qi1*k1'+qe1*k2';
fgv=gi1*k1'+ge1*k2';
Lxv=Liv*k1'+Lev*k2';
