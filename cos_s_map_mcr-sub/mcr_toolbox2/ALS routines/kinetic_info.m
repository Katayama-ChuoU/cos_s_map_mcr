function varargout = kinetic_info(varargin)
% KINETIC_INFO MATLAB code for kinetic_info.fig
%      KINETIC_INFO, by itself, creates a new KINETIC_INFO or raises the existing
%      singleton*.
%
%      H = KINETIC_INFO returns the handle to a new KINETIC_INFO or the handle to
%      the existing singleton*.
%
%      KINETIC_INFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KINETIC_INFO.M with the given input arguments.
%
%      KINETIC_INFO('Property','Value',...) creates a new KINETIC_INFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kinetic_info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kinetic_info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kinetic_info

% Last Modified by GUIDE v2.5 19-Mar-2013 14:19:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kinetic_info_OpeningFcn, ...
                   'gui_OutputFcn',  @kinetic_info_OutputFcn, ...
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


% --- Executes just before kinetic_info is made visible.
function kinetic_info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kinetic_info (see VARARGIN)

% Choose default command line output for kinetic_info
handles.output = hObject;

nModels=evalin('base','mcr_als.alsOptions.kinetic.nModels;');

if nModels==1
    modelActiu=1;
    assignin('base','modelActiu',modelActiu);
    evalin('base','mcr_als.alsOptions.kinetic.results.aux.modelActiu=modelActiu;');
    evalin('base','clear modelActiu ');
    
    
    % ssq residuals
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    ssqr=evalin('base',['mcr_als.alsOptions.kinetic.results.save_ssq{',num2str(optim_niter),'};']);
    set(handles.edit_ssq,'string',num2str(ssqr),'enable','inactive');
        
    % plot perfils
    nexp=evalin('base','mcr_als.alsOptions.nexp;');
    if nexp==1
        perfils=cell2mat(evalin('base','mcr_als.alsOptions.kinetic.results.conckout{1};'));
    else
        perfils=cell2mat(evalin('base',['mcr_als.alsOptions.kinetic.results.conckout{',num2str(modelActiu),'};']));
    end
    
    time=evalin('base','mcr_als.alsOptions.kinetic.time_axis');
    expressionX=['mcr_als.alsOptions.kinetic.models.model1.concs.col;'];
    coloured=evalin('base',expressionX);
    perfilsCol=perfils*diag(coloured);
    plot(time,perfils,'.');
    hold on;
    plot(time,perfilsCol,'o');
    hold off;
    axis([0 max(time) 0 max(max(perfils))]);
    
    % dades taula
    constants=evalin('base','length(mcr_als.alsOptions.kinetic.results.kopt{1});');
    optim_niter=evalin('base','mcr_als.alsOptions.resultats.optim_niter;');
    for i=1:1:constants
        expressionX=['mcr_als.alsOptions.kinetic.results.save_kopt{',num2str(optim_niter),'};'];
        ki=evalin('base',expressionX);
        expressionX=['mcr_als.alsOptions.kinetic.results.save_sigK{',num2str(optim_niter),'};'];
        error_ki=evalin('base',expressionX);
        dades_taula{i,1}=[num2str(ki(i))];
        dades_taula{i,2}=[num2str(error_ki(i))];
    end
    set(handles.uitable1,'Data',dades_taula);
    
else
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kinetic_info wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kinetic_info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% Nombre de models
% **********************************************************************************

% --- Executes during object creation, after setting all properties.
function popup_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nModels=evalin('base','mcr_als.alsOptions.kinetic.nModels;');
if nModels==1
     set(hObject,'BackgroundColor','white','String','1','enable','inactive');
else
    j=2;
    llistannc(1)={'select model nr.'};
    for i=1:nModels;
    llistnnc=[num2str(i)];
    llistannc(j)={llistnnc};
    j=j+1;
    end;
    set(hObject,'enable','on','string',llistannc,'value',1);
end

% --- Executes on selection change in popup_model.
function popup_model_Callback(hObject, eventdata, handles)
% hObject    handle to popup_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_model

modelActiu=get(hObject,'Value')-1;
assignin('base','modelActiu',modelActiu);
evalin('base','mcr_als.alsOptions.kinetic.results.aux.modelActiu=modelActiu;');
evalin('base','clear modelActiu ');

if modelActiu==0
    set(handles.edit_ssq,'string','  ','enable','inactive');
    set(handles.uitable1,'Data',[]);
    set(handles.push_saveK,'enable','off');
    set(handles.push_saveProfiles,'enable','off');    
    % nothing happen
    axes(handles.axes_perfils);
    cla;
    axis([0 1 0 1]);
    title('');
    xlabel('');
    ylabel('');
else
    % ssq residuals
    ssqr=evalin('base',['mcr_als.alsOptions.kinetic.results.ssq{',num2str(modelActiu),'};']);
    set(handles.edit_ssq,'string',num2str(ssqr),'enable','inactive');

    % plot perfiles
    expressionX=['mcr_als.alsOptions.kinetic.results.conckout{',num2str(modelActiu),'};'];
    perfils=cell2mat(evalin('base',expressionX));

    time=evalin('base','mcr_als.alsOptions.kinetic.time_axis');

    expressionX=['mcr_als.alsOptions.kinetic.models.model',num2str(modelActiu),'.concs.col;'];
    coloured=evalin('base',expressionX);
    perfilsCol=perfils*diag(coloured);
    plot(time,perfils,':');
    hold on;
    plot(time,perfilsCol);
    hold off;
    axis([0 max(time) 0 max(max(perfils))]);
    
    % data table
    expressionX=['length(mcr_als.alsOptions.kinetic.results.kopt{',num2str(modelActiu),'});'];
    constants=evalin('base',expressionX);
  
    for i=1:1:constants
        expressionX=['mcr_als.alsOptions.kinetic.results.kopt{',num2str(modelActiu),'};'];
        ki=evalin('base',expressionX);
        expressionX=['mcr_als.alsOptions.kinetic.results.sig_knglm{',num2str(modelActiu),'};'];
        error_ki=evalin('base',expressionX);
        dades_taula{i,1}=[num2str(ki(i))];
        dades_taula{i,2}=[num2str(error_ki(i))];
    end
    set(handles.uitable1,'Data',dades_taula);
    set(handles.push_saveK,'enable','on');
    set(handles.push_saveProfiles,'enable','on');    
end

% Residuals 
% **********************************************************************************

% --- Executes during object creation, after setting all properties.
function edit_ssq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ssq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_ssq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ssq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ssq as text
%        str2double(get(hObject,'String')) returns contents of edit_ssq as a double


% Tanca
% **********************************************************************************

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% Guarda
% **********************************************************************************

% --- Executes on button press in push_saveProfiles.
function push_saveProfiles_Callback(hObject, eventdata, handles)
% hObject    handle to push_saveProfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.results.aux.modelActiu;');

expressionX=['mcr_als.alsOptions.kinetic.results.conckout{',num2str(modelActiu),'};'];
perfils=cell2mat(evalin('base',expressionX));
assignin('base',['C_Kinetic_',num2str(modelActiu)],perfils);

% --- Executes on button press in push_saveK.
function push_saveK_Callback(hObject, eventdata, handles)
% hObject    handle to push_saveK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelActiu=evalin('base','mcr_als.alsOptions.kinetic.results.aux.modelActiu;');

expressionX=['mcr_als.alsOptions.kinetic.results.kopt{',num2str(modelActiu),'};'];
ki=evalin('base',expressionX);
assignin('base',['k_Kinetic_',num2str(modelActiu)],ki);
