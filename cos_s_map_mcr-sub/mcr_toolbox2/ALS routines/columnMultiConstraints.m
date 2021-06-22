function varargout = columnMultiConstraints(varargin)
% COLUMNMULTICONSTRAINTS MATLAB code for columnMultiConstraints.fig
%      COLUMNMULTICONSTRAINTS, by itself, creates a new COLUMNMULTICONSTRAINTS or raises the existing
%      singleton*.
%
%      H = COLUMNMULTICONSTRAINTS returns the handle to a new COLUMNMULTICONSTRAINTS or the handle to
%      the existing singleton*.
%
%      COLUMNMULTICONSTRAINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLUMNMULTICONSTRAINTS.M with the given input arguments.
%
%      COLUMNMULTICONSTRAINTS('Property','Value',...) creates a new COLUMNMULTICONSTRAINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before columnMultiConstraints_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to columnMultiConstraints_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help columnMultiConstraints

% Last Modified by GUIDE v2.5 13-May-2014 14:27:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @columnMultiConstraints_OpeningFcn, ...
    'gui_OutputFcn',  @columnMultiConstraints_OutputFcn, ...
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


% --- Executes just before columnMultiConstraints is made visible.
function columnMultiConstraints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to columnMultiConstraints (see VARARGIN)

% Choose default command line output for columnMultiConstraints
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

clos_used=evalin('base','mcr_als.alsOptions.closure.closure');
if clos_used==1
    set(handles.check_closC,'enable','off');
    set(handles.Pan_Clos,'visible','on');
    
    closX='concentration';
    assignin('base','closX',closX);
    evalin('base','mcr_als.alsOptions.closure.type=closX;');
    evalin('base','clear closX');
end

evalin('base','mcr_als.alsOptions.multi.scons=0;'); % equal constraint to all Cs
evalin('base','mcr_als.alsOptions.multi.curr_smat=1;'); % current matrix

% default isp
matr=evalin('base','mcr_als.alsOptions.multi.matr');
nsp=evalin('base','min(size(mcr_als.alsOptions.iniesta))');

% total Nr of row submatrices
set(handles.text_num,'String',num2str(matr));

% UIWAIT makes columnMultiConstraints wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = columnMultiConstraints_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Actual Matrix
% *********************************************************************

% --- Executes on button press in check_sameS.
function check_sameS_Callback(hObject, eventdata, handles)
% hObject    handle to check_sameS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_sameS

scons=get(hObject,'Value');

if scons==0
    set(handles.text_matrixNr,'enable','on');
    matrixNR=evalin('base','mcr_als.alsOptions.multi.matr');
    j=1;
    for i=1:matrixNR,
        lsb=[i];
        lsv(j)={lsb};
        j=j+1;
    end;
    set(handles.popup_matrixNr,'enable','on','string',lsv,'value',1);
    
    %reset all values
    set(handles.check_nnC,'enable','on','value',0);
    set(handles.text_nnCi,'enable','off');
    set(handles.popup_nnCi,'enable','off','value',1);
    set(handles.text_nnCsp,'enable','off');
    set(handles.popup_nnCsp,'enable','off','value',1);
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegS'');');
    
    set(handles.check_unimod,'enable','on','value',0);
    set(handles.text_Ui,'enable','off');
    set(handles.popup_Ui,'enable','off','value',1);
    set(handles.text_Up,'enable','off');
    set(handles.popup_Up,'enable','off','value',1);
    set(handles.text_Utol,'enable','off');
    set(handles.edit_Utol,'enable','off','string',' ');
    set(handles.text_Uv,'enable','off');
    set(handles.edit_Uv,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodS'');');
    
    clos_used=evalin('base','mcr_als.alsOptions.closure.closure');
    if clos_used==1
        set(handles.check_closC,'enable','off');
        set(handles.Pan_Clos,'visible','on');
        
        closX='concentration';
        assignin('base','closX',closX);
        evalin('base','mcr_als.alsOptions.closure.type=closX;');
        evalin('base','clear closX');
    else
        set(handles.check_closC,'enable','on','value',0);
        set(handles.text_Cnr,'enable','off');
        set(handles.popup_Cnr,'enable','off','value',1);
        set(handles.check_Cvar,'enable','off','value',0);
        set(handles.text_C1,'enable','off');
        set(handles.text_C1v,'enable','off');
        set(handles.text_C1c,'enable','off');
        set(handles.text_C1sp,'enable','off');
        set(handles.check_C1sp,'enable','off','value',0);
        set(handles.popup_C1c,'enable','off','value',1);
        set(handles.edit_C1,'enable','off','string',' ');
        set(handles.edit_C1v,'enable','off','string',' ');
        set(handles.edit_C1sp,'enable','off','string',' ');
        set(handles.text_C2,'enable','off');
        set(handles.text_C2v,'enable','off');
        set(handles.text_C2c,'enable','off');
        set(handles.text_C2sp,'enable','off');
        set(handles.check_C2sp,'enable','off','value',0);
        set(handles.popup_C2c,'enable','off','value',1);
        set(handles.edit_C2,'enable','off','string',' ');
        set(handles.edit_C2v,'enable','off','string',' ');
        set(handles.edit_C2sp,'enable','off','string',' ');
        evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''closure'');'); % compte
        closX='None';
        assignin('base','closX',closX);
        evalin('base','mcr_als.alsOptions.closure.type=closX;');
        evalin('base','clear closX');
    end
    
    set(handles.check_eqC,'enable','on','value',0);
    set(handles.text_eqCs,'enable','off');
    set(handles.popup_eqCs,'enable','off','value',1);
    set(handles.text_eqCc,'enable','off');
    set(handles.popup_eqCc,'enable','off','value',1);
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''sselcS'');');
    
    evalin('base','mcr_als.alsOptions.nonegS.noneg=0;');
    evalin('base','mcr_als.alsOptions.unimodS.unimodal=0;');
    evalin('base','mcr_als.alsOptions.closure.closure=0;'); % compte
    evalin('base','mcr_als.alsOptions.sselcS.sselcon=0;');
    
