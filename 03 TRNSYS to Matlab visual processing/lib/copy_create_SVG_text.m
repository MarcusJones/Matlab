function copy_create_SVG_text(settings,svgFile,searchTextID,newTextID)
%COPY_CREATE_SVG_TEXT Summary of this function goes here
%   Detailed explanation goes here

perlFile = [settings.currFilePath, 'lib\create_new_SVG_Text.pl'];

perl(perlFile, svgFile, searchTextID, newTextID);
