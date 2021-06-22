function [xT,xP,inter,intern,flag_nan,InOr,frag] = nanCleanX(xT,xP,inter,pars)
BADNANPATTERN       = 'The missing values pattern cannot be handled by this version of icoshiftMC';
frag            = false;
[flag_nan,InOr] = deal([]);
intern          = inter;
Ref             = @(c) reshape(c,2,length(c)/2)';
anyMiss         = isnan(xT(1,:));
missA           = any(any(bsxfun(@ne,anyMiss,isnan(xP(:,:)))));
if (any(anyMiss) || missA)
    
    % If there are missing values in the target, check that the same pattern
    % of missing is present in the samples. If not an error is produced.
    if (missA), Select = @any; else Select = @all; end
    if (pars.flag2)
        
        intern = RemoveNaN([1,inter(end) - inter(1) + 1],cat(1,xT(:,inter),xP(:,inter)),Select); % We assume that inter is sorted so that inter(1) < inter(end)
        if size(intern,1) ~= 1, error('Reference region contains a pattern of missing that cannot be handled consistently')
        elseif ~isequal(intern,[1,inter(end) - inter(1) + 1]), warning('iCoShift:miss_refreg','The missing values at the boundaries of the reference region will be ignored')
        end
        intern = inter(1) + intern(1) - 1:inter(1) + intern(2) - 1;
        
    else
        [intern,flag_nan] = RemoveNaN(Ref(inter),cat(1,xT,xP),Select);
        intern            = intern(:)';
    end
    if isempty(intern), error('iCoShift:badNaNPattern',BADNANPATTERN), end
    if length(intern) ~= length(inter) && ~pars.flag2
        
        if pars.whole
            
            if length(intern) > 2
                
                [XSeg,InOr] = ExtractSegments(cat(1,xT,xP),Ref(intern));
                inter       = [InOr(1),InOr(end)];
                InOr        = cat(2,Ref(intern),InOr);
                xP          = XSeg(2:end,:,:);
                xT          = XSeg(1,:,:);
                frag        = true;
                
            end
            
        else
            warning('iCoShift:Missing_values','\nTo handle the pattern of missing values, %i segments are created/removed',abs(length(intern) - length(inter))/2)
            inter = intern;
        end
        
    end
    
end

function [XSeg,SegNew] = ExtractSegments(X, Segments)
% Extract segments from signals
%
% [XSeg] = ExtractSegments(X, Segments)
%
% INPUT
% X       : (n × p) data matrix
% Segments: (s × 2) segment boundary matrix
%
% OUTPUT
% XSeg: (n × q) data matrix in which segments have been removed
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Created      : 23 March, 2009; 07:51
% Last modified: 23 March, 2009; 15:07

% HISTORY
% 0.00.01 23 Mar 09 -> Generated function with blank help
% 1.00.00 23 Mar 09 -> First working version

% Some initialisations
dimX  = size(X);
ind   = {':'};
ind   = ind(1,ones(ndims(X) - 2,1));
Sd    = diff(Segments,1,2) + 1;
q     = sum(Sd + 1);
[s,t] = size(Segments);

% Check input
% error(nargchk(2,2,nargin,'struct'))
if (exist('narginchk','builtin')),narginchk(2,2); elseif (nargin ~= 2), error('ExtractSegments:badInput','Invalid number of input parameters'); end

flag_si = t ~= 2;
flag_in = any(Segments(:) ~= fix(Segments(:)));
flag_ob = any(Segments(:,1) < 1) || any(Segments(:,2) > dimX(2));
flag_ni = any(diff(Segments(:,1)) < 0) || any(diff(Segments(:,2)) < 0);
flag_ab = any(Sd < 2);
if flag_si, error('Segment boundary matrix must have two columns'), end
if flag_in, error('Segment boundaries must be integers'), end
if flag_ob, error('Segment boundaries outside of segment'), end
if flag_ni, error('Segments boundaries must be monotonically increasing'), end
if flag_ab, error('Segments must be at least two points long'), end

% Initialise output
if nargout > 0, XSeg = NaN([dimX(1),q,dimX(3:end)]); else return, end

% Calculate Segments
cdim = cat(1,0,cumsum(Sd));
for i_seg = 1:s
    XSeg(:,cdim(i_seg) + 1:cdim(i_seg + 1),ind{:}) = X(:,Segments(i_seg,1):Segments(i_seg,2),ind{:});
end
if nargout > 1, SegNew = cat(2,cdim((1:s)') + 1,cdim((2:s + 1)')); end