else
    set(handles.text_matrixNr,'enable','off');
    set(handles.popup_matrixNr,'enable','off','Value',1,'String','Same constraints');
    
    %reset all values
    set(handles.check_nnC,'enable','on','value',0);
    set(handles.text_nnCi,'enable','off');
    set(handles.popup_nnCi,'enable','off','value',1);
    set(handles.text_nnCsp,'enable','off');
    set(handles.popup_nnCsp,'enable','off','value',1);
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegS'');');
    
    set(handles.check_unimod,'enable','on','value',0);
    set(handles.text_Ui,'enable','off');
    set(handles.popup_Ui,'enable','off','value',1);
    set(handles.text_Up,'enable','off');
    set(handles.popup_Up,'enable','off','value',1);
    set(handles.text_Utol,'enable','off');
    set(handles.edit_Utol,'enable','off','string',' ');
    set(handles.text_Uv,'enable','off');
    set(handles.edit_Uv,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodS'');');
    
    clos_used=evalin('base','mcr_als.alsOptions.closure.closure');
    if clos_used==1
        set(handles.check_closC,'enable','off');
        set(handles.Pan_Clos,'visible','on');
        
        closX='concentration';
        assignin('base','closX',closX);
        evalin('base','mcr_als.alsOptions.closure.type=closX;');
        evalin('base','clear closX');
    else
        set(handles.check_closC,'enable','on','value',0);
        set(handles.text_Cnr,'enable','off');
        set(handles.popup_Cnr,'enable','off','value',1);
        set(handles.check_Cvar,'enable','off','value',0);
        set(handles.text_C1,'enable','off');
        set(handles.text_C1v,'enable','off');
        set(handles.text_C1c,'enable','off');
        set(handles.text_C1sp,'enable','off');
        set(handles.check_C1sp,'enable','off','value',0);
        set(handles.popup_C1c,'enable','off','value',1);
        set(handles.edit_C1,'enable','off','string',' ');
        set(handles.edit_C1v,'enable','off','string',' ');
        set(handles.edit_C1sp,'enable','off','string',' ');
        set(handles.text_C2,'enable','off');
        set(handles.text_C2v,'enable','off');
        set(handles.text_C2c,'enable','off');
        set(handles.text_C2sp,'enable','off');
        set(handles.check_C2sp,'enable','off','value',0);
        set(handles.popup_C2c,'enable','off','value',1);
        set(handles.edit_C2,'enable','off','string',' ');
        set(handles.edit_C2v,'enable','off','string',' ');
        set(handles.edit_C2sp,'enable','off','string',' ');
        evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''closure'');');  % Ok, no closure applied
        closX='None';
        assignin('base','closX',closX);
        evalin('base','mcr_als.alsOptions.closure.type=closX;');
        evalin('base','clear closX');
    end
    
    set(handles.check_eqC,'enable','on','value',0);
    set(handles.text_eqCs,'enable','off');
    set(handles.popup_eqCs,'enable','off','value',1);
    set(handles.text_eqCc,'enable','off');
    set(handles.popup_eqCc,'enable','off','value',1);
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''sselcS'');');
    
    evalin('base','mcr_als.alsOptions.nonegS.noneg=0;');
    evalin('base','mcr_als.alsOptions.unimodS.unimodal=0;');
    if clos_used~=1
    evalin('base','mcr_als.alsOptions.closure.closure=0;');% only if no C closure
    end
    evalin('base','mcr_als.alsOptions.sselcS.sselcon=0;');
    
end

assignin('base','scons',scons);
evalin('base','mcr_als.alsOptions.multi.scons=scons;');
evalin('base','clear scons');


% --- Executes during object creation, after setting all properties.
function popup_matrixNr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_matrixNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

matrixNR=evalin('base','mcr_als.alsOptions.multi.matr');
j=1;
for i=1:matrixNR,
    lsb=[i];
    lsv(j)={lsb};
    j=j+1;
end;
set(hObject,'string',lsv)

% --- Executes on selection change in popup_matrixNr.
function popup_matrixNr_Callback(hObject, eventdata, handles)
% hObject    handle to popup_matrixNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_matrixNr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_matrixNr

nmat = get(hObject,'value');
former_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
curr_smat=nmat;
assignin('base','curr_smat',curr_smat);
evalin('base','mcr_als.alsOptions.multi.curr_smat=curr_smat;');
evalin('base','clear curr_smat');

% start -> values that can be modified

if get(handles.popup_nnCsp,'value')~=1 & (former_smat~=curr_smat);
    treated=evalin('base','mcr_als.alsOptions.nonegS.treated');
    spneg=evalin('base','mcr_als.alsOptions.nonegS.spneg');
    if treated(1,3)==0
        % forzed to zero
        if treated(curr_smat,1)==0
            set(handles.popup_nnCsp,'value',1);
            set(handles.edit_nnCp,'string',' ','enable','off');
        else
            valor=treated(curr_smat,2)+2;
            nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
            nsign=nsign+2;
            set(handles.popup_nnCsp,'value',valor);
            if valor==(0+2)
                set(handles.edit_nnCp,'string',' ','enable','off');
            elseif valor==(nsign)
                set(handles.edit_nnCp,'string',' ','enable','off');
            else
                set(handles.edit_nnCp,'string',num2str(cneg(curr_smat,:)),'enable','off');
            end
            
        end
    elseif treated(1,3)==1 | treated(1,3)==2
        % nnls and fnnls
        if treated(curr_smat,1)==0
            set(handles.popup_nnCsp,'value',1);
            set(handles.edit_nnCp,'string',' ','enable','off');
        else
            valor=treated(curr_smat,2)+2;
            set(handles.popup_nnCsp,'value',valor);
            set(handles.edit_nnCp,'string',' ','enable','off');
        end
    end
end

if get(handles.popup_Up,'value') ~=1 & (former_smat~=curr_smat);
    treated=evalin('base','mcr_als.alsOptions.unimodS.treated');
    spsmod=evalin('base','mcr_als.alsOptions.unimodS.spsmod');
    if treated(curr_smat,1)==0
        set(handles.popup_Up,'value',1);
        set(handles.edit_Uv,'string',' ','enable','off');
    else
        valor=treated(curr_smat,2)+2;
        nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
        nsign=nsign+2;
        set(handles.popup_Up,'value',valor);
        if valor==(0+2)
            set(handles.edit_Uv,'string',' ','enable','off');
        elseif valor==(nsign)
            set(handles.edit_Uv,'string',' ','enable','off');
        else
            set(handles.edit_Uv,'string',num2str(spsmod(curr_smat,:)),'enable','off');
        end
        
    end
end


