function h = hline(y,lc)
%HLINE Adds horizontal lines to figure at specified locations.

if nargin==0
  y   = 0;
  lc  = '-g';
end
if nargin==1                 %1/01 nbg
  if isa(y,'char')
    lc = y;
    y  = 0;
  elseif isa(y,'double')
    lc = '-g';
  end
end

[m,n] = size(y);
if m>1&n>1
  error('Error - input must be a scaler or vector')
elseif n>1
  y   = y';
  m   = n;
end

v     = axis;
if ishold
  for ii=1:m
    h(ii) = plot(v(1:2),[1 1]*y(ii,1),lc);
  end
else
  hold on
  for ii=1:m
    h(ii) = plot(v(1:2),[1 1]*y(ii,1),lc);
  end
  hold off
end

if nargout == 0;
  clear h
end
