function [balHeader balSum] = get_balSum(balHdr,balAll,searchHdr)

for i = 1:length(balHdr)
    if ~isempty(regexp(balHdr{i}{1},searchHdr,'match'))
        balSum = sum(balAll{i});
        balHeader = balHdr{i}{1};
    end
end