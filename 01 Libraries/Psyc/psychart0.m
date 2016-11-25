% Filename: psychart.m
function psychart(action);
% LL=1, 英制單位; =2 為公制單位
% V(11)現存單位資料, VV(11,LL)存對等資料
%1.Dry-bulb temperature   (C) ,V(1)
%2.Wet-bulb temperature   (C) ,V(2) 
%3.Dew-point temperature  (C) ,V(3)
%4.Relative humidity      (%) ,V(4) 
%5.Atomosphere pressure (kpa) ,V(5)  
%6.Absolute Humidity      (-) ,V(6) 
%7.Specific volume    (m3/kg) ,V(7) 
%8.Enthalpy           (m3/kg) ,V(8)
%9.Latent heat        (m3/kg) ,V(9)
%10.Saturated pressure  (kpa) ,V(10) 
%11.Vapor pressure      (kpa) ,V(11)  
global aa mm hh ind figNumber rhx
if nargin<1,
    action='initialize';
end;
switch action
case 'initialize'
    aa=[50 25 11.9 12.6 101325 0.009 0.929 74 0.1064 1474 12350 ];
    tc=aa(1);tw=aa(2);rhx=aa(3);tdp=aa(4);patm=aa(5);ah=aa(6);
    ind=zeros(1,5);
    mm=aa(1:5);% save the old value in mm , reload the newly input value to compare with mm
    mm(6)=1;	% slider scale default value =1
    figNumber=figure( ...
        'Name','Psychrometric Chart(SI units)', ...
        'NumberTitle','off','Units','normalized', 'Visible','off','Position',[0 0 1 1]);
    axes( ...
        'Units','normalized',  ...
        'Position',[0.1 0.45 .65 0.5]);
    set(gca, 'FontSize',12); 
    psyplot(tc,ah,gcf,mm(6),rhx,patm);


    %===================================
    % Set up the MiniCommand Window
    top=0.35;	    left=0.05;	    right=0.75;	    bottom=0.05;
    labelHt=0.05;	 spacing=0.005;
    promptStr=char(' ', ...
       '   Please confirm/change the atmospheric pressure,',...
       '   then enter 2 out of 4 parameters listed at the right column',...
       '   and then press " Execute!". ', ' ');
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
        'String','Information','FontSize',14);
    % Then the editable text field
    mcwPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    hh(1)=uicontrol( 'Style','text', 'HorizontalAlignment','left', ...
        'Units','normalized', 'Max',10, 'BackgroundColor',[1 1 1], ...
        'Position',mcwPos, 'String',promptStr,'FontSize',14);
    % Save this handle for future use
    set(gcf,'userdata',hh(1));

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    left=0.80;
    btnWid=0.15;
    btnHt=0.06;
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
    top=0.95;	    left=0.80;	    btnWid=0.15;	    btnHt=0.08;
    height=btnHt/2;	
    boxx=[top left btnWid btnHt];
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hh(8)=uicontrol('Style','push','Units','normalized','FontSize',14, 'Position',btnPos, ...
        'String','Execute!', 'Callback','psychart(''start'')');
   
    %====================================
    % input dry-bulb button
    btnNumber=2;
    yPos=top-(btnNumber)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx1=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','Dry bulb (deg. C)','FontSize',12);
    btnPos=[left yPos-btnHt btnWid height];
    hh(2)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(tc),'Callback','psychart(''change'')');

    %====================================
    % Input wet-bulb button
    btnNumber=3;
    yPos=top-(btnNumber)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx2=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','Wet bulb (deg. C)','FontSize',12);
    btnPos=[left yPos-btnHt btnWid height];
    hh(3)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(tw),'Callback','psychart(''change'')');
 
    %====================================
    % Input rel. hum. button
    btnNumber=4;
    yPos=top-(btnNumber)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx3=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','Rel. Humidity (%)','FontSize',12);
    btnPos=[left yPos-btnHt btnWid height];
    hh(4)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(rhx),'Callback','psychart(''change'')');
 
    %====================================
    % Input abs. hum. button
    btnNumber=5;
    yPos=top-(btnNumber)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx4=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','Dew point (deg. C)','FontSize',12);
    btnPos=[left yPos-btnHt btnWid height];
    hh(5)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(tdp),'Callback','psychart(''change'')');
    %====================================
    % input atmosphere pressure
    btnNumber=1;
    yPos=top-(btnNumber)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx1=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
        'String','Atm. pressure (Pa)','FontSize',12);
    btnPos=[left yPos-btnHt btnWid height];
    hh(6)=uicontrol('Style','edit','Units','normalized', 'Position',btnPos, ...
        'string',num2str(patm),'Callback','psychart(''change'')');

    %====================================
    % Input abs. hum. button
    btnNumber=6;
    yPos=top-(btnNumber)*(btnHt+spacing);
    btnPos=[left yPos-btnHt btnWid btnHt];
    hx5=uicontrol('Style','text','Units','normalized', 'Position',btnPos, ...
       'String','Range','FontSize',12);
    btnPos=[left yPos-btnHt btnWid height];
    hh(7)=uicontrol('Style','slider','Units','normalized', 'Position',btnPos, ...
        'max',1,'min',0.3,'value',1,'Callback','psychart(''change'')');
    %====================================

    %====================================
    % The INFO button
    uicontrol('Style','push', 'Units','normalized', ...
        'Position',[left bottom+btnHt+0.4*spacing btnWid 0.7*btnHt], ...
        'String','Info', 'Callback','psychart(''info'')','FontSize',12);

    %====================================
    % The CLOSE button
    uicontrol( 'Style','push','Units','normalized', ...
        'Position',[left bottom btnWid 0.7*btnHt], ...
        'String','Close', 'Callback','close(gcf)','FontSize',12);

    % Now uncover the figure
    set(figNumber,'Visible','on');
    mode=0;
 case 'change'
    %輸入新值,並進行檢查,若有變化,則進行回存及顯示
   for i=1:5, %限制輸入的新值的範圍,並調整使之合理
      temp=str2num(char(get(hh(i+1),'string')));%load 目前格子內現有的值
      if abs((temp-mm(i))/mm(i))>0.01,%檢查有無新輸入值 mm(i)為前次儲存的舊有值
         switch i,%檢查新輸入值是否合理
         case {1,3} % db rh
            if temp<0, temp=0;end;% to ensure Tdb & rh >=0
            if temp>100,temp=100;end;% to ensure Tdb & rh <=100
         case 2 %wb
            if temp>mm(1), temp=mm(1);end;% to ensure Twb <Tdb
            if temp<mm(4), temp=mm(4);end;% to ensure Twb >Tdp
         case 4 % tdp
            if temp<-10, temp=-10;end;% to ensure Tdp>-10
            if temp>100, temp=100;end;% to ensure Tdp<100
         end
         mm(i)=temp;%將修正後的新輸入值存入mm
         if temp~=aa(i),ind(i)=1;end;%標記有更新的資料
      end;
   end;
   ii=sum(ind);%統計有更新資料的個數
   switch ii%配合輸入的新值,調整已存在mm的舊值,使之合理
   case {1,3,4}
      if ind(1)==1 & mm(1)<mm(2), mm(2)=mm(1);end%Tdb有更新,且小於已存在之Twb,則修正Twb使之與Tdb相等
      if ind(2)==1 & mm(1)<mm(2), mm(1)=mm(1);end%Twb有更新,且大於已存在之Tdb,則修正Tdb使之與Twb相等
      if ind(4)==1 & mm(1)<mm(4), mm(1)=mm(4);end%Tdp有更新,且小於已存在之Tdb,則修正Tdb使之與Tdp相等
   case 2%有兩組數據已更新
      if ind(1)==1 & ind(2)==1 & mm(1)<mm(2), mm(2)=mm(1);end%Tdb&Twb同時更新,且Tdb<Twb,則修正Twb使之與Tdb相等
      if ind(1)==1 & ind(4)==1 & mm(1)<mm(4), mm(4)=mm(1);end%Tdb&Tdp同時更新,且Tdp>Tdb,則修正Tdp使之與Tdb相等
      if ind(2)==1 & ind(4)==1 & mm(2)<mm(4), mm(4)=mm(2);end%Twb&Tdp同時更新,且Tdp>Twb,則修正Tdp使之與Twb相等
   end
   for i=1:5,if i~=5, set(hh(i+1),'string',num2str(mm(i),3));end;end%顯示修正後的新輸入值在格中
   temp=get(hh(7),'value');%檢查slider 有無移動
   if abs((temp-mm(6))/mm(6))>0.01,%若有移動slider
      mm(6)=temp;
      figure(figNumber)
      psyplot(aa(1),aa(6),gcf,mm(6),rhx,mm(5));
   end;
    
