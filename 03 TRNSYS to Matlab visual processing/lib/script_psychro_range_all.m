

%get_state_points2(trnData,'ZoneAir','ZoA','all')
for i = 1:length(trnData.ZoneAir.ZoA)
    %    trnData.ZoneAir.ZoA{i}.description
    if strcmp(trnData.ZoneAir.ZoA{i}.description,'Entr')
        psyData.T = trnData.ZoneAir.ZoA{i}.data(:,1)
        psyData.w = trnData.ZoneAir.ZoA{i}.data(:,2)
    end
end


psyData.T = psyData.T(trnTime.mask);
psyData.w = psyData.w(trnTime.mask);

psychTitle = ['The  system at ' ];


Tv = psyData.T;
Wv = psyData.w;
%Labels = psyData.labels;
Labels = '234';

% Convert the humidity from g/kg into kg/kg
Wv = Wv.*1;% conversion not necessary, TRN output is [kg/kg]- SL

% sets temperature matrix, 1 cell = 1 degree
% -20 up to 60 degrees Celsius
for j=1:11
    for h=1:81
        T(h,j)=(h-21);
    end
end

% sets humidity matrix, in steps of 10%
for i=1:81;
    RV(i,1:11)=0:0.1:1;
end
% To get RH lines, convert from RH into T/W
% calculates p for each temperature and humidity
for k=1:11
    for l=1:20
        p(l,k)=611*exp(22.44*T(l,1)./(272.44+T(l,1)))*RV(l,k);
    end
    for l=21:81
        p(l,k)=611*exp(17.08*T(l,1)./(234.18+T(l,1)))*RV(l,k);
    end
    % calculates moisture content for each p
    % /1000 to get [kg/kg]- SL
    for m=1:81
        x(m,k)=611*p(m,k)./(101300-p(m,k))/1000;
    end
end

%% Plot data

%if nargin == 1 % This is a fresh plot!
    figure;
    hold on
    axis;
    Handle = gca;

    % Format and and labels:
    contour(T,x,RV,RV(1,:)); % Plot the RH lines
    %clabel(RV);
    axis([0 70 0 0.020]); %changed range from 0-30 to 0-0.03 to fit unit [kg/kg]- SL
    ylabel('Specific Humidity [kg/kg]')  %changed unit from kg/kg to g/kg- SL
    xlabel('Dry Bulb Temperature [ºC]')
    zlabel('Time')
    set(gca,'YAxisLocation','right')
    grid;
%end

%hold on
    title(psychTitle);

% Plot the points
for i = 1:length(Tv)
    plot(Handle,Tv(i),Wv(i),'O','color','b','MarkerFaceColor','b','MarkerSize',10); % MJ Invert
    %text(Tv(i)-0.05,Wv(i)+0.00005,0,Labels(i),'FontSize',12,'FontWeight','bold')   %label coordinates updated to kg/kg- SL

    
%     Can't get "pin to axsis" in script!
%     textOffset = .10; %
%     rX = [Tv(i)+Tv(i)*textOffset, Tv(i)];
%     rY = [Wv(i)+Wv(i)*textOffset, Wv(i)];
%     [fX, fY] = dsxy2figxy(gca, rX, rY);
%     har = annotation('textarrow',fX,fY);
%     set(har,'String','Testing','Fontsize',8)
end

get(gcf)

%% Connect the points - Disabled
%for i = 1:length(Tv)-1
%    plot([Tv(i),Tv(i+1)],[Wv(i),Wv(i+1)],':','color',[0 0.4 1]); % MJ Invert
%end
%hold off
%y=Handle;
%end
