function [time,header]=ADPParseExcelTexts(Excelstuff)
%seperate the header
header=Excelstuff(1:10,2:end);
%seperate the time - as Excel does not save time at midnight, one in 1440
%lines produces an error which then is treated seperately
timetxt=Excelstuff(11:end,1);
time=double(size(timetxt))';
for i=1:length(timetxt)
    try
        time(i)=datenum(timetxt{i},'dd.mm.yyyy HH:MM:SS');
    catch
        time(i)=datenum(timetxt{i},'dd.mm.yyyy');
    end
end