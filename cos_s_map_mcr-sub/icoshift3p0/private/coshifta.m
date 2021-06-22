function [xP,ind,R] = coshifta(xT,xP,refW,n,options)
% function [xW,ind,R] = coshifta(xT,xP,refW,n,options)
% Based on Correlation optimized shifting (COshift)
% Author:
% Frans van den Berg* (FvdB) email: fb@life.ku.dk
% Improved by:
% Francesco Savorani* (FS)   email: frsa@life.ku.dk
% Giorgio Tomasi*§    (GT)   email: gto@life.ku.dk
%
% * Department of Food Science Quality & Technology - Spectroscopy and Chemometrics group - www.models.life.ku.dk
% § Department of Basic Science and Environment - Soil and Environmental Chemistry group - www.igm.life.ku.dk
% Faculty of Life Sciences - University of Copenhagen - Denmark
%
% loosely based on : V.G. van Mispelaar et.al. 'Quantitative analysis of target components by comprehensive two-dimensional gas chromatography'
%                   J. Chromatogr. A 1019(2003)15-29

% HISTORY
% 1.00.00 2008 Jun 19 First documented version
% 2.00.00 2009 Nov 24 Blocking in case of large X (32MB blocks by default - options(4))


% ERRORS CHECK
if (isempty(refW)), refW = 0; end
if all(refW >= 0), rw = length(refW);
else rw = 1;
end
options_def = [ones(1,3) 2^25 -Inf 0];
options(end + 1:length(options_def)) = options_def(length(options) + 1:end);
if options(2) == 1, Filling = -inf;
elseif options(2) == 0, Filling = NaN;
else error('options(2) must be 0 or 1');
end

if  strcmpi(xT,'average'), xT = MeanwNaN(xP); end %NANMEAN REPLACED
dimT    = size(xT);
dimP    = size(xP);
dimR    = size(refW);

if (~isequal(dimT(2:end),dimP(2:end))), error('Target "xT" and sample "xP" must be of compatible size (same dimensions in all modes but the first'); end
if any(n <= 0),error('Shift(s) "n" must be larger than zero'); end
if (dimR(1) ~= 1), error('Reference windows "refW" must be either a single vector or 0'); end
if rw > 1 && (min(refW) < 1) || (max(refW) > dimT(2)), error('Reference window "refW" must be a subset of xP'); end
if (dimT(1) ~= 1), error('Target "xT" must be a single row spectrum/chromatogram'); end

auto = strcmpi(n,'b') || strcmpi(n,'f');  % switch for the best automatic serach on
if (auto)
    
    if (rw ~= 1), locDim = dimR(2); else locDim = dimP(2); end
    try_last = strcmpi(n,'f');
    if (try_last)
        n        = locDim - 1; %floor(locDim/2);     %FRSA speed up fast option
        src_step = round(locDim/2)-1;               %FRSA
    else
        n        = max(fix(0.05 * locDim),10); % change here the first searching point for the best "n"
        src_step = fix(locDim/20);             % Change here to define the searching step        
    end
    
end

if (dimT(1) ~= 1), error('ERROR: Target "xT" must be a single row spectrum/chromatogram'); end
% End ERRORS CHECK

allDimInd                      = {':'};
allDimInd                      = allDimInd(1,ones(1,ndims(xP)));
xtraDimInd                     = allDimInd(3:end);
BLOCKSIZE                      = options(4);
nBlocks                        = whos('xP');
nBlocks                        = ceil(nBlocks.bytes/BLOCKSIZE);
SamxBlock                      = floor(dimP(1)/nBlocks);
indBlocks                      = SamxBlock(1,ones(1,nBlocks));
indBlocks(1:rem(dimP(1),SamxBlock)) = SamxBlock + 1;
indBlocks                      = [0,cumsum(indBlocks)];

ind = zeros(dimP(1),1);
if (rw == 1), refW = 1:dimP(2); end
% try_last = 0;

% preprocess if required
T = preprocessX(xT(1,refW,xtraDimInd{:}),[0,options(6)],xtraDimInd{:});
B = preprocessX(xP(:,refW,xtraDimInd{:}),options([1,6]),xtraDimInd{:});

