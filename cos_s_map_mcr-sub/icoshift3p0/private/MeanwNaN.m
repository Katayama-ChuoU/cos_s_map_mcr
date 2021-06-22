function [S] = MeanwNaN(X, Dim, flag)
% Mean with missing values
%
% [S] = MeanwNaN(X, Dim, flag)
%
% INPUT
% X   : data array
% Dim : dimension along which the mean is calculated
% flag: true if any missing / missingness of X
%
% OUTPUT
% S: mean along Dim of X ignoring missing values
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
if (cellfun(@str2num,regexp(version,'^(\d+?).','tokens','once')) >= 8), narginchk(1,3); 
elseif (nargin < 1), error('Not enough input arguments'); 
end
if (nargin < 2),Dim = 1;end
if (nargin < 3),flag = [];end
if (isempty(flag) || (numel(flag) == 1 && flag))
    flag = isnan(X);
    N    = true;
elseif (isequal(size(flag),size(X))), N = true;
elseif (numel(flag) == 1 && ~flag),   N = false;
else error('Invalid flag'),
end
if N,
    X(flag) = 0;
    flag    = ~flag;
    c       = sum(flag,Dim);
    c(~c)   = NaN;
else
    c = size(X,Dim);
end
S = sum(X,Dim) ./ c;