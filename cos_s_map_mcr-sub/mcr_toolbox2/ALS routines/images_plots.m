function varargout = images_plots(varargin)
% IMAGES_PLOTS MATLAB code for images_plots.fig
%      IMAGES_PLOTS, by itself, creates a new IMAGES_PLOTS or raises the existing
%      singleton*.
%
%      H = IMAGES_PLOTS returns the handle to a new IMAGES_PLOTS or the handle to
%      the existing singleton*.
%
%      IMAGES_PLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGES_PLOTS.M with the given input arguments.
%
%      IMAGES_PLOTS('Property','Value',...) creates a new IMAGES_PLOTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before images_plots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to images_plots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help images_plots

% Last Modified by GUIDE v2.5 10-Oct-2015 17:20:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @images_plots_OpeningFcn, ...
                   'gui_OutputFcn',  @images_plots_OutputFcn, ...
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


% --- Executes just before images_plots is made visible.
function images_plots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to images_plots (see VARARGIN)

% Choose default command line output for images_plots
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes images_plots wait for user response (see UIRESUME)
% uiwait(handles.figure1);

evalin('base','mcr_als.aux.flip=0;');


% --- Outputs from this function are returned to the command line.
function varargout = images_plots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

z_imags=evalin('base','mcr_als.aux.z');
if z_imags==1
    llistannc(1)={'Image nr. 1'};
    set(hObject,'string',llistannc,'Enable','inactive')
    evalin('base','mcr_als.aux.actual_image=1;');
else
    j=2;
    llistannc(1)={'select the nr of image...'};
    for i=1:z_imags;
        llistnnc=['Image nr. ',num2str(i)];
        llistannc(j)={llistnnc};
        j=j+1;
    end;
    set(hObject,'string',llistannc,'enable','on')
end;


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

imageNR=get(hObject,'Value')-1;

if imageNR>0
    assignin('base','imageNR',imageNR);
    evalin('base','mcr_als.aux.actual_image=imageNR;');
    evalin('base','clear imageNR');
    set(handles.popupmenu1,'Enable','on','value',1)
    axes(handles.axes1);
    cla;
    axes(handles.axes2);
    cla;
else
    set(handles.popupmenu1,'value',1,'Enable','inactive')
    axes(handles.axes1);
    cla;
    axes(handles.axes2);
    cla;
    
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
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


z_imags=evalin('base','mcr_als.aux.z');
if z_imags==1
    set(hObject,'string',llistannc,'Enable','on')
else
set(hObject,'string',llistannc,'Enable','inactive')
end;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

valorpop=get(hObject,'Value')-1;

if valorpop>0
    
    long=evalin('base','mcr_als.aux.long;');
    copt=evalin('base','mcr_als.alsOptions.resultats.optim_concs;');
    sopt=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
    minc=min(min(copt));
    maxc=max(max(copt));
    [m,n]=size(copt);
    % x
    x=evalin('base','mcr_als.aux.x;');
    % y
    y=evalin('base','mcr_als.aux.y;');
    % z -> total number of images
    z=evalin('base','mcr_als.aux.z;');
    % actual image
    imageNR=evalin('base','mcr_als.aux.actual_image;');
    % mdis
    mdis=evalin('base','mcr_als.aux.mdis;');
    % type of plot
    typePlot=evalin('base','mcr_als.aux.typePlot_image;');
    
    % j = imatge
    % flip y-axis
    valorFLIP=evalin('base','mcr_als.aux.flip;');
    
    % reshaping conc profiles into maps frommultisets with images equally sized
    if length(x)==1 & length(y)==1
        axes(handles.axes1);
        if typePlot==1
            if valorFLIP==1
                imagesc(mdis{imageNR,valorpop},[minc maxc]);axis('xy');axis('square');colorbar
            else
                imagesc(mdis{imageNR,valorpop},[minc maxc]);axis('square');colorbar
            end
        elseif typePlot==2
            if valorFLIP==1
                contour(mdis{imageNR,valorpop},50);axis('xy');axis('square');colorbar
            else
                contour(mdis{imageNR,valorpop},50);axis('square');colorbar
            end
        end
    end
    % reshaping conc profiles into maps from multisets with images with different sizes
    if length(x)>1 & length(y)>1
                axes(handles.axes1);
                if typePlot==1
                    if valorFLIP==1
                        imagesc(mdis{imageNR,valorpop},[minc maxc]);axis('xy');axis('square');colobar
                    else
                        imagesc(mdis{imageNR,valorpop},[minc maxc]);axis('square');colobar
                    end
                elseif typePlot==2
                    if valorFLIP==1
                        contour(mdis{imageNR,valorpop},50);axis('xy');axis('square');colorbar
                    else
                        contour(mdis{imageNR,valorpop},50);axis('square');colorbar
                    end
                end
    end
    
    axes(handles.axes2);
    plot(long,sopt(valorpop,:),'k');
    axis([min(long) max(long) min(sopt(valorpop,:))-0.1*min(sopt(valorpop,:)) max(sopt(valorpop,:))+0.1*max(sopt(valorpop,:))]); 
    
    quantc=evalin('base','mcr_als.aux.quantc;');
    valorQ=quantc(imageNR,valorpop);
    set(handles.edit_quatc,'string',num2str(valorQ));
   
