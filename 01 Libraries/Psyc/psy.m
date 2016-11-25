%
function psyvalue=psy(factor1,factor2,factor3,action)
%
switch action
case 'pws'
        tdb=factor1;  % in degree C
	if tdb<=0    % for -100 to 0 deg.C
		A1=-5.6745359*10^3;
		A2=6.3925247;
		A3=-9.677843*10^-3;
		A4=0.6221570*10^-6;
		A5=2.0747825*10^-9;
		A6=-0.9484024*10^-12;
		A7=4.16735019;
	else        % for 0 to 200 deg.C
		A1=-5.8002206*10^3;
		A2=1.3914993;
		A3=-48.640239*10^-3;
		A4=41.764768*10^-6;
		A5=-14.452093*10^-9;
		A6=0.0;
		A7=6.5459673;
	end;
	T=tdb+273.15;  % change to Kelvin 
	SatP=A1/T+A2+A3*T+A4*T*T+A5*T*T*T+A6*T*T*T*T+A7*log(T);
	psyvalue=exp(SatP)/1000; 	% in kPa  eq. 2-1
    
 case 'tsat' % eq from ASAE standard 
    psat=factor1; % in kPa
    A0=19.5322;    A1=13.6626;
    A2=1.17678;    A3=-0.189693;
    A4=0.087453;    A5=-0.0174053;
    A6=0.00214768;    A7=-0.138343/1000;A8=0.38/100000;
    c=0.00145;tmpV=log(c*psat*1000);
    Tval=A0+A1*tmpV+A2*tmpV^2+A3*tmpV^3+A4*tmpV^4+...
        A5*tmpV^5+A6*tmpV^6+A7*tmpV^7+A8*tmpV^8;
    T=255.38+Tval;     % in Kelvin
    psyvalue=T-273.15; % change to deg.C
 
    %-------------- a better way of programming ----------------------
    % a=[19.5322 13.6626 1.1768 -0.189693 0.0873453 -0.0174053 0.00214768 -0.00013843 0.0000038];
    % aa=0;
    % for i=1:1:9;
    %    aa=aa+a(i)*(log(0.00145*psat*1000))^(i-1);
    % end
    % psyvalue=255.38+aa-273.15;% in degree C

 case 'hfg'
   tdb=factor1;             % in degree C
   hfg=2501-2.42*tdb;       % in kJ/kg, for tdb between 0 and 65 degree C      
   psyvalue=hfg;
 
 case 'hfg2'                % find the latent heat, kJ/kg, 
   tdb=factor1;             % in degree C
   T=tdb+273.15;
   if T < 255.38, T=255.38, end;
   if T < 273.15  
      hfg = 2839.683144 - 0.21256384*(T -255.38); 
   elseif T <  338.72 
      hfg = 2502.535259 - 2.38576424 * (T - 273.15);
   else
      hfg = sqrt(7329155978000 - 15995964.08 * T * T)/1000;
   end;
   psyvalue=hfg;
   
case 'pw'           		% Pw is f(Pws, rh)
   pws=factor1;  			% in kPa
   rh=factor2;  			% in %
   pw=pws*rh/100;           % in kPa
   psyvalue=pw;
   
case 'pw2'					% Pw =f(patm,ah)
   patm=factor1;    		% in kPa
   ah=factor2;              % in kg/kg   
   pw=patm*ah/(0.62198+ah);
   psyvalue=pw;             % in kPa
   
case 'rh'           		% rh = f(Pw, Pws)
   pw=factor1;      		% in kPa
   pws=factor2;             % in kPa
   rh=factor1/factor2*100;
   if rh>100,rh=100;end
   psyvalue=rh;             % in %
   
case 'dos'					% dos=f(Patm, Pws, rh)
   patm=factor1;			% in kPa
   pws=factor2;             % in kPa
   rh=factor3;				% in %
   pw=pws*rh/100;			% in kPa
   dos=rh * (patm - pws) / (patm-pw);	% ND
   if dos>100, dos=100;end
   psyvalue=dos;
   
case 'ah'             		% ah=f(Patm, Pw)  =f(Patm,Pws,rh)
   patm=factor1;            % in kPa
   pws=factor2;             % in kPa
   rh=factor3;              % in percentage
   pw=pws*rh/100;           % in kPa
   ah=0.62198*pw/(patm-pw); % eq.2-9
   psyvalue=ah;             % in kg/kg
   
case 'tdp'          		% Tdp=f(tdb, Pw)
   tdb=factor1;             % in degree C
   pwk=factor2;             % in kPa
   pw=pwk*1000;  			% in Pa
   if tdb<0 
      tdp=-60.45+7.0322*log(pw)+0.37*log(pw)^2; 	% eq.2-17  for -60 to 0 degree C, pw in Pa
   else
      tdp=-35.957-1.8726*log(pw)+1.1689*log(pw)^2;  % eq.2-18  for 0 to 70 degree C, pw in Pa
   end
   if tdp>tdb, tdp = tdb;end
   psyvalue=tdp; % in degree C
   
