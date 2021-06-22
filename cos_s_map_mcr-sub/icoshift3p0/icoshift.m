function [xCS,ints,ind,target] = icoshift(xT,xP,inter,n,options,Scal)
% interval Correlation Optimized shifting
%
% VERSION 3.0 beta
% 
% [xCS,ints,ind,target] = icoshift(xT,xP,inter[,n[,options[,Scal]]])
%
% Splits a spectral database into "inter" intervals and coshift each vector
% left-right to get the maximum correlation toward a reference or toward an
% average spectrum in that interval. Missing parts on the edges after
% shifting are filled with "closest" value or with "NaNs".
%
% INPUT
% xT (1 × mT)    : target vector.
%                  Use 'average' if you want to use the average spectrum as a reference
%                  Use 'median' if you want to use the median spectrum as a reference
%                  Use 'max' if you want to use for each segment the corresponding actual spectrum having max features as a reference
%                  Use 'average2' for using the average of the average multiplied for a requested number (default=3) as a reference
%
% xP (nP × mP)   : Matrix of sample vectors to be aligned as a sample-set
%                  towards common target xT
% inter          : definition of alignment mode
%                  'whole'         : it works on the whole spectra (no intervals).
%                  nint            : (numeric) number of many intervals.
%                  'ndata'         : (string) length of regular intervals
%                                    (remainders attached to the last).
%                  [I1s I1e,I2s...]: interval definition. ('I(n)s' interval
%                                    n start, 'I(n)e' interval n end).
%                  (refs:refe)     : shift the whole spectra according to a
%                                    reference signal(s) in the region
%                                    refs:refe (in sampling points)
%                  'refs-refe'     : shift the whole spectra according to a
%                                    reference signal(s) in the region
%                                    refs-refe (in Scal units)
% n (1 × 1)      : (optional)
%                  n = integer n.: maximum shift correction in data
%                                  points/Scal units (cf. options(5))
%                                  in x/rows. It must be >0
%                  n = 'b' (best): the algorithm search for the best n
%                                  for each interval (it can be time consuming!)
%                  n = 'f' (fast): fast search for the best n for each interval (default)
%                  A warning is displayed for each interval if "n" appears too small
% options (1 × 6): (optional) NaN uses the default.
%                  (1) triggers plots & warnings:
%                      0 : no on-screen output
%                      1 : only warnings (default)
%                      2 : warnings and plots
%                  (2) selects filling mode
%                      0 : using not a number
%                      1 : using previous point (default)
%                  (3) turns on Co-shift preprocessing
%                      0 : no Co-shift preprocessing (default)
%                      1 : Executes a Co-shift step before carrying out iCOshift
%                  (4) max allowed shift for the Co-shift preprocessing (default = equal to n if not specified)
%                      it has to be given in Scal units if option(5)=1
%                  (5) 0 : intervals are given in No. of datapoints  (deafult)
%                      1 : intervals are given in ppm --> use Scal for inter and n
%                  (6) 0 : use raw signals
%                      1 : apply SNV interval-wise prior to alignment
%                      3 : apply MSC interval-wise prior to alignment
%                     -n : use order n derivatives of signals for alignment (first or second derivative only - no smoothing)
% Scal           : vector of scalars used as axis for plot (optional)
%
% OUTPUT
% xCS  (nP × mT): shift corrected vector or matrix
% ints (nI × 4) : defined intervals (Int. No., starting point, ending point, size)
% ind  (nP × nI): matrix of indexes reporting how many points each spectrum
%                 has been shifted for each interval (+ left, - right)
% target (1 x mP): actual target used for the final alignment
%
% Authors:
% Francesco Savorani - Department of Food Science
%                      Quality & Technology - Spectroscopy and Chemometrics group
%                      Faculty of Sciences
%                      University of Copenhagen - Denmark
% email: frsa@food.ku.dk
%
% Giorgio Tomasi -     Department of Basic Science and Environment
%                      Soil and Environmental Chemistry group
%                      Faculty of Life Sciences
%                      University of Copenhagen - Denmark
% email: gito@plen.ku.dk

%% Constant
BLOCKSIZE      = 2^25; % To avoid out of memory errors when 'whole', the job is divided in blocks of 32MB

