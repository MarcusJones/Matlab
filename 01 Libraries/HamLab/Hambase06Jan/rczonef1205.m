function[Building,Elan,Atotzg]=rczonef1205(con,zonetot,wandex,wandia,wandi0,wandin)
% veranderderd 06-02: yvi etc+1, Lv1 alleen positief, en 02-2005 x1 en x alleen
% positief
%# scalar omg2 omg1 ctyp Ri Re Rtot R inva Zvi
%# scalar Zve alfa beta
%# scalar i ilaag lagen
%gewijzigd sep 02 dn1...dn4
%gewijzigd jan 2004 transfer coeff 2febr tu toegevoegd
% maart2004 vertraging correct dec Zvi
%142 okt 2005 dper....*3
%wzc beperkt regel 178

kwallex=wandex(:,3)'; %constructie
kex=wandex(:,1)';     %zone
Awandex=wandex(:,2)';
koudeex=wandex(:,5)';

kwallia=wandia(:,3)';
kia=wandia(:,1)';
Awandia=wandia(:,2)';

kwall0=wandi0(:,3)';
ki0=wandi0(:,1)';
%tempi0=wandi0(:,4)';
Awandi0=wandi0(:,2)';
koude0=wandi0(:,5)';

kwallin=wandin(:,4)';
kini=wandin(:,1)';
kine=wandin(:,2)';
Awandin=wandin(:,3)';

kwall=[kwallex,kwall0,kwallia,kwallin]; %contypes
kbin=[kex,ki0,kia,kini];                  %zones
Awand=[Awandex,Awandi0,Awandia,Awandin];  %wandopp

Iex=zeros(zonetot,length(kex));
Ii0=zeros(zonetot,length(kwall0));
Iw2=zeros(zonetot,length(kini));
%Iow=zeros(zonetot,length(kow));
Iwand1=zeros(zonetot,length(kbin));
Iin=zeros(zonetot,length(kini));
for i=1:zonetot
    Iex(i,:)=(kex==i);
    Ii0(i,:)=(ki0==i);
    Iw2(i,:)=(kine==i).*Awandin;
    %Iow(i,:)=(kow==i);
    Iwand1(i,:)=(kbin==i).*Awand;
    for j=i+1:zonetot
        Iin(i,:)=Iin(i,:)+(kini==i&kine==j);
        Iin(j,:)=Iin(j,:)-(kini==i&kine==j);
    end
end
Atotzg=sum(Iwand1')+sum(Iw2');
%------------------------------------------------------------------------------------------------------------
k1=[sort(kwall),0];
k2=find(diff(k1)~=0);
wand=k1(k2);

yi=zeros(max(wand)+1,23);
ye=zeros(max(wand)+1,23);
yvi=zeros(max(wand)+1,23);
yve=zeros(max(wand)+1,23);
jj=sqrt(-1);
opts=optimset('display','off');
%opts=optimset('display','off','TolX',1e-20);

