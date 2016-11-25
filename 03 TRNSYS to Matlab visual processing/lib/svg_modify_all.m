%% SVG Updating

function svg_modify_all(trnData, trnTime, settings, snapTime)
changeAllTextFile = [settings.fileio.trnsysprojdir 'PROCESS\ChangeAll.txt'];

%% Checkout the templates

snapDateString = datestr(snapTime, 'ddmmm');

waterSideSVGTemplate = 'Y:\08 Analysis\SVG Analysis\Templates\WaterSide_template.svg';
airSideSVGTemplate = 'Y:\08 Analysis\SVG Analysis\Templates\AirSide_template.svg';
waterSideSVG = ['Y:\08 Analysis\SVG Analysis\WaterSide_', snapDateString, '.svg'];
airSideSVG = ['Y:\08 Analysis\SVG Analysis\AirSide_', snapDateString, '.svg'];
copyfile(waterSideSVGTemplate,waterSideSVG)
copyfile(airSideSVGTemplate,airSideSVG)

% Write the change file
write_changeTextFile(trnData, trnTime, settings, snapTime, changeAllTextFile);
disp(' - Wrote the SVG change file');
% Map the change file to both the air and water side diagrams
find_replace_SVG_text2(settings, changeAllTextFile, waterSideSVG, snapTime)
disp(sprintf(' - Created %s', waterSideSVG));
find_replace_SVG_text2(settings, changeAllTextFile, airSideSVG, snapTime)
disp(sprintf(' - Created %s', airSideSVG));