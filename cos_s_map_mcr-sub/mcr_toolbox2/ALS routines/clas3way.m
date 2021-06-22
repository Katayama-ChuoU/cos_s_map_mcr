function varargout = clas3way(varargin)
% CLAS3WAY M-file for clas3way.fig

% Last Modified by GUIDE v2.5 04-Dec-2012 14:58:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @clas3way_OpeningFcn, ...
    'gui_OutputFcn',  @clas3way_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before clas3way is made visible.
function clas3way_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to clas3way (see VARARGIN)

% Choose default command line output for clas3way
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes clas3way wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = clas3way_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popup_seldat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_seldat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

llista(1)={'select...'};
llista(2)={'Column-wise augmented data matrix (C direction)'};
llista(3)={'Row-wise augmented data matrix (S direction)'};
llista(4)={'Column- and Row-wise augmented data matrix (C&S directions)'};
set(hObject,'string',llista)


% --- Executes on selection change in popup_seldat.
function popup_seldat_Callback(hObject, eventdata, handles)
% hObject    handle to popup_seldat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_seldat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_seldat

datamod=get(handles.popup_seldat,'Value')-1;
nexp=evalin('base','mcr_als.alsOptions.nexp'); %control popup +1
pop_nexp=nexp+1;

if datamod==0
    
    set(handles.text_numC,'enable','off');
    set(handles.text_numS,'enable','off');
    set(handles.text_Csub,'enable','off');
    set(handles.text_selnc,'enable','off');
    set(handles.text_nr,'enable','off');
    set(handles.text_Ssub,'enable','off');
    set(handles.text_selns,'enable','off');
    set(handles.text_nc,'enable','off');
    set(handles.edit_nr,'enable','off');
    set(handles.edit_nc,'enable','off');
    set(handles.popup_selnc,'enable','off','value',1);
    set(handles.checkbox_samerows,'enable','off','value',0);
    set(handles.checkbox_samecolumns,'enable','off','value',0);
    set(handles.checkbox_external,'enable','off','value',0);
    set(handles.popup_selns,'enable','off','value',1);
    set(handles.push_ok,'enable','off');
    set(handles.popup_numC,'enable','off','value',1);
    set(handles.popup_numS,'enable','off','value',1);
    
elseif datamod==1
    
    set(handles.text_numC,'enable','on');
    set(handles.text_numS,'enable','off');
    set(handles.text_Csub,'enable','on');
    set(handles.text_selnc,'enable','on');
    set(handles.text_nr,'enable','off');
    set(handles.text_Ssub,'enable','off');
    set(handles.text_selns,'enable','off');
    set(handles.text_nc,'enable','off');
    set(handles.edit_nr,'enable','off');
    set(handles.edit_nc,'enable','off');
    set(handles.popup_numC,'enable','inactive','value',pop_nexp);
    set(handles.popup_numS,'enable','off','value',1);
    set(handles.popup_selnc,'enable','on','value',1);
    set(handles.checkbox_samerows,'enable','on','value',0);
    set(handles.checkbox_samecolumns,'enable','off','value',0);
    set(handles.checkbox_external,'enable','on','value',0);
    set(handles.popup_selns,'enable','off','value',1);
    set(handles.push_ok,'enable','off');
    
    % create list selnC
    
    matc=nexp;
    j=2;
    llistannc(1)={'select...'};
    
    for i=1:1:matc;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    
    set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
    matc=nexp;
    nrsol=zeros(1,matc);
    assignin('base','nrsol',nrsol);
    evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
    evalin('base','clear nrsol ');
    assignin('base','matc',matc);
    evalin('base','mcr_als.alsOptions.multi.matc=matc;');
    evalin('base','clear matc ');
    matr=1;
    assignin('base','matr',matr);
    evalin('base','mcr_als.alsOptions.multi.matr=matr;');
    evalin('base','clear matr');
    
