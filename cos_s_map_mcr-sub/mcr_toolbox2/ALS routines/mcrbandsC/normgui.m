
function varargout = normgui(varargin)
% NORMGUI M-file for normgui.fig
%      NORMGUI, by itself, creates a new NORMGUI or raises the existing
%      singleton*.
%
%      H = NORMGUI returns the handle to a new NORMGUI or the handle to
%      the existing singleton*.
%
%      NORMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NORMGUI.M with the given input arguments.
%
%      NORMGUI('Property','Value',...) creates a new NORMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before normgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to normgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help normgui

% Last Modified by GUIDE v2.5 27-Oct-2009 15:09:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @normgui_OpeningFcn, ...
    'gui_OutputFcn',  @normgui_OutputFcn, ...
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


% --- Executes just before normgui is made visible.
function normgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to normgui (see VARARGIN)

% Choose default command line output for normgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes normgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = normgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% GUI -------
% ***********************************************************************





% seleccio especies
% ***********************************************************************

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

dim=evalin('base','mcr_bands.temp.nsign');
j=2;
llistannc(1)={'select a species...'};
for i=1:dim;
    llistnnc=['Species nr. ',num2str(i)];
    llistannc(j)={llistnnc};
    j=j+1;
end;

set(hObject,'string',llistannc)



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

valorpop=get(hObject,'Value')-1;

fband=evalin('base','mcr_bands.Results.fband');
finic=evalin('base','mcr_bands.Results.finic');
tband=evalin('base','mcr_bands.Results.tband');
tbandsvd=evalin('base','mcr_bands.Results.tbandsvd');
nsign=evalin('base','mcr_bands.temp.nsign');
[rows,cols]=size(tband);

if valorpop == 0
    set(handles.edit_max,'String',' ');
    set(handles.edit_min,'String',' ');
    set(handles.edit_finic,'String',' ');
    set(handles.edit_diff,'String',' ');
    set(handles.taula_maxMCR,'Data',[]);
    set(handles.taula_maxSVD,'Data',[]);
    set(handles.taula_minMCR,'Data',[]);
    set(handles.taula_minSVD,'Data',[]);
    
    
else
    %% MAX F
    format short e
    valor=num2str(fband(1,valorpop),4);
    set(handles.edit_max,'String',valor);
    
    %% MIN F
    format short e
    valor=num2str(fband(2,valorpop),4);
    set(handles.edit_min,'String',valor);
    
    %% DIFF F
    format short e
    valor=num2str([fband(1,valorpop)-fband(2,valorpop)],4);
    set(handles.edit_diff,'String',valor);
    
    %% MAX MCR
    format short e
    data=tband([1+((valorpop-1)*rows/nsign):((valorpop-1)*nsign)+(valorpop*nsign)],:);
    set(handles.taula_maxMCR,'Data',data);
    
    %% MIN MCR
    format short e
    data=tband([((valorpop-1)*nsign)+(valorpop*nsign)+1:2*valorpop*nsign],:);
    set(handles.taula_minMCR,'Data',data);
    
    %% MAX SVD
    format short e
    data=tbandsvd([1+((valorpop-1)*rows/nsign):((valorpop-1)*nsign)+(valorpop*nsign)],:);
    set(handles.taula_maxSVD,'Data',data);
    
    %% MIN SVD
    format short e
    data=tbandsvd([((valorpop-1)*nsign)+(valorpop*nsign)+1:2*valorpop*nsign],:);
    set(handles.taula_minSVD,'Data',data);
    %% F INIC
    format short e
    valor=num2str(finic(1,valorpop),4);
    set(handles.edit_finic,'String',valor);
end


% valors f min
% ***********************************************************************



% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min as text
%        str2double(get(hObject,'String')) returns contents of edit_min as a double



% valors f min
% ***********************************************************************


% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max as text
%        str2double(get(hObject,'String')) returns contents of edit_max as a double


% --- Executes on button press in edit_finic.
function edit_finic_Callback(hObject, eventdata, handles)
% hObject    handle to edit_finic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit_finic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_finic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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



function edit_diff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_diff as text
%        str2double(get(hObject,'String')) returns contents of edit_diff as a double


% --- Executes during object creation, after setting all properties.
function edit_diff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
warndlg('Use the Close button to close this window.');


% --- Executes on button press in push_back.
function push_back_Callback(hObject, eventdata, handles)
% hObject    handle to push_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);
