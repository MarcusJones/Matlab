%ENPOWFUN ENergy and POWer FUNction
%
% [Enx,Powx] =enpowfun(Output)
%
% Output  = Output matrix of HAMBase
% Enx(1)  = heating energy [m3]
% Enx(2)  = cooling power [m3]
% Enx(3)  = humidification energy [m3] 
% Enx(4)  = dehumidification energy [m3] 
% Powx(1) = heating power [W]
% Powx(2) = cooling power [W]
% Powx(3) = humidification power [W] 
% Powx(4) = dehumidification power [W] 


function [Enx,Powx]=enpowfun(BASE,Output,zonenr)

Enx=zeros(4,1);
Powx=zeros(4,1);

Q=Output.Qplant(:,zonenr);
g=Output.Gplant(:,zonenr);

np=length(Q);

Qhe=zeros(np,1);
Qco=zeros(np,1);
Qhu=zeros(np,1);
Qde=zeros(np,1);

i=find(Q>0); if ~isempty(i); Qhe(i)=Q(i); end
i=find(Q<0); if ~isempty(i); Qco(i)=-Q(i); end
i=find(g>0); if ~isempty(i); Qhu(i)=g(i); end
i=find(g<0); if ~isempty(i); Qde(i)=-g(i); end
 
Vol=BASE.Vol{zonenr};

a=3600/(32e6*Vol);


 Enx(1)=a*sum(Qhe);  
 Enx(2)=a*sum(Qco);  
 Enx(3)=a*sum(Qhu); 
 Enx(4)=a*sum(Qde);  
 Powx(1)=max(Qhe)/Vol; 
 Powx(2)=max(Qco)/Vol; 
 Powx(3)=max(Qhu)/Vol; 
 Powx(4)=max(Qde)/Vol; 





