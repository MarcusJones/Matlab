clear

% [DB,WB] = meshgrid(20:30,15:40)
% 
% T = 20:30;
% DELTA_T_WB_IN_R =
% 
% T_HW_IN_R = [ 30 50 70 90 ]

% C_8 = -5800.2206;
% C_9 = 1.3914993;
% C_10 = -0.48640239e-1;
% C_11 = 0.41764768e-4;
% C_12 = -0.14452093e-7;
% C_13 = 6.5459673;
% 
% % Find p_ws from empirical fit agaist T
% p_ws = exp(C_8./T+C_9+C_10.*T+C_11.*T.^2+C_12.*T.^3+C_13.*log(T));
% 

T_DB_IN_C = 20:30;



T_DB_IN_R = 30;
T_WB_IN_R = 10:5:30;
T_HW_IN_R = 50:100;

for i = 1:length(T_WB_IN_R)
    RF(:,i) = -0.4287 + 0.0056.*T_DB_IN_R - (0.00008505).*T_HW_IN_R.^2 +0.0212*T_HW_IN_R - 0.0074*T_WB_IN_R(i);
end

for i = 1:length(T_WB_IN_R)
    WR(:,i) = -26.7629 + 0.3195.*T_DB_IN_R + 0.012.*T_HW_IN_R.^2+ (0.00000000032589).*T_HW_IN_R - 1.11.*T_WB_IN_R(i);
end

FPeff = 0.898316195 + T_HW_IN_R.* (-0.00655527);
VTeff = 0.554241645 + T_HW_IN_R.* (-0.002570694);


% Start figure
figure
hold on
legstr = ['T_W_B = 10\circC'; 'T_W_B = 15\circC'; 'T_W_B = 20\circC'; 'T_W_B = 25\circC'; 'T_W_B = 30\circC'];

for i = 1:length(T_WB_IN_R)

    plot(T_HW_IN_R,RF(:,i),'--','LineWidth',i/2)
%    text(70,RF(25-3,i),legstr(i,:),'FontSize',15,'BackgroundColor',[1 1 1])
end
ylabel('Efficiency [-]')
xlabel('Water Temperature [\circCC]')

total1 = RF(:,4).*VTeff(:);
total2 = RF(:,4).*FPeff(:);
plot(T_HW_IN_R,FPeff,'-o','LineWidth',1.5)
plot(T_HW_IN_R,VTeff,'-*','LineWidth',1.5)
plot(T_HW_IN_R,total2,'-x','LineWidth',1.5)
% legstr = [legstr, 'Flat Plate'; ; 'Combined Vac'; 'Combined Fla'];

legstr=char(legstr,'Flat Plate','Vacuum Tube','Combined Vacuum Tube','Combined Flate Plate');

grid on
legend([legstr]);
% End figure 

% Start figure
figure
hold on
for i = 1:length(T_WB_IN_R)
    plot(T_HW_IN_R,WR(:,i))
    text(70,WR(25-3,i),legstr(i,:),'FontSize',15,'BackgroundColor',[1 1 1])
end
ylabel('Water Removal Rate [kg/hr]')
xlabel('Water Temperature [C]')
grid on
% End figure 