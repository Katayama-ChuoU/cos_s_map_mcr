function Position = getPointer(hObject,Units)
% Get position of the pointer in the desired units
if (numVersion(8)), narginchk(1,2), else argChk(1,2), end
if (~(ishghandle(hObject) && any(strcmp(get(hObject,'type'),{'root','figure','axes'})))), error('Invalid handle'); end
if (nargin < 2), Units = get(hObject,'Units'); end
typeObj = get(hObject,'type');
if (~strcmp(typeObj,'axes')) 
    oldUnits = get(hObject,'Units');
    set(hObject,'Units',Units)
end
if (strcmp(typeObj,'root')), Position = get(hObject,'PointerLocation');
else Position = get(hObject,'CurrentPoint');
end
if (~strcmp(typeObj,'axes')), set(hObject,'Units',oldUnits); end

end
