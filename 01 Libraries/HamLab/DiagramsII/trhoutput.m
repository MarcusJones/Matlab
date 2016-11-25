% "Klimaat Evaluatie Kaart" / "Climate Evaluation Chart" generating file
% the command "kekoutput" can be used after simulation or measurement
% if HAMbase or AutomaticMeasuringSystem were used.
% This file is editable; personal adjustments can be made.
% Copyright TU/e, MM & JvS, 2006 01 20

% IF CASE = SIMULATION
if exist('BASE')==1

% default settings; do not change
for zonenr=1:length(BASE.Vol)
eval(['ZONE(zonenr).name=''zone ' num2str(zonenr) ''';'])
eval(['ZONE(zonenr).demandname=''ASHRAE B'';'])
eval(['ZONE(zonenr).demand=[15 25 5 5 40 60 10 10];'])
end

% Zone specification; change if different parameters are required (will override default settings)
ZONE(1).name='zone 1';                      % name of zone
ZONE(1).demandname='ASHRAE B';              % name of Climate Demand to compare with
ZONE(1).demand=[15 25 5 5 40 60 10 10];     % Climate Demand: min. T, max T, dThour, dTday, min. RH, max. RH, dRHhour, dRHday
titlename='Simulation';

% executable; do not change
a=[''];
b=[''];
for zonenr=1:length(BASE.Vol)
a=[a ',''' ZONE(zonenr).name ''',Output.Ta(:,' num2str(zonenr) '),' num2str(ZONE(zonenr).demand(1)) ',' num2str(ZONE(zonenr).demand(2)) ',' num2str(ZONE(zonenr).demand(3)) ',' num2str(ZONE(zonenr).demand(4))];
b=[b ',''' ZONE(zonenr).name ''',100*Output.RHa(:,' num2str(zonenr) '),' num2str(ZONE(zonenr).demand(5)) ',' num2str(ZONE(zonenr).demand(6)) ',' num2str(ZONE(zonenr).demand(7)) ',' num2str(ZONE(zonenr).demand(8))];
end
eval(['tempreport(length(Output.Ta)/(BASE.Period(4)*24),titlename' a ')'])
eval(['humreport(length(Output.RHa)/(BASE.Period(4)*24),titlename' b ')'])
end



% IF CASE = MEASUREMENT
if exist('spec')

% executable; do not change
a=[''];
b=[''];
for zonenr=1:length(spec)
a=[a ',''' spec(zonenr).name1 ''',' spec(zonenr).code '(:,1),' num2str(spec(zonenr).demand(1)) ',' num2str(spec(zonenr).demand(2)) ',' num2str(spec(zonenr).demand(3)) ',' num2str(spec(zonenr).demand(4))];
b=[b ',''' spec(zonenr).name1 ''',' spec(zonenr).code '(:,3),' num2str(spec(zonenr).demand(5)) ',' num2str(spec(zonenr).demand(6)) ',' num2str(spec(zonenr).demand(7)) ',' num2str(spec(zonenr).demand(8))];
end
eval(['tempreport(4,spec(zonenr).name2' a ')'])
eval(['humreport(4,spec(zonenr).name2' b ')'])
end