if get(handles.popup_Cnr,'value') ~=1 & (former_smat~=curr_smat);
    dc=evalin('base','mcr_als.alsOptions.closure.dc');
    if dc==2
        treated=evalin('base','mcr_als.alsOptions.closure.treated');
        sclos1=evalin('base','mcr_als.alsOptions.closure.sclos1');
        sclos2=evalin('base','mcr_als.alsOptions.closure.sclos2');
        
        if treated(curr_smat,1)==0
            set(handles.popup_Cnr,'value',1);
            set(handles.edit_C1,'string',' ','enable','off');
            set(handles.edit_C2,'string',' ','enable','off');
            set(handles.edit_C1v,'string',' ','enable','off');
            set(handles.edit_C2v,'string',' ','enable','off');
            set(handles.popup_C1c,'value',1,'enable','off');
            set(handles.popup_C2c,'value',1,'enable','off');
            set(handles.edit_C1sp,'string',' ','enable','off');
            set(handles.edit_C2sp,'string',' ','enable','off');
            set(handles.check_C1sp,'value',0,'enable','off');
            set(handles.check_C2sp,'value',0,'enable','off');
            set(handles.check_Cvar,'value',0,'enable','off');
        else
            % number of closures
            clos_number=treated(curr_smat,2);
            if clos_number==0
                set(handles.popup_Cnr,'value',clos_number+2);
                set(handles.edit_C1,'string',' ','enable','off');
                set(handles.edit_C2,'string',' ','enable','off');
                set(handles.edit_C1v,'string',' ','enable','off');
                set(handles.edit_C2v,'string',' ','enable','off');
                set(handles.popup_C1c,'value',1,'enable','off');
                set(handles.popup_C2c,'value',1,'enable','off');
                set(handles.edit_C1sp,'string',' ','enable','off');
                set(handles.edit_C2sp,'string',' ','enable','off');
                set(handles.check_C1sp,'value',0,'enable','off');
                set(handles.check_C2sp,'value',0,'enable','off');
                set(handles.check_Cvar,'value',0,'enable','off');
            elseif clos_number==1
                set(handles.popup_Cnr,'value',clos_number+2);
                set(handles.edit_C1,'string',num2str(treated(curr_smat,3)),'enable','on');
                set(handles.edit_C2,'string',' ','enable','off');
                set(handles.edit_C1v,'string',' ','enable','off');
                set(handles.edit_C2v,'string',' ','enable','off');
                set(handles.popup_C1c,'value',treated(curr_smat,4)+1,'enable','on');
                set(handles.popup_C2c,'value',1,'enable','off');
                set(handles.edit_C1sp,'string',num2str(sclos1(curr_smat,:)),'enable','on');
                set(handles.edit_C2sp,'string',' ','enable','off');
                nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
                clos_sp1=treated(curr_smat,5);
                if nsign==clos_sp1
                    set(handles.check_C1sp,'value',1,'enable','on');
                else
                    set(handles.check_C1sp,'value',0,'enable','on');
                end
                set(handles.check_C2sp,'value',0,'enable','off');
                
                set(handles.check_Cvar,'value',0,'enable','off');
                
            elseif clos_number==2
                set(handles.popup_Cnr,'value',clos_number+2);
                set(handles.edit_C1,'string',num2str(treated(curr_smat,3)),'enable','on');
                set(handles.edit_C2,'string',num2str(treated(curr_smat,6)),'enable','on');
                set(handles.edit_C1v,'string',' ','enable','off');
                set(handles.edit_C2v,'string',' ','enable','off');
                set(handles.popup_C1c,'value',treated(curr_smat,4)+1,'enable','on');
                set(handles.popup_C2c,'value',treated(curr_smat,7)+1,'enable','on');
                set(handles.edit_C1sp,'string',num2str(sclos1(curr_smat,:)),'enable','on');
                set(handles.edit_C2sp,'string',num2str(sclos2(curr_smat,:)),'enable','on');
                nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
                clos_sp1=treated(curr_smat,5);
                clos_sp2=treated(curr_smat,8);
                if nsign==clos_sp1
                    set(handles.check_C1sp,'value',1,'enable','on');
                else
                    set(handles.check_C1sp,'value',0,'enable','on');
                end
                if nsign==clos_sp2
                    set(handles.check_C2sp,'value',1,'enable','on');
                else
                    set(handles.check_C2sp,'value',0,'enable','on');
                end
                
                set(handles.check_Cvar,'value',0,'enable','off');
                
            end
            
        end
    end
end

% end -> values that can be modified

assignin('base','curr_smat',curr_smat);
evalin('base','mcr_als.alsOptions.multi.curr_smat=curr_smat;');
evalin('base','clear curr_smat');



% Non-negativity
% *********************************************************************

% --- Executes on button press in check_nnC.
function check_nnC_Callback(hObject, eventdata, handles)
% hObject    handle to check_nnC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_nnC

noneg=get(hObject,'Value');

if noneg==0;
    set(handles.text_nnCi,'enable','off');
    set(handles.popup_nnCi,'enable','off','value',1);
    set(handles.text_nnCsp,'enable','off');
    set(handles.popup_nnCsp,'enable','off','value',1);
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''nonegS'');');
else
    set(handles.text_nnCi,'enable','on');
    set(handles.popup_nnCi,'enable','on','value',1);
    set(handles.text_nnCsp,'enable','off');
    set(handles.popup_nnCsp,'enable','off','value',1);
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions.nonegS.spneg=[];');
    
    evalin('base','mcr_als.alsOptions.nonegS.treated=zeros(mcr_als.alsOptions.multi.matr,3);');
end;

assignin('base','noneg',noneg);
evalin('base','mcr_als.alsOptions.nonegS.noneg=noneg;');
evalin('base','clear noneg');

% --- Executes during object creation, after setting all properties.
function popup_nnCi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_nnCi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'forced to zero'};
llista(3)={'nnls'};
llista(4)={'fnnls'};
set(hObject,'string',llista)

% --- Executes on selection change in popup_nnCi.
function popup_nnCi_Callback(hObject, eventdata, handles)
% hObject    handle to popup_nnCi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_nnCi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_nnCi

ialgs=get(hObject,'Value')-2;
assignin('base','ialgs',ialgs);
evalin('base','mcr_als.alsOptions.nonegS.ialgs=ialgs;');

if ialgs==-1
    
    set(handles.text_nnCsp,'enable','off');
    set(handles.popup_nnCsp,'enable','off'),
    set(handles.popup_nnCsp,'string','select...');
    
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string','');
    
elseif ialgs==0
    
    dim=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    j=2;
    llistannc(1)={'select...'};
    for i=0:1:dim;
        llistnnc=[i];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    
    set(handles.text_nnCsp,'enable','on');
    set(handles.popup_nnCsp,'enable','on','value',1)
    set(handles.popup_nnCsp,'string',llistannc)
    
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string','');
    
elseif (ialgs==1 | ialgs==2)
    dim=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    llistannc(1)={'select...'};
    llistnnc=[0 dim];
    llistannc(2)={llistnnc};
    
    set(handles.text_nnCsp,'enable','on');
    set(handles.popup_nnCsp,'enable','on','value',1)
    set(handles.popup_nnCsp,'string',llistannc)
    
    set(handles.text_nnCp,'enable','off');
    set(handles.edit_nnCp,'enable','off','string','');
    
end

evalin('base','mcr_als.alsOptions.nonegS.treated(:,3)=ialgs;');

evalin('base','clear ialgs');


% --- Executes during object creation, after setting all properties.
function popup_nnCsp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_nnCsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_nnCsp.
function popup_nnCsp_Callback(hObject, eventdata, handles)
% hObject    handle to popup_nnCsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_nnCsp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_nnCsp

nspneg=get(hObject,'Value')-2;

assignin('base','nspneg',nspneg);
evalin('base','mcr_als.alsOptions.nonegS.nspneg=nspneg;');

dim=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
nexp=evalin('base','mcr_als.alsOptions.nexp');
ialgs=evalin('base','mcr_als.alsOptions.nonegS.ialgs');
matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
spneg=evalin('base','mcr_als.alsOptions.nonegS.spneg');
assignin('base','matr',matr);
assignin('base','dim',dim);
assignin('base','curr_smat',curr_smat);


if evalin('base','mcr_als.alsOptions.multi.scons')==1
    if ialgs == 0
        if nspneg == dim;
            spneg = ones(dim,nexp);
            set(handles.text_nnCp,'enable','off');
            set(handles.edit_nnCp,'enable','off','string','');
        elseif  nspneg == -1
            spneg=zeros(dim,nexp);
            set(handles.text_nnCp,'enable','off');
            set(handles.edit_nnCp,'enable','off','string','');
        elseif  nspneg == 0
            spneg = zeros(dim,nexp);
            set(handles.text_nnCp,'enable','off');
            set(handles.edit_nnCp,'enable','off','string','');
        else
            spneg=[];
            set(handles.text_nnCp,'enable','on');
            set(handles.edit_nnCp,'enable','on');
        end
    else
        if nspneg==0
            spneg = zeros(dim,matr);
        elseif nspneg==1
            spneg = ones(dim,matr);
        end
    end