for ct=1:length(wand)
    %for ct=4
    ctyp=wand(ct);
    % file met constructies
    l= con{ctyp}.matprop(:,1)';
    lambda =con{ctyp}.matprop(:,2)';
    c = con{ctyp}.matprop(:,4)';
    rho =con{ctyp}.matprop(:,3)';
    ksi=con{ctyp}.matprop(:,7)';
    Zvi=con{ctyp}.Zvi;
    Zve=con{ctyp}.Zve;
    mu=con{ctyp}.matprop(:,6)';
    %bv= matprop(:,8)'; %bv.10^7 onbetrouwbaar
    Ri=con{ctyp}.Ri;
    Re=con{ctyp}.Re;
    hi(ctyp)=1/Ri;
    he(ctyp)=1/Re;

    Reab(ctyp)=con{ctyp}.ab*Re;
    Reeb(ctyp)=con{ctyp}.eb*Re;

    lagen=length(l);
    wrl=[Ri,l./lambda,Re]; %warmteweerstand per laag in m2K/W
    wcl=[0,(rho.*c).*l,0];%warmtecapaciteit per laag in J/m2K
    kspouw=find(rho<1.4);
    wrl(kspouw+1)=0.17;
    wcl(kspouw+1)=0;
    if Ri<0.25&Ri>0.001
        wrl(1)=1/(1/Ri+1); %correctie stralingsuitwisseling
    end
    if Re<0.25&Re>0.001
        wrl(lagen+2)=1/(1/Re+1);
    end
    wrc=wrl.*wcl;
    Rtot=sum(wrl);
    % ipv fi wordt met Rtot*fi gerekend
    wrl=wrl/Rtot;
    Building.Ucon(ctyp)=1/Rtot;
    rcum=cumsum(([0,wrl(1:lagen+1)]+wrl(1:lagen+2))/2);
    %al=1-(sum(wcl.*rcum))/sum(wcl);
    %tu=al*(1-al)*Rtot*sum(wcl)/3600;
    ki=cumsum(wrl);
    mi=find(ki>1/2);
    k=mi(1);
    if k>1
        wrle=[wrl(1:k-1),1/2-ki(k-1)];
        wrli=[wrl(k)-1/2+ki(k-1),wrl(k+1:lagen+2)];
        wcle=[wcl(1:k-1),(1/2-ki(k-1))*wcl(k)/wrl(k)];
        wcli=[(wrl(k)-1/2+ki(k-1))*wcl(k)/wrl(k),wcl(k+1:lagen+2)];
    else
        wrle=wrl(k)/2;
        wrli=[wrl(k)/2,wrl(k+1:lagen+2)];
        wcle=wcl(k)/2;
        wcli=[wcl(k)/2,wcl(k+1:lagen+2)];
    end
    rcume=cumsum(([0,wrle(1:k-1)]+wrle)/2);
    rcumi=cumsum((wrli+[0,wrli(1:lagen+2-k)])/2);
    C1=sum(wcle);
    C2=sum(wcli);
    if C1>0
        ale=1-2*(sum(wcle.*rcume))/C1;
    else
        ale=1-2*(sum(rcume));
    end
    if C2>0
        ali=1-2*(sum(wcli.*rcumi))/C2;
    else
        ali=1-2*(sum(rcumi));
    end
    R1=(1-ale)/2;
    R3=ali/2;
    R2=(1+ale-ali)/2;
    stau=(R1*C1*(R2+R3)+R3*C2*(R2+R1))*Rtot/3600;
    ptau=R1*R2*R3*C1*C2*Rtot^2/3600/3600;
    tauu1=(stau+sqrt(stau^2-4*ptau))/2;
    tauu2=(stau-sqrt(stau^2-4*ptau))/2;
    dper=floor(3*tauu1/24);
    om=(1:23)*2*pi/24;
    if dper>1
        om1=(1:23)*2*pi/(dper*24);
        nper=23;
        omega=jj*[om,om1]/3600;
    else
        om1=om;
        nper=0;
        omega=jj*om/3600;
        dper=1;
    end

    omegav=jj*om/3600;
    %------------------------
    % rekenen met kg/kg dus 0.62e-5, del=1.8e-10
    psref=2340;
    ksl=ksi.*l/((0.62e-5)*psref);%vochtcapaciteit per laag in kg/m2(kg/kg)
    k=find(mu<=1);
    mu(k)=1;
    mu(kspouw)=1;
    ksl(k)=1.2*l(k);
    ksl(kspouw)=1.2*l(kspouw);
    mul=(0.62e+5)*(mu.*l)/1.8;        %vochtweerstand per laag in m2s/kg
    k=find(ksl==0);
    ksl(k)=eps;
    wzl=[Zvi,mul,Zve];
    wzc=[0,ksl,0].*wzl;%anders fout!!!
    %Rvtot=sum(wzl);
    %ipv fi wordt met (Zvi+Zve)*fi gerekend
    wzl=wzl/(Zvi+Zve);
    k=find(wzc>1e7);
    dd(k)=sqrt(1e7./wzc(k));
    wzl(k)=wzl(k).*dd(k);
    wzc(k)=1e7;

    %-----------------------------------------------------------------------

    M11=ones(1,nper+23);
    M12=zeros(1,nper+23);
    M21=zeros(1,nper+23);
    M22=ones(1,nper+23);
    argA1t=zeros(1,nper+23);
    A1t=ones(1,nper+23);
    phi=zeros(1,nper+23);

    Mv11=ones(1,23);
    Mv12=zeros(1,23);
    Mv21=zeros(1,23);
    Mv22=ones(1,23);
    %argA1vt=zeros(1,23);
    %A1vt=ones(1,23);
    phiv=zeros(1,23);
    tavnn=ones(1,23);

    for ilaag=1:lagen+2

        R=wrl(ilaag);
        inva=wrc(ilaag);
        B=R;
        A=1;
        D=0;

        Rv=wzl(ilaag);
        invav=wzc(ilaag);
        Bv=Rv;
        Av=1;
        Dv=0;
        tavn=1;
        %misschien beter om ipv 0 0.23 te nemen
        if inva>0
            phi=sqrt(inva*omega);
            ta1=sinh(phi);
            B=(R./phi).*ta1;
            A=cosh(phi);
            D=(phi/R).*ta1;
        end

        if invav>0
            phiv=sqrt(invav*omegav);
            tavn=phiv./sinh(phiv);
            Av=phiv.*coth(phiv);
            Dv=(invav*omegav)/Rv;
        end


        M12c=M11.*B+A.*M12;
        M11=(M11.*A+D.*M12)./M12c;
        Mc21=(M21.*A+M22.*D)./M12c;
        M22=(M21.*B+M22.*A)./M12c;
        M21=Mc21;
        M12=M12c;
        an=angle(M12);
        k=find(an<0);
        an(k)=an(k)+2*pi;
        argA1t=argA1t+an+2*pi*floor(imag(phi)/(2*pi));
        A1t=A1t.*M12;
        M12=M12./M12;


        tavnn=tavnn.*tavn;
        Mv12c=Mv11.*Bv+Av.*Mv12;
        Mv11=(Mv11.*Av+Dv.*Mv12);
        Mv21c=(Mv21.*Av+Mv22.*Dv);
        Mv22=(Mv21.*Bv+Mv22.*Av);
        Mv21=Mv21c;
        Mv12=Mv12c;
    end;
    Ht=1./A1t;
    H=Ht(1:23);
    yi(ctyp,:)=(M22(1:23)-H)/Rtot;
    ye(ctyp,:)=(M11(1:23)-H)/Rtot;
    yvi(ctyp,:)=(Mv22-tavnn)./Mv12/(Zvi+Zve);
    yve(ctyp,:)=(Mv11-tavnn)./Mv12/(Zvi+Zve);

    %gi(ctyp)=1/Rtot/wrl(1);
    %ge(ctyp)=1/Rtot/wrl(lagen+2);
    %gvi(ctyp)=1/Rvtot/wzl(1);
    %gve(ctyp)=1/Rvtot/wzl(lagen+2);

    Uxy(ctyp)=1/Rtot;

    if nper>1
        zz=Ht(24:46);
    else
        zz=H;
    end

    x0=([0,tauu1,tauu2]);
    %version 6.5 syntax:
    [x,fval,exitflag,output]=fminsearch('impederf',x0,opts,zz,om1,dper);
    
    %version 7 syntax:
    %[x,fval,exitflag,output]=fminsearch(@(x)impederf(x,zz,om1,dper),x0,opts);

    x1=abs(x);
    x(1)=x1(1);
    x(2)=(x1(2)+sqrt(x1(2)^2-4*x1(3)))/2;
    x(3)= x1(2)- x(2);

    if x(1)>0
        th=floor(x(1));
        td=x(1)-th;
    else
        th=3;
        td=0;
    end

    if abs(x(2)-x(3))<0.005
        x(2)=x(2)-0.005;
        x(3)=x(3)+0.005;
    end

    e1=exp(-1/x(2));
    etd1=exp(-(1-td)/x(2))*x(2);
    e01=1-td-x(2);
    aa1=e01+etd1;
    aa2=1-e01*(1+e1)-2*etd1;
    aa3=e01*e1-e1+etd1;

    e2=exp(-1/x(3));
    etd2=exp(-(1-td)/x(3))*x(3);
    e02=1-td-x(3);
    ab1=e02+etd2;
    ab2=1-e02*(1+e2)-2*etd2;
    ab3= e02*e2-e2+etd2;

    a1=zeros(1,th+6);
    a1(th+3)=(-aa1*x(2)+ab1*x(3))/(x(3)-x(2));
    a1(th+4)=(-(-aa1*e2+aa2)*x(2)+(-ab1*e1+ab2)*x(3))/(x(3)-x(2));
    a1(th+5)=(-(-aa2*e2+aa3)*x(2)+(-ab2*e1+ab3)*x(3))/(x(3)-x(2));
    a1(th+6)=(-(-aa3*e2)*x(2)+(-ab3*e1)*x(3))/(x(3)-x(2));
    a1(1)=e1+e2;
    a1(2)=-e1*e2;
    a1(4)=a1(4)+a1(3)*a1(1);
    a1(5)=a1(5)+a1(3)*a1(2);
    %Deze factoren gelden ook voor een stapfunctie rechthoekige puls.
    thn(ctyp)=th+6;
    adn(ctyp,1:th+6)=a1;
    if 1==0
        %[ct, x, a1]
        a1
        insling=30;
        T=zeros(1,dper*24*insling);
        T(24*dper*(1:insling-1))=dper;
        qres1=zeros(1,insling*24*dper);
        qres=zeros(1,insling*24*dper);
        for i=length(a1):insling*24*dper
            qres(i)=a1(3)*T(i)+qres1(i-1);
            dt=0;
            for k=4:length(a1)
                dt=dt+a1(k)*T(i+1-k+3);
            end
            qres1(i)=dt+a1(1)*qres1(i-1)+a1(2)*qres1(i-2);
        end

        qqq=qres(((insling-3)*24:(insling-1)*24-1)*dper);
        TTT=T(((insling-3)*24:(insling-1)*24-1)*dper);

        om2=(1:24*dper-1)*2*pi/(dper*24);
        w1=sin(om2/2)./om2;
        sw1=-24*sum(((-1).^(1:24*dper-1)).*w1);
        w=w1/sw1;
        w1=sin(om1/2)./om1;
        sw1=-24*sum(((-1).^(1:24-1)).*w1);
        w2=w1/sw1;

        k=1;
        TT=zeros(1,47+1);
        q2=zeros(1,47+1);
        qc=zeros(1,47+1);
        q2c=zeros(1,47+1);
        for t=0:dper:47*dper
            TT(k)=sum(real(w.*exp(jj*om2*t)))+1/24;
            qc(k)=1/24+sum(real(exp(-jj*om2*x(1)).*(w.*exp(jj*om2*t))./((1+x(2)*jj*om2).*(1+x(3)*jj*om2))));
            q2(k)=sum(real(zz.*(w2.*exp(jj*om1*t))))+1/24;
            q2c(k)=1/24+sum(real(exp(-jj*om1*x(1)).*(w2.*exp(jj*om1*t))./((1+x(2)*jj*om1).*(1+x(3)*jj*om1))));

            k=k+1;
        end
        k=1;
        w1=sin(om/2)./om;
        sw1=-24*sum(((-1).^(1:24-1)).*w1);
        w=w1/sw1;
        for t=0:0.1:(24-0.1)
            %Ttri(k)=sum(real((w.*exp(jj*om*t))))+1/24;
            q3(k)=sum(real(H.*(w.*exp(jj*om*t))))+1/24;
            q3c(k)=1/24+sum(real(exp(-jj*om*x(1)).*(w.*exp(jj*om*t))./((1+x(2)*jj*om).*(1+x(3)*jj*om))));

            k=k+1;
        end

        figure (ct+20)
        % check 2de orde model vs responsiefactoren
        plot((0:47),qc,(0:47),qqq);
        % check 'exact' model vs 2de orde model dper*24h periode
        figure (ct+30)
        %plot([0:47],q2,[0:47],q2c)
        %plot([0:47],24*(q2-q2c))
        % check 'exact' model vs 2de orde model 24h periode
        plot((0:0.1:(24-0.1)),q3,(0:0.1:(24-0.1)),q3c)
        %plot([0:0.1:(24-0.1)],24*(q3-q3c))
    end

