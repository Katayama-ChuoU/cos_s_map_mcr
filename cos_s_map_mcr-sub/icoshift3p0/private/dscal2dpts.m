function I = dscal2dpts(d,ppm,varargin)
% Translates an interval width from scal to the best approximation in sampling points.
%
% I = dppm2dpts(Delta,scal,prec)
%
% INPUT
% Delta: interval widths in scale units
% scal : scale
% prec : precision on the scal axes
%
% OUTPUT
% I: interval widths in sampling points
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Last modified: 21st February, 2009
%
if isempty(d), I = []; return; end
if nargin < 2, error('Not enough input arguments'); end
if d <= 0; error('Delta must be positive'); end
if ppm(1) < ppm(2), I = scal2pts(ppm(1) + d,ppm,varargin{:}) - 1;
else I = length(ppm) - scal2pts(ppm(end) + d,ppm,varargin{:}) + 1;
end