elseif evalin('base','mcr_als.alsOptions.multi.scons')==0
    if ialgs == 0
        if nspneg == dim;
            spnegr=ones(dim,1);
            spneg(curr_smat,:)=spnegr;
            assignin('base','spneg',spneg);
            evalin('base','mcr_als.alsOptions.nonegS.spneg = spneg;');
            set(handles.text_nnCp,'enable','off');
            set(handles.edit_nnCp,'enable','off','string','');
        elseif  nspneg == -1
            spnegr=zeros(dim,1);
            spneg(curr_smat,:)=spnegr;
            assignin('base','spneg',spneg);
            evalin('base','mcr_als.alsOptions.nonegS.spneg = spneg;');
            set(handles.text_nnCp,'enable','off');
            set(handles.edit_nnCp,'enable','off','string','');
        elseif  nspneg == 0
            spnegr=zeros(dim,1);
            spneg(curr_smat,:)=spnegr;
            assignin('base','spneg',spneg);
            evalin('base','mcr_als.alsOptions.nonegS.cneg = spneg;');
            set(handles.text_nnCp,'enable','off');
            set(handles.edit_nnCp,'enable','off','string','');
        else
            set(handles.text_spcnn,'enable','on');
            set(handles.edit_spcnn,'enable','on');
        end
    else
        if nspneg==0;
            form_spneg = zeros(dim,1);
            spneg(:,curr_smat)=form_spneg;
        elseif nspneg==1;
            form_spneg= ones(dim,1);
            spneg(:,curr_smat)=form_spneg;
        end
    end
    
    evalin('base','mcr_als.alsOptions.nonegS.treated(curr_smat,1)=1;');
    evalin('base','mcr_als.alsOptions.nonegS.treated(curr_smat,2)=nspneg;');
    
end
assignin('base','spneg',spneg);
evalin('base','mcr_als.alsOptions.nonegS.spneg=spneg;');
evalin('base','clear spneg nspneg curr_smat dim matr;');


% --- Executes during object creation, after setting all properties.
function edit_nnCp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nnCp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nnCp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nnCp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nnCp as text
%        str2double(get(hObject,'String')) returns contents of edit_nnCp as a double

spnegr=str2num(get(hObject,'String'));

curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
spneg=evalin('base','mcr_als.alsOptions.nonegS.spneg');
assignin('base','curr_smat',curr_smat);
spneg(curr_smat,:)=spnegr;

assignin('base','spneg',spneg);
evalin('base','mcr_als.alsOptions.nonegS.spneg=spneg;');
evalin('base','clear spneg');

% Unimodality
% *********************************************************************

% --- Executes on button press in check_unimod.
function check_unimod_Callback(hObject, eventdata, handles)
% hObject    handle to check_unimod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_unimod

unimodal=get(hObject,'Value');

if unimodal==1;
    set(handles.text_Ui,'enable','on');
    set(handles.popup_Ui,'enable','on','value',1);
    set(handles.text_Up,'enable','on');
    set(handles.popup_Up,'enable','on','value',1);
    set(handles.text_Utol,'enable','on');
    set(handles.edit_Utol,'enable','on','string',' 1.1');
    set(handles.text_Uv,'enable','off');
    set(handles.edit_Uv,'enable','off','string',' ');
    
    evalin('base','mcr_als.alsOptions.unimodS.spsmod=[];');
    % default value of Utol
    smod=1.1;
    assignin('base','smod',smod);
    evalin('base','mcr_als.alsOptions.unimodS.smod=smod;');
    evalin('base','clear smod');
    
    evalin('base','mcr_als.alsOptions.unimodS.treated=zeros(mcr_als.alsOptions.multi.matr,2);');
    
else
    set(handles.text_Ui,'enable','off');
    set(handles.popup_Ui,'enable','off','value',1);
    set(handles.text_Up,'enable','off');
    set(handles.popup_Up,'enable','off','value',1);
    set(handles.text_Utol,'enable','off');
    set(handles.edit_Utol,'enable','off','string',' ');
    set(handles.text_Uv,'enable','off');
    set(handles.edit_Uv,'enable','off','string',' ');
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''unimodS'');');
end;

assignin('base','unimodal',unimodal);
evalin('base','mcr_als.alsOptions.unimodS.unimodal=unimodal;');
evalin('base','clear unimodal');

% --- Executes during object creation, after setting all properties.
function popup_Ui_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_Ui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'vertical'};
llista(3)={'horizontal'};
llista(4)={'average'};
set(hObject,'string',llista)

% --- Executes on selection change in popup_Ui.
function popup_Ui_Callback(hObject, eventdata, handles)
% hObject    handle to popup_Ui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_Ui contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_Ui

cmod=get(hObject,'Value')-2;
assignin('base','cmod',cmod);
evalin('base','mcr_als.alsOptions.unimodS.cmod=cmod;');
evalin('base','clear cmod');

% --- Executes during object creation, after setting all properties.
function popup_Up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

dim=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
j=2;
llistannc(1)={'select...'};
for i=0:1:dim;
    llistnnc=[i];
    llistannc(j)={llistnnc};
    j=j+1;
end;

set(hObject,'string',llistannc)


% --- Executes on selection change in popup_Up.
function popup_Up_Callback(hObject, eventdata, handles)
% hObject    handle to popup_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_Up contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_Up

nsmod=get(hObject,'Value')-2;

assignin('base','nsmod',nsmod);
evalin('base','mcr_als.alsOptions.unimodS.nsmod=nsmod;');

dim=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
nexp=evalin('base','mcr_als.alsOptions.nexp');
matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
spsmod=evalin('base','mcr_als.alsOptions.unimodS.spsmod');

assignin('base','matr',matr);
assignin('base','dim',dim);
assignin('base','curr_smat',curr_smat);

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    if nsmod == dim
        spsmod=ones(matr,dim);
        set(handles.text_Uv,'enable','off');
        set(handles.edit_Uv,'enable','off','string','');
    elseif  nsmod == 0
        spsmod=zeros(matr,dim);
        set(handles.text_Uv,'enable','off');
        set(handles.edit_Uv,'enable','off','string','');
    elseif  nsmod == -1
        spsmod=[];
        set(handles.text_Uv,'enable','off');
        set(handles.edit_Uv,'enable','off','string','');
    else
        spsmod=[];
        set(handles.text_Uv,'enable','on');
        set(handles.edit_Uv,'enable','on');
    end
    
elseif evalin('base','mcr_als.alsOptions.multi.scons')==0
    
    if nsmod == dim
        form_spsmod=ones(1,dim);
        spsmod(curr_smat,:)=form_spsmod;
        set(handles.text_Uv,'enable','off');
        set(handles.edit_Uv,'enable','off','string','');
    elseif  nsmod == 0
        form_spsmod=zeros(1,dim);
        spsmod(curr_smat,:)=form_spsmod;
        set(handles.text_Uv,'enable','off');
        set(handles.edit_Uv,'enable','off','string','');
    elseif  nsmod == -1
        evalin('base','mcr_als.alsOptions.unimodS.spsmod=[]');
        set(handles.text_Uv,'enable','off');
        set(handles.edit_Uv,'enable','off','string','');
    else
        evalin('base','mcr_als.alsOptions.unimodS.spsmod=[];');
        set(handles.text_Uv,'enable','on');
        set(handles.edit_Uv,'enable','on');
    end
    
    evalin('base','mcr_als.alsOptions.unimodS.treated(curr_smat,1)=1;');
    evalin('base','mcr_als.alsOptions.unimodS.treated(curr_smat,2)=nsmod;');
    
