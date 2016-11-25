function [dataout,headerout]=ADPExtract(data,header,varargin)
% Extracts colums of data from a matrix using a header provided by the ADP
% Database
% [DATAOUT,HEADER]=ADPExtract(DATA,HEADER,TOEXTRACT)
% returns the datacolums and their indexes within the old data structure;in TOEXTRACT the user can specify any
%number of explicit column numbers, units or parts of names to be displayed

%first check the input
if ~isfloat(data)
    error('Data has to be a matrix');
end
if nargin<3
    error('Nothing to Extract')
end
%start to parse the selections
l=size(header);
output=[];
for i=1:length(varargin)
    current=varargin{i};
    % first handle vectors, which can be colums or rows
    if isvector(current) && ~ischar(current)
        if round(current)==current
            try
                output=[output,current];
            catch
                output=[output,current'];
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
                        output=[output ,j];
                    end
                end
            else
                % else search in the header for occurencies of the string in the
                % text fields (3,4,9 and 10th row)
                for j=1:l(2)
                    if ~isempty(regexp(header{10,j},current,'once')) || ~isempty(regexp(header{9,j},current,'once')) || ...
                            ~isempty(regexp(header{3,j},current,'once')) || ~isempty(regexp(header{4,j},current,'once'))
                        output=[output ,j];
                    end
                end
            end
        end
    end
end
%error if there was nothing selected
if isempty(output)
    error('No valid Variables were selected');
end
indexes=unique(output);
dataout=data(:,indexes);
headerout=header(:,indexes);