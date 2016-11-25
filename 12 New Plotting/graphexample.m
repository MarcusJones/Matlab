%%
cd 'C:\Projects\AllScripts\L Matlab\12 New Plotting'
load data

%%
figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);
hold on;

hFit   = line(xfit  , yfit   );
hE     = errorbar(xdata_m, ydata_m, ydata_s);
hData  = line(xVdata, yVdata );
hModel = line(xmodel, ymodel );
hCI(1) = line(xmodel, ymodelL);
hCI(2) = line(xmodel, ymodelU);

%%
set(hFit                          , ...
  'Color'           , [0 0 .5]    );
set(hE                            , ...
  'LineStyle'       , 'none'      , ...
  'Marker'          , '.'         , ...
  'Color'           , [.3 .3 .3]  );
set(hData                         , ...
  'LineStyle'       , 'none'      , ...
  'Marker'          , '.'         );
set(hModel                        , ...
  'LineStyle'       , '--'        , ...
  'Color'           , 'r'         );
set(hCI(1)                        , ...
  'LineStyle'       , '-.'        , ...
  'Color'           , [0 .5 0]    );
set(hCI(2)                        , ...
  'LineStyle'       , '-.'        , ...
  'Color'           , [0 .5 0]    );



%%
set(hFit                          , ...
  'LineWidth'       , 2           );
set(hE                            , ...
  'LineWidth'       , 1           , ...
  'Marker'          , 'o'         , ...
  'MarkerSize'      , 6           , ...
  'MarkerEdgeColor' , [.2 .2 .2]  , ...
  'MarkerFaceColor' , [.7 .7 .7]  );
set(hData                         , ...
  'Marker'          , 'o'         , ...
  'MarkerSize'      , 5           , ...
  'MarkerEdgeColor' , 'none'      , ...
  'MarkerFaceColor' , [.75 .75 1] );
set(hModel                        , ...
  'LineWidth'       , 1.5         );
set(hCI(1)                        , ...
  'LineWidth'       , 1.5         );
set(hCI(2)                        , ...
  'LineWidth'       , 1.5         );

% adjust error bar width
hE_c                   = ...
    get(hE     , 'Children'    );
errorbarXData          = ...
    get(hE_c(2), 'XData'       );
errorbarXData(4:9:end) = ...
    errorbarXData(1:9:end) - 0.2;
errorbarXData(7:9:end) = ....
    errorbarXData(1:9:end) - 0.2;
errorbarXData(5:9:end) = ...
    errorbarXData(1:9:end) + 0.2;
errorbarXData(8:9:end) = ...
    errorbarXData(1:9:end) + 0.2;
set(hE_c(2), 'XData', errorbarXData);




%%

hTitle  = title ('My Publication-Quality Graphics');
hXLabel = xlabel('Length (m)'                     );
hYLabel = ylabel('Mass (kg)'                      );

hText   = text(10, 800, ...
  sprintf('\\it{C = %0.1g \\pm %0.1g (CI)}', ...
  c, cint(2)-c));

hLegend = legend( ...
  [hE, hFit, hData, hModel, hCI(1)], ...
  'Data (\mu \pm \sigma)' , ...
  'Fit (\it{C x^3})'      , ...
  'Validation Data'       , ...
  'Model (\it{C x^3})'    , ...
  '95% CI'                , ...
  'location', 'NorthWest' );

%%
set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hTitle, hXLabel, hYLabel, hText], ...
    'FontName'   , 'AvantGarde');
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel, hText]  , ...
    'FontSize'   , 10          );
set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'YTick'       , 0:500:2500, ...
  'LineWidth'   , 1         );

%%
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 finalPlot1.eps
close;


%%

fixPSlinestyle('finalPlot1.eps', 'finalPlot2.eps');