tElapsedTotal=toc(tStartTotal)/60;
tElapsedOverhead = tElapsedTotal- tElapsedTRNSYS -tElapsedSVG;
disp(' - Time Report ...');
disp(['     - Overhead: ',sprintf('%.1f',tElapsedOverhead),'m']);
disp(['     - TRNSYS: ',sprintf('%.1f',tElapsedTRNSYS),'m']);
disp(['     - SVG: ',sprintf('%.1f',tElapsedSVG),'m']);

% if (flagCheckDckErrors && flagRunDeckFile)
%     disp(sprintf(' - Convergence score: %0.1f%%',100-logFile.notConverged/length(trnTime.time)/printIntervalMultiplier*100));
% end