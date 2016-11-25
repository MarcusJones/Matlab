% Script to plot bar charts - get the structure
% MJones - 12 OCT 2009 - Created file

function plot_barData(trnTime,bData)
% This section for pretty bar graph is straight out of help file!

n = length(bData.hdr);
h = bar(bData.data');
colormap(summer(n));
ch = get(h,'Children');
fvd = get(ch,'Faces');
fvcd = get(ch,'FaceVertexCData');
[zs, izs] = sortrows(bData.data',1);
for i = 1:n
    row = izs(i);
    fvcd(fvd(row,:)) = i;
end
set(ch,'FaceVertexCData',fvcd)
k = 128;                % Number of colors in color table
colormap(summer(k));    % Expand the previous colormap
shading interp          % Needed to graduate colors
for i = 1:n
    color = floor(k*i/n);       % Interpolate a color index
    row = izs(i);               % Look up actual row # in data
    fvcd(fvd(row,1)) = 1;       % Color base vertices 1st index
    fvcd(fvd(row,4)) = 1;
    fvcd(fvd(row,2)) = color;   % Assign top vertices color
    fvcd(fvd(row,3)) = color;
end
set(ch,'FaceVertexCData', fvcd);  % Apply the vertex coloring
set(ch,'EdgeColor','k');           % Give bars black borders

%            set(h,'xlabel',bData.desc)

set(gca,'xticklabel',bData.desc)


ylabel('Energy [kWh]');

name = ['Energy for ' bData.system ' system, from ' ...
    datestr(trnTime.Range.start, 'dd-mmmm-yy HH:MM') ' to  ' ...
    datestr(trnTime.Range.end, 'dd-mmmm-yy HH:MM')];

title(name)
