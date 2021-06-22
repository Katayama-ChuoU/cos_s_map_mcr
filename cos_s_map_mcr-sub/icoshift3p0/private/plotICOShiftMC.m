function plotICOShiftMC(xT,xP,xTo,xPo,xCS,xCSred,Intervals,Shifts,scalStr,chStr,FUN,useChannels,Flags,options)% FRSA interv is not needed?
% PLOT COMPARISON rigid shift

%% Constants
MAXPOINTS = 2^14;
PLOTFUN   = @(a,b,c) iCOShiftContour(a,b,c,[0.8 0.95]);
if (isfield(options,'plotFun') && isa(options.plotFun,'function_handle')), PLOTFUN = options.plotFun; end

% Initialisations
if (isempty(xPo)), xPo = xP; end

dimX = size(xPo);
[nP,mP,nC] = deal(dimX(1),dimX(2),prod(dimX(3:end)));
if (mP <= MAXPOINTS), x = 1:mP;
else
    st   = ceil(mP/MAXPOINTS);
    x    = 1:st:mP;
end
CM   = 1 - MyCM(nP);
if (isempty(chStr)), 
    Channels = 1:nC;
    chTB     = [1 nC];
else 
    Channels = chStr.scal;
    if (chStr.scalDir), chTB = Channels([1 end]); else chTB = Channels([end 1]); end
end
if (isempty(scalStr)),
    Scal  = 1:mP;
    scTB  = x([1 end]);
else
    Scal = scalStr.scal;
    if (scalStr.scalDir), scTB = Scal([1,end]);
    else scTB = Scal([end,1]);
    end
end
nSubplots = 2 + double(Flags.COShift);
subProp   = {'LineWidth',1,'nextplot','add','ColorOrder',CM,'color','w','box','on'};
tProp     = {'Color','k', 'LineWidth', 2.5}; 
newFigure();

if (~isempty(xPo)), title_suff = ' (after coshift)'; else title_suff = ''; end
title_suff = sprintf('%s - ch. optimality: "%s"',title_suff,FUN);

% Generate collapsed data
if (strcmp(FUN,'max')), FUN = @(A) max(A(:,:,useChannels),[],3);
elseif (size(xCS,3) > 1 || strcmp(FUN,'sum')), FUN = @(A) SumwNaN(A(:,:,:),3);
elseif (~ismatrix(xPo)), error('DEBUG: this should never happen!!')
end

%% 1st plot
% Plot raw data
sh    = subplot(nSubplots,1,1,subProp{:});
yP    = FUN(xP);
yTx   = FUN(xT(:,x,:));
indNaN = all(isnan(xT(:,x,:)),3);
if (any(indNaN))
    yTx(:,indNaN,:)           = NaN; % Take care of NaNs in the target for 'max' 
    xTo(:,all(isnan(xT),3),:) = NaN;
end

