function wschad=shadowf0502(Obstruc,kschaduw)
%nov2001

rad=pi/180;
%grid op raam in z-richting
nn=10;
incl=90*rad;
% n= Het aantal gridlijnen verticaal op het raam. Dit is per project steeds hetzelfde getal
%gewijzigd 18 april2000 window(:,5) ipv window(5,:)
n=20;
wschad=zeros(max(kschaduw),2*n^2+3);

for schaduwtyp=kschaduw
   if schaduwtyp~=0
      obstak=Obstruc{schaduwtyp};
      obstak=sortrows(obstak);
      obstak1=obstak;
      if obstak(1,1)==1
         k=length(obstak(:,1));
         obstak(:,5:7)=obstak(:,5:7)-ones(k,1)*obstak(1,5:7);
         breedte=obstak(1,3);
         hoogte=obstak(1,4);
         tetinf=obstak(1,8);
         diepte=obstak(1,2);
         
         
         %grid in y-richting
         mm=round(nn*breedte/hoogte);
         breed=breedte*([1:mm]-0.5)/mm;
         hoog=hoogte*([1:nn]-0.5)/nn;
         [b,a]=meshgrid(breed,hoog);
         as=a*sin(incl);
         ac=a*cos(incl);
         m=2*n;
         FS=zeros(n,m);
         ss0=zeros(n,m);
         
         s=zeros(nn,mm);
         
         for ii=1:n
            salt=asin((2*ii-1)/(2*n));
            
            for jj=1:m
               ss=ones(nn,mm);
               ss1=1;
               phi=-asin((2*jj-1)/m-1);
               tet=pi/2-salt;
               zonv=[cos(phi)*sin(tet),-sin(phi)*sin(tet),cos(tet)];          
               
               if zonv(3)>sin(tetinf*rad);
                  
                  lx=(diepte+ac)/zonv(1);
                  lz=(hoogte-as)/zonv(3);
                  if jj<=m/2
                     ly=-b/zonv(2);
                  else
                     ly=(breedte-b)/zonv(2);    
                  end
                  s=min(ly,lz)<=lx;
                  ss=ss.*(1-s);
                  for nvl=2:k
                     
                     if obstak(nvl,1)==2
                        
                        len10=max( (obstak(nvl,5)+ac)/zonv(1),(obstak(nvl,7)-as)/zonv(3) );
                        len20=min( (obstak(nvl,5)+ac+obstak(nvl,2))/zonv(1),(obstak(nvl,7)-as+obstak(nvl,4))/zonv(3) );
                        if jj<=m/2
                           %zonv(2) is hier<0
                           len1=max( len10,(obstak(nvl,6)-b+obstak(nvl,3))/zonv(2) );
                           len2=min( len20,(obstak(nvl,6)-b)/zonv(2) );
                        else
                           len1=max( len10,(obstak(nvl,6)-b)/zonv(2) );
                           len2=min( len20,(obstak(nvl,6)-b+obstak(nvl,3))/zonv(2) );
                        end
                        s=(len2>=len1);
                        s=s*(1-obstak(nvl,8));
                        ss=ss.*(1-s);
                        
                     elseif obstak(nvl,1)==3
                        
                        inprcyl=(obstak(nvl,6)-b)*zonv(2)+(obstak(nvl,5)+ac)*zonv(1);
                        inprsphere=inprcyl+(obstak(nvl,4)+obstak(nvl,7)-as)*zonv(3);
                        racyl=(obstak(nvl,6)-b).^2+(obstak(nvl,5)+ac).^2;
                        rasphere=racyl+(obstak(nvl,4)+obstak(nvl,7)-as).^2;
                        
                        s=(inprsphere.^2>(rasphere-obstak(nvl,2)^2))|...
                           ( (inprcyl.^2>(racyl-obstak(nvl,3)^2))&...
                           (zonv(3)*racyl.^0.5<(obstak(nvl,4)+obstak(nvl,7)-as)) );
                        % doorlating kale boom in de winter
                        s=s*(1-obstak(nvl,8));
                        ss=ss.*(1-s);
                        
                     elseif obstak1(nvl,1)==4
                        invhoek=(acos(abs(cos(phi)*cos(salt))))/rad;
                        hoek=[0 obstak1(nvl,2:8) 90];
                        doorlating= [1 obstak1(nvl+1,2:8) 0];
                        k1=max(find(hoek<invhoek));
                        ss1=doorlating(k1)+(doorlating(k1+1)-doorlating(k1))*...
                           (invhoek-hoek(k1))/(hoek(k1+1)-hoek(k1));
                     end
                  end
               else
                  ss=zeros(nn,mm);
               end 
               ss0(ii,jj)=1-ss1;
               FS(ii,jj)=1-mean(mean(ss))*ss1;
            end
         end
         
      elseif obstak1(1,1)==4
         
         %grid in y-richting
         m=2*n;
         FS=zeros(n,m);
         ss0=FS;
         for ii=1:n
            salt=asin((2*ii-1)/(2*n));
            for jj=1:m
               ss1=1;
               phi=-asin((2*jj-1)/m-1);
               invhoek=(acos(abs(cos(phi)*cos(salt))))/rad;
               hoek=[0 obstak1(1,2:8) 90];
               doorlating= [1 obstak1(2,2:8) 0];
               k1=max(find(hoek<invhoek));
               ss1=doorlating(k1)+(doorlating(k1+1)-doorlating(k1))*...
                  (invhoek-hoek(k1))/(hoek(k1+1)-hoek(k1));
               FS(ii,jj)=1-ss1;
               ss0=FS;
            end %jj
         end;  %ii
         
      end
      
      %  CIE hemel nog hellingshoek
      w1(2:n+1)=asin([1:n]/n)+sqrt(1-([1:n]/n).^2).*([1:n]/n-(4/3)*(1-([1:n]/n).^2));
      w1(1)=-4/3;
      ww=diff(w1)/(m*(pi/2+4/3));
      
      %pcolor(1:m,1:n,1-FS),colormap('gray'),shading flat
      
      % 20% reflectie
      w=(0.8*FS+0.2*ss0)'*ww';
      SF(4:m*n+3)=FS(:);
      SF(1)=sum(w);
      SF(2)=n;
      SF(3)=m;
      wschad(schaduwtyp,:)=SF;
   end;
   
end

