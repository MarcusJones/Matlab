function [Output,Varu,Elan]=Wavox1205(Control,Profiles,InClimate,InBuil)

% uitvoer per uur in file wout: luchttemperatuur,comforttemperatuur,wandtemperatuur,
% transtemperatuur,warmtebehoefte,koelbehoefte,luchtvochtigheid,wandvochtigheid (%),
% ventilatie,zon,transmissie,intern,vochtprod,buitentemperatuur,rel vochtigheid buiten,
% zonnestraling op vlak oriennr, atmosferische straling op vlak oriennr
% dec03 toevoegen transglas

[Varu,Building,Control,Elan,x0]=Wavoinit1205(InClimate,InBuil,Control);

zonetot=Building.zonetot;
Psref=2340;
Tp=x0(1:zonetot);
Tq=x0(zonetot+1:2*zonetot);
Ta=x0(2*zonetot+1:3*zonetot);
Tx=Ta;
Fp=x0(3*zonetot+1:4*zonetot);
Fq=x0(4*zonetot+1:5*zonetot);
Fx=x0(5*zonetot+1:6*zonetot);
Pvin=Varu.Pvin;

Elan.Lx1=Elan.Cx1.*(1-exp(-3600*Elan.Lx1./Elan.Cx1))/3600;
Elan.Lx2=Elan.Cx2.*(1-exp(-3600*Elan.Lx2./Elan.Cx2))/3600;

C1P1=Psref*Elan.Cv1/3600.*Fp;
C2P2=Psref*Elan.Cv2/3600.*Fq;
CvaPi=2*Psref*Elan.Ca/3600.*Fx;
Elan.alv1n=Elan.Lv1./(Elan.Cv1/3600);
Elan.alv2n=Elan.Lv2./(Elan.Cv2/3600);
fpmax=Control.Qpmax';
fcmax=Control.Qcmax';
Gmax=Control.Gmax';
Gmin=Control.Gmin';

maxuur=1;
maxuurv=1;
if sum(sum(abs(Elan.Link)))~=0
    maxuur=5;
    maxuurv=5;
elseif sum(sum(abs(Elan.Ldet)))~=0
    maxuur=2;
end
oriennr=Building.oriennr;
nnmax=InClimate.aantaldagen*24;
Output.Trans=zeros(nnmax,zonetot);
Output.Vent=zeros(nnmax,zonetot);
Output.Tcom=zeros(nnmax,zonetot);
Output.Tw=zeros(nnmax,zonetot);
Output.Ta=zeros(nnmax,zonetot);
Output.Tr=zeros(nnmax,zonetot);
Output.figain=zeros(nnmax,zonetot);
Output.RHa=zeros(nnmax,zonetot);
Output.Qplant=zeros(nnmax,zonetot);
Output.Gplant=zeros(nnmax,zonetot);
Output.Tglas=zeros(nnmax,zonetot);
Output.RHw=zeros(nnmax,zonetot);
Output.Zon=zeros(nnmax,zonetot);
Output.Qint=zeros(nnmax,zonetot);
Output.Gint=zeros(nnmax,zonetot);
Output.Tx=zeros(nnmax,zonetot);
Output.Lnr=zeros(nnmax,length(oriennr));
Output.Enr=zeros(nnmax,length(oriennr));

%dagen inslingeren
nin=InClimate.nin;

%----------------------------------------------------------------------------

for nn1=-nin*24+1:nnmax
    if nn1>0
        nn=nn1;
    else
        nn=nn1-24*floor(nn1/24);
        if nn==0
            nn=24;
        end
    end
    
    [Control,Varu]=Wavovaru1205(nn,Tx,Ta,Varu,Profiles,Building,Control,InClimate);
    
    [Tx,Ta,Tp,Tq,Tw,Tcom,Ener,Trans,Vent,Transglas]=...
        tsolufsim4(Varu.Lgtot,Varu.Lv,fpmax,fcmax,Control.Tsetmin,Control.Tsetmax,Tx,Ta,Tp,...
        Tq,Varu.figainx,Varu.figaina,Varu.fgtrans,Varu.Tglase,maxuur,Varu.Te,Varu.fzonab,Elan);
    
    [Pvin,Px,rvin,rvwand,Hum,CvaPi,C1P1,C2P2]=rvsolufsim6(Varu.Pe,Ta,Tw,Varu.Gint,maxuurv,...
        Control.rvmin,Control.rvmax,Varu.Lvv,Pvin,CvaPi,C1P1,C2P2,Elan,Gmin,Gmax);
    
    Output.Transglas(nn,:)=Transglas';  
    Output.Trans(nn,:)=Trans';
    Output.Vent(nn,:)=Vent';
    Output.Tcom(nn,:)=Tcom';
    Output.Tw(nn,:)=Tw';
    Output.Ta(nn,:)=Ta';
    Output.Tx(nn,:)=Tx';
    Tr=1.13*Tx'/(6*0.13)-(1.13/(6*0.13)-1)*(Ta'+(Varu.figainx'+(1-Elan.Facp').*Ener')./Elan.Lxa');
    Output.Tr(nn,:)=Tr;
    Output.Tglas(nn,:)=((Tr'.*(Building.Atot)'-Tw.*(Building.Atot'-Building.Aglas'))./(eps+Building.Aglas'))';
    Output.figain(nn,:)=Varu.figainx'+Varu.figaina';
    Output.RHa(nn,:)=rvin';
    Output.Qplant(nn,:)=Ener';
    Output.Gplant(nn,:)=Hum';
    Output.RHw(nn,:)=rvwand';
    Output.Zon(nn,:)=Varu.Zon';
    Output.Qint(nn,:)=Varu.Qint';
    Output.Gint(nn,:)=Varu.Gint';
    Output.Lnr(nn,:)=Varu.Lnr'; %atmosferische straling op vlak oriennr
    Output.Enr(nn,:)=Varu.Enr'; %zonnestraling op vlak oriennr
end
Output.Cx1=Elan.Cx1';
Output.Cx2=Elan.Cx2';
