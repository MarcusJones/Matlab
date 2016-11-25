% script reads the result of a CFD simulation file;
% coordinate system for measurement and CFD are different, with
% measurements corresponding to standard MATLAB
% Measurements  CFD
%       x       z+19.85
%       y       x
%       z       y
datenfile=fopen('fall-sept-mit-suedeinlass-outflow-komega-irrad-test2gad_4760-Auswertung221106-temperatur.prof');
alles=textscan(datenfile,'%s');
fclose(datenfile);
alles=alles{1};
for i=1:length(alles)
      alles{i}=str2double(alles{i});
end
alles=cell2mat(alles);
alles(isnan(alles))=[];
alles=reshape(alles,length(alles)/4,4);
zwischen=alles;
alles(:,1)=zwischen(:,3)+19.85;
alles(:,2)=zwischen(:,1);
alles(:,3)=zwischen(:,2);
clear zwischen
lower=alles(1:100:end,:);
upper=alles(1:10:end,:);
[xgrid ygrid zgrid]=meshgrid((-0.5:0.1:19.5),(-0.5:0.5:13.5),(0.3:0.1:0.7));
m1=griddata3(upper(:,1),upper(:,2),upper(:,3),upper(:,4),xgrid,ygrid,zgrid,'nearest');
m2=griddata3(upper(:,1),upper(:,2),upper(:,3),upper(:,4),xgrid,ygrid,zgrid);
n1=griddata3(lower(:,1),lower(:,2),lower(:,3),lower(:,4),xgrid,ygrid,zgrid,'nearest');
n2=griddata3(lower(:,1),lower(:,2),lower(:,3),lower(:,4),xgrid,ygrid,zgrid);
figure()
hold on
for i=1:5
    surf(m1(:,:,i)-n1(:,:,i))
end