case 'start'
   % 開始執行
   tc=mm(1);tw=mm(2);rh=mm(3);tdp=mm(4);patm=mm(5);
   ah=aa(6);sv=aa(7);enp=aa(8);mu=aa(9);pv=aa(10);ps=aa(11);  
   mode=0;
   for i=1:5, 
      mode=mode+ind(i)*i*i;%對更新的資料格位進行編碼,以供分類識別,例如僅更新 tw(i=2),則mode= 2*2=4
      %同時更新 tc(i=1) & tw 則mode=1*1+2*2=5
   end;
   if and(ind(5)==1,mode==25)
      mode=1;%若僅更新patm ,則歸類為第1類
   end
   ind(:)=[0];
   switch mode
   case {1,4,5,14,21,30}  %僅更新 tc 或 tw 或同時更新 tc & tw 或 tc & tw & rh 或 tc & tw & tdp 或 tc & tw & rh & tdp
      ah=ah3c(tc,tw,patm);
      ps=pst(tc);
      ahs=ahc(ps,patm);
      mu=ah/ahs;
      rh=rh2(mu,ps,patm);
      sv=vah(tc,ah,patm);
      enp=enthal(tc,ah);
      pv=pvh(ah,patm);
      tdp=dp2c(tc,pv);
      
   case {9,10}       %僅更新 rh(i=3) 或同時更新 tc & rh
      ps=pst(tc);     %satuated pressure, pa
      pv=rh*ps/100;   %vapor pressure,pa
      ah=ahc(pv,patm);     %Absolute humidity,dimensionless
      ahs=ahc(ps,patm);
      mu=ah/ahs;
      sv=vah(tc,ah,patm);
      enp=enthal(tc,ah);
      tdp=dp2c(tc,pv);%dew-point temp, C
      tw=wbc(tc,pv,patm);  %Web-bulb temp, C
      
   case 13
      %known tw,rh
      mod='ah=ah3c(tc0,tw,patm);ps=pst(tc0);ahs=ahc(ps,patm);mu=ah/ahs;rh0=rh2(mu,ps,patm);';
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
      ah=ahc(pv,patm);     %Absolute humidity,dimensionless
      hfg=hfgc(tc);   %evaporation heat, kJ/kg
      enp=enthal(tc,ah);
      sv=vah(tc,ah,patm);
      
   case {16,17}  %僅更新 tdp(i=4) 或同時更新 tc & tdp

      pv=pst(tdp);
      ps=pst(tc);
      rh=pv/ps*100;
      hfg=hfgc(tc);
      tw=wbc(tc,pv,patm);  %Web-bulb temp, C
      ahs=ahc(ps,patm);
      ah=ahc(pv,patm);
      mu=ah/ahs;
      enp=enthal(tc,ah);
      sv=vah(tc,ah,patm);
      
   case 20
      %known tw, tdp
      pv=pst(tdp);
      x1=tw+5;x2=tw+10;% assumed Tf, and Tf>Tw
      ok=1;i=1;
      while 1,
         y1=wbc(x1,pv,patm);
         y2=wbc(x2,pv,patm);
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
      ahs=ahc(ps,patm);
      ah=ahc(pv,patm);
      mu=ah/ahs;
      enp=enthal(tc,ah);
      sv=vah(tc,ah,patm);
   case {25,26,29} %同時更新 rh(i=3) & tdp (i=4) 或同時更新 Tc & rh & tdp 或同時更新 Tw & rh & tdp

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
      ah=ahc(pv,patm);
      ahs=ahc(ps,patm);
      mu=ah/ahs;
      tw=wbc(tc,pv,patm);  %Web-bulb temp, C
      hfg=hfgc(tc);   %evaporation heat, kJ/kg
      enp=enthal(tc,ah);
      sv=vah(tc,ah,patm);
      
   end;
      set(hh(2),'string','');
      set(hh(3),'string','');
   set(hh(4),'string','');
   set(hh(5),'string','');
   set(hh(6),'string','');

   aa=[ tc tw rh tdp patm ah sv enp mu pv ps];% 將計算後的值存入aa成為本次新值
   set(hh(2),'string',num2str(tc,3));
   set(hh(3),'string',num2str(tw,3));
   set(hh(4),'string',num2str(rh,3));
   set(hh(5),'string',num2str(tdp,3));
   set(hh(6),'string',num2str(patm));
   s=char([' Other psychrometric properties are as follow:'],[' '],...
          ['       The humidity ratio   --------- ' num2str(ah) ' kg/kg DA'],...
          ['       The specific volume  ------- ' num2str(sv) ' m^3/kg'],...
          ['       The enthalpy  ---------------- ' num2str(round(enp)) ' kJ/kg'],...
          ['       The partial pressure -------- ' num2str(round(pv)) ' Pa'],...
          ['       The saturated pressure ---- ' num2str(round(ps)) ' Pa']);
 %          ['The degree of saturation--- ' num2str(mu) ' -.'],...
  set(hh(1),'string',s,'FontSize',12);
   mm(1:5)=aa(1:5);
   figure(figNumber)
   rhx=rh;
   psyplot(tc,ah,gcf,mm(6),rhx,patm);
     
 case 'info'
    message=char(' ',...
       ' Software developed by Professors Din-Sue Fon and Wei Fang, ', ...
       ' Dept. of Bio-Industrial Mechatronics Engineering, ', ...
       ' National Taiwan University, ',...
       ' All rights reserved by the authors. ',...
       ' E-mail:dsfong@ccms.ntu.edu.tw or weifang@ccms.ntu.edu.tw');
    
    set(hh(1),'string',message,'FontSize',12);
 end;
 