else
    
    axes(handles.axes1);
    cla;
    axes(handles.axes2);
    cla;
    set(handles.edit_quatc,'string',' ');
end


% --- Executes on button press in push_multiplot.
function push_multiplot_Callback(hObject, eventdata, handles)
% hObject    handle to push_multiplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    long=evalin('base','mcr_als.aux.long;');
    copt=evalin('base','mcr_als.alsOptions.resultats.optim_concs;');
    sopt=evalin('base','mcr_als.alsOptions.resultats.optim_specs;');
    minc=min(min(copt));
    maxc=max(max(copt));
    [m,n]=size(copt);
    % x
    x=evalin('base','mcr_als.aux.x;');
    % y
    y=evalin('base','mcr_als.aux.y;');
    % z -> total number of images
    z=evalin('base','mcr_als.aux.z;');
    % mdis
    mdis=evalin('base','mcr_als.aux.mdis;');
    % type of plot
    typePlot=evalin('base','mcr_als.aux.typePlot_image;');
    % flip y-axis
    valorFLIP=evalin('base','mcr_als.aux.flip;');
    
    
% reshaping conc profiles into maps frommultisets with images equally sized
if length(x)==1 & length(y)==1
    for j=0:z-1
        for i=1:n
            if typePlot==1
                if valorFLIP==1
                    figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]);axis('xy');axis('square');colorbar;
                else
                    figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]);axis('square');colorbar;
                end
            elseif typePlot==2
                if valorFLIP==1
                    figure(j+1),subplot(n,1,i),contour(mdis{j+1,i},50);axis('xy');axis('square');colorbar;
                else
                    figure(j+1),subplot(n,1,i),contour(mdis{j+1,i},50);axis('square');colorbar;
                end
            end
            set(gcf,'Name','Conc distribution');
        end
    end
    
end
% reshaping conc profiles into maps from multisets with images with different sizes
if length(x)>1 & length(y)>1
    for j=0:z-1
        for i=1:n
            if typePlot==1
                if valorFLIP==1
                    figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]);axis('xy');axis('square');colorbar;
                else
                    figure(j+1),subplot(n,1,i),imagesc(mdis{j+1,i},[minc maxc]);axis('square');colorbar;
                end
            elseif typePlot==2
                if valorFLIP==1
                    figure(j+1),subplot(n,1,i),contour(mdis{j+1,i},50);axis('xy');axis('square');colorbar;
                else
                    figure(j+1),subplot(n,1,i),contour(mdis{j+1,i},50);axis('square');colorbar;
                end
            end
            set(gcf,'Name','Conc distribution');
        end
    end
end

figure('Name','Spectra');
plot(long,sopt);
axis([min(long) max(long) min(min(sopt))-0.1*min(min(sopt)) max(max(sopt))+0.1*max(max(sopt))]); 

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in push_save.
function push_save_Callback(hObject, eventdata, handles)
% hObject    handle to push_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


mdis=evalin('base','mcr_als.aux.mdis;');
assignin('base','mdis',mdis);

quantc=evalin('base','mcr_als.aux.quantc;');
assignin('base','quantc',quantc);



function edit_quatc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_quatc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_quatc as text
%        str2double(get(hObject,'String')) returns contents of edit_quatc as a double


% --- Executes during object creation, after setting all properties.
function edit_quatc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_quatc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function listbox_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    typePlot=1;
    assignin('base','typePlot',typePlot);
    evalin('base','mcr_als.aux.typePlot_image=typePlot;');
    evalin('base','clear typePlot');

% --- Executes on selection change in listbox_plot.
function listbox_plot_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_plot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_plot

valorlist=get(hObject,'Value');
    assignin('base','typePlot',valorlist);
    evalin('base','mcr_als.aux.typePlot_image=typePlot;');
    evalin('base','clear typePlot');


% --- Executes on button press in check_flip.
function check_flip_Callback(hObject, eventdata, handles)
% hObject    handle to check_flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_flip


valorFLIP=get(hObject,'Value');
    assignin('base','valorFLIP',valorFLIP);
    evalin('base','mcr_als.aux.flip=valorFLIP;');
    evalin('base','clear valorFLIP');


