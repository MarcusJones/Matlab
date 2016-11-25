function report_state_points(trnData)
%% Report on structure
% Provide some feedback to the user, for quality control
trnSystems = fieldnames(trnData);
disp(sprintf(' - Arranged %i system(s);',length(trnSystems)));

for i = 1:length(trnSystems)
    trnStates = fieldnames(trnData.(trnSystems{i}));
    disp(sprintf('     - System \''%s\'' containing;', trnSystems{i}));
    for j = 1:length(trnStates)
        disp(sprintf('          - State \''%s\'' with %i point(s);', ...
            trnStates{j}, ...
            length(trnData.(trnSystems{i}).(trnStates{j}))))
    end
end