% Warnings
OLDMATLAB = 'The version of Matlab that you are using is old and this version of icoshift will work but might misbehave, please use the previous icoshift version (V 1.2) that you can download from www.models.life.ku.dk';

% Errors
EMPTYX              = 'The data array is empty';
MULTCH  = 'The data has only one channel. Consider icoshift instead for smaller overhead';

% Number of input arguments
if (~nargin), help4Empty(mfilename), return; end

% CHECK VERSION
matVersion = cellfun(@str2num,regexp(version,'^(\d+?\.\d+?).','tokens','once')) >= 8;
if (matVersion), narginchk(2,6);
elseif (nargin < 2), error('icoShift:tooFew','Not enough input arguments');
elseif (nargin > 6), error('icoShift:tooMany','Too many input arguments');
else warning('icoShift:oldMatlabVersion',OLDMATLAB);
end

%% Check input
dimX = size(xP);
isMD = length(dimX) > 2;
nP   = dimX(1);
mP   = dimX(2);
if (isempty(xP)), error('icoshiftMC:emptyX',EMPTYX);
elseif (isMD), warning('icoshiftMC:singleCh',MULTCH);
end

% Options
if (nargin < 5), options = []; end
options = checkOptions(options);

% Scal
useScal = false;
if (nargin < 6), Scal = [];  else useScal = options.useScal; end
if (~isempty(Scal)), [~,scalStr] = chkScal(Scal,mP,true); else scalStr = emptyStruct(); end

% Inter
if (nargin < 3), inter = 'whole'; end
if (useScal), [inter,pars] = getIntervals(inter,mP,emptyStruct(),scalStr); else [inter,pars] = getIntervals(inter,mP,emptyStruct(),emptyStruct()); end

% n
if (nargin < 4), n = []; end
[n,pars] = getN(n,pars,inter,scalStr);

% Target
[xT,pars] = getTarget(xT,xP,pars,options);

%% Execute preliminary coshift if so required
pars.COShift = ~pars.whole && options.preCOShift;
if (options.show && pars.COShift), xPo = xP; else xPo = []; end % Create a copy for plotting purposes
if (pars.COShift)
    
    if (options.show), h = waitbar(0,'Preliminary COShift ...'); end
    if (useScal && options.maxPreCOShift), options.maxPreCOShift = dscal2dpts(options.maxPreCOShift,scalStr.scal,scalStr.precision); end
    if (isnumeric(n)), options.maxPreCOShift = max(n,options.maxPreCOShift); 
    elseif (options.maxPreCOShift == 0), options.maxPreCOShift = n; 
    end
    if (pars.maxFlag), Target = 'average'; else Target = xT; end
    [xP,~,wint] = icoshift(Target,xP,'whole',options.maxPreCOShift,[0 1 0]);
    if (ischar(pars.note) && ~isempty(pars.note)), xT = getTarget(pars.note,xP,pars,options); end
    if (options.show) 
        waitbar(1,h,'Preliminary COShift ... done!'); 
        delete(h)
        drawnow
    end

else wint = [];
end

%% Missing values
[xT,xP,inter,~,flagNaN,InOr,frag] = nanCleanX(xT,xP,inter,pars);

%% Initalise
%  Define intervals and check for interval overlapping if necessary
if (pars.flag2), allint = [1, inter(1), inter(end), length(inter)]; else allint = checkIntervals(inter,mP); end

%% ALIGN
if (options.show), home; end
optionsVec = [options.show,options.fill,NaN,BLOCKSIZE,-Inf,options.alignPreprocessed];

% Initial message
if (options.show)
    if (pars.flag2), str = 'the reference window "refW"'; else str = 'each interval'; end
    if     strcmpi(n,'b'), fprintf('\n Automatic searching for the best "n" for %s enabled \n It can take a longer time \n',str)
    elseif strcmpi(n,'f'), fprintf('\n Fast automatic searching for the best "n" for %s enabled \n',str)
    end
end