% Align
opt  = [-n n 2 options(3) Filling options(5)];
conv = false;
show = options(1) > 0;
t    = zeros(nBlocks,1);
it   = 0;
while ~conv % Automatic search for the best "n" for each interval
    
    it = it + 1;
    if (show && auto && it == 1), fprintf(1,'\tFinding optimal max. shift (it #):     '); end
    for i_block = 1:nBlocks
        
        aaaa = tic;
        allDimInd{1}          = indBlocks(i_block) + 1:indBlocks(i_block + 1);
        [~,ind(allDimInd{1})] = CC_FFTShift(T,B(allDimInd{:}),opt); %FFT Co-Shifting
        t(i_block)            = t(i_block) + toc(aaaa);
        if (show)
            if (~auto), fprintf('block #%3i: %g s\n',i_block,t(i_block)); else fprintf('\b\b\b\b\b%4i ',it); end
        end
        
    end
    if (auto) % for n equal to ither 'b' or 'f'
        
        tmp  = max(abs(ind));
        nTmp = opt(2) + src_step;
        if (tmp == opt(2) && ~try_last), try_last = nTmp >= size(refW,2); % FRSA to avoid n > interval size
        elseif (tmp < opt(2) && nTmp < size(refW,2) && ~try_last), try_last = true;
        else
            conv = true; 
            n = opt(2); 
            continue
        end
        opt(2) = nTmp ;
        opt(1) = -opt(2);
        
    else conv = true;
    end
    
end
if (show && auto), fprintf('\n'); end
if (options(1) ~= 0), fprintf('\tBest shift allowed for this interval = %g \n',n); end
if (Filling == -inf),
    leadSection  = xP(:,1,xtraDimInd{:});
    trailSection = xP(:,dimP(2),xtraDimInd{:});