elseif datamod==2
    
    set(handles.text_numS,'enable','on');
    set(handles.text_numC,'enable','off');
    set(handles.text_Csub,'enable','off');
    set(handles.text_selnc,'enable','off');
    set(handles.text_nr,'enable','off');
    set(handles.text_Ssub,'enable','on');
    set(handles.text_selns,'enable','on');
    set(handles.text_nc,'enable','off');
    set(handles.edit_nr,'enable','off');
    set(handles.edit_nc,'enable','off');
    set(handles.popup_numS,'enable','inactive','value',pop_nexp);
    set(handles.popup_numC,'enable','off','value',1);
    set(handles.popup_selnc,'enable','off','value',1);
    set(handles.checkbox_samerows,'enable','off','value',0);
    set(handles.checkbox_samecolumns,'enable','on','value',0);
    set(handles.checkbox_external,'enable','off','value',0);
    set(handles.popup_selns,'enable','on','value',1);
    set(handles.push_ok,'enable','off');
    
    % create list selnC
    matr=nexp;
    j=2;
    llistannc(1)={'select...'};
    for i=1:1:matr;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    set(handles.popup_selns,'string',llistannc,'enable','on','value',1);
    matr=nexp;
    ncsol=zeros(1,matr);
    assignin('base','ncsol',ncsol);
    evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
    evalin('base','clear ncsol ');
    assignin('base','matr',matr);
    evalin('base','mcr_als.alsOptions.multi.matr=matr;');
    evalin('base','clear matr ');
    matc=1;
    assignin('base','matc',matc);
    evalin('base','mcr_als.alsOptions.multi.matc=matc;');
    evalin('base','clear matc');
    
elseif datamod==3
    
    set(handles.text_numC,'enable','on');
    set(handles.text_numS,'enable','on');
    set(handles.text_Csub,'enable','off');
    set(handles.text_selnc,'enable','off');
    set(handles.text_nr,'enable','off');
    set(handles.text_Ssub,'enable','off');
    set(handles.text_selns,'enable','off');
    set(handles.text_nc,'enable','off');
    set(handles.edit_nr,'enable','off');
    set(handles.edit_nc,'enable','off');
    set(handles.popup_numC,'enable','on','value',1);
    set(handles.popup_numS,'enable','on','value',1);
    set(handles.popup_selnc,'enable','off','value',1);
    set(handles.checkbox_samerows,'enable','off','value',0);
    set(handles.checkbox_samecolumns,'enable','off','value',0);
    set(handles.checkbox_external,'enable','off','value',0);
    set(handles.popup_selns,'enable','off','value',1);
    set(handles.push_ok,'enable','off');
    
    %init. matc i matr
    matc=0;matr=0;
    assignin('base','matc',matc);
    evalin('base','mcr_als.alsOptions.multi.matc=matc;');
    evalin('base','clear matc');
    assignin('base','matr',matr);
    evalin('base','mcr_als.alsOptions.multi.matr=matr;');
    evalin('base','clear matr');
    
    
end

assignin('base','datamod',datamod);
evalin('base','mcr_als.alsOptions.multi.datamod=datamod;');
evalin('base','clear datamod');

% --- Executes during object creation, after setting all properties.
function popup_numC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_numC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

nexp=evalin('base','mcr_als.alsOptions.nexp');
j=2;
llistannc(1)={'select...'};
for i=1:1:nexp;
    llistnnc=[i];
    llistannc(j)={llistnnc};
    j=j+1;
end;
set(hObject,'string',llistannc)

% --- Executes on selection change in popup_numC.
function popup_numC_Callback(hObject, eventdata, handles)
% hObject    handle to popup_numC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_numC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_numC

matc=get(handles.popup_numC,'Value')-1;

if evalin('base','mcr_als.alsOptions.multi.datamod')==1
    set(handles.text_Csub,'enable','on');
    set(handles.text_selnc,'enable','on');
    set(handles.text_nr,'enable','off');
    set(handles.text_Ssub,'enable','off');
    set(handles.text_selns,'enable','off');
    set(handles.text_nc,'enable','off');
    set(handles.edit_nr,'enable','off');
    set(handles.edit_nc,'enable','off');
    set(handles.popup_numS,'enable','off','value',2);
    matr=get(handles.popup_numS,'Value')-1;
    assignin('base','matr',matr);
    evalin('base','mcr_als.alsOptions.multi.matr=matr;');
    evalin('base','clear matr ');
    j=2;
    llistannc(1)={'select...'};
    for i=1:1:matc;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
    set(handles.checkbox_samerows,'enable','on','value',0);
    set(handles.checkbox_external,'enable','on','value',0);
    set(handles.edit_external,'enable','off','string',' ');
    set(handles.popup_selns,'enable','off');
    set(handles.push_ok,'enable','off');

    if matc*matr ~= evalin('base','mcr_als.alsOptions.nexp')
        errordlg('Warning: nr. of submatrices in C x nr. of submatrices in S should be equal to nexp')
        set(handles.text_Csub,'enable','off');
        set(handles.text_selnc,'enable','off');
        set(handles.text_nr,'enable','off');
        set(handles.edit_nr,'enable','off','string',' ');
        set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
        set(handles.checkbox_samerows,'enable','off','value',0);
    end

