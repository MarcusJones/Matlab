function [sys,x0,str,ts] = buildmodsfun(t,x,u,flag,inputfilename)
%WAVOSFUN41 Wavo S functie Versie 3
%          	* Tgemid. discrete update
%          	* Vochtinput
% 				* RV begrenzingen
%				* Meer Outputs, interpolatie P.fxxxx variablen
%
% JvS nov,2001


global P Pu Tm InClimate Building Profiles Varu Control Output 


switch flag
   
   
   %%%%%%%%%%%%%%%%%%
   % Initialization %
   %%%%%%%%%%%%%%%%%%
case 0         
   [sys,x0,str,ts]=mdlInitializeSizes(inputfilename);
   
   %%%%%%%%%%%%%%%
   % Derivatives %
   %%%%%%%%%%%%%%%
case 1
   sys=mdlDerivatives(t,x,u);
   
   %%%%%%%%%%
   % Update %
   %%%%%%%%%%
case 2,
   sys=mdlUpdate(t,x,u);
   
   
   %%%%%%%%%%
   % Output %
   %%%%%%%%%%
case 3        
   sys=mdlOutputs(t,x,u);
   
   %%%%%%%%%%%%%
   % Terminate %
   %%%%%%%%%%%%%
case 9
   sys = [];       % do nothing
   
otherwise
   error(['unhandled flag = ',num2str(flag)]);
   
end

% end mixedm

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%

function [sys,x0,str,ts]=mdlInitializeSizes(inputfilename)


global P Pu InClimate Profiles Building Varu Control zonetot Output
global Cx1 Cx2 Cv1 Cv2 Ldet Ldeta Lx1 Lx2 Lv1 Lv2 Lrcvx Ca fbv0 Lxa Facp Facset Link
global figainx figaina Tglase fgtrans fzonab Te Pe Gint figainxOud figainaOud TglaseOud RVe
global fgtransOud fzonabOud TeOud PeOud GintOud Lgtot Lvv Lv rvmax rvmin


eval(['clear ' inputfilename ])
eval(inputfilename)
disp(['loading ' inputfilename])

[Varu,Building,Control,Elan,x0]=Wavoinit1205(InClimate,InBuil,Control);

zonetot=Building.zonetot

%SIMULINK PARAMETERS
set_param(gcs,'StartTime','0');
set_param(gcs,'StopTime',[num2str(InClimate.aantaldagen) '*24*3600']);
set_param([gcs '/Selector'],'Elements',['[1:' num2str(zonetot) ']'],'InputPortWidth',num2str(3*zonetot+2));   
set_param([gcs '/Selector1'],'Elements',[num2str(zonetot) '+[1:' num2str(zonetot) ']'],'InputPortWidth',num2str(3*zonetot+2));   
set_param([gcs '/Selector2'],'Elements',[num2str(2*zonetot) '+[1:' num2str(zonetot) ']'],'InputPortWidth',num2str(3*zonetot+2));   
set_param([gcs '/Selector3'],'Elements',num2str(3*zonetot+1),'InputPortWidth',num2str(3*zonetot+2));   
set_param([gcs '/Selector4'],'Elements',num2str(3*zonetot+2),'InputPortWidth',num2str(3*zonetot+2));   
set_param([gcs '/Mux1'],'Inputs',num2str(zonetot))
set_param([gcs '/Mux2'],'Inputs',num2str(zonetot))


P=[];
Pu=0;

sizes = simsizes;
sizes.NumContStates  = 6*zonetot;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3*zonetot+2;
sizes.NumInputs      = 2*zonetot;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

%BASIS INVOER file

str = [];
ts  = [0 0] ;                 % sample time

%fplant=zeros(zonetot,1);
%Gextra=zeros(zonetot,1);

%SIMULINK PARAMETERS:

%Px=Pvin;
%----------------------------------------------------------------------------

Ta=10*ones(zonetot,1);
Tx=Ta;
%[Control,Varu]=wavosimx_4(1,Tx,Ta,Varu,Profiles,Building,Control,InClimate);

[Control,Varu]=Wavovaru1205(1,Tx,Ta,Varu,Profiles,Building,Control,InClimate);

%Parameters
P.fplant=0;
P.Gextra=0;

%Hulpvariabelen:
figaina=Varu.figaina;
figainx=Varu.figainx;
Tglase=Varu.Tglase;
fgtrans=Varu.fgtrans;
fzonab=Varu.fzonab;
Lgtot=Varu.Lgtot;
Gint=Varu.Gint;
Pe=Varu.Pe;
Te=Varu.Te;
RVe=InClimate.kli(1,5)/100;
Lvv=Varu.Lvv;
Lv=Varu.Lv;
figainaOud=figaina;
figainxOud=figainx;
TglaseOud=Tglase;
fgtransOud=fgtrans;
fzonabOud=fzonab;
TeOud=Te;
GintOud=Gint;
PeOud=Pe;
%Tset=Control.Tsetmin;
%Tsetmax=Control.Tsetmax;
rvmax=Control.rvmax;
rvmin=Control.rvmin;

