function fig2_2
pa=101.325; % in kPa
eval('clc');
for i=1:1:4;% in %
for j=1:1:41;% in deg.C
    T=j-1;
    pws=psy(T,0,0,'pws');% in kPa
    RH=i*25;
    pw=(RH)/100*pws;           % in kPa
    W(i,j)=0.62198*pw/(pa-pw);
end
end
Tdb=0:1:40;
plot(Tdb,W(1,:),Tdb,W(2,:),Tdb,W(3,:),Tdb,W(4,:));
xlabel('dry-bulb temperature, ^oC');
ylabel('humidity ratio, kg/kg');
grid on;

xp=30;
text(xp,W(1,xp),'25%');
text(xp,W(2,xp),'50%');
text(xp,W(3,xp),'75%');
text(xp,W(4,xp),'100%');





