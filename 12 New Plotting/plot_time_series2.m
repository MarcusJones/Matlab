function plot_time_series2(frame,p_def)

%% Get data and time masks
[nrows, ncols] = size(frame.data);

if isfield(p_def,'dmask')
    dmask = p_def.dmask;
else
    dmask = true(1,ncols);
end

if isfield(p_def,'tmask')
    tmask = p_def.tmask;
else
    tmask = true(nrows,1);
end


%% Plot
figure;
handle = axes;
plot(handle,frame.time(tmask),frame.data(tmask,dmask));

if ~isfield(p_def,'no_datetime')
    datetick2
end

% Set limits
time_masked = frame.time(tmask);
set(handle,'XLim',[time_masked(1) time_masked(end)]);


%% Labels
if isfield(p_def,'xlab')
    xlabel(handle,p_def.xlab)
end
if isfield(p_def,'ylab')
    ylabel(handle,p_def.ylab)
end
if isfield(p_def,'title')
    title(handle,p_def.title)
end

%% Get legend
if isfield(p_def,'legend')
    % There is a legend already
    this_leg = p_def.legend;
elseif isfield(p_def,'legend_def')
    % User specifies exactly which headers to use (integer array)
    legend_def = p_def.legend_def;
    this_leg = func_get_labels2(frame,dmask,legend_def);
else
    % Take all headers
    nheads = size(frame.headerDef,1);
    legend_def = 1:nheads;
    this_leg = func_get_labels2(frame,dmask,legend_def);    
end

if isfield(p_def,'legPos')
    leg_loc = p_def.legPos;
else
    leg_loc = 'NorthEast';
end

legend(handle,this_leg,'interpreter', 'none','Location',leg_loc);

if isfield(p_def,'tools')
    if p_def.tools
        plottools('on');
    end
end

%plottools(handle,'on','figurepalette')
%plottools(handle,'plotbrowser')
%plottools(handle,'propertyeditor')


    

    

    



if 0
    theTimeVector = timeStruct.time(timeMask);
    
    if isfield(p_def,'legend')
        p_def.legend = p_def.legend;
    else
        plotDef.legend = func_get_labels(frame,dataMask,legendDefinition);
    end
    
    
    %thisLegend = func_get_labels(dataFrame,dataMask,legendDefinition);
    %legend(thisLegend,'interpreter', 'none')
    
    %%
    
    func_annotate(handle, p_def);
    
    datetick2
    set(gca,'XLim',[theTimeVector(1) theTimeVector(end)]);
    
    if isfield(p_def,'legend')
        if isfield(plop_deftDef,'legPos') && ~isempty(p_def.legPos)
            legLocation = p_def.legPos;
        else
            legLocation = 'NorthEast';
        end
        legend(handle,p_def.legend,'interpreter', 'none','Location',legLocation);
    else
    end
    
    
    %get(gcf,'Children')
    %num = findall(gcf,'type','axes');
    %get(gca)
    %datetick2
end
%%

