inputFile = 'c:\Main.dck';
fin = fopen(inputFile);
%fout = fopen('output.txt');

%START=0
%STOP=168


while ~feof(fin)
   s = fgetl(fin);
   if regexp(s, 'TimeStep = ')
       disp(s)
   end
   %s = regexprep(s, '118520', '118521');
   %fprintf(fout,'%s',s);
   %disp(s)
         % disp(s)
end

fclose(fin);
%fclose(fout) 
