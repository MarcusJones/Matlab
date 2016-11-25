% Script to plot bar charts - get the structure
% MJones - 12 OCT 2009 - Created file

function bData = get_barData(trnTime,trnData,searchSystem,searchState)

[Y, M, D, H, MN, S] = datevec(trnTime.time(2)-trnTime.time(1));
Interval = H + MN/60 + S/3600;

trnSystems = fieldnames(trnData);
% Loop through the systems
for i = 1:length(trnSystems)
    if (strcmp(trnSystems{i},searchSystem))
        trnStates = fieldnames(trnData.(trnSystems{i}));
        % Loop through the state groups
        for j = 1:length(trnStates)
            % Look for Power states
            if (strcmp(trnStates{j},searchState))
                barSystem = trnStates{j};
                barArray = [];
                barHdr = [];
                barDesc = {};
                % Loop through the state numbers
                for k = 1:length(trnData.(trnSystems{i}).(trnStates{j}))
                    barArray = [barArray trnData.(trnSystems{i}).(trnStates{j}){k}.data];
                    barHdr = [barHdr trnData.(trnSystems{i}).(trnStates{j}){k}.number];
                    barDesc = [barDesc trnData.(trnSystems{i}).(trnStates{j}){k}.description];
                end
                barData = sum(barArray(trnTime.Range.mask,:))*Interval;
            end
        end
    end
end

bData.array = barArray;
bData.hdr = barHdr;
bData.desc = barDesc;
bData.data = barData;
bData.system = searchSystem;
