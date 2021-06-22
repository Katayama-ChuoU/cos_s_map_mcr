function chInd = char2channels(ch,Channels)
    BADINTERVALS = 'Invalid channels intervals';
    OUTOFBOUNDARY = 'Out of boundary channel selection%s';
    ch      = regexp(ch,',','split');
    chRange = [Channels(1),Channels(end)];
    if (chRange(1) > chRange(2)), chRange = chRange([2 1]); end
    for (i = 1:length(ch)), ch{i} = genInter(ch{i}); end
    chInd = cat(2,ch{:});
   
    function inter = genInter(a)
        a = cellfun(@str2double,regexp(a,'-','split'));
        if (length(a) > 2), error('getChannels:badIntervals',BADINTERVALS); 
        elseif (length(a) == 1 && ( (a > chRange(2) || a < chRange(1)))), error('getChannels:outOfBoundary',OUTOFBOUNDARY,sprintf(' (single channel: %g)',a));
        elseif (length(a) > 1)
            a(a > chRange(2)) = chRange(2);
            a(a < chRange(1)) = chRange(1);
        end
        inter = scal2pts(a,Channels);
        if (length(inter) > 1)
            if (inter(1) < inter(2)), inter = inter(1):inter(2); else inter = inter(2):inter(1); end
            inter = inter(Channels(inter) >= a(1) & Channels(inter) <= a(2));
        end
        
    end

end