function psychart(action);
% psychart.m
% LL=1, 英制單位; =2 為公制單位
% V(11)現存單位資料, VV(11,LL)存對等資料
%1.Dry-bulb temperature   (C) ,V(1)
%2.Wet-bulb temperature   (C) ,V(2) 
%3.Dew-point temperature  (C) ,V(3)
%4.Relative humidity      (%) ,V(4) 
%5.Absolute Humidity      (-) ,V(5) 
%6.Specific volume    (m3/kg) ,V(6) 
%7.Enthalpy           (m3/kg) ,V(7)
%8.Latent heat        (m3/kg) ,V(8)
%9.Saturated pressure   (kpa) ,V(9) 
%10.Vapor pressure      (kpa) ,V(10)  
%11.Atomosphere pressure(kpa) ,V(11)  
global aa mm hh ind figNumber
if nargin<1,
    action='initialize';
end;
switch action
case 'initialize'
    aa=[50 25 11.9 12.6 0.009 0.929 74 0.1064 1474 12350];
    tc=aa(1);tw=aa(2);rh=aa(3);tdp=aa(4);ah=aa(5);
    ind=zeros(1,4);
    mm=aa(1:5);mm(5)=1;
    figNumber=figure( ...
        'Name','Psychrometric Chart(SI units)', ...
        'NumberTitle','off', 'Visible','off');
    axes( ...
        'Units','normalized',  ...
        'Position',[0.10 0.45 0.65 0.50]);
    set(gca, 'FontSize',7); 
    psyplot(tc,ah,gcf,mm(5));


    %===================================
    % Set up the MiniCommand Window
    top=0.35;
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    promptStr=char(' ', ...
       '請輸入乾球, 濕球, 相對濕度及露點溫度等參數中之兩項', ...
       ' ','超過兩項輸入時,則以前兩項或相近兩項為輸入值', ' ',...
       '輸入妥當後, 請按執行紐....');
    % First, the MiniCommand Window frame
    frmBorder=0.02;
    frmPos=[left-frmBorder bottom-frmBorder ...
        (right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol( ...
        'Style','frame','Units','normalized', 'Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50]);
    % Then the text label
    labelPos=[left top-labelHt (right-left) labelHt];
    uicontrol( ...
        'Style','text', 'Units','normalized', 'Position',labelPos, ...
        'BackgroundColor',[0.50 0.50 0.50], 'ForegroundColor',[1 1 1], ...
        'String','提 示 板');
    % Then the editable text field
    mcwPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    hh(1)=uicontrol( 'Style','text', 'HorizontalAlignment','left', ...
        'Units','normalized', 'Max',10, 'BackgroundColor',[1 1 1], ...
        'Position',mcwPos, 'String',promptStr);
    % Save this handle for future use
    set(gcf,'userdata',hh(1));

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    left=0.80;
    btnWid=0.15;
    btnHt=0.08;
    % Spacing between the button and the next command's label
    spacing=0.03;

    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    uicontrol('Style','frame','Units','normalized','Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50]);
    
    %====================================
    % The execute the program
    top=0.95;
    left=0.80;
    btnWid=0.15;
    btnHt=0.08;
    height=btnHt/2;
    boxx=[top left btnWid btnHt];
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hh(2)=uicontrol('Style','push','Units','normalized', 'Position',btnPos, ...
        'String','執行', 'Callback','psychart(''start'')');

   
    %====================================
    % input dry-bulb button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx1=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','乾球溫度(C)');
    btnPos=[left yPos-btnHt btnWid height];
    hh(3)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(tc),'Callback','psychart(''change'')');

    %====================================
    % Input wet-bulb button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx2=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','濕球溫度(C)');
    btnPos=[left yPos-btnHt btnWid height];
    hh(4)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(tw),'Callback','psychart(''change'')');
 
    %====================================
    % Input rel. hum. button
    btnNumber=4;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx3=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','相對濕度(%)');
    btnPos=[left yPos-btnHt btnWid height];
    hh(5)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(rh),'Callback','psychart(''change'')');
 
    % Input abs. hum. button
    btnNumber=5;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx4=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','露點溫度(C)');
    btnPos=[left yPos-btnHt btnWid height];
    hh(6)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(tdp),'Callback','psychart(''change'')');
    % Input abs. hum. button
    btnNumber=6;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx5=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
       'String','變更範圍');
    btnPos=[left yPos-btnHt btnWid height];
    hh(7)=uicontrol('Style','slider','Units','normalized', 'Position',btnPos, ...
        'max',1,'min',0.3,'value',1,'Callback','psychart(''change'')');
    %====================================

    %====================================
    % The INFO button
    uicontrol('Style','push', 'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String','Info', 'Callback','psychart(''info'')');

    %====================================
    % The CLOSE button
    uicontrol( 'Style','push','Units','normalized', ...
        'Position',[left bottom btnWid btnHt], ...
        'String','Close', 'Callback','close(gcf)');

    % Now uncover the figure
    set(figNumber,'Visible','on');
    mode=0;
 case 'change'
   %輸入新值,並進行檢查,若有變化,則進行回存及顯示
   for i=1:4, 
      temp=str2num(char(get(hh(i+2),'string')));
      if abs((temp-mm(i))/mm(i))>0.01,
         switch i,
         case {1,3} % db 
            if temp<0, temp=0;end;
            if temp>100,temp=100;end;
         case 2 %wb
            if temp>mm(1), temp=mm(1);end;
            if temp<mm(4), temp=mm(4);end;
         case 4 % tdp
            if temp<-10, temp=-10;end;
            if temp>100, temp=100;end;
         end
         mm(i)=temp;if temp~=aa(i),ind(i)=1;end;
      end;
   end;
   ii=sum(ind);
   switch ii
   case {1,3,4}
      if ind(1)==1 & mm(1)<mm(2), mm(2)=mm(1);end
      if ind(2)==1 & mm(1)<mm(2), mm(1)=mm(1);end
      if ind(4)==1 & mm(1)<mm(4), mm(1)=mm(4);end
   case 2
      if ind(1)==1 & ind(2)==1 & mm(1)<mm(2), mm(2)=mm(1);end
      if ind(1)==1 & ind(4)==1 & mm(1)<mm(4), mm(4)=mm(1);end
      if ind(2)==1 & ind(4)==1 & mm(2)<mm(4), mm(4)=mm(2);end
   end
   for i=1:4,set(hh(i+2),'string',num2str(mm(i)));end
   temp=get(hh(7),'value');
   if abs((temp-mm(5))/mm(5))>0.01,
      mm(5)=temp;
      figure(figNumber)
      psyplot(aa(1),aa(5),gcf,mm(5));
   end;
    
