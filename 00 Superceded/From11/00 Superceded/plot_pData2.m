%% function plot_pData(trnTime,pStruct)
% M. Jones - 03 Sep 09 - Created function
% Plot a 'pStruct', a properly formed structure with all necessary plot
% information

% Inputs:
% timeStruct - A properly formed time structure
   % .time
   % .Range
   %   .mask
   %   .start
   %   .end
% pStruct    - A properly formed plot data structure

% Outputs:
% Plot with units, title, legend

function plot_pData2(handle, timeStruct,pStruct)

%figure
%hold on

%a1 = subplot(1,1,1);

%set(handle,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0; 46/255 139/255 87/255],...
%      'DefaultAxesLineStyleOrder',{'-','--'});

plot(timeStruct.time(timeStruct.mask),...
    [...
    pStruct.Data(timeStruct.mask,:) ...
    ],'LineWidth',1)

datetick2 

ylabel(pStruct.yLabel);

xlabel('Time')

name = [pStruct.Title ', from ' ...
    datestr(timeStruct.Range.start, 'dd-mmmm-yy HH:MM') ' to  ' ...
    datestr(timeStruct.Range.end, 'dd-mmmm-yy HH:MM')];

title(name)

% try 
%     legend(strcat(pStruct.Header,  '_',  ...
%         ' '),'interpreter', 'none')
%                 %strtrim(pStruct.Units), ...
% catch
%     disp 'ERROR HINT: Make sure length of Headers = Names = Units '
%     rethrow (lasterr)
% end

%legend(strcat(pStruct.Headers, '_', ' ', pStruct.Units),'interpreter', 'none')
