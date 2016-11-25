% Fuction - Unit version
% MJones
% Unit Conversion - currently only kJ/h to kW
% Loop through each file
% Currently only converts one unit type, can be expanded for more
% Inputs:
% Entire TData struct

function TData = convert_units(TData)

for i = 1:size(TData(:),1);
    % Loop through each unit
    for j = 1:size(TData(i).units,2)
        % Look for a string, store anything
        Match = (regexp(TData(i).units(j), 'kJ/h'));
        % Convert the first cell element to a number for logical if statement
        if cell2mat(Match)
            TData(i).data(:,j) = convert_KJH_kW(TData(i).data(:,j)); %convert!
            TData(i).units(j) = cellstr(' [kW]'); % Convert string to cell
        end

    end
end

end