case 'start'
   % 開始執行
   tc=mm(1);tw=mm(2);rh=mm(3);tdp=mm(4);ah=aa(5);
   sv=aa(6);enp=aa(7);mu=aa(8);pv=aa(9);ps=aa(10);  
   mode=0;
   for i=1:4, 
      mode=mode+ind(i)*i*i;
   end;
   ind(:)=[0];
   switch mode
   case {5,1,2,14,21,30}  %known tc,tw
      ah=ah3c(tc,tw);
      ps=pst(tc);
      ahs=ahc(ps);
      mu=ah/ahs;
      rh=rh2(mu,ps);
      sv=vah(tc,ah);
      enp=enthal(tc,ah);
      pv=pvh(ah);
      tdp=dp2c(tc,pv);
      
   case {9,10}      % known db, rh
      ps=pst(tc);     %satuated pressure, pa
      pv=rh*ps/100;   %vapor pressure,pa
      ah=ahc(pv);     %Absolute humidity,dimensionless
      ahs=ahc(ps);
      mu=ah/ahs;
      sv=vah(tc,ah);
      enp=enthal(tc,ah);
      tdp=dp2c(tc,pv);%dew-point temp, C
      tw=wbc(tc,pv);  %Web-bulb temp, C
      
   case 13
      %known tw,rh
      mod='ah=ah3c(tc0,tw);ps=pst(tc0);ahs=ahc(ps);mu=ah/ahs;rh0=rh2(mu,ps);';
      x1=tw+5;x2=tw+10;% assumed Tf, and Tf>Tw
      ok=1;i=1;
      while 1,
         tc0=x1;eval(mod);
         y1=rh0;
         tc0=x2;eval(mod);
         y2=rh0;
         if abs(y2-y1)<0.05, x1x=(x1+x2)/2;break; end;
         x1x=x1+((rh-y1)*(x2-x1)/(y2-y1));
         if abs(x1-x1x)>abs(x2-x1x),
            x1=x1x;
         else
            x2=x1x;
         end;
         i=i+1;
         if i>100, 
            set(hh(1),'string','Warning: too many loop times');
            ok=~ok;pause;
         end
         
      end;
      tc=x1x;tc0=tc;eval(mod);
      pv=ps*rh/100;
      tdp=dp2c(tc,pv);
      ah=ahc(pv);     %Absolute humidity,dimensionless
      hfg=hfgc(tc);   %evaporation heat, kJ/kg
      enp=enthal(tc,ah);
      sv=vah(tc,ah);
      
   case {16,17}
      %known db, tdp
      pv=pst(tdp);
      ps=pst(tc);
      rh=pv/ps*100;
      hfg=hfgc(tc);
      tw=wbc(tc,pv);  %Web-bulb temp, C
      ahs=ahc(ps);
      ah=ahc(pv);
      mu=ah/ahs;
      enp=enthal(tc,ah);
      sv=vah(tc,ah);
      
   case 20
      %known tw, tdp
      pv=pst(tdp);
      x1=tw+5;x2=tw+10;% assumed Tf, and Tf>Tw
      ok=1;i=1;
      while 1,
         y1=wbc(x1,pv);
         y2=wbc(x2,pv);
         if abs(y2-y1)<0.05, x1x=(x1+x2)/2;break; end;
         x1x=x1+((rh-y1)*(x2-x1)/(y2-y1));
         if abs(x1-x1x)>abs(x2-x1x),
            x1=x1x;
         else
            x2=x1x;
         end;
         i=i+1;
         if i>100, 
            set(hh(1),'string','Warning: too many loop times');
            ok=~ok;pause;
         end
      end;
      tc=x1x;
      ps=pst(tc);
      rh=pv/ps*100;
      hfg=hfgc(tc);
      ahs=ahc(ps);
      ah=ahc(pv);
      mu=ah/ahs;
      enp=enthal(tc,ah);
      sv=vah(tc,ah);
   case {25,26,29}
      %known rh,tdp
      pv=pst(tdp);
      ps=pv/rh/100;
      x1=tdp+5;x2=tdp+10; % assumed Tc, and Tc>tdp
      ok=1;i=1;
      while 1,
         y1=dp2c(x1,ps); %try tdp
         y2=dp2c(x2,ps);
         if abs(y2-y1)<0.05, x1x=(x1+x2)/2;break; end;
         x1x=x1+((rh-y1)*(x2-x1)/(y2-y1));
         if abs(x1-x1x)>abs(x2-x1x),
            x1=x1x;
         else
            x2=x1x;
         end;
         i=i+1;
         if i>100, 
            set(hh(1),'string','Warning: too many loop times');
            ok=~ok;pause;
         end
      end;
      tc=x1x;
      ah=ahc(pv);
      ahs=ahc(ps);
      mu=ah/ahs;
      tw=wbc(tc,pv);  %Web-bulb temp, C
      hfg=hfgc(tc);   %evaporation heat, kJ/kg
      enp=enthal(tc,ah);
      sv=vah(tc,ah);
      
   end;
   aa=[tc tw rh tdp ah sv enp mu pv ps];
   set(hh(3),'string',num2str(tc));
   set(hh(4),'string',num2str(tw));
   set(hh(5),'string',num2str(rh));
   set(hh(6),'string',num2str(tdp));
   s=char(['The other information as follows:'],...
          ['The absolute humidity------ ' num2str(ah) ' kg/kg.'],...
          ['The specific volume   ----- ' num2str(sv) ' m3/kg.'],...
          ['The enthalpy -------------- ' num2str(round(enp)) ' kJ/kg.'],...
          ['The degree of saturation--- ' num2str(mu) ' -.'],...
          ['The partial pressure ---------- ' num2str(round(pv)) ' Pa.'],...
          ['The saturated pressure ---- ' num2str(round(ps)) ' Pa.']);
   set(hh(1),'string',s);
   mm(1:4)=aa(1:4)
   figure(figNumber)
   psyplot(tc,ah,gcf,mm(5));
     
 case 'info'
    message=char(' ',...
       '本程式由國立台灣大學農業機械工程學系馮丁樹教授設計，',...
       '作為"穀物乾燥與模擬"及"乾燥原理與技術"課程之教材。',...
       '作者保留本程式之著作權，請勿私自轉載或變更部份內容。', ...
       '若程式中有任何執行上之問題，請電(02)-23651765，',...
       '或以email:dsfong@ccms.ntu.edu.tw聯絡， 謝謝。');
    
    set(hh(1),'string',message);
 end;
 

   
   
   

