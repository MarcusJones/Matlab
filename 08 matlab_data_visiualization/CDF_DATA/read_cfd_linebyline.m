datenfile=fopen('fall-sept-mit-suedeinlass-outflow-komega-irrad-test2gad_4760-Auswertung221106-temperatur.prof');
werte=zeros(1000000,1);
tic
i=0;
while 1
    tline = fgetl(datenfile);
    if ~ischar(tline),   break,   end
    i=i+1;
    if numel(regexp(tline,'[()]'))==0
       werte(i)=str2double(tline);
    end
    
end
toc
fclose(datenfile);