top   = max(max(yP(:)),max(yTx(:)));
bot   = min(min(yP(:)),min(yTx(:)));
axLim = scalAx(scTB(1),scTB(2),chTB(1),chTB(2),bot,top);
if (Flags.COShift)
    
    yPo   = FUN(xPo);
    lineH = localPlot(sh(1),Scal,yPo,x,Intervals,Shifts,[bot,top],axLim([1 2 5 6]),CM,Flags);
    hTarget = plot(Scal(x),MeanwNaN(yPo(:,x),1),tProp{:});
    legend(hTarget, 'average');
    % line(Intervals(1,[2:3;2:3]), axLim([3 3;4 4]), 'Color', 'r', 'LineStyle', ':', 'LineWidth', 2)
    setappdata(sh,'openPlotFUN',@(hObj) MCPlot(hObj,xPo(:,x,:),squeeze(xTo(:,x,:))'))

else
    
    lineH = localPlot(sh(1),Scal,yP,x,Intervals,Shifts,[bot,top],axLim([1 2 5 6]),CM,Flags);
    setappdata(sh,'X',xPo(:,x,:))
    hTarget = plot (Scal(x),yTx,tProp{:});
    if (isempty(Flags.note)), legend (hTarget, 'Target'); % User provided target
    else
        if (Flags.avg2Flag), legend(hTarget,sprintf('average2 * %g', Flags.avgPower)); else legend(hTarget, Flags.note); end
        a = sum(abs(Shifts),2);
        b = find(a == min(a));
        bStr = regexprep(regexprep(sprintf('#%i, ',b(1:end - 1)),', $',sprintf(' and #%i',b(end))),'^# and ','');
        if (length(b) > 1), msg = 'Samples %s are the most similar to the "%s" one'; else msg = 'Sample %s isthe most similar to the "%s" one'; end
        set(hTarget,'ButtonDownFcn',@dispInfo,'tag',sprintf(msg,bStr,Flags.note));
    end
    setappdata(sh,'openPlotFUN',@(hObj) MCPlot(hObj,xPo(:,x,:),squeeze(xTo(:,x,:))'))
    
end
set(lineH,{'userdata'},num2cell((1:nP)'));
set(hTarget,'userdata',[]);
title(sh(1),'Raw data');

%% 2nd plot
% Plot after preliminary coshift
if (Flags.COShift)
    
    sh(2)  = subplot(nSubplots,1,2,subProp{:});
    [lineH(:,2),intH] = localPlot(sh(2),Scal,yP,x,Intervals,Shifts,[bot,top],axLim([1 2 5 6]),CM,Flags);
    hTarget  = plot(sh(2),Scal(x),yTx,tProp{:});
    setappdata(sh(2),'openPlotFUN',@(hObj) MCPlot(hObj,xPo(:,x,:),squeeze(xTo(:,x,:))'))
    if (Flags.avg2Flag), legend(hTarget,sprintf('average2 * %g', Flags.avgPower)); else legend(hTarget, Flags.note); end
    if (Flags.flag2)
        set(intH(strcmp(get(intH,'Type'),'line')),'Color','g')
        titleStr = 'Reference aligned data';
    elseif (~Flags.whole)
        set(intH,'edgecolor','b');
        titleStr = 'Pre-coshifted data';
    else titleStr = 'Interval-aligned data';
    end
    set(lineH(:,2),{'userdata'},num2cell((1:nP)'));
    title(sprintf('%s %s',titleStr,title_suff))
    
end

%% 2nd or 3rd plot
sh(nSubplots) = subplot(nSubplots,1,nSubplots,subProp{:});
if (~isempty(xCSred) && ismatrix(xCSred)), [lineH(:,nSubplots),intH] = localPlot(sh(nSubplots),Scal,xCSred,x,Intervals,Shifts,[bot,top],axLim([1 2 5 6]),CM,Flags);
else [lineH(:,nSubplots),intH] = localPlot(sh(nSubplots),Scal,FUN(xCS),x,Intervals,Shifts,[bot,top],axLim([1 2 5 6]),CM,Flags);
end
plot(sh(2),Scal(x),yTx,tProp{:});
set(lineH(:,nSubplots),{'userdata'},num2cell((1:nP)'));
setappdata(sh(2),'openPlotFUN',@(hObj) MCPlot(hObj,xCS(:,x,:),squeeze(xTo(:,x,:))',xPo(:,x,:)))
if (Flags.flag2)
    set(intH(strcmp(get(intH,'Type'),'line')),'Color','g')
    titleStr = 'Reference aligned data';
elseif (~Flags.whole)
    set(intH,'edgecolor','b');
    titleStr = 'Interval-aligned data';
else titleStr = 'Whole spectra aligned data';
end
title(sprintf('%s %s',titleStr,title_suff))

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

    function MCPlot(hObject,X,T,O)
        colEdge   = [0 0 1;1 0 0;0 1 0];
        colFace   = num2cell(colEdge,2);
        colEdge   = num2cell(colEdge * .5,2);
        ind       = get(hObject,'userdata');
        newFigure();
        aH        = axes(subProp{:});

        legTxt    = {sprintf('Target')};
        hT        = PLOTFUN(Scal(x),Channels,T);
        patchXY   = [1 0;0.95 0.05] * [xlim;ylim]';
        ptcH(1,1) = patch(patchXY([1 1 2 2],1),patchXY([1 2 2 1],2),zeros(4,1),'EdgeColor',[0 0 .5],'FaceColor',[0 0 .5]);
        Tit       = 'Target';
        if (~isempty(ind))
            Tit       = sprintf('Sample #%i',ind);
            legTxt    = cat(1,legTxt,{sprintf('Sample #%i',ind)});
            hT(2,1)   = PLOTFUN(Scal(x),Channels,squeeze(X(ind,:,:))');
            ptcH(2,1) = patch(patchXY([1 1 2 2],1),patchXY([1 2 2 1],2),zeros(4,1),'EdgeColor',[.5 0 0],'FaceColor',[.5 0 0]);
        end
        if (nargin > 3)
            hT(3,1)   = PLOTFUN(Scal(x),Channels,squeeze(O(ind,:,:))');
            ptcH(3,1) = patch(patchXY([1 1 2 2],1),patchXY([1 2 2 1],2),zeros(4,1),'EdgeColor',[0 .5 0],'FaceColor',[0 .5 0]);
            legTxt    = {sprintf('Target'),sprintf('Sample #%i - aligned',ind),sprintf('Sample #%i - raw',ind)};
        end
        legend(ptcH,legTxt{:});
        if (isprop(hT(1),'EdgeColor')), set(hT,{'EdgeColor'},colEdge(1:length(hT))); end
        if (isprop(hT(1),'FaceColor')), set(hT,{'FaceColor'},colFace(1:length(hT))); end
        if (isprop(hT(1),'LineColor')), set(hT,{'LineColor'},colEdge(1:length(hT))); end
        if (isprop(hT(1),'FaceAlpha')), set(hT,{'FaceAlpha'},num2cell(0.4 * ones(size(hT)))); end
        set(ptcH,'Visible','off')
        title(Tit)
        ylabel('Channels')
        set(aH,'NextPlot','replacechildren')
        
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

end

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

end

function figH = newFigure(dim)
if (~nargin), dim = [0.1 0.15 .85 .75]; end
pbu = get(0,'units');
set(0,'Units','pixels');
Scrsiz = get(0,'ScreenSize');
set(0,'Units',pbu);
ScrLength = Scrsiz(3);
ScrHight  = Scrsiz(4);
figpos    = dim .* [ScrLength ScrHight ScrLength ScrHight];
figH      = figure('unit','pixels','Position',figpos);

end

function axLim = scalAx(mX,MX,mY,MY,mZ,MZ)
if (nargin == 4),
    dY    = MY - mY;
    axLim = [mX,MX, mY - 0.075 * dY,MY + 0.075 * dY];
elseif (nargin == 6)
    dZ    = MZ - mZ;
    axLim = [mX,MX,mY,MY,mZ - 0.075 * dZ,MZ + 0.075 * dZ];
end
end

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
        t = mat2cell(cellfun(@char,reshape(t(1:end - 1),size(Shifts'))','UniformOutput',0),nP,ones(1,nI));
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

end
