%tStartSVGChange = tic;
%INPUT
% Set the state point info...

currSnapIdx = find_snaptime_index(trnTime, snapTime);
snapDateStringSVG = datestr(snapTime, 'mmmm dd HH:MM AM');

find_replace_SVG_text(settings, svgFile, 'tspan[@id=''StateDateTime'']', snapDateStringSVG);

trnSystems = fieldnames(trnData);
% Looping through the systems ...
for i = 1:length(trnSystems)
    %if strcmp(trnSystems{i},'Office')
    % The current system
    currSvgSys = trnSystems{i};
    trnStates = fieldnames(trnData.(trnSystems{i}));

    % Looping through the states ...
    for j = 1:length(trnStates)

        currSvgState = trnStates{j};

        switch (currSvgState)
            case 'Fluid'
                svgTextFieldVec = {'.Temperature','.FlowRate','.Enthalpy', '.ID'};
                svgTextUnitVec =  {' C', ' kg/s',' kW', ''};
                currSvgType = 'Fluid';
            case 'MoistAir'
                svgTextFieldVec = {'.Temperature','.Humidity','.FlowRate','.Enthalpy','.ID'};
                svgTextUnitVec =  {' C',' g/kg',' kg/s',' kW', ''};
                currSvgType = 'MoistAir';
            case 'ThermalPower'
                svgTextFieldVec = {'.ThermalPower', '.ID'};
                svgTextUnitVec =  {' kW', ''};
                currSvgType = 'ThermalPower';
            case 'Power';
                svgTextFieldVec = {'.Power', '.ID'};
                svgTextUnitVec =  {' kW', ''};
                currSvgType = 'Power';
            otherwise
                svgTextFieldVec = {};
                svgTextUnitVec =  {};
                currSvgType = 0;
        end

        currStatePointDataColVec = 1:length(svgTextUnitVec);


        % Loop through each variable for the current state
        for spIndx = 1:length(currStatePointDataColVec)

            %%%%%%%%%%%%
            svgTextField = svgTextFieldVec{spIndx};
            svgTextUnit = svgTextUnitVec{spIndx};
            currStatePointDataCol = currStatePointDataColVec(spIndx);

            for i = 1:length(trnData.(currSvgSys).(currSvgState))
                currStatePoint = get_state_point(trnData,currSvgSys,currSvgType,i);
                currID = [currStatePoint.system '.' currStatePoint.type '.' num2str(currStatePoint.number)];
                currSearchXPath = ['tspan[@id=''' currID svgTextField ''']'];

                if strcmp(svgTextField,'.ID')
                    currVariable = currStatePoint.number;
                    currVariableStr = sprintf('%i',currVariable);
                    currVariableStr = ' ';
                else
                    currVariable = currStatePoint.data(currSnapIdx,currStatePointDataCol);
                    if strcmp(svgTextField,'.Humidity')
                        currVariable = currVariable .*1000;
                    end
                    if strcmp(svgTextField,'.FlowRate')
                        currVariable = currVariable ./3600;
                    end
                    currVariableStr = sprintf('%0.1f',currVariable);
                end

                newTSpanText = [currVariableStr svgTextUnit];

                find_replace_SVG_text(settings, svgFile, currSearchXPath, newTSpanText);
                %                disp(sprintf('spIndex = %i i = %i', spIndx, i));
                disp(sprintf('CurrSearch = %s newText = %s', currSearchXPath, newTSpanText));
            end
        end
    end
    %end
end
%close(h)

%tStartSVGChangeElapsed=toc(tStartSVGChange)
