tic
datenfile=fopen('test.ip');
daten=textscan(datenfile,'%f','Headerlines',5);
fclose(datenfile);
numbers=cell2mat(daten);
clear daten;
numbers=reshape(numbers,length(numbers)/4,4);
zwischen=numbers;
numbers(:,1)=zwischen(:,3)+19.85;
numbers(:,2)=zwischen(:,1);
numbers(:,3)=zwischen(:,2);
numbers(:,4)=zwischen(:,4)-273.15;
clear zwischen;
toc
tic
[xgrid ygrid zgrid]=meshgrid((-0.5:0.05:19.5),(-0.5:0.05:13.5),0.5);
lower=numbers(1:100:end,:);
n1=griddata3(lower(:,1),lower(:,2),lower(:,3),lower(:,4),xgrid,ygrid,zgrid);
toc
bild=surf(xgrid,ygrid,zgrid,n1);
set(bild,'Edgecolor','none');