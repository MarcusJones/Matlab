function omimport(modelname)  
%
% Read OpenModelica Result File into Workspace
%
% SYNTAX: omimport(modelname)
% z.B. omimport('package.model')
%
% All $dummies, der(*) and data(time)=0 are thrown out
% Feedback/problems: Christian Schaad, Fluidsystemtechnik, TU-Darmstadt, cschaad@gmx.de


[daten datasetindexlaenge]=omlesennachdaten(modelname);

assignin('base','daten',daten);

for i=1:datasetindexlaenge+1;
    if (isempty(strfind(daten(i).name,'$dummy')) & isempty(strfind(daten(i).name,'der(')) & (max(daten(i).data)~=0 | min(daten(i).data)~=0))  % Hier werden die Dummies, die "ders" und die Variablen == 0 rausgeschmissen
        %% Hier werden die Sonderzeichen durch Unterstriche ersetzt, EVTL.
        %%  ZU ERWEITERN !!!
        if (isempty(strfind(daten(i).name,'(')) ~= 1)|(isempty(strfind(daten(i).name,'[')) ~= 1) | (isempty(strfind(daten(i).name,',')) ~= 1)
            daten(i).name(strfind(daten(i).name,'('))='';
            daten(i).name(strfind(daten(i).name,')'))='';
            daten(i).name(strfind(daten(i).name,'['))='';
            daten(i).name(strfind(daten(i).name,']'))='';
            daten(i).name(strfind(daten(i).name,','))='';
        end;
        
        evalin('base',([num2str(daten(i).name),'=daten(',num2str(i),').data;']));
       
    end
     evalin('base',(['daten(',num2str(i),').data=[];'])); % Rohdaten aus Workspace wieder loeschen
    
end
evalin('base',(['clear daten']));



function [daten, datasetindexlaenge] = omlesennachdaten(modelname)
% Faster code...

lf =char(10); 
Resultfile=[modelname,'_res.plt'];
fid = fopen(Resultfile, 'r');


linux=isunix;
stringlaenge=50000000;  % Choose as big as possible to improve speed!!!
offset=0;
datasetindexlaenge=0;
daten.name=[];
while  ~feof(fid)
    
    fseek(fid,-offset-2,0);
   
    I= fread(fid,stringlaenge,'*char')';
    disp([num2str(ftell(fid)/1024/1024),' MB data read']);    % Debug...
 
    j=1;
   
    for i=2:length(I)
        if ((I(i-1)==lf) & (I(i)=='D'));
            datasetindex(j)=i;
            j=j+1;
        end
    end

    datasetindex(end+1)=length(I);


    for i= 1:length(datasetindex)-1
        [temp1,temp2]=strtok(I(datasetindex(i)+9:datasetindex(i+1)-2),lf);

        switch linux
            case 1
                daten(end+1).name=temp1;
            case 0
                daten(end+1).name=temp1(1:end-1);
        end
        c=textscan(temp2,'%f%s%f');
        daten(end).data=c{3};
    end
   
    
    
    offset=datasetindex(end)-datasetindex(end-1);
    datasetindexlaenge=datasetindexlaenge+length(datasetindex)-1;
    clear I datasetindex
end


fclose(fid);
