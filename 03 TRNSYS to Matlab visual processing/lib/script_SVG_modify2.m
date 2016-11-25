%% SVG Updating
% % This can take 20 minutes!!!!!!!
% % snapTime = datenum(2000, 00, 02, 12, 00, 0);
% % svgFile = ['Y:\08 Analysis\SVG Analysis\All_SystemsCondition1.svg']
% % Scr_SVG_change_all

% Checkout a template
waterSideSVGTemplate = 'Y:\08 Analysis\SVG Analysis\Templates\WaterSide_template.svg';
airSideSVGTemplate = 'Y:\08 Analysis\SVG Analysis\Templates\AirSide_template.svg';

% TIME ONE
snapTime = datenum(2000, 01, 15, 12, 00, 0);
snapDateString = datestr(snapTime, 'ddmmm');
waterSideSVG = ['Y:\08 Analysis\SVG Analysis\WaterSide_', snapDateString, '.svg'];
airSideSVG = ['Y:\08 Analysis\SVG Analysis\AirSide_', snapDateString, '.svg'];
copyfile(waterSideSVGTemplate,waterSideSVG)
copyfile(airSideSVGTemplate,airSideSVG)

svgFile = waterSideSVG;
snapTime = datenum(2000, 01, 01, 12, 00, 0);
write_changeTextFile(trnData, trnTime, settings, snapTime)

svgFile = airSideSVG;
Scr_SVG_change_all_TEXTALL

snapDateStringSVG = datestr(snapTime, 'mmmm dd HH:MM AM');
find_replace_SVG_text(settings, svgFile, 'tspan[@id=''StateDateTime'']', snapDateStringSVG);


% TIME TWO
snapTime = datenum(2000, 06, 15, 12, 00, 0);
snapDateString = datestr(snapTime, 'ddmmm');
waterSideSVG = ['Y:\08 Analysis\SVG Analysis\WaterSide_', snapDateString, '.svg'];
airSideSVG = ['Y:\08 Analysis\SVG Analysis\AirSide_', snapDateString, '.svg'];
copyfile(waterSideSVGTemplate,waterSideSVG)
copyfile(airSideSVGTemplate,airSideSVG)

svgFile = waterSideSVG;
Scr_SVG_change_all

svgFile = airSideSVG;
Scr_SVG_change_all


%% TIME TEMP
% snapTime = datenum(2000, 06, 3, 12, 00, 0);
% snapDateString = datestr(snapTime, 'ddmmm');
% airSideSVG = ['Y:\08 Analysis\SVG Analysis\AirSide_', snapDateString, '.svg'];
% copyfile(airSideSVGTemplate,airSideSVG)
% 
% svgFile = airSideSVG;
% Scr_SVG_change_all


%% SVG Detection

%svgFile = [settings.fileio.trnsysprojdir, 'HVAC\CTCC.svg'];

%SVG_element_exists(settings,svgFile,'tspan')