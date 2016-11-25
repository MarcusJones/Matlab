function [MM,CC,RR,Building,xcons,MMV,CCV,RRV,kex0,maxuur,kwall,kbin,Awand,kbuit]...
   =Xmat1204(InBuil,frdis,interhour,maxuur);
%Liecx0,Liec00

% Author: Martin de Wit 14-nov-1998
%Cq(T-T*)=L(frdisT+(1-frdis)T*)+[Lq(1)T1..0...Lq(somnl+1)T2]
%(Cq-Lfrdis)T=(Cq+L(1-frdis))T*+[Lq(1)T1..0...-Lq(somnl+1)T2]
%MT=-MT*(1/frdis-1)+CqT*/frdis+[Lq(1)T1..0...Lq(somnl+1)T2]
%T=-T*(1/frdis-1)+M\CqT*/frdis+B[Lq(1)T1..0...Lq(somnl+1)T2]=F+ctiT1-cteT2=
%-T*(1/frdis-1)+FF/frdis+ctiT1-cteT2
%qi=(Twfrdis+Tw*(1-frdis)-T1)Lq(1)==(FF)Lq(1)+(frdis(ctiT1-cteT2)-T1)Lq(1)=qi1+Lie(T1-T2)-LiT1
%Lie=cte(1)Lq(1)frdis   Li=(1-cti(1)frdis-cte(1)frdis)*Lq(1);
%qe=-(FF)Lq(1)-Lei(T2-T1)+LeT2

%kcmax=max(kwall);
%Li=zeros(1,kcmax);
%Le=zeros(1,kcmax);
%Lie=zeros(1,kcmax);
%a=zeros(1,kcmax);
%e=zeros(1,kcmax);
%U=zeros(1,kcmax);
%xcons=zeros(kcmax,7);
zone=InBuil.zone;
wandex=InBuil.wandex;
window=InBuil.window;
wandi0=InBuil.wandi0;
wandia=InBuil.wandia;
wandin=InBuil.wandin;
con=InBuil.con;

zonetot=length(zone);

kwallex=wandex(:,3)'; %constructie
kex=wandex(:,1)';     %zone
Awandex=wandex(:,2)';
koudeex=wandex(:,5)';

kwall0=wandi0(:,3)';
ki0=wandi0(:,1)';
%tempi0=wandi0(:,4)';
Awandi0=wandi0(:,2)';
koude0=wandi0(:,5)';

kwallia=wandia(:,3)';
kia=wandia(:,1)';
Awandia=wandia(:,2)';

kwallin=wandin(:,4)';
kini=wandin(:,1)';
kine=wandin(:,2)';
Awandin=wandin(:,3)';

kwall=[kwallex,kwall0,kwallia,kwallin]; %contypes
kbin=[kex,ki0,kia,kini];                  %zones
Awand=[Awandex,Awandi0,Awandia,Awandin];  %wandopp
kbuit=[kia,kine];

%------------------------------------------------------------------------------------------------------------

delt=3600/interhour;
%for i=1:max(kwall)
%   MM{i}=0;
%   CC{i}=0;
%RR{i}=0;
%MMV{i}=0;MM{i}=0;
%CCV{i}=0;
%RRV{i}=0;
%end

