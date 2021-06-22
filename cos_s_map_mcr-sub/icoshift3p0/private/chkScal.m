function [flagDirect,scalStr] = chkScal(Scal,len,flag)
if (nargin < 2), flag = false; end
BADSCAL             = '%s must be a vector having the same length as the corresponding dimension';
NONMONOTONICSCALARS = '%s must be strictly monotonic';
DISCONTINUOUSSCAL   = '%s vector is not continuous, the defined intervals might not reflect actual ranges';
name                = inputname(1);
if (~(isnumeric(Scal) && isequal(numel(Scal),length(Scal),len))), error('icoShift:badScalarVec',BADSCAL,name); end
dScal   = diff(Scal);
incScal = sign(dScal(1));
if incScal == 0 || ~all(sign(dScal) == incScal), error('chkScal:nonMonotonicScalarVec',NONMONOTONICSCALARS,name); end
flagDirect = incScal > 0;
prec       = abs(median(unique(dScal)));
if (flag && any(abs(dScal) > 2 * min(abs(dScal)))), warning('chkScal:discontinuousScalarVec',DISCONTINUOUSSCAL,name); end
scalStr = struct('scal',Scal(:)','precision',prec,'scalDir',flagDirect); % Ensures that the scalars are on a row vector