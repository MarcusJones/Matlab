function DaySum = DaySum(Flow, BreakLevel, Search1, Search2)

Total = 0;

for i = Search1:Search2
    Total = Total + Flow(i);
end

DaySum = Total;

