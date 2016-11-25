function resp=wavorespf9(matprop,Ri,Re,Rvw_s,br,interhour,fig)
%respfac(1:5)=>up,respfac(6:10)=>temperatuur,respfac(11:15)=>down

%l =      [0.015 0.2  0.05  0.05];
%matprop = matpropf(l,[262 312 456 312]);
%Ri=1/13;
%Re=1;
%br=0.3;
%Rvw_s=0.015/0.8+0.1/1.7;

br=br/2;
delhour=5;
frdis=3/4;

n=24*interhour;
l= matprop(:,1)';
lambda = matprop(:,2)';
c = matprop(:,4)';
rho =matprop(:,3)';

%-------------------------
lagen=length(l);
delt=3600/delhour/interhour;
wrl=l./lambda;
wcl=(rho.*c).*l/delt;
kspouw=find(rho<1.4);
wrl(kspouw)=0.17;
wcl(kspouw)=0;

%Esp discretizatie, F0=1/2
%nl=round((wcl.*wrl).^0.5);
nl=round((0.5*wcl.*wrl).^0.5);
k=find(nl==0|nl==1);
nl(k)=2;
k=find(wcl==0);
nl(k)=1;
somnl=sum(nl)+1;
%breedte in nb delen
%nb=10;
nb=2*ceil(br*max(nl./l));
wrb=wrl.*(br./(nb*l)).^2;

% Bepaling Cq1 warmte_transport
% Bepaling Rq warmte_transport
Cq1=zeros(somnl,1);
Rq=zeros(somnl+1,1);
C1=zeros(somnl-1,1);
Lb1=zeros(somnl-1,1);

% Re, Ri
Rq(somnl+1)=Re;
Rq(1)=Ri;

som=1;
for ii=1:lagen,
   Rq(som+1:som+nl(ii))=wrl(ii)/nl(ii);
   C1(som:som+nl(ii)-1)=wcl(ii)/(2*nl(ii));
   Lb1(som:som+nl(ii)-1)=1/(2*nl(ii)*wrb(ii));
   xq(som:som+nl(ii)-1)=l(ii)/nl(ii);
   som=som+nl(ii);
end

Cq1=[C1;0]+[0;C1];
Lq=1./Rq;
Lp=[Lb1;0]+[0;Lb1];
%bepaling matrix warmte
M1=diag(Lq(1:somnl)+Lq(2:somnl+1))-diag(Lq(2:somnl),1)...
   -diag(Lq(2:somnl),-1);

somnlst=2;
Rt=cumsum(Rq)-Rq(1);
while Rt(somnlst+1)<Rvw_s
   somnlst=somnlst+1;
end
%xt=cumsum(xq);
%while xt(somnlst)<xin(2)
%   somnlst=somnlst+1;
%end

%-----------------------------------------------------------------
%R2 matrix AB en Cq2 de elementen zijn met nb/br vermenigvuldigd

AB=zeros((nb+1)*somnl,(nb+1)*somnl);
AB(1:somnl,1:somnl)=M1/2;
for i=2:nb+1
   AB((i-1)*somnl+1:i*somnl,(i-1)*somnl+1:i*somnl)=M1;
   RRp((i-2)*somnl+1:(i-1)*somnl )=Lp;
   CCp((i-2)*somnl+1:(i-1)*somnl )=Cq1/2;
end
AB(nb*somnl+1:(nb+1)*somnl,nb*somnl+1:(nb+1)*somnl)=M1/2;
Rp=[zeros(1,somnl),RRp]+[RRp,zeros(1,somnl)];

M2=sparse(AB+diag(Rp)-diag(RRp,somnl)-diag(RRp,-somnl));

Cq2=[zeros(1,somnl),CCp]+[CCp,zeros(1,somnl)];
%-----------------------------------------------------------------
Rtot=(sum(wrl)+Ri+Re);

Q=0*Cq2;
Q(somnlst)=nb;
T=M2\Q';
R1=sum(Rq(1:somnlst));
R2=Rtot-R1;
Rv=R1*R2/Rtot;
eta=R2/Rtot;
Rup=nb*Ri*T(somnlst)/trapz(T((0:nb)*somnl+1));
Rdown=nb*Re*T(somnlst)/trapz(T((1:nb+1)*somnl));

R11=Rup*Rdown/(Rup+Rdown);
eta=Rdown/(Rup+Rdown);
%----------------------------------------------------------------------
%-------------------------------------------------------------------
D=frdis*M2+diag(Cq2);
D1=sparse(D);
[L,U]=lu(D1);
uu=zeros((nb+1)*somnl,1);

Talt=zeros(1,(nb+1)*somnl)';
for i=1:n*delhour
   if i<=delhour
      uu(somnlst)=nb;
   else
      uu(somnlst)=0;
   end
   
   Tneu=(1-1/frdis)*Talt+(1/frdis)*(U\(L\(Cq2'.*Talt)))+U\(L\uu);
   T3=frdis*Tneu+(1-frdis)*Talt;
   Talt=Tneu;
   quitvlup(i)=trapz(T3([0:nb]*somnl+1)')/(nb*Ri);
   quitvldown(i)=trapz(T3((1:nb+1)*somnl)')/(nb*Re);
   Tvloerin22(i)=T3(somnlst);
end
k=delhour*[0:n-1];
quitup=zeros(1,n);
quitdown=zeros(1,n);

Tvloerin2=zeros(1,n);
for kk=1:delhour
   quitup=quitup+quitvlup(k+kk)/delhour;
   quitdown=quitdown+quitvldown(k+kk)/delhour;
   Tvloerin2=Tvloerin2+Tvloerin22(k+kk)/delhour;
end
%sum(quitup+quitdown)
respfac=zeros(1,15);
quit=quitup';
respfac(1)=quit(1);
p=eta-respfac(1);
C=zeros(n-1,3);
C(1:n-1,1)=quit(1:n-1);
C(2:n-1,3)=quit(1:n-2);
C(1,2)=-1;
C(1,1)=C(1,1)-eta;
C(1,3)=-eta;
C(2,2)=1;
quitb=quit(2:n);
quitb(1)=quit(2)-p;

cb=C\quitb;
respfac(3:5)=cb([1,2,3]);
respfac(2)=p-eta*(cb(1)+cb(3))-cb(2);

Tvloerin2(1)=Tvloerin2(1);
Tvloerin=Tvloerin2';
respfac(6)=Tvloerin(1);
p=R11-respfac(6);
C(1:n-1,1)=Tvloerin(1:n-1);
C(2:n-1,3)=Tvloerin(1:n-2);
C(1,1)=C(1,1)-R11;
C(1,3)=-R11;
Tvloerinb=Tvloerin(2:n);
Tvloerinb(1)=Tvloerin(2)-p;

cb=C\Tvloerinb;
respfac(8:10)=cb([1,2,3]);
respfac(7)=p-R11*(cb(1)+cb(3))-cb(2);

quit=quitdown';
respfac(11)=quit(1);
p=1-eta-respfac(11);
C=zeros(n-1,3);
C(1:n-1,1)=quit(1:n-1);
C(2:n-1,3)=quit(1:n-2);
C(1,2)=-1;
C(1,1)=C(1,1)-(1-eta);
C(1,3)=-(1-eta);
C(2,2)=1;
quitb=quit(2:n);
quitb(1)=quit(2)-p;

cb=C\quitb;
respfac(13:15)=cb([1,2,3]);
respfac(12)=p-(1-eta)*(cb(1)+cb(3))-cb(2);
resp=[Ri,Re,Rvw_s,respfac];
if fig==1
   x=eye(100,4);
   a=[1,-resp(6),-resp(8)];
   b=[resp(4),resp(5),resp(7)];
   y=filter(b,a,x);
   figure (1)
   n=length(quitup);
   plot(1:n,quitup,1:n,y(1:n),'o')
   
   a=[1,-resp(11),-resp(13)];
   b=[resp(9),resp(10),resp(12)];
   yy=filter(b,a,x);
   figure (2)
   plot(1:n,Tvloerin2,1:n,yy(1:n),'o')
   
   a=[1,-resp(16),-resp(18)];
   b=[resp(14),resp(15),resp(17)];
   yyy=filter(b,a,x);
   figure (3)
   plot(1:n,quitdown,1:n,yyy(1:n),'o')
   
   pause
end
