function [Tx,Ta,Tpee,Tkuu,Tw,Tcom,Ener,Trans,Vent,Transglas]=tsolufsim4(Lgtot,Lv,...
   fpmax,fcmax,Tset,Tsetmax,Tx,Ta,Tpee,Tkuu,figainx,figaina,fgtrans,Tglase,maxuur,Te,fzonab,Elan)

   Lxa=Elan.Lxa;
   Lx1=Elan.Lx1;
   Lx2=Elan.Lx2;
   Cx1=Elan.Cx1/3600;
   Cx2=Elan.Cx2/3600;
   Ldeta=Elan.Ldeta;
   Facp=Elan.Facp;
   link=Elan.Link;
   Ldet=Elan.Ldet;
   Ca=Elan.Ca/3600;
   Lrcvx=Elan.Lrcvx;
   Facset=Elan.Facset;
   
%# scalar nuur

%oplossen van thermisch model

% alle grootheden zijn gemiddeld,de gemiddelde warmtestroom 
% regelcrit:Tset en rv, Ca is hier al door 3600 gedeeld
    
fgeg1=Lgtot.*Tglase+fgtrans+figainx+fzonab;
fgev1=figaina+Lv.*Te;

A110=Facp;
A120=Lxa;
A210=-(1-Facp);
A220=Lgtot+Lxa+Lx1+Lx2+Ldeta; 
detA=A110.*A220-A120.*A210;
A11=A110./detA;
A12=A120./detA;
A21=A210./detA;
A22=A220./detA;

B10=-Ta.*Ca-fgev1;
C1=Lxa+Lv+Ca;
B20=Lx1.*Tpee+Lx2.*Tkuu+fgeg1;
C2=Lxa;
z1=(A22.*C1-A12.*C2);
z2=(A11.*C2-A21.*C1);
noemert=(z2.*(1-Facset)+Facset);

Ta1=Ta;
Tx1=Tx;

for nuur=1:maxuur
   % Bepaling warmtestroom naar Ta
   fventlink=(link*(0.8*Ta+0.2*Ta1));
   B1=B10-fventlink;
   ftransdet=(Ldet*(0.8*Tx+0.2*Tx1));
   B2=ftransdet+B20;
   % vergelijkingen warmte Cranck-Nicolson ,luchttemp voorwaardse discretizatie
   Ta1=Ta;
   Tx1=Tx;
         
   y1=(A22.*B1-A12.*B2);
   y2=(A11.*B2-A21.*B1);
   
   % Fpp=y1+z1.*Ta; Tx=y2+z2.*Ta;
   Fpp=y1+z1.*((Tset-(1-Facset).*y2)./noemert);
   Fcp=y1+z1.*(Tsetmax-(1-Facset).*y2)./noemert;
   Ener=Fpp.*(Fpp>=0)+(Fpp>fpmax).*(fpmax-Fpp)+Fcp.*(Fcp<=0)+(Fcp<fcmax).*(fcmax-Fcp); %------ aangepast!
   Ta=(Ener-y1)./z1;
   Tx=y2+z2.*Ta;
end
Tcom=Facset.*Ta+(1-Facset).*Tx;
fw1=Lx1.*(Tx-Tpee);
fw2=Lx2.*(Tx-Tkuu);
Tpee=Tpee+fw1./Cx1;
Tkuu=Tkuu+fw2./Cx2;
Tw=Tx+(-fw1-fw2+fgtrans+fzonab-Ldeta.*Tx+ftransdet)./Lrcvx;

Trans=-Lgtot.*Tglase-fgtrans+Lgtot.*Tx+Ldeta.*Tx-ftransdet;
Vent= Lv.*(Ta-Te)-fventlink;
Transglas=-Lgtot.*Tglase+Lgtot.*Tx;
