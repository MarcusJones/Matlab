% plotten van de benodigde grafieken van de simulaties.
figure(4)

subplot(411)
plot([buitentemp bintemp])
xlabel('tijd [uren]')
ylabel('luchttemp [C]')
title('simulatie 11 nov. t/m 31 dec. 2000')
grid
legend ('buiten','kerk',-1)
%axis([0 24 -10 25])	%dag 1 normale omstandigheden
%axis([144 168 -10 25]) %dag 7 met dienst
%axis([984 1008 -10 25]) %kritieke dag t=1000
axis([0 1225 -10 25])

subplot(412)
plot(binvocht*100)
xlabel('tijd [uren]')
ylabel('RV [%]')
grid
legend ('kerk',-1)
%axis([0 24 0 100])	%dag 1 normale omstandigheden
%axis([144 168 0 100]) %dag 7 met dienst
%axis([984 1008 0 100])
axis([0 1225 0 100])

subplot(413)
plot((Hum/2500)*3600)
xlabel('tijd [uren]')
ylabel('Bevochtiging [kg/h]')
grid
legend ('kerk',-1)
%axis([0 24 0 8])	%dag 1 normale omstandigheden
%axis([144 168 0 8]) %dag 7 met dienst
%axis([984 1008 0 8])
axis([0 1225 0 8])

subplot(414)
plot(stoken/1000)
xlabel('tijd [uren]')
ylabel('stookcapaciteit [kW]')
grid
legend ('kerk',-1)
%axis([0 24 0 8])	%dag 1 normale omstandigheden
%axis([144 168 0 8]) %dag 7 met dienst
%axis([984 1008 0 8])
axis([0 1225 0 90])

figure(5)
bintemp1=[bintemp;zeros(1,2)];
subplot(211)
plot([Twix(:,1) bintemp1])
xlabel('tijd [uren]')
ylabel('temp [C]')
title('simulatie: binnenoppervlaktetemp. noordwand')
grid
legend ('noordwand','kerk',-1)
%axis([0 24 -10 25])	%dag 1 normale omstandigheden
%axis([144 168 -10 25]) %dag 7 met dienst
%axis([984 1008 -10 25])
axis([0 1225 0 21])

subplot(212)
binvocht1=[binvocht;zeros(1,2)];
plot([(rvwix(:,1)*100) (binvocht1*100)])
xlabel('tijd [uren]')
ylabel('RV [%]')
title('simulatie: relatieve vochtigheid noordwand')
grid
legend ('noordwand','kerk',-1)
%axis([0 24 0 100])	%dag 1 normale omstandigheden
%axis([144 168 0 100]) %dag 7 met dienst
%axis([984 1008 0 100])
axis([0 1225 0 100])

figure(6)
bintemp1=[bintemp;zeros(1,2)];
subplot(211)
plot([Twig(:,1) bintemp1])
xlabel('tijd [uren]')
ylabel('temp [C]')
title('simulatie: binnenoppervlaktetemp. noordraam')
grid
legend ('raam','kerk',-1)
%axis([0 24 -10 25])	%dag 1 normale omstandigheden
%axis([144 168 -10 25]) %dag 7 met dienst
axis([984 1008 -10 25])
%axis([0 1225 0 21])

subplot(212)
binvocht1=[binvocht;zeros(1,2)];
plot([(rvwig(:,1)*100) (binvocht1*100)])
xlabel('tijd [uren]')
ylabel('RV [%]')
title('simulatie: relatieve vochtigheid noordraam')
grid
legend ('raam','kerk',-1)
%axis([0 24 0 100])	%dag 1 normale omstandigheden
%axis([144 168 0 100]) %dag 7 met dienst
axis([984 1008 0 100])
%axis([0 1225 0 100])

figure(7)
subplot(211)
plot((Hum/2500)*3600)
xlabel('tijd [uren]')
ylabel('Bevochtiging [kg/h]')
title('simulatie: benodigde bevochtigingscapaciteit')
grid
legend ('kerk',-1)
%axis([0 24 0 8])	%dag 1 normale omstandigheden
%axis([144 168 0 8]) %dag 7 met dienst
%axis([984 1008 0 8])
axis([0 1225 0 8])

figure(8)
bintemp1=[bintemp;zeros(1,2)];
subplot(211)
plot([Twex(:,15) bintemp1])
xlabel('tijd [uren]')
ylabel('temp [C]')
title('simulatie: binnenoppervlaktetemp. dakbeschot')
grid
legend ('dakbeschot','kerk','zolder',-1)
%axis([0 24 -10 25])	%dag 1 normale omstandigheden
%axis([144 168 -10 25]) %dag 7 met dienst
%axis([984 1008 -10 25])
axis([0 1225 0 21])

subplot(212)
binvocht1=[binvocht;zeros(1,2)];
plot([(rvwex(:,15)*100) (binvocht1*100)])
xlabel('tijd [uren]')
ylabel('RV [%]')
title('simulatie: relatieve vochtigheid dakbeschot')
grid
legend ('dakbeschot','kerk','zolder',-1)
%axis([0 24 0 100])	%dag 1 normale omstandigheden
%axis([144 168 0 100]) %dag 7 met dienst
%axis([984 1008 0 100])
axis([0 1225 0 100])

figure(9)

subplot(211)
plot([buitentemp bintemp])
xlabel('tijd [uren]')
ylabel('luchttemp [C]')
title('simulatie 11 nov. t/m 31 dec. 2000')
grid
legend ('buiten','kerk',-1)
%axis([0 24 -10 25])	%dag 1 normale omstandigheden
%axis([144 168 -10 25]) %dag 7 met dienst
%axis([984 1008 -10 25]) %kritieke dag t=1000
axis([0 1225 -10 25])

subplot(212)
plot(binvocht*100)
xlabel('tijd [uren]')
ylabel('RV [%]')
grid
legend ('kerk',-1)
%axis([0 24 0 100])	%dag 1 normale omstandigheden
%axis([144 168 0 100]) %dag 7 met dienst
%axis([984 1008 0 100])
axis([0 1225 0 100])

