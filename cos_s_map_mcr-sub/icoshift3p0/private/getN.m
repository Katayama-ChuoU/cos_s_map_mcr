function [n,Flags] = getN(n,Flags,inter,scalStr)
%% Constants
% Errors
BADN        = 'n must be ''f'', ''b'' or a scalar';
NONPOSITIVE = 'Maximum shift "n" must be positive';

% Warnings
NONINDEX = '"n" must be an integer if Scal is ignored (%i is used)';

%% Initialisation
if (isempty(n)),
    n = 'f'; % Change here the default assigned "n" value
    fprintf('\n Fast search for the best "n" set by default (initial value 50)\n')
end
useScal = nargin > 2 && ~isempty(scalStr);
A       = numel(n) == 1;
B       = ischar(n) && any(strcmpi({'b','f'},n));
C       = isnumeric(n);
D       = useScal || fix(n) == n;
if (~(A && (B || (C && D)))), error('icoShift:badN',BADN); end
if (~isa(n,'numeric')), return; end
if (any(n <= 0)),  error('getN:nonPositive',NONPOSITIVE); end
if (useScal), n = dscal2dpts(n,scalStr.scal,scalStr.precision);
elseif (~D), 
    warning('getN:nonIndex',NONINDEX,round(n));
    fprintf('\n press a key to continue...')
    pause
end
if (~Flags.flag2 && any(diff((reshape(inter,2,size(inter,2)/2)),1,1) < n)) %FRSA a ) was missing
    error('ERROR: shift "n" must be not larger than the size of the smallest interval');
end
n = round(n(1));

end
