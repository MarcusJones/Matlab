function [conheatcool1,CFhcon,CFhcon2,basis]=Xinitflh1202(Flheat,interhour,RR,InBuil,zonetot)
% vloerverwarminginitialisatie
%fimaxcon0:max Watts dat geleverd kan worden in eerste tijdstap naar boven==Qmax, qmax is ingaand
%conheatcool1:vector met data
%nfloor aantal vloeren met vloerverw
% conheatcool(1:nfloor,1:24)=[kn,fimaxcon0,oppervlakte,Tmax,izone,izone2,Ri,Re,somnlst,respfacup,respfactemp,respfacdown]
% Author: Martin de Wit dec-2002

nfloor=length(Flheat.wandnr);
CFhcon2=zeros(1,zonetot);
con=InBuil.con;
CFhcon=zeros(1,zonetot);
basis=ones(1,zonetot);
for i=1:nfloor
   br=Flheat.br(i);
   Rvw_s=Flheat.Rvw_s(i);
   wandtyp=Flheat.wandtyp(i);
   wandnr=Flheat.wandnr(i);
   Ri=Flheat.Ri(i);
   Re=Flheat.Re(i);
   Afloor=Flheat.oppervlakte(i);
   Tmax=Flheat.Tmax(i);
   Rf=Flheat.Rflow(i);
   fig=Flheat.fig(i);
   basis0=Flheat.basis(i);
   qmax=Flheat.qmax(i);
   conheatcool1(i,24)=0;
   izone2=0;
   if wandtyp==-1
      izone=InBuil.wandex(wandnr,1);
      k=find(InBuil.wandex(:,6)'==wandnr);
      kc=InBuil.wandex(k,3);
      kn=k;
   elseif wandtyp==0
      izone=InBuil.wandi0(wandnr,1);
      k=find(InBuil.wandi0(:,6)'==wandnr);
      kc=InBuil.wandi0(k,3);
      kn=length(InBuil.wandex(:,1))+k;
   elseif wandtyp==-2
      izone=InBuil.wandia(wandnr,1);
      k=find(InBuil.wandia(:,4)'==wandnr);
      kc=InBuil.wandia(k,3);
      kn=length(InBuil.wandex(:,1))+length(InBuil.wandi0(:,1))+k;
   elseif wandtyp>=1
      izone=InBuil.wandin(wandnr,1);
      k=find(InBuil.wandin(:,5)'==wandnr);
      izone2=InBuil.wandin(k,2);
      kc=InBuil.wandin(k,4);
      kn=length(InBuil.wandex(:,1))+length(InBuil.wandi0(:,1))+length(InBuil.wandia(:,1))+k;
   end
   respfac=wavorespf9(con{kc}.matprop,Ri,Re,Rvw_s,br,interhour,fig);
   %resp=[Ri,Re,Rvw_s,respfac],Tvloerin(1)=Tvloerin(1)+Rf;% warmtestromen voor totale oppervlak
   respfac(9)=(respfac(9)+Rf/2)/Afloor;
   respfac(10)=(respfac(10)-respfac(11)*Rf/2)/Afloor;
   respfac(12)=(respfac(12)-respfac(13)*Rf/2)/Afloor;
   % misschien niet per zone maar per wand
   if wandtyp>=1
      CFhcon2(izone2)=1-5*respfac(2); %CFhcon=covectiefactor vlvw
   end
   
   CFhcon(izone)=1-5*respfac(1);
   basis(izone)=basis0;
   fimaxcon0=Afloor*qmax*respfac(4);   
   Lq=RR{kc};
   Rq=1./Lq;
   %laag: opp==1, steeds laag R(laag)< Rthr (vanaf opp)
   somnlst=1;
   Rt=cumsum(Rq)-Rq(1);
   while Rt(somnlst+1)<Rvw_s
      somnlst=somnlst+1;
   end
   %Tdiep=Tlaag(somnlst)
   respfac(3)=somnlst;
   
   conheatcool1(i,:)=[kn,fimaxcon0,Afloor,Tmax,izone,izone2,respfac];
end
