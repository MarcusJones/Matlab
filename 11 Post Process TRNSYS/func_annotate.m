function annotate(axesHandle, plotDef)

figHandle = get(axesHandle,'parent');
set(figHandle, 'Color',[1 1 1]);

% Define axis label sizes and final printed figure size

axisLabelFontSize = 14;
axisFontSize = 14;


if isfield(plotDef,'size')
    if strcmp(plotDef.size,'A6')
        % A6;
        figWidth = 14.8;
        figHeight = 10.5;
    elseif strcmp(plotDef.size,'A4')
        % A4;
        figWidth = 29.7;
        figHeight = 21.0;        
    elseif strcmp(plotDef.size,'A4_80')
        % A4 SCALED 80%;
        figWidth = 29.7 * .8 ;
        figHeight = 21.0 * .8;
    else
        % A4;
        figWidth = 29.7;
        figHeight = 21.0;
    end
else
    % A4;
    figWidth = 29.7;
    figHeight = 21.0;
end

if isfield(plotDef,'visi')
    set(figHandle, 'Visible',plotDef.visi);
else
end

%% Positioning and sizing
if 0
    % Set units, get screen size
    set(figHandle, 'Units','centimeters');
    screenSize = get(0,'ScreenSize');
    
    set(figHandle, 'PaperType','A4');
    set(figHandle, 'PaperUnits', 'centimeters');
    set(figHandle, 'PaperOrientation', 'landscape');
    
    set(figHandle, 'PaperPosition', ...
        [0, 0, ...
        figWidth, figHeight] );
    
    % set(gcf, 'Position', ...
    %  [screenSize(3)/2-figWidth/2, screenSize(4)/2-figHeight/2, ...
    %  figWidth, figHeight] );
    set(gcf, 'Position', ...
        [0, 0, ...
        figWidth, figHeight] );
end
set(figHandle, 'Units', 'centimeters');

set(gcf, 'Position', ...
    [0, 0, ...
    figWidth, figHeight] );
%bottomTrim = 1;
%sideTrim = 1
%set(gcf, 'PaperPosition', []);

% Centre & size the figure



% test1 = get(figHandle, 'PaperPositionMode')
% set(figHandle, 'PaperPositionMode', ...
%     'auto' );
% test1 = get(figHandle, 'PaperPositionMode')

%% Annotatations
if isfield(plotDef,'yLabel')
    set(get(axesHandle,'YLabel'),'String',plotDef.yLabel);
else
end

if isfield(plotDef,'xLabel')
    set(get(axesHandle,'XLabel'),'String',plotDef.xLabel);
else
    
end


if isfield(plotDef,'title')
    set(get(axesHandle,'title'),'String',plotDef.title);
else
end


% LEGEND TURNED OFF - BREAKS DATETICK
if isfield(plotDef,'legend') && 0
    if isfield(plotDef,'legPos') && ~isempty(plotDef.legPos)
        legLocation = plotDef.legPos;
    else
        legLocation = 'NorthEast';
    end
    legend(axesHandle,plotDef.legend,'interpreter', 'none','Location',legLocation);
else
end

% Format title
titleHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'title');
if iscell(titleHandles)
    titleHandles = cell2mat(titleHandles);
end;
set(titleHandles,'FontSize', axisLabelFontSize );
set(titleHandles,'FontName', 'Helvetica');


% Hide Title
titleHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'title');
if iscell(titleHandles)
    titleHandles = cell2mat(titleHandles);
end;
%set(titleHandles,'Visible', 'off' );

% Format x-axis label
xLabelHandles = get(findobj(axesHandle,'-depth',1,'Type','axes'),'xlabel');
if iscell(xLabelHandles)
    xLabelHandles = cell2mat(xLabelHandles);
end
set(xLabelHandles,'FontSize', axisLabelFontSize );
set(xLabelHandles,'FontName', 'Helvetica');

% Format y-axis label
yLabelHandles = get(findobj(axesHandle,'-depth',1,'Type','axes'),'ylabel');
if iscell(yLabelHandles)
    yLabelHandles = cell2mat(yLabelHandles);
end;
set(yLabelHandles,'FontSize', axisLabelFontSize );
set(yLabelHandles,'FontName', 'Helvetica');

% Format axis tick labels
set( findobj(axesHandle,'-depth',1,'Type','axes'), 'FontSize', axisFontSize);
set( findobj(axesHandle,'type','axes'), 'FontName', 'Helvetica');

%% Colors
% Color options
set(axesHandle, 'Color',[1 1 1]);

%% Lines
% Line formatting
set( findobj(axesHandle,'-depth',2,'Type','line'), 'LineWidth'   , 2 );
set( findobj(axesHandle,'-depth',2,'Type','line'), 'LineStyle'   , '-' );

%% Grids
% Axis formatting
set( findobj(axesHandle,'-depth',1,'Type','axes'), 'Box', 'off' );
set( findobj(axesHandle,'-depth',1,'Type','axes'), 'XGrid'   , 'on' );
set( findobj(axesHandle,'-depth',1,'Type','axes'), 'YGrid'   , 'on' );
set( findobj(axesHandle,'-depth',1,'Type','axes'), 'ZGrid'   , 'on' );

%print


