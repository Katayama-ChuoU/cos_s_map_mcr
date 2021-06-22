function A = preprocessX(A,opt,varargin)
if (~opt(2)), return; end
switch opt(2)
    case 3
        if (size(A,1) > 1)
            A = reshape(msc(0,A(:,:)),size(A)); 
            if (opt(1)), fprintf(1,'\tMSC applied\n'); end
        end
        
    case 2
        A = bsxfun(@minus,A,min(A(:,:),[],2));
        if (opt(1)), fprintf(1,'\tInterval minimum subtracted\n'); end
        
    case 1
        A = bsxfun(@minus,A,MeanwNaN(A(:,:),2));
        A = bsxfun(@times,A,(sum(~isnan(A(:,:)),2) - 1)./sqrt(SumwNaN(A(:,:).^2,2)));
        if (opt(1)), fprintf(1,'\tSNV applied\n'); end
        
    otherwise % negative values
        A = locDiff(A,-opt(2),varargin{:}); % NOTE this is not optimal if information is available outside the boundaries; also, consider smoothing
        if (opt(1))
            if (opt(2) == -1), fprintf(1,'\tFirst derivatives calculated\n'); else fprintf(1,'\tSecond derivatives calculated\n'); end
        end
        
end

function Xd = locDiff(X,deg,varargin)
lead  = ones(1,ceil(deg/2));
trail = ones(1,floor(deg/2));
Xd    = diff(X,deg,2);
s     = size(Xd,2);
Xd    = Xd(:,[lead, 1:s, s(trail)],varargin{:});