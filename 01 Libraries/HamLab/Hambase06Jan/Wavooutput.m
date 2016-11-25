%
%                Warmte en vocht  
%      UITVOERGEDEELTE
% ---------------------------------------------------------------------------------
%wout eerste rij:idag1, aantal dagen, aantal zones
% idag=24 eerste dag,imaand=1 31*24=744, 1e rekendag bijv idag1=31 is 1 febr
jaar=InClimate.date(1,1);
maand=InClimate.date(1,2);
dag=InClimate.date(1,3);
aantaldagen=InClimate.aantaldagen;
maanddag=[0 31 59 90 120 151 181 212 243 273 304 334 365];
% idag1=0 voor 1 jan
if maand>=3&mod(jaar,4)==0
    idag1=maanddag(maand)+dag;
else
    idag1=maanddag(maand)+dag-1;
end
idag2=idag1+aantaldagen;
nnmax=aantaldagen*24;
%zonetot=Building.zonetot;
date=InClimate.date;
fpmax=Control.Qpmax';
Cxt=Output.Cx1+Output.Cx2;
%relatieve vochtigheid buiten
buitenvocht=InClimate.kli(:,5)/100;
%luchttemperatuur buiten
buitentemp=InClimate.kli(:,2)/10;
% 'operatieve' temperatuur binnen 
comforttemp=Output.Tcom;
%gemiddelde wand-(excl glas)temperatuur
opptemp=Output.Tw;
%fictieve temperatuur voor transmissieverlies
transtemp=Output.Tx;
% uurlijks energieverbruik Wh 
energie=Output.Qplant;
% uurlijks energieverbruik lat koeling Wh 
Hum=Output.Gplant;
%relatieve vochtigheid binnen
binvocht=Output.RHa;
%relatieve vochtigheid in de wand
wandvocht=Output.RHw;
%uurlijks transmissieverlies in Wh met de werkelijk optredende temperaturen 
Trans=Output.Trans;
%uurlijks ventilatieverlies in Wh
Vent=Output.Vent;
%uurlijks zonne-energie binnen in Wh 
Zon=Output.Zon;
%uurlijkse luchttemperatuur
bintemp=Output.Ta;
%interne warmteproduktie
Intern= Output.Qint;  
%dampproduktie per uur  
Dampprod=Output.Gint; 
etainst=Control.etainst;

%(sum(energie))
%(sum(Trans+Vent-Zon-Intern))
%1e rekendag bijv idag1=31 is 1 febr

Humb=(Hum>0).*Hum;
Humo=(Hum<0).*Hum;
koeling=(energie<0).*energie;
stoken=energie-koeling;
%sum(koeling)
%sum(stoken)
%sum(Zon)
%sum(Trans)
%sum(Vent)
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
   
   tdag=24*(i-1)+1:24*i;
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
zonetot1=size(comforttemp);
zonetot=zonetot1(2);
T=19:30;
TN=zeros(2+zonetot,12);
N=zeros(12,zonetot);
nn=zeros(12,1);
[N,T]=hist(comforttemp(1:24*aantaldagen,:),T);
[NN,T]=hist(buitentemp(1:24*aantaldagen,:),T);
TN(2,12:-1:1)=cumsum(NN(12:-1:1));
if zonetot==1
   TN(1,:)=T ;
   TN(3,12:-1:1)=cumsum(N(12:-1:1));
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
      TN(2+izone,12:-1:1)=cumsum(N(12:-1:1,izone)');
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
ymax=10*ceil(ymax/10+1);
subplot(221),bar([1:6],[Zontot;Interntot;Transtot;Venttot;...
      Energietot+Humbtot;-Koeltot-Humotot]),axis([0 7 0 ymax]),...
   xlabel('Solar Casual Trans Vent Heating Cooling'),ylabel('kWh');
subplot(221),title(['solar util.fac.=',num2str(etazon,2),'  casual util.fac.=',num2str( etaintern,2)]);
t=idag1+1/24:1/24:idag2;
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

C=Cxt/(1000*3600);
tey=['thermal mass = ',num2str(C,3),' kWh/K'];
tez=['gasverbruik = ',num2str(gasver,5),' m^3 gas'];
tez1=['temperatuuroverschrijdingen in uren'];
m=length(TN(:,2));
p=1/10;
% Place the text in the correct locations
for rowCnt=1:length(TN(:,2));
   for colCnt=1:11,
      tez2=num2str(TN(rowCnt,colCnt+1),4);
      subplot(2,1,1),text(-0.1,1,tey),text(-0.1,0.85,tez),...
         text(-0.1,0.7,tez1),text(-0.1+p*(colCnt-.5),p*(m-rowCnt+.5),tez2, ...
         'HorizontalAlignment','center'),axis off;
   end;
end;
subplot(2,2,3),plot(21:30,TN(2:2+zonetot,3:12))...
   ,axis([21 30 ,0 max(max(TN(:,3:12)))]),xlabel('temperature'),ylabel('cum hours');