elseif (isnan(Filling)); [leadSection,trailSection] = deal(NaN([dimP(1),1,dimP(3:end)]));
else [leadSection,trailSection] = deal(repmat(Filling,[dimP(1),1,dimP(3:end)]));
end
for iSam = find(ind' ~= 0)
    
    iTrail = [];
    iLead  = [];
    s      = 1;
    e      = dimP(2);
    c      = abs(ind(iSam));
    if (ind(iSam) < 0)
        iLead  = leadSection(iSam,ones(1,c),xtraDimInd{:});
        e      = e + ind(iSam);
    else
        iTrail = trailSection(iSam,ones(1,c),xtraDimInd{:});
        s      = ind(iSam) + 1;
    end
    xP(iSam,:,xtraDimInd{:})  = cat(2,iLead,xP(iSam,s:e,xtraDimInd{:}),iTrail);

end


function [Xwarp,Shift,Values] = CC_FFTShift(T,X,Options)
% Calculate optimal rigid shift using Fast Fourier Transform
% Signals are expected to be on the rows (horizontal slabs).
%
% SYNTAX
% [Xwarp,Shift,Values] = CC_FFTShift(T,X,Options)
%
% IdimP(1)UT
% T      : target
% X      : signals
% Options: 1 x 4 vector. If element is NaN, the default value is used
%          (1) lower bound for shift
%          (2) upper bound for shift
%          (3) mode along which shift is to be determined (the last by default)
%          (4) Not used
%          (5) fill in value (default: NaN), -inf uses the previous/following point
%          (6) trimming for correlation (default: -Inf)
%
% OUTPUT
% Xwarp  : aligned signals
% Shifts : (i) shift for the i-th signal
% Values : (i + 1,j) cost function for the i-th signal and shift (j),
%          the first row contains the investigated shifts
%
% Author: Giorgio Tomasi
%         giorgio.tomasi@gmail.com
%
% Created      : August 2006

if (~ismatrix(X)), error('Multiway arrays cannot be handled'); end
dimX    = size(X);
dimT    = size(T);

if nargin < 3, Options = []; end

% Default options, max shift is half the target's length
OptionsDefault                          = [-fix(dimT(end) * 0.5),fix(dimT(end) * 0.5) ndims(T) 1 NaN,-Inf];
Options(end + 1:length(OptionsDefault)) = OptionsDefault(length(Options) + 1:length(OptionsDefault));
Options(isnan(Options))                 = OptionsDefault(isnan(Options));
if Options(1) > Options(2), error('Lower bound for shift is larger than upper bound'), end
TimeDim = Options(3);
if not(isequal(dimT([2:TimeDim - 1,TimeDim + 1:end]),dimX([2:TimeDim - 1,TimeDim + 1:end])))
    error('Target and signals do not have compatible dimensions')
end
Xnorm             = sqrt(SumwNaN(X.^2,TimeDim));
Xnorm(Xnorm == 0) = 1; % Deals with signals of just zeros
X_fft             = bsxfun(@rdivide,X,Xnorm);
Tnorm = sqrt(SumwNaN(T.^2,TimeDim));
Tnorm(Tnorm == 0) = 1; % Deals with signals of just zeros
T     = bsxfun(@rdivide,T,Tnorm);
nP    = dimX(TimeDim);
mP    = dimX(1);
nT    = dimT(TimeDim);
if (TimeDim ~= 2)
    ord       = [1 TimeDim 2:(TimeDim - 1), TimeDim + 1:ndims(X)];
    iord(ord) = 1:ndims(X);
end

% Remove leading NaN's
flag_miss = any(isnan(X_fft(:))) || any(isnan(T(:)));
if flag_miss
    
    if (~ismatrix(X)), warning('Multidimensional handling of missing not tested'), end
    MissOff = NaN(1,mP);
    if (TimeDim ~= 2)
        X_fft = permute(X_fft,ord);
        T     = permute(X_fft,ord);
    end
    for i_signal = 1:size(X_fft,1)
        
        Limits = RemoveNaN([1,nP],X_fft(i_signal,:,:),@all);
        if ~isequal(size(Limits),[1,2]), error('Missing values can be handled only if leading or trailing in a sample'); end
        if any(cat(2,Limits(1),mP - Limits(2)) > max(abs(Options(1:2)))), error('Missing values band larger than largest admitted shift'); end
        MissOff(i_signal) = Limits(1);
        nPts              = Limits(2) - Limits(1) + 1;
        if (nPts < nP)
            if (MissOff(i_signal) > 1), X_fft(i_signal,1:nPts)  = X_fft(i_signal,Limits(1):Limits(2)); end
            X_fft(i_signal,nPts + 1:end) = 0; 
        end
        
    end
    Limits = RemoveNaN([1,nT],T(:,:,:),@all);
    if ~isequal(size(Limits),[1,2]), error('Missing values can be handled only if leading or trailing in the target)'); end
    nPts   = Limits(2) - Limits(1) + 1;
    if (nPts < nT)
        T(:,1:nPts)       = T(:,Limits(1):Limits(2));
        T(:,nPts + 1:end) = 0;
    end
    MissOff = MissOff - Limits(1);
    if (TimeDim ~= 2)
        X_fft = permute(X_fft,iord);
        T     = permute(T,iord);
    end
    
end

% Zero pad to avoid pollution (cf. Press & Teukolsky pg. 540 and 545)
pad = max(abs(Options(1:2)));

% Calculate cross-correlation
len_fft = max(nT,nP) + pad;
Shift   = Options(1):Options(2);
if (Options(1) < 0 && Options(2) > 0),      ind = [len_fft + Options(1) + 1:len_fft,1:Options(2) + 1];
elseif (Options(1) < 0 && Options(2) < 0),  ind = len_fft + Options(1) + 1:len_fft + Options(2) + 1;
elseif (Options(1) < 0 && Options(2) == 0), ind = [len_fft + Options(1) + 1:len_fft + Options(2),1];
else                                        ind = Options(1) + 1:Options(2) + 1;                       % Options(1) >= 0 && Options(2) > 0
end
X_fft = fft(X_fft,len_fft,TimeDim);
T_fft = fft(T,len_fft,TimeDim);
T_fft = conj(T_fft);
cc    = ifft(bsxfun(@times,X_fft,T_fft),len_fft,TimeDim);
cc    = cc(:,ind); %reshape(,[Options(2) - Options(1) + 1,prod(dimX(ord(2:end - 1))),dimX(1)]);
if (TimeDim ~= 2), cc = permute(cc,ord); end
if (isfinite(Options(6)) && Options(6) > -1 && Options(6) < 1 - 1e-2), cc = max(cc,Options(6)); end 
[~,pos]  = max(cc,[],2);
Values     = cat(1,Shift,cc);
Shift      = Shift(pos);
if flag_miss, Shift = Shift + MissOff; end
Xwarp      = NaN([dimX(1),dimT(2:end)]);
[ind,indw] = deal(repmat({':'},ndims(X),1));
for i_X = 1:dimX(1)
    
    ind{1}  = i_X;
    indw{1} = i_X;
    if Shift(i_X) >= 0
        
        ind{TimeDim}  = Shift(i_X) + 1:dimX(TimeDim);
        indw{TimeDim} = 1:(dimX(TimeDim) - Shift(i_X));
        if Options(5) == -inf
            ind{TimeDim}  = cat(2,ind{TimeDim},dimX(TimeDim(ones(1,abs(Shift(i_X))))));
            indw{TimeDim} = cat(2,indw{TimeDim},dimX(TimeDim) - Shift(i_X) + 1:dimX(TimeDim));
        end
        
    elseif Shift(i_X) < 0
        
        ind{TimeDim}  = 1:(dimX(TimeDim) + Shift(i_X));
        indw{TimeDim} = -Shift(i_X) + 1:dimX(TimeDim);
        if Options(5) == -inf
            ind{TimeDim}  = cat(2,ones(1,-Shift(i_X)),ind{TimeDim});
            indw{TimeDim} = cat(2,1:-Shift(i_X),indw{TimeDim});
        end
        
    end
    Xwarp(indw{:}) = X(ind{:});
    
end

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