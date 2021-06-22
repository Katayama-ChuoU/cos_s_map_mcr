function varargout = mcrbandsg(varargin)
% MCRBANDSG M-file for mcrbandsg.fig
%      MCRBANDSG, by itself, creates a new MCRBANDSG or raises the existing
%      singleton*.
%
%      H = MCRBANDSG returns the handle to a new MCRBANDSG or the handle to
%      the existing singleton*.
%
%      MCRBANDSG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCRBANDSG.M with the given input arguments.
%
%      MCRBANDSG('Property','Value',...) creates a new MCRBANDSG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mcrbandsg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcrbandsg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mcrbandsg

% Last Modified by GUIDE v2.5 01-Jun-2010 17:57:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mcrbandsg_OpeningFcn, ...
    'gui_OutputFcn',  @mcrbandsg_OutputFcn, ...
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


% --- Executes just before mcrbandsg is made visible.
function mcrbandsg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcrbandsg (see VARARGIN)

% Choose default command line output for mcrbandsg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes mcrbandsg wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Variables to initialize
evalin('base','mcr_bands.Options.Resultats=0;');
evalin('base','mcr_bands.Options.flagOptim=0;');
evalin('base','mcr_bands.Options.knownC=0;');
evalin('base','mcr_bands.Options.knownS=0;');

% --- Outputs from this function are returned to the command line.
function varargout = mcrbandsg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
disp ('   ')
disp ('   ')
disp ('   ************************************************************************************')
disp ('   *                           MCR-BANDS GRAPHIC INTERFACE                            *')
disp ('   *                           MATLAB Optimization Toolbox is required                *')
disp ('   *                           January, 2010                                          *')
disp ('   ************************************************************************************')
disp ('   ')

% initial parameters
evalin('base','mcr_bands.Options.showplots=1;');
evalin('base','mcr_bands.Optional.param_flag=0;');
evalin('base','mcr_bands.Options.NExpFlag=0;');

% advanced parameters
if (evalin('base','mcr_bands.Optional.param_flag;'))==0
    evalin('base','mcr_bands.Optional.Opt_param.Display=''iter'';');
    evalin('base','mcr_bands.Optional.Opt_param.Diagnostics=''on'';');
    evalin('base','mcr_bands.Optional.Opt_param.TolCon=0.0001;');
    evalin('base','mcr_bands.Optional.Opt_param.TolFun=0.00001;');
    evalin('base','mcr_bands.Optional.Opt_param.TolX=0.0001;');
    evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange=0.00001;');
    evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange=0.1;');
    evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals=3000;');
end


% *************************************************************************
% POPUPS mandatory for concs and specs 
% *************************************************************************


% --- Executes during object creation, after setting all properties.
function popup_conc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_conc (see GCBO)
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
lsv(1)={'select a variable from the WS'};
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


% --- Executes during object creation, after setting all properties.
function popup_spec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_spec (see GCBO)
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
lsv(1)={'select a variable from the WS'};
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

% --- Executes on selection change in popup_data.
function popup_data_Callback(hObject, eventdata, handles)
% hObject    handle to popup_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_data

popUp=get(handles.popup_data,'String');
pU=get(handles.popup_data,'Value');

if pU==1
    
else
    sel=char([popUp(pU)]);
    matdad=evalin('base',sel);
    assignin('base','matdad',matdad);
    evalin('base','mcr_bands.Data.data=matdad;');
    evalin('base','clear matdad');
    set(handles.popup_conc,'enable','on');
end

% --- Executes on selection change in popup_conc.
function popup_conc_Callback(hObject, eventdata, handles)
% hObject    handle to popup_conc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_conc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_conc
popUp=get(handles.popup_conc,'String');
pU=get(handles.popup_conc,'Value');

if pU==1
    
else
    sel=char([popUp(pU)]);
    concdad=evalin('base',sel);
    assignin('base','concdad',concdad);
    evalin('base','mcr_bands.Data.conc=concdad;');
    [xdim,ydim]=size(concdad);
    assignin('base','ydim',ydim);
    evalin('base','mcr_bands.Optional.Rotation.t0=eye(ydim);');
    %%evalin('base','mcr_bands.Optional.Speciation.ispec=[1:ydim];');
    evalin('base','clear concdad ydim');
    set(handles.popup_spec,'enable','on');
end

% --- Executes on selection change in popup_spec.
function popup_spec_Callback(hObject, eventdata, handles)
% hObject    handle to popup_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_spec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_spec
popUp=get(handles.popup_spec,'String');
pU=get(handles.popup_spec,'Value');

if pU==1
    
else
    sel=char([popUp(pU)]);
    specdad=evalin('base',sel);
    assignin('base','specdad',specdad);
    evalin('base','mcr_bands.Data.spec=specdad;');
    evalin('base','clear specdad');
    
    if 1==1;
        set(handles.popup_norm,'enable','on');
        set(handles.popup_nonneg,'enable','on');
        set(handles.popup_unimod,'enable','on');
        set(handles.popup_trilin,'enable','on');
        set(handles.popup_conceq,'enable','on');
        set(handles.popup_speceq,'enable','on');
    end
end


% *************************************************************************
% popups - constraints
% *************************************************************************

% creation

% --- Executes during object creation, after setting all properties.
function popup_norm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: no closure nor normalization'};
llista(2)={'apply closure normalization'};
llista(3)={'spectra normalization'};
llista(4)={'spectra normalization using only off-diagonal T values'};
set(hObject,'string',llista)
evalin('base','mcr_bands.Constraints.Normalization.iclos=0;'); %defaut

% --- Executes during object creation, after setting all properties.
function popup_nonneg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_nonneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: do not apply non-negativity constraints'};
llista(2)={'apply non-negativity constraints in conc'};
llista(3)={'non-negativity constraints in spec and conc'};
llista(4)={'non-negativity constraints only in spec '};
set(hObject,'string',llista)
evalin('base','mcr_bands.Constraints.Non_negativity.ineg=0;');%default

% --- Executes during object creation, after setting all properties.
function popup_unimod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_unimod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: do not apply unimodality constraints'};
llista(2)={'apply unimodality in concn'};
llista(3)={'apply unimodality in spectra (not implemented yet)'};
llista(4)={'apply unimodality in both (not implemented yet)'};
set(hObject,'string',llista)
evalin('base','mcr_bands.Constraints.Unimodality.iunimod=0;');%default

% --- Executes during object creation, after setting all properties.
function popup_trilin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_trilin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: single data matrix = no three-way data'};
llista(2)={'three-way non-trilinear data'};
llista(3)={'three-way trilinear data'};
set(hObject,'string',llista)
evalin('base','mcr_bands.Constraints.Trilinearity.itril=0;');%default

% --- Executes during object creation, after setting all properties.
function popup_conceq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_conceq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: do not apply equality constraints'};
llista(2)={'apply equality constraints'};
llista(3)={'apply selectivity constraints (<=)'};
set(hObject,'string',llista)
evalin('base','mcr_bands.Constraints.Cequality.iknown=0;');%default

% --- Executes during object creation, after setting all properties.
function popup_speceq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_speceq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'default: do not apply equality constraints'};
llista(2)={'apply equality constraints'};
llista(3)={'apply selectivity constraints (<=)'};
set(hObject,'string',llista)
evalin('base','mcr_bands.Constraints.Sequality.iknown=0;');%default


% Selection change

% --- Executes on selection change in popup_norm.
function popup_norm_Callback(hObject, eventdata, handles)
% hObject    handle to popup_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_norm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_norm

cnorm=get(hObject,'Value')-1;
assignin('base','cnorm',cnorm);
evalin('base','mcr_bands.Constraints.Normalization.iclos=cnorm;');
evalin('base','clear cnorm');

% --- Executes on selection change in popup_nonneg.
function popup_nonneg_Callback(hObject, eventdata, handles)
% hObject    handle to popup_nonneg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_nonneg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_nonneg

cnonneg=get(hObject,'Value')-1;
assignin('base','cnonneg',cnonneg);
evalin('base','mcr_bands.Constraints.Non_negativity.ineg=cnonneg;');
evalin('base','clear cnonneg');

% --- Executes on selection change in popup_unimod.
function popup_unimod_Callback(hObject, eventdata, handles)
% hObject    handle to popup_unimod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_unimod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_unimod

cunim=get(hObject,'Value')-1;
assignin('base','cunim',cunim);
evalin('base','mcr_bands.Constraints.Unimodality.iunimod=cunim;');
evalin('base','clear cunim');

% --- Executes on selection change in popup_trilin.
function popup_trilin_Callback(hObject, eventdata, handles)
% hObject    handle to popup_trilin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_trilin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_trilin

ctril=get(hObject,'Value')-1;
assignin('base','ctril',ctril);
evalin('base','mcr_bands.Constraints.Trilinearity.itril=ctril;');
evalin('base','clear ctril');
if ctril == 0
    set(handles.edit_nr,'enable','off','String','1','BackgroundColor',[1 1 1]);
    evalin('base','mcr_bands.Optional.NumExp.nexp=1;');
    evalin('base','mcr_bands.Options.NExpFlag=0;');
else
    set(handles.edit_nr,'enable','on','String','1','BackgroundColor',[1 0.6 0.6]);
    evalin('base','mcr_bands.Options.NExpFlag=1;');
end

% --- Executes on selection change in popup_conceq.
function popup_conceq_Callback(hObject, eventdata, handles)
% hObject    handle to popup_conceq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_conceq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_conceq

ccknown=get(hObject,'Value')-1;
assignin('base','ccknown',ccknown);
evalin('base','mcr_bands.Constraints.Cequality.iknown=ccknown;');
evalin('base','clear ccknown');
if ccknown == 0
    set(handles.popup_knownC,'enable','off');
    evalin('base','mcr_bands.Options.knownC=0;');
else
    set(handles.popup_knownC,'enable','on');
    evalin('base','mcr_bands.Options.knownC=1;');
end

% --- Executes on selection change in popup_speceq.
function popup_speceq_Callback(hObject, eventdata, handles)
% hObject    handle to popup_speceq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_speceq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_speceq

scknown=get(hObject,'Value')-1;
assignin('base','scknown',scknown);
evalin('base','mcr_bands.Constraints.Sequality.iknown=scknown;');
evalin('base','clear scknown');
if scknown == 0
    set(handles.popup_knownS,'enable','off');
    evalin('base','mcr_bands.Options.knownS=0;');
else
    set(handles.popup_knownS,'enable','on');
    evalin('base','mcr_bands.Options.knownS=1;');
end


% *************************************************************************
% Popup - Optional constraints
% *************************************************************************

% --- Executes during object creation, after setting all properties.
function popup_rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_rotation (see GCBO)
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
lsv(1)={'default is t=eye(nsign) or select a variable'};
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


% --- Executes during object creation, after setting all properties.
function popup_knownC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_knownC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

lsvar=evalin('base','whos');
[aa,bb]=size(lsvar);
j=3;
lsv(1)={'select a variable or "use isp matrix"'};
lsv(2)={'use isp matrix'};
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
evalin('base','mcr_bands.Optional.Cequality.cknown=[];'); %defaut

% --- Executes during object creation, after setting all properties.
function popup_knownS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_knownS (see GCBO)
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
evalin('base','mcr_bands.Optional.Sequality.sknown=[];'); %defaut

% --- Executes on selection change in popup_rotation.
function popup_rotation_Callback(hObject, eventdata, handles)
% hObject    handle to popup_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_rotation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popup_rotation



popUp=get(handles.popup_rotation,'String');
pU=get(handles.popup_rotation,'Value');

if pU==1
    concdad=evalin('base','mcr_bands.Data.conc;');
    [xdim,ydim]=size(concdad);
    assignin('base','ydim',ydim);
    evalin('base','mcr_bands.Optional.Rotation.t0=eye(ydim);');
    evalin('base','clear ydim');
else
    sel=char([popUp(pU)]);
    rota=evalin('base',sel);
    assignin('base','rota',rota);
    evalin('base','mcr_bands.Optional.Rotation.t0=rota;');
    evalin('base','clear rota');
end


% --- Executes on selection change in popup_knownC.
function popup_knownC_Callback(hObject, eventdata, handles)
% hObject    handle to popup_knownC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_knownC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popup_knownC


% -------------------------------------------
popUp=get(handles.popup_knownC,'String');
pU=get(handles.popup_knownC,'Value');

if pU==1
    evalin('base','mcr_bands.Optional.Cequality.cknown=[];');
    set(handles.push_isp,'enable','off');
elseif pU==2
    set(handles.push_isp,'enable','on');
    evalin('base','mcr_bands.Options.knownC=0;');
else
    set(handles.push_isp,'enable','off');
    sel=char([popUp(pU)]);
    ckxx=evalin('base',sel);
    assignin('base','ckxx',ckxx);
    evalin('base','mcr_bands.Optional.Cequality.cknown=ckxx;');
    evalin('base','clear ckxx');
    evalin('base','mcr_bands.Options.knownC=0;');
end

%
% AQUí **************************************
%


% --- Executes on button press in push_isp.
function push_isp_Callback(hObject, eventdata, handles)
% hObject    handle to push_isp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

push_isp;


% --- Executes on selection change in popup_knownS.
function popup_knownS_Callback(hObject, eventdata, handles)
% hObject    handle to popup_knownS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_knownS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popup_knownS


% -------------------------------------------
popUp=get(handles.popup_knownS,'String');
pU=get(handles.popup_knownS,'Value');

if pU==1
    evalin('base','mcr_bands.Optional.Sequality.sknown=[];');
else
    sel=char([popUp(pU)]);
    skxx=evalin('base',sel);
    assignin('base','skxx',skxx);
    evalin('base','mcr_bands.Optional.Sequality.sknown=skxx;');
    evalin('base','clear skxx');
    evalin('base','mcr_bands.Options.knownS=0;');
end


% --- Executes during object creation, after setting all properties.
function edit_nr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nr as text
%        str2double(get(hObject,'String')) returns contents of edit_nr as a double

numb_exper= str2num(get(hObject,'String'));
evalin('base','mcr_bands.Options.NExpFlag=0;');

set(handles.edit_nr,'BackgroundColor',[0.8 1 0.8]);

assignin('base','numb_exper',numb_exper);
evalin('base','mcr_bands.Optional.NumExp.nexp=numb_exper;');
evalin('base','clear numb_exper');


% *************************************************************************
% PUSHBUTTONS
% *************************************************************************

% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('cancel');
evalin('base','clear mcr_bands;');
close;

% --- Executes on button press in push_reset.
function push_reset_Callback(hObject, eventdata, handles)
% hObject    handle to push_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('reset mcrbandsg');
evalin('base','clear mcr_bands;');
close;
mcrbandsg;

% --- Executes on button press in push_opt.
function push_opt_Callback(hObject, eventdata, handles)
% hObject    handle to push_opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% go ahead
% creation of ig
%close;

%*************************************************************************
% Optimization starts
%*************************************************************************


% check flag de NExp
if (evalin('base','mcr_bands.Options.NExpFlag')==1)
    warndlg('Check the number of experiments');
else
    
    
    if (evalin('base','mcr_bands.Options.knownC')==1)
        warndlg('Check the cknown');
    else
        
        if (evalin('base','mcr_bands.Options.knownS')==1)
            warndlg('Check the sknown');
        else
            
            global g
            global nconstr
            
            %    m=evalin('base','mcr_bands.Data.data;');
            c=evalin('base','mcr_bands.Data.conc;');
            s=evalin('base','mcr_bands.Data.spec;');
            t0=evalin('base','mcr_bands.Optional.Rotation.t0;');
            cknown=evalin('base','mcr_bands.Optional.Cequality.cknown;');
            sknown=evalin('base','mcr_bands.Optional.Sequality.sknown;');
            % ispec=evalin('base','mcr_bands.Optional.Speciation.ispec;');
            
            
            tband=[];tbandsvd=[];sband=[];cband=[];optband=[];lofband=[];fband=[];detcbands=[];detsbands=[];
            foptim=[];iknown=0;iclos=0;iunimod=0;clos=[];ineg=2;nexp=1;itil=0;
            % new version
            nconstr=0;g=[];
            tnorm=norm(c*s,'fro');normband=[];
            
            [nrow,nsign]=size(c);
            [nsign,ncol]=size(s);
            
            % evaluation of initial determinants
            detcbands=det(c'*c);
            detsbands=det(s*s');
            
         % options=optimset('Display',evalin('base','mcr_bands.Optional.Opt_param.Display'),'Diagnostics',evalin('base','mcr_bands.Optional.Opt_param.Diagnostics=''on'),'TolCon',evalin('base','mcr_bands.Optional.Opt_param.TolCon'),'TolFun',evalin('base','mcr_bands.Optional.Opt_param.TolFun'),'Tolx',evalin('base','mcr_bands.Optional.Opt_param.TolX'),'DiffMinChange',evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange'),'DiffMaxChange',evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange'),'MaxFunEvals',evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals'));
            
            options=optimset('Display',evalin('base','mcr_bands.Optional.Opt_param.Display'),'Diagnostics',evalin('base','mcr_bands.Optional.Opt_param.Diagnostics'),'TolCon',evalin('base','mcr_bands.Optional.Opt_param.TolCon'),'TolFun',evalin('base','mcr_bands.Optional.Opt_param.TolFun'),'Tolx',evalin('base','mcr_bands.Optional.Opt_param.TolX'),'DiffMinChange',evalin('base','mcr_bands.Optional.Opt_param.DiffMinChange'),'DiffMaxChange',evalin('base','mcr_bands.Optional.Opt_param.DiffMaxChange'),'MaxFunEvals',evalin('base','mcr_bands.Optional.Opt_param.MaxFunEvals'));
            
            % definition of constraints ig
            % normalization constraints: closure or spectra normalization
            ig(1,1)=evalin('base','mcr_bands.Constraints.Normalization.iclos;');
            
            if evalin('base','mcr_bands.Constraints.Normalization.iclos;')==1,
                clos=sum(c');clos=clos'; 	% closure constants as defined in input concentrations
            end
            
            % non-negativity constraints (inequality constraints)
            ig(1,2)=evalin('base','mcr_bands.Constraints.Non_negativity.ineg;');
            
            % equality constraints in cknown (implemented)
            ig(1,3)=evalin('base','mcr_bands.Constraints.Cequality.iknown;');
            
            % equality constraints in sknown (not implemented for the moment)
            ig(1,4)=evalin('base','mcr_bands.Constraints.Sequality.iknown;');
            
            % unimodality constraints in concentrations
            ig(1,5)=evalin('base','mcr_bands.Constraints.Unimodality.iunimod;');
            
            % trilinearity constraints
            ig(1,6)=evalin('base','mcr_bands.Constraints.Trilinearity.itril;');
            
            if evalin('base','mcr_bands.Constraints.Trilinearity.itril;')>0,
                nexp=evalin('base','mcr_bands.Optional.NumExp.nexp;');
            end
            
            % ************************************************************
            % constrained maximization/minimization  of resolution bands *
            % performed separately for each species                      *
            % ************************************************************
            
            noptim=nsign;
            
            % evaluation of t values from svd ---------------> new version
            disp('evaluation of t values from svd')
            [u,l,v]=svd(c*s);
            ul=u(:,1:nsign)*l(1:nsign,1:nsign);
            
            if (evalin('base','mcr_bands.Options.showplots')==1)
                figure;
            else
            end
            
            for ioptim=1:noptim;
                disp('estimation of feasible range for species profiles: '); disp(i);
                
                %****************************************************************************************
                
                if ig(1,1)==3,
                    index=0;
                    for ii=1:nsign
                        for jj=1:nsign
                            if ii==jj,dummy=t0(ii,jj);else,index=index+1;tt(1,index)=t0(ii,jj);end
                        end
                    end
                    vlb=[];
                    vub=[];
                    % pause
                else
                    tt=t0;
                end
                
                % calculation of the maximum/outer band
                
                [tmax,fbandmax,exitflagmax]=fmincon(@fmaxmin,tt,[],[],[],[],[],[],@mycons,options,c,s,1,ioptim,ig,clos,cknown,sknown,nexp);
                fbandmax=-fbandmax; %---------------------> new version 
                if ig(1,1)==3,tmax=tconv(tmax,nsign);end;
                
                
                % calculation of the minimum/inner band
                
                [tmin,fbandmin,exitflagmin]=fmincon(@fmaxmin,tt,[],[],[],[],[],[],@mycons,options,c,s,2,ioptim,ig,clos,cknown,sknown,nexp);
                if ig(1,1)==3,tmin=tconv(tmin,nsign);end;
                
                disp('***************************************************')
                disp('OPTIMAL VALUES FOR MAXIMUM CONTRIBUTION OF SPECIES: ');
                disp(ioptim);
                disp('optimal T values (max)');disp(tmax);
                disp('optimal values of the function f(T) at the maximum');disp(-fbandmax);
                disp('termination > 0 (convergence), = 0 (max.number of iterations), < 0 (divergence) :');disp(exitflagmax);
                disp('****************************************************')
                disp('OPTIMAL VALUES FOR MINIMUM CONTRIBUTION OF SPECIES: ')
                disp(ioptim);
                disp('optimal T values (min)');disp(tmin);
                disp('optimal values of the function f(T) at the minimum');disp(fbandmin);
                disp('termination > 0 (convergence), = 0 (max.number of iterations), < 0 (divergence) :');disp(exitflagmin);
                disp('***************************************************')
                
                %****************************************************************************************
                
                
                % values to keep for the optimization of each species band
                
                smax=tmax*s;
                cmax=c/tmax;
                smin=tmin*s;
                cmin=c/tmin;
                tmaxsvd=smax*v(:,1:nsign);  % -------------------------> new version
                tminsvd=smin*v(:,1:nsign);
                
                exitflag(ioptim,:)=[exitflagmax,exitflagmin]; % -----------------------new version
                for ix=1:nsign
                    tmaxsvd(ix,:)=tmaxsvd(ix,:)./tmaxsvd(ix,ix);
                    tminsvd(ix,:)=tminsvd(ix,:)./tminsvd(ix,ix);
                end
                
                tband=[tband;tmax;tmin];
                tbandsvd=[tbandsvd;tmaxsvd;tminsvd]; % -------------------------> new version
                sband=[sband;smax(ioptim,:);smin(ioptim,:)];
                cband=[cband,cmax(:,ioptim),cmin(:,ioptim)];
                fband=[fband,[fbandmax;fbandmin]];
                
                
                %****************************************************************************************
                % Intermediate Figures
                %**************************************************************************
                
                if (evalin('base','mcr_bands.Options.showplots')==1)
                    
                    %disp('plot of band profiles for species: '),disp(ioptim);
                    %figure
                    subplot(noptim,2,2*ioptim-1),plot(cmax(:,ioptim))
                    hold on
                    subplot(noptim,2,2*ioptim-1),plot(cmin(:,ioptim))
                    subplot(noptim,2,2*ioptim-1),plot(c(:,ioptim),'r:')
                    title(['Plot of C bands profiles for species: ',num2str(ioptim)]);
                    hold off
                    
                    subplot(noptim,2,2*ioptim),plot(smax(ioptim,:)')
                    hold on
                    subplot(noptim,2,2*ioptim),plot(smin(ioptim,:)')
                    subplot(noptim,2,2*ioptim),plot(s(ioptim,:),'r:')
                    title(['Plot of S bands profiles for species: ',num2str(ioptim)]);
                    hold off
                    
                else
                end
                
                %**************************************************************************
                %**************
                
                
                normmin(ioptim)=norm(cmin(:,ioptim)*smin(ioptim,:),'fro')/tnorm;
                normmax(ioptim)=norm(cmax(:,ioptim)*smax(ioptim,:),'fro')/tnorm;
                normband=[normband;normmax(ioptim);normmin(ioptim)];
                
                % Calculation of initial function values for comparison with th eoptimized ones
                % To check that the optimization was good -> Added February 2009 and
                % corrected in May 2009
                
                % modification may 2009
                disp('f values for initial solution')
                [finic(ioptim)]=fmaxmin(eye(nsign),c,s,2,ioptim,1)
                pause(1);
                
            end
            
            
            
            %****************************************************************************************
            % End results
            %****************************************************************************************
            
            assignin('base','nconstr',nconstr);
            assignin('base','sband',sband);
            assignin('base','nsign',nsign);
            %assignin('base','ispec',ispec);
            assignin('base','cband',cband);
            assignin('base','tband',tband);
            assignin('base','tbandsvd',tbandsvd);
            assignin('base','fband',fband);
            assignin('base','finic',finic);
            assignin('base','exitflag',exitflag);
            
            evalin('base','mcr_bands.temp.sband=sband;');
            evalin('base','mcr_bands.temp.cband=cband;');
            evalin('base','mcr_bands.temp.nsign=nsign;');
            %evalin('base','mcr_bands.temp.ispec=ispec;');
            evalin('base','mcr_bands.temp.ncosntr=nconstr;');
            evalin('base','mcr_bands.temp.tband=tband;');
            evalin('base','mcr_bands.temp.fband=fband;');
            evalin('base','mcr_bands.temp.finic=finic;');
            evalin('base','mcr_bands.temp.tbandsvd=tbandsvd;');
            evalin('base','mcr_bands.temp.exitflag=exitflag;');
            
            % evalin('base','clear sband cband nsign ispec nconstr detcbands detsbands exitflag');
            evalin('base','clear sband cband nsign tband tbandsvd fband ispec nconstr exitflag finic');
            
            
            if (evalin('base','mcr_bands.Options.flagOptim;'))==1
                delete(mcrbands_fr);
            end
            
            mcrbands_fr;
            evalin('base','mcr_bands.Options.flagOptim=1;');
            
                       
            
            %% ************************************************************************************
            %% Output
            %% ************************************************************************
            
            %[sband,cband,normband,tband,fband]
            assignin('base','sband',sband);
            assignin('base','cband',cband);
            assignin('base','tband',tband);
            assignin('base','tbandsvd',tbandsvd);
            assignin('base','fband',fband);
            assignin('base','finic',finic);
            assignin('base','normband',normband);
            assignin('base','exitflag',exitflag); % ---------------------------------------
            
            evalin('base','mcr_bands.Results.sband=sband;');
            evalin('base','mcr_bands.Results.cband=cband;');
            evalin('base','mcr_bands.Results.tband=tband;');
            evalin('base','mcr_bands.Results.tbandsvd=tbandsvd;');
            evalin('base','mcr_bands.Results.fband=fband;');
            evalin('base','mcr_bands.Results.finic=finic;');
            evalin('base','mcr_bands.Results.normband=normband;');
            evalin('base','mcr_bands.Results.exitflag=exitflag;');% ---------------------------------------
            
            evalin('base','clear sband cband tband tbandsvd fband finic normband exitflag');
            
            if evalin('base','mcr_bands.Options.Resultats') == 1
                assignin('base',evalin('base','mcr_bands.Options.Nom_resultats'),evalin('base','mcr_bands.Results'))
            end
            
            
        end
    end
end

% --- Executes on button press in check_results.
function check_results_Callback(hObject, eventdata, handles)
% hObject    handle to check_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_results

resultats=get(hObject,'Value');
assignin('base','resultats',resultats);
if resultats==1;
    evalin('base','mcr_bands.Options.Resultats=1;');
    set(handles.edit_results,'enable','on');
else
    evalin('base','mcr_bands.Options.Resultats=0;');
    set(handles.edit_results,'enable','off','String',' ');
    evalin('base','mcr_bands.Options.Nom_resultats=[];');
end;
evalin('base','clear resultats');

% --- Executes during object creation, after setting all properties.
function edit_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_results_Callback(hObject, eventdata, handles)
% hObject    handle to edit_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_results as text
%        str2double(get(hObject,'String')) returns contents of edit_results as a double

nom_resultats= get(hObject,'String');

assignin('base','nom_resultats',nom_resultats);
evalin('base','mcr_bands.Options.Nom_resultats=nom_resultats;');
evalin('base','clear nom_resultats');


% --- Executes on button press in check_plots.
function check_plots_Callback(hObject, eventdata, handles)
% hObject    handle to check_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_plots

showplots=get(hObject,'Value');
assignin('base','showplots',showplots);
evalin('base','mcr_bands.Options.showplots=showplots;');
evalin('base','clear showplots');


% --- Executes on button press in push_optparam.
function push_optparam_Callback(hObject, eventdata, handles)
% hObject    handle to push_optparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

change_opt_param;
evalin('base','mcr_bands.Optional.param_flag=1;');