%=======================================================================
%=======================================================================
function psyplot(t,h,fig,rr);
%
tmin=t-10*rr;tmax=t+10*rr;hmin=h-0.01*rr;hmax=h+0.01*rr;
incwb=2;incva=0.02;incrh=10;
if rr<0.6, 
   incwb=1;incva=0.01;incrh=5;
end;
if hmin<=0,hmin=0;end;
if tmin<-10, tmin=-10;end;
range=[tmin tmax hmin hmax];
kk=(hmax-hmin)/(tmax-tmin);
figure(fig);
db=tmin:(tmax-tmin)/10:tmax;
for rh=100:-incrh:5;
   ps=pst(db);
   ah=ahc(rh*ps/100);
   plot(db,ah,'b-');
   axis(range);
   xlabel('Dry-bulb Temperature, C');
   ylabel('Absolute Humidity, kg/kg');
      [x,y]=locate(db,ah,kk,range,'y+k*(x-m(1))-m(4)');
      if x>0, 
         text(x,y,[num2str(rh) '%'],'FontSize',8);
      end;  
   hold on;
end;
ahx=ahc(ps);
plot(db,ahx,'b-','linewidth',3);
fill([db tmin],[ahx hmax],'b');
line([tmin tmax],[h h],'color','g','LineStyle',':');
line([t t],[hmin hmax],'color','b','LineStyle',':');
hidden on;
for wb=10:incwb:tmax,
   ah=ah3c(db,wb);
   plot(db,ah,'r-');
   text(db(4),ah(4),[num2str(wb) 'C'],'FontSize',8);
   hold on;
