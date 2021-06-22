function [An,flag] = RemoveNaN(B, Signal, Select)
% Rearrange segments so that they do not include NaN's
%
% [Bn] = RemoveNaN(B, Signal, Select)
%
% INPUT
% B     : (p × 2) Boundary matrix (i.e. [Seg_start(1) Seg_end(1); Seg_start(2) Seg_end(2);...]
% Signal: (n × 2) Matrix of signals (with signals on rows)
% Select: (1 × 1) function handle to selecting operator
%                 e.g. @any (default) eliminate a column from signal matrix
%                                     if one or more elements are missing
%                      @all           eliminate a column from signal matrix
%                                     if all elements are missing
%
% OUTPUT
% An  : (q × 2)     new Boundary matrix in which NaN's are removed
% flag: (q × 2 × n) flag matrix if there are NaN before (column 1) or after (column 2)
%                   the corresponding segment in the n signals.
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Created      : 25 February, 2009

% HISTORY
% 1.00.00 09 Mar 09 -> First working version
% 2.00.00 23 Mar 09 -> Added output for adjacent NaN's in signals
% 2.01.00 23 Mar 09 -> Added Select input parameter
% 3.00.00 11 May 15 -> Adapted to the multichannel case

% error(nargchk(2,3,nargin))
matVersion = cellfun(@str2num,regexp(version,'^(\d+?\.\d+?).','tokens','once')) >= 8; 
if (matVersion); narginchk(2,3)
elseif (nargin < 2), error('not enough input arguments')
elseif (nargin > 3), error('too many input arguments')
end
if nargin < 3, Select = @any; end
C      = NaN(size(B));
count  = 0;
if (~islogical(Signal)), Signal = isnan(Signal); end
anyMiss = any(Select(Signal(:,:,:),1),3); % Collapses the array to 3 dimensions for multichannel
for i_el = 1:size(B,1)
    
    ind     = B(i_el,1):B(i_el,2);
    len     = B(i_el,2) - B(i_el,1) + 1; 
    in      = anyMiss(ind);
    if any(in)
        
        p = diff([0 in],1,2);
        a = find(p < 0);
        b = find(p > 0) - 1;
        if (in(1)), b = b(2:end);
        elseif (a(1) ~= 1), a = cat(2,1,a);
        end
        if (~in(end) && b(end) ~= len), b = cat(2,b,len); end
        C(count + 1:count + length(a),:) = ind(cat(2,a(:),b(:)));
        count = count + length(a);
        
    else
        count      = count + 1;
        C(count,:) = B(i_el,:);
    end
    
end
An = C;
if nargout > 1
    
    flag            = false(size(C,1),2,size(Signal,1));
    Cinds           = C(:,1) > 1;
    Cinde           = C(:,2) < size(Signal,2);
    flag(Cinds,1,:) = any(Signal(:,C(Cinds,1) - 1,:),3)';
    flag(Cinde,2,:) = any(Signal(:,C(Cinde,2) + 1,:),3)';
    
end
