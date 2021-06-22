function [inter,Flags] = getIntervals(inter,mP,Flags,scalStr)
BADINTERVALS        = 'Number of intervals "inter" must be smaller than number of variables in xP';

Flags(1).whole   = ischar(inter) && strcmpi(inter,'whole');
Flags(1).flag2   = false;
Flags(1).allsegs = false;
useScal          = nargin > 3 && ~isempty(scalStr); % Converts scalars to points
if (numel(inter) == 1 && isnumeric(inter) && inter >= mP); error('icoShift:badIntervals',BADINTERVALS); end
if (useScal) % For legibility
    prec = scalStr.precision;
    Scal = scalStr.scal;
end
if (Flags(1).whole), inter = [1,mP];
elseif (ischar(inter))
    
    interv = cellfun(@str2double,regexp(inter,'-','split'));
    Flags(1).flag2   = length(interv) == 2;
    Flags(1).allsegs = length(interv) == 1;
    if (length(interv) == 1)

        if (useScal), interv = dscal2dpts(interv,Scal,prec); else interv = round(interv); end
        inter = 1:interv - 1:mP;
        inter = [inter(1:end - 1);inter(2:end)];
        if (inter(end) ~= mP)
            
            inter(end) = mP;
            if (options(1))
                mbx = {sprintf('Warning: the last interval will not fulfill the selected intervals size "inter" = %i',interv)
                    sprintf('Size of the last interval = %i',interv + mP - inter(end))};
                if (options(1) == 2), uiwait(msgbox(mbx,'Warning','warn')); else warning('icoshift:varIntervals','%s\n%s',mbx{:}); end
            end
            
        end
        
    elseif (length(interv) == 2)
        if (useScal), interv = scal2pts(interv,Scal,prec); end
        interv = sort(interv);
        inter = interv(1):interv(2);
    else error('Invalid range for reference signal')
    end
    
elseif isa(inter,'numeric')
    
    Flags.allsegs = numel(inter) == 1;
    Flags.flag2   = length(inter) > 1 && isequal(inter,inter(1):sign(diff(inter(1:2))):inter(end));
    if (Flags.allsegs)
        
        if fix(inter) == inter % Distributes vars_left_over in the first "vars_left_over" intervals
            
            remain   = mod(mP,inter);
            N        = fix(mP/inter);
            startint = [(1:(N+1):(remain - 1)*(N+1)+1)'; ((remain - 1) * (N + 1) + 1 + 1 + N:N:mP)'];
            endint   = [startint(2:inter); mP]; % ints with common edges
            inter    = [startint endint]';
            inter    = inter(:)';
            
        else error('The number of intervals must be an integer');
        end
        
    elseif (~Flags.flag2 && useScal)
        
        inter = scal2pts(inter,Scal,prec);
        if any(inter(1:2:end) > inter(2:2:end)) && Scal(2) < Scal(1)
            inter = flipud(reshape(inter,2,length(inter)/2));
            inter = inter(:)';
        end
        
    end 
    
end