for ctyp=1:max(kwall) 
   % file met constructies
   l= con{ctyp}.matprop(:,1)';
   lambda =con{ctyp}.matprop(:,2)';
   c = con{ctyp}.matprop(:,4)';
   rho =con{ctyp}.matprop(:,3)';
   ksi=con{ctyp}.matprop(:,7)';
   mu=con{ctyp}.matprop(:,6)';
   %bv= matprop(:,8)'; %bv.10^7 onbetrouwbaar
   Ri=con{ctyp}.Ri;
   Re=con{ctyp}.Re;
   Zvi=con{ctyp}.Zvi;
   Zve=con{ctyp}.Zve;
   hi(ctyp)=1/Ri;
   he(ctyp)=1/Re;
   
   a(ctyp)=con{ctyp}.ab;
   e(ctyp)=con{ctyp}.eb;
   Reeb(ctyp)=Re*e(ctyp);
   Reab(ctyp)=Re*a(ctyp);
   lagen=length(l);
   %wrl=[Ri,l./lambda,Re]; %warmteweerstand per laag in m2K/W
   %wcl=[0,(rho.*c).*l,0]/delt;%warmtecapaciteit per laag in J/m2K
   wrl=[l./lambda]; %warmteweerstand per laag in m2K/W
   wcl=[(rho.*c).*l]/delt;%warmtecapaciteit per laag in J/m2K
   
   kspouw=find(rho<1.4);
   wrl(kspouw)=0.17;
   wcl(kspouw)=0;
   
   %wrc=wrl.*wcl;
   Building.Ucon(ctyp)=1/(sum(wrl)+Ri+Re);
   
   % rekenen met kg/kg dus 0.62e-5, del=1.8e-10 
   psref=2340;
   ksl=ksi.*l/((0.62e-5)*psref)/delt;%vochtcapaciteit per laag in kg/m2(kg/kg)
   k=find(mu<=1);
   mu(k)=1;
   mu(kspouw)=1;
   mul=(0.62e+5)*(mu.*l)/1.8;        %vochtweerstand per laag in m2s/kg

   ksl(k)=1.2*l(k)/delt;
   ksl(kspouw)=1.2*l(kspouw)/delt;
   k=find(ksl==0);
   ksl(k)=eps;
   
   bvi=sqrt(ksl(1)/mul(1));
   bve=sqrt(ksl(lagen)/mul(lagen));
      
   if Ri>0.1
      Ri=1/(1/Ri+1); %correctie stralingsuitwisseling
   end
   if Re>0.1
      Re=1/(1/Re+1);
   end
   
   %__________________________________________________
   
   %Esp discretizatie, F0=1/2
   
   nl=round((wcl.*wrl).^0.5);
   k=find(nl==0|nl==1);
   nl(k)=2;
   k=find(wcl==0);
   nl(k)=1;
   somnl=sum(nl)+1;
   
   % Bepaling Cq warmte_transport
   % Bepaling Rq warmte_transport
   Cq=zeros(somnl,1);
   Rq=zeros(somnl+1,1);
   C1=zeros(somnl-1,1);
   % Re, Ri
   Rq(somnl+1)=Re;
   Rq(1)=Ri;
   U(ctyp)=1/(Ri+Re+sum(wrl));
   xcons(ctyp,1)=somnl;
   xcons(ctyp,2)=1/Ri;
   xcons(ctyp,3)=1/Re;
   som=1;
   for ii=1:lagen,
      Rq(som+1:som+nl(ii))=wrl(ii)/nl(ii);
      C1(som:som+nl(ii)-1)=wcl(ii)/(2*nl(ii));
      som=som+nl(ii);
   end
   
   Cq=[C1;0]+[0;C1];
   Lq=1./Rq;
   
   %bepaling matrix warmte
   %M=diag(Cq+0.5*Lq(1:somnl)+0.5*Lq(2:somnl+1))-diag(0.5*Lq(2:somnl),1)...
   %   -diag(0.5*Lq(2:somnl),-1);
   M=diag(Cq+frdis*Lq(1:somnl)+frdis*Lq(2:somnl+1))-diag(frdis*Lq(2:somnl),1)...
      -diag(frdis*Lq(2:somnl),-1);
   
   MM{ctyp}=M;
   RR{ctyp}=Lq;
   CC{ctyp}=Cq;
   
   cti=zeros(somnl,1);
   cte=zeros(somnl,1);
   B=inv(M);
   cti=B(:,1)*Lq(1)*frdis;
   cte=B(:,somnl)*Lq(somnl+1)*frdis;
   
   Lie(ctyp)=cte(1)*Lq(1);
   %Lei=cti(somnl)*Rq(somnl+1);
   Li(ctyp)=(1-cti(1)-cte(1))*Lq(1);
   Le(ctyp)=(1-cti(somnl)-cte(somnl))*Lq(somnl+1);
   
   % Bepaling Cv vocht_transport
   % Bepaling Rv vocht_transport
   
   if ksl(1)*mul(1)>2*nl(1)^2
      nlvi=ceil(log(((0.5*ksl(1)*mul(1))^0.5)/nl(1))/log(2));
   else
      nlvi=0;
   end;
   
   if ksl(lagen)*mul(lagen)>2*nl(lagen)^2
      nlve=ceil(log(((0.5*ksl(lagen)*mul(lagen))^0.5)/nl(lagen))/log(2));
   else
      nlve=0;
   end;
   
   if bvi<1e-5
      nlvi=0;
   end
   if bve<1e-5
      nlve=0;
   end;
   
   somnlv=somnl+nlvi+nlve;
   
   % Bepaling Cvq vocht_transport
   % Bepaling Rvq voch_transport
   Cvq=zeros(somnlv,1);
   Rvq=zeros(somnlv+1,1);
   Cv1=zeros(somnl-1,1);
   Rv1=zeros(somnl+1,1);
   
   % 1/betae, 1/betai
   Rv1(somnl+1)=Zve;
   Rv1(1)=Zvi;
   
   Zv(ctyp)=1/(sum(mul)+Zvi+Zve);
   xcons(ctyp,4)=1/Zvi;
   xcons(ctyp,5)=1/Zve;
   xcons(ctyp,6)=nlvi;
   xcons(ctyp,7)=nlve;
   
   som=1;
   for ii=1:lagen,
      Rv1(som+1:som+nl(ii))=mul(ii)/nl(ii);
      Cv1(som:som+nl(ii)-1)=ksl(ii)/(2*nl(ii));
      som=som+nl(ii);
   end
   Rvq=[Rv1(1),Rv1(2)*2^(-nlvi),Rv1(2)*2.^(-nlvi:-1),Rv1(3:somnl-1)',...
         Rv1(somnl)*2.^(-1:-1:-nlve),Rv1(somnl)*2^(-nlve),Rv1(somnl+1)]';
   Cvq2=[Cv1(1)*2^(-nlvi),Cv1(1)*2.^(-nlvi:-1),Cv1(2:somnl-2)',...
         Cv1(somnl-1)*2.^(-1:-1:-nlve),Cv1(somnl-1)*2^(-nlve)]';
   Cvq=[Cvq2;0]+[0;Cvq2];
   Lvq=1./Rvq;
   
   %bepaling matrix vocht
   MV=diag(frdis*Lvq(1:somnlv)+frdis*Lvq(2:somnlv+1))-diag(frdis*Lvq(2:somnlv),1)...
      -diag(frdis*Lvq(2:somnlv),-1);
   
   MMV{ctyp}=MV;
   RRV{ctyp}=Lvq;
   CCV{ctyp}=Cvq;
   
   %T=T1,T1+2.^(-nlvi:-1)(T2-T1),T2,...Tn-1,Tn-1+(1-2.^(-1:-1:-nlve))(Tn-Tn-1),Tn
   %eind vocht
   