end %wand

yy=zeros(zonetot,23);
yv=zeros(zonetot,23);
% berekening weerstanden en capaciteiten in een vertrek
for i=1:23
    yy(:,i)=Iwand1*yi(kwall,i)+Iw2*ye(kwallin,i);
    yv(:,i)=Iwand1*yvi(kwall,i)+Iw2*yve(kwallin,i);
end

Rimean=Atotzg./(hi(kwall)*Iwand1'+he(kwallin)*Iw2');
Cx1=zeros(1,zonetot);
Cx2=zeros(1,zonetot);
Cv1=zeros(1,zonetot);
Cv2=zeros(1,zonetot);
Lx1=zeros(1,zonetot);
Lx2=zeros(1,zonetot);
Lv1=zeros(1,zonetot);
Lv2=zeros(1,zonetot);

opts=optimset('display','off');
%opts=optimset('display','off','TolX',1e-20);
for i=1:zonetot
    zz=yy(i,:);
    x0=([2*abs(zz(1))/om(1),2/om(1),abs(zz(23))/om(23),1/om(23)]);
    %0.13*x0(1)/Atotzg(i)+1/om(1)

    om1=om;

    %version 6.5 syntax:
    [x,fval,exitflag,output]=fminsearch('impederf',x0,opts,zz,om1,0);
    
    %version 7 syntax:
    %[x,fval,exitflag,output]=fminsearch(@(x)impederf(x,zz,om1,0),x0,opts);
    
    
    
    x=abs(x);
    Cx1(i)=x(1);
    Cx2(i)=x(3);
    %LCx1(i)=1/x(2);
    %LCx2(i)=1/x(4);
    Lx1(i)=x(1)/x(2);
    Lx2(i)=x(3)/x(4);

    if 1==0
        k=1;
        w1=sin(om/2)./om;
        sw1=-24*sum(((-1).^(1:24-1)).*w1);
        w=w1/sw1;
        for t=0:0.1:(24-0.1)
            q(k)=sum(real(zz.*(w.*exp(jj*om*t))));
            qe(k)=sum(real(w.*exp(jj*om*t).*(jj*x(1)*om./(1+x(2)*jj*om)+jj*x(3)*om./(1+x(4)*jj*om))));
            k=k+1;
        end
        figure (i+20)
        plot((0:0.1:(24-0.1)),q,(0:0.1:(24-0.1)),qe)
        %plot([0:0.1:(24-0.1)],(q-qe)/max(q))
    end

    zz=yv(i,:);
    x0=([abs(zz(1))/om(1),1/om(1),abs(zz(23))/om(23),1/om(23)]);

    
    %version 6.5 syntax:
    [x,fval,exitflag,output]=fminsearch('impederf',x0,opts,zz,om1,0);
    
    %version 7 syntax:
    %[x,fval,exitflag,output]=fminsearch(@(x)impederf(x,zz,om1,0),x0,opts);
        
    

    x=abs(x);
    Cv1(i)=1000*x(1);   %cv=1000 Vermenigvuldiging met cv om Ca van lucht rectstreeks te bebruiken
    Cv2(i)=1000*x(3);
    %LCv1(i)=1/x(2);
    %LCv2(i)=1/x(4);
    Lv1(i)=1000*x(1)/x(2);
    Lv2(i)=1000*x(3)/x(4);

    if 1==0
        k=1;
        w1=sin(om/2)./om;
        sw1=-24*sum(((-1).^(1:24-1)).*w1);
        w=w1/sw1;
        for t=0:0.1:(24-0.1)
            q(k)=sum(real(zz.*(w.*exp(jj*om*t))));
            qe(k)=sum(real(w.*exp(jj*om*t).*(jj*x(1)*om./(1+x(2)*jj*om)+jj*x(3)*om./(1+x(4)*jj*om))));
            k=k+1;
        end
        figure (i+30)
        plot((0:0.1:(24-0.1)),q,(0:0.1:(24-0.1)),qe)
    end

