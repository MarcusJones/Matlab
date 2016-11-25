function [listout violationslower violationsupper] =ADPRangeTest(structin,lowers,uppers,varargin)
% searches for rage plausibility violations in ADP structures
%
% TABLEOUT=ADP(STRUCTIN,LOWER,UPPER)
% displays the number of violations in the structure, and returns TABLEOUT
% which has the size of STRUCTIN.HEADER, which contains TRUE when the
% corresponding datapoint violates the condition
%
% [TABLEOUT VIOLATIONSLOWER VIOLATIONSUPPER]=ADP(STRUCTIN,LOWER,UPPER)
% displays the number of violations in the structure, and returns TABLEOUT
% which has the size of STRUCTIN.HEADER, which contains TRUE when the
% corresponding datapoint violates the condition, and the matrices
% VIOLATIONSLOWER and VIOLATIONSUPPER which contain true if the value
% violates the lower/upper limit
%
% TABLEOUT=ADP(STRUCTIN,LOWER,UPPER,SELECTIONS)
% [TABLEOUT VIOLATIONSLOWER VIOLATIONSUPPER]=ADP(STRUCTIN,LOWER,UPPER,SELECTIONS)
% allows the user to select certain sensors by column number, name or part
% there off or physical unit
%
% See also ADPRead, ADPausfall, ADPDisp

% first see if the structure is right
if ~isADPstruct(structin)
    error('this function only works for ADP structures');
end
groesse=size(structin.data);
% check whether you need all or only certain parts
if nargin>3
    todo=ADPGetFromHeader(structin.header,varargin);
    sizetodo=length(todo);
else
    todo=1:groesse(2);
    sizetodo=groesse(2);
end
if numel(lowers)>1
   if length(lowers)~=sizetodo;
       error('Vector of lower values has to have a number of entries corresponding to the values selected.');
   end
else
    lowers=ones(sizetodo)*lowers;
end
if numel(uppers)>1
   if length(uppers)~=sizetodo;
       error('Vector of lower values has to have a number of entries corresponding to the values selected.');
   end
else
    uppers=ones(sizetodo)*uppers;
end
listout=false(groesse);
violationslower=false(groesse);
violationsupper=false(groesse);
for j=1:sizetodo
    current=structin.data(:,todo(j));
    violationsl=current<lowers(j);
    violationsu=current>uppers(j);
    % search vor violations, if found print out warning and add entries to matrix
    if sum(violationsl+violationsu)>0
        disp(['In ',structin.header{10,todo(j)},' where ',num2str(sum(violationsl)), ...
            ' values lower then ', num2str(lowers(j)), ' and ', num2str(sum(violationsu)), ' higher then ' num2str(uppers(j)),'.']);
        listout(:,todo(j))=violationsl | violationsu;
        violationslower(:,todo(j))=violationsl;
        violationsupper(:,todo(j))=violationsu;
    end
end