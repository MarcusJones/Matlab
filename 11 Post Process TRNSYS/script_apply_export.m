% Define axis label sizes and final printed figure size
axisLabelFontSize = 14;
axisFontSize = 14;

% A6;
figWidth = 14.8;
figHeight = 10.5;

% A4;
figWidth = 29.7;
figHeight = 21.0;

% A4 SCALED 80%;
figWidth = 29.7 * .8 ;
figHeight = 21.0 * .8;

% Set units, get screen size
set(gcf, 'Units','centimeters');
screenSize = get(0,'ScreenSize');

set(gcf, 'PaperType','A4');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperOrientation', 'landscape');
%bottomTrim = 1;
%sideTrim = 1
%set(gcf, 'PaperPosition', []);
 
% Centre & size the figure
% set(gcf, 'Position', ...
%  [screenSize(3)/2-figWidth/2, screenSize(4)/2-figHeight/2, ...
%  figWidth, figHeight] );
set(gcf, 'Position', ...
 [0, 0, ...
 figWidth, figHeight] );
get(gcf, 'Position')

% Hide Title
titleHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'title');
if iscell(titleHandles)
    titleHandles = cell2mat(titleHandles)
end;
set(titleHandles,'Visible', 'off' );
 
% Format x-axis label
xLabelHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'xlabel');
if iscell(xLabelHandles)
    xLabelHandles = cell2mat(xLabelHandles);
end
set(xLabelHandles,'FontSize', axisLabelFontSize );
set(xLabelHandles,'FontName', 'Helvetica');
 
% Format y-axis label
yLabelHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'ylabel');
if iscell(yLabelHandles)
    yLabelHandles = cell2mat(yLabelHandles)
end;
set(yLabelHandles,'FontSize', axisLabelFontSize );
set(yLabelHandles,'FontName', 'Helvetica');

% Format axis tick labels
set( findobj(gcf,'-depth',1,'Type','axes'), 'FontSize', axisFontSize);
set( findobj(gcf,'type','axes'), 'FontName', 'Helvetica');

% Color options
set(gcf, 'Color',[1 1 1]);
 
% Line formatting
set( findobj(gcf,'-depth',2,'Type','line'), 'LineWidth'   , 2 );
set( findobj(gcf,'-depth',2,'Type','line'), 'LineStyle'   , '-' );
 
% Axis formatting
set( findobj(gcf,'-depth',1,'Type','axes'), 'Box', 'off' );
set( findobj(gcf,'-depth',1,'Type','axes'), 'XGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes'), 'YGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes'), 'ZGrid'   , 'on' );


%print