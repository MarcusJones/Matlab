function y=expand(s,ts,te)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expands matrices in size
% february 10, 2005, TUe, PBE, MM
% sensor=expand(sensor,starttime,endtime);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
last=[];
first=[];
len=length(s(1,:));
startdate=datevec(s(1,10));
enddate=datevec(s(length(s(:,10)),10));
daypoints=max(find(s(:,10)<=datenum(startdate(1),startdate(2),startdate(3)+1,startdate(4),startdate(5),startdate(6))))-1;
hourpoints=round(daypoints/24);
if s(1,10)>ts
wsdate=datevec(ts);
yb=startdate(1)-wsdate(1);
mb=startdate(2)-wsdate(2);
db=max(startdate(3))-max(wsdate(3));
hb=startdate(4)-wsdate(4);
bp=hourpoints*(24*12*31*yb+24*31*mb+24*db+hb);
for i=1:len
    for j=1:bp
before(j,i)=NaN;
end
end
bl=length(before(:,10));
for bb=[1:bl]
before(bb,10)=datenum(startdate(1),startdate(2),startdate(3),startdate(4)-(bl-bb)/hourpoints,startdate(5),startdate(6));
end
before2=max(find(before(:,10)<ts));
first=before(before2+1:bl,:);
end
if s(length(s(:,10)),10)<te
wedate=datevec(te);
ya=wedate(1)-enddate(1);
ma=wedate(2)-enddate(2);
da=wedate(3)-enddate(3);
ha=wedate(4)-enddate(4);
ap=hourpoints*(ya*12*31*24+ma*24*31+da*24+ha)
for i=1:len
    for j=1:ap
after(j,i)=NaN;
end
end
al=length(after(:,10));
for ab=[1:al]
after(ab,10)=datenum(enddate(1),enddate(2),enddate(3),enddate(4)+ab/hourpoints,enddate(5),enddate(6));
end
after2=min(find(after(:,10)>te));
last=after(1:after2,:);
end
if first~=[] & last~=[]
y([1:length(first(:,1))],[1:len])=first;
y([length(first(:,1))+1:length(first(:,1))+length(s(:,10))],[1:len])=s;
y([length(first(:,1))+length(s(:,10)):length(first(:,1))+length(s(:,10))+length(last(:,1))-1],[1:len])=last;
elseif first~=[]
y([1:length(first(:,1))],[1:len])=first;
y([length(first(:,1))+1:length(first(:,1))+length(s(:,10))],[1:len])=s;
elseif last~=[]
y([a+1:b-1],[1:len])=s([a+1:b-1],[1:len]);
y([b:b+length(last(:,1))-1],[1:len])=last;
else y=s;
end