else

    max=evalin('base','mcr_als.alsOptions.nexp');
    if matc==1 |matc==max |matc==0
        errordlg('Re-define your data set class');
        set(handles.text_Ssub,'enable','off');
        set(handles.text_selns,'enable','off');
        set(handles.text_nc,'enable','off');
        set(handles.edit_nc,'enable','off','string',' ');
        set(handles.popup_selns,'string','select...','enable','off','value',1);
        set(handles.text_Csub,'enable','off');
        set(handles.text_selnc,'enable','off');
        set(handles.text_nr,'enable','off');
        set(handles.edit_nr,'enable','off','string',' ');
        set(handles.popup_selnc,'string','select...','enable','off','value',1);
        set(handles.checkbox_samerows,'enable','off','value',0);
        set(handles.checkbox_external,'enable','off','value',0);
    else
        matr=get(handles.popup_numS,'Value')-1;
        assignin('base','matr',matr);
        evalin('base','mcr_als.alsOptions.multi.matr=matr;');
        evalin('base','clear matr ');
        j=2; % list conc. matrices
        llistannc(1)={'select...'};
        for i=1:1:matc;
            llistnnc=[i];
            llistannc(j)={llistnnc};
            j=j+1;
        end;

        set(handles.push_ok,'enable','off');

        if matr~=1 & matr~=0

            if matc*matr ~= evalin('base','mcr_als.alsOptions.nexp')
                errordlg('Warning: nr. of submatrices in C x nr. of submatrices in S should be equal to nexp')
                set(handles.text_Ssub,'enable','off');
                set(handles.text_selns,'enable','off');
                set(handles.text_nc,'enable','off');
                set(handles.edit_nc,'enable','off','string',' ');
                set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
                set(handles.text_Csub,'enable','off');
                set(handles.text_selnc,'enable','off');
                set(handles.text_nr,'enable','off');
                set(handles.edit_nr,'enable','off','string',' ');
                set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
                set(handles.checkbox_samerows,'enable','off','value',0);
                set(handles.checkbox_external,'enable','off','value',0);
            elseif matc*matr ~= evalin('base','mcr_als.alsOptions.nexp') & (matc==1 | matr==1);
                errordlg('Warning: nr. of submatrices in C x nr. of submatrices in S should be equal to nexp')
                set(handles.text_Csub,'enable','off');
                set(handles.text_selnc,'enable','off');
                set(handles.text_nr,'enable','off');
                set(handles.edit_nr,'enable','off','string',' ');
                set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
                set(handles.checkbox_samerows,'enable','off','value',0);
                set(handles.checkbox_external,'enable','off','value',0);
                set(handles.text_Ssub,'enable','off');
                set(handles.text_selns,'enable','off');
                set(handles.text_nc,'enable','off');
                set(handles.edit_nc,'enable','off','string',' ');
                set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
            else
                set(handles.text_Ssub,'enable','on');
                set(handles.text_selns,'enable','on');
                set(handles.text_nc,'enable','off');
                set(handles.edit_nc,'enable','off','string',' ');
                set(handles.popup_selns,'enable','on','value',1);
                set(handles.push_ok,'enable','off');
                set(handles.text_Csub,'enable','on');
                set(handles.text_selnc,'enable','on');
                set(handles.text_nr,'enable','off');
                set(handles.edit_nr,'enable','off','string',' ');
                set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
                set(handles.checkbox_samerows,'enable','on','value',0);
                set(handles.checkbox_external,'enable','on','value',0);
                set(handles.edit_external,'enable','off','string',' ');
                set(handles.push_ok,'enable','off');
            end

        elseif evalin('base','mcr_als.alsOptions.multi.matr')==1
            errordlg('Re-define your data set class')
            set(handles.text_Ssub,'enable','off');
            set(handles.text_selns,'enable','off');
            set(handles.text_nc,'enable','off');
            set(handles.edit_nc,'enable','off','string',' ');
            set(handles.popup_selns,'string','select...','enable','off','value',1);
            set(handles.text_Csub,'enable','off');
            set(handles.text_selnc,'enable','off');
            set(handles.text_nr,'enable','off');
            set(handles.edit_nr,'enable','off','string',' ');
            set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
            set(handles.checkbox_samerows,'enable','off','value',0);
            set(handles.checkbox_external,'enable','off','value',0);
        elseif evalin('base','mcr_als.alsOptions.multi.matr')==0
            set(handles.text_Csub,'enable','off');
            set(handles.text_selnc,'enable','off');
            set(handles.text_nr,'enable','off');
            set(handles.edit_nr,'enable','off','string',' ');
            set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
            set(handles.checkbox_samerows,'enable','off','value',0);
            set(handles.checkbox_external,'enable','off','value',0);
        end
    end
end