case 'tdp2'     % ASHRAE p.6.9 (1993 Fundamentals handbook)
   pw=factor1; 
   c14=6.54;c15=14.526;c16=0.7389;c17=0.09486;c18=0.4569;
   afa=log(pw);afa2=pw^0.1984;
   % for tdb=0~90 deg.C
   tdp2=c14+c15*afa+c16*afa^2+c17*afa^3+c18*afa2;   
   psyvalue=tdp2; % in degree C

case 'h'                	% h = f(tdb, ah)
   tdb=factor1;        		% in degree C
   ah=factor2;         		% in kg/kg
   h=1.006*tdb+ah*(2501+1.805*tdb);     			% eq.2-21
   psyvalue=h;              % in kJ/kg   
   
case 'sv'
   patm=factor1;            % in kPa
   p=patm*1000;             % in Pa
   tdb=factor2;     		% in degree C
   tk=tdb+273.15;           % in K
   ah=factor3;        		% in kg/kg
   sv=(1/p)*287.055*tk*(1+1.6078*ah)/(1+ah);
   psyvalue=sv;             %in m3/kg
   
case 'twb'
   tdb=factor1;    tdp=factor2;
   % Note: this equation is good for patm=101325 Pa only.
   if abs(tdb - tdp) < .001, psyvalue=tdb;return;end
 X = tdb;
 a = .011569; b = .613423862; 
 c = -.00643928; D = 7.52158e-05; 
 e = -4.5287e-07;
 ap1 = a + b * X + c * X ^ 2 + D * X ^ 3 + e * X ^ 4;
 a = .419636669; b = .027436851;
 c = .007711576; D = .001536155;
 e = .00023861;
 bp1 = (a + c * X + e * X ^ 2) / (1 + b * X + D * X ^ 2);
 a = .011146403;b = .027956528;
 c = .000255119;D = .002122386;
 e = 7.1215e-06;
 cp1 = (a + c * X + e * X ^ 2) / (1 + b * X + D * X ^ 2);
 a = 9.65426e-05;b = -.00292091;
 c = 7.15163e-07;D = .001201577;
 dp1 = (a + c * X) / (1 + b * X + D * X ^ 2);
 twb = ap1 + bp1 * tdp + cp1 * tdp * tdp + dp1 * tdp * tdp * tdp;
 if twb > tdb,twb = tdb;end
 if twb < tdp,twb = tdp;end
   psyvalue=twb;

case 'twb2'
% method of use   wb = psy(T, pv, patm, 'twb2')
% find wet-bulb temp by Brunt, 1941
% input variable, dry-bulb T, pv, patm in C, kPa, kPa.

T=factor1;                       %in degree C
pvapor=factor2;                  % in kPa
patmosphere=factor3;             % in kPa

pv=pvapor*1000;                  % in Pa
patm=patmosphere*1000;           % in Pa
pwsb0=1000*psy(T,999,999,'pws'); % pwsb0 in Pa

hfg=psy(T,999,999,'hfg2');
wbb=psy(T,pv/1000,999,'tdp');

cc=1.0069254*(1 + .15577 * pv / patm)/(0.62194*hfg);
ok=1;
while ok,
   pwsb=(pv+cc*patm*(T-wbb))/(1+cc*(T-wbb));
   if abs(pwsb-pwsb0)<0.001, 
      ok=0;
   else
      pwsb0=pwsb;
      wbb=psy(pwsb/1000,999,999,'tsat');  
   end;
end;
tdb=T;
 if wbb > tdb,twb = tdb;end
psyvalue=wbb;

case 'rh2'
   %... note that this equation is only good for Tdb in the range of 10~70
   %C and patm=101.325 kPa 
   tdb=factor1;
   twb=factor2;
   if abs(tdb - twb)< .001
      rh=100;
   else
    aa = 6.5283207 - 3243.72695 / tdb + 27478.51412 * log(tdb) / tdb / tdb - 31804.835/ tdb/tdb;
    bb = -5.7823757 + .00014449003 * tdb * tdb * sqrt(tdb) - .000012648953 * tdb * tdb * tdb + 45.725691 / sqrt(tdb);
    cc = -1.8793625 - .034446164 * tdb - .51282028 * (log(tdb)) ^ 2 + 1.6161997 * sqrt(tdb);
    dd = .0018867775 - .00000020696545 * tdb * tdb * sqrt(tdb) + .000000020593745 * tdb * tdb * tdb - 59.002463 * exp(-tdb);
    rh = aa + bb * twb + cc * twb * twb + dd * twb * twb * twb;
   end    
   if rh < 0, rh=0;end
   if rh>100,rh=100;end
   psyvalue=rh;         
   
case 'THI1'
   tdb=factor1;
   twb=factor2;
   THI1 = .35 * tdb + .65 * twb;   %.. eq. from Bianca, 1962.
   psyvalue=THI1;
   
case 'THI2'
   tdb=factor1;
   tdp=factor2;
   THI2 = tdb + .36 *tdp + 41.2;   %... eq. from ASAE STANDARD
   psyvalue=THI2;
   
case 'DI'
   tdb=factor1;
   tdp=factor2;
   DI = .99 * tdb + .36 * tdp + 41.5; %... Discomfort index from ASHRAE
   psyvalue=DI;
end;
%--------------------------------------------------------------------------