Cx1=Elan.Cx1;
Cx2=Elan.Cx2;
Cv1=Elan.Cv1;
Cv2=Elan.Cv2;
Ldet=Elan.Ldet;
Ldeta=Elan.Ldeta;
Lx1=Elan.Lx1;
Lx2=Elan.Lx2;
Lv1=Elan.Lv1;
Lv2=Elan.Lv2;
Lrcvx=Elan.Lrcvx;
Ca=Elan.Ca;
fbv0=Elan.fbv0;
Lxa=Elan.Lxa;
Facp=Elan.Facp;
Facset=Elan.Facset;
Link=Elan.Link;
nnmax=InClimate.aantaldagen*24;
Output.Transout=zeros(nnmax,zonetot);
Output.Ventout=zeros(nnmax,zonetot);
Output.Humout=zeros(nnmax,zonetot);
Output.Twout=zeros(nnmax,zonetot);
Output.Taout=zeros(nnmax,zonetot);
Output.Txout=zeros(nnmax,zonetot);
Output.figainout=zeros(nnmax,zonetot);
Output.Rvaout=zeros(nnmax,zonetot);

% end mdlInitializeSizes

%=============================================================================
% mdlDerivatives
% Compute derivatives for continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

global P Pu zonetot
global Cx1 Cx2 Cv1 Cv2 Ldet Ldeta Lx1 Lx2 Lv1 Lv2 Lrcvx Ca fbv0 Lxa Facp Facset Link
global figainx figaina Tglase fgtrans fzonab Te Pe Gint TglaseOud
global fgtransOud TeOud PeOud Lgtot Lvv Lv rvmax rvmin


%tfrac=abs(floor(t/3600)-t/3600)  %0<tfrac<1
tfrac=min(t/3600-Pu,1);

Tp=x(1:zonetot);
Tq=x(zonetot+[1:zonetot]);
Ta=x(2*zonetot+[1:zonetot]);
Fp=x(3*zonetot+[1:zonetot]);
Fq=x(4*zonetot+[1:zonetot]);
Fx=x(5*zonetot+[1:zonetot]);

P.fplant=u(1:zonetot);
P.Gextra=u(zonetot+[1:zonetot]);

TglaseU=TglaseOud+tfrac*(Tglase-TglaseOud);
fgtransU=fgtransOud+tfrac*(fgtrans-fgtransOud);
TeU=TeOud+tfrac*(Te-TeOud);
PeU=PeOud+tfrac*(Pe-PeOud);

Tx=( diag(Lxa+Ldeta+Lgtot+Lx1+Lx2) - Ldet )\( Lxa.*Ta+Lx1.*Tp+Lx2.*Tq+fgtransU+...
   fzonab+figainx+Lgtot.*TglaseU+(1-Facp).*P.fplant ) ;
Tw=Tx+(-Lx1.*(Tx-Tp)-Lx2.*(Tx-Tq)+fgtransU+fzonab-Ldeta.*Tx+(Ldet*Tx))./Lrcvx;

%P
ex1=2.71828182845904;
machtTw=17.08*Tw./(234.18+Tw);
if Tw<0
   machtTw=22.44*Tw./(272.44+Tw);
end;
PsTw=611*ex1.^machtTw;

machtTa=17.08*Ta./(234.18+Ta);
if Ta<0
   machtTa=22.44*Ta./(272.44+Ta);
end;
PsTa=611*ex1.^machtTa;
%Phi factor
fP1=PsTw/2340;
fP2=(1./(1+2340*fbv0./PsTa));

%RV begrenzingen alleen voor lucht
Fxmax=rvmax.*PsTa./(fP2*2340);
Fxmin=rvmin.*PsTa./(fP2*2340);
s3=( Lvv.*fP2.*((Fx<Fxmin).*(Fxmin-Fx)+(Fx>Fxmax).*(Fxmax-Fx))...
   -Link*(fP2.*((Fx<Fxmin).*(Fxmin-Fx)+(Fx>Fxmax).*(Fxmax-Fx))) )*2340*0.62e-8;

