function y=TwoPointMollier4(Tamb,Wamb,Tproc,Wproc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a mollier diagram given a set of data
% Input 2 moist air conditions (2 variables each)
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

% Convert the humidity into g/kg
Wamb = Wamb.*1000;
Wproc = Wproc.*1000;


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting comfort condition into T, p and x-information, and plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
demands(1:8)=[20 26 NaN NaN 30 70 NaN NaN];
dem=(['Indoor climate compared to comfort standards']);
demleg=(['Comfort        ';'min T  =  20 ºC';'max T  =  26 ºC';'min RH  =  30 %';'max RH  =  70 %']);
Teis([1:(demands(2)-demands(1))*2+3])=[[demands(1):1:demands(2)] [demands(2):-1:demands(1)] demands(1)];
d3=length(Teis)-1;                                                          % calculates T and x for the given demand
for d=[1:(d3/2)]
    peis([d])=6.11*exp(17.08*Teis(d)./(234.18+Teis(d)))*demands(5);
    peis([d3/2+d])=6.11*exp(17.08*Teis(d3/2+d)./(234.18+Teis(d3/2+d)))*demands(6);
end
peis(d3+1)=peis(1);
for d2=[1:(length(Teis))]
    xeis(d2)=611*peis(d2)./(101300-peis(d2));
end
heis(1:length(Teis))=-90.1;
Thelp(1:33)=(-1:1:31);
hhelp(1:33)=90;
for i=1:33
    pmineis(i)=6.11*exp(17.08*Thelp(i)./(234.18+Thelp(i)))*demands(5);
    pmaxeis(i)=6.11*exp(17.08*Thelp(i)./(234.18+Thelp(i)))*demands(6);
    xmineis(i)=611*pmineis(i)./(101300-pmineis(i));
    xmaxeis(i)=611*pmaxeis(i)./(101300-pmaxeis(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure                                                          % opens new plot window




contour(x,T,RV,RV(1,:));                                        % plots isoRHlines in plot
axis([0 25 -1 31]);                                             % sets axis xmin, xmax, Tmin, Tmax
% NewPosition=[0 0 'PaperSize'];                                  % sets paper margins to zero
orient tall                                                     % stretches figure to A4-size
hold on   
legstr=[];                                                      % creates empty matrix to put legenddata in

t1=title('Mollier Diagram');
set(t1,'FontSize',20);
xlabel('Specific Humidity [g/kg]')
ylabel('Dry Bulb Temperature [ºC]')
% undertext=text(12.5,-3.5,'dates');
% set(undertext,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center');

% creates text label for each isoRHline and append legend
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

% Plot the ambient dots and append the legend
plot(Wamb,Tamb,'d','color','r','MarkerFaceColor','r','MarkerSize',5);
legstr=char(legstr,'Ambient Air');
%,[1 .8 .5],

% Plot the process dots and append the legend
plot(Wproc,Tproc,'d','color','b','MarkerFaceColor','b','MarkerSize',5);
legstr=char(legstr,'Process Air');

% (This was used to plot AIL nominal performance data) 
% for i = 1:length(AILpsyc(:,5))
%     plot([AILpsyc(i,3).*1000,AILpsyc(i,5).*1000],[AILpsyc(i,1),AILpsyc(i,4),],'-','color',[0 0.4 1]);
% end 

% plot(AILpsyc(:,3).*1000,AILpsyc(:,1),'o','color',[1 0 1],'MarkerFaceColor','r',...
%                 'MarkerSize',10);
% legstr=char(legstr,'Nominal Ambient Conditions');
% 
% plot(AILpsyc(:,5).*1000,AILpsyc(:,4),'o','color',[.6 1 0],'MarkerFaceColor','b',...
%                 'MarkerSize',10);
% legstr=char(legstr,'Nominal Cooling');

% Plot the ASHRAE summer comfort zone
plot3([13.6 12.2 4.5 4.5 13.6],[22.8 26 27.2 23.3 22.8],[-1 -1 -1 -1 -1],'-','color',[0.87059     0.92157     0.98039],'LineWidth',[10])
legstr=char(legstr,'Comfort Zone Boundary');

% Plot some connecting process lines
for i = 1:10:length(Wamb)
    plot([Wamb(i),Wproc(i)],[Tamb(i),Tproc(i)],':','color',[0 0.4 1]);
end 


l=legend([legstr],4 );                                                     % creates legend containing all legstrings in lower right corner
set(l,'FontSize',12);                                                       % sets legend fontsize to 7

y=0;

end