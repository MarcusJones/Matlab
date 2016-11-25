function logThis(logStr,settings)


logFH = fopen(settings.fileIO.runLogFile,'a');
fprintf(logFH, '%s - %s \n',datestr(now),logStr);
fclose(logFH);

disp(sprintf('%s',logStr));

return
