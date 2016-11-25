%daten einlesen
alldata=importdata('Data/ubimet_v5.csv');
startday=datenum(alldata.textdata{3,1},'dd.mm.yyyy HH:MM:SS');
days=startday+(0:364);
%direct horizontal radiation is taken and reformatted to days
dir_hor=alldata.data(:,5);
dir_hor=dir_hor(1:(end-1));
dir_hor=reshape(dir_hor,24,365);
%diffuse radiation
dir_diff=alldata.data(:,4);
dir_diff=dir_diff(1:(end-1));
dir_diff=reshape(dir_diff,24,365);
%sum
dir_all=alldata.data(:,3);
dir_all=dir_all(1:(end-1));
dir_all=reshape(dir_all,24,365);
%means of 0-12 and 12-24 taken
vormittag=mean(dir_hor(1:12,:));
nachmittag=mean(dir_hor(13:24,:));
k=1:365;
% condition is set here
%quotient=vormittag./nachmittag;
indexvormittag=k(vormittag./nachmittag>20);
indexnachmittag=k(nachmittag./vormittag>2);
% plot everything in sets of eight graphs each so the content per graph stays limited
i=0;j=0;
while i<length(indexvormittag)
    i=i+1;j=j+1;
    subplot(8,1,j);
    plot(dir_hor(:,indexvormittag(i)));
    ylim([0 max(dir_hor(:,indexvormittag(i)))]);
    xlim([1 24])
    legend([num2str(indexvormittag(i)),'  ',datestr(days(indexvormittag(i)),'mmm dd.')]);
    if j==8
        j=0;
        figure()
    end
end