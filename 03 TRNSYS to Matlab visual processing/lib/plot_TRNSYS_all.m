function plot_TRNSYS_all(trnData,trnTime)

for i = 1:1 %length(trnData.Sol.W) % 
    
    plot_TRNSYS(trnData.Sol.W{i}.name,...
        trnData.Sol.W{i}.header,...
        trnData.Sol.W{i}.units,...
        trnTime.time,...
        trnData.Sol.W{i}.data,...
        trnTime.Range)

end

