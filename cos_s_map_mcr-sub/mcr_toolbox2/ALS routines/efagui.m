function varargout = efagui(varargin)
% EFAGUI M-file for efagui.fig
%      EFAGUI, by itself, creates a new EFAGUI or raises the existing
%      singleton*.
%
%      H = EFAGUI returns the handle to a new EFAGUI or the handle to
%      the existing singleton*.
%
%      EFAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EFAGUI.M with the given input arguments.
%
%      EFAGUI('Property','Value',...) creates a new EFAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before efagui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to efagui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help efagui

% Last Modified by GUIDE v2.5 06-Feb-2008 12:49:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @efagui_OpeningFcn, ...
                   'gui_OutputFcn',  @efagui_OutputFcn, ...
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


% --- Executes just before efagui is made visible.
function efagui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to efagui (see VARARGIN)

% Choose default command line output for efagui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes efagui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = efagui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% *************************************************************************
% Actions
% *************************************************************************

% --- Executes on button press in push_go.
function push_go_Callback(hObject, eventdata, handles)
% hObject    handle to push_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

comptador=evalin('base','mcr_als.aux.counter;')+1;

   d=evalin('base','mcr_als.data;');
   [ns,nc]=size(d); % required?
   x=d(1:ns,:);
   [nsoln,nwave]=size(x);
   minn=min(nsoln,nwave);

if comptador==1; % first time. start analysis
   set(handles.text_start,'visible','off'); 

   % ****************
   % forward analysis
   % ****************
   
   n=2;
   
   while n<=nsoln
%         disp('processing row number: '),disp(n)
        svf=svd(x(1:n,:));
        l=svf.*svf;
        nl=size(l);

        ef(1:nl,n-1)=l(1:nl,1);
        efl(1:nl,n-1)=log10(l(1:nl,1));
        n=n+1;
   end
   ef=ef';
   efl=efl';
   eforward=ef;
    
   % set appropriately the zero log values
    minvalue=min(min(efl));
    minvalue=round(minvalue);
    [ns1,ns2]=size(efl);
    for i=1:ns1,
        for j=1:ns2,
            if efl(i,j)==0,
                efl(i,j)=minvalue;
            end
        end
    end

    xforward=[2:nsoln];

    axes(handles.axes_efa);
    plot(xforward,efl);
    title('Forward EFA');
    xlabel('Row number');
    ylabel('log(eigenvalues)');
    
    assignin('base','xforward',xforward);
    evalin('base','mcr_als.InitEstim.aux.xforward=xforward;');
    assignin('base','efl',efl);
    evalin('base','mcr_als.InitEstim.aux.efl=efl;');   
    assignin('base','ef',ef);
    evalin('base','mcr_als.InitEstim.ef=ef;');   
    evalin('base','clear xforward efl ef');
        
    evalin('base','mcr_als.aux.counter=1;');
end

if comptador==2; % 

    % *****************
    % backward analysis
    % *****************

%     disp('backward analysis')
    x=x(nsoln:-1:1,:);
    n=2;
    while n<=nsoln
%         disp('processing row number (backward): '),disp(n)
        svb=svd(x(1:n,:));
        nl=size(svb);
        l=svb.*svb;
        eb(1:nl,n-1)=l(1:nl,1);
        ebl(1:nl,n-1)=log10(l(1:nl,1));
        n=n+1;
    end
    eb=eb';
    ebl=ebl';
    ebackward=eb;

    % set appropriately the zero log values
    minvalue=min(min(ebl));
    minvalue=round(minvalue);
    [ns1,ns2]=size(ebl);
    for i=1:ns1,
        for j=1:ns2,
            if ebl(i,j)==0,
                ebl(i,j)=minvalue;
            end
        end
    end

    xbackward=[nsoln:-1:2];
    axes(handles.axes_efa);
    plot(xbackward,ebl)
    title('Backward EFA')
    xlabel('Row number')
    ylabel('log(eigenvalues)')

    assignin('base','xbackward',xbackward);
    evalin('base','mcr_als.InitEstim.aux.xbackward=xbackward;');
    assignin('base','ebl',ebl);
    evalin('base','mcr_als.InitEstim.aux.ebl=ebl;');   
 
    assignin('base','eb',eb);
    evalin('base','mcr_als.InitEstim.eb=eb;');  
    evalin('base','clear xbackward ebl eb');  
    evalin('base','mcr_als.aux.counter=2;');
end

if comptador==3; % 

       d=evalin('base','mcr_als.data;');
       [ns,nc]=size(d); % necessari?
       x=d(1:ns,:);
       [nsoln,nwave]=size(x);
       minn=min(nsoln,nwave);
    
       
    % ******************************
    % evolving factor analysis plots
    % ******************************

    % 1) plot the log(eigenvalues) and singular values

    xforward=evalin('base','mcr_als.InitEstim.aux.xforward;');
    xbackward=evalin('base','mcr_als.InitEstim.aux.xbackward;');
    efl=evalin('base','mcr_als.InitEstim.aux.efl;');
    ebl=evalin('base','mcr_als.InitEstim.aux.ebl;');
    
    xforward=[2:nsoln];
    xbackward=[nsoln:-1:2];
    
    axes(handles.axes_efa);
    plot(xforward,efl,'k',xbackward,ebl,'r')
    title('EVOLVING FACTOR ANALYSIS')
    xlabel('Row number')
    ylabel('log(eigenvalues)')
    
    evalin('base','mcr_als.aux.counter=3;');
