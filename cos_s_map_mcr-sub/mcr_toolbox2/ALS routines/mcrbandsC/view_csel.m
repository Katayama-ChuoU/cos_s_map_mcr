function varargout = view_csel(varargin)
% VIEW_CSEL M-file for view_csel.fig
%      VIEW_CSEL, by itself, creates a new VIEW_CSEL or raises the existing
%      singleton*.
%
%      H = VIEW_CSEL returns the handle to a new VIEW_CSEL or the handle to
%      the existing singleton*.
%
%      VIEW_CSEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_CSEL.M with the given input arguments.
%
%      VIEW_CSEL('Property','Value',...) creates a new VIEW_CSEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_csel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_csel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_csel

% Last Modified by GUIDE v2.5 23-Mar-2010 15:47:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_csel_OpeningFcn, ...
                   'gui_OutputFcn',  @view_csel_OutputFcn, ...
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


% --- Executes just before view_csel is made visible.
function view_csel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_csel (see VARARGIN)

% Choose default command line output for view_csel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

    

%% MAX F

data=evalin('base','mcr_bands.Optional.Cequality.cknown');

    format short e
    set(handles.taula_csel,'Data',data);

% UIWAIT makes view_csel wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = view_csel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

