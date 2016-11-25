function plot_cv_network(cvData)

figure
axes
axis([0 100 0 100])
for i = 1 : length(cvData)
    text(cvData{i}.x,cvData{i}.y,sprintf('%s \n %.2f',...
        cvData{i}.title,cvData{i}.balanceSnap));
end