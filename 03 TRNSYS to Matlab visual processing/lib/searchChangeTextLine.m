function searchChangeTextLine(textFile,searchText,newLine,settings)
    
    perlFile = [settings.currFilePath 'lib\find_change_text_line.pl'];

    perl(perlFile,settings.fileIO.trnsysRunFile,searchText,newLine);

return
