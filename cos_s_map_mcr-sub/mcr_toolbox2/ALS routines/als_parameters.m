function varargout = als_parameters(varargin)
% ALS_PARAMETERS MATLAB code for als_parameters.fig
%      ALS_PARAMETERS, by itself, creates a new ALS_PARAMETERS or raises the existing
%      singleton*.
%
%      H = ALS_PARAMETERS returns the handle to a new ALS_PARAMETERS or the handle to
%      the existing singleton*.
%
%      ALS_PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALS_PARAMETERS.M with the given input arguments.
%
%      ALS_PARAMETERS('Property','Value',...) creates a new ALS_PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before als_parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to als_parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help als_parameters

% Last Modified by GUIDE v2.5 27-Oct-2014 10:50:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @als_parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @als_parameters_OutputFcn, ...
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


% --- Executes just before als_parameters is made visible.
function als_parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to als_parameters (see VARARGIN)

% Choose default command line output for als_parameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes als_parameters wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = als_parameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Continue 
% *********************************************************************

% --- Executes on button press in push_continue.
function push_continue_Callback(hObject, eventdata, handles)
% hObject    handle to push_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
alsOptimization;

% Output
% *********************************************************************

% --- Executes during object creation, after setting all properties.
function edit_cOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

out=get(hObject,'String');
assignin('base','out_conc',out);
evalin('base','mcr_als.alsOptions.out.out_conc=out_conc;');
evalin('base','clear out_conc');

function edit_cOpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cOpt as text
%        str2double(get(hObject,'String')) returns contents of edit_cOpt as a double

out=get(hObject,'String');
assignin('base','out_conc',out);
evalin('base','mcr_als.alsOptions.out.out_conc=out_conc;');
evalin('base','clear out_conc');


% --- Executes during object creation, after setting all properties.
function edit_sOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

out=get(hObject,'String');
assignin('base','out_spec',out);
evalin('base','mcr_als.alsOptions.out.out_spec=out_spec;');
evalin('base','clear out_spec');

function edit_sOpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sOpt as text
%        str2double(get(hObject,'String')) returns contents of edit_sOpt as a double

out=get(hObject,'String');
assignin('base','out_spec',out);
evalin('base','mcr_als.alsOptions.out.out_spec=out_spec;');
evalin('base','clear out_spec');


% --- Executes during object creation, after setting all properties.
function edit_stdOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stdOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

out=get(hObject,'String');
assignin('base','out_std',out);
evalin('base','mcr_als.alsOptions.out.out_std=out_std;');
evalin('base','clear out_std');


function edit_stdOpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stdOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stdOpt as text
%        str2double(get(hObject,'String')) returns contents of edit_stdOpt as a double

out=get(hObject,'String');
assignin('base','out_std',out);
evalin('base','mcr_als.alsOptions.out.out_std=out_std;');
evalin('base','clear out_std');


% --- Executes during object creation, after setting all properties.
function edit_areaOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_areaOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

out=get(hObject,'String');
assignin('base','out_area',out);
evalin('base','mcr_als.alsOptions.out.out_area=out_area;');
evalin('base','clear out_area');


function edit_areaOpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_areaOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_areaOpt as text
%        str2double(get(hObject,'String')) returns contents of edit_areaOpt as a double

out=get(hObject,'String');
assignin('base','out_area',out);
evalin('base','mcr_als.alsOptions.out.out_area=out_area;');
evalin('base','clear out_area');


% --- Executes during object creation, after setting all properties.
function edit_resOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_resOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

out=get(hObject,'String');
assignin('base','out_res',out);
evalin('base','mcr_als.alsOptions.out.out_res=out_res;');
evalin('base','clear out_res');


function edit_resOpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_resOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_resOpt as text
%        str2double(get(hObject,'String')) returns contents of edit_resOpt as a double

out=get(hObject,'String');
assignin('base','out_res',out);
evalin('base','mcr_als.alsOptions.out.out_res=out_res;');
evalin('base','clear out_res');


% --- Executes during object creation, after setting all properties.
function edit_ratioOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ratioOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

out=get(hObject,'String');
assignin('base','out_rat',out);
evalin('base','mcr_als.alsOptions.out.out_rat=out_rat;');
evalin('base','clear out_rat');


function edit_ratioOpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ratioOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ratioOpt as text
%        str2double(get(hObject,'String')) returns contents of edit_ratioOpt as a double

out=get(hObject,'String');
assignin('base','out_rat',out);
evalin('base','mcr_als.alsOptions.out.out_rat=out_rat;');
evalin('base','clear out_rat');


% Parameters
% ***************************************************************************

% --- Executes during object creation, after setting all properties.
function edit_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nit=50;
assignin('base','nit',nit);
evalin('base','mcr_als.alsOptions.opt.nit=nit;');
evalin('base','clear nit');

function edit_iter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_iter as text
%        str2double(get(hObject,'String')) returns contents of edit_iter as a double

nit=str2num(get(hObject,'String'));
assignin('base','nit',nit);
evalin('base','mcr_als.alsOptions.opt.nit=nit;');
evalin('base','clear nit');

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

tolsigma=str2num(get(hObject,'String'));
assignin('base','tolsigma',tolsigma);
evalin('base','mcr_als.alsOptions.opt.tolsigma=tolsigma;');
evalin('base','clear tolsigma');

function edit_conv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_conv as text
%        str2double(get(hObject,'String')) returns contents of edit_conv as a double

tolsigma=str2num(get(hObject,'String'));
assignin('base','tolsigma',tolsigma);
evalin('base','mcr_als.alsOptions.opt.tolsigma=tolsigma;');
evalin('base','clear tolsigma');

% --- Executes on button press in check_graph.
function check_graph_Callback(hObject, eventdata, handles)
% hObject    handle to check_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_graph

val=get(hObject,'Value');

if val==1
    gr='y';
else
    gr='n';
end

assignin('base','gr',gr);
evalin('base','mcr_als.alsOptions.opt.gr=gr;');
evalin('base','clear gr');


% --- Executes on button press in push_back2cons.
function push_back2cons_Callback(hObject, eventdata, handles)
% hObject    handle to push_back2cons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegC'');');  
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegS'');'); 
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodC'');');
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodS'');');  
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''closure'');'); 
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''cselcC'');'); 
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''sselcS'');');
evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''trilin'');');
% evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''multi'');');
evalin('base','mcr_als.alsOptions.nonegC.noneg=0;');
evalin('base','mcr_als.alsOptions.nonegS.noneg=0;');
evalin('base','mcr_als.alsOptions.unimodC.unimodal=0;');
evalin('base','mcr_als.alsOptions.unimodS.unimodal=0;');
evalin('base','mcr_als.alsOptions.closure.closure=0;');
evalin('base','mcr_als.alsOptions.cselcC.cselcon=0;');
evalin('base','mcr_als.alsOptions.sselcS.sselcon=0;');
evalin('base','mcr_als.alsOptions.trilin.tril=0;');
% evalin('base','mcr_als.alsOptions.multi.datamod=0;');
evalin('base','mcr_als.alsOptions.opt.gr=''y'';');

if evalin('base','mcr_als.alsOptions.nexp') > 1
    if evalin('base','mcr_als.alsOptions.multi.matc') > 1
        evalin('base','mcr_als.alsOptions.trilin.appTril=0;');
        rowMultiConstraints;
    else
        rowModeConstraints;
    end
else
    rowModeConstraints;
end
