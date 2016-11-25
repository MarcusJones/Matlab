
% Indien de eerste n dagen niet betrouwbaar zijn omdat de constructie erg zwaar is
% (inslingeren) kunnen deze overgeslagen worden voor de plot
ninsling=0;
%ninsling=2;

%U-waarden
U=Output.U;

%Plotten van oppervlakte temp en rv van wand (dan TeRH=1) met 'wandnaam' en wandnr 
TeRH=0;
%wandnaam:  wandex,wandi0,wandia,wandin,window
wandnaam='window';
%wandnr rijnr bij invoer
wandnr=1;

idag1=InClimate.idag1+ninsling;
aantaldagen=InClimate.aantaldagen-ninsling;
idag2=idag1+aantaldagen;
nnmax=aantaldagen*24;
twout=1+24*ninsling:nnmax+24*ninsling;

kli=InClimate.kli(twout,:);
%LAT=InClimate.LAT;
%LSMLON=InClimate.LSMLON;
interhour=InClimate.interhour;
zonetot=length(InBuil.zone);
twout2=1+24*ninsling*interhour:nnmax*interhour+24*ninsling*interhour;

%relatieve vochtigheid buiten
buitenvocht=InClimate.kli(:,5)/100;
%luchttemperatuur buiten
buitentemp=InClimate.kli(:,2)/10;
% 'operatieve' temperatuur binnen 
comforttemp=Output.Tcom(twout2,:);
%fictieve temperatuur voor transmissieverlies
transtemp=Output.Tx(twout2,:);
%interne warmteproduktie
Intern= Output.Qint(twout2,:);  
% uurlijks energieverbruik Wh 
energie=Output.Qplant(twout2,:);
% uurlijks energieverbruik lat koeling Wh 
Hum=Output.Gplant(twout2,:);
%relatieve vochtigheid binnen
binvocht=Output.RHa(twout2,:);
%relatieve vochtigheid in de wand
%wandvocht=Output.Rvw;
%uurlijks transmissieverlies in Wh met de werkelijk optredende temperaturen 
Trans=Output.Trans(twout2,:);
%uurlijks ventilatieverlies in Wh
Vent=Output.Vent(twout2,:);
%uurlijks zonne-energie binnen in Wh 
Zon=Output.Zon(twout2,:);
%uurlijkse luchttemperatuur
bintemp=Output.Ta(twout2,:);
%dampproduktie per uur  
Dampprod=Output.Gint(twout2,:); 
%vloertemp bij vloerverwarming
Twflh=Output.Twflh1(twout2,:);
rvwflh=Output.RHwflh1(twout2,:);

etainst=Control.etainst;
fpmax=max(energie);
fcmax=min(energie);

%sum(energie)/interhour
%sum(sum(energie))/interhour
%sum(sum(Trans+Vent-Zon-Intern))/interhour

%1e rekendag bijv idag1=31 is 1 febr

Humb=(Hum>0).*Hum/interhour;
Humo=(Hum<0).*Hum/interhour;
koeling=(energie<0).*energie;
stoken=energie-koeling;

%iday=idag1:idag1+aantaldagen;
%iday(iday>=365)=iday(iday>=365)-365;
% stookseizoen 1oct tot 1mei
iday=idag1;
for i=1:aantaldagen
   iday=iday+1;
   st(i)=1;
   id1=iday-365*floor(iday/365);
   if id1>120&id1<274
      st(i)=0;
   end
   
   tdag=24*(i-1)*interhour+1:24*i*interhour;
   binvo(i,:)=mean(binvocht(tdag,:));
   Zun(i,:)=mean(Zon(tdag,:));
   ener(i,:)=mean(stoken(tdag,:));
   Tran(i,:)=mean(Trans(tdag,:));
   Ven(i,:)=mean(Vent(tdag,:));
   Int(i,:)=mean(Intern(tdag,:));
   koel(i,:)=mean(koeling(tdag,:));
   Humom(i,:)=mean(Humo(tdag,:));
   Humbm(i,:)=mean(Humb(tdag,:));
