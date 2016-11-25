function update_dck_execute(settings)
    logThis(sprintf('Executing %s',settings.fileIO.trnsysRunFile),settings);
    
    %%% Change the weather file %%%
    if settings.processControl.flagChangeWeather
        replaceinfile('defaultWeather.met',settings.fileIO.weatherFile,settings.fileIO.trnsysRunFile,'-nobak');
    end
    
    %%% Time and print step %%%
    if settings.processControl.flagUpdateTimeAndPrint
        % Update the TimeStep equation line
        searchChangeTextLine(settings.fileIO.trnsysRunFile,...
            'TimeStep = ', ...
            sprintf('TimeStep = %s',settings.simControl.timeStepStr),...
            settings);
        
        % Update the printInterval equation line
        searchChangeTextLine(settings.fileIO.trnsysRunFile,...
            'printInterval = ', ...
            sprintf('printInterval = %s',settings.simControl.printIntervalStr),...
            settings);
        
        % Replace all STEP within all printers to reflect the printInerval
        replaceinfile('STEP		! 1 Printing interval','printInterval',settings.fileIO.trnsysRunFile,'-nobak');
    end
    
    %%% START & STOP %%%
    if settings.processControl.flagUpdateStartStop
        % Update the start time
        searchChangeTextLine(settings.fileIO.trnsysRunFile,...
            'START=',...
            sprintf('START=%i',settings.simControl.simulationStartHour),...
            settings);
        
        % Update the stop time
        searchChangeTextLine(settings.fileIO.trnsysRunFile,...
            'STOP=',...
            sprintf('STOP=%i',settings.simControl.simulationStopHour),...
            settings);
    end
    
    % Delete the OUT files
    delete(settings.fileIO.searchMask);
    
    tStartTRNSYS=tic;
    trnExe = [settings.fileIO.trnsysRunProg, ' ', ...
        '"' settings.fileIO.trnsysRunFile, '"', ' /n'];
    % /n switch removes end dialog
    dos(trnExe); % EXECUTE SIMULATION
    clear trnExe
    tElapsedTRNSYS=toc(tStartTRNSYS)/60;
    
    logThis(sprintf('Finished, %.1fm elapsed for execution',tElapsedTRNSYS),settings);
    