end

assignin('base','spsmod',spsmod);
evalin('base','mcr_als.alsOptions.unimodS.spsmod=spsmod;');
evalin('base','clear spsmod');



% --- Executes during object creation, after setting all properties.
function edit_Uv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Uv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Uv as text
%        str2double(get(hObject,'String')) returns contents of edit_Uv as a double

form_spsmod= str2num(get(hObject,'String'));
matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
spsmod=evalin('base','mcr_als.alsOptions.unimodS.spsmod');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    for i=1:matr;
        spsmod(i,:)=form_spsmod;
    end
elseif evalin('base','mcr_als.alsOptions.multi.scons')==0
    spsmod(curr_smat,:)=form_spsmod;
end

assignin('base','spsmod',spsmod);
evalin('base','mcr_als.alsOptions.unimodS.spsmod=spsmod;');
evalin('base','clear spsmod');


% --- Executes during object creation, after setting all properties.
function edit_Utol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Utol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Utol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Utol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Utol as text
%        str2double(get(hObject,'String')) returns contents of edit_Utol as a double

smod= str2num(get(hObject,'String'));

if smod==1,
    smod=1.0001;
end

assignin('base','smod',smod);
evalin('base','mcr_als.alsOptions.unimodS.smod=smod;');
evalin('base','clear smod');


% Closure
% *********************************************************************

% --- Executes on button press in check_closC.
function check_closC_Callback(hObject, eventdata, handles)
% hObject    handle to check_closC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_closC

closure=get(hObject,'Value');

if closure==1;
    
    set(handles.text_Cnr,'enable','on');
    set(handles.popup_Cnr,'enable','on','value',1);
    
    closX='Spectra';
    assignin('base','closX',closX);
    evalin('base','mcr_als.alsOptions.closure.type=closX;');
    evalin('base','clear closX');
    
    assignin('base','dc',2);
    evalin('base','mcr_als.alsOptions.closure.dc=dc;');
    
    dim=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    assignin('base','dim',dim);
    matr=evalin('base','mcr_als.alsOptions.multi.matr');
    assignin('base','matr',matr);
    evalin('base','mcr_als.alsOptions.closure.tclos1(1:matr)=zeros(1,matr);');
    evalin('base','mcr_als.alsOptions.closure.tclos2(1:matr)=zeros(1,matr);');
    evalin('base','mcr_als.alsOptions.closure.sclos1(1:matr,1:dim)=zeros(matr,dim);');
    evalin('base','mcr_als.alsOptions.closure.sclos2(1:matr,1:dim)=zeros(matr,dim);');
    evalin('base','mcr_als.alsOptions.closure.iclos(1:matr)=zeros(1,matr);');
    evalin('base','mcr_als.alsOptions.closure.iclos1(1:matr)=zeros(1,matr);');
    evalin('base','mcr_als.alsOptions.closure.iclos2(1:matr)=zeros(1,matr);');
    evalin('base','mcr_als.alsOptions.closure.vclos1(1:matr)=zeros(1,matr);');
    evalin('base','mcr_als.alsOptions.closure.vclos2(1:matr)=zeros(1,matr);');
    
    
    evalin('base','mcr_als.alsOptions.closure.treated=zeros(matr,8);'); % treated/nr closures/valor 1/condition1 /nr species 1/valor 2/condition 2/ nr species 2
    
    evalin('base','clear dc dim matr');
    
else
    
    set(handles.text_Cnr,'enable','off');
    set(handles.popup_Cnr,'enable','off','value',1);
    set(handles.check_Cvar,'enable','off','value',0);
    
    set(handles.text_C1,'enable','off');
    set(handles.text_C1v,'enable','off');
    set(handles.text_C1c,'enable','off');
    set(handles.text_C1sp,'enable','off');
    set(handles.check_C1sp,'enable','off','value',0);
    set(handles.popup_C1c,'enable','off','value',1);
    set(handles.edit_C1,'enable','off','string',' ');
    set(handles.edit_C1v,'enable','off','string',' ');
    set(handles.edit_C1sp,'enable','off','string',' ');
    
    set(handles.text_C2,'enable','off');
    set(handles.text_C2v,'enable','off');
    set(handles.text_C2c,'enable','off');
    set(handles.text_C2sp,'enable','off');
    set(handles.check_C2sp,'enable','off','value',0);
    set(handles.popup_C2c,'enable','off','value',1);
    set(handles.edit_C2,'enable','off','string',' ');
    set(handles.edit_C2v,'enable','off','string',' ');
    set(handles.edit_C2sp,'enable','off','string',' ');
    
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''closure'');');
    
    closX='None';
    assignin('base','closX',closX);
    evalin('base','mcr_als.alsOptions.closure.type=closX;');
    evalin('base','clear closX');
end;

assignin('base','closure',closure);
evalin('base','mcr_als.alsOptions.closure.closure=closure;');
evalin('base','clear closure');

vc=0;
assignin('base','vc',vc);
evalin('base','mcr_als.alsOptions.closure.vc=vc;');
evalin('base','clear vc');


% --- Executes during object creation, after setting all properties.
function popup_Cnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_Cnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'0'};
llista(3)={'1'};
llista(4)={'2'};
set(hObject,'string',llista)

% --- Executes on selection change in popup_Cnr.
function popup_Cnr_Callback(hObject, eventdata, handles)
% hObject    handle to popup_Cnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_Cnr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_Cnr

form_iclos=get(hObject,'Value')-2;

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);

if form_iclos == 1;
    set(handles.check_Cvar,'enable','on','value',0);
    
    set(handles.text_C1,'enable','on');
    set(handles.edit_C1,'enable','on');
    set(handles.text_C1c,'enable','on');
    set(handles.popup_C1c,'enable','on','value',1);
    set(handles.text_C1sp,'enable','on');
    set(handles.edit_C1sp,'enable','on');
    set(handles.check_C1sp,'enable','on','value',0);
    set(handles.text_C1v,'enable','off');
    set(handles.edit_C1v,'enable','off','string',' ');
    
    set(handles.text_C2,'enable','off');
    set(handles.edit_C2,'enable','off','string',' ');
    set(handles.text_C2c,'enable','off');
    set(handles.popup_C2c,'enable','off','value',1);
    set(handles.text_C2sp,'enable','off');
    set(handles.edit_C2sp,'enable','off','string',' ');
    set(handles.check_C2sp,'enable','off','value',0);
    set(handles.text_C2v,'enable','off');
    set(handles.edit_C2v,'enable','off','string',' ');
    
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,1)=1;');
    
