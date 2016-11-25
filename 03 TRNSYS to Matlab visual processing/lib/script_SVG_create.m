%% Checkout a fresh copy
% Template file is here:
%svgTemplate = [settings.currFilePath 'Data\Template.svg'];
%svgFile = [settings.fileio.trnsysprojdir 'HVAC\CTCC.svg'];
% Copy it to a new one:
%copyfile(svgTemplate,svgFile);


%% SVG Creating
% This take over 1 minute!!

% Have to MANUALLY modify the template ... ? 
% Ensure that: '</g></svg>' is on ONLY ONE LINE AT END!!!!!!!!!!
svgFile = ['Y:\08 Analysis\SVG Analysis\Templates\WaterSide_Template.svg'];
svgFile = ['Y:\08 Analysis\SVG Analysis\Templates\AirSide_Template.svg'];

statesToCreate = {'Fluid' 'MoistAir' 'ThermalPower' 'Power'};
relatedTemplateIDs = {'FLD_template' 'MOA_template' 'THP_template' 'POW_template'};

% Use this section to only generate certain points!!!
%statesToCreate = {'MoistAir'};
%relatedTemplateIDs = {'MOA_template'};
%systemsToCreate = {'Office','Theatre','Exhibition','Toilets','SHX'};
%systemsToCreate = {'CTCC','CoolNet','Dist','Sol'};
systemsToCreate = {'Sol'};

tic
% Loop through all states to create
for stateIndx = 1:length(statesToCreate)
    trnSystems = fieldnames(trnData);
    % Loop through the systems in the current state
    for iSystems = 1:length(trnSystems)

        for iSystemsToCreate = 1:length(systemsToCreate)
            % Search and ensure that 
            if strcmp(trnSystems{iSystems},systemsToCreate{iSystemsToCreate}) ...
                || strcmp('all',systemsToCreate{1})

                trnStates = fieldnames(trnData.(trnSystems{iSystems}));

                system2SVG = trnSystems{iSystems}; % The system
                searchState = statesToCreate{stateIndx}; % The State
                searchTextID = relatedTemplateIDs{stateIndx}; % The search ID

                % Loop through the state groups
                for iStates = 1:length(trnStates)
                    % If the stategroup matches, then add the point
                    if (strcmp(trnStates{iStates},searchState))
                        type2SVG = trnStates{iStates};
                        add_all_statepoints_SVG(trnData, settings, svgFile, system2SVG, type2SVG, searchTextID);
                    end
                end

            end
        end

    end

end
toc
