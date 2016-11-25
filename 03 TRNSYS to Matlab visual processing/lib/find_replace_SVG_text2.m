function find_replace_SVG_text2(settings, changeFile, svgFile, snapTime)
%FIND_REPLACE_SVG_TEXT Summary of this function goes here
%   Detailed explanation goes here

% %% SVG Modification
% % Use perl (perlFile) to access the XML tree of svgFile
% % Do a simple find and replace on the 'tspan' element with and 'ID' of

% # Inputs:
% # 1 - the SVG file to modify
% # 2 - the XPath Statement (what to search for)
% # 3 - What to change the text into!
%
% #Outputs:
% # A temporary file which is deleted
% # A modified SVG with updated text 'searchTSpanID'
% UPDATE THIS DESCRIPTION!!!!!!!!!!!

perlFile = [settings.currFilePath 'lib\change_element_text_ALL.pl'];

perl(perlFile, changeFile, svgFile);

% Now finally update the current date! 

snapDateStringSVG = datestr(snapTime, 'mmmm dd HH:MM AM');
replaceinfile('CURRENTDATE',snapDateStringSVG,svgFile,'-nobak');