nrsol=zeros(1,matc);
assignin('base','nrsol',nrsol);
evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
evalin('base','clear nrsol ');
assignin('base','matc',matc);
evalin('base','mcr_als.alsOptions.multi.matc=matc;');
evalin('base','clear matc ');


% --- Executes during object creation, after setting all properties.
function popup_numS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_numS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

nexp=evalin('base','mcr_als.alsOptions.nexp');
j=2;
llistannc(1)={'select...'};
for i=1:1:nexp;
    llistnnc=[i];
    llistannc(j)={llistnnc};
    j=j+1;
end;

set(hObject,'string',llistannc)

% --- Executes on selection change in popup_numS.
function popup_numS_Callback(hObject, eventdata, handles)
% hObject    handle to popup_numS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_numS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_numS


matr=get(handles.popup_numS,'Value')-1;

if evalin('base','mcr_als.alsOptions.multi.datamod')==2
    set(handles.text_Ssub,'enable','on');
    set(handles.text_selns,'enable','on');
    set(handles.text_nc,'enable','off');
    set(handles.text_Csub,'enable','off');
    set(handles.text_selnc,'enable','off');
    set(handles.text_nr,'enable','off');
    set(handles.edit_nc,'enable','off','string',' ');
    set(handles.edit_nr,'enable','off');
    set(handles.popup_numC,'enable','off','value',2);

    matc=get(handles.popup_numC,'Value')-1;
    assignin('base','matc',matc);
    evalin('base','mcr_als.alsOptions.multi.matc=matc;');
    evalin('base','clear matc ');
    j=2;
    llistannc(1)={'select...'};

    for i=1:1:matr;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;

    set(handles.popup_selns,'string',llistannc,'enable','on','value',1);
    set(handles.popup_selnc,'enable','off');
    set(handles.checkbox_samerows,'enable','off','value',0);
    set(handles.checkbox_samecolumns,'enable','on','value',0);
    set(handles.checkbox_external,'enable','off','value',0);
    set(handles.push_ok,'enable','off');

    if matc*matr ~= evalin('base','mcr_als.alsOptions.nexp')
        errordlg('Warning: nr. of submatrices in C x nr. of submatrices in S should be equal to nexp')
        set(handles.text_Ssub,'enable','off');
        set(handles.text_selns,'enable','off');
        set(handles.text_nc,'enable','off');
        set(handles.edit_nc,'enable','off','string',' ');
        set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
        set(handles.checkbox_samecolumns,'enable','off','value',0);
    end
