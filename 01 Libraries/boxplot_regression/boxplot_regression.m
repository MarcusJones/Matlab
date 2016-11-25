function [Q] = boxplot_regression(X, Y, width, bottom_bin_upper_bound, Nbins)

% ----------------------------
% S. HSIANG, 1/12
% SHSIANG@PRINCETON.EDU
% ----------------------------
%
% OUTPUT = boxplot_regression(X, Y, width, bottom_bin_upper_bound, Nbins)
%
% BOXPLOT_REGRESSION bins data from X and Y according to the bins in X 
% specified by WIDTH, BOTTOM_BIN_UPPER_BOUND and NBINS. It then plots a 
% boxplot over these bins in X for the values in Y.  It also overlays the
% conditional mean of Y for each bin.
%
% X - independant variable
% Y - dependant variable
% width - the width of each interior bin in X
% bottom_bin_upper_bound - the upper bound for the lowest bin
% Nbins - the number of total bins (including top and bottom bins)
%
% NOTES:
%
% The top and bottom bins are for all values beyond the limits of the
% Nbins-2 interior bins.  They are infinite in width.  However, all
% interior bins are WIDTH units in width.
%
% Each bin includes its upper bound but excludes its lower bound. 
%
% X and Y can be matrices or vectors, however they must be the same size
% and have elements that correspond 1:1.
%
% The OUTPUT stored is a structure containing values of 
% Y         - reshaped to a vector
% X_binned  - corresponding new values of X that are unique to each bin 
%               (indexed by each bin's upper bound, except the top bin)
% Y_means   - the mean values of Y for each bin
% labels    - a cell array describing the values of X in each bin
%
% See also bin_var, NWbootstrap, NWbootstrap_epkv, NWbootstrap_epkv_3D


%------------- FIRST CHECK THAT DATA IS SAME SIZE

size_X = size(X);
size_Y = size(Y);

if size_X(1) ~= size_Y(1)
    Q = false;
    disp('SOL: X AND Y DATA MUST BE SAME DIMENSIONALITY')
    return
end

if size_X(2) ~= size_Y(2)
    Q = false;
    disp('SOL: X AND Y DATA MUST BE SAME DIMENSIONALITY')
    return
end


N_bins = (Nbins-2);
top_bin_lower_bound = bottom_bin_upper_bound + N_bins * width;


%------------- reshape the data to be one vector for each var

X = reshape(X,size_X(1)*size_X(2),1);
Y = reshape(Y,size_Y(1)*size_Y(2),1);

%------------- bin X data - designate bin by upper bound value (inclusive)

X_binned = nan(size(X));    %X var after binning

for i = 1:length(X)
    
    %top bin
    if X(i) <= bottom_bin_upper_bound
        X_binned(i) = bottom_bin_upper_bound;
    end

    %bottom bin
    if X(i) > top_bin_lower_bound
        X_binned(i) = top_bin_lower_bound + width;
    end

    %all interior bins
    for n = 1:N_bins
        
        if X(i) > bottom_bin_upper_bound + width*(n-1) && X(i) <= bottom_bin_upper_bound + width*(n)
            X_binned(i) = bottom_bin_upper_bound + width*(n);
        end
    end
end

%------------- generate labels

labels = cell(N_bins+2,1);
labels{1} = ['<=' num2str(bottom_bin_upper_bound)];
labels{N_bins+2} = ['>' num2str(top_bin_lower_bound)];

for n = 1:N_bins
    labels{n+1} = ['(' num2str(bottom_bin_upper_bound + width*(n-1)) ',' num2str(bottom_bin_upper_bound + width*(n)) ']'];
end

%------------- generate means

Y_means = nan(N_bins+2,1);  %mean values for each bin

Y_means(1) = nanmean(Y(X_binned == bottom_bin_upper_bound));
Y_means(end) = nanmean(Y(X_binned == top_bin_lower_bound));

for i = 1:N_bins
    Y_means(i+1) = nanmean(Y(X_binned == bottom_bin_upper_bound + width*(i)));
end

%------------- plot boxplots, switching style if number of bins > 25

if N_bins+2<=25
    boxplot(Y,X_binned,'labels',labels, ...
        'plotstyle','traditional','colors','k', ...
        'outliersize',3,'symbol','o','labelorientation','inline', 'jitter',.25)
else
    boxplot(Y,X_binned,'labels',labels, ...
        'plotstyle','compact','colors',[.6 .6 .6], ...
        'outliersize',3,'symbol','o','labelorientation','inline', ...
        'jitter',.1,'medianstyle','target')
end

box off

%------------- plotting means as a solid line

hold on
plot(Y_means,'Color','k','LineWidth',1.5)


Q = struct('X_binned',X_binned,'Y',Y,'Y_means',Y_means,'labels',{labels});









