function [S] = SumwNaN(X, Dim, flag)
% Sum with missing values
%
% [S] = SumwNaN(X, Dim, flag)
% 
% INPUT
% X   : data array
% Dim : dimension along which the sum is to be performed
% flag: true if any missing / missingness of X
% 
% OUTPUT
% S: sum along Dim of X ignoring missing values
% 
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
% 
% Created      : 10 March, 2009; 15:59
% Last modified: 24 November, 2009; 16:03
if nargin < 1,error('not enough input arguments'); end
if nargin < 2,Dim = 1;end
if nargin < 3,flag = [];end
if isempty(flag) || (numel(flag) == 1 && flag)
   flag = isnan(X);
   N    = true;
elseif isequal(size(flag),size(X)), N = true;
elseif numel(flag) == 1 && ~flag,   N = false;
else error('Invalid flag'),
end
if N, X(flag) = 0; end
S = sum(X,Dim);
