function varargout = correlCons_reload(varargin)
% CORRELCONS_RELOAD MATLAB code for correlCons_reload.fig
%      CORRELCONS_RELOAD, by itself, creates a new CORRELCONS_RELOAD or raises the existing
%      singleton*.
%
%      H = CORRELCONS_RELOAD returns the handle to a new CORRELCONS_RELOAD or the handle to
%      the existing singleton*.
%
%      CORRELCONS_RELOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRELCONS_RELOAD.M with the given input arguments.
%
%      CORRELCONS_RELOAD('Property','Value',...) creates a new CORRELCONS_RELOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correlCons_reload_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correlCons_reload_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help correlCons_reload

% Last Modified by GUIDE v2.5 29-Jan-2013 11:58:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correlCons_reload_OpeningFcn, ...
                   'gui_OutputFcn',  @correlCons_reload_OutputFcn, ...
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


% --- Executes just before correlCons_reload is made visible.
function correlCons_reload_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correlCons_reload (see VARARGIN)

% Choose default command line output for correlCons_reload
handles.output = hObject;


% Update the figure with old values
% *******************************************************************

% texts
    set(handles.text_species,'enable','inactive');
%     set(handles.text_type,'enable','inactive');
%     set(handles.text_matrix,'enable','inactive');

% check all
compreg=evalin('base','mcr_als.alsOptions.correlation.compreg');
total=sum(compreg);
nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
if total==nsign;
    set(handles.check_all,'value',1,'enable','inactive');
else
    set(handles.check_all,'value',0,'enable','inactive');
end

% multiexperiments
nexp=evalin('base','mcr_als.alsOptions.nexp');

if nexp==1
%     set(handles.radio_global,'enable','inactive','value',0);
%     set(handles.radio_local,'enable','inactive','value',0);
%     set(handles.radio_no,'enable','inactive','value',0);
%     set(handles.radio_yes,'enable','inactive','value',0);
else
%     % regmodel
%     regmodel=evalin('base','mcr_als.alsOptions.correlation.regmodel');
%     % mateffect
%     mateffect=evalin('base','mcr_als.alsOptions.correlation.mateffect');
%     
%     if regmodel==0
%         set(handles.radio_global,'enable','inactive','value',1);
%         set(handles.radio_local,'enable','inactive','value',0);
%         set(handles.radio_no,'enable','inactive','value',0);
%         set(handles.radio_yes,'enable','inactive','value',0);
%     else
%         set(handles.radio_global,'enable','inactive','value',0);
%         set(handles.radio_local,'enable','inactive','value',1);       
%         if mateffect==0
%             set(handles.radio_no,'enable','inactive','value',1);
%             set(handles.radio_yes,'enable','inactive','value',0);
%         else
%             set(handles.radio_no,'enable','inactive','value',0);
%             set(handles.radio_yes,'enable','inactive','value',1);
%         end
%     end
%     
    
    
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes correlCons_reload wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correlCons_reload_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% Code *************************************************************************

% --- Executes during object creation, after setting all properties.
function popup_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

matrix_name=evalin('base','mcr_als.alsOptions.correlation.csel_matrix_name;');
set(hObject,'string',matrix_name,'enable','inactive');


% --- Executes on selection change in popup_select.
function popup_select_Callback(hObject, eventdata, handles)
% hObject    handle to popup_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_select
% nothing


% species selection
% *************************************************************************

% --- Executes on button press in check_all.
function check_all_Callback(hObject, eventdata, handles)
% hObject    handle to check_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_all


% --- Executes during object creation, after setting all properties.
function edit_species_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

compreg=evalin('base','mcr_als.alsOptions.correlation.compreg');
set(hObject,'string',num2str(compreg),'enable','inactive');

function edit_species_Callback(hObject, eventdata, handles)
% hObject    handle to edit_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_species as text
%        str2double(get(hObject,'String')) returns contents of edit_species as a double

% nothing



% multiple experiments
% *************************************************************************

% --- Executes on button press in radio_global.
function radio_global_Callback(hObject, eventdata, handles)
% hObject    handle to radio_global (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_global


% --- Executes on button press in radio_local.
function radio_local_Callback(hObject, eventdata, handles)
% hObject    handle to radio_local (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_local


% --- Executes on button press in radio_yes.
function radio_yes_Callback(hObject, eventdata, handles)
% hObject    handle to radio_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_yes


% --- Executes on button press in radio_no.
function radio_no_Callback(hObject, eventdata, handles)
% hObject    handle to radio_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_no


% buttons
% *************************************************************************

% --- Executes on button press in push_reset.
function push_reset_Callback(hObject, eventdata, handles)
% hObject    handle to push_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''correlation'');');
close;
correlCons;

% --- Executes on button press in push_done.
function push_done_Callback(hObject, eventdata, handles)
% hObject    handle to push_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_als.alsOptions.correlation.appCorrelation=1;');
close;

% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''correlation'');');
evalin('base','mcr_als.alsOptions.correlation.appCorrelation=0;');
close;
