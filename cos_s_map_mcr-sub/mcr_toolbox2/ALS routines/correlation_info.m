function varargout = correlation_info(varargin)
% CORRELATION_INFO MATLAB code for correlation_info.fig
%      CORRELATION_INFO, by itself, creates a new CORRELATION_INFO or raises the existing
%      singleton*.
%
%      H = CORRELATION_INFO returns the handle to a new CORRELATION_INFO or the handle to
%      the existing singleton*.
%
%      CORRELATION_INFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRELATION_INFO.M with the given input arguments.
%
%      CORRELATION_INFO('Property','Value',...) creates a new CORRELATION_INFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correlation_info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correlation_info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help correlation_info

% Last Modified by GUIDE v2.5 29-Jan-2013 15:01:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correlation_info_OpeningFcn, ...
                   'gui_OutputFcn',  @correlation_info_OutputFcn, ...
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


% --- Executes just before correlation_info is made visible.
function correlation_info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correlation_info (see VARARGIN)

% Choose default command line output for correlation_info
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes correlation_info wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correlation_info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popu_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popu_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

compreg=evalin('base','mcr_als.alsOptions.correlation.compreg');
indices=find(compreg);
dim=length(indices);
j=2;
llistannc(1)={'select a species...'};
for i=1:dim;
    llistnnc=['Species nr. ',num2str(indices(i))];
    llistannc(j)={llistnnc};
    j=j+1;
end;

set(hObject,'string',llistannc)

% --- Executes on selection change in popu_select.
function popu_select_Callback(hObject, eventdata, handles)
% hObject    handle to popu_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popu_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popu_select

valorpop=get(hObject,'Value')-1;

if valorpop>0
    compreg=evalin('base','mcr_als.alsOptions.correlation.compreg');
    indices=find(compreg);
    num=indices(valorpop);
    
    % plot
    axes(handles.axes1);
    
    % optimal iteration
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    matdad=evalin('base','mcr_als.data');
    [rows,cols]=size(matdad);
    ycorrelP=evalin('base','mcr_als.alsOptions.correlation.results.save_ycal');
    yinp=ycorrelP((rows*(optim_niter-1))+1:(rows*optim_niter),:);
    
    ysel=evalin('base','mcr_als.alsOptions.correlation.csel_variable');
    [nr,nc]=size(yinp);
    yout=yinp;
    ycal=yinp;
    j=num;
    isel=find(isfinite(ysel(:,j)));
    
    if isfinite(isel) & length(ysel(isel,j))>=2
        x=ysel(isel,j);
        y=yinp(isel,j);
        [p,S]=polyfit(x,y,1);
        ycalc(:,j)=(yinp(:,j)-p(2))/p(1);
        plot(ysel(isel,j),ycalc(isel,j),'r*',ysel(isel,j),ysel(isel,j));
        xlabel('Cknown values');
        ylabel('Cpred values');
    end
    
    % table
    data=[];
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    stats=evalin('base',['mcr_als.alsOptions.correlation.results.save_stats(',num2str(optim_niter),',:);']);
    
    data{1,1}=[];
    
    % slope
    SLOPE=stats{1,num}.slope;
    data{2,1}=num2str(SLOPE);
    
    % offset
    OFFSET=stats{1,num}.offset;
    data{3,1}=num2str(OFFSET);
    
    % r
    RCOEF=stats{1,num}.r;
    data{4,1}=num2str(RCOEF);
    
    % RMSEC
    RMSEC=stats{1,num}.RMSEC;
    data{5,1}=num2str(RMSEC);
    set(handles.uitable1,'Data',data);
    
else
    
    data=[];
    set(handles.uitable1,'Data',data);
    axes(handles.axes1);
    cla;
    
end


% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
