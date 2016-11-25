function bData = get_bar_data(trnData,systemNames,stateName,number)
trnSystems = fieldnames(trnData);

bData = [];
for iCurrSys = 1:length(systemNames)
    currSysName = systemNames{iCurrSys};
    for iTrnsystem = 1:length(trnSystems)
        currSys = trnSystems{iTrnsystem};
%        disp([currSysName, '=' currSys]);
        if strcmp(currSys,currSysName)
            try
                bData = [bData get_state_points2(trnData,currSys,stateName,number)];
            catch
            end
        end
    end
end
end