function [Xcoshift] = ApplyiCoshift(X, Inter, Shifts, Flag, Mode)
% Apply iCOshift to a set of samples
%
% [Xcoshift] = ApplyiCoshift(X, Inter, Shifts)
%
% INPUT
% X     : data array
% Inter : nI × 3 intervals definitition (second output from icoshift) or
%         NaN: use shift to correct the entire signal
% Shifts: nS × nI corrections for the nS samples and nI intervals (third output from icoshift)
% Flag  : true  -> fill in with first/last point
%         false -> fill in with NaN
% Mode  : mode in which the shift is to be applied
%
% OUTPUT
% Xcoshift:
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Created      : 25 September, 2009; 09:20
% Last modified: 25 September, 2009; 15:43 

% HISTORY
% 0.00.01 25 Sep 09 -> Generated function with blank help

error(nargchk(3,5,nargin))
if nargin < 4, Flag = true; end
if nargin < 5, Mode = ndims(X); end
dimX = size(X);
if Mode > ndims(X), error('The specified mode exceeds the array''s order'), end
ord      = [Mode,2:Mode - 1,Mode + 1:ndims(X),1];
X        = permute(X,ord);
dimXper  = dimX(ord);
X        = reshape(X,[dimXper(1),prod(dimXper(2:end - 1)),dimXper(end)]);
Xcoshift = X;
if isnan(Inter(1)), Inter = [1 1 size(X,1)]; end
if size(Shifts,1) == 1 && dimX(1) > 1; Shifts = Shifts(ones(dimX(1),1),:); end
if ~isequal(size(Inter),[size(Shifts,2) 4]); error('Interval definition matrix must have size nI × 3'); end
if ~isequal(size(Shifts,1),dimX(1)), error('Shifts matrix is not compatible with X'); end
if min(Inter(:,2)) < 0 || max(Inter(:,3) > size(X,1)), error('Intervals exceed the array dimension'), end    
for i_seg = Inter(:,1)'
    
    ShiftsSeg  = Shifts(:,i_seg);
    n          = max(abs(ShiftsSeg));
    len        = Inter(i_seg,3) - Inter(i_seg,2) + 1;
    Xseg       = X(Inter(i_seg,2):Inter(i_seg,3),:,:);
    temp_index = -n:n;
    if Flag , Ashift = cat(1,Xseg(ones(1,n),:,:),Xseg,Xseg(len(ones(1,n)),:,:));
    else      Ashift = cat(1,NaN(n,size(Xseg,2),size(Xseg,3)),Xseg,NaN(n,size(Xseg,2),size(Xseg,3)));
    end
    for i_sam = 1:size(X,3)
        index                                           = find(temp_index == ShiftsSeg(i_sam));
        Xcoshift(Inter(i_seg,2):Inter(i_seg,3),:,i_sam) = Ashift(index:index + len - 1,:,i_sam);        
    end
    
end
dimXper(1) = size(Xcoshift,1);
Xcoshift   = reshape(Xcoshift,dimXper);
ord(ord)   = 1:length(dimXper);
clear X
Xcoshift   = permute(Xcoshift,ord);