elseif  form_iclos==2
    warndlg('Warning: there should not be common species to the two closures','WARNING!!');
    
    set(handles.check_Cvar,'enable','on','value',0);
    
    set(handles.text_C1,'enable','on');
    set(handles.edit_C1,'enable','on');
    set(handles.text_C1c,'enable','on');
    set(handles.popup_C1c,'enable','on','value',1);
    set(handles.text_C1sp,'enable','on');
    set(handles.edit_C1sp,'enable','on');
    set(handles.check_C1sp,'enable','on','value',0);
    set(handles.text_C1v,'enable','off');
    set(handles.edit_C1v,'enable','off','string',' ');
    
    set(handles.text_C2,'enable','on');
    set(handles.edit_C2,'enable','on');
    set(handles.text_C2c,'enable','on');
    set(handles.popup_C2c,'enable','on','value',1);
    set(handles.text_C2sp,'enable','on');
    set(handles.edit_C2sp,'enable','on');
    set(handles.check_C2sp,'enable','on','value',0);
    set(handles.text_C2v,'enable','off');
    set(handles.edit_C2v,'enable','off','string',' ');
    
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,1)=1;');
    
elseif form_iclos == 0;
    set(handles.check_Cvar,'enable','off','value',0);
    
    set(handles.text_C1,'enable','off');
    set(handles.edit_C1,'enable','off');
    set(handles.text_C1c,'enable','off');
    set(handles.popup_C1c,'enable','off','value',1);
    set(handles.text_C1sp,'enable','off');
    set(handles.edit_C1sp,'enable','off');
    set(handles.check_C1sp,'enable','off','value',0);
    set(handles.text_C1v,'enable','off');
    set(handles.edit_C1v,'enable','off','string',' ');
    
    set(handles.text_C2,'enable','off');
    set(handles.edit_C2,'enable','off');
    set(handles.text_C2c,'enable','off');
    set(handles.popup_C2c,'enable','off','value',1);
    set(handles.text_C2sp,'enable','off');
    set(handles.edit_C2sp,'enable','off');
    set(handles.check_C2sp,'enable','off','value',0);
    set(handles.text_C2v,'enable','off');
    set(handles.edit_C2v,'enable','off','string',' ');
    
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,1)=1;');
    
else
    set(handles.check_Cvar,'enable','off','value',0);
    
    set(handles.text_C1,'enable','off');
    set(handles.edit_C1,'enable','off');
    set(handles.text_C1c,'enable','off');
    set(handles.popup_C1c,'enable','off','value',1);
    set(handles.text_C1sp,'enable','off');
    set(handles.edit_C1sp,'enable','off');
    set(handles.check_C1sp,'enable','off','value',0);
    set(handles.text_C1v,'enable','off');
    set(handles.edit_C1v,'enable','off','string',' ');
    
    set(handles.text_C2,'enable','off');
    set(handles.edit_C2,'enable','off');
    set(handles.text_C2c,'enable','off');
    set(handles.popup_C2c,'enable','off','value',1);
    set(handles.text_C2sp,'enable','off');
    set(handles.edit_C2sp,'enable','off');
    set(handles.check_C2sp,'enable','off','value',0);
    set(handles.text_C2v,'enable','off');
    set(handles.edit_C2v,'enable','off','string',' ');
    
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,1)=0;');
end

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
iclos=evalin('base','mcr_als.alsOptions.closure.iclos');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        iclos(1,[1:matr])=form_iclos;
    end
    
else
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        iclos(1,curr_smat)=form_iclos;
    end
    
end

assignin('base','iclos',iclos);
evalin('base','mcr_als.alsOptions.closure.iclos=iclos;');

assignin('base','form_iclos',form_iclos);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,2)=form_iclos;');
evalin('base','clear iclos matr curr_smat');



% --- Executes during object creation, after setting all properties.
function edit_C1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_C1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C1 as text
%        str2double(get(hObject,'String')) returns contents of edit_C1 as a double


form_tclos1= str2num(get(hObject,'String'));

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);
tclos1=evalin('base','mcr_als.alsOptions.closure.tclos1');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        tclos1(1,[1:matr])=form_tclos1;
    end
else
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        tclos1(1,curr_smat)=form_tclos1;
        
    end
end

assignin('base','tclos1',tclos1);
evalin('base','mcr_als.alsOptions.closure.tclos1=tclos1;');
assignin('base','form_tclos1',form_tclos1);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,3)=form_tclos1;');
evalin('base','clear tclos1 matr curr_smat form_tclos1');



% --- Executes during object creation, after setting all properties.
function popup_C1c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_C1c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'equal than'};
llista(3)={'least-squares closure'};
llista(4)={'lower or equal than'};
set(hObject,'string',llista)

% --- Executes on selection change in popup_C1c.
function popup_C1c_Callback(hObject, eventdata, handles)
% hObject    handle to popup_C1c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_C1c contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_C1c

form_iclos1=get(hObject,'Value')-1;

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);

iclos1=evalin('base','mcr_als.alsOptions.closure.iclos1');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        iclos1(1,[1:matr])=form_iclos1;
    end
else
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        iclos1(1,curr_smat)=form_iclos1;
    end
end

assignin('base','iclos1',iclos1);
evalin('base','mcr_als.alsOptions.closure.iclos1=iclos1;');
assignin('base','form_iclos1',form_iclos1);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,4)=form_iclos1;');
evalin('base','clear iclos1 matr curr_smat form_iclos1');

% --- Executes on button press in check_C1sp.
function check_C1sp_Callback(hObject, eventdata, handles)
% hObject    handle to check_C1sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_C1sp

check1clos=get(hObject,'Value');

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);

if check1clos==0
    set(handles.text_C1sp,'enable','on');
    set(handles.edit_C1sp,'enable','on','string',' ');
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    ceros=zeros(1,nsign);
    sclos1=evalin('base','mcr_als.alsOptions.closure.sclos1');
    
    if evalin('base','mcr_als.alsOptions.multi.scons')==1
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            for i=1:matr;
                sclos1(i,:)=ceros;
            end
        end
    else
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            sclos1(curr_smat,:)=ceros;
        end
    end
    
    assignin('base','sclos1',sclos1);
    evalin('base','mcr_als.alsOptions.closure.sclos1=sclos1;');
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,5)=0;');
    evalin('base','clear sclos1 matr curr_smat');
    
    
elseif check1clos==1
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    unos=ones(1,nsign);
    set(handles.text_C1sp,'enable','on');
    set(handles.edit_C1sp,'enable','inactive','string',num2str(unos));
    
    sclos1=evalin('base','mcr_als.alsOptions.closure.sclos1');
    
    if evalin('base','mcr_als.alsOptions.multi.scons')==1
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            for i=1:matr;
                sclos1(i,:)=unos;
            end
        end
    else
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            sclos1(curr_smat,:)=unos;
        end
    end
    
    assignin('base','sclos1',sclos1);
    evalin('base','mcr_als.alsOptions.closure.sclos1=sclos1;');
    suma_sp=sum(sclos1(curr_smat,:));
    assignin('base','suma_sp',suma_sp);
    
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,5)=suma_sp;');
    
    evalin('base','clear sclos1 matr curr_smat suma_sp');
    
end


% --- Executes during object creation, after setting all properties.
function edit_C1sp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C1sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_C1sp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C1sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C1sp as text
%        str2double(get(hObject,'String')) returns contents of edit_C1sp as a double

form_sclos1= str2num(get(hObject,'String'));

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);
sclos1=evalin('base','mcr_als.alsOptions.closure.sclos1');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        for i=1:matr;
            sclos1(i,:)=form_sclos1;
        end
    end
else
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        sclos1(curr_smat,:)=form_sclos1;
    end
end

assignin('base','sclos1',sclos1);
evalin('base','mcr_als.alsOptions.closure.sclos1=sclos1;');
suma_sp=sum(form_sclos1);
assignin('base','suma_sp',suma_sp);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,5)=suma_sp;');