target4plot = NaN(size(xT));
if (pars.flag2) % Use reference window

    [ind,xCS,target] = localAlign(xP,xT,n,optionsVec,pars.maxFlag,inter);
    if (pars.maxFlag), [xT(:,inter),target4plot(:,inter)] = deal(target(:,inter));
    elseif (pars.avg2Flag)
        if (options.show), fprintf('\tCo-shifting again the %s in the %g samples... \r',str,nP); end
        target1                            = MeanwNaN(xCS(:,inter),1);
        [xT(:,inter),target4plot(:,inter)] = deal((target1 - max(0,min(target1(1,:),[],2))).*pars.avgPower); %AVG2 power multiplier and baseline correction
        [ind,xCS,~]                        = localAlign(xP,xT,n,optionsVec,false,inter);
    end

else
    
    xCS  = xP;
    nint = size(allint,1);
    ind  = zeros(nP,nint);
    for i = (1:nint)    % Local co-shifting
        
        if (options.show);
            home
            if pars.whole, fprintf('\n Co-shifting the whole %g samples... \r',nP); else fprintf('\n Co-shifting interval no. %g of %g... \r',i,nint); end
        end
        a                            = allint(i,2):allint(i,3);
        [ind(:,i),xCS(:,a,:),target] = localAlign(xP(:,a),xT(:,a),n,optionsVec,pars.maxFlag);
        if (pars.maxFlag), [xT(:,a),target4plot(:,a)] = deal(target);
        elseif (pars.avg2Flag)

            if (options.show)
                if (pars.whole), fprintf('\tCo-shifting again the whole %g samples... \r',nP);
                else fprintf('\tCo-shifting again interval no. %g of %g... \r',i,size(allint,1));
                end
            end
            target1                     = MeanwNaN(xCS(:,a),1);
            [ind(:,i),xCS(:,a),xT(:,a)] = localAlign(xP(:,a),(target1 - max(0,min(target1(1,:)))) .*pars.avgPower,n,optionsVec,false);
            target4plot(:,a)            = xT(:,a);
        else target4plot(:,a,:)             = xT(:,a); % NOTE: is this necessary?            
        end
        
    end
        
end

% If n == 'whole' and some values are missing, reconstruct signal
if (frag), xCS = reconstructX(xCS,xPo,ind,InOr,flagNaN,dimX,pars,options); end
if (pars.COShift), ind = bsxfun(@plus,ind,wint); end
target = xT;
ints   = allint;
if (options.show == 2), plotICOShift(target4plot,xP,xPo,xCS,ints,ind,scalStr,pars); end

function xRec = reconstructX(xCS,Ind,InOr,flagNaN,dimX,~,~)
xRec = NaN(dimX(1:2));
for i_sam = 1:dimX(1)
    
    for i_seg = 1:size(InOr,1)
        
        xRec(i_sam,InOr(i_seg,1):InOr(i_seg,2),:) = xCS(i_sam,InOr(i_seg,3):InOr(i_seg,4),:);
        if Ind(i_sam) < 0
            if flagNaN(i_seg,1,i_sam), xRec(i_sam,InOr(i_seg,1):InOr(i_seg,1) - Ind(i_sam),:) = NaN; end
        elseif Ind(i_sam) > 0
            if flagNaN(i_seg,2,i_sam), xRec(i_sam,InOr(i_seg,2) - Ind(i_sam) + 1:InOr(i_seg,2),:) = NaN; end
        end
        
    end
    
end


function s = emptyStruct()
s = rmfield(struct('a',cell(0)),'a');

function B = getMaxTarget(A)
[~,bmax] = max(sum(sum(A,3),2));
B        = A(bmax,:,:);

function [loc_ind,A,target] = localAlign(A,T,n,optionsVec,flag,inter)
if (nargin < 6), inter = 0; end
if (flag)
    
    if (length(inter) > 1 || inter > 0) % Second condition is trivial, a one point reference hardly makes sense
        target            = T;
        target(:,inter,:) = getMaxTarget(A(:,inter,:));
    else target = getMaxTarget(A);
    end
    
else target = T;
end
missInd = ~all(isnan(A(:,:)),2);
loc_ind = NaN(size(A,1),1);
if (~all(isnan(target(1,:))) && any(missInd)), [A(missInd,:,:),loc_ind(missInd)] = coshifta(target,A(missInd,:,:),inter,n,optionsVec); end

% to be fixed:
% 3) warning for wrong selected scale (outside scale boundaries)
% 4) ...