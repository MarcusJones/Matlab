function [Tx,Ta,Tcom,Ener,Trans,Vent]=Xsolwa1202(Lgtot,Lxa,Lx,Facp,Lv,link,Ldet,Ca,...
   fpmax1,fcmax1,Facset,Tset,Tsetmax,Te,Tx,Ta,figainx,figaina,fgtrans,fglas,maxuur)

fgeg1=fglas+fgtrans+figainx;
fgev1=figaina+Lv'*Te;

A110=Facp;
A120=Lxa;
A210=-(1-Facp);
A220=Lgtot+Lxa+Lx ;
detA=A110.*A220-A120.*A210;
A11=A110./detA;
A12=A120./detA;
A21=A210./detA;
A22=A220./detA;


B10=-Ta.*Ca-fgev1;
C1=Lxa+Lv'+Ca;
C2=Lxa;
z1=(A22.*C1-A12.*C2);
z2=(A11.*C2-A21.*C1);
noemert=(z2.*(1-Facset)+Facset);

Ta1=Ta;
Tx1=Tx;

for nuur=1:maxuur
   % Bepaling warmtestroom naar Ta
   fpmax=fpmax1.*(fpmax1>0);
   fcmax=fcmax1.*(fcmax1<0);
   fventlink=(link*(0.8*Ta+0.2*Ta1)')';
   B1=B10-fventlink; 
   ftransdet=(Ldet*(0.8*Tx+0.2*Tx1)')';
   B2=fgeg1+ftransdet;
   % vergelijkingen warmte Cranck-Nicolson ,luchttemp voorwaardse discretizatie
   Ta1=Ta;
   Tx1=Tx;
   
   y1=(A22.*B1-A12.*B2);
   y2=(A11.*B2-A21.*B1);
   
   % Fpp=y1+z1.*Ta; Tx=y2+z2.*Ta;
   Fpp=y1+z1.*(Tset-(1-Facset).*y2)./noemert;
   Fcp=y1+z1.*(Tsetmax-(1-Facset).*y2)./noemert;
   Ener=Fpp.*(Fpp>=0)+(Fpp>fpmax).*(fpmax-Fpp)+Fcp.*(Fcp<=0)+(Fcp<fcmax).*(fcmax-Fcp);
   Ta=(Ener-y1)./z1;
   Tx=y2+z2.*Ta;
end
Tcom=Facset.*Ta+(1-Facset).*Tx;
Vent= -Lv'.*(Te-Ta)-fventlink;
Trans=-fglas-fgtrans+Lgtot.*Tx+Lx.*Tx-ftransdet;