end

% check frequentie oneindig
%Lg=Iwand1*gi(kwall)'+Iw2*ge(kwallin)'
%Lx1+Lx2
%Lgv=Iwand1*gvi(kwall)'+Iw2*gve(kwallin)'
%(Lv1+Lv2)/1000

%----------------------------------------------------------------------------------------
Reab0=Reab(kwallex);
Reeb0=Reeb(kwallex);
Lex0=Awandex.*Uxy(kwallex)+koudeex;
aLex(1,:)=adn(kwallex,1)';
aLex(2,:)=adn(kwallex,2)';
Ldetae0=adn(kwallex,3)'.*Lex0;
for i=3:(max(thn(kwallex))-1)
    aLex(i,:)=adn(kwallex,i+1)'.*Lex0;
end

Li0=Awandi0.*Uxy(kwall0)+koude0;
aLi(1,:)=adn(kwall0,1)';
aLi(2,:)=adn(kwall0,2)';
Ldetai0=adn(kwall0,3)'.*Li0;
for i=3:(max(thn(kwall0))-1)
    aLi(i,:)=adn(kwall0,i+1)'.*Li0;
end

Ldeta=Ldetae0*Iex'+Ldetai0*Ii0';
%link niet functiegebonden!
if zonetot>=2
    Lin=Awandin.*Uxy(kwallin);
    Ldet1=zeros(zonetot,zonetot);
    aLin1(1,:)=adn(kwallin,1)';
    aLin1(2,:)=adn(kwallin,2)';
    Ldetain=adn(kwallin,3)'.*Lin;
    for i=1:zonetot
        for j=i+1:zonetot
            Ldet1(i,j)=Ldetain*(kini==i&kine==j)';
        end
    end
    Ldet=Ldet1+Ldet1'-diag(sum(Ldet1+Ldet1'));
    for i=3:(max(thn(kwallin))-1)
        aLin1(i,:)=adn(kwallin,i+1)'.*Lin;
    end;
