function [ch,FUN,pars] = getChannels(ch,len,options,pars,chStruct)
% useChannels    : #1  'corrProd'                : maximise product of cross-correlations across channels
%                  #2  'corrSum'                 : maximise sum of cross-correlations across channels
%                  #3  'corrMax'                 : maximise max of cross-correlations across channels
%                  #4  'corrTrimSum'             : maximise trimmed sum of correlations across channels
%                  #5  'corrTrimProd'            : maximise trimmed product of correlations across channels
%                  #6  'sum'                     : icoshift of sum of all the channels (default)
%                  #7  'max'                     : icoshift toward maximum across channels (a.k.a. base peak - claimed to reduce the baseline effect)
%                  #8  [ch1, ch2,...]            : use channels ch1, ch2 ...
%                  #9  'ch1, ... ch10-ch13,...'  : (requires Channels), use the channels and ranges specified
%                  #10 {%ch%,%opt%}              : use %opt% criterion instead of 'sum' on channels as selected in %ch%

FUN     = 'sum';
METHODS = {'corrProd','corrSum','corrMax','corrTrimSum','corrTrimProd','sum','max'};
BADCELL = 'If useChannels is passed as a cell, it must have two non-empty elements: a list of channels and a "function"';
BADMETHOD = 'Bad channel optimality criterion (cf. help)';
AMBIGUOUSMETHOD = 'Not enough character to unambiguously determine the multichannel optimality criterion';
MISSINGCHANNELS = 'Channel scalars vector must be available when channel scalars are used for selection';
OUTOFBOUNDARY = 'Out of boundary channel selection%s';
BADCHANNELS   = 'Invalid channel selection: %s';
checkScal   = ~ischar(ch);
if (~isempty(chStruct)), Channels    = chStruct.scal; % For legibility
end
if (isa(ch,'cell'))
    
    if (~(isequal(length(ch),numel(ch),2) && ischar(ch{2}))), error('getChannels:badCell',BADCELL); end
    FUN = ch{2};
    ch  = ch{1};
    if (ischar(ch))
        
        if (any(regexp(ch,'^\d','once'))) 
           if (nargin < 5 || isempty(Channels)), error('getChannels:missingChannels',MISSINGCHANNELS); end
           ch = char2channels(ch,Channels);  
           checkScal = false;
        elseif (strcmp(ch,':')), checkScal = false;
        else error('getChannels:badMethod',BADMETHOD)
        end
        
    end
    
elseif (ischar(ch)), 
    
    if (any(regexp(ch,'^\d','once'))) 
       if (nargin < 5 || isempty(Channels)), error('getChannels:missingChannels',MISSINGCHANNELS); end
       ch = char2channels(ch,Channels);  
    else
        FUN = ch;
        ch  = ':';
    end
    
end
if (ischar(FUN))
    
    FUN = find(strncmpi(FUN,METHODS,length(FUN)),2,'first');
    if (~any(FUN)), error('getChannels:badMethod',BADMETHOD);
    elseif (length(FUN) == 2), error('getChannels:ambiguousMethod',AMBIGUOUSMETHOD)
    end
    FUN = METHODS{FUN};
    
elseif (isa(FUN,'function_handle'))
    if (nargin(FUN) == 0 || nargout(FUN) == 0), error('getChannels:badMethod',BADMETHOD); end
else error('getChannels:badMethod',BADMETHOD); 
end
if (checkScal)
    
    if (options.useChannelScal)
        chMin = min(Channels);
        chMax = max(Channels);
        if (any(ch > chMax) || any(ch < chMin)), error('getChannels:outOfBoundary',OUTOFBOUNDARY,' (check channel scalars)'); end
        ch = scal2pts(ch,Channels,chStruct.precision);
    elseif (any(ch > len(3)) || any(ch < 1)), error('getChannels:outOfBoundary',OUTOFBOUNDARY,'');
    elseif (any(fix(ch) ~= ch)), error('getChannels:badChannels',BADCHANNELS,' indices must be integers')
    end
    
end 
pars.syntCh = isa(FUN,'function_handle') || ~any(regexp(FUN,'^corr','once'));
pars.redSet = pars.syntCh || ~(strcmp(ch,':') || isequal(ch,1:length(Channels)));

end

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
