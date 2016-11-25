% "Klimaat Evaluatie Kaart" / "Climate Evaluation Chart" generating file
% the command "kekoutput" can be used after simulation or measurement
% if HAMbase or AutomaticMeasuringSystem were used.
% This file is editable; personal adjustments can be made.
% All figures are saved as .tif in KEKyyyymmdd-folder.
% Copyright TU/e, MM & JvS, 2006 01 20

% IF CASE = SIMULATION
if exist('BASE')==1

% default settings; do not change
for zonenr=1:length(BASE.Vol)
eval(['ZONE(zonenr).name=''zone ' num2str(zonenr) ''';'])
eval(['ZONE(zonenr).demandname=''ASHRAE B'';'])
eval(['ZONE(zonenr).demand=[15 25 5 5 40 60 10 10];'])
eval(['KEK(zonenr).Taxismin=-1;'])
eval(['KEK(zonenr).Taxismax=31;'])
eval(['KEK(zonenr).Twidth=0.2;'])
eval(['KEK(zonenr).Xwidth=0.2;'])
eval(['KEK(zonenr).histogram=1;'])
eval(['KEK(zonenr).fungalgrowth=1;'])
end

% Zone specification; change if different parameters are required (will override default settings)
ZONE(1).name='zone 1';                      % name of zone
ZONE(1).demandname='ASHRAE B';              % name of Climate Demand to compare with
ZONE(1).demand=[15 25 5 5 40 60 10 10];     % Climate Demand: min. T, max T, dThour, dTday, min. RH, max. RH, dRHhour, dRHday

% KEK specification; change if different parameters are required (will override default settings)
KEK(1).Taxismin=-1;                         % minimum value on Temperature axis
KEK(1).Taxismax=31;                         % maximum value on Temperature axis
KEK(1).Twidth=0.2;                          % width between 2 squares, temperature
KEK(1).Xwidth=0.2;                          % width between 2 squares, absolute humidity
KEK(1).histogram=1;                         % plot histograms; 1 = yes, 0 = no
KEK(1).fungalgrowth=1;                      % plot fungal growth curve; 1 = yes, 0 = no

% executable; do not change
for zonenr=1:length(BASE.Vol)
kek(Output.Ta(:,zonenr),100*Output.RHa(:,zonenr),3600*(BASE.Period(4)*24)/length(Output.Ta),BASE.Period(1),BASE.Period(2),BASE.Period(3),1,0,0,ZONE(zonenr).name,...
    ZONE(zonenr).demandname,ZONE(zonenr).demand(1),ZONE(zonenr).demand(2),ZONE(zonenr).demand(3),ZONE(zonenr).demand(4),ZONE(zonenr).demand(5),ZONE(zonenr).demand(6),...
    ZONE(zonenr).demand(7),ZONE(zonenr).demand(8),KEK(zonenr).Taxismin,KEK(zonenr).Taxismax,KEK(zonenr).Twidth,KEK(zonenr).Xwidth,KEK(zonenr).histogram,...
    KEK(zonenr).fungalgrowth,BASE,Output,zonenr);
end
end

% IF CASE = MEASUREMENT
if exist('spec')

% default settings; do not change
for zonenr=1:length(spec)
eval(['KEK(zonenr).Taxismin=-1;'])
eval(['KEK(zonenr).Taxismax=31;'])
eval(['KEK(zonenr).Twidth=0.2;'])
eval(['KEK(zonenr).Xwidth=0.2;'])
eval(['KEK(zonenr).histogram=1;'])
eval(['KEK(zonenr).fungalgrowth=1;'])
end

% KEK specification: change if different parameters are required (will override default settings)
KEK(1).Taxismin=-1;                         % minimum value on Temperature axis
KEK(1).Taxismax=31;                         % maximum value on Temperature axis
KEK(1).Twidth=0.2;                          % width between 2 squares, temperature
KEK(1).Xwidth=0.2;                          % width between 2 squares, absolute humidity
KEK(1).histogram=1;                         % plot histograms; 1 = yes, 0 = no
KEK(1).fungalgrowth=1;                      % plot fungal growth curve; 1 = yes, 0 = no

% executable; do not change
for zonenr=1:length(spec)
eval(['kek(' spec(zonenr).code '(:,1),' spec(zonenr).code '(:,3),-1,' spec(zonenr).code '(:,10),1,1,1,1,1,spec(zonenr).name1,spec(zonenr).demname,spec(zonenr).demand(1),spec(zonenr).demand(2),spec(zonenr).demand(3),spec(zonenr).demand(4),spec(zonenr).demand(5),spec(zonenr).demand(6),spec(zonenr).demand(7),spec(zonenr).demand(8),KEK(zonenr).Taxismin,KEK(zonenr).Taxismax,KEK(zonenr).Twidth,KEK(zonenr).Xwidth,KEK(zonenr).histogram,KEK(zonenr).fungalgrowth);'])
end
end
