function [xT,pars] = getTarget(Target,xP,pars,options)
%% Constants
BASICTARGETS   = {'average','average2','median','max'};

% Error
BADTARGET = 'Invalid target. It must be a signal of appropriate size or one of ''average'',''median'',''average2'', or ''max''';

%% Some initialisations
DEFAULTTARGETPARS = struct('maxFlag',false,'avg2Flag',false,'avgPower',3,'note','','avg2dontAsk',false);
fN = fieldnames(DEFAULTTARGETPARS);
for (i = 1:length(fN))
    if (~isfield(pars,fN{i})), pars.(fN{i}) = DEFAULTTARGETPARS.(fN{i}); end
end

%% Main
if (ischar(Target))
    
    xT = BASICTARGETS(strncmpi(Target,BASICTARGETS,length(Target)));
    if (length(xT) > 1), xT = xT(1); end
    xT = char(xT);
    pars.note = xT;
    switch(lower(xT))
        case {'average','average2'}
            xT        = MeanwNaN(xP);
            pars.avg2Flag = pars.note(end) == '2';
            if (pars.avg2Flag && options.show && ~pars.avg2dontAsk)
                pars.avgPower    = input('Input multiplier for the 2nd average [default is 3]: ');
                pars.avg2dontAsk = true;
                if (isempty(pars.avgPower)); pars.avgPower = 3; end
            end
            
        case 'median', xT = MedianwNaN(xP);            
        case 'max'
            dimX         = size(xP);
            xT           = zeros([1,dimX(2:end)]);
            pars.maxFlag = true;

        otherwise, error('icoshift:badTarget',BADTARGET);
    
    end
    
elseif (size(Target,2) ~= size(xP,2)), error('Target "xT" and sample "xP" must have the same number of columns');
elseif (~ismatrix(xP))
    dimT = size(Target);
    dimP = size(xP);
    if (~isequal(dimT(3:end),dimP(3:end))), error('icoshift:badTarget',BADTARGET); end
    xT = Target;
else xT = Target;
end

function [S] = MedianwNaN(varargin)
% Median with missing values
%
% [S] = MedianwNaN(X, Dim, flag)
% 
% INPUT
% X   : data array
% Dim : dimension along which the sum is to be performed
% flag: true if any missing
% 
% OUTPUT
% S: median along Dim of X ignoring missing values
% 
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
% 
if nargin < 1,error('not enough input arguments'); end
S = Percentile(varargin{1},0.5,varargin{2:end});

function P = Percentile(A,p,dim, flag)
% Percentiles 
%
% [P] = Percentile(A, p, dim, flag)
% 
% INPUT
% A   : matrix/array
% p   : vector of percentiles expressed as fractions between 0 and 1
% dim : dimension across which the percentiles are calculated
% flag: true if any missing values in A
% 
% OUTPUT
% P: matrix of percentiles (the same columns as A and the same n. of rows as p)
%
% Percentiles are specified in the interval [0 1] and are computed as specified in www.itl.nist.gov
% For an n-vector x the p percentile is computed as follow:
% Said k = fix(p * (N + 1)) and d = p * (N + 1) - k
%       for     k = 0 -> P = x(1)
%       for     k = N -> P = x(N)
%       for 0 < k < N -> P = x(k) + d * (x(k + 1) - x(k))
% The function ignores the missing values
% 
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
% 
% Reference: NIST Engineering Statistics Handbook (http://www.itl.nist.gov/div898/handbook/prc/section2/prc252.htm)
if (isempty(p)), error('No percentiles requested'); end
if (any(p < 0 | p > 1)) || ~isreal(p), error('Invalid percentile specification'); end
if (nargin < 3 || isempty(dim)), dim = 1; end
if (nargin < 4 || isempty(flag)), flag = true; end
N         = ndims(A);
dimA      = size(A);
dimA(dim) = length(p);
ord       = [dim,1:dim - 1,dim + 1:N];
if (dim > N), error('Percentile:singleton','Percentiles applied to singleton dimension'), end
if (dim > 1)
    iord(ord) = 1:N;
    A         = permute(A,ord); 
end
if (N > 2), A = reshape(A,size(A,1),numel(A)/size(A,1)); end
A         = sort(A);
if (numel(flag) == 1 && flag), Anan = sum(isnan(A));
elseif (numel(flag) == 1 && ~flag), Anan = 0;
else error('Invalid flag'),
end
P = NaN(length(p),size(A,2));
if (all(Anan == 0)) 
   
    n         = size(A,1);
    t         = p(:) * (n + 1);
    k         = fix(t);
    d         = t - k;
    d(k == 0) = 0;
    k(k == 0) = 1;
    d(k == n) = 1;
    k(k == n) = n - 1;
    P         = A(k,:) + d(:,ones(1,size(A,2))) .* (A(k + 1,:) - A(k,:));
    
else
    
    n         = size(A,1) - Anan;
    t         = p(:) * (n + 1);
    k         = fix(t);
    d         = t - k;
    d(k == 0) = 0;
    k(k == 0) = 1;
    for i_col = 1:size(A,2)
        k_col                    = k(:,i_col);
        d_col                    = d(:,i_col);
        d_col(k_col == n(i_col)) = 1;
        k_col(k_col == n(i_col)) = n(i_col) - 1;
        P(:,i_col)               = A(k_col,i_col) + d_col .* (A(k_col + 1,i_col) - A(k_col,i_col));
    end
    
end
if (N > 2), P = reshape(P,dimA(ord)); end
if (dim > 1), P = permute(P,iord); end
