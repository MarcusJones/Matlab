%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function can be used to save HAMbase output to a file called 'sim.mat' (or any other name)
% First run your HAMbase simulation. Then type 'getsimresult'. All necessary files will be stored in sim.mat.
% Copy sim.mat from your simulation directory to the same directory as the other files to compare with.
% March 9, 2005, TUe, BPS, MM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsim=datenum(InClimate.date(:,1),InClimate.date(:,2),InClimate.date(:,3),InClimate.date(:,5),0,0);
% compenseren foutje van Martin: laatste waarde in InClimate.date is 0 wanneer in de zomertijd wordt begonnen en
% in de wintertijd van het volgende jaar wordt geeindigd.
tsim(length(tsim))=tsim(length(tsim)-1)+1/24;
bintemp=Output.Ta;
binvocht=100*Output.RHa;
opptemp=Output.Tw;
buitenvocht=InClimate.kli(:,5);
buitentemp=0.1*InClimate.kli(:,2);
save sim.mat tsim bintemp binvocht opptemp buitenvocht buitentemp