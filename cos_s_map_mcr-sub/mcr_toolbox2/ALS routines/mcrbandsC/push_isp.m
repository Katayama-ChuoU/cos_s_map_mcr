function varargout = push_isp(varargin)
% PUSH_ISP M-file for push_isp.fig
%      PUSH_ISP, by itself, creates a new PUSH_ISP or raises the existing
%      singleton*.
%
%      H = PUSH_ISP returns the handle to a new PUSH_ISP or the handle to
%      the existing singleton*.
%
%      PUSH_ISP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUSH_ISP.M with the given input arguments.
%
%      PUSH_ISP('Property','Value',...) creates a new PUSH_ISP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before push_isp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to push_isp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help push_isp

% Last Modified by GUIDE v2.5 11-Oct-2010 13:39:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @push_isp_OpeningFcn, ...
                   'gui_OutputFcn',  @push_isp_OutputFcn, ...
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


% --- Executes just before push_isp is made visible.
function push_isp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to push_isp (see VARARGIN)

% Choose default command line output for push_isp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes push_isp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = push_isp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function popup_ispm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_ispm (see GCBO)
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


% --- Executes during object creation, after setting all properties.
function popup_ispvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_ispvar (see GCBO)
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
lsv(1)={'select a variable'};
lsv(2)={'write in the editable box'}; 
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


% --- Executes on button press in checkbox_num.
function checkbox_num_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

equalrows=get(hObject,'Value');
assignin('base','equalrows',equalrows);

if equalrows==1;
    [nrtotal,nspecies]=evalin('base','size(mcr_bands.Data.conc);');
    [nrexperiments,nspecies]=evalin('base','size(mcr_bands.Optional.Cequality.ispm);');
    Nrrows=nrtotal/nrexperiments;
    assignin('base','Nrrows',Nrrows);
    assignin('base','NrRowsXMat',ones(1,nrexperiments)*Nrrows);
    evalin('base','mcr_bands.Optional.Cequality.Nrrows=Nrrows;');
    evalin('base','mcr_bands.Optional.Cequality.NrRowsXMat=NrRowsXMat;');
    set(handles.popup_ispvar,'enable','off');
    set(handles.push_OK,'enable','on');
    evalin('base','clear Nrrows NrRowsXMat');
else
    evalin('base','mcr_bands.Optional.NrRows=[];');
    set(handles.popup_ispvar,'enable','on');
    set(handles.push_OK,'enable','off');
    end;
evalin('base','clear equalrows ');



% --- Executes on selection change in popup_ispm.
function popup_ispm_Callback(hObject, eventdata, handles)
% hObject    handle to popup_ispm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_ispm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_ispm

popUp=get(handles.popup_ispm,'String');
pU=get(handles.popup_ispm,'Value');

if pU==1
    evalin('base','mcr_bands.Optional.Cequality.ispm=[];');
else
    sel=char([popUp(pU)]);
    ispm=evalin('base',sel);
    assignin('base','ispm',ispm);
    evalin('base','mcr_bands.Optional.Cequality.ispm=ispm;');
    evalin('base','clear ispm');
    
    set(handles.checkbox_num,'enable','on','value',0);
    set(handles.popup_ispvar,'enable','on');
    set(handles.push_OK,'enable','off');
end


% Hint: get(hObject,'Value') returns toggle state of checkbox_num
% --- Executes on selection change in popup_ispvar.
function popup_ispvar_Callback(hObject, eventdata, handles)
% hObject    handle to popup_ispvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_ispvar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_ispvar

popUp=get(handles.popup_ispvar,'String');
pU=get(handles.popup_ispvar,'Value');

if pU==1
    evalin('base','mcr_bands.Optional.Cequality.ispvar=[];');
    set(handles.edit_ispvar,'enable','off');
elseif pU==2
    set(handles.edit_ispvar,'enable','on','string','  ');
else
    set(handles.edit_ispvar,'enable','off');
    sel=char([popUp(pU)]);
    ispm=evalin('base',sel);
    assignin('base','ispm',ispm);
    evalin('base','mcr_bands.Optional.Cequality.ispvar=ispvar;');
    evalin('base','mcr_bands.Optional.Cequality.NrRowsXMat=ispvar;');
    evalin('base','clear ispvar');
    set(handles.push_OK,'enable','on');   
end


function edit_ispvar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ispvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ispvar as text
%        str2double(get(hObject,'String')) returns contents of edit_ispvar as a double

valors=str2num(get(hObject,'String'));
assignin('base','valors',valors);
evalin('base','mcr_bands.Optional.Cequality.NrRowsXMat=valors;');
evalin('base','clear valors');
set(handles.push_OK,'enable','on');   

% --- Executes during object creation, after setting all properties.
function edit_ispvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ispvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in push_back.
function push_back_Callback(hObject, eventdata, handles)
% hObject    handle to push_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_bands.Optional=rmfield(mcr_bands.Optional,''Cequality'');');
evalin('base','mcr_bands.Optional.Cequality.cknown=[];'); %defaut
close;

% --- Executes on button press in push_OK.
function push_OK_Callback(hObject, eventdata, handles)
% hObject    handle to push_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



    [nrtotal,nspecies]=evalin('base','size(mcr_bands.Data.conc);');
    [nrexperiments,nspecies]=evalin('base','size(mcr_bands.Optional.Cequality.ispm);');
    NrRowsXMat=evalin('base','mcr_bands.Optional.Cequality.NrRowsXMat;');
     
    files=[0,cumsum(NrRowsXMat)];
    nrexp=nrexperiments;
    ispmat=evalin('base','mcr_bands.Optional.Cequality.ispm;');
    csel=1./zeros(nrtotal,nspecies);    
    
    for j=1:nrtotal
       
        for k=1:nspecies   
          for test=1:nrexp;
           if (j>files(test))
               numexp=test;
           end                       
        end
                   
        valor=ispmat(numexp,k);
        
        if valor==1
         elseif valor == 0
            csel(j,k)=0;
        end                     
   end 

    end
    
    assignin('base','csel',csel);
    evalin('base','mcr_bands.Optional.Cequality.cknown=csel;');
    evalin('base','clear csel');
    set(handles.push_print,'enable','on','backgroundcolor',[0 0.5 0]);
    set(handles.push_cont,'enable','on');

% --- Executes on button press in push_print.
function push_print_Callback(hObject, eventdata, handles)
% hObject    handle to push_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view_csel;
%disp(evalin('base','mcr_bands.Optional.Cequality.cknown'));


% --- Executes on button press in push_cont.
function push_cont_Callback(hObject, eventdata, handles)
% hObject    handle to push_cont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
