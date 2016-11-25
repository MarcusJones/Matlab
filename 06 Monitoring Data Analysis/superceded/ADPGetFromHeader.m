function out=ADPGetFromHeader(header,x)
todisplay=[];
l=size(header);
%start to parse the selections
if ~iscell(x)
    x={x};
end
for i=1:length(x)
    current=x{i};
    % first handle vectors, which can be colums or rows
    if isvector(current) && ~ischar(current)
        if round(current)==current
            try
                todisplay=[todisplay,current];
            catch
                todisplay=[todisplay,current'];
            end
        else
            error('Vector of Colums to plot contains non-integer Values');
        end
    else
        if ischar(current)
            if ~isempty(regexp(current,'^°C$|^h$|Wh$|^%$|^bar$|^A$|m[^][23]$|/s$','once'))
                %check if unit is searched for, if so, use the 5th row
                for j=1:l(2)
                    if ~isempty(regexp(header{5,j},current,'once'))
                        todisplay=[todisplay ,j];
                    end
                end
            else
                % else search in the header for occurencies of the string in the
                % text fields (3,4,9 and 10th row)
                for j=1:l(2)
                    if ~isempty(regexp(header{10,j},current,'once')) || ~isempty(regexp(header{9,j},current,'once')) || ...
                            ~isempty(regexp(header{3,j},current,'once')) || ~isempty(regexp(header{4,j},current,'once'))
                        todisplay=[todisplay ,j];
                    end
                end
            end
        end
    end
end
out=sort(unique(todisplay));