end
%MM,CC,RR,Li,Le,Lie,a,e,U,xcons,MMV,CCV,RRV
%[MM,CC,RR,Lic,Lec,Liec,a,e,U,xcons,MMV,CCV,RRV,Liecin,Liec0,Li0,Liecex,...
%Lex0,Iex,Ii0,Iw2,Iow,Iwand1,Iwand2,Liecx0,Liec00,Ldet1,Iwand2,kex0,Lx,Ldet,Aglas,,Atot,]
%____________________________________________________
Liecin=Awandin.*Lie(kwallin);
Liec0=Awandi0.*Lie(kwall0)+koude0;
Li0=Awandi0.*U(kwall0)+koude0;
Liecex=Awandex.*Lie(kwallex)+koudeex;
Lex0=Awandex.*U(kwallex)+koudeex;


Ldet1=zeros(zonetot,zonetot);
Iex=zeros(zonetot,length(kex));
Ii0=zeros(zonetot,length(kwall0));
Iw2=zeros(zonetot,length(kini));
Iwand1=zeros(zonetot,length(kbin));
Iwand2=zeros(zonetot,length(kbin));

for i=1:zonetot
   Iex(i,:)=(kex==i);
   Liecex0(i,:)=(kex==i).*Liecex;
   Ii0(i,:)=(ki0==i);
   Liec00(i,:)=(ki0==i).*Liec0;
   Iw2(i,:)=(kine==i).*Awandin;
     Iwand1(i,:)=(kbin==i).*Awand;
   for j=i+1:zonetot
      Ldet1(i,j)=Liecin*(kini==i&kine==j)';
   end
end
Iwand2=[zeros(zonetot,length([kex,ki0,kia])),Iw2];
kex0=ones(1,zonetot)*Iex;
Lx=Li(kwall)*Iwand1'+sum(Liecex0')+sum(Liec00')+Le(kwallin)*Iw2';
Ldet=Ldet1+Ldet1'-diag(sum(Ldet1+Ldet1'));
Atotzg=sum(Iwand1')+sum(Iw2');
Rimean=Atotzg./(hi(kwall)*Iwand1'+he(kwallin)*Iw2');

%aantal iteratiestappen per uur bij link door lucht is 5 door constr is 2
if maxuur==1&sum(sum(Ldet1))~=0
   maxuur=2;
end
Building.Rimean=Rimean;
Building.eb0=e(kwallex);
Building.ab0=a(kwallex);
Building.Reeb0=Reeb(kwallex);
Building.Reab0=Reab(kwallex);
Building.Ii0=Ii0;
Building.Iex=Iex;
Building.Iwand1=Iwand1;
Building.Iwand2=Iwand2;
Building.Li=Li;
Building.Le=Le;
Building.Lie=Lie;
Building.U=U;
Building.Li0=Li0;
Building.Lex0=Lex0;
Building.Liecex0=Liecex0;
Building.Liec00=Liec00;
Building.Atotzg=Atotzg;
Building.Lx=Lx;
Building.Ldet=Ldet;

% ---------------------------------------------------------------------------------
