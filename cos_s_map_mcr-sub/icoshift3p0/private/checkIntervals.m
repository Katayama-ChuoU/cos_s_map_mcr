function allint = checkIntervals(inter,mP)
if (length(inter) > 1)

    try allint = reshape(inter,[2,length(inter)/2])'; catch ME, error('icoshiftMC:badIntervals','Wrong definition of intervals ("inter")'); end
    if (max(allint(:,2),[],1) > mP), error('icoshiftMC:intervalOverflow','Intervals ("inter") exceed samples matrix dimension'); end
    sallint = sortrows(allint,1)';
    intdif  = diff(sallint(2:end));
    if any(intdif(1:2:end) < 0), uiwait(msgbox('The user-defined intervals are overlapping: is that intentional?','Warning','warn')); end
    allint  = cat(2,(1:size(allint,1))',allint,diff(allint,1,2) + 1);

else error('Debug: this error should never be reached!!!') % DEBUG
end
