function []=shaddrawf1101(Obstruc,schaduwtyp)
obstak=sortrows(Obstruc{schaduwtyp});
if obstak(1,1)==1
   k=length(obstak(:,1));
   obstak(:,5:7)=obstak(:,5:7)-ones(k,1)*obstak(1,5:7);
end

%azimuth 'view' voor situatietekening

fiview=72.5;
%elevatie 'view' voor situatietekening
tetview=30;

rad=pi/180;
inc=90;
%tekenen van de situatie
incl=inc*rad;

xr=[0,0,-obstak(1,4)*cos(incl),-obstak(1,4)*cos(incl)]+obstak(1,5);
yr=[0,obstak(1,3),obstak(1,3),0]+obstak(1,6);
zr=[0,0,obstak(1,4)*sin(incl),obstak(1,4)*sin(incl)]+obstak(1,7);

h=axes('box','on','DataAspectRatio',[1 1 1],'view',[fiview,tetview]);
patch(xr',yr',zr','b')


for nvl=1:k;
   tvl=obstak(nvl,1);
   if tvl==1
      x(1,:)=[0,0,obstak(nvl,2),obstak(nvl,2)]+obstak(nvl,5);
      x(2,:)=[0,obstak(nvl,2),obstak(nvl,2),0]+obstak(nvl,5);
      
      x(3,:)=[0,0,obstak(nvl,2),obstak(nvl,2)]+obstak(nvl,5);
      x(4,:)=[0,obstak(nvl,2),obstak(nvl,2),0]+obstak(nvl,5);
      
      y(1,:)=[0,obstak(nvl,3),obstak(nvl,3),0]+obstak(nvl,6);
      y(2,:)=[0,0,0,0]+obstak(nvl,6);
      
      y(3,:)=[0,obstak(nvl,3),obstak(nvl,3),0]+obstak(nvl,6);
      y(4,:)=[obstak(nvl,3),obstak(nvl,3),obstak(nvl,3),obstak(nvl,3)]+obstak(nvl,6);
      
      z(1,:)=[0,0,0,0]+obstak(nvl,7);
      z(2,:)=[0,0,obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      
      z(3,:)=[obstak(nvl,4),obstak(nvl,4),obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      z(4,:)=[0,0,obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      
      patch(x',y',z',[0.5 0.5 0.5])
      
   elseif tvl==2
      x(1,:)=[0,0,obstak(nvl,2),obstak(nvl,2)]+obstak(nvl,5);
      x(2,:)=[0,obstak(nvl,2),obstak(nvl,2),0]+obstak(nvl,5);
      x(3,:)=[0,0,0,0]+obstak(nvl,5);
      
      x(4,:)=[0,0,obstak(nvl,2),obstak(nvl,2)]+obstak(nvl,5);
      x(5,:)=[0,obstak(nvl,2),obstak(nvl,2),0]+obstak(nvl,5);
      x(6,:)=[obstak(nvl,2),obstak(nvl,2),obstak(nvl,2),obstak(nvl,2)]+obstak(nvl,5);
      
      y(1,:)=[0,obstak(nvl,3),obstak(nvl,3),0]+obstak(nvl,6);
      y(2,:)=[0,0,0,0]+obstak(nvl,6);
      y(3,:)=[0,obstak(nvl,3),obstak(nvl,3),0]+obstak(nvl,6);
      
      y(4,:)=[0,obstak(nvl,3),obstak(nvl,3),0]+obstak(nvl,6);
      y(5,:)=[obstak(nvl,3),obstak(nvl,3),obstak(nvl,3),obstak(nvl,3)]+obstak(nvl,6);
      y(6,:)=[0,obstak(nvl,3),obstak(nvl,3),0]+obstak(nvl,6);
      
      z(1,:)=[0,0,0,0]+obstak(nvl,7);
      z(2,:)=[0,0,obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      z(3,:)=[0,0,obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      
      z(4,:)=[obstak(nvl,4),obstak(nvl,4),obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      z(5,:)=[0,0,obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      z(6,:)=[0,0,obstak(nvl,4),obstak(nvl,4)]+obstak(nvl,7);
      
      patch(x',y',z',[0.5 0.5 0.5])
      
   elseif tvl==3
      
      fr=fiview*rad;
      tetr=tetview*rad;
      fi=rad*[0:15:360];
      tet1=atan2(sin(tetr),cos(tetr)*sin(fi-fr));
      x1=obstak(nvl,2)*(sin(tet1).*cos(fi))+obstak(nvl,5);
      y1=obstak(nvl,2)*sin(tet1).*sin(fi)+obstak(nvl,6);
      z1=obstak(nvl,2)*cos(tet1)+obstak(nvl,7)+obstak(nvl,4);
      xx=obstak(nvl,3)*cos(fr);
      yy=obstak(nvl,3)*sin(fr);
      x2=[-xx,xx,xx,-xx]+obstak(nvl,5);
      y2=[-yy,yy,yy,-yy]+obstak(nvl,6);
      z2=[obstak(nvl,7),obstak(nvl,7),obstak(nvl,7)+obstak(nvl,4),obstak(nvl,7)+obstak(nvl,4)];
      
      patch(x1',y1',z1','g')
      patch(x2',y2',z2',[0.5 0.5 0.5])           
   end;
end;

