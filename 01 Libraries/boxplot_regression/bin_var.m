function [Q] = bin_var(X, width, bottom_bin_upper_bound, Nbins)

% ----------------------------
% S. HSIANG, 1/12
% SHSIANG@PRINCETON.EDU
% ----------------------------
%
% OUTPUT = bin_var(X, width, bottom_bin_upper_bound, Nbins)
%
% BIN_VAR bins data from X according to the bins 
% specified by WIDTH, BOTTOM_BIN_UPPER_BOUND and NBINS. 
%
% X - variable
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
% X can be a matrix or vectors.  The output size is the same as the
% original
%
% The OUTPUT stored is a structure containing values of 
% X_binned  - corresponding new values of X that are unique to each bin 
%               (indexed by each bin's upper bound, except the top bin)
% labels    - a cell array describing the values of X in each bin
%
% See also boxplot_regression


%------------- specifying bins

size_X = size(X);

N_bins = (Nbins-2);
top_bin_lower_bound = bottom_bin_upper_bound + N_bins * width;


% reshape the data to be one vector for each var
X = reshape(X,size_X(1)*size_X(2),1);

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

%reshaping to original dims
X_binned = reshape(X_binned,size_X(1), size_X(2));

Q = struct('binned_values',X_binned,'bins',{labels});