end;
for va=0.8:incva:2
   ah=ah4c(db,va);
   plot(db,ah,'k-');
   text(db(8),ah(8),['\leftarrow' num2str(va) ' m\^3/kg'],'FontSize',6);
   text(db(3),ah(3),['\leftarrow' num2str(va) ' m\^3/kg'],'FontSize',6);
end
plot(t,h,'bo','MarkerSize',10,'linewidth',3);
grid on;hold off;
%
%
%======================================================

function [xx,yy]=locate(x,y,k,m,s)
%find the text position printed
[mx,n]=min(abs(eval(s)));
xx=x(n);
yy=y(n);
if xx>m(2) | xx<m(1), xx=0;end;
if yy>m(4) | yy<m(3), xx=0;end;
%
%
%======================================================
function [ah]=ahc(pv)
% find humidity ratio for SI unit
patm=101325;
pv(pv<=0)=[eps];
pv(pv>=patm)=[patm-eps];
ah=0.62198 * pv ./ (patm - pv);
%======================================================
function [ah]=ah3c(t,tw)
%calculate absolute humidity
%three inputs
pws=pst(tw);
ahs=ahc(pws);
ah=((2501-2.381*t).*ahs -(t-tw))./ ...
   (2501+1.805*t-4.186*tw);%
%======================================================
function [ah]=ah4c(db,va)
%find absolute humidity by specific volume and temperature
patm=101325;c273=273.16;
aa=va*patm./(287 * (db+c273));
ah=(aa-1)/1.6078;
%
%======================================================

function [ps]=pst(t)
%Find a saturated pressure
cc=273.15;
c=[-5674.5359 -0.51523058 -9.677843E-3 6.2215701E-7 ...
      2.0747825E-9 -9.484024E-13 4.1635019 -5800.220 ...
      -5.516256 -4.8640239E-2 4.1764768E-5 -1.4452093E-8 ...
      6.5459673];
ps1=t+cc;ps2=ps1;
ps1(ps1<=cc)=[eps];
ps2(ps2>cc)=[eps];
ps2=exp(c(1)./ps2+c(2)+ps2.*(c(3)+ps2.*(c(4)+ps2.*(c(5)+ps2.* ...
   c(6))))+c(7)*log(ps2));
ps1=exp(c(8)./ps1+c(9)+ps1.*(c(10)+ps1.*(c(11)+ps1.*c(12))) ...
   +c(13)*log(ps1));
ps=ps1+ps2;ps=ps*1000;
%
%
%======================================================
function [rh]=rh2(mu,ps)
%Calculate relative humidity
patm=101325;
rh=mu./(1-(1-mu).*(ps/patm))*100;
%
%
%======================================================
function [va]=vah(t,h)
% calculate the specific volume from 
% dry-bulb temp and humidity ratio
patm=101325;
va = 287 * (t + 273.16).*(1+1.6078*h) / patm;
%
%
%======================================================
function [enthal]=enthal(t,w)
%calculate the enthalpy of air
enthal=1.006*t+w.*(2501 +1.805*t);
%
%
%======================================================
function [dp]=dp2c(Tdb, pv)
% find dew-point temp by pv in pa, Tdb, dp in C
al=log(pv);
for i=1:size(Tdb,1),
   if Tdb(i)<0
      dp(i)=-60.5 +7.0322*al(i) + 0.37*al(i)*al(i);
   else
      dp(i)=-35.957 - 1.8726*al(i) + 1.1689*al(i)*al(i);
   end;
end;
%
%
%======================================================
function [dp]=dp2a(tdb, pv)
% find dew-point temp by pv in pa, Tdb, dp in C
al=log(pv/1000);
dp1=pv;dp2=pv;
dp1(tdb<0)=[eps];
dp2(tdb>=0)=[eps];
dp1=6.54+al.*(14.526+al.*(0.7389+al*0.09486))+0.4569*pv.^0.1984;
dp2=6.09+al.*(12.608+al*0.4959);
dp=dp1+dp2;
%
%
%======================================================
function [pv]=pvh(h)
% find humidity ratio for SI unit
patm=101325;
pv=patm*h./(0.62198 +h);%
%
%======================================================
function [wb]=wbc(T, pv)
% find wet-bulb temp by Brunt, 1941
% input variable, dry-bulb, pv, in C, Pa.
patm=101325;
pwsb0=psc(T);
hfg=hfgc(T);
wbb=dp2c(T,pv);
cc=1.0069254*(1 + .15577 * pv / patm)/( 0.62194*hfg);
ok=1;
while ok,
   pwsb=(pv+cc*patm*(T-wbb))./(1+cc*(T-wbb));
   if abs(pwsb-pwsb0)<0.001, 
      ok=0;
   else
      pwsb0=pwsb;
      wbb=wbsc(pwsb);
   end;
end;
wb=wbb;
%
%======================================================
function [HL]=hfgc(Tc)
% find the latent heat, kJ/kg, Tc in column matrix
c273=273.16;
T=Tc+c273;
for i=1:size(Tc,1),
   if T(i)<255.38, T(i)=255.38, end;
   if T(i) < c273  
      HL(i) = 2839.683144 - 0.21256384*(T(i) -255.38); 
   elseif T <  338.72 
      HL(i) = 2502.535259 - 2.38576424 * (T(i) - c273);
   else
      HL(i) = sqrt(7329155978000 - 15995964.08 * T(i) * T(i))/1000;
   end;
end;
HL=HL';
