function [ s r ] = find_replace_SVG_text(settings, svgFile, XPathString, newText)
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

perlFile = [settings.currFilePath 'lib\change_element_text.pl'];

%perlCmd = [perlFile, svgFile, XPathString, newText];

perl(perlFile, svgFile, XPathString, newText);

% 
% % SLOW
% [s r] = dos(perlCmd);
% 
% if ((s) || exist(r,'var'))
%     error('Problem with change_element_text.pl')
% end