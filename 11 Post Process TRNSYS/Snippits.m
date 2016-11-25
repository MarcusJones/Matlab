%% %%%%%%%%%%% Print  to
% This one is BETTER!
this_dir = 'C:\ExportDir\';
fname = 'temp'
out_path = [this_dir fname]
export_fig(out_path,'-pdf')

%% %%%%%%%%%%%%% Place month labels

PlaceMonthLabels = 275;
PlaceMonthLabels = input('Y axis position for month labels: ')

startYear = datevec(trnTime.time(1));
startYear = startYear(1);

monthMarks = [];
monthLabels = {};
monthLines =[];
for i = 1:13
    monthLines = [monthLines datenum([startYear i 01 0 0 0])];
    monthMarks = [monthMarks datenum([startYear i 15 0 0 0])];
    monthLabels{i} =[datestr([startYear i 1 0 0 0],'mmm')];
end

set(gca,'XTick',monthLines)
%set(gca,'XTickLabel',monthLabels)

% Place the text labels
t = text(monthMarks(1:12),PlaceMonthLabels*ones(1,length(monthMarks(1:12))),monthLabels(1:12));
set(t,'HorizontalAlignment','center','VerticalAlignment','middle');
set(t,'HorizontalAlignment','center','VerticalAlignment','middle');

% Remove the default labels
set(gca,'XTickLabel','')


%% %%%%%%%%%%%%%%Mask ON
trnTime = set_operation_mask(trnTime,1);

%% %%%%%%%%%%%%Apply Export settings
axisLabelFontSize = 20;
axisFontSize = 20;

% Size options
set( gcf                       , ...
    'PaperUnits'   , 'centimeters' );
set( gcf                       , ...
    'PaperPosition'   , [-4.0450490624999995 3.463408020833333 29.690131354166663 20.99195395833333]);
set( gcf                       , ...
    'PaperSize'   , [21.573594999999997 27.91877]);
set( gcf                       , ...
    'PaperType'   ,'A4');
set( gcf                       , ...
    'PaperOrientation'   ,'portrait');
set( gcf                       , ...
    'Name'   ,'TestName');
set( gcf                       , ...
    'Position',[0,0,1123,794;]);

% Hide Title
titleHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'title');
if ~isa(titleHandles,'cell')
    titleHandles = {titleHandles}
end
set(cell2mat(titleHandles),'Visible'   , 'off' );

% Color options
set( gcf                       , ...
    'Color',[1 1 1]);

% Line formatting
set( findobj(gcf,'-depth',2,'Type','line')                    , ...
    'LineWidth'   , 3 );
set( findobj(gcf,'-depth',2,'Type','line')                    , ...
    'LineStyle'   , '-' );

% Axis formatting
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'Box'   , 'off' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'XGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'YGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'ZGrid'   , 'on' );
set( findobj(gcf,'-depth',1,'Type','axes')                    , ...
    'FontSize'   , axisFontSize );
set( findobj(gcf,'type','axes')                      , ...
    'FontName'   , 'Helvetica' );

legend('boxon')

xLabelHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'xlabel');
if ~isa(xLabelHandles,'cell')
    xLabelHandles = {xLabelHandles}
end
set(cell2mat(xLabelHandles),'FontSize'   , axisLabelFontSize );
set(cell2mat(xLabelHandles),'FontName'   , 'Helvetica');

yLabelHandles = get(findobj(gcf,'-depth',1,'Type','axes'),'ylabel');
if ~isa(yLabelHandles,'cell')
    yLabelHandles = {yLabelHandles}
end
set(cell2mat(yLabelHandles),'FontSize'   , axisLabelFontSize );
set(cell2mat(yLabelHandles),'FontName'   , 'Helvetica');

set( findobj('Type','text')                    , ...
    'FontSize'   , 20 );
set( findobj('Type','text')                    , ...
    'FontName'   , 'AvantGarde' );

%%%%%%%%%%%%%% DB Stop ON
dbstop if error

%%%%%%%%%%%%% DB Continue!
dbclear all

%%%%%%%% Beep off
beep off 