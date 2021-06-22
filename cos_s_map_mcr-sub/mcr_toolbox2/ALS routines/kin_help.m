function varargout = kin_help(varargin)
% KIN_HELP MATLAB code for kin_help.fig
%      KIN_HELP, by itself, creates a new KIN_HELP or raises the existing
%      singleton*.
%
%      H = KIN_HELP returns the handle to a new KIN_HELP or the handle to
%      the existing singleton*.
%
%      KIN_HELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KIN_HELP.M with the given input arguments.
%
%      KIN_HELP('Property','Value',...) creates a new KIN_HELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kin_help_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kin_help_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kin_help

% Last Modified by GUIDE v2.5 27-Oct-2014 13:17:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kin_help_OpeningFcn, ...
                   'gui_OutputFcn',  @kin_help_OutputFcn, ...
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


% --- Executes just before kin_help is made visible.
function kin_help_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kin_help (see VARARGIN)

% Choose default command line output for kin_help
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kin_help wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kin_help_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
