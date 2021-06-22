function varargout = valueg(varargin)
% VALUEG M-file for valueg.fig
%      VALUEG, by itself, creates a new VALUEG or raises the existing
%      singleton*.
%
%      H = VALUEG returns the handle to a new VALUEG or the handle to
%      the existing singleton*.
%
%      VALUEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VALUEG.M with the given input arguments.
%
%      VALUEG('Property','Value',...) creates a new VALUEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before valueg_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to valueg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help valueg

% Last Modified by GUIDE v2.5 28-Oct-2009 14:36:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @valueg_OpeningFcn, ...
    'gui_OutputFcn',  @valueg_OutputFcn, ...
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


% --- Executes just before valueg is made visible.
function valueg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to valueg (see VARARGIN)

% Choose default command line output for valueg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


format short e
data=evalin('base','mcr_bands.Results.exitflag');
%     set(handles.taula_minSVD,'Data',data);

colnames{1,1} = 'Maximum';
colnames{1,2} = 'Minimum';
htable1 = uitable(data,colnames,'ColumnWidth',90,'Position', [130 140 200 100]);


% UIWAIT makes valueg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = valueg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






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

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
warndlg('Use the Close button to close this window.');


