function varargout = als_res(varargin)
% ALS_RES M-file for als_res.fig
%      ALS_RES, by itself, creates a new ALS_RES or raises the existing
%      singleton*.
%
%      H = ALS_RES returns the handle to a new ALS_RES or the handle to
%      the existing singleton*.
%
%      ALS_RES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALS_RES.M with the given input arguments.
%
%      ALS_RES('Property','Value',...) creates a new ALS_RES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before als_res_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to als_res_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help als_res

% Last Modified by GUIDE v2.5 27-Nov-2012 12:19:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @als_res_OpeningFcn, ...
    'gui_OutputFcn',  @als_res_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before als_res is made visible.
function als_res_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to als_res (see VARARGIN)

% Choose default command line output for als_res
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes als_res wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = als_res_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

als_end=evalin('base','als_end');
set(handles.alsframe,'background',[0.831 0.816 0.784]);
    
if als_end == 0;
       
    conc=evalin('base','cx_plot');
    abss=evalin('base','sx_plot');
    niter=evalin('base','niter_plot');
    sstd=evalin('base','sstd_plot');
    change=evalin('base','change_plot');
    
    axes(handles.concen);
    
    [xi,yi]=size(conc);
    maxim=max(max(conc));
    minim=min(min(conc));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim+0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(conc);axis([1 xi minim1 maxim1])
    
    title('Concentration profiles');
    
    axes(handles.spec);
    
    [xi,yi]=size(abss);
    maxim=max(max(abss));
    minim=min(min(abss));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim);
    end
    
    if minim > 0
        minim1=minim-0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    if (minim == 0 & maxim == 0)
        minim1=minim-1;
        maxim1=maxim+1;
    end
    
    plot(abss');axis([1 yi minim1 maxim1])
    title('Spectra');
    
    niter=char(['Iteration Nr.  ',num2str(niter)]);
    set(handles.als_iter,'string',niter,'background',[0.831 0.816 0.784]);

    
    if change < 0.0,
        set(handles.als_fit,'string','FITTING IS NOT IMPROVING','background',[0.831 0.816 0.784])
    else,
        set(handles.als_fit,'string','FITTING IS IMPROVING','background',[0.831 0.816 0.784]);
    end
    
    changes=char(['Change in sigma (%) = ',num2str(change)]);
    set(handles.als_change,'string',changes,'background',[0.831 0.816 0.784]);
    
    fit_pca=char(['Fitting error (lack of fit, lof) in % (PCA) = ', num2str(sstd(1))]);
    set(handles.als_fitpca,'string',fit_pca,'background',[0.831 0.816 0.784]);
    
    fit_exp=char(['Fitting error (lack of fit, lof) in % (exp) = ', num2str(sstd(2))]);
    set(handles.als_fitexp,'string',fit_exp,'background',[0.831 0.816 0.784]);
       
    pause(.3);

    % *************************************************************************
    
elseif als_end == 1
    
    set(handles.als_fit,'string','CONVERGENCE IS ACHIEVED!!!','background',[0.831 0.816 0.784])
    set(handles.alsframe,'background',[0.831 0.816 0.784]);
    
    copt_xxx=evalin('base','copt_xxx');
    sopt_xxx=evalin('base','sopt_xxx');
    itopt_xxx=evalin('base','itopt_xxx');
    sdopt_xxx=evalin('base','sdopt_xxx');
    r2opt_xxx=evalin('base','r2opt_xxx');
    rtopt_xxx=evalin('base','rtopt_xxx');
    change_xxx=evalin('base','change_xxx');
    
    axes(handles.concen);
    
    [xi,yi]=size(copt_xxx);
    maxim=max(max(copt_xxx));
    minim=min(min(copt_xxx));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim-0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(copt_xxx);axis([1 xi minim1 maxim1])
    
    title('Concentration profiles');
    
    axes(handles.spec);
    
    [xi,yi]=size(sopt_xxx);
    maxim=max(max(sopt_xxx));
    minim=min(min(sopt_xxx));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim-0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(sopt_xxx');axis([1 yi minim1 maxim1]);
    
    title('Spectra');
    
    niter=char(['Plots are optimum in the iteration Nr.  ',num2str(itopt_xxx)]);
    set(handles.als_iter,'string',niter,'background',[0.831 0.816 0.784]);
    
    changes=char(['Std. dev of residuals vs. exp. data = ',num2str(change_xxx)]);
    set(handles.als_change,'string',changes,'background',[0.831 0.816 0.784]);
    
    fit_pca=char(['Fitting error (lack of fit, lof) in % (PCA) =', num2str(sdopt_xxx(1,1))]);
    set(handles.als_fitpca,'string',fit_pca,'background',[0.831 0.816 0.784]);
    
    fit_exp=char(['Fitting error (lack of fit, lof) in % (exp) = ', num2str(sdopt_xxx(1,2))]);
    set(handles.als_fitexp,'string',fit_exp,'background',[0.831 0.816 0.784]);
    
    R2=char(['Percent of variance explained ( r ² ) at the optimum is = ',num2str(100*r2opt_xxx)]);
    set(handles.als_r2,'string',R2,'background',[0.831 0.816 0.784]);
        
elseif als_end == 2
    
    set(handles.als_fit,'string',['FIT NOT IMPROVING FOR 20 TIMES CONSECUTIVELY (DIVERGENCE?), STOP!!'],'background',[0.831 0.816 0.784])
    set(handles.alsframe,'background',[0.831 0.816 0.784]);
    
    copt_xxx=evalin('base','copt_xxx');
    sopt_xxx=evalin('base','sopt_xxx');
    itopt_xxx=evalin('base','itopt_xxx');
    sdopt_xxx=evalin('base','sdopt_xxx');
    r2opt_xxx=evalin('base','r2opt_xxx');
    rtopt_xxx=evalin('base','rtopt_xxx');
    change_xxx=evalin('base','change_xxx');
    
    axes(handles.concen);
    [xi,yi]=size(copt_xxx);
    maxim=max(max(copt_xxx));
    minim=min(min(copt_xxx));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim-0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(copt_xxx);axis([1 xi minim1 maxim1])
    title('Concentration profiles');
    
    axes(handles.spec);
    [xi,yi]=size(sopt_xxx);
    maxim=max(max(sopt_xxx));
    minim=min(min(sopt_xxx));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim-0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(sopt_xxx');axis([1 yi minim1 maxim1]);
    title('Spectra');
    
    niter=char(['Plots are optimum in the iteration Nr.  ',num2str(itopt_xxx)]);
    set(handles.als_iter,'string',niter,'background',[0.831 0.816 0.784]);
    
    R2=char(['Percent of variance explained ( r ² ) at the optimum is = ',num2str(100*r2opt_xxx)]);
    set(handles.als_r2,'string',R2,'background',[0.831 0.816 0.784]);
    
    fit_pca=char(['Fitting error (lack of fit, lof) in % (PCA) =', num2str(sdopt_xxx(1,1))]);
    set(handles.als_fitpca,'string',fit_pca,'background',[0.831 0.816 0.784]);
    
    fit_exp=char(['Fitting error (lack of fit, lof) in % (exp) = ', num2str(sdopt_xxx(1,2))]);
    set(handles.als_fitexp,'string',fit_exp,'background',[0.831 0.816 0.784]);
        
    changes=char(['Std. dev of residuals vs. exp. data =',num2str(change_xxx)]);
    set(handles.als_change,'string',changes,'background',[0.831 0.816 0.784]);
    
elseif als_end == 3
    
    set(handles.als_fit,'string','NUMBER OF ITERATIONS EXCEEDED THE ALLOWED!!!','background',[0.831 0.816 0.784])
    set(handles.alsframe,'background',[0.831 0.816 0.784]);
    
    copt_xxx=evalin('base','copt_xxx');
    sopt_xxx=evalin('base','sopt_xxx');
    itopt_xxx=evalin('base','itopt_xxx');
    sdopt_xxx=evalin('base','sdopt_xxx');
    r2opt_xxx=evalin('base','r2opt_xxx');
    rtopt_xxx=evalin('base','rtopt_xxx');
    change_xxx=evalin('base','change_xxx');
    
    axes(handles.concen);
    [xi,yi]=size(copt_xxx);
    maxim=max(max(copt_xxx));
    minim=min(min(copt_xxx));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim+0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(copt_xxx);axis([1 xi minim1 maxim1])
    title('Concentration profiles');
    
    axes(handles.spec);
    [xi,yi]=size(sopt_xxx);
    maxim=max(max(sopt_xxx));
    minim=min(min(sopt_xxx));
    
    if maxim > 0
        maxim1=maxim+0.2*maxim;
    else
        maxim1=maxim-0.2*abs(maxim)
    end
    
    if minim > 0
        minim1=minim-0.2*minim;
    else
        minim1=minim-0.2*abs(minim);
    end
    
    plot(sopt_xxx');axis([1 yi minim1 maxim1]);
    title('Spectra');
    
    niter=char(['Plots are optimum in the iteration nº  ',num2str(itopt_xxx)]);
    set(handles.als_iter,'string',niter,'background',[0.831 0.816 0.784]);
    
    R2=char(['Percent of variance explained ( r ² ) at the optimum is = ',num2str(100*r2opt_xxx)]);
    set(handles.als_r2,'string',R2,'background',[0.831 0.816 0.784]);
    
    fit_pca=char(['Fitting error (lack of fit, lof) in % (PCA) =', num2str(sdopt_xxx(1,1))]);
    set(handles.als_fitpca,'string',fit_pca,'background',[0.831 0.816 0.784]);
    
    fit_exp=char(['Fitting error (lack of fit, lof) in % (exp) = ', num2str(sdopt_xxx(1,2))]);
    set(handles.als_fitexp,'string',fit_exp,'background',[0.831 0.816 0.784]);
    
    changes=char(['Std. dev of residuals vs. exp. data =',num2str(change_xxx)]);
    set(handles.als_change,'string',changes,'background',[0.831 0.816 0.784]);
    
end

% --- Executes on button press in push_copy.
function push_copy_Callback(hObject, eventdata, handles)
% hObject    handle to push_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

print -dbitmap;

% --- Executes on button press in push_print.
function push_print_Callback(hObject, eventdata, handles)
% hObject    handle to push_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

print -dsetup;
print;


% --- Executes on button press in push_info.
function push_info_Callback(hObject, eventdata, handles)
% hObject    handle to push_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

optim_info;

% --- Executes on button press in push_bands.
function push_bands_Callback(hObject, eventdata, handles)
% hObject    handle to push_bands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mcrbandsg_connected;

% --- Executes on button press in push_error.
function push_error_Callback(hObject, eventdata, handles)
% hObject    handle to push_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in push_back2const.
function push_back2const_Callback(hObject, eventdata, handles)
% hObject    handle to push_back2const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegC'');');  
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegS'');'); 
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodC'');');
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodS'');');  
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''closure'');'); 
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''cselcC'');'); 
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''sselcS'');');
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''trilin'');');
% evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''multi'');');
evalin('base','mcr_als.alsOptions.nonegC.noneg=0;');
evalin('base','mcr_als.alsOptions.nonegS.noneg=0;');
evalin('base','mcr_als.alsOptions.unimodC.unimodal=0;');
evalin('base','mcr_als.alsOptions.unimodS.unimodal=0;');
evalin('base','mcr_als.alsOptions.closure.closure=0;');
evalin('base','mcr_als.alsOptions.cselcC.cselcon=0;');
evalin('base','mcr_als.alsOptions.sselcS.sselcon=0;');
evalin('base','mcr_als.alsOptions.trilin.tril=0;');
% evalin('base','mcr_als.alsOptions.multi.datamod=0;');
evalin('base','mcr_als.alsOptions.opt.gr=''y'';');
% als2013;

if evalin('base','mcr_als.alsOptions.nexp') > 1
    if evalin('base','mcr_als.alsOptions.multi.matc') > 1
                evalin('base','mcr_als.alsOptions.trilin.appTril=0;');
        rowMultiConstraints;
    else
        rowModeConstraints;
    end
else
    rowModeConstraints;
end


% --- Executes on button press in push_back2param.
function push_back2param_Callback(hObject, eventdata, handles)
% hObject    handle to push_back2param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
als_parameters_reload;
