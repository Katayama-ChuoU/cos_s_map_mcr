function varargout = optim_info(varargin)
% OPTIM_INFO MATLAB code for optim_info.fig
%      OPTIM_INFO, by itself, creates a new OPTIM_INFO or raises the existing
%      singleton*.
%
%      H = OPTIM_INFO returns the handle to a new OPTIM_INFO or the handle to
%      the existing singleton*.
%
%      OPTIM_INFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIM_INFO.M with the given input arguments.
%
%      OPTIM_INFO('Property','Value',...) creates a new OPTIM_INFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optim_info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optim_info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optim_info

% Last Modified by GUIDE v2.5 18-Dec-2013 10:53:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optim_info_OpeningFcn, ...
                   'gui_OutputFcn',  @optim_info_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before optim_info is made visible.
function optim_info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optim_info (see VARARGIN)

% Choose default command line output for optim_info
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes optim_info wait for user response (see UIRESUME)
% uiwait(handles.figure1);

appCorrel=evalin('base','mcr_als.alsOptions.correlation.appCorrelation;');
if appCorrel==1
    set(handles.push_correl,'enable','on');
else
    set(handles.push_correl,'enable','off');
end

appTril=evalin('base','mcr_als.alsOptions.trilin.appTril;');
if appTril>0
    set(handles.push_3p,'enable','on');
else
    set(handles.push_3p,'enable','off');
end

appKin=evalin('base','mcr_als.alsOptions.kinetic.appKinetic;');
if appKin>0
    set(handles.push_kinetic,'enable','on');
else
    set(handles.push_kinetic,'enable','off');
end

% --- Outputs from this function are returned to the command line.
function varargout = optim_info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ******************************************************************************
% Graphics
% ******************************************************************************

% --- Executes during object creation, after setting all properties.
function popup_graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'Plot R^2'};
llista(3)={'Plot LOF'};
llista(4)={'Plot % sigma change'};
llista(5)={'Plot log(ssq)'};
llista(6)={'Plot row profiles evolution'};
llista(7)={'Plot column profiles evolution'};
set(hObject,'string',llista)

% --- Executes on selection change in popup_graph.
function popup_graph_Callback(hObject, eventdata, handles)
% hObject    handle to popup_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_graph contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_graph

valor=get(hObject,'Value')-2; 

if valor==-1
    
    % nothing happen
    axes(handles.axes1);
    cla;
    axis([0 1 0 1]);
    title('');
    xlabel('');
    ylabel('');
    
elseif valor==0
    
    % plot R2
    plot_R2=evalin('base','mcr_als.alsOptions.resultats.plot_R2;');
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    plot_optim_R2=evalin('base','mcr_als.alsOptions.resultats.plot_optim_R2;');
    axes(handles.axes1);
    X=length(plot_R2);
    plot(plot_R2,'.-');axis([1 X min(plot_R2) max(plot_R2)]);title('Evolution of R2');
    xlabel('Number of iterations');
    ylabel('% R2');
    hold on;
    plot(optim_niter,plot_optim_R2,'ro');
    zoom on;
    hold off;
    
  elseif valor==1
    
    % plot lof
    plot_lof=evalin('base','mcr_als.alsOptions.resultats.plot_lof;');
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    plot_optim_lof=evalin('base','mcr_als.alsOptions.resultats.plot_optim_lof;');
    axes(handles.axes1);
    X=length(plot_lof);
    plot(plot_lof,'.-');axis([1 X min(plot_lof) max(plot_lof)]);title('Evolution of lof');
    xlabel('Number of iterations');
    ylabel('% lof');
    hold on;
    plot(optim_niter,plot_optim_lof,'ro');
    zoom on;
    hold off;
    
elseif valor==2
    
    % sigma change
    plot_sigmaC=evalin('base','mcr_als.alsOptions.resultats.plot_sigmaC;');
    axes(handles.axes1);
    X=length(plot_sigmaC);
    plot(plot_sigmaC,'.-');axis([1 X min(plot_sigmaC) max(plot_sigmaC)]);title('Evolution of % change of sigma');
    xlabel('Number of iterations');
    ylabel('% sigma');
    zoom on;
    hold on;
    convcrit=evalin('base','mcr_als.alsOptions.opt.tolsigma;');
    hline(convcrit,'g:');
    hline(-convcrit,'g:');
    hold off;
    
    
 elseif valor==3
    
    % log(ssq)
    sigmaN=evalin('base','mcr_als.alsOptions.resultats.plot_sigmaN;');
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    plot_sigmaN=log10(sigmaN);
    plot_sigmaN_optim=plot_sigmaN(optim_niter);
    axes(handles.axes1);
    X=length(plot_sigmaN);
    plot(plot_sigmaN,'.-');axis([1 X min(plot_sigmaN) max(plot_sigmaN)]);title('Evolution of log(ssq)');
    xlabel('Number of iterations');
    ylabel('log10(ssq)');
    zoom on;
    hold on;
    plot(optim_niter,plot_sigmaN_optim,'ro');
    zoom on;
    hold off;
    
elseif valor==4
   
    % plot spectra
    plot_specs=evalin('base','mcr_als.alsOptions.resultats.plot_specs;');
    optim_specs=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
    axes(handles.axes1);
    [m,X]=size(plot_specs);
    set(gcf,'defaultaxescolororder',jet(m))
    plot(plot_specs','-');axis([1 X min(min(plot_specs)) max(max(plot_specs))]);title('Evolution of Spectra Profiles');
    xlabel('Channel');
    ylabel('Intensity (a.u.)');
    hold on;
    plot(optim_specs','r.');
    zoom on;
    hold off;
    
elseif valor==5
    
    % plot concs
    plot_concs=evalin('base','mcr_als.alsOptions.resultats.plot_concs;');
    optim_concs=evalin('base','mcr_als.alsOptions.resultats.optim_concs;');
    axes(handles.axes1);
    [X,m]=size(plot_concs);
    set(gcf,'defaultaxescolororder',jet(m))
    plot(plot_concs,'-');axis([1 X min(min(plot_concs)) max(max(plot_concs))]);title('Evolution of Concentration Profiles');
    xlabel('Row number');
    ylabel('Concentration signal)');
    hold on;
    plot(optim_concs,'r.');
    zoom on;
    hold off;
    
end


% ******************************************************************************
% Close
% ******************************************************************************

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in push_3p.
function push_3p_Callback(hObject, eventdata, handles)
% hObject    handle to push_3p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if evalin('base','mcr_als.alsOptions.trilin.iquadril;')==0;
    if evalin('base','mcr_als.alsOptions.trilin.appTril;')==2;
       bilinear_info;
    else
       trilinear_info;
    end
elseif evalin('base','mcr_als.alsOptions.trilin.iquadril;')==1;
quadrilinear_info;
end

% --- Executes on button press in push_correl.
function push_correl_Callback(hObject, eventdata, handles)
% hObject    handle to push_correl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

correlation_info;


% --- Executes on button press in push_kinetic.
function push_kinetic_Callback(hObject, eventdata, handles)
% hObject    handle to push_kinetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

kinetic_info;


% --- Executes on button press in push_images.
function push_images_Callback(hObject, eventdata, handles)
% hObject    handle to push_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

images_info;
