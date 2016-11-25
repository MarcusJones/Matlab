%% SVG Updating

function svg_modify_CustomForReport(trnData, trnTime, settings, snapTime)
changeAllTextFile = [settings.fileio.trnsysprojdir 'PROCESS\ChangeAll.txt'];

%% Checkout the templates

snapDateString = datestr(snapTime, 'ddmmm');

% waterSideSVGTemplate = 'Y:\08 Analysis\SVG Analysis\Templates\WaterSide_template.svg';
% airSideSVGTemplate = 'Y:\08 Analysis\SVG Analysis\Templates\AirSide_template.svg';
% waterSideSVG = ['Y:\08 Analysis\SVG Analysis\WaterSide_', snapDateString, '.svg'];
% airSideSVG = ['Y:\08 Analysis\SVG Analysis\AirSide_', snapDateString, '.svg'];
% copyfile(waterSideSVGTemplate,waterSideSVG)
% copyfile(airSideSVGTemplate,airSideSVG)

% Write the change file
write_changeTextFile(trnData, trnTime, settings, snapTime, changeAllTextFile);
disp(' - Wrote the SVG change file');
% Map the change file to both the air and water side diagrams
svgDIR = 'Y:\04 Reports\20100331 EA1 Scientific\Primitives\NewSVG\';

find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_ConvChill.svg'     ] , snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_CoolingTower.svg'   ], snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_ExhibitionAHU.svg'  ], snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_OfficeAHU.svg'      ], snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_SHX.svg'            ], snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_Sanitation.svg'     ], snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_SolarCool.svg'      ], snapTime)
find_replace_SVG_text2(settings, changeAllTextFile, [svgDIR 'Scheme_Summer_Theatre.svg'        ], snapTime)