function y=PsychroPlot(Tv,Wv,Labels,time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script: Pschrometric process plot
% Marcus Jones - 10 AUG 2009
%
% Input a vector a list of T, w
% Plots a psychrometric process diagram given a set of data
% Input a vector of temperature and hunidity ratio 
% All points
%
% Modified from the script from the HAMLAB package
% Comments from original: 
% *****************************************************
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

% Convert the humidity from g/kg into kg/kg
Wv = Wv.*1;% conversion not necessary, TRN output is [kg/kg]- SL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mollierdiagram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MJ - This section sets the grid for the RH lines

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
        x(m,k)=611*p(m,k)./(101300-p(m,k))/1000;                         % calculates moisture content for each p
                                                                           % /1000 to get [kg/kg]- SL
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on   

contour(T,x,RV,RV(1,:)); % Plot the RH lines
%clabel(RV); 
axis([0 55 0 0.030]); %changed range from 0-30 to 0-0.03 to fit unit [kg/kg]- SL
title('Psychrometric Chart');
ylabel('Specific Humidity [kg/kg]')  %changed unit from kg/kg to g/kg- SL
xlabel('Dry Bulb Temperature [�C]') 
set(gca,'YAxisLocation','right')
grid;                                                                      

% Plot and label the points
for i = 1:length(Tv)
    plot3(Tv(i),Wv(i),1,'O','color','b','MarkerFaceColor','b','MarkerSize',10); % MJ Invert
    text(Tv(i)-0.25,Wv(i)+0.0005,Labels{i},'FontSize',12,'FontWeight','bold')   %label coordinates updated to kg/kg- SL
%    text(Tv(i)-0.25,Wv(i),char(i),'FontSize',12,'FontWeight','bold')
end

% Label the points
%for i = 1:length(Tv)

%end

% Label the points
for i = 1:length(Tv)-1
    plot([Tv(i),Tv(i+1)],[Wv(i),Wv(i+1)],':','color',[0 0.4 1]); % MJ Invert
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=0;
end
