function dispInfo(varargin)
% Displays the 'tag' (or the 'userdata' if a cell vector of strings).
% The tag remains visible on the plot for 5 seconds (the time can be
% changed setting the DispInfoDelay property of the figure). It changes
% linewidth and color for the same amount of time as to highlight the object.
%
% dispInfo(Handle);
%
% Inputs:
% Handle: handle of the object whose tag is to be displayed (optional). Callback object is used if Handle
%         is not specified
%
% Outputs:
% None
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
%
% Created      : 05 March, 2003

% Last modified: 19 May,   2015

if nargin < 1, hObject = gcbo; else hObject = varargin{1}; end
hParent = ancestor(hObject,{'axes'});
ex      = getappdata(hObject,'Extra');

skipToolTip = nargin > 1 && ischar(varargin{2}) && strcmp(varargin{2},'noToolTip');

% object type
if strcmp(get(hObject,'type'),'line'),      objProperties = {'LineWidth',get(hObject,'linewidth'),'Color',get(hObject,'Color')};
elseif strcmp(get(hObject,'type'),'patch'), objProperties = {'LineWidth',get(hObject,'linewidth'),'EdgeColor',get(hObject,'EdgeColor')};
else error('Invalid object for dispInfo');
end

% Check selection type
selType = get(ancestor(hParent,'figure'),'SelectionType');
anyOpenFUN = isappdata(hParent,'openPlotFUN');
if (strcmp(selType,'alt') && anyOpenFUN)
    
    FUN = getappdata(hParent,'openPlotFUN');
    if (~(isempty(FUN) || (isappdata(hObject,'noOpen')  && getappdata(hObject,'noOpen'))))
        feval(FUN,hObject);
        return
    end
    
end

% "Tooltip"
dispText = strrep(get(hObject,'Tag'),'_','\_');
if (isappdata(hObject,'dispInfo')), t = getappdata(hObject,'dispInfo');
else t = get(hObject,'userdata'); % Legacy
end
if (~isempty(t) && (ischar(t) || iscellstr(t))), dispText = t; end
if (~(isempty(dispText) || skipToolTip))
    
    if (anyOpenFUN && (~(isappdata(hObject,'noOpen') && getappdata(hObject,'noOpen')))), 
        dispText = cat(1,cellstr(dispText),'\fontsize{7}Keep \bfCtrl\rm pressed to open'); 
    end
    t = getPointer(ancestor(hObject,'figure'),'points');
    hAxes = axes('units','points','position',[t,50,10],'box','on','xtick',[],'ytick',[],'visible','off');
    b = text(.51,.5,dispText,'verticalalignment','middle','horizontalalignment','center','fontsize',9);
    c = getExtent(b,'points');
    set(hAxes,'position',[t,c(3) * 1.05 c(4) * 1.2],'visible','on')
    
else hAxes = [];
end

% Update
newProps = objProperties;
if isequal(newProps{4},'r') || isequal(newProps{4},[1 0 0]), newProps{4} = [0 0 0.8]; else newProps{4} = 'r'; end
newProps{2} = newProps{2} + 1;
set(hObject,newProps{:})

% If extended, the change is permanent
if (strcmp(selType,'extend')), objProperties = newProps; end

% Set timer
hCopy = copyobj(hObject,get(hObject,'Parent'));
set(hObject,'HitTest','off');

if (~isappdata(hParent,'dispInfoDelay') || isempty(getappdata(hParent,'DispInfoDelay'))), Delay = 5;
else Delay = getappdata(gcf,'dispInfoDelay');
end
t = timer('StartDelay',Delay,'TimerFcn',@(hTimer,~) RemInfoAx(hTimer,hObject,objProperties,hAxes,hCopy),'stopfcn',@Delt);
start(t);

setappdata(hObject,'flag_AvoidEndlessRecursion',0)
if ~isempty(ex)
    a = getappdata(ex,'flag_AvoidEndlessRecursion');
    if (isempty(a) || a), arrayfun(@(a) dispInfo(a,'noToolTip'),ex); end
end

end

function RemInfoAx(~,hObject,objProperties,hAxes,hCopy)
set(hObject,objProperties{:},'HitTest','on')
setappdata(hObject,'flag_AvoidEndlessRecursion',1)
delete(hCopy)
delete(hAxes)
end

function Delt(varargin), delete(varargin{1}); end

function extentObj = getExtent(hObject,Units)
if (nargin < 2), Units = get(hObject,'Units'); end
bu       = get(hObject,'units');
set(hObject,'units',Units);
extentObj = get(hObject,'extent');
set(hObject,'units',bu);

end