evalin('base','clear sclos1 matr curr_smat suma_sp');


% --- Executes during object creation, after setting all properties.
function edit_C2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_C2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C2 as text
%        str2double(get(hObject,'String')) returns contents of edit_C2 as a double

form_tclos2= str2num(get(hObject,'String'));

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);

tclos2=evalin('base','mcr_als.alsOptions.closure.tclos2');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        tclos2(1,[1:matr])=form_tclos2;
    end
    
else
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        tclos2(1,curr_smat)=form_tclos2;
    end
    
end

assignin('base','tclos2',tclos2);
evalin('base','mcr_als.alsOptions.closure.tclos2=tclos2;');

assignin('base','form_tclos2',form_tclos2);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,6)=form_tclos2;');

evalin('base','clear tclos2 matr curr_smat form_tclos2');


% --- Executes during object creation, after setting all properties.
function popup_C2c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_C2c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'equal than'};
llista(3)={'least-squares closure'};
llista(4)={'lower or equal than'};
set(hObject,'string',llista)


% --- Executes on selection change in popup_C2c.
function popup_C2c_Callback(hObject, eventdata, handles)
% hObject    handle to popup_C2c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_C2c contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_C2c


form_iclos2=get(hObject,'Value')-1;

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);
iclos2=evalin('base','mcr_als.alsOptions.closure.iclos1');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        iclos2(1,[1:matr])=form_iclos2;
    end
else
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        iclos2(1,curr_smat)=form_iclos2;
    end
end

assignin('base','iclos2',iclos2);
evalin('base','mcr_als.alsOptions.closure.iclos2=iclos2;');
assignin('base','form_iclos2',form_iclos2);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,7)=form_iclos2;');
evalin('base','clear iclos2 matr curr_smat form_iclos2');

% --- Executes on button press in check_C2sp.
function check_C2sp_Callback(hObject, eventdata, handles)
% hObject    handle to check_C2sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_C2sp

check2clos=get(hObject,'Value');

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);

if check2clos==0
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    ceros=zeros(1,nsign);
    set(handles.text_C2sp,'enable','on');
    set(handles.edit_C2sp,'enable','on','string',' ');
    
    sclos2=evalin('base','mcr_als.alsOptions.closure.sclos2');
    
    if evalin('base','mcr_als.alsOptions.multi.scons')==1
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            for i=1:matr;
                sclos2(i,:)=ceros;
            end
        end
    else
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            sclos2(curr_smat,:)=ceros;
        end
    end
    
    assignin('base','sclos2',sclos2);
    evalin('base','mcr_als.alsOptions.closure.sclos1=sclos2;');
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,8)=0')
    evalin('base','clear sclos2 matr curr_smat');
    
elseif check2clos==1
    nsign=evalin('base','min(size(mcr_als.alsOptions.iniesta))');
    unos=ones(1,nsign);
    set(handles.text_C2sp,'enable','on');
    set(handles.edit_C2sp,'enable','inactive','string',num2str(unos));
    
    sclos2=evalin('base','mcr_als.alsOptions.closure.sclos2');
    
    if evalin('base','mcr_als.alsOptions.multi.scons')==1
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            for i=1:matr;
                sclos2(i,:)=unos;
            end
        end
    else
        if evalin('base','mcr_als.alsOptions.closure.dc')==2
            sclos2(curr_smat,:)=unos;
        end
    end
    
    assignin('base','sclos2',sclos2);
    evalin('base','mcr_als.alsOptions.closure.sclos2=sclos2;');
    suma_sp=sum(sclos2(curr_smat,:));
    assignin('base','suma_sp',suma_sp);
    evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,8)=suma_sp;');
    
    evalin('base','clear sclos2 matr curr_smat suma_sp');
    
end


% --- Executes during object creation, after setting all properties.
function edit_C2sp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C2sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_C2sp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C2sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C2sp as text
%        str2double(get(hObject,'String')) returns contents of edit_C2sp as a double


form_sclos2= str2num(get(hObject,'String'));

