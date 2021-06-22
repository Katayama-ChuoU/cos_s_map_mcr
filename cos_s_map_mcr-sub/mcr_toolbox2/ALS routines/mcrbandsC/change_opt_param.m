function varargout = change_opt_param(varargin)
% CHANGE_OPT_PARAM M-file for change_opt_param.fig
%      CHANGE_OPT_PARAM, by itself, creates a new CHANGE_OPT_PARAM or raises the existing
%      singleton*.
%
%      H = CHANGE_OPT_PARAM returns the handle to a new CHANGE_OPT_PARAM or the handle to
%      the existing singleton*.
%
%      CHANGE_OPT_PARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANGE_OPT_PARAM.M with the given input arguments.
%
%      CHANGE_OPT_PARAM('Property','Value',...) creates a new CHANGE_OPT_PARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before change_opt_param_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to change_opt_param_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help change_opt_param

% Last Modified by GUIDE v2.5 28-Oct-2009 14:30:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @change_opt_param_OpeningFcn, ...
    'gui_OutputFcn',  @change_opt_param_OutputFcn, ...
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



% --- Executes just before change_opt_param is made visible.
function change_opt_param_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to change_opt_param (see VARARGIN)

% Choose default command line output for change_opt_param
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes change_opt_param wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = change_opt_param_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% default parameters
if (evalin('base','mcr_bands.Optional.param_flag;'))==0
    evalin('base','mcr_bands.Optional.Opt_param.Display=''iter'';');
    evalin('base','mcr_bands.Optional.Opt_param.Diagnostics=''on'';');
    evalin('base','mcr_bands.Optional.Opt_param.TolCon=0.0001;');
    evalin('base','mcr_bands.Optional.Opt_param.TolFun=0.00001;');
    evalin('base','mcr_bands.Optional.Opt_param.TolX=0.0001;');
    evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange=0.00001;');
    evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange=0.1;');
    evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals=3000;');
    
    evalin('base','mcr_bands.Optional.Opt_param.levelDisplay=0;');
    evalin('base','mcr_bands.Optional.Opt_param.valueDiag=0;');
end

% ************************************************************************
% Level display
% ************************************************************************

% --- Executes during object creation, after setting all properties.
function pop_leveldisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_leveldisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: iter'};
llista(2)={'off'};
llista(3)={'final'};
llista(4)={'notify'};
if (evalin('base','mcr_bands.Optional.param_flag;'))==0
    set(hObject,'string',llista)
else
    valor=evalin('base','mcr_bands.Optional.Opt_param.levelDisplay;');
    set(hObject,'string',llista,'value',valor+1)
end


% --- Executes on selection change in pop_leveldisplay.
function pop_leveldisplay_Callback(hObject, eventdata, handles)
% hObject    handle to pop_leveldisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_leveldisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_leveldisplay

levelDisplay=get(hObject,'Value')-1;
assignin('base','levelDisplay',levelDisplay);

% list reloaded
llista(1)={'iter'};
llista(2)={'off'};
llista(3)={'final'};
llista(4)={'notify'};
assignin('base','llista',llista);

% valor=llista{levelDisplay};
evalin('base','mcr_bands.Optional.Opt_param.Display=llista{levelDisplay+1};');
evalin('base','mcr_bands.Optional.Opt_param.levelDisplay=levelDisplay;');
evalin('base','clear llista levelDisplay');

% ************************************************************************
% Diagnostics
% ************************************************************************

% --- Executes during object creation, after setting all properties.
function pop_diagn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_diagn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: on'};
llista(2)={'off'};

if (evalin('base','mcr_bands.Optional.param_flag;'))==0
    set(hObject,'string',llista)
else
    valor=evalin('base','mcr_bands.Optional.Opt_param.valueDiag;');
    set(hObject,'string',llista,'value',valor+1)
end
% --- Executes on selection change in pop_diagn.
function pop_diagn_Callback(hObject, eventdata, handles)
% hObject    handle to pop_diagn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_diagn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_diagn

Diagnostics=get(hObject,'Value')-1;
assignin('base','Diagnostics',Diagnostics);

% list reloaded
llista(1)={'on'};
llista(2)={'off'};
assignin('base','llista',llista);

evalin('base','mcr_bands.Optional.Opt_param.valueDiag=Diagnostics;');
evalin('base','mcr_bands.Optional.Opt_param.Diagnostics=llista{Diagnostics+1};');
evalin('base','clear Diagnostics');


% ************************************************************************
% tolcon
% ************************************************************************


% --- Executes during object creation, after setting all properties.
function edit_tolcon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

valor=evalin('base','mcr_bands.Optional.Opt_param.TolCon;');
set(hObject,'string',valor)

