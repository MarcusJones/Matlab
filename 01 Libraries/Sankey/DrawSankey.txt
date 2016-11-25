function drawSankey(input, losses, unit, labels)

if sum(losses) >= input
    
    error('losses exceed input, unable to draw diagram');
    
else
   
    figure('color','white', ...
           'Position', [10 200 1260 720]);
    axis off;
   
    inputLabel = sprintf('%.1f [%s]\n%s', input, unit,labels{1});
    text(-0.05, 0.5, inputLabel, 'FontSize', 16,'HorizontalAlignment','right');
    
    frLosses = losses/input;
    
    line([0.4 0 0.05 0 0.4], [0 0 0.5 1 1], 'Color', 'black', 'LineWidth', 2.5);
    
    limTop = 1; posLen = 0.4;
    
    for i = 1 : length(losses)
       
        rI = max(0.07, frLosses(i)/2);
        rE = rI + frLosses(i);
        
        arcIx = posLen + rI * sin(linspace(0,pi/2));
        arcIy = limTop + rI * (1 - cos(linspace(0,pi/2)));
        
        arcEx = posLen + rE * sin(linspace(0,pi/2));
        arcEy = limTop + rI - rE*cos(linspace(0,pi/2));
        
        line(arcIx, arcIy, 'Color', 'black', 'LineWidth', 2.5);
        line(arcEx, arcEy, 'Color', 'black', 'LineWidth', 2.5);
        
        arEdge = max(0.015, rI/3);
        arTop = max(0.04, 0.8*frLosses(i));
        
        arX = posLen + rI + [0 -arEdge frLosses(i)/2 frLosses(i)+ arEdge frLosses(i)];
        arY = limTop + rI + [0 0 arTop 0 0];
        
        line(arX, arY, 'Color', 'black', 'LineWidth', 2.5);
        
        txtX = posLen + rI + frLosses(i)/2;
        txtY = limTop + rI + arTop + 0.05;
        
        if frLosses(i) > 0.1
            fullLabel = sprintf('%s\n%.1f [%%]',labels{i+1}, 100*frLosses(i));
            fontsize = 10 + ceil((frLosses(i)-0.1)/0.05);
        else
            fullLabel = sprintf('%s: %.1f [%%]',labels{i+1}, 100*frLosses(i));
            fontsize = 10;
        end
        
        text(txtX, txtY, fullLabel, 'Rotation', 50, 'FontSize', fontsize, 'FontWeight', 'bold', 'VerticalAlignment', 'middle');
        
        limTop = limTop - frLosses(i);
        
        newPos = posLen + rE + 0.01;
        
        line([posLen newPos], [limTop limTop], 'Color', 'black', 'LineWidth', 2.5);
        line([posLen newPos], [0 0], 'Color', 'black', 'LineWidth', 2.5);
        
        posLen = newPos;
        
    end
    
    newPos = posLen + max(0.05*limTop, 0.05);
    
    line([posLen, newPos],[limTop limTop], 'Color', 'black', 'LineWidth', 2.5);
    line([posLen, newPos],[0 0], 'Color', 'black', 'LineWidth', 2.5);
    
    line([newPos newPos newPos+0.8*limTop newPos newPos], [0, -0.035, limTop/2, limTop+0.035, limTop], 'Color', 'black', 'LineWidth', 2.5);
    
    posLen = newPos + 0.8*limTop;
    
    endText = sprintf('%.1f [%s]\n%s\n%.1f [%%]', input-sum(losses), unit,labels{length(losses)+2},100*(1-sum(frLosses)));
    fontsize = 10 + ceil((1-sum(frLosses)-0.1)/0.05);
    
    text(posLen + 0.05, limTop/2, endText, 'FontSize', fontsize);
    
    axis([-0.2, posLen+0.2, -0.2, 1+frLosses(1)+0.2]);
    axis equal 
    
end

end