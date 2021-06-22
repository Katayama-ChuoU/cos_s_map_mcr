function varargout = bilinear_info(varargin)
% BILINEAR_INFO MATLAB code for bilinear_info.fig
%      BILINEAR_INFO, by itself, creates a new BILINEAR_INFO or raises the existing
%      singleton*.
%
%      H = BILINEAR_INFO returns the handle to a new BILINEAR_INFO or the handle to
%      the existing singleton*.
%
%      BILINEAR_INFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BILINEAR_INFO.M with the given input arguments.
%
%      BILINEAR_INFO('Property','Value',...) creates a new BILINEAR_INFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bilinear_info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bilinear_info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bilinear_info

% Last Modified by GUIDE v2.5 14-Nov-2014 13:19:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bilinear_info_OpeningFcn, ...
                   'gui_OutputFcn',  @bilinear_info_OutputFcn, ...
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


% --- Executes just before bilinear_info is made visible.
function bilinear_info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bilinear_info (see VARARGIN)

% Choose default command line output for bilinear_info
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bilinear_info wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% trildir=evalin('base','mcr_als.alsOptions.trilin.trildir;');
% if trildir==1
    uaug=evalin('base','mcr_als.alsOptions.resultats.optim_concs;');
    vaug=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
    nmat=evalin('base','mcr_als.alsOptions.nexp;');
    d=evalin('base','mcr_als.alsOptions.matdad;');
% else
%     warndlg('no trilinear constraint applied');
% end


% [u1,u2,l,dc,dtc,dt]=umodeaug(copt,sopt,nmat,1,d);
% umodeaug

[nrt,ns]=size(uaug);
[ns,nc]=size(vaug);
nr=nrt/nmat;
u1=[];u2=[];l=[];a1=[];a2=[];st1=[];st2=[];

for i=1:nmat
    inicrow=(i-1)*nr+1;
    endrow=i*nr;
    dt(:,:,i)=d(inicrow:endrow,:);
end

for j=1:ns
    m=[];
    for i=1:nmat
        inicrow=(i-1)*nr+1;
        endrow=i*nr;
        m=[m,uaug(inicrow:endrow,j)];
    end
    [u,s,v]=svd(m);
    %log(s(1:4,1:4))
    %pause
    u1=[u1,u(:,1)*s(1,1)];
    u2=[u2,v(:,1)];
    if max(u1(:,j)<0) && max(u2(:,j)<0), u1(:,j)=-u1(:,j);u2(:,j)=-u2(:,j);end
    
    l1=[];for il=1:nmat,l1=[l1;s(il,il)];end
    l=[l,l1];
end

disp('check of trilineraity from svd of folded profiles: ');disp(l)

% Test lofbil (x,uaug,vaug)
disp(' ');disp('Test lof and R2 bilinear model')

for i=1:nrt
    for j=1:nc
        if isfinite(d(i,j))==1,
            dc(i,j)=0;
            for ls=1:ns
                dc(i,j)=dc(i,j)+uaug(i,ls)*vaug(ls,j);
            end
        end
    end
end


ifn=find(isfinite(d)==1);
res=d(ifn)-dc(ifn);
sumd=sum(sum(d(ifn).*d(ifn)));
sumdc=sum(sum(dc(ifn).*dc(ifn)));
sumres=sum(sum(res.*res));

loft=(sqrt(sumres/sumd))*100;
r2t1=((sumdc)/sumd)*100;
r2t2=((sumd-sumres)/sumd)*100;
disp(['lof (%) = ',num2str(loft)]);

disp(['R2 % = ',num2str(r2t2)]);

set(handles.text_2LOF,'string',num2str(loft));
set(handles.text_2R2,'string',num2str(r2t2));


