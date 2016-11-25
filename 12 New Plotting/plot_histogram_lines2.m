function plot_histogram_lines(df,p_def,bin_vec)

%% Get data and time masks
[nrows, ncols] = size(df.data);

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
%[freqCount,binLocs] = hist(dataFrame.data(tmask,dmask),binEdges);
figure;
handle = axes;
[freqCount,binLocs] = hist(df.data(tmask,dmask),bin_vec);
plot(handle,binLocs, freqCount);

%% Annotate

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
    this_leg = func_get_labels2(df,dmask,legend_def);
else
    % Take all headers
    nheads = size(df.headerDef,1);
    legend_def = 1:nheads;
    this_leg = func_get_labels2(df,dmask,legend_def);    
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

limits = get(gca,'YLim');
minY = limits(1);
maxY = limits(2);

selected_area = (binLocs > 20 & binLocs < 24) * maxY
hold on
thisHand = area(handle,binLocs,selected_area)
set(thisHand,'BaseValue',minY);


set(thisHand,'FaceColor',[1 1 0.6863]);
set(thisHand,'lineStyle','none');

% Highlight moved under lines
uistack(thisHand,'bottom');

% Axes grid on top
set(gca, 'Layer','top');


