function [success] = omparameter (modelname,name,wert);
% 
% Change parameter in *_init.txt file; Returns linenumber replaced if
% succeeded, -1 if not.
% SYNTAX: [linenumber] = omparameter(modelname,parameter,value)
% Beispiel: omparameter('package.model','stop value',10)
%
% Feedback/problems: Christian Schaad, Fluidsystemtechnik, TU-Darmstadt, cschaad@gmx.de

success=-1;
inputfile=[modelname,'_init.txt'];
outputfile=[modelname,'_init.txt'];

fid=fopen(inputfile);
i=0;
while 1
    i=i+1;
    tline0 = fgetl(fid);
    if ~ischar(tline0), break, end
    tline= [tline0,char(10)];
    if ~isempty(strfind(tline,[' // ',name,char(10)]))
    tline=[num2str(wert),' // ',[name,char(10)]];
    success=i;
    end

    dataset(i).string=tline;
    clear tline tline0;
       
end
fclose(fid);

fid=fopen(outputfile,'w');
for j=1:i-1
fprintf(fid,[dataset(j).string]);
end
fclose(fid);
switch success
    case -1
        error(['Parameter ',parameter,' not found!']);
end; 
disp(['Replaced line number ',num2str(success)]);