end


if comptador==4; % 

% 2) rescaling the log of eigenvalues plot

    d=evalin('base','mcr_als.data;');
    [ns,nc]=size(d); 
    x=d(1:ns,:);
    [nsoln,nwave]=size(x);
    minn=min(nsoln,nwave);
    xforward=evalin('base','mcr_als.InitEstim.aux.xforward;');
    xbackward=evalin('base','mcr_als.InitEstim.aux.xbackward;');
    efl=evalin('base','mcr_als.InitEstim.aux.efl;');
    ebl=evalin('base','mcr_als.InitEstim.aux.ebl;');
    
    maxvalue=max(max(ebl));
    maxvalue=round(maxvalue+1);
    %minvalue=input(' min. value of log efa plots ? ');
    set(handles.text_minvalue,'visible','on','enable','on');
    set(handles.edit_minvalue,'visible','on','enable','on');
 
    set(handles.push_print,'enable','off');
    set(handles.push_copy,'enable','off');
    set(handles.push_canc,'enable','off');
    set(handles.push_go,'enable','off');
    evalin('base','mcr_als.aux.efamin=1;');
    
    while(evalin('base','mcr_als.aux.efamin')==1)
         pause(0.3);
    end
    set(handles.push_go,'enable','on');  
    set(handles.push_print,'enable','on');
    set(handles.push_copy,'enable','on');
    set(handles.push_canc,'enable','on');
    set(handles.text_minvalue,'visible','on','enable','inactive');
    set(handles.edit_minvalue,'visible','on','enable','inactive');
    minvalue=evalin('base','mcr_als.InitEstim.aux.EFAminvalue;');
    
    axes(handles.axes_efa);
    plot(xforward,efl,'k',xbackward,ebl,'r')
    axis([2 nsoln minvalue maxvalue])
    title('EVOLVING FACTOR ANALYSIS')
    xlabel('Row number')
    ylabel('log(eigenvalues)')
    evalin('base','mcr_als.aux.counter=4;');
    
end


if comptador==5; % 

    d=evalin('base','mcr_als.data;');
    [ns,nc]=size(d); 
    x=d(1:ns,:);
    [nsoln,nwave]=size(x);
    minn=min(nsoln,nwave);
    xforward=evalin('base','mcr_als.InitEstim.aux.xforward;');
    xbackward=evalin('base','mcr_als.InitEstim.aux.xbackward;');
    ef=evalin('base','mcr_als.InitEstim.ef;');
    eb=evalin('base','mcr_als.InitEstim.eb;');
    
    % 3) plot the arranged conc. profiles for the num. of factors

    nf=evalin('base','mcr_als.CompNumb.nc;');

    clear e;

        for j=1:nf
            jj=nf+1-j;
            for i=1:nsoln-1,
                ii=nsoln-i;
                if ef(i,j)<=eb(ii,jj),
                    e(i,j)=ef(i,j);
                else,
                    e(i,j)=eb(ii,jj);
                end
            if e(i,j)==0.0, e(i,j)=1.0e-30; end
            end
        end

        axes(handles.axes_efa);
        plot(xforward,e)
        title ('Initial estimates from EFA analysis')

    e(2:nsoln,:)=e(1:nsoln-1,:);
    assignin('base','e',e);
    evalin('base','mcr_als.InitEstim.iniesta=e;');  
    evalin('base','clear e'); 
    
    evalin('base','mcr_als.aux.counter=5;');
    set(handles.push_go,'enable','off');  
    set(handles.push_OK,'enable','on');
    
    
end


% --- Executes on button press in push_OK.
function push_OK_Callback(hObject, eventdata, handles)
% hObject    handle to push_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_als.aux.estat=2;');
evalin('base','mcr_als.InitEstim.method=''EFA'';');
close;

% --- Executes on button press in push_canc.
function push_canc_Callback(hObject, eventdata, handles)
% hObject    handle to push_canc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','mcr_als.aux.estat=3;');
evalin('base','mcr_als=rmfield(mcr_als,''InitEstim'');');
close;

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

print;


% *************************************************************************
% Minvalue
% *************************************************************************

% --- Executes during object creation, after setting all properties.
function edit_minvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minvalue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minvalue as text
%        str2double(get(hObject,'String')) returns contents of edit_minvalue as a double

EFAminvalue=str2num(get(hObject,'String'));

assignin('base','EFAminvalue',EFAminvalue);
evalin('base','mcr_als.InitEstim.aux.EFAminvalue=EFAminvalue;');
evalin('base','clear EFAminvalue');

evalin('base','mcr_als.aux.efamin=0;');

