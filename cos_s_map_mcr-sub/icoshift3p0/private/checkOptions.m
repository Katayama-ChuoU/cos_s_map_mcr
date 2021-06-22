function options = checkOptions(options)
persistent BADOPTIONS ERRORSTR OPTIONNAMES DEFAULTOPTIONS isLog
if (isempty(ERRORSTR))
    
    BADOPTIONS     = 'Options%s must be %s';
    DEFAULTOPTIONS = struct('show',1,'fill',1,'preCOShift',0,'maxPreCOShift',0,'useScal',0,'alignPreprocessed',0);
    OPTIONNAMES    = fieldnames(DEFAULTOPTIONS);
    ERRORSTR = struct('show','0, 1 or 2',...
                      'fill','0 or 1',...
                'preCOShift','0 or 1',...
                   'useScal','0 or 1',...
         'alignPreprocessed','0 or 1');
    isLog = @(a) islogical(a) || a == 0 || a == 1;
    
end
if (~nargin), options = DEFAULTOPTIONS; return, end
numericOptions = isnumeric(options);
if (numericOptions)
    
    if (length(options) ~= numel(options)), error('icoShift:badOptions',BADOPTIONS,'','a numerical vector'); end
    optionsNew = DEFAULTOPTIONS;
    for (i = 1:length(options)) 
        if (~isnan(options(i))), optionsNew.(OPTIONNAMES{i}) = options(i); end
    end
    options = optionsNew;
    
elseif (~isstruct(options)), error('icoShift:badOptions',BADOPTIONS,'','a structure');
else
    
    for (i = 1:length(OPTIONNAMES))
        name  = OPTIONNAMES{i};
        if (~isfield(options,name) || isnan(options.(name))), options.(name) = DEFAULTOPTIONS.(name); end
        if (~(isnumeric(options.(name)) && numel(options.(name)) == 1)),  error('icoShift:badOptions',BADOPTIONS,['.',name],'a scalar'); end
    end
    
end
try
    
    if (~any(0:2 == options.show)),                                     error('show');              end
    if (~any(-2:3 == options.alignPreprocessed)),                       error('alignPreprocessed'); end
    if (~isLog(options.fill)),                                          error('fill');              end
    if (~isLog(options.preCOShift)),                                    error('preCOShift');        end
    if (~isLog(options.useScal)),                                       error('useScal');           end
    
catch ME
    error('icoShift:badOptions',BADOPTIONS,genErrorName(ME.message),ERRORSTR.(ME.message))
end

    function errStr = genErrorName(str)
        if (numericOptions), errStr = sprintf('(%i)',find(strcmp(OPTIONNAMES,str))); else errStr = sprintf('.%s',str); end
    end

end