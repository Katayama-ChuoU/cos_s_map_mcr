function [US] = UpdateStruct(S, U, flag)
% Update structure S using fields in U.
%
% [US] = UpdateStruct(S, U, flag)
%
% INPUT
% S   : original structure
% U   : update
% flag: true (default) -> overwrite
%       false          -> do not overwrite (only add fields and copy if
%                         destination field is empty)
%
% OUTPUT
% US: updated structure.
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Created      : 25 February, 2008
% Last modified: 13 April, 2009; 16:06

if (numVersion(8)), narginchk(2,3), else argChk(2,3), end

if nargin < 3, flag = true; end
US        = S;
m         = numel(S);
n         = numel(U);
Ufields   = fieldnames(U);
Sfields   = fieldnames(S);
[~,b]     = setxor(Ufields,Sfields);
c         = intersect(Ufields,Sfields);
o         = n;
if m < n
   US                 = US(:);
   US(n).(Ufields{1}) = [];
   US                 = reshape(US,size(U));
elseif m > n
   if n == 1
      U = repmat(U,size(S));
      o = m;
   end
end
for i_f = 1:length(b)
   [US(1:o).(Ufields{b(i_f)})] = deal(U(1:o).(Ufields{b(i_f)})); 
end
for i_f = 1:length(c)
   for i_n = 1:o, US(i_n).(c{i_f}) = UpdateField(US(i_n).(c{i_f}),U(i_n).(c{i_f})); end
end

   function NSF = UpdateField(OSF,UF)
      if isstruct(OSF) && isstruct(UF), NSF = UpdateStruct(OSF,UF,flag);
      else

         if flag, NSF = UF;
         else
            if isempty(OSF), NSF = UF;
            else NSF = OSF;
            end
         end

      end
      
   end

end