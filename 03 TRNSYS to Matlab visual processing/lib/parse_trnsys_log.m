function parse_trnsys_log(settings)
    logThis('Checking for execution errors in log file',settings)
    
    fin = fopen(settings.fileIO.trnsysLogFile);
    settings.logFile.cntLines = 0;
    settings.logFile.notConverged = 0;
    settings.logFile.errors = 0;
    while ~feof(fin)
        settings.logFile.cntLines = settings.logFile.cntLines + 1;
        %disp(logFile.cntLines)
        s = fgetl(fin);
        if ~isempty(regexp(s, 'The inputs to the listed units have not converged at this timestep.', 'once' ))
            settings.logFile.notConverged = settings.logFile.notConverged + 1;
        end
        if ~isempty(regexp(s, '*** Fatal Error', 'once' ))
            settings.logFile.errors = settings.logFile.errors +1;
        end
    end
    fclose(fin);
    clear fin s
    
    if settings.logFile.errors
        logThis(sprintf('Fatal error in DCK file'),settings);
        error('Fatal error in DCK file, check list file');
    end
    
    logThis(sprintf('Convergence score: %0.1f%%',100-settings.logFile.notConverged/settings.simControl.numberTimeSteps),settings);
    