else
    Ldet=zeros(zonetot,zonetot);
    aLin1=0;
end
% ---------------------------------------------------------------------------------
Building.Rimean=Rimean;
Building.Reab0=Reab0;
Building.aLex=aLex;
Building.aLi=aLi;
Building.aLin1=aLin1;
Building.Reeb0=Reeb0;
Building.Iex=Iex;
Building.Iin=Iin;
Building.Ii0=Ii0;
Building.Ldetae0=Ldetae0;
Building.Ldetai0=Ldetai0;

%C was in uren, in seconden wordt deze groter
Elan.Cx1=3600*Cx1';
Elan.Cx2=3600*Cx2';
Elan.Cv1=3600*Cv1';
Elan.Cv2=3600*Cv2';
Elan.Ldet=Ldet;
Elan.Ldeta=Ldeta';
Elan.Lx1=Lx1';
Elan.Lx2=Lx2';
Elan.Lv1=Lv1';
Elan.Lv2=Lv2';


k=isnan(Elan.Cv1);
if sum(k)>0
    error('Walls too thick for vapour calculation')
end
k=isnan(Elan.Cv2);
if sum(k)>0
    error('Walls thick for vapour calculation')
end
k=isnan(Elan.Cx1);
if sum(k)>0
    error('Walls too thick for heat calculation')
end
k=isnan(Elan.Cx2);
if sum(k)>0
    error('Walls thick for heat calculation')
end
