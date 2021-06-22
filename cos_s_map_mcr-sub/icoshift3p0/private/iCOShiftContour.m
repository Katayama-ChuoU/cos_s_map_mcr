function hContour = iCOShiftContour(x,y,Z,p,varargin)
if (nargin < 4), p = [.6 .95]; end
if (isempty(p) && nargin > 4), [~,hContour] = contour(x,y,Z,varargin{:});
else
    a = Percentile(max(Z,[],2),p);
    if (a(1) == a(2)), a = [min(Z),max(Z)]; end
    if (isequal(a(1),a(2),0)), a = [0 1]; end
    [~,hContour] = contour(x,y,Z,linspace(a(1),a(2),10),varargin{:});
end