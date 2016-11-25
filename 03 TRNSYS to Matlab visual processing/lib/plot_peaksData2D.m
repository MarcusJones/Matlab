%% Integrate the power column for each month, store in a n x 12 array
% The headers will be in one column array

function plot_peaksData2D(bDataPowerAll, trnTime)

[Y, M, D, H, MN, S] = datevec(trnTime.time(2) - trnTime.time(1));
Interval = H + MN/60 + S/3600;

powerMatrix = [];
powerConsumers = {};
powerMonths = {};
% Loop each power point;
for iPwrPoint = 1:length(bDataPowerAll);
    % Loop each month
    powerConsumers{iPwrPoint} = bDataPowerAll{iPwrPoint}.description;
    startDnum = datevec(trnTime.time(1));
    startYear = datevec(trnTime.time(1));
    startYear = startYear(1);
    for iMonth = 2:366
        currStartDnum = datenum(startYear,1,iMonth-1,0,0,0);
        currEndDnum = datenum(startYear,1,iMonth,0,0,0);
        powerMonths{iMonth-1} = datestr(currEndDnum,'mmm');
        %currEndDnum - currStartDnum
        currMask =((trnTime.time>=currStartDnum) & (trnTime.time<=currEndDnum));
        thisTime(iMonth-1) = datenum(startYear,1,iMonth-1,0,0,0);
        powerMatrix(iPwrPoint,iMonth-1) = max(bDataPowerAll{iPwrPoint}.data(currMask));%*Interval;
    end
end
%bar3(powerMatrix,1,'grouped')
figure
plot(thisTime,powerMatrix')
%bar(powerMatrix)
%bar3(powerMatrix,1,'detached')


legend(powerConsumers)
%bar3(powerMatrix,1,'stacked')
%ylabel('Power consumers')
%xlabel('Months')
%zlabel('Energy [kWh]')
%set(gca,'XTickLabel',powerMonths)
%set(gca,'YTickLabelMode','manual')
%set(gca,'YTick',1:length(bDataPowerAll))
%set(gca,'YTickLabel',powerConsumers)
load('cmapMonths')
set(gcf,'Colormap',cmapMonths)
%colormap('jet')
%colormap('autumn')
%mycmap = get(gca,'Colormap');
%cmapMonths = get(gcf,'Colormap')
%TIntegral(i) = sum(data(Range.mask,i))*Interval;

end