matr=evalin('base','mcr_als.alsOptionst.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
assignin('base','matr',matr);
assignin('base','curr_smat',curr_smat);
sclos2=evalin('base','mcr_als.alsOptions.closure.sclos2');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        for i=1:matr;
            sclos2(i,:)=form_sclos2;
        end
    end
    
else
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        sclos2(curr_smat,:)=form_sclos2;
    end
end

assignin('base','sclos2',sclos2);
evalin('base','mcr_als.alsOptions.closure.sclos2=sclos2;');

suma_sp=sum(form_sclos2);
assignin('base','suma_sp',suma_sp);
evalin('base','mcr_als.alsOptions.closure.treated(curr_smat,8)=suma_sp;');

evalin('base','clear sclos2 matr curr_smat form_sclos2');


% vclos
% oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

% --- Executes on button press in check_Cvar.
function check_Cvar_Callback(hObject, eventdata, handles)
% hObject    handle to check_Cvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_Cvar


vclos=get(hObject,'Value');

if vclos==1;
    iclos=evalin('base','mcr_als.alsOptions.closure.iclos');
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==1;
        activa=evalin('base','mcr_als.alsOptions.multi.curr_cmat');
    elseif evalin('base','mcr_als.alsOptions.closure.dc')==2;
        activa=evalin('base','mcr_als.alsOptions.multi.curr_smat');
    end
    
    if iclos(activa)==1
        set(handles.text_C1v,'enable','on');
        set(handles.edit_C1v,'enable','on','string',' ');
        set(handles.text_C2v,'enable','off');
        set(handles.edit_C2v,'enable','off','string',' ');
        set(handles.text_C1,'enable','off');
        set(handles.edit_C1,'enable','off','string',' ');
        set(handles.text_C2,'enable','off');
        set(handles.edit_C2,'enable','off','string',' ');
        set(handles.text_C1c,'enable','off');
        set(handles.popup_C1c,'enable','off','value',1);
        set(handles.text_C2c,'enable','off');
        set(handles.popup_C2c,'enable','off','value',1);
        set(handles.text_C1sp,'enable','on');
        set(handles.edit_C1sp,'enable','on','value',1);
        set(handles.text_C2sp,'enable','off');
        set(handles.edit_C2sp,'enable','off','value',1);
        
        iclos1=1; % equal
        assignin('base','iclos1',iclos1);
        evalin('base','mcr_als.alsOptions.closure.iclos1=iclos1;');
        evalin('base','clear iclos1');
        
        vc=1; % equal
        assignin('base','vc',vc);
        evalin('base','mcr_als.alsOptions.closure.vc=vc;');
        evalin('base','clear vc');
        
    elseif iclos(activa)==2
        set(handles.text_C1v,'enable','on');
        set(handles.edit_C1v,'enable','on','string',' ');
        set(handles.text_C2v,'enable','on');
        set(handles.edit_C2v,'enable','on','string',' ');
        set(handles.text_C1,'enable','off');
        set(handles.edit_C1,'enable','off','string',' ');
        set(handles.text_C2,'enable','off');
        set(handles.edit_C2,'enable','off','string',' ');
        set(handles.text_C1c,'enable','off');
        set(handles.popup_C1c,'enable','off','value',1);
        set(handles.text_C2c,'enable','off');
        set(handles.popup_C2c,'enable','off','value',1);
        set(handles.text_C1sp,'enable','on');
        set(handles.edit_C1sp,'enable','on','value',1);
        set(handles.text_C2sp,'enable','on');
        set(handles.edit_C2sp,'enable','on','value',1);
        
        iclos1=1; % equal
        assignin('base','iclos1',iclos1);
        evalin('base','mcr_als.alsOptions.closure.iclos1=iclos1;');
        evalin('base','clear iclos1');
        
        iclos2=1; % equal
        assignin('base','iclos2',iclos2);
        evalin('base','mcr_als.alsOptions.closure.iclos2=iclos2;');
        evalin('base','clear iclos2');
        
        vc=1; % equal
        assignin('base','vc',vc);
        evalin('base','mcr_als.alsOptions.closure.vc=vc;');
        evalin('base','clear vc');
        
    end
    
else
    set(handles.text_C1v,'enable','off');
    set(handles.edit_C1v,'enable','off','string',' ');
    set(handles.text_C2v,'enable','off');
    set(handles.edit_C2v,'enable','off','string',' ');
    set(handles.text_Cnr,'enable','on');
    set(handles.popup_Cnr,'enable','on','value',1);
    set(handles.text_C1,'enable','off');
    set(handles.edit_C1,'enable','off','string',' ');
    set(handles.text_C2,'enable','off');
    set(handles.edit_C2,'enable','off','string',' ');
    set(handles.text_C1c,'enable','off');
    set(handles.popup_C1c,'enable','off','value',1);
    set(handles.text_C2c,'enable','off');
    set(handles.popup_C2c,'enable','off','value',1);
    set(handles.text_C1sp,'enable','off');
    set(handles.edit_C1sp,'enable','off','string',' ');
    set(handles.text_C2sp,'enable','off');
    set(handles.edit_C2sp,'enable','off','string',' ');
    
    vc=0; % equal
    assignin('base','vc',vc);
    evalin('base','mcr_als.alsOptions.closure.vc=vc;');
    evalin('base','clear vc');
end;


% --- Executes during object creation, after setting all properties.
function edit_C1v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C1v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_C1v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C1v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C1v as text
%        str2double(get(hObject,'String')) returns contents of edit_C1v as a double


vclos1=get(hObject,'String');
form_vclos1=evalin('base',vclos1);

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
vclos1=evalin('base','mcr_als.alsOptions.closure.vclos1');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        vclos1([1:matr],1)=form_vclos1;
    end
    
else
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        vclos1(curr_smat,1)=form_vclos1;
    end
    
end

assignin('base','vclos1',vclos1);
evalin('base','mcr_als.alsOptions.closure.vclos1=vclos1;');
evalin('base','clear vclos1 matr curr_smat');

% --- Executes during object creation, after setting all properties.
function edit_C2v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_C2v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C2v as text
%        str2double(get(hObject,'String')) returns contents of edit_C2v as a double


vclos2=get(hObject,'String');
form_vclos2=evalin('base',vclos2);

matr=evalin('base','mcr_als.alsOptions.multi.matr');
curr_smat=evalin('base','mcr_als.alsOptions.multi.curr_smat');
vclos2=evalin('base','mcr_als.alsOptions.closure.vclos2');

if evalin('base','mcr_als.alsOptions.multi.scons')==1
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        vclos2([1:matr],1)=form_vclos2;
    end
    
else
    
    if evalin('base','mcr_als.alsOptions.closure.dc')==2
        vclos2(curr_smat,1)=form_vclos2;
    end
    
end

assignin('base','vclos2',vclos2);
evalin('base','mcr_als.alsOptions.closure.vclos2=vclos2;');
evalin('base','clear vclos2 matr curr_smat');


% Equality
% *********************************************************************

% --- Executes on button press in check_eqC.
function check_eqC_Callback(hObject, eventdata, handles)
% hObject    handle to check_eqC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_eqC

sselcon=get(hObject,'Value');

if sselcon==1;
    set(handles.text_eqCs,'enable','on');
    set(handles.popup_eqCs,'enable','on','value',1);
    set(handles.text_eqCc,'enable','on');
    set(handles.popup_eqCc,'enable','on','value',1);
    
    
else
    set(handles.text_eqCs,'enable','off');
    set(handles.popup_eqCs,'enable','off','value',1);
    set(handles.text_eqCc,'enable','off');
    set(handles.popup_eqCc,'enable','off','value',1);
    
    evalin('base','mcr_als.alsOptions=rmfield(mcr_als.alsOptions,''sselcS'');');
    
end;
assignin('base','sselcon',sselcon);
evalin('base','mcr_als.alsOptions.sselcS.sselcon=sselcon;');
evalin('base','clear sselcon');


% --- Executes during object creation, after setting all properties.
function popup_eqCs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_eqCs (see GCBO)
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

% --- Executes on selection change in popup_eqCs.
function popup_eqCs_Callback(hObject, eventdata, handles)
% hObject    handle to popup_eqCs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_eqCs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_eqCs

popmenu3=get(handles.popup_eqCs,'String');
pm3=get(handles.popup_eqCs,'Value');

if pm3==1
    
else
    selssel_char=char([popmenu3(pm3)]);
    selssel=evalin('base',selssel_char);
    jjsel=find(isfinite(selssel));
    
    assignin('base','selssel',selssel);
    assignin('base','jjsel',jjsel);
    assignin('base','selssel_char',selssel_char);
    
    evalin('base','mcr_als.alsOptions.sselcS.jjsel=jjsel;');
    evalin('base','mcr_als.alsOptions.sselcS.ssel=selssel;');
    evalin('base','mcr_als.alsOptions.sselcS.selssel_char=selssel_char;');
    
    evalin('base','clear selssel jjsel selssel_char');
    
end


% --- Executes during object creation, after setting all properties.
function popup_eqCc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_eqCc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

llista(1)={'select...'};
llista(2)={'equal than'};
llista(3)={'lower or equal than'};
set(hObject,'string',llista)

% --- Executes on selection change in popup_eqCc.
function popup_eqCc_Callback(hObject, eventdata, handles)
% hObject    handle to popup_eqCc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_eqCc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_eqCc

type_ssel=get(hObject,'Value')-2;
assignin('base','type_ssel',type_ssel);
evalin('base','mcr_als.alsOptions.sselcS.type_ssel=type_ssel;');
evalin('base','clear type_ssel');


% Continue
% *********************************************************************

% --- Executes on button press in push_continue.
function push_continue_Callback(hObject, eventdata, handles)
% hObject    handle to push_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;

if evalin('base','mcr_als.alsOptions.closure.closure')==0;
    if evalin('base','mcr_als.alsOptions.correlation.checkSNorm')==0;
        closure_no;
    else
        als_parameters;
    end
else
    als_parameters;
end



% Reset
% *********************************************************************


% --- Executes on button press in push_reset.
function push_reset_Callback(hObject, eventdata, handles)
% hObject    handle to push_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

columnMultiConstraints;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_back.
function push_back_Callback(hObject, eventdata, handles)
% hObject    handle to push_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
if evalin('base','mcr_als.alsOptions.multi.datamod')==2
    rowModeConstraints;
elseif evalin('base','mcr_als.alsOptions.multi.datamod')==3
    rowMultiConstraints;
end