% Test loftril (x,u1,vaug',u2)

disp(' ');disp('Test lof and R2 trilinear model')
dtc=dt;
for i=1:nr
    for j=1:nc
        for k=1:nmat
            if isfinite(dt(i,j,k))==1,
                dtc(i,j,k)=0;
                for ls=1:ns
                    dtc(i,j,k)=dtc(i,j,k)+u1(i,ls)*vaug(ls,j)*u2(k,ls);
                end
            end
        end
    end
end
ifn=find(isfinite(dt)==1);
res=dt(ifn)-dtc(ifn);
sumdt=sum(sum(sum(dt(ifn).*dt(ifn))));
sumdtc=sum(sum(sum(dtc(ifn).*dtc(ifn))));
sumres=sum(sum(sum(res.*res)));
% disp(['sstot,sscalc and ssres = ',num2str([sumdt,sumdtc,sumres])]);
loft=(sqrt(sumres/sumdt))*100;
r2t1=((sumdtc)/sumdt)*100;
r2t2=((sumdt-sumres)/sumdt)*100;
disp(['lof (%) = ',num2str(loft)]);

disp(['R2 % = ',num2str(r2t2)]);

set(handles.text_3LOF,'string',num2str(loft));
set(handles.text_3R2,'string',num2str(r2t2));


%save umodeaug variables

assignin('base','u1TRIL',u1);
evalin('base','mcr_als.aux.u1=u1TRIL;');
evalin('base','clear u1TRIL');

assignin('base','u2TRIL',u2);
evalin('base','mcr_als.aux.u2=u2TRIL;');
evalin('base','clear u2TRIL');

assignin('base','vaugTRIL',vaug);
evalin('base','mcr_als.aux.vaug=vaugTRIL;');
evalin('base','clear vaugTRIL');

assignin('base','lTRIL',l);
evalin('base','mcr_als.aux.l=lTRIL;');
evalin('base','clear lTRIL');

assignin('base','dcTRIL',dc);
evalin('base','mcr_als.aux.dc=dcTRIL;');
evalin('base','clear dcTRIL');

assignin('base','dtcTRIL',dtc);
evalin('base','mcr_als.aux.dtc=dtcTRIL;');
evalin('base','clear dtcTRIL');

assignin('base','dtTRIL',dt);
evalin('base','mcr_als.aux.dt=dtTRIL;');
evalin('base','clear dtTRIL');



% --- Outputs from this function are returned to the command line.
function varargout = bilinear_info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function popup_species_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nc=evalin('base','mcr_als.CompNumb.nc');
j=2;
llistannc(1)={'select a species...'};
for i=1:nc;
    llistnnc=['Species nr. ',num2str(i)];
    llistannc(j)={llistnnc};
    j=j+1;
end;
set(hObject,'string',llistannc)

% --- Executes on selection change in popup_species.
function popup_species_Callback(hObject, eventdata, handles)
% hObject    handle to popup_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_species contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_species

valorpop=get(hObject,'Value')-1;

if valorpop>0
    
    u1=evalin('base','mcr_als.aux.u1;');
    u2=evalin('base','mcr_als.aux.u2;');
    vaug=evalin('base','mcr_als.aux.vaug;');
    
    % mode 1
    axes(handles.axes1);
    plot(u1(:,valorpop));
    mm=length(u1);
    axis([0 mm+1 min(u1(:,valorpop))-0.1*min(u1(:,valorpop)) max(u1(:,valorpop))+0.1*max(u1(:,valorpop))]);
    title('Mode 1');
    
    % mode 2
    axes(handles.axes2);
    plot(vaug(valorpop,:));
    mm=length(vaug);
    axis([0 mm+1 min(vaug(valorpop,:))-0.1*min(vaug(valorpop,:)) max(vaug(valorpop,:))+0.1*max(vaug(valorpop,:))]);
    title('Mode 2');
    
    % mode 3
    axes(handles.axes3);
    plot(u2(:,valorpop));
    mm=length(u2);
    axis([0 mm+1 min(u2(:,valorpop))-0.1*min(u2(:,valorpop)) max(u2(:,valorpop))+0.1*max(u2(:,valorpop))]);
    title('Mode 3');
        
else
    
    axes(handles.axes1);
    cla;
    axes(handles.axes2);
    cla;
    axes(handles.axes3);
    cla;
end

% --- Executes on button press in push_export.
function push_export_Callback(hObject, eventdata, handles)
% hObject    handle to push_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

u1=evalin('base','mcr_als.aux.u1;');
assignin('base','u1',u1);

u2=evalin('base','mcr_als.aux.u2;');
assignin('base','u2',u2);

vaug=evalin('base','mcr_als.aux.vaug;');
assignin('base','vaug',vaug);

% --- Executes on button press in push_multiplot.
function push_multiplot_Callback(hObject, eventdata, handles)
% hObject    handle to push_multiplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp('plot for each component, estimation of profiles in three modes (using svd)')
kk=0;
% if iplot>2,u1=sgolayfilt(u1,2,49);end

ns=evalin('base','mcr_als.CompNumb.nc');

    u1=evalin('base','mcr_als.aux.u1;');
    u2=evalin('base','mcr_als.aux.u2;');
    vaug=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');

figure('Name','trilinear info multiplot');
for k=1:ns
    kk=kk+1;subplot(ns,3,kk),plot(u1(:,k),'r')
    kk=kk+1;subplot(ns,3,kk),plot(vaug(k,:),'b')
    kk=kk+1;subplot(ns,3,kk),plot(u2(:,k),'g')
end

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
