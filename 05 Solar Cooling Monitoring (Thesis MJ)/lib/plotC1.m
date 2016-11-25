clear x1 x2 y X b stats x1fit x2fit X1FIT X2FIT YFIT b 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose and load independent and dependent variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 1
x1 = Good.Air.Amb.W';
x2 = Good.Strong.C.In';
y = Good.C.Air.WA';

Variable = 'Absorption ';
Units = '[kg/hr]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose model of fit and perform regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = [ones(size(x1)) x1 x2 x1.*x2]; % Bi-linear, w/ interaction
b = regress(y,X);
yhat = b(1) + b(2)*x1 + b(3)*x2 + b(4)*x1.*x2;
r = y-yhat;
% stats = regstats(y,[x1 x2 x1.*x2],'interaction'); % Perform fit
% beta - Regression coefficients
% covb - Covariance of regression coefficients
% yhat - Fitted values of the response data
% r	 - Residuals
% mse - Mean squared error
% rsquare - R2 statistic
s = std(r)
b

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correlation plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
a1 = subplot(1,2,1);
p1 = plot(yhat,y);
hold on
p2 = plot([-1000,1000],[-1000,1000]);
axis([round(min(y)) round(max(y)) round(min(y)) round(max(y))])
axis([0 round(max(y)) 0 round(max(y))])
set(p1,'Marker','.','LineStyle','none');
ylabel(a1,[Variable Units])
xlabel(a1,[Variable Units])
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Residual plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a2 = subplot(1,2,2);
p1 = plot(y,r);
hold on
p2 = plot([-1000,1000],[0,0]);
axis([round(min(y)) round(max(y)) round(min(r)) round(max(r))])
axis([0 round(max(y)) round(min(r)) round(max(r))])
set(p1,'Marker','.','LineStyle','none');
ylabel(a2,['Residual ' Units])
xlabel(a2,[Variable Units])
hold off

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 3D plot of data and model
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hold on
% %b = stats.beta;
% scatter3(x1,x2,y) % Raw data
% X = [x1,x2];
% x1min = floor(min(x1)*1000)/1000;
% x1max = floor(max(x1)*1000)/1000;
% x1step = (x1max - x1min)/10;
% x2min = floor(min(x2)*1000)/1000;
% x2max = floor(max(x2)*1000)/1000;
% x2step = (x2max - x2min)/10;
% x1fit = (x1min:x1step:x1max); % x1 fit axis
% x2fit = (x2min:x2step:x2max); % x2 fit axis
% [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
% YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT.*X2FIT;
% mesh(X1FIT,X2FIT,YFIT); % Fitted data
% hold off