xdot1=(1./Cx1).*Lx1.*(Tx-Tp);
xdot2=(1./Cx2).*Lx2.*(Tx-Tq);
xdot3=(1./Ca ).*( -Lv.*(Ta-TeU) - Lxa.*(Ta-Tx)+ Link*Ta + figaina + Facp.*P.fplant );
xdot4=(1./Cv1).*Lv1.*(fP2.*Fx- fP1.*Fp);   
xdot5=(1./Cv2).*Lv2.*(fP2.*Fx- fP1.*Fq);
xdot6=(1./Ca ).*( -(Lv1+Lv2+Lvv).*fP2.*Fx+Lv1.*fP1.*Fp +Lv2.*fP1.*Fq...
   +Lvv.*PeU+Link*(fP2.*Fx)+(Gint+P.Gextra+s3)/(2340*0.62e-8) );

sys = [xdot1; xdot2; xdot3; xdot4; xdot5; xdot6];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

global P Pu InClimate Building Profiles Varu Control Output zonetot Ldet Ldeta Lx1 Lx2
global Lrcvx figainx figaina Tglase fgtrans fzonab Te Pe Gint RVe 
global TglaseOud fgtransOud TeOud PeOud Lgtot Lvv Lv rvmax rvmin


Puvorig=Pu;
%Pu=max([Pu floor(t/3600)]); 
Pu=max([Pu ceil(t/3600)]); 
if Pu~=Puvorig
   
   %Bewaar oude waarden
   TglaseOud=Tglase;
   fgtransOud=fgtrans;
   
   TeOud=Te;
   PeOud=Pe;
   
   Ta=x(2*zonetot+[1:zonetot]);
   Tx=P.Tx;
   %[Control,Varu]=wavosimx_4(Pu,Tx,Ta,Varu,Profiles,Building,Control,InClimate);
   [Control,Varu]=Wavovaru1205(Pu,Tx,Ta,Varu,Profiles,Building,Control,InClimate);

   
   %Tset=Control.Tsetmin;
   %Tsetmax=Control.Tsetmax;
   rvmax=Control.rvmax;
   rvmin=Control.rvmin;
   
   figaina=Varu.figaina;
   figainx=Varu.figainx;
   Tglase=Varu.Tglase;
   fgtrans=Varu.fgtrans;
   fzonab=Varu.fzonab;
   Te=Varu.Te;
   Gint=Varu.Gint;
   Pe=Varu.Pe;
   RVe=InClimate.kli(Pu,5)/100;
   Lgtot=Varu.Lgtot;
   Lvv=Varu.Lvv;
   Lv=Varu.Lv;
   
   if 1==1
      Tp=x(1:zonetot);
      Tq=x(zonetot+[1:zonetot]);
      Fp=x(3*zonetot+[1:zonetot]);
      Fq=x(4*zonetot+[1:zonetot]);
      Fx=x(5*zonetot+[1:zonetot]);
      Tw=Tx+( -Lx1.*(Tx-Tp)-Lx2.*(Tx-Tq)+fgtrans+fzonab-Ldeta.*Tx+Ldet*Tx )./Lrcvx;
      
      Output.Transout(Pu,:)=(-fgtrans-fzonab+Lgtot.*(Tx-Tglase)+Ldeta.*Tx)';
      Output.Ventout(Pu,:)=(Lv.*(Ta-Te))';
      Output.Humout(Pu,:)=P.Gextra*2500000';
      Output.Twout(Pu,:)=Tw';
      Output.Taout(Pu,:)=Ta';
      Output.Txout(Pu,:)=Tx';
      Output.figainout(Pu,:)=figainx+figaina;
      Output.Rvaout(Pu,:)=P.Rva';
      %if Pu==InClimate.aantaldagen*24
      %   save Output Output
      %end
      
   end
   
end


sys=[];
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

% Return output of the unit delay if we have a 
% sample hit within a tolerance of 1e-8. If we
% don't have a sample hit then return [] indicating
% that the output shouldn't change.

global P zonetot 
global Ldet Ldeta Lx1 Lx2 Lxa Facp Facset figainx Tglase fgtrans fzonab Lgtot fbv0
global Te RVe

Tp=x(1:zonetot);
Tq=x(zonetot+[1:zonetot]);
Ta=x(2*zonetot+[1:zonetot]);
Fx=x(5*zonetot+[1:zonetot]);

Tx=( diag(Lxa+Ldeta+Lgtot+Lx1+Lx2) - Ldet )\( Lxa.*Ta+Lx1.*Tp+Lx2.*Tq+fgtrans+...
   fzonab+figainx+Lgtot.*Tglase+(1-Facp).*P.fplant ) ;

ex1=2.71828182845904;
machtTa=17.08*Ta./(234.18+Ta);
if Ta<0
   machtTa=22.44*Ta./(272.44+Ta);
end;
PsTa=611*ex1.^machtTa;
Rva=min(Fx./(PsTa/2340+fbv0),1);

P.Tx=Tx;
P.Rva=Rva;
Tcom=Tx+Facset.*(Ta-Tx);
sys=[Tcom ;Ta; Rva; Te; RVe];


% end mdlOutputs