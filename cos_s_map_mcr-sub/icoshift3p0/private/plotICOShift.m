function plotICOShift(xT,xP,xPo,xCS,Intervals,Shifts,scalStr,Flags)% FRSA interv is not needed?
% PLOT COMPARISON rigid shift

%% Constants
MAXPOINTS = 2^14;

% Initialisations
[nP,mP] = size(xP);
if (mP <= MAXPOINTS), x = 1:mP;
else
    st   = ceil(mP/MAXPOINTS);
    x    = 1:st:mP;
end
CM   = 1 - MyCM(nP);
top  = max(xP(:));
bot  = min(xP(:));
if (isempty(scalStr)), 
    Scal  = 1:mP;
    axLim = scalAx(x(1),x(end),bot,top);
else
    Scal = scalStr.scal;
    if (scalStr.scalDir), axLim = scalAx(Scal(1),Scal(end),bot,top);
    else axLim = scalAx(Scal(end),Scal(1),bot,top);
    end
end

nSubplots = 2 + ~isempty(xPo);
newFigure();

if (~isempty(xPo)), title_suff    = ' (after coshift)'; else title_suff = ''; end

%% 1st plot
% Plot raw data
sh     = subplot(nSubplots,1,1,'nextplot','add','ColorOrder',CM,'color','w');
if (Flags.COShift), 
    lineH = localPlot(sh(1),Scal,xPo,x,Intervals,Shifts,[bot,top],axLim,CM,Flags);
    avrg  = MeanwNaN(xPo);
    legend(plot(Scal(x),avrg(x), 'Color','r', 'LineWidth', 4), 'average');
    % line(Intervals(1,[2:3;2:3]), axLim([3 3;4 4]), 'Color', 'r', 'LineStyle', ':', 'LineWidth', 2)
else
    
    lineH = localPlot(sh(1),Scal,xP,x,Intervals,Shifts,[bot,top],axLim,CM,Flags);
    hTarget = plot (Scal(x),xT(x), 'Color','r', 'LineWidth', 4); 
    if (isempty(Flags.note)), legend (hTarget, 'Target'); % User provided target
    else        
        if (Flags.avg2Flag), legend(hTarget,sprintf('average2 * %g', Flags.avgPower)); else legend(hTarget, Flags.note); end
        a = sum(abs(Shifts),2);
        b = find(a == min(a));
        bStr = regexprep(regexprep(sprintf('#%i, ',b(1:end - 1)),', $',sprintf(' and #%i',b(end))),'^# and ','');
        if (length(b) > 1), msg = 'Samples %s are the most similar to the "%s" one'; else msg = 'Sample %s isthe most similar to the "%s" one'; end 
        set(hTarget,'ButtonDownFcn',@dispInfo,'tag',sprintf(msg,bStr,Flags.note));
    end
    
end
title(sh(1),'Raw data');

%% 2nd plot
% Plot after preliminary coshift
if (Flags.COShift)
    
    sh(2)  = subplot(nSubplots,1,2,'nextplot','add','ColorOrder',CM,'color','w');
    [lineH(:,2),intH] = localPlot(sh(2),Scal,xP,x,Intervals,Shifts,[bot,top],axLim,CM,Flags);
    hTarget  = plot(sh(2),Scal(x),xT(x), 'Color','r', 'LineWidth', 4);
    if (Flags.avg2Flag), legend(hTarget,sprintf('average2 * %g', Flags.avgPower)); else legend(hTarget, Flags.note); end
    if (Flags.flag2)
        set(intH(strcmp(get(intH,'Type'),'line')),'Color','g')
        title(['Reference aligned data',title_suff]);
    elseif (~Flags.whole)
        set(intH,'edgecolor','b');
        title('pre-coshifted data');
    else title(['Interval-aligned data',title_suff]);
    end
    
end

%% 2nd or 3rd plot
sh(nSubplots) = subplot(nSubplots,1,nSubplots,'nextplot','add','ColorOrder',CM,'color','w');
[lineH(:,nSubplots),intH] = localPlot(sh(nSubplots),Scal,xCS,x,Intervals,Shifts,[bot,top],axLim,CM,Flags);
if (Flags.flag2)
    set(intH(strcmp(get(intH,'Type'),'line')),'Color','g')
    title(['Reference aligned data',title_suff]);
elseif (~Flags.whole)
    set(intH,'edgecolor','b');
    title(['Interval-aligned data',title_suff]);
else title('Whole spectra aligned data');
end

%% Connect plots
linkaxes(sh,'xy')
if (Scal(1) > Scal(2)), set(sh,'xdir','rev'), end % Reverts X axis direction if Scal is monotonically decreasing
for i_sam = 1:nP

    setappdata(lineH(i_sam,1),'Extra',lineH(i_sam,end))
    setappdata(lineH(i_sam,1),'flag_AvoidEndlessRecursion',1)
    setappdata(lineH(i_sam,end),'Extra',lineH(i_sam,end - 1))
    setappdata(lineH(i_sam,end),'flag_AvoidEndlessRecursion',1)
    if (Flags.COShift)
        setappdata(lineH(i_sam,2),'Extra',lineH(i_sam,1))
        setappdata(lineH(i_sam,2),'flag_AvoidEndlessRecursion',1)
    end
    
end

function Cols = ExtCM(n,CM)
% Extend colormap to have n colors
if nargin < 2
    CM = MyCM;
end
if isa(CM,'char')
    CM = eval(CM);
end
if isa(CM,'function_handle')
    CM = CM();
end
if ~isequal(size(CM),[64,3]) || any(CM(:) < 0 | CM(:) > 1)
    error('CM argument is not a colormap')
end
if n < 0 || ~isfinite(n)
    error('n must be positive and finite')
end
Cols           = interp1((1:64)',CM,linspace(1,64,n)');
Cols(Cols < 0) = 0;
Cols(Cols > 1) = 1;

function Colours = MyCM(n)
% Purple to orange colour map
%
% Author: Giorgio Tomasi
%         Giorgio.Tomasi@gmail.com
Colours(:,1) = linspace(0,1,64)';
Colours(:,2) = abs(linspace(-.5,.5,64)');
Colours(:,3) = flipud(Colours(:,1));
if nargin
   if isnumeric(n), Colours = ExtCM(n,Colours);
   else error('Invalid input. A positive integer must be provided');
   end
end

function figH = newFigure()
pbu = get(0,'units');
set(0,'Units','pixels');
Scrsiz = get(0,'ScreenSize');
set(0,'Units',pbu);
ScrLength = Scrsiz(3);
ScrHight  = Scrsiz(4);
figpos    = [0.1*ScrLength 0.15*ScrHight 0.85*ScrLength 0.75*ScrHight];
figH      = figure('unit','pixels','Position',figpos);

function axLim = scalAx(mX,MX,mY,MY)
dY    = MY - mY;
axLim = [mX,MX, mY - 0.075 * dY,MY + 0.075 * dY];

function [lineH,intH] = localPlot(axH,Scal,A,x,Intervals,Shifts,yL,axLim,CM,Flags)
if (Flags.allsegs), Colour = [1 1 1]; else Colour = [1.0000    0.8314    0.8314]; end
xTxt  = mean(Scal(Intervals(:,2:3)),2);
nI    = size(Intervals,1);
nP    = size(A,1);
if (Flags.flag2)
    
    XX   = Intervals(:,[2 2 3 3])';
    YY   = axLim(ones(Intervals(end,1),1),[3 4 4 3])';
    intH = plot(Scal(Intervals([2 3; 2 3])), axLim(3:4),':r','LineWidth',2);
    intH(end + 1) = fill(Scal(XX),YY,Colour);
    set(intH(end),'facealpha',0.4,{'tag'},cellstr(num2str(Intervals(:,1))),'ButtonDownFcn',@dispInfo,'EdgeColor','none','LineWidth',1)
    t     = A(:,Intervals(1,2):Intervals(1,3),:);
    mT    = min(t(:));
    MT    = max(t(:));
    text(xTxt,MT + 0.05 * (MT - mT),'Ref.','Color','k', 'Rotation', 90, 'Clipping','on');

elseif (~Flags.whole)

    XX   = Intervals(:,[2 2 3 3])';
    YY   = axLim(ones(Intervals(end,1),1),[3 4 4 3])';
    intH = fill(Scal(XX),YY,Colour);
    set(intH,'facealpha',0.4,{'tag'},cellstr(num2str(Intervals(:,1))),'ButtonDownFcn',@dispInfo,'EdgeColor','b','LineWidth',1)
    text(xTxt,yL(ones(nI,1),end),num2str(Intervals(:,1)), 'Rotation', 90,'Clipping','on');

else intH = [];
end
if (~isempty(intH))

    for (i = 1:length(intH)), setappdata(intH(i),'noOpen',true);  end
    if (nP < 4)
        t = regexp(sprintf('Sample #%i: %i\t',reshape(permute(cat(3,ones(nI,1) * (1:nP),Shifts'),[2 3 1]),[nP,2 * nI])'),'\t','split');
        t = cellfun(@char,reshape(t(1:end - 1),size(Shifts'))','UniformOutput',0);
    else t = genStr(Shifts,{'min','median','max'})';
    end
    if (Flags.flag2), t = t(ones(length(intH),1)); end
    for (i = 1:length(intH))
        
        if (Flags.flag2), t{i} = cat(1,{'\bfReference\rm'},t{i}); 
        elseif (~Flags.whole), t{i} = cat(1,{sprintf('\\bfInterval #%i\\rm',i)},t{i}); 
        end
        setappdata(intH(i),'dispInfo',t{i});
    
    end
    
end
set(axH,'xlim',axLim(1:2),'ylim',axLim(3:4))
lineH = plot(Scal(x),A(:,x));
set(lineH,{'color'},num2cell(CM,2),{'Tag'},cellstr(num2str((1:nP)','Sam. #%i')),'ButtonDownFcn',@dispInfo);