end

T=19:30;
TN=zeros(2+zonetot,12);
N=zeros(12,zonetot);
nn=zeros(12,1);
[N,T]=hist(comforttemp(1:24*aantaldagen,:),T);
[NN,T]=hist(buitentemp(1:24*aantaldagen,:),T);
TN(2,12:-1:1)=cumsum(NN(12:-1:1));
if zonetot==1
   TN(1,:)=T ;
   TN(3,12:-1:1)=cumsum(N(12:-1:1))/interhour;
   Ener0=ener';
   Koel0=koel';
   Tran0=Tran';
   Ven0=Ven';
   Zun0=Zun';
   Int0=Int';
   Humom0=Humom';
   Humbm0=Humbm';   
elseif zonetot >=2
   TN(1,:)=T' ;
   % energiesom over de zones
   Ener0=sum(ener');
   Koel0=sum(koel');
   Tran0=sum(Tran');
   Ven0=sum(Ven');
   Zun0=sum(Zun');
   Int0=sum(Int');
   Humom0=sum(Humom');
   Humbm0=sum(Humbm');
   for izone=1:zonetot
      TN(2+izone,12:-1:1)=cumsum(N(12:-1:1,izone)')/interhour;
   end
end;

% Tabel temperatuuroverschrijdingen
% 1e rij:temperaturen,2e rij overschrijding buitentemperaturen
% 3 t/m 5e rij overschrijding binnencomforttemperaturen zone1 t/m zone3 

temperatuuroverschrijdingen=TN(:,2:12);
Zun1=sum(Zun0.*st);
Int1=sum(Int0.*st);

% uitsluiten dagen met gemiddeld koeling
hk=find(Koel0<0);
Tran0(hk)=0*Tran0(hk);
Ven0(hk)=0*Ven0(hk);
Zun0(hk)=0*Zun0(hk);
Int0(hk)=0*Int0(hk);
% uitsluiten dagen met gemiddeld koeling en gemiddeld niet stoken
hh=find(Ener0==0);
Tran0(hh)=0*Tran0(hh);
Ven0(hh)=0*Ven0(hh);
Zun0(hh)=0*Zun0(hh);
Int0(hh)=0*Int0(hh);

% energiesom over de zones en de rekenperiode
Tran3=sum(Tran0.*st);
Ven3=sum(Ven0.*st);
Zun3=sum(Zun0.*st);
Int3=sum(Int0.*st);

Energietot=sum(Ener0)*24/1000;
Koeltot=sum(Koel0)*24/1000;
Transtot=Tran3*24/1000;
Venttot=Ven3*24/1000;
Zontot=Zun3*24/1000;
Interntot=Int3*24/1000;
Humotot=sum(Humom0)*24/1000;
Humbtot=sum(Humbm0)*24/1000;
%gasverbruik in m^3 bij 72%
gasver=100*Energietot/(9.72*etainst);
gasverbruik=[num2str(gasver),' m^3 gas'];
etazon=Zun3/(Zun1+eps);
etaintern=Int3/(Int1+eps);

%warmwater=551
Transtot=Energietot+Zontot+Interntot-Venttot;
%['Trans Vent Int Zon stoken Koeling= ',num2str( Transtot),' ',num2str( Venttot),...
%' ',num2str( Interntot),' ',num2str( Zontot),' ',num2str( Energietot),' ',num2str( Koeltot),' kWh']

figure(3)

ymax=max([Zontot Interntot Transtot Venttot Energietot+Humbtot -Koeltot-Humotot]);
ymax=10*ceil(ymax/10);

subplot(221),bar([1:6],[Zontot;Interntot;Transtot;Venttot;...
      Energietot+Humbtot;-Koeltot-Humotot]),axis([0 7 0 ymax]),...
   xlabel('Solar Casual Trans Vent Heating Cooling'),ylabel('kWh');
subplot(221),title(['solar util.fac.=',num2str(etazon,2),'  casual util.fac.=',num2str( etaintern,2)]);
t=idag1+1/(24*interhour):1/(24*interhour):idag2;
subplot(222),plot(t,comforttemp)...
   ,axis([idag1 idag2 ,0 max(max(comforttemp))]),ylabel('comfort');
subplot(222),title(['zone1 T>25 C=',int2str(TN(3,7)),' hours   ']);
subplot(223),plot(t,binvocht)...
   ,axis([idag1 idag2 ,0 1]),xlabel('day'),ylabel(' RH air ');
subplot(224),plot(t,stoken+koeling)...
   ,axis([idag1 idag2 ,-1+min(min(koeling)) 1+max(max(stoken))]),xlabel('day'),ylabel('energy (W)');
subplot(224),title(['heating=',int2str(Energietot),' kWh   ','  cooling=',int2str( -Koeltot),' kWh']);

%x=[Zontot,Interntot,Energietot+Humbtot,Transtot,Venttot,-Koeltot-Humotot]
%pie(x)

figure (4)

tez=['gasverbruik = ',num2str(gasver,5),' m^3 gas'];
tez1=['temperatuuroverschrijdingen in uren'];
m=length(TN(:,2));
p=1/10;
% Place the text in the correct locations
for rowCnt=1:length(TN(:,2));
   for colCnt=1:11,
      tez2=num2str(TN(rowCnt,colCnt+1),4);
      subplot(2,1,1),text(-0.1,0.85,tez),...
         text(-0.1,0.7,tez1),text(-0.1+p*(colCnt-.5),p*(m-rowCnt+.5),tez2, ...
         'HorizontalAlignment','center'),axis off;
   end;
end;
subplot(2,2,3),plot(21:30,TN(2:2+zonetot,3:12))...
   ,axis([21 30 ,0 max(max(TN(:,3:12)))]),xlabel('temperature'),ylabel('cum hours');


% plotten van oppervlaktetemperaturen en relatieve vochtigheden
if TeRH==1
   
   kn=1;
   if wandnaam=='wandex'
      k=find(InBuil.wandex(:,6)'==wandnr);
      kn=k;
      yT=Output.Twall1(twout2,kn);
      yRH=Output.RHwall1(twout2,kn);
   elseif wandnaam=='wandi0'
      k=find(InBuil.wandi0(:,6)'==wandnr);
      kn=length(InBuil.wandex(:,1))+k;
      yT=Output.Twall1(twout2,kn);
      yRH=Output.RHwall1(twout2,kn);
   elseif wandnaam=='wandia'
      k=find(InBuil.wandia(:,4)'==wandnr);
      kn=length(InBuil.wandex(:,1))+length(InBuil.wandi0(:,1))+k;
      yT=Output.Twall1(twout2,kn);
      yRH=Output.RHwall1(twout2,kn);
   elseif wandnaam=='wandin'
      k=find(InBuil.wandin(:,5)'==wandnr);
      izone2=InBuil.wandin(k,2);
      kn=length(InBuil.wandex(:,1))+length(InBuil.wandi0(:,1))+length(InBuil.wandia(:,1))+k;
      yT=Output.Twall1(twout2,kn);
      yRH=Output.RHwall1(twout2,kn);
   elseif wandnaam=='window'
      kn==wandnr;
      yT=Output.Twindowi(twout2,kn);
      yRH=Output.RHwindowi(twout2,kn);
   end    
   figure (5)
   subplot(211),plot(t,yT),legend(wandnaam),...
      axis([idag1 idag2 ,min(yT)-1 max(yT)+1]),ylabel('temperatuur');
   subplot(212),plot(t,yRH),legend(wandnaam),...
      axis([idag1 idag2 ,0 1]),ylabel('rel. vochtigheid');
end