function varargout = norm_old(varargin)
% NORM_OLD M-file for norm_old.fig
%      NORM_OLD, by itself, creates a new NORM_OLD or raises the existing
%      singleton*.
%
%      H = NORM_OLD returns the handle to a new NORM_OLD or the handle to
%      the existing singleton*.
%
%      NORM_OLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NORM_OLD.M with the given input arguments.
%
%      NORM_OLD('Property','Value',...) creates a new NORM_OLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before norm_old_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to norm_old_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help norm_old

% Last Modified by GUIDE v2.5 04-Nov-2008 15:12:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @norm_old_OpeningFcn, ...
    'gui_OutputFcn',  @norm_old_OutputFcn, ...
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


% --- Executes just before norm_old is made visible.
function norm_old_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to norm_old (see VARARGIN)

% Choose default command line output for norm_old
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes norm_old wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = norm_old_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_print.
function push_print_Callback(hObject, eventdata, handles)
% hObject    handle to push_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


disp('**********************************************************');
disp('Summary of the evaluation of final norms of band solutions');
disp('**********************************************************');

fband=evalin('base','mcr_bands.Results.fband');
tband=evalin('base','mcr_bands.Results.tband');
tbandsvd=evalin('base','mcr_bands.Results.tbandsvd');
nsign=evalin('base','mcr_bands.temp.nsign');

ij=1;ik=1;il=1;

for i=1:nsign*2,
    disp('mcr and svd t values and corrsponding f optim value for species'),disp(il);
    if mod(i,2)==0, disp('min');il=il+1;else disp('max'), end
    disp('tband mcr');disp(tband(ij:ij+nsign-1,:));disp('tband svd');disp(tbandsvd(ij:ij+nsign-1,:));disp('foptim');disp(fband(ik));
    disp(' ')
    ij=ij+nsign;ik=ik+1;
end

close;


% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


close;

