% OBSELETE plot_psychro_all2(trnData,trnTime)

% Handle = 1;
% for i = 1:10
%     psychTime1 = dateNum(2000, 01, 01, i, 00, 0);
%     psyData1 = get_psych_data(trnData,trnTime,'Office',psychTime1);
%     plot_psyData(psyData1,Handle);
% %    set(Handle, 'OuterPosition',[100, 100, 1000,900])
%     psychMovie2(i) = getframe(gcf);
%     close
% end
% % 
% %
% clf
% %figure
% set(gcf, 'OuterPosition',[100, 100, 1000,900])
% axes('Position',[0 0 1 1])
% movie(psychMovie2,100)
% mpgwrite(psychMovie2,[],'c:\test4.mpg')
% 
%
% psychTime1 = dateNum(2000, 01, 01, 12, 00, 0);
% psyData1 = get_psych_data(trnData,trnTime,'Office',psychTime1);
% psychTime2 = dateNum(2000, 01, 3, 7, 43, 2);
% psyData2 = get_psych_data(trnData,trnTime,'SHX',psychTime2);
% PlotH = plot_psyData(psyData1);
% HOLD plot...
% plot_psyData(psyData1,PlotH)