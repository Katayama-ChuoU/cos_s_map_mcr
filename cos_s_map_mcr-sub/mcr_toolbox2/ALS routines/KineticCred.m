function varargout = KineticCred(varargin)
% KINETICCRED MATLAB code for KineticCred.fig
%      KINETICCRED, by itself, creates a new KINETICCRED or raises the existing
%      singleton*.
%
%      H = KINETICCRED returns the handle to a new KINETICCRED or the handle to
%      the existing singleton*.
%
%      KINETICCRED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KINETICCRED.M with the given input arguments.
%
%      KINETICCRED('Property','Value',...) creates a new KINETICCRED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KineticCred_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KineticCred_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KineticCred

% Last Modified by GUIDE v2.5 27-Oct-2014 13:19:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KineticCred_OpeningFcn, ...
                   'gui_OutputFcn',  @KineticCred_OutputFcn, ...
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


% --- Executes just before KineticCred is made visible.
function KineticCred_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KineticCred (see VARARGIN)

% Choose default command line output for KineticCred
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KineticCred wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KineticCred_OutputFcn(hObject, eventdata, handles) 
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
