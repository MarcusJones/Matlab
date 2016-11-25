function [Twflh,rvwflh,Twflh2,rvwflh2,delTvloerin,Tvec,fpflh,fpflh2,qvec,qvec2,...
      delfigain,delfigain2,Ener,Ener3,fpmax1,fcmax1]=...
  Xflh1202(Xvin,delTvloerin,Tvec,fpflh,fpflh2,qvec,qvec2,delfigain,Ener,fpmax1,fcmax1,...
   conheatcool1,Tlaagh,iterend,basis);

zonetot=length(Ener);
Twflh=zeros(1,zonetot);
rvwflh=zeros(1,zonetot);
Twflh2=zeros(1,zonetot);
rvwflh2=zeros(1,zonetot);
% pas op volgorde respfac
delfigain2=zeros(1,zonetot);
% conheatcool(1,:)=[kn,fimaxcon0,oppervlakte,Tmax,izone,izone2,Ri,Re,somnlst,respfac(constructie,1:15)]
Ener0=Ener;
Ener3=Ener;
nfloor=length(conheatcool1(:,1));
for i=1:nfloor
   conheatcool=conheatcool1(i,:);
   kn=conheatcool(1);
   somnlst=conheatcool(9);
   Tlag=Tlaagh{kn};
   %laag: opp==1, steeds laag R(laag)< Rthr (vanaf opp)
   izone=conheatcool(5);
   izone2=conheatcool(6);
   basis0=basis(izone);
   respfacq=conheatcool(10:14);
   respfacT=conheatcool(15:19);
   respfacq2=conheatcool(20:24);
   Tdiep=Tlag(somnlst);
   Tmax=conheatcool(4); 
   fimaxcon0=conheatcool(2);
   if iterend
      Qin=(basis0*delfigain(izone)+(1-basis0)*Ener(izone))/respfacq(1);
      Ener(izone)=Qin+Ener0(izone)*basis0;
      Ener3(izone)=basis0*Ener0(izone);
      
      LqflA=conheatcool(3)/conheatcool(7);
      %Tvloerin temp verhoging aanvoer
      Tvloerin=delTvloerin(izone)+respfacT(1)*Qin;
      Tvec(izone,:)=[Qin Tvloerin Tvec(izone,[1:2])];
      delTvloerin(izone)=respfacT(2:5)*Tvec(izone,:)';
      
      qvloeruit=fpflh(izone)+respfacq(1)*Qin;
      qvec(izone,:)=[Qin qvloeruit qvec(izone,[1:2])];
      fpflh(izone)=respfacq(2:5)*qvec(izone,:)';
      %oppervlaktetemp
      Twflh(izone)=Tlag(1)+qvloeruit/LqflA;
      xsat=611*(0.62e-5)*exp(17.08*Twflh(izone)/(234.18+Twflh(izone)));
      rvwflh(izone)=Xvin(izone)/xsat;
      
      if  izone2>0
         somnl=length(Tlag);
         LqflA2=conheatcool(3)/conheatcool(8);
         
         qvloeruit=fpflh2(izone2)+respfacq2(1)*Qin;
         qvec2(izone2,:)=[Qin qvloeruit qvec2(izone2,[1:2])];
         fpflh2(izone2)=respfacq2(2:5)*qvec2(izone2,:)';
         %oppervlaktetemp
         Twflh2(izone2)=Tlag(somnl)+qvloeruit/LqflA2;
         xsat=611*(0.62e-5)*exp(17.08*Twflh(izone2)/(234.18+Twflh(izone2)));
         rvwflh2(izone2)=Xvin(izone2)/xsat;
      end
      
   end %iterend
   
   maxener=respfacq(1)*(Tmax-Tdiep-delTvloerin(izone))/respfacT(1);
   if basis0
      Enerfl0=maxener;
      delfigain(izone)=maxener;
   else
      fpmax11=min(maxener,fimaxcon0);
      fpmax11=fpmax11*(fpmax11>0);
      fpmax1(izone)=fpmax11;
      fcmax11=max(maxener,fimaxcon0);
      fcmax11=fcmax11.*(fcmax11<0);
      fcmax1(izone)=fcmax11;
      Enerfl0=Ener0(izone);
   end
   
   if  izone2>0
      delfigain2(izone2)=Enerfl0*respfacq2(1)/respfacq(1);
   end
   
   %als energie naar 2 zones dan wordt de som naar de hoofdzone toegeschreven
   
end