%=======================================================================
%=======================================================================
function psyplot(t,h,fig,rr,rhx,patm);
%
tmin=t-25*rr;tmax=t+25*rr;hmin=h-0.025*rr;hmax=h+0.025*rr;
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
   ah=ahc(rh*ps/100,patm);
   plot(db,ah,'b-');
   axis(range);
   xlabel('Dry-bulb Temperature, C');
   ylabel('Humidity Ratio, kg/kg');
   [x,y]=locate(db,ah,kk,range,'y+k*(x-m(1))-m(4)');
   if x>0, 
      text(x,y,[num2str(rh) '%'],'color','b','FontSize',8);
   end;  
   hold on;
end;
ahx=ahc(ps,patm);
%plot(db,ahx,'b-','linewidth',3);
line([tmin tmax],[h h],'color','g','LineStyle',':');
line([t t],[hmin hmax],'color','b','LineStyle',':');
hidden on;
for wb=0:incwb:tmax,
nn=11;
   ah=ah3c(db,wb,patm);
   plot(db,ah,'r-');
   if rr>=0.6
      if wb-4*fix(wb/4)==0
         for   mm=nn:-1:1;
            if and(and(ah(mm)>hmin+0.002,ah(mm)<hmax),db(mm)<tmax)
               text(db(mm),ah(mm),[num2str(wb) 'C'],'FontSize',8);               
               break
            end
         end
      end
   else
      if wb-2*fix(wb/2)==0
         for   mm=nn:-1:1;
            if and(and(ah(mm)>hmin+0.002*rr,ah(mm)<hmax),db(mm)<tmax)
               text(db(mm),ah(mm),[num2str(wb) 'C'],'FontSize',8);
               break
            end
         end
      end
   end
   hold on;
