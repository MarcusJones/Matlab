%% function plot_pData_array(time,pStructs)
% M. Jones - 03 Sep 09 - Created function
% Plot a 'pStruct', a properly formed structure with all necessary plot
% information

% Inputs:
% time - A properly formed time structure
% pStruct    - A properly formed plot data structure

% Outputs:
% Plot with units, title, legend

function plot_pData_array(time,pStructs,settings)

figure
hold on

numSubPlots = length(pStructs);

startTitleString = datestr(time.time(1), 'dd-mmm-yyyy HH:MM:SS');
endTitleString = datestr(time.time(end), 'dd-mmm-yyyy HH:MM:SS');

superTitle = [pStructs(1).Title, ', from ', ...
    startTitleString ' to  ' endTitleString];

%settings.simControl.dataRangeStart ' to  ' ...
%settings.simControl.simulationStop];


for nCurrSubPlot = 1:numSubPlots;
    pStruct = pStructs(nCurrSubPlot);
    
    h(nCurrSubPlot) = subplot(numSubPlots,1,nCurrSubPlot);
    
    set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0; 46/255 139/255 87/255],...
        'DefaultAxesLineStyleOrder',{'-','--'});
    
    plot(time.time(time.mask),...
        [...
        pStruct.Data(time.mask,:) ...
        ],'LineWidth',1)
    
    if(nCurrSubPlot == 1)
        title(superTitle);
    end
    
    ylabel(pStruct.yLabel);
    pStruct.Descriptions
    try
        legend(strcat(pStruct.Headers, '_', pStruct.Names, '_',  ...
            ' ', pStruct.Descriptions),'interpreter', 'none')
        % strtrim(pStruct.Units), ...
        % I hid this for now! -MJ
        legend('hide');
        
    catch
        try
            pStruct.Descriptions = pStruct.Names;
            legend(strcat(pStruct.Headers, '_', pStruct.Names, '_',  ...
                ' ', pStruct.Descriptions),'interpreter', 'none')
            disp 'Make sure length of Headers = Names = Units! Descriptions turned off!';
            % strtrim(pStruct.Units), ...
            % I hid this for now! -MJ
            legend('hide');
        catch
            disp 'ERROR HINT: Make sure length of Headers = Names = Units ';
            rethrow (lasterr)
        end
        
        
    end
    
    set(h(nCurrSubPlot),'XGrid','on');
    set(h(nCurrSubPlot),'YGrid','on');
    
end

datetick2;
theTimeVector = time.time(time.mask);
set(gca,'XLim',[theTimeVector(1) theTimeVector(end)]);

%set(gca,'xtick',[],'ytick',[])
%set(h(numSubPlots),'xtickMode', 'auto')

%set(h(2),'xtick',[],'ytick',[])
%set(get(gca,'XLabel'),'Time')
%set(gca,'XLabel','tewt')
%suplabel(superTitle  ,'t')
%legend(strcat(pStruct.Headers, '_', ' ', pStruct.Units),'interpreter', 'none')

%    datetick2