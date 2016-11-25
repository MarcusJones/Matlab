% 1 min. 10 sec. converted into date number
Length = length(rawdata);
m = datenum(0, 0, 0, 0, 1, 0);
n = datenum(0, 0, 0, 0, 1, 5);

for i = 2:Length
    dt(i,1) = rawdata(i,1) - rawdata(i-1,1);
end
IndxNum = find(dt > n);

clear Length m n Status dt IndxNum i