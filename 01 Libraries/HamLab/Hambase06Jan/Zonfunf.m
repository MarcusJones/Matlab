function [Esol,Lrad]=zonfunf(iday1,LSMLON,LAT,orbel,klizo,Or,gref,wschad)
% ----------------------------------------------------------------------------
% zonnestraling
% ----------------------------------------------------------------------------
% 
%# scalar ki li uur

mschad=wschad(:,3);
nschad=wschad(:,2);
difred=wschad(:,1);
ki=length(Or(:,1));
li=length(orbel(:,1));

% Perez (zie Solar Energy volume 39 no. 3)
% berekening van de diffuse straling op een schuin vlak
% Approximatin of A and C, the solid angles occupied by the circumsolar region,
% weighed by its average incidence on the slope and horizontal respectively.
% In the expression of diffuse on inclined surface the quotient of A/C is
% reduced to XIC/XIH. A=2*(1-cos(beta))*xic, C=2*(1-cos(beta))*xih
% gecontroleerd  okt 1996 martin de wit
epsint=[0.056 0.253 0.586 1.134 2.23 4.98 9.08 99999];
facc1=[-0.011 -0.038 0.166 0.419 0.710 0.857 0.734 0.421;...
      0.748 1.115 0.909 0.646 0.025 -0.370 -0.073 -0.661;...
      -0.080 -0.109 -0.179 -0.262 -0.290 -0.279 -0.228 0.097];
facc2=[-0.048 -0.023 0.062 0.140 0.243 0.267 0.231 0.119;...
      0.073 0.106 -0.021 -0.167 -0.511 -0.792 -1.180 -2.125;...
      -0.024 -0.037 -0.050 -0.042 -0.004 0.076 0.199 0.446];
pii=pi;
r=pii/180;
beta=Or(:,1)'*r;
gamma=Or(:,2)'*r;
cosbeta=cos(beta);
sinbeta=sin(beta);
sinlat=sin(LAT*r);
coslat=cos(LAT*r);

% sunrise and sunset
%    hh=acos(-sinlat/coslat*tan(delta))/(r*15);
%    sunr=ceil(12-hh-ET/60+(4/60)*(LSM-LON)+0.5);
%    suns=floor(12+hh-ET/60+(4/60)*(LSM-LON)+0.5);
%    sinsalt=sinlat*sindelta+coslat*cosdelta*cos(h)
%    sin(fi)*sinsalt=cosdelta*sin(h)
%    cos(fi)*cossalt=-coslat*sindelta+sinlat*cosdelta*cos(h);
%    cos(fi)*cossalt*coslat=-sindelta+sinlat*sinsalt;

theta=360*r*(iday1-1)/365.25;
el=4.901+0.033*sin(-0.031+theta)+theta;
% declination
sindelta=sin(23.442*r)*sin(el);
cosdelta=sqrt(1-sindelta.^2);
q1=tan(4.901+theta);
q2=cos(23.442*r)*tan(el);
% equation of time
ET=(atan((q1-q2)./(q1.*q2+1)))*4/r;
% calculation of extraterrestrial radiation
Eon=1370*(1+0.033*cos(theta-360*r*2/365.25));

%uurloop

for uur=1:24
   
   Qtot=zeros(1,li);
   Ltot=zeros(1,li);
   
   AST=uur+ET/60-(4/60)*(LSMLON)-0.5;
   h=(AST-12)*15*r;
   
   % hai=sin(solar altitude)
   hai=coslat*cosdelta*cos(h)+sinlat*sindelta;
   
   if hai>0
      Qt=zeros(1,ki);
      % salt=solar altitude
      salt=asin(hai);
      cossalt=cos(salt);
      fi=acos( (hai*sinlat-sindelta)/(cossalt*coslat) )*sign(h); 
      
      Edif=klizo(uur,1);
      Enorm=klizo(uur,3);
      
      gam=fi-gamma;
      cai=cossalt*cos(gam).*sinbeta+hai*cosbeta;
      
      if Edif>0;
         
         % determination of zet = solar zenith angle (pi/2 - solar altitude).
         zet=pii/2-salt; 
         
         % determination of inteps with eps
         inteps=1;
         eps=Enorm/Edif;
         i=find(epsint>=eps);
         inteps=min(i);
         
         % calculation of inverse relative air mass
         airmiv=hai;
         if salt<10*r,
            airmiv=hai+0.15*(salt/r+3.885)^(-1.253);
         end
         
         % delt is "the new sky brightness parameter"
         delt=Edif/(airmiv*Eon);
         
         % determination of the "new circumsolar brightness coefficient
         % (facc(1)) and horizon brightness coefficient (f2acc(2))"
         
         facc=[1 delt zet]*[facc1(:,inteps),facc2(:,inteps)];
         
         % salts=solar altitude for an inclined surface
         salts=pii/2-acos(cai);
         
         % alpha= the half-angle circumsolar region
         alpha=25*r;
         
         xic0=0.5*(1+salts/alpha).*sin((salts+alpha)/2);
         xic=(salts>-alpha).*xic0+(salts>alpha).*(cai-xic0);
         
         if salt>alpha,
            xih=hai;
         else
            xih=sin((alpha+salt)/2);
         end
         
         % determination of the diffuse radiation on an inclined surface
         % Isotropic sky daarna Perez
         
         Ed=0.5*(1+cosbeta)*Edif;
         Ed=Ed+Edif*(facc*[-0.5*(1+cosbeta)+xic/xih;sinbeta]);
         Ed=(Ed>0).*Ed; 
         
         % horizontal surfaces treated separately
         % beta=0 : surface facing up, beta=180(pi) : surface facing down
         
         Ed=Ed+(beta>-0.001 & beta<0.001).*(Edif-Ed)-...
            (beta>(pii-0.001) & beta<(pii+0.001)).*Ed; 
         
      else Edif=0;
         Ed=zeros(1,ki);
      end;    
      
      cai=(cai>0).*cai;
      
      Ehor=Enorm*hai+Edif;
      Qt=Ed+0.5*gref*(1-cosbeta)*Ehor+cai*Enorm;
      
      % total irradiation on an inclined surface
      Qtot(1:ki)=Qt;
      
      for i=ki+1:li
         k=orbel(i,1);
         l=orbel(i,2);
         Qtot(i)=Qt(k)-difred(l)*Ed(k);
         if cai(k)>0 
            is=ceil(nschad(l)*hai);
            js=ceil(mschad(l)*(sin(gam(k))+1)/2);
            FS=wschad(l,3+(js-1)*nschad(l)+is);
            Qtot(i)=Qt(k)-FS*cai(k)*Enorm;
         end;
      end;
      
      
   end; % einde zonhoogte>0
   
   % vertrek
   Te=klizo(uur,2)/10;
   
   Lu=((Te/100+2.7315)^4*(5.67-0.543*(Te/100+2.7315)^2)...
      -61.3*klizo(uur,4)/8)*0.5*(1+cosbeta);
   
   %door afscherming minder langgolvig 
   Ltot(1:ki)=Lu;
   for i=ki+1:li
      k=orbel(i,1);
      l=orbel(i,2);
      Ltot(i)=(1-difred(l))*Lu(k);
   end;
   
   %radiation(uur,:)=[Qtot(:)',Ltot(:)'];
   Esol(uur,:)=Qtot(:)';
Lrad(uur,:)=Ltot(:)';
end %uur
