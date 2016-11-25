function y=conversion(Tair,Tsurf,RHair,time,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% converts raw data to physical properties
% january 19, 2005, TUe, PBE, MM
% sensor=conversion(Tair,Tsurf,RHair,time,Tin,Tsurf2,RHin,Taircavity,RHaircavity), 4,7 or 9 inputs, if data isn't available: []
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=length(varargin);                                             % determines length of input arguments
if isempty(Tair);                                               % if one channel isn't available, this channel will be replaced by Not-a-Numbers
    Tair=time;
    e=find(time>0);
    Tair(e)=NaN;
end
if isempty(Tsurf);
    Tsurf=time;
    e=find(time>0);
    Tsurf(e)=NaN;
end
if isempty(RHair);
    RHair=time;
    e=find(time>0);
    RHair(e)=NaN;
end
y(:,1)=Tair;                                                    % air temperature [ºC]
y(:,2)=Tsurf;                                                   % surface temperature [ºC]
y(:,3)=RHair;                                                   % relative humidity of the air [% RH]
y(:,10)=time(:,1);                                              % time [days after Christ]
y(:,5)=611*exp(17.08*Tair./(234.18+Tair));                      % maximum vapour pressure at given air temperature [Pa]
f=find(Tair<0);
y(f,5)=611*exp(22.44*Tair(f)./(272.44+Tair(f)));
y(:,6)=611*exp(17.08*Tsurf./(234.18+Tsurf));                    % maximum vapour pressure at given surface temperature [Pa]
g=find(Tsurf<0);
y(g,6)=611*exp(22.44*Tsurf(g)./(272.44+Tsurf(g)));
y(:,7)=0.01*y(:,5).*RHair;                                      % actual vapour pressure [Pa]
y(:,4)=100*y(:,7)./y(:,6);                                      % relative humidity near surface [% RV]
y(:,8)=611*y(:,7)./(101300-y(:,7));                             % specific humidity [g/kg]
y(:,9)=((234.18*log(y(:,7)/611))./(17.08-log(y(:,7)/611)));     % dewpoint [ºC]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extra if inputarguments=3 (Tin,Tsurf2,RHin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if a(1,1)>0;
if varargin{1}==[]
varargin{1}=NaN*time;
end
if varargin{2}==[]
varargin{2}=NaN*time;
end
if varargin{3}==[]
varargin{3}=NaN*time;
end
    if a(1,1)==1;
        disp('>>> number of inputs incorrect !!!')
    elseif a(1,1)==2;
        disp('>>> number of inputs incorrect !!!')
    else
y(:,11)=(varargin{1});                                          % temperature supplied by installation [ºC]
y(:,12)=(varargin{2});                                          % surface temperature 2 [ºC]
y(:,13)=(varargin{3});                                          % relative humidity supplied by installation [% RH]
y(:,15)=611*exp(17.08*y(:,11)./(234.18+y(:,11)));               % maximum vapour pressure at given installation temperature [Pa]
h=find(y(:,11)<0);
y(h,15)=611*exp(22.44*y(h,11)./(272.44+y(h,11)));
y(:,16)=611*exp(17.08*y(:,12)./(234.18+y(:,12)));               % maximum vapour pressure at given surface 2 temperature [Pa]
i=find(y(:,12)<0);
y(i,16)=611*exp(22.44*y(i,12)./(272.44+y(i,12)));
y(:,17)=0.01*y(:,15).*y(:,13);                                  % actual installation vapour pressure [Pa]
y(:,14)=100*y(:,7)./y(:,16);                                    % relative humidity near surface 2 [% RH]
y(:,18)=611*y(:,17)./(101300-y(:,17));                          % installation specific humidity [g/kg]
y(:,19)=((234.18*log(y(:,17)/611))./(17.08-log(y(:,17)/611)));  % dewpoint of the air supplied by the installation [ºC]
y(:,20)=100*y(:,17)./y(:,16);                                   % relative humidity near surface IF psurface=pinstallation
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extra if inputarguments=5 (Tin,Tsurf2,RHin) and (Tgap,RHgap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if a(1,1)>3
if varargin{4}==[]
varargin{4}=NaN*time;
end
if varargin{5}==[]
varargin{5}=NaN*time;
end
    if a(1,1)==4
        disp('>>> number of inputs incorrect !!!')
    else
y(:,21)=(varargin{4});                                          % temperature of the cavity [ºC]
y(:,22)=(varargin{5});                                          % relative humidity of the cavity [% RH]
y(:,23)=611*exp(17.08*y(:,21)./(234.18+y(:,21)));               % maximum vapour pressure of the air in the cavity [Pa]
j=find(y(:,21)<0);
y(j,23)=611*exp(22.44*y(j,21)./(272.44+y(j,21)));
y(:,24)=0.01*y(:,23).*y(:,22);                                  % actual vapour pressure of the air in the cavity [Pa]
y(:,25)=611*y(:,24)./(101300-y(:,24));                          % specific humidity of the air in the cavity [g/kg]
y(:,26)=((234.18*log(y(:,24)/611))./(17.08-log(y(:,24)/611)));  % dewpoint if the air in the cavity [ºC]
end
end