else
    max=evalin('base','mcr_als.alsOptions.nexp');
    if matr==1 |matr==max |matr==0
        errordlg('Re-define your data set class');
        set(handles.text_Csub,'enable','off');
        set(handles.text_selnc,'enable','off');
        set(handles.text_nr,'enable','off');
        set(handles.edit_nr,'enable','off','string',' ');
        set(handles.popup_selnc,'string','select...','enable','off','value',1);
        set(handles.checkbox_samerows,'enable','off','value',0);
        set(handles.checkbox_samecolumns,'enable','off','value',0);
        set(handles.checkbox_external,'enable','off','value',0);
        set(handles.text_Ssub,'enable','off');
        set(handles.text_selns,'enable','off');
        set(handles.text_nc,'enable','off');
        set(handles.edit_nc,'enable','off','string',' ');
        set(handles.popup_selns,'string','select...','enable','off','value',1);
    else
        matc=get(handles.popup_numC,'Value')-1;
        assignin('base','matc',matc);
        evalin('base','mcr_als.alsOptions.multi.matc=matc;');
        evalin('base','clear matc ');
        j=2;
        llistannc(1)={'select...'};
        for i=1:1:matr;
            llistnnc=[i];
            llistannc(j)={llistnnc};
            j=j+1;
        end;

        set(handles.push_ok,'enable','off');
        if matc~=1 & matc~=0
            if matc*matr ~= evalin('base','mcr_als.alsOptions.nexp')
                errordlg('Warning: nr. of submatrices in C x nr. of submatrices in S should be equal to nexp')
                set(handles.text_Csub,'enable','off');
                set(handles.text_selnc,'enable','off');
                set(handles.text_nr,'enable','off');
                set(handles.edit_nr,'enable','off','string',' ');
                set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
                set(handles.text_Ssub,'enable','off');
                set(handles.text_selns,'enable','off');
                set(handles.text_nc,'enable','off');
                set(handles.edit_nc,'enable','off','string',' ');
                    set(handles.checkbox_samecolumns,'enable','off','value',0);
                set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
            elseif matc*matr ~= evalin('base','mcr_als.alsOptions.nexp') & (matc==1 | matr==1);
                errordlg('Warning: nr. of submatrices in C x nr. of submatrices in S should be equal to nexp')
                set(handles.text_Csub,'enable','off');
                set(handles.text_selnc,'enable','off');
                set(handles.text_nr,'enable','off');
                set(handles.edit_nr,'enable','off','string',' ');
                set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
                set(handles.checkbox_samerows,'enable','off','value',0);
                    set(handles.checkbox_samecolumns,'enable','off','value',0);
                set(handles.checkbox_external,'enable','off','value',0);
                set(handles.text_Ssub,'enable','off');
                set(handles.text_selns,'enable','off');
                set(handles.text_nc,'enable','off');
                set(handles.edit_nc,'enable','off','string',' ');
                set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
            else
                set(handles.text_Csub,'enable','on');
                set(handles.text_selnc,'enable','on');
                set(handles.text_nr,'enable','off');
                set(handles.edit_nr,'enable','off','string',' ');
                set(handles.popup_selnc,'enable','on','value',1);
                set(handles.checkbox_samerows,'enable','on','value',0);
                set(handles.checkbox_samecolumns,'enable','on','value',0);
                set(handles.checkbox_external,'enable','on','value',0);
                set(handles.edit_external,'enable','off','string',' ');
                set(handles.push_ok,'enable','off');
                set(handles.text_Ssub,'enable','on');
                set(handles.text_selns,'enable','on');
                set(handles.text_nc,'enable','off');
                set(handles.edit_nc,'enable','off','string',' ');
                set(handles.popup_selns,'string',llistannc,'enable','on','value',1);
                set(handles.push_ok,'enable','off');
            end

        elseif evalin('base','mcr_als.alsOptions.multi.matc')==1
            errordlg('Re-define your data set class')
            set(handles.text_Csub,'enable','off');
            set(handles.text_selnc,'enable','off');
            set(handles.text_nr,'enable','off');
            set(handles.edit_nr,'enable','off','string',' ');
            set(handles.popup_selnc,'string','select...','enable','off','value',1);
            set(handles.checkbox_samerows,'enable','off','value',0);
                set(handles.checkbox_samecolumns,'enable','off','value',0);
            set(handles.checkbox_external,'enable','off','value',0);
            set(handles.text_Ssub,'enable','off');
            set(handles.text_selns,'enable','off');
            set(handles.text_nc,'enable','off');
            set(handles.edit_nc,'enable','off','string',' ');
            set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
        elseif evalin('base','mcr_als.alsOptions.multi.matc')==0
            set(handles.text_Ssub,'enable','off');
            set(handles.text_selns,'enable','off');
            set(handles.text_nc,'enable','off');
            set(handles.edit_nc,'enable','off','string',' ');
            set(handles.popup_selns,'string',llistannc,'enable','off','value',1);
                        set(handles.checkbox_samerows,'enable','off','value',0);
                set(handles.checkbox_samecolumns,'enable','off','value',0);
        end
    end
end

ncsol=zeros(1,matr);
assignin('base','ncsol',ncsol);
evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
evalin('base','clear ncsol ');
assignin('base','matr',matr);
evalin('base','mcr_als.alsOptions.multi.matr=matr;');
evalin('base','clear matr ');


% --- Executes during object creation, after setting all properties.
function popup_selnc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_selnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

llistannc={'select...'};
set(hObject,'string',llistannc)

% --- Executes on selection change in popup_selnc.
function popup_selnc_Callback(hObject, eventdata, handles)
% hObject    handle to popup_selnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_selnc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_selnc

numc=get(handles.popup_selnc,'Value')-1;
assignin('base','numc',numc);
evalin('base','mcr_als.alsOptions.multi.numc=numc;');

if numc>0
    set(handles.text_nr,'enable','on');
    set(handles.edit_nr,'enable','on','string',evalin('base','mcr_als.alsOptions.multi.nrsol(numc)'));
else
    set(handles.text_nr,'enable','off');
    set(handles.edit_nr,'enable','off','string',' ');
end

evalin('base','clear numc ');
set(handles.push_ok,'enable','on');

% --- Executes during object creation, after setting all properties.
function edit_nr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_nr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nr as text
%        str2double(get(hObject,'String')) returns contents of edit_nr as a double

nr=str2num(get(hObject,'String'));
assignin('base','nr',nr);
evalin('base','mcr_als.alsOptions.multi.nr=nr;');
evalin('base','clear nr');
nrsol=evalin('base','mcr_als.alsOptions.multi.nrsol');
nrsol(evalin('base','mcr_als.alsOptions.multi.numc'))=nr;
assignin('base','nrsol',nrsol);
evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
evalin('base','clear nrsol ');


% --- Executes during object creation, after setting all properties.
function popup_selns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_selns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

llistannc={'select...'};
set(hObject,'string',llistannc)


% --- Executes on selection change in popup_selns.
function popup_selns_Callback(hObject, eventdata, handles)
% hObject    handle to popup_selns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_selns contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_selns

nums=get(handles.popup_selns,'Value')-1;
assignin('base','nums',nums);
evalin('base','mcr_als.alsOptions.multi.nums=nums;');

if nums>0
    set(handles.text_nc,'enable','on');
    set(handles.edit_nc,'enable','on','string',evalin('base','mcr_als.alsOptions.multi.ncsol(nums)'));
else
    set(handles.text_nc,'enable','off');
    set(handles.edit_nc,'enable','off','string',' ');
end

evalin('base','clear nums ');
set(handles.push_ok,'enable','on');


% --- Executes during object creation, after setting all properties.
function edit_nc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_nc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nc as text
%        str2double(get(hObject,'String')) returns contents of edit_nc as a double

nc=str2num(get(hObject,'String'));
assignin('base','nc',nc);
evalin('base','mcr_als.alsOptions.multi.nc=nc;');
evalin('base','clear nc');
ncsol=evalin('base','mcr_als.alsOptions.multi.ncsol');
ncsol(evalin('base','mcr_als.alsOptions.multi.nums'))=nc;
assignin('base','ncsol',ncsol);
evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
evalin('base','clear ncsol ');


% --- Executes on button press in checkbox_samecolumns.
function checkbox_samecolumns_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_samecolumns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_samecolumns


samecolumns=get(hObject,'Value');

if samecolumns==0;
    set(handles.edit_nc,'enable','off');
    set(handles.text_selns,'enable','on');
    set(handles.text_nc,'enable','off');
    matr=evalin('base','mcr_als.alsOptions.multi.matr');
    
    j=2; % list conc. spectra
    llistannc(1)={'select...'};
    for i=1:1:matr;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    
    set(handles.popup_selns,'string',llistannc,'enable','on','value',1);
    set(handles.push_ok,'enable','off');
    ncsol=zeros(1,matr);
    assignin('base','ncsol',ncsol);
    evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
    evalin('base','clear ncsol ');
else
    set(handles.text_selns,'enable','off');
    set(handles.text_nc,'enable','off');
    set(handles.edit_nc,'enable','off');
    llistannc={'select...'};
    set(handles.popup_selns,'string',llistannc,'enable','off','value',1);

    [files,columnes]=size(evalin('base','mcr_als.alsOptions.matdad'));
    matr=evalin('base','mcr_als.alsOptions.multi.matr');

    ncolumnes=columnes/matr;

    test_num=round(ncolumnes)-ncolumnes;

    if test_num == 0
        ncsol=ncolumnes*ones(1,matr);
        assignin('base','ncsol',ncsol);
        evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
        evalin('base','clear ncsol ');
        assignin('base','nc',ncolumnes);
        evalin('base','mcr_als.alsOptions.multi.nc=nc;');
        evalin('base','clear nc');
        set(handles.push_ok,'enable','on');
    else

        set(handles.edit_nc,'enable','off');
        matr=evalin('base','mcr_als.alsOptions.multi.matr');
        j=2; % list conc. matrices
        llistannc(1)={'select...'};
        for i=1:1:matr;
            llistnnc=[i];
            llistannc(j)={llistnnc};
            j=j+1;
        end;
        set(handles.popup_selns,'string',llistannc,'enable','on','value',1);
        set(handles.text_selns,'enable','on');
        set(handles.push_ok,'enable','off');
        ncsol=zeros(1,matr);
        assignin('base','ncsol',ncsol);
        evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
        evalin('base','clear ncsol ');
        set(handles.checkbox_samerows,'enable','on','value',0);
        errordlg('check dimensions!! It is not possible that each matrix has the same nr. of columns');
    end

end

% --- Executes on button press in checkbox_samerows.
function checkbox_samerows_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_samerows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_samerows

samerows=get(hObject,'Value');

if samerows==0;
    set(handles.edit_external,'enable','off','string',' ');
    set(handles.edit_nr,'enable','off');
    set(handles.checkbox_external,'enable','on','value',0);
    set(handles.text_selnc,'enable','on');
    set(handles.text_nr,'enable','off');
    matc=evalin('base','mcr_als.alsOptions.multi.matc');
    
    j=2; % list conc. matrices
    llistannc(1)={'select...'};
    for i=1:1:matc;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    
    set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
    set(handles.push_ok,'enable','off');
    nrsol=zeros(1,matc);
    assignin('base','nrsol',nrsol);
    evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
    evalin('base','clear nrsol ');
else
    set(handles.text_selnc,'enable','off');
    set(handles.edit_external,'enable','off','string',' ');
    set(handles.checkbox_external,'enable','off','value',0);
    set(handles.text_nr,'enable','off');
    set(handles.edit_nr,'enable','off');
    llistannc={'select...'};
    set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);

    [files,columnes]=size(evalin('base','mcr_als.alsOptions.matdad'));
    matc=evalin('base','mcr_als.alsOptions.multi.matc');

    nfiles=files/matc;

    test_num=round(nfiles)-nfiles;

    if test_num == 0
        nrsol=nfiles*ones(1,matc);
        assignin('base','nrsol',nrsol);
        evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
        evalin('base','clear nrsol ');
        assignin('base','nr',nfiles);
        evalin('base','mcr_als.alsOptions.multi.nr=nr;');
        evalin('base','clear nr');
        set(handles.push_ok,'enable','on');
    else

        set(handles.edit_external,'enable','off','string',' ');
        set(handles.edit_nr,'enable','off');
        set(handles.checkbox_external,'enable','on','value',0);
        matc=evalin('base','mcr_als.alsOptions.multi.matc');
        j=2; % list conc. matrices
        llistannc(1)={'select...'};
        for i=1:1:matc;
            llistnnc=[i];
            llistannc(j)={llistnnc};
            j=j+1;
        end;
        set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
        set(handles.text_selnc,'enable','on');
        set(handles.push_ok,'enable','off');
        nrsol=zeros(1,matc);
        assignin('base','nrsol',nrsol);
        evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
        evalin('base','clear nrsol ');
        set(handles.checkbox_samerows,'enable','on','value',0);

        errordlg('check dimensions!! It is not possible that each matrix has the same nr. of rows');
    end

end


% --- Executes on button press in checkbox_external.
function checkbox_external_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_external


external=get(hObject,'Value');

if external==0;
    set(handles.text_selnc,'enable','on');
    set(handles.text_nr,'enable','off');
    set(handles.edit_external,'enable','off','string',' ');
    set(handles.edit_nr,'enable','off');
    set(handles.checkbox_samerows,'enable','on','value',0);

    matc=evalin('base','mcr_als.alsOptions.multi.matc');
    j=2; % list conc. matrices
    llistannc(1)={'select...'};
    for i=1:1:matc;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
    set(handles.push_ok,'enable','off');
    nrsol=zeros(1,matc);
    assignin('base','nrsol',nrsol);
    evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
    evalin('base','clear nrsol ');
else

    set(handles.text_selnc,'enable','off');
    set(handles.text_nr,'enable','off');
    set(handles.edit_external,'enable','on','string',' ');
    set(handles.edit_nr,'enable','off');
    set(handles.checkbox_samerows,'enable','off','value',0);
    llistannc={'select...'};
    set(handles.popup_selnc,'string',llistannc,'enable','off','value',1);
    set(handles.push_ok,'enable','off');
end


% --- Executes during object creation, after setting all properties.
function edit_external_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_external_Callback(hObject, eventdata, handles)
% hObject    handle to edit_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_external as text
%        str2double(get(hObject,'String')) returns contents of edit_external as a double

external_char=get(hObject,'String');

nrsol=evalin('base',external_char);

[files,columnes]=size(evalin('base','mcr_als.alsOptions.matdad'));
nrsuma=sum(nrsol);

if nrsuma==files
    assignin('base','nrsol',nrsol);
    evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
    evalin('base','clear nrsol ');
    set(handles.push_ok,'enable','on');
else

    set(handles.text_selnc,'enable','on');
    set(handles.text_nr,'enable','on');
   
    set(handles.edit_external,'enable','off','string',' ');
    set(handles.edit_nr,'enable','off');
    set(handles.checkbox_external,'enable','on','value',0);
    matc=evalin('base','mcr_als.alsOptions.multi.matc');
    j=2; % list conc. matrices
    llistannc(1)={'select...'};
    for i=1:1:matc;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    set(handles.popup_selnc,'string',llistannc,'enable','on','value',1);
    set(handles.push_ok,'enable','off');
    nrsol=zeros(1,matc);
    assignin('base','nrsol',nrsol);
    evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
    evalin('base','clear nrsol ');
    set(handles.checkbox_samerows,'enable','on','value',0);

    errordlg('Error! Nr. rows of exp. data and of your ext. variable don''t agree');


end


