function varargout = correlCons(varargin)
% CORRELCONS MATLAB code for correlCons.fig
%      CORRELCONS, by itself, creates a new CORRELCONS or raises the existing
%      singleton*.
%
%      H = CORRELCONS returns the handle to a new CORRELCONS or the handle to
%      the existing singleton*.
%
%      CORRELCONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRELCONS.M with the given input arguments.
%
%      CORRELCONS('Property','Value',...) creates a new CORRELCONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correlCons_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correlCons_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help correlCons

% Last Modified by GUIDE v2.5 04-Aug-2014 12:25:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correlCons_OpeningFcn, ...
                   'gui_OutputFcn',  @correlCons_OutputFcn, ...
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


% --- Executes just before correlCons is made visible.
function correlCons_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correlCons (see VARARGIN)

% Choose default command line output for correlCons
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes correlCons wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correlCons_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% Initialization Code **************************************
evalin('base','mcr_als.alsOptions.correlation.appCorrelation=0;');


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

lsvar=evalin('base','whos');
[aa,bb]=size(lsvar);
j=2;
lsv(1)={'select a variable'};
for i=1:aa,
    csize=length(lsvar(i).class);
    if csize==6,
        if lsvar(i).class=='double',
            lsb=[lsvar(i).name];
            lsv(j)={lsb};
            j=j+1;
        end;
    end;
end;

set(hObject,'string',lsv)


% --- Executes on selection change in popup_select.
function popup_select_Callback(hObject, eventdata, handles)
% hObject    handle to popup_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_select

popmenu2=get(handles.popup_select,'String');
pm2=get(handles.popup_select,'Value');

if pm2==1
    
    % Deactivate options
    set(handles.text_species,'enable','off');
    set(handles.check_all,'enable','off','value',0);
    set(handles.edit_species,'enable','off','string',' ');
%     set(handles.text_type,'enable','off');
%     set(handles.radio_global,'enable','off','value',0);
%     set(handles.radio_local,'enable','off','value',0);
%     set(handles.text_matrix,'enable','off');
%     set(handles.radio_yes,'enable','off','value',0');
%     set(handles.radio_no,'enable','off','value',0);   
    
    evalin('base','mcr_als.alsOptions.correlation.csel_variable=[];');
    evalin('base','mcr_als.alsOptions.correlation.csel_matrix_name=[];');
    evalin('base','mcr_als.alsOptions.correlation.compreg=[];');
    evalin('base','mcr_als.alsOptions.correlation.iisel=[];');
    evalin('base','mcr_als.alsOptions.correlation.regmodel=[];');
    evalin('base','mcr_als.alsOptions.correlation.mateffect=[];');
    
else
    
    selec2=char([popmenu2(pm2)]);
    var_name=evalin('base',selec2);
    iisel=find(isfinite(var_name));
    assignin('base','var_name',var_name);
    assignin('base','iisel',iisel);
    evalin('base','mcr_als.alsOptions.correlation.csel_variable=var_name;');
    evalin('base','mcr_als.alsOptions.correlation.iisel=iisel;');   
    evalin('base','clear var_name iisel');
    assignin('base','csel_matrix_name',selec2);
    evalin('base','mcr_als.alsOptions.correlation.csel_matrix_name=csel_matrix_name;');
    evalin('base','clear csel_matrix_name');
            
    % Activate options
    set(handles.text_species,'enable','on');
    set(handles.check_all,'enable','on');
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    ceros=zeros(1,nsign);
    set(handles.edit_species,'enable','on','string',num2str(ceros));
    nexp=evalin('base','mcr_als.alsOptions.nexp');
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    ceros=zeros(1,nsign);
    assignin('base','valorCorrel',ceros);
    evalin('base','mcr_als.alsOptions.correlation.compreg=valorCorrel;');
    evalin('base','mcr_als.alsOptions.correlation.regmodel=0;');
    evalin('base','mcr_als.alsOptions.correlation.mateffect=0;');
    evalin('base','clear valorCorrel');
    
%     if nexp>1
%         nrMatC=evalin('base','mcr_als.alsOptions.multi.matc');
%         if nrMatC>1
%             set(handles.text_type,'enable','on');
%             set(handles.radio_global,'enable','on','value',1);
%             set(handles.radio_local,'enable','on','value',0);
%             set(handles.radio_yes,'enable','off','value',0);
%             set(handles.radio_no,'enable','off','value',0);
%             set(handles.text_matrix,'enable','on');
%         end
%     else
%         set(handles.text_type,'enable','off');
%         set(handles.radio_global,'enable','off','value',0);
%         set(handles.radio_local,'enable','off','value',0);
%         set(handles.radio_yes,'enable','off','value',0);
%         set(handles.radio_no,'enable','off','value',0);
%         set(handles.text_matrix,'enable','off');
%     end
    
end


% species selection
% *************************************************************************

% --- Executes on button press in check_all.
function check_all_Callback(hObject, eventdata, handles)
% hObject    handle to check_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_all

check1clos=get(hObject,'Value');

if check1clos==0
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    ceros=zeros(1,nsign);

    set(handles.edit_species,'enable','on','string',num2str(ceros));
    assignin('base','valorCorrel',ceros);
    evalin('base','mcr_als.alsOptions.correlation.compreg=valorCorrel;');
    evalin('base','clear valorCorrel');
    
elseif check1clos==1
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    unos=ones(1,nsign);    
    set(handles.edit_species,'enable','inactive','string',num2str(unos));
    assignin('base','valorCorrel',unos);
    evalin('base','mcr_als.alsOptions.correlation.compreg=valorCorrel;');
    evalin('base','clear valorCorrel');
end

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


function edit_species_Callback(hObject, eventdata, handles)
% hObject    handle to edit_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_species as text
%        str2double(get(hObject,'String')) returns contents of edit_species as a double

valorCorrel= str2num(get(hObject,'String'));
assignin('base','valorCorrel',valorCorrel);
evalin('base','mcr_als.alsOptions.correlation.compreg=valorCorrel;');
evalin('base','clear valorCorrel');


% multiple experiments  ---> this options is currently disabled
% *************************************************************************

% --- Executes on button press in radio_global.
function radio_global_Callback(hObject, eventdata, handles)
% hObject    handle to radio_global (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_global

type=0;% global
set(handles.radio_global,'enable','on','value',1);
set(handles.radio_local,'enable','on','value',0);
set(handles.radio_yes,'enable','off','value',0);
set(handles.radio_no,'enable','off','value',0);

assignin('base','typeCorrel',type);
evalin('base','mcr_als.alsOptions.correlation.regmodel=typeCorrel;');
evalin('base','mcr_als.alsOptions.correlation.mateffect=0;');
evalin('base','clear typeCorrel');


% --- Executes on button press in radio_local.
function radio_local_Callback(hObject, eventdata, handles)
% hObject    handle to radio_local (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_local
type=1;% local
set(handles.radio_global,'enable','on','value',0);
set(handles.radio_local,'enable','on','value',1);
set(handles.radio_yes,'enable','on','value',0);
set(handles.radio_no,'enable','on','value',1);

assignin('base','typeCorrel',type);
evalin('base','mcr_als.alsOptions.correlation.regmodel=typeCorrel;');
evalin('base','mcr_als.alsOptions.correlation.mateffect=0;');
evalin('base','clear typeCorrel');


% --- Executes on button press in radio_yes.
function radio_yes_Callback(hObject, eventdata, handles)
% hObject    handle to radio_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_yes
mEffect=1;% yes
set(handles.radio_yes,'enable','on','value',1);
set(handles.radio_no,'enable','on','value',0);

assignin('base','matEffect',mEffect);
evalin('base','mcr_als.alsOptions.correlation.mateffect=matEffect;');
evalin('base','clear matEffect');


% --- Executes on button press in radio_no.
function radio_no_Callback(hObject, eventdata, handles)
% hObject    handle to radio_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_no
mEffect=0;% yes
set(handles.radio_yes,'enable','on','value',0);
set(handles.radio_no,'enable','on','value',1);

assignin('base','matEffect',mEffect);
evalin('base','mcr_als.alsOptions.correlation.mateffect=matEffect;');
evalin('base','clear matEffect');



% S normalization
% *************************************************************************

% --- Executes on button press in check_Snorm.
function check_Snorm_Callback(hObject, eventdata, handles)
% hObject    handle to check_Snorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_Snorm

checkSNorm = get(hObject,'Value');
assignin('base','checkSNorm',checkSNorm);
evalin('base','mcr_als.alsOptions.correlation.checkSNorm=checkSNorm;');
evalin('base','clear checkSNorm');


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
