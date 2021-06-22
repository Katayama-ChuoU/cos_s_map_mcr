function varargout = mcrbands_fr(varargin)
% MCRBANDS_FR M-file for mcrbands_fr.fig
%      MCRBANDS_FR, by itself, creates a new MCRBANDS_FR or raises the existing
%      singleton*.
%
%      H = MCRBANDS_FR returns the handle to a new MCRBANDS_FR or the handle to
%      the existing singleton*.
%
%      MCRBANDS_FR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCRBANDS_FR.M with the given input arguments.
%
%      MCRBANDS_FR('Property','Value',...) creates a new MCRBANDS_FR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mcrbands_fr_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcrbands_fr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mcrbands_fr

% Last Modified by GUIDE v2.5 11-May-2009 18:57:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mcrbands_fr_OpeningFcn, ...
    'gui_OutputFcn',  @mcrbands_fr_OutputFcn, ...
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


% --- Executes just before mcrbands_fr is made visible.
function mcrbands_fr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcrbands_fr (see VARARGIN)

% Choose default command line output for mcrbands_fr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mcrbands_fr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mcrbands_fr_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ************************************************************
% Figures
% ************************************************************

sband=evalin('base','mcr_bands.temp.sband;');
cband=evalin('base','mcr_bands.temp.cband;');
nsign=evalin('base','mcr_bands.temp.nsign;');
c=evalin('base','mcr_bands.Data.conc;');
s=evalin('base','mcr_bands.Data.spec;');

%ispec=evalin('base','mcr_bands.temp.ispec;'); octubre 2009
ioptim=ones(1:nsign);

axes(handles.axesC);
plot(cband(:,1:2:nsign*2));
hold on; zoom on;
% plot(c(:,ioptim),':');
plot(cband(:,2:2:nsign*2));
plot(c,'.')
title('Concentration profiles');

axes(handles.axesS);
plot(sband(1:2:nsign*2,:)');
hold on; zoom on;
plot(s','.');
plot(sband(2:2:nsign*2,:)');
title('Spectra profiles');


% ************************************************************
% End of the optimization
% ************************************************************

% --- Executes during object creation, after setting all properties.
function edit_conv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

xtot=evalin('base','mcr_bands.temp.exitflag');
x=min(min(xtot));
if  x == 0
    set(hObject,'String','Maximum Number of iterations reached');
elseif x > 0
    set(hObject,'String','Convergence');
else
    set(hObject,'String','Divergence');
end

function edit_conv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_conv as text
%        str2double(get(hObject,'String')) returns contents of edit_conv as a double

% no action

% --- Executes on button press in push_value.
function push_value_Callback(hObject, eventdata, handles)
% hObject    handle to push_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vers=version;
tall=vers(1:3);
num=str2num(tall);

if num >= 7.6
    valueg;
elseif (num >=7.0 & num < 7.6)
    valueg_old;
else
    warndlg('Matlab Release not supported');
end


% ************************************************************
% Number of constraints
% ************************************************************

% --- Executes during object creation, after setting all properties.
function edit_total_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_total (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

maxim=num2str(evalin('base','mcr_bands.temp.ncosntr(1,9)'));
set(hObject,'String',maxim);

function edit_total_Callback(hObject, eventdata, handles)
% hObject    handle to edit_total (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_total as text
%        str2double(get(hObject,'String')) returns contents of edit_total as a double

% nothing

% --- Executes on button press in push_const.
function push_const_Callback(hObject, eventdata, handles)
% hObject    handle to push_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applicons;

% ************************************************************
% Det matrix
% ************************************************************

% --- Executes on button press in push_deter.
function push_deter_Callback(hObject, eventdata, handles)
% hObject    handle to push_deter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vers=version;
tall=vers(1:3);
num=str2num(tall);

if num >= 7.6
    normgui;
elseif (num >=7.0 & num < 7.6)
    normgui_old;
else
    norm_old;
end



% --- Executes on button press in push_copy.
function push_copy_Callback(hObject, eventdata, handles)
% hObject    handle to push_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

print -dmeta;

% --- Executes on button press in push_print.
function push_print_Callback(hObject, eventdata, handles)
% hObject    handle to push_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

print -dsetup;
print;

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;

