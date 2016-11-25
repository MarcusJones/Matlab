function y=reduce(s,ts,te)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reduces matrices in size
% december 16, 2004, TUe, PBE, MM
% sensor=reduce(sensor,starttime,endtime);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=max([0;find(s(:,10)<ts)]);
b=min([length(s(:,10))+1;find(s(:,10)>te)]);
y=s([a+1:b-1],:);