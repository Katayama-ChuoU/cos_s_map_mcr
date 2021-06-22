function [X,Xmeancal]=msc(option,X,target,vek)
%
%   [Xmsc,Xmeancal]=msc(option,X,vek);
%
%   Multiplicative Scatter Correction
%
%   option==0      only offset correction
%   option==1      full msc correction
%   vek            the spectral region to operate on
%
%   SBE-97

[n,m]=size(X);

if (nargin < 4 || isempty(vek)), vek= 1:m; end

if (nargin < 3 || isempty(target)), Xmeancal = mean(X(:,vek),1);
else Xmeancal = target(vek);
end
if (option == 0)
    for i = 1:n
        coef   = polyfit(Xmeancal,X(i,vek),0);
        X(i,:) = X(i,:) - coef(1);
    end
elseif (option == 1)
    for i = 1:n
        coef   = polyfit(Xmeancal,X(i,vek),1);
        X(i,:) = (X(i,:) - coef(2)) / coef(1);
    end
elseif (option > 1)
    
    for i=1:n
        coef   = polyfit(Xmeancal,X(i,vek),2);
        disc   = coef(2) * coef(2) - 4 * coef(1) * (coef(3) - X(i,:));
        X(i,:) = (-coef(2) + sqrt(disc)) / (2 * coef(1));        
    end
    
end
