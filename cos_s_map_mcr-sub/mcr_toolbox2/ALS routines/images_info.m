function varargout = images_info(varargin)
% IMAGES_INFO MATLAB code for images_info.fig
%      IMAGES_INFO, by itself, creates a new IMAGES_INFO or raises the existing
%      singleton*.
%
%      H = IMAGES_INFO returns the handle to a new IMAGES_INFO or the handle to
%      the existing singleton*.
%
%      IMAGES_INFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGES_INFO.M with the given input arguments.
%
%      IMAGES_INFO('Property','Value',...) creates a new IMAGES_INFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before images_info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to images_info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help images_info

% Last Modified by GUIDE v2.5 17-Dec-2013 11:09:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @images_info_OpeningFcn, ...
                   'gui_OutputFcn',  @images_info_OutputFcn, ...
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


% --- Executes just before images_info is made visible.
function images_info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to images_info (see VARARGIN)

% Choose default command line output for images_info
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes images_info wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% aqui




% --- Outputs from this function are returned to the command line.
function varargout = images_info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% creations
% ************************************************************************

% --- Executes during object creation, after setting all properties.
function edit_xpix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xpix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_ypix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ypix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_images_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_presol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_presol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

copt=evalin('base','mcr_als.alsOptions.resultats.optim_concs;');
[m,n]=size(copt);
PixIn=[1:m];
assignin('base','PixIn',PixIn);
evalin('base','mcr_als.aux.pixin=PixIn;');
evalin('base','clear PixIn');

% --- Executes during object creation, after setting all properties.
function edit_pback_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

assignin('base','PixOut',0);
evalin('base','mcr_als.aux.pixout=PixOut;');
evalin('base','clear PixOut');


% --- Executes during object creation, after setting all properties.
function popup_wave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_wave (see GCBO)
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
lsv(1)={'arbitrary channels'};
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

% arbitrary channels
sopt=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
[rs,cs]=size(sopt);
longWave=[1:cs];
assignin('base','longWave',longWave);
evalin('base','mcr_als.aux.long=longWave;');
evalin('base','clear longWave');


% edits
% ************************************************************************

function edit_xpix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xpix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xpix as text
%        str2double(get(hObject,'String')) returns contents of edit_xpix as a double

x_pixs=str2num(get(hObject,'String'));
assignin('base','x_pixs',x_pixs);
evalin('base','mcr_als.aux.x=x_pixs;');
evalin('base','clear x_pixs');

function edit_ypix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ypix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ypix as text
%        str2double(get(hObject,'String')) returns contents of edit_ypix as a double

y_pixs=str2num(get(hObject,'String'));
assignin('base','y_pixs',y_pixs);
evalin('base','mcr_als.aux.y=y_pixs;');
evalin('base','clear y_pixs');


function edit_images_Callback(hObject, eventdata, handles)
% hObject    handle to edit_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_images as text
%        str2double(get(hObject,'String')) returns contents of edit_images as a double

z_imags=str2num(get(hObject,'String'));
assignin('base','z_imags',z_imags);
evalin('base','mcr_als.aux.z=z_imags;');
evalin('base','clear z_imags');


function edit_presol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_presol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_presol as text
%        str2double(get(hObject,'String')) returns contents of edit_presol as a double


PixIn=str2num(get(hObject,'String'));
assignin('base','PixIn',PixIn);
evalin('base','mcr_als.aux.pixin=PixIn;');
evalin('base','clear PixIn');


function edit_pback_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pback as text
%        str2double(get(hObject,'String')) returns contents of edit_pback as a double

PixOut=str2num(get(hObject,'String'));
assignin('base','PixOut',PixOut);
evalin('base','mcr_als.aux.pixout=PixOut;');
evalin('base','clear PixOut');

% --- Executes on selection change in popup_wave.
function popup_wave_Callback(hObject, eventdata, handles)
% hObject    handle to popup_wave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_wave contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_wave

popmenu3=get(handles.popup_wave,'String');
pm3=get(handles.popup_wave,'Value');

if pm3==1
    % arbitrary channels
    sopt=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
    [rs,cs]=size(sopt);
    longWave=[1:cs];
    assignin('base','longWave',longWave);
    evalin('base','mcr_als.aux.long=longWave;');
    evalin('base','clear longWave');
else
    selec3=char([popmenu3(pm3)]);
    longWave=evalin('base',selec3);
    assignin('base','longWave',longWave);
    evalin('base','mcr_als.aux.long=longWave;');
    evalin('base','clear longWave');    
end


% --- Executes on button press in push_OK.
function push_OK_Callback(hObject, eventdata, handles)
% hObject    handle to push_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


copt=evalin('base','mcr_als.alsOptions.resultats.optim_concs;');
sopt=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
[m,n]=size(copt);
[rs,cs]=size(sopt);

long=evalin('base','mcr_als.aux.long;');

% x
x=evalin('base','mcr_als.aux.x;');
% y
y=evalin('base','mcr_als.aux.y;');
% z -> number of images
z=evalin('base','mcr_als.aux.z;');

% pixin
pixin=evalin('base','mcr_als.aux.pixin;');
% pixout
pixout=evalin('base','mcr_als.aux.pixout;');

% if nargin <=6
%     pixout=0;
%     pixin=[1:m];
% end

mdis=cell(z,n);
quantc=zeros(z,n);
ctot=zeros(m,n);
ctot(pixin,:)=copt;

if pixout~=0
    ctot(pixout,:)=min(min(copt));
end

% reshaping conc profiles into maps frommultisets with images equally sized
if length(x)==1 & length(y)==1
    for j=0:z-1
        clayer=ctot((x*y)*j+1:(x*y)*(j+1),:);
        for i=1:n
            quantc(j+1,i)=100*(sum(sum(clayer(:,i)*sopt(i,:))))/(sum(sum(clayer*sopt)));
            mdis{j+1,i}=reshape(clayer(:,i),x,y);
%           figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]),axis('square')
            assignin('base','mdisIMG',mdis);
            evalin('base','mcr_als.aux.mdis=mdisIMG;');
            evalin('base','clear mdisIMG');
            
            assignin('base','quantcIMG',quantc);
            evalin('base','mcr_als.aux.quantc=quantcIMG;');
            evalin('base','clear quantcIMG');

        end
    end
end
% reshaping conc profiles into maps from multisets with images with different sizes
if length(x)>1 & length(y)>1
    ptot=0;
    for j=0:z-1
        clayer=ctot(ptot+1:ptot+x(j+1)*y(j+1),:);
        ptot=sum([ptot x(j+1)*y(j+1)]);
        for i=1:n
            quantc(j+1,i)=100*(sum(sum(clayer(:,i)*sopt(i,:))))/(sum(sum(clayer*sopt)));
            mdis{j+1,i}=reshape(clayer(:,i),x(j+1),y(j+1));
%           figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]),axis('square')
            assignin('base','mdisIMG',mdis);
            evalin('base','mcr_als.aux.mdis=mdisIMG;');
            evalin('base','clear mdisIMG');
 
            assignin('base','quantcIMG',quantc);
            evalin('base','mcr_als.aux.quantc=quantcIMG;');
            evalin('base','clear quantcIMG');

        end
    end
end

images_plots;
% figure,plot(long,sopt)


% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
