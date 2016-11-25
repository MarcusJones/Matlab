%xmlread('C:\Documents and Settings\MJones\Desktop\Prog\Matlab\XMLParse\simple.xml');

%xmlread();
clear all;
GBData = xml_load('C:\Documents and Settings\MJones\Desktop\Prog\Matlab\XMLParse\simple2zone.xml')


load 'C:\Documents and Settings\MJones\Desktop\Prog\Matlab\XMLParse\simple2zone.xml';

% Separate the surfaces
for i = 1:size(GBData.Campus,2)
    GBData.Campus(i).Surface
end
  

xml2mat('C:\Documents and Settings\MJones\Desktop\Prog\Matlab\XMLParse\simple2zone.xml')
fid = fopen('C:\Documents and Settings\MJones\Desktop\Prog\Matlab\XMLParse\simple2zone.xml');

fid

%     scalar(GBData.Campus(i).Surface)
% 
% class(x)
% 
% 
% structfun
% 
% out3 = structfun(@(x)x+1,GBData.Campus.Surface)
% 
% Surfaces(2)
