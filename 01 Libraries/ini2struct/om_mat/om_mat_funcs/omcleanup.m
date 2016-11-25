function omcleanup (modelname) 
%
% Clean up all the compilation stuff
%
% Feedback/problems: Christian Schaad, Fluidsystemtechnik, TU-Darmstadt, cschaad@gmx.de
linux=isunix;

switch linux
    case 1
        cur=pwd;
        cd ('~/OpenModelica/work')
end


delete simo.mos;
delete([modelname,'.makefile']);
delete([modelname,'.log']);
delete([modelname,'.libs']);
delete([modelname,'_functions.cpp']);
delete([modelname,'.cpp']);

switch linux
    case 1
   delete([modelname,'_res.plt']); 
   delete([modelname,'.exe']);
   delete(modelname);
   delete([modelname,'_init.txt']);
        cd (cur)
end