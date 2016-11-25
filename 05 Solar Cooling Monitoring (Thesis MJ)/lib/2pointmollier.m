function y=TwoPointMollier(Tamb,Wamb,Tproc,Wproc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a mollier diagram given a set of data
% 
% Modified from the following:
%  *****************************************************
% plots data into a mollier diagram, using data points and weekly averages
% january 19, 2005, TUe, PBE, MM and JvS
% mollier(sensor,condition,title,filename,[0;0;0;0;0;0;1;0;0;0]), condition can be 1=air, 2=surf, 3=in, 4=surf2, 5=gap
%                                          ASHRAE A  Thomson1
%                                            ASHRAE B  Thomson2
%                                              ASHRAE C  Deltaplan
%                                                ASHRAE D  Mecklenburg
%
%                                                  Jutte     Lafontaine        (none, one or more can be '1')
% *****************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mollierdiagram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:11                                                   % sets temperature matrix, 1 cell = 1 degree
    for h=1:81                                                % -20 up to 60 degrees Celsius
        T(h,j)=(h-21);
    end
end
for i=1:81;
    RV(i,1:11)=0:0.1:1;                                         % sets humidity matrix, in steps of 10%
end
% To get RH lines, convert from RH into T/W
for k=1:11                                                    % calculates p for each temperature and humidity
    for l=1:20
        p(l,k)=611*exp(22.44*T(l,1)./(272.44+T(l,1)))*RV(l,k);
    end
    for l=21:81
        p(l,k)=611*exp(17.08*T(l,1)./(234.18+T(l,1)))*RV(l,k);
    end
    for m=1:81
        x(m,k)=611*p(m,k)./(101300-p(m,k));                         % calculates moisture content for each p
    end
end

figure                                                          % opens new plot window
contour(x,T,RV,RV(1,:));                                        % plots isoRHlines in plot
axis([0 25 -1 31]);                                             % sets axis xmin, xmax, Tmin, Tmax
% NewPosition=[0 0 'PaperSize'];                                  % sets paper margins to zero
orient tall                                                     % stretches figure to A4-size
hold on   
legstr=[];                                                      % creates empty matrix to put legenddata in

t1=title('Testing');
set(t1,'FontSize',20);
xlabel('Specific Humidity [g/kg]')
ylabel('Dry Bulb Temperature [ºC]')
% undertext=text(12.5,-3.5,'dates');
set(undertext,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center');

% creates text label for each isoRHline

text(x(48,2),27,'10%')                                                     
text(x(48,3),27,'20%')
text(x(48,4),27,'30%')
text(x(48,5),27,'40%')
text(x(48,6),27,'50%')
text(x(48,7),27,'60%')
text(x(48,8),27,'70%')
text(x(48,9),27,'80%')
text(x(48,10),27,'90%')
text(x(48,11),27,'100%')
grid;                                                                      

legstr=[legstr;'Constant RH Lines'];

plot(Wproc,Tproc,'.','color',[.6 .6 1]);
legstr=char(legstr,'Process Air');

plot(Wamb,Tamb,'.','color',[1 .8 .5]);
legstr=char(legstr,'Ambient Air');

l=legend([legstr],4 );                                                     % creates legend containing all legstrings in lower right corner
set(l,'FontSize',7);                                                       % sets legend fontsize to 7

y=0;

end