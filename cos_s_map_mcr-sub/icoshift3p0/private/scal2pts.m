function pts = scal2pts(ppmi,ppm,prec)
% Transforms scalars in data points
%
% pts = scal2pts(values,scal)
%
% INPUT
% values: scalars whose position is sought
% scal  : vector scalars
% prec  : precision (optional) to handle endpoints
%
% OUTPUT
% pts   : position of the requested scalars (NaN if it is outside of 'scal')
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Created      : 12 February, 2009; 17:43
% Last modified: 11 March, 2009; 15:14

% HISTORY
% 1.00.00 12 Feb 09 -> First working version
% 1.01.00 11 Mar 09 -> Added input parameter check
if nargin < 3, prec = min(abs(unique(diff(ppm)))); end
dimppmi = size(ppmi);
ppmi    = ppmi(:);
ppm     = ppm(:);
rev     = ppm(1) > ppm(2);
if rev, ppm = ppm(end:-1:1); end
ubound  = (ppmi - ppm(end)) < prec & (ppmi - ppm(end)) > 0;
lbound  = (ppm(1) - ppmi) < prec & (ppm(1) - ppmi) > 0;
ppmi(ubound) = ppm(end);
ppmi(lbound) = ppm(1);
if nargin < 2, error('Not enough input arguments'); end
if length(ppmi) > length(ppm), warning('icoshift:scal2pts','ppm vector is shorter than the value''s'), end
[xxi,k]              = sort(ppmi(:));
[~,j]                = sort([ppm(:);xxi(:)]);
r(j)                 = 1:length(j);
r                    = r(length(ppm) + 1:end) - (1:length(ppmi));
r(k)                 = r;
r(ppmi == ppm(end))  = length(ppm);
ind                  = find((r > 0) & (r <= length(ppm)));
ind                  = ind(:);
pts                  = Inf(size(ppmi));
pts(ind)             = r(ind);
ptsp1                = min(length(ppm),abs(pts + 1));
ptsm1                = max(1,abs(pts - 1));
ind                  = find(isfinite(pts));
dp0                  = abs(ppm(pts(ind)) - ppmi(ind));
dpp1                 = abs(ppm(ptsp1(ind)) - ppmi(ind));
dpm1                 = abs(ppm(ptsm1(ind)) - ppmi(ind));
pts(ind(dpp1 < dp0)) = pts(ind(dpp1 < dp0)) + 1;
pts(ind(dpm1 < dp0)) = pts(ind(dpm1 < dp0)) - 1;
if isempty(pts), pts = []; end
pts(not(isfinite(pts))) = NaN;
if rev, pts = length(ppm) - pts + 1; end
if ~isequal(size(pts),ppmi), pts = reshape(pts,dimppmi); end