end;
for va=0.8:incva:2
   ah=ah4c(db,va,patm);
   plot(db,ah,'k-');
 %  if and(ah(8)>hmin,ah(8)<hmax)
%      text(db(8),ah(8),['\leftarrow' num2str(va) ' m\^3/kg'],'color','m','FontSize',8);
         for   mm=nn:-1:1;
            if and(and(ah(mm)>hmin,ah(mm)<hmax),and(db(mm)>tmin,db(mm)<tmax-5*rr))
               text(db(mm),ah(mm),['\leftarrow' num2str(va) ' m\^3/kg'],'color','m','FontSize',8);               
               break
            end
         end
%end
 %  if and(ah(3)>hmin,ah(3)<hmax)
%text(db(3),ah(3),['\leftarrow' num2str(va) ' m\^3/kg'],'color','m','FontSize',8);
 %  end
end
fill([db tmin],[ahx hmax],'g');
plot(t,h,'bo','MarkerSize',10,'linewidth',3);
grid on;hold off;
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
function [ah]=ahc(pv,patm)
% find humidity ratio for SI unit
%pv(pv<=0)=[eps];
%pv(pv>=patm)=[patm-eps];
if pv<=0
   pv=[eps];
end
if pv>=patm/1.00001
   pv=[patm/1.00001];
end

ah=0.62198 * pv ./ (patm - pv);

%======================================================
function [ah]=ah3c(t,tw,patm)
%calculate humidity ratio
%three inputs
pws=pst(tw);
ahs=ahc(pws,patm);
ah=((2501-2.381*t).*ahs -(t-tw))./ ...
   (2501+1.805*t-4.186*tw);%
%======================================================
function [ah]=ah4c(db,va,patm)
%find absolute humidity by specific volume and temperature
c273=273.16;
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
function [rh]=rh2(mu,ps,patm)
%Calculate relative humidity
rh=mu./(1-(1-mu).*(ps/patm))*100;
%
%
%======================================================
function [va]=vah(t,h,patm)
% calculate the specific volume from 
% dry-bulb temp and humidity ratio
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
% find dew-point temp by pv in pa, Tdb, dp in K
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
function [pv]=pvh(h,patm)
% find humidity ratio for SI unit
pv=patm*h./(0.62198 +h);%
%
%======================================================
function [wb]=wbc(T, pv,patm)
% find wet-bulb temp by Brunt, 1941
% input variable, dry-bulb, pv, in C, Pa.
pwsb0=pst(T);
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
function [wbb]=wbsc(pwsb)
% find initial wet-bulb for iteration agorithm.
a=[19.5322 13.6626 1.17678 -0.189693 0.087453 -0.0174053 0.00214768 -.00013843 0.0000038];
aa=0;
for i=1:1:9;
   aa=aa+a(i)*(log(0.00145*pwsb))^(i-1);
end
wbb=255.38+aa-273.15;


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