% --- Executes on button press in push_can.
function push_can_Callback(hObject, eventdata, handles)
% hObject    handle to push_can (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;

% --- Executes on button press in push_ok.
function push_ok_Callback(hObject, eventdata, handles)
% hObject    handle to push_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if evalin('base','mcr_als.alsOptions.multi.datamod') ==1
    nrsol=evalin('base','mcr_als.alsOptions.multi.nrsol');
    [nr,nc]=size(evalin('base','mcr_als.alsOptions.matdad'));
    nrfin=cumsum(evalin('base','mcr_als.alsOptions.multi.nrsol'));
    [b,a]=size(nrfin);
    nrinic=[1 1+nrfin(1:(a-1))];
    for i=1:a;
        ncinic(1,i)=1;
        ncfin(1,i)=nc;
    end
    ncsol=nc;
    assignin('base','ncsol',ncsol);
    evalin('base','mcr_als.alsOptions.multi.ncsol=ncsol;');
    evalin('base','clear ncsol ');
elseif evalin('base','mcr_als.alsOptions.multi.datamod')==2
    ncsol=evalin('base','mcr_als.alsOptions.multi.ncsol');
    [nr,nc]=size(evalin('base','mcr_als.alsOptions.matdad'));
    ncfin=cumsum(evalin('base','mcr_als.alsOptions.multi.ncsol'));
    [b,a]=size(ncfin);
    ncinic=[1 1+ncfin(1:(a-1))];
    for i=1:a;
        nrinic(1,i)=1;
        nrfin(1,i)=nr;
    end
    nrsol=nr;
    assignin('base','nrsol',nrsol);
    evalin('base','mcr_als.alsOptions.multi.nrsol=nrsol;');
    evalin('base','clear nrsol ');
elseif evalin('base','mcr_als.alsOptions.multi.datamod')==3
    nrsol=evalin('base','mcr_als.alsOptions.multi.nrsol');
    ncsol=evalin('base','mcr_als.alsOptions.multi.ncsol');
    [nr,nc]=size(evalin('base','mcr_als.alsOptions.matdad'));
    nrfin=cumsum(evalin('base','mcr_als.alsOptions.multi.nrsol'));
    [b,a]=size(nrfin);
    nrinic=[1 1+nrfin(1:(a-1))];
    ncfin=cumsum(evalin('base','mcr_als.alsOptions.multi.ncsol'));
    [b,a]=size(ncfin);
    ncinic=[1 1+ncfin(1:(a-1))];
end

assignin('base','ncfin',ncfin);
evalin('base','mcr_als.alsOptions.multi.ncfin=ncfin;');
evalin('base','clear ncfin ');
assignin('base','ncinic',ncinic);
evalin('base','mcr_als.alsOptions.multi.ncinic=ncinic;');
evalin('base','clear ncinic ');
assignin('base','nrfin',nrfin);
evalin('base','mcr_als.alsOptions.multi.nrfin=nrfin;');
evalin('base','clear nrfin ');
assignin('base','nrinic',nrinic);
evalin('base','mcr_als.alsOptions.multi.nrinic=nrinic;');
evalin('base','clear nrinic ');

% isp
nesp=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
matc=evalin('base','mcr_als.alsOptions.multi.matc');
matr=evalin('base','mcr_als.alsOptions.multi.matr');
isp=ones(matc,nesp);
assignin('base','isp',isp);
evalin('base','mcr_als.alsOptions.multi.isp=isp;');
evalin('base','clear isp ');

% check dimensions

if evalin('base','mcr_als.alsOptions.multi.datamod')==1
    dimr=sum(evalin('base','mcr_als.alsOptions.multi.nrsol'));
    [row,col]=size(evalin('base','mcr_als.alsOptions.matdad'));
    if dimr ~= row
        errordlg('check dimensionsof the c submatrices');
    else
        close;
        rowMultiConstraints;
    end

elseif evalin('base','mcr_als.alsOptions.multi.datamod')==2
    dimc=sum(evalin('base','mcr_als.alsOptions.multi.ncsol'));
    [row,col]=size(evalin('base','mcr_als.alsOptions.matdad'));
    if dimc ~= col
        errordlg('check dimensions of the s submatrices');
    else
        close;
        rowModeConstraints;
    end

elseif evalin('base','mcr_als.alsOptions.multi.datamod')==3
    dimr=sum(evalin('base','mcr_als.alsOptions.multi.nrsol'));
    dimc=sum(evalin('base','mcr_als.alsOptions.multi.ncsol'));
    [row,col]=size(evalin('base','mcr_als.alsOptions.matdad'));
    if dimr ~= row
        errordlg('check dimensionsof the c submatrices');
    elseif dimc ~= col
        errordlg('check dimensions of the s submatrices');
    else
        close;
        rowMultiConstraints;
    end

end



