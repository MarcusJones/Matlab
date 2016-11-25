function SimpleAverage = SimpleAverage(ToAvg, BreakLevel, Range1, Range2)

Total = 0;
for i = Range1:Range2-1
    if ToAvg(i) >= BreakLevel
        Total = Total + ToAvg(i);
    end
end

SimpleAverage = Total/(Range2 - Range1);