function edit_tolcon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tolcon as text
%        str2double(get(hObject,'String')) returns contents of edit_tolcon as a double


TolCon= str2num(get(hObject,'String'));

assignin('base','TolCon',TolCon);
evalin('base','mcr_bands.Optional.Opt_param.TolCon=TolCon;');
evalin('base','clear TolCon');

% ************************************************************************
% tolfun
% ************************************************************************



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

valor=evalin('base','mcr_bands.Optional.Opt_param.TolFun;');
set(hObject,'string',valor)

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


TolFun= str2num(get(hObject,'String'));

assignin('base','TolFun',TolFun);
evalin('base','mcr_bands.Optional.Opt_param.TolFun=TolFun;');
evalin('base','clear TolFun');

% ************************************************************************
% tolx
% ************************************************************************


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

valor=evalin('base','mcr_bands.Optional.Opt_param.TolX;');
set(hObject,'string',valor)


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

TolX= str2num(get(hObject,'String'));

assignin('base','TolX',TolX);
evalin('base','mcr_bands.Optional.Opt_param.TolX=TolX;');
evalin('base','clear TolX');


% ************************************************************************
% diffminchange
% ************************************************************************


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

valor=evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange;');
set(hObject,'string',valor)

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


DiffMinChange= str2num(get(hObject,'String'));

assignin('base','DiffMinChange',DiffMinChange);
evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange=DiffMinChange;');
evalin('base','clear DiffMinChange');


% ************************************************************************
% diffmaxchange
% ************************************************************************


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

valor=evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange;');
set(hObject,'string',valor)

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

DiffMaxChange= str2num(get(hObject,'String'));

assignin('base','DiffMaxChange',DiffMaxChange);
evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange=DiffMaxChange;');
evalin('base','clear DiffMaxChange');


% ************************************************************************
% maxfunevals
% ************************************************************************

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

valor=evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals;');
set(hObject,'string',valor)

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

MaxFunEvals= str2num(get(hObject,'String'));

assignin('base','MaxFunEvals',MaxFunEvals);
evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals=MaxFunEvals;');
evalin('base','clear MaxFunEvals');


% ************************************************************************
% reset
% ************************************************************************


% --- Executes on button press in push_reset.
function push_reset_Callback(hObject, eventdata, handles)
% hObject    handle to push_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% default parameters
evalin('base','mcr_bands.Optional.Opt_param.Display=''iter'';');
evalin('base','mcr_bands.Optional.Opt_param.Diagnostics=''on'';');
evalin('base','mcr_bands.Optional.Opt_param.TolCon=0.0001;');
evalin('base','mcr_bands.Optional.Opt_param.TolFun=0.00001;');
evalin('base','mcr_bands.Optional.Opt_param.TolX=0.0001;');
evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange=0.00001;');
evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange=0.1;');
evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals=3000;');

% default parameters
llista(1)={'default: iter'};
llista(2)={'off'};
llista(3)={'final'};
llista(4)={'notify'};
set(handles.pop_leveldisplay,'string',llista,'value',1)

llista2(1)={'default: on'};
llista2(2)={'off'};
set(handles.pop_diagn,'string',llista2,'value',1)

set(handles.edit_tolcon,'string',0.0001)
set(handles.edit2,'string',0.00001)
set(handles.edit3,'string',0.0001)
set(handles.edit4,'string',0.00001)
set(handles.edit5,'string',0.1)
set(handles.edit6,'string',3000)


% ************************************************************************
% link
% ************************************************************************

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('http://www.mathworks.com/access/helpdesk/help/toolbox/optim/index.html?/access/helpdesk/help/toolbox/optim/ug/bqnk0r0.html&http://www.mathworks.com/support/product/product.html?product=OP&x=8&y=7', '-new');


% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% tornem a posar els parametres per defecte
evalin('base','mcr_bands.Optional.Opt_param.Display=''iter'';');
evalin('base','mcr_bands.Optional.Opt_param.Diagnostics=''on'';');
evalin('base','mcr_bands.Optional.Opt_param.TolCon=0.0001;');
evalin('base','mcr_bands.Optional.Opt_param.TolFun=0.00001;');
evalin('base','mcr_bands.Optional.Opt_param.TolX=0.0001;');
evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange=0.00001;');
evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange=0.1;');
evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals=3000;');

evalin('base','mcr_bands.Optional.param_flag=0;');
delete(handles.figure1);


% ************************************************************************
% go
% ************************************************************************

% --- Executes on button press in push_go.
function push_go_Callback(hObject, eventdata, handles)
% hObject    handle to push_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
warndlg('Use the Close or Cancel button to close this window.');


