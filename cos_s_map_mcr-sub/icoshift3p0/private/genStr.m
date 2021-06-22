function s = genStr(Shifts,name,val)
nInt = size(Shifts,2);
if (nargin < 3)
    
    if (iscellstr(name))
        s = cell(nInt,length(name));
        for (i = 1:length(name)), s(:,i) = genStr(Shifts,name{i}); end
        s = mat2cell(s',length(name),ones(nInt,1));
        return
    else val(1,:) = feval(name,Shifts); 
    end
    
end
T      = bsxfun(@eq,Shifts,val(1,:));
indT = all(~T,1);
if (any(indT))
   for (i = find(indT))
       [~,b] = min(abs(Shifts(:,i) - val(1,i)),[],1);
       T(:,i) = Shifts(:,i) == Shifts(b,i);
   end
end
[bm,cm] = find(T);
if (size(val,1) == 1 || all(isnan(val(2,:)),2)), val(2,:) = bm([1;find(diff(cm)) + 1]'); end
aa = accumarray(cm,1,[nInt,1]) - 1;% Count n. of additional samples
s  = regexp(sprintf(sprintf('%s: %%g (Sample #%%i and %%i more);',name),cat(1,val,aa')),';','split');
s  = strrep(s(1:end -1),' and 0 more','');

end