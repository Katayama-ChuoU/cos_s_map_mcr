function varargout = kineticHM_multi(varargin)
% KINETICHM_MULTI MATLAB code for kineticHM_multi.fig
%      KINETICHM_MULTI, by itself, creates a new KINETICHM_MULTI or raises the existing
%      singleton*.
%
%      H = KINETICHM_MULTI returns the handle to a new KINETICHM_MULTI or the handle to
%      the existing singleton*.
%
%      KINETICHM_MULTI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KINETICHM_MULTI.M with the given input arguments.
%
%      KINETICHM_MULTI('Property','Value',...) creates a new KINETICHM_MULTI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kineticHM_multi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kineticHM_multi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help kineticHM_multi
% Last Modified by GUIDE v2.5 20-Mar-2013 10:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @kineticHM_multi_OpeningFcn, ...
    'gui_OutputFcn',  @kineticHM_multi_OutputFcn, ...
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


% --- Executes just before kineticHM_multi is made visible.
function kineticHM_multi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kineticHM_multi (see VARARGIN)

% Choose default command line output for kineticHM_multi
handles.output = hObject;

set(handles.uitable2,'Data',[]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kineticHM_multi wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = kineticHM_multi_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Select Model
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function edit_nrModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nrModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nrModel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nrModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nrModel as text
%        str2double(get(hObject,'String')) returns contents of edit_nrModel as a double

nModels=str2num(get(hObject,'String'));
assignin('base','nModels',nModels);
evalin('base','mcr_als.alsOptions.kinetic.nModels=nModels;');
evalin('base','clear nModels');

if nModels==1
    set(handles.popup_selectModel,'enable','inactive','string',1,'value',1);
    set(handles.edit_mech,'enable','on');
    evalin('base','mcr_als.alsOptions.kinetic.modelActiu=1;');
    nexp=evalin('base','mcr_als.alsOptions.nexp;');
    set(handles.edit_nexp,'string',num2str(ones(1,nexp)),'enable','on');
    
    assignin('base','nexpx3',nexp);
    expressionX=['mcr_als.alsOptions.kinetic.models.model1.expFitted=ones(1,nexpx3);'];
    evalin('base',expressionX);
    evalin('base','clear nexpx3');
    
elseif nModels>1
    j=2;
    llistannc(1)={'select model nr.'};
    for i=1:nModels;
        llistnnc=[num2str(i)];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    set(handles.popup_selectModel,'enable','on','string',llistannc,'value',1);
end


% --- Executes during object creation, after setting all properties.
function popup_selectModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_selectModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_selectModel.
function popup_selectModel_Callback(hObject, eventdata, handles)
% hObject    handle to popup_selectModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_selectModel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_selectModel

modelActiu=get(hObject,'Value')-1;
assignin('base','modelActiu',modelActiu);
evalin('base','mcr_als.alsOptions.kinetic.modelActiu=modelActiu;');
evalin('base','clear modelActiu ');

% reset (by now)

nexp=evalin('base','mcr_als.alsOptions.nexp;');
set(handles.edit_nexp,'string',num2str(ones(1,nexp)),'enable','on');
assignin('base','nexpx3',ones(1,nexp));
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted=nexpx3;'];
evalin('base',expressionX);
evalin('base','clear nexpx3');

set(handles.edit_mech,'enable','on','string',' ');
set(handles.listbox_rates,'string',' ','value',1,'enable','inactive');
set(handles.edit_rates,'string',' ');
set(handles.listbox_concs,'string',' ','value',1,'enable','inactive');
set(handles.listbox_KINspecies,'string',' ','value',1,'enable','inactive');
set(handles.listbox_MCRspecies,'string',' ','value',1,'enable','inactive');
set(handles.popup_time,'value',1');
set(handles.check_colour,'enable','inactive','value',1);
axes(handles.axes1);cla;


% Multiple experiments
% ******************************************************************************

% --- Executes during object creation, after setting all properties.
function edit_nexp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nexp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nexp as text
%        str2double(get(hObject,'String')) returns contents of edit_nexp as a double

expFitted=str2num(get(hObject,'String'));
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
assignin('base','expFitted',expFitted);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted=expFitted;'];
evalin('base',expressionX);
evalin('base','clear expFitted');


% Write mechanism
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function edit_mech_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_mech_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mech as text
%        str2double(get(hObject,'String')) returns contents of edit_mech as a double

modelEscrit=get(hObject,'String');
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');

% save expFitted
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted;'];
expFitted=evalin('base',expressionX);

hard.model.modelEscrit = cellstr(modelEscrit);
disp(hard.model.modelEscrit)
[hard.model.model,hard.model.species_list,hard.model.errstr] = eq2mat_hard(hard.model.modelEscrit);
assignin('base','modelHard',hard);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'=modelHard;'];
evalin('base',expressionX);
evalin('base','clear modelHard');

% load expFitted
assignin('base','expFittedX',expFitted);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted=expFittedX;'];
evalin('base',expressionX);
evalin('base','clear expFittedX');

% rates
[hard.model.nrconstants,n]=size(hard.model.model.N);
j=1;
for i=1:1:hard.model.nrconstants;
    llistnnc=['k',num2str(i)];
    llistannc(j)={llistnnc};
    j=j+1;
end;
set(handles.listbox_rates,'string',llistannc,'value',1);
set(handles.listbox_rates,'enable','on');

% set active the first and value=0
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.kactiu=1;'];
evalin('base',expressionX);

set(handles.edit_rates,'string','0');

% all zeros and edit values
ki=zeros(1,hard.model.nrconstants);
assignin('base','ki',ki);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.ki=ki;'];
evalin('base',expressionX);
evalin('base','clear ki');

% species *****************************************************
[hard.model.nrspecies,n]=size(hard.model.species_list);
j=1;
for i=1:1:hard.model.nrspecies;
    llistnnc=[hard.model.species_list(i)];
    llistannc(j)=llistnnc;
    j=j+1;
end;
set(handles.listbox_concs,'string',llistannc,'value',1);
set(handles.listbox_concs,'enable','on');

% set active the first ones
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu=1;'];
evalin('base',expressionX);

% all zeros and edit values
nexp=evalin('base','mcr_als.alsOptions.nexp;');
ci=zeros(nexp,hard.model.nrspecies);
assignin('base','ci',ci);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.ci=ci;'];
evalin('base',expressionX);
evalin('base','clear ci');

%  setting the table ******************************************************

dades_taula=[];
nexp=evalin('base','mcr_als.alsOptions.nexp;');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted;'];
expFitted=evalin('base',expressionX);

for i=1:1:nexp
    dades_taula{i,1}=['Exp ',num2str(i)];
    
    if expFitted(1,i)==1
        dades_taula{i,2}=[];
    else
        dades_taula{i,2}=NaN;
    end
end
set(handles.uitable2,'Data',dades_taula);

% cused
Cused=zeros(1,hard.model.nrspecies);
assignin('base','Cused',Cused);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.Cused=Cused;'];
evalin('base',expressionX);
evalin('base','clear Cused');

% coloured
col=ones(1,hard.model.nrspecies);
assignin('base','col',col);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.col=col;'];
evalin('base',expressionX);
evalin('base','clear col');

% correspondence kinetic and MCR profiles
llistannc2=['No kinetic' llistannc];
set(handles.listbox_KINspecies,'string',llistannc2,'value',1);
set(handles.listbox_KINspecies,'enable','on');

% set active the first ones
corrMCR0=zeros(evalin('base','mcr_als.alsOptions.nComponents;'),1);
assignin('base','corrMCR0',corrMCR0);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.corrMCR=corrMCR0;'];
evalin('base',expressionX);
evalin('base','clear corrMCR0');

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.MCRactiu=1;'];
evalin('base',expressionX);
evalin('base','clear MCRactiu sortMCR');


% Initial Rates
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function listbox_rates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_rates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% nothing

% --- Executes on selection change in listbox_rates.
function listbox_rates_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_rates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_rates contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_rates

kactiu=get(hObject,'Value');
assignin('base','kactiu',kactiu);
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.kactiu=kactiu;'];
evalin('base',expressionX);
evalin('base','clear kactiu');

% change the edit value for the memory value
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.ki(1,mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.kactiu);'];
valor=evalin('base',expressionX);
set(handles.edit_rates,'enable','on','string',num2str(valor));


% --- Executes during object creation, after setting all properties.
function edit_rates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% nothing

function edit_rates_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rates as text
%        str2double(get(hObject,'String')) returns contents of edit_rates as a double

ki=str2num(get(hObject,'String'));
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.kactiu;'];
num=evalin('base',expressionX);
assignin('base','ki',ki);
assignin('base','num',num);

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.ki(1,num)=ki;'];
evalin('base',expressionX);
evalin('base','clear ki num');


% Initial Concentrations
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function listbox_concs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_concs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% nothing

% --- Executes on selection change in listbox_concs.
function listbox_concs_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_concs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_concs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_concs

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
cactiu=get(hObject,'Value');
assignin('base','cactiu',cactiu);
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu=cactiu;'];
evalin('base',expressionX);
evalin('base','clear cactiu');

% change the edit value for the memory value
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.ci(1,mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu);'];
valor=evalin('base',expressionX);

%canvi del valor del check pel de la memo
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.col(1,mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu);'];
valor=evalin('base',expressionX);
set(handles.check_colour,'enable','on','value',valor);

% setting of the table ******************************************************

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.Cused;'];
Cused=evalin('base',expressionX);
valor=Cused(cactiu);

if valor==0
    dades_taula=[];
    nexp=evalin('base','mcr_als.alsOptions.nexp;');
    expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted;'];
    expFitted=evalin('base',expressionX);
    
    for i=1:1:nexp
        dades_taula{i,1}=['Exp ',num2str(i)];
        
        if expFitted(1,i)==1
            dades_taula{i,2}=[];
        else
            dades_taula{i,2}=NaN;
        end
    end
    set(handles.uitable2,'Data',dades_taula);
else
    expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.ci(:,',num2str(cactiu),');'];
    oldCvalues=evalin('base',expressionX);
    
    nexp=evalin('base','mcr_als.alsOptions.nexp;');
    for i=1:1:nexp
        dades_taula{i,1}=['Exp ',num2str(i)];
        dades_taula{i,2}=oldCvalues(i,1);
    end
    set(handles.uitable2,'Data',dades_taula);
end


% --- Executes on button press in check_colour.
function check_colour_Callback(hObject, eventdata, handles)
% hObject    handle to check_colour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_colour

valorCol=get(hObject,'Value');

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu;'];
num=evalin('base',expressionX);

assignin('base','num',num);
assignin('base','valorCol',valorCol);

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.col(1,num)=valorCol;'];
evalin('base',expressionX);

evalin('base','clear valorCol num');



% time
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function popup_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_time (see GCBO)
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

% --- Executes on selection change in popup_time.
function popup_time_Callback(hObject, eventdata, handles)
% hObject    handle to popup_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_time contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_time


popmenu2=get(handles.popup_time,'String');
pm2=get(handles.popup_time,'Value');

if pm2==1
    
else
    selec2=char([popmenu2(pm2)]);
    time=evalin('base',selec2);
    assignin('base','time_axis',time);
    evalin('base','mcr_als.alsOptions.kinetic.time_axis=time_axis;');
    evalin('base','clear time_axis');
end

% activate popup of setting experiment
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
nexp=evalin('base','mcr_als.alsOptions.nexp;');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted;'];
expFitted=evalin('base',expressionX);

j=2;
llistannc(1)={'select Exp nr.'};
for i=1:1:nexp
    if expFitted(i)==1
        llistnnc=['Exp nr. ',num2str(i)];
        llistannc(j)={llistnnc};
        j=j+1;
    end
end
set(handles.popup_expSim,'enable','on','string',llistannc,'value',1);

set(handles.push_sim,'enable','off');
set(handles.push_done,'enable','on');



% MCR:Kinetic relationship
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function listbox_MCRspecies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_MCRspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

j=1;
nsign=evalin('base','mcr_als.alsOptions.nComponents');
for i=1:1:nsign;
    llistnnc=['MCR species nr. ',num2str(i)];
    llistannc(j)={llistnnc};
    j=j+1;
end;
set(hObject,'string',llistannc,'value',1,'enable','on');

% --- Executes on selection change in listbox_MCRspecies.
function listbox_MCRspecies_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_MCRspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_MCRspecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_MCRspecies

MCRactiu=get(hObject,'Value');
assignin('base','MCRactiu',MCRactiu);
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.MCRactiu=MCRactiu;'];
evalin('base',expressionX);

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.corrMCR(MCRactiu,1);'];
corrMCRold=evalin('base',expressionX);

valor=corrMCRold+1;
set(handles.listbox_KINspecies,'value',valor);
evalin('base','clear MCRactiu');



% --- Executes during object creation, after setting all properties.
function listbox_KINspecies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_KINspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_KINspecies.
function listbox_KINspecies_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_KINspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_KINspecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_KINspecies

sortMCR=get(hObject,'Value')-1;
assignin('base','sortMCR',sortMCR);
modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.MCRactiu;'];
MCRactiu=evalin('base',expressionX);
assignin('base','MCRactiu',MCRactiu);

expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.corrMCR(MCRactiu,1)=sortMCR;'];
evalin('base',expressionX);

% change edit
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concMCR.corrMCR'];
vectorCorr=evalin('base',expressionX);
evalin('base','clear cactiu sortMCR');


% --- Executes on button press in push_CALS.
function push_CALS_Callback(hObject, eventdata, handles)
% hObject    handle to push_CALS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iniesta=evalin('base','mcr_als.alsOptions.iniesta;');
if evalin('base','mcr_als.InitEstim.method')=='Pur';
    if evalin('base','mcr_als.InitEstim.pureDirection')==1;
        iniesta=iniesta';
    end
end
[rows,columns]=size(iniesta);
nComponents=evalin('base','mcr_als.alsOptions.nComponents;');
matdad=evalin('base','mcr_als.alsOptions.matdad;');
perfils=evalin('base','mcr_als.alsOptions.kinetic.sim.simula.perfilc');


if nComponents==rows % IE = spectra
  
    axes(handles.axes1);
    hold on;
    time=evalin('base','mcr_als.alsOptions.kinetic.time_axis');
    ccc=matdad/iniesta;
    valorNorm=max(max(ccc))/max(max(perfils));
    if verLessThan('matlab', '8.4')
        %  nothing
    else
        set(handles.axes1,'ColorOrderIndex',1);
    end
    plot(time,ccc/valorNorm,'*');

    
elseif nComponents==columns % IE = concs
  
    axes(handles.axes1);
    hold on;
    if verLessThan('matlab', '8.4')
        %  nothing
    else
        set(handles.axes1,'ColorOrderIndex',1);
    end
    time=evalin('base','mcr_als.alsOptions.kinetic.time_axis');
    valorNorm=max(max(iniesta))/max(max(perfils));
    plot(time,iniesta/valorNorm,'*');
    hold off;
    
end




% Valors de la taula
% ******************************************************************

% --- Executes on button press in push_Tvalues.
function push_Tvalues_Callback(hObject, eventdata, handles)
% hObject    handle to push_Tvalues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
% save species and the table values
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu;'];
cactiu=evalin('base',expressionX);
% backup taula
info = get(handles.uitable2,'Data');
oldCvalues=cell2mat(info(:,2))';
assignin('base','oldCvalues',oldCvalues');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.ci(:,',num2str(cactiu),')=str2num(oldCvalues);'];
evalin('base',expressionX);

% seting used=yes
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.Cused(1,mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.cactiu)=1;'];
evalin('base',expressionX);


% Finish
% ******************************************************************

% --- Executes on button press in push_done.
function push_done_Callback(hObject, eventdata, handles)
% hObject    handle to push_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_als.alsOptions.kinetic.appKinetic=1');
close;


% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in push_credits.
function push_credits_Callback(hObject, eventdata, handles)
% hObject    handle to push_credits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

KineticCred;

% ****************************************************************************************


% simulate
% ******************************************************************

% --- Executes during object creation, after setting all properties.
function popup_expSim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_expSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popup_expSim.
function popup_expSim_Callback(hObject, eventdata, handles)
% hObject    handle to popup_expSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_expSim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_expSim

% s'ha el temps d'acord a l'experiment

exp2Sim=get(hObject,'Value')-1;

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
nexp=evalin('base','mcr_als.alsOptions.nexp;');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.expFitted;'];
expFitted=evalin('base',expressionX);
time=evalin('base','mcr_als.alsOptions.kinetic.time_axis');

if nexp==sum(expFitted) % cas facil, tots els experiments es modelen
    % cut time
    nrinic=evalin('base','mcr_als.alsOptions.multi.nrinic;');
    nrfin=evalin('base','mcr_als.alsOptions.multi.nrfin;');
    time_sim=time(nrinic(exp2Sim):nrfin(exp2Sim));
    
    % cut concs
    expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.ci;'];
    concs=evalin('base',expressionX);
    concs_sim=concs(exp2Sim,:);
    
else
    % modification of expsim adding the previos 0 values
    expFitted_tall=expFitted(1:exp2Sim);
    numOf0=numel(expFitted_tall)-sum(expFitted_tall);
    exp2Sim_0=exp2Sim+numOf0;
    
    % cutting concs
    expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.ci;'];
    concs=evalin('base',expressionX);
    concs_sim=concs(exp2Sim_0,:);
    
    % cutting time
    if numOf0>0
        nrsol=evalin('base','mcr_als.alsOptions.multi.nrsol;');
        rows=expFitted.*nrsol;
        time_sim=time(1,1+sum(rows(1:exp2Sim_0-1)) : sum(rows(1:exp2Sim_0)));
    else
        nrinic=evalin('base','mcr_als.alsOptions.multi.nrinic;');
        nrfin=evalin('base','mcr_als.alsOptions.multi.nrfin;');
        time_sim=time(nrinic(exp2Sim_0):nrfin(exp2Sim_0));
    end
end
assignin('base','time_sim',time_sim);
evalin('base','mcr_als.alsOptions.kinetic.sim.time_sim=time_sim');
assignin('base','concs_sim',concs_sim);
evalin('base','mcr_als.alsOptions.kinetic.sim.concs_sim=concs_sim');
evalin('base','clear time_sim concs_sim');
set(handles.push_sim,'enable','on');


% --- Executes on button press in push_sim.
function push_sim_Callback(hObject, eventdata, handles)
% hObject    handle to push_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.modelActiu;');
expressionX=['[mcr_als.alsOptions.kinetic.sim.simula.eixx,mcr_als.alsOptions.kinetic.sim.simula.perfilsc]=ode15s(@gui_conc,[0 max(mcr_als.alsOptions.kinetic.sim.time_sim)],mcr_als.alsOptions.kinetic.sim.concs_sim,[],mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.constants.ki,transpose(mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.model.model.N),mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.model.model.R);'];
evalin('base',expressionX);
axes(handles.axes1);

evalin('base','mcr_als.alsOptions.kinetic.sim.simula.perfilc=interp1(mcr_als.alsOptions.kinetic.sim.simula.eixx,mcr_als.alsOptions.kinetic.sim.simula.perfilsc,mcr_als.alsOptions.kinetic.sim.time_sim);');

time=evalin('base','mcr_als.alsOptions.kinetic.sim.time_sim');
perfils=evalin('base','mcr_als.alsOptions.kinetic.sim.simula.perfilc');
expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.col;'];
coloured=evalin('base',expressionX);

perfilsCol=perfils*diag(coloured);
plot(time,perfils,':');
hold on;
if verLessThan('matlab', '8.4')
    %  nothing
else
    set(handles.axes1,'ColorOrderIndex',1);
end
plot(time,perfilsCol);
hold off;
axis([0 max(time) 0 max(max(perfils))]);

set(handles.push_done,'enable','on');
