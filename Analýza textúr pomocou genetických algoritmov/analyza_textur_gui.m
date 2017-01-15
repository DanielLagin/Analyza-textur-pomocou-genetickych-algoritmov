function varargout = analyza_textur_gui(varargin)
% ANALYZA_TEXTUR_GUI M-file for analyza_textur_gui.fig
%      ANALYZA_TEXTUR_GUI, by itself, creates a new ANALYZA_TEXTUR_GUI or raises the existing
%      singleton*.
%
%      H = ANALYZA_TEXTUR_GUI returns the handle to a new ANALYZA_TEXTUR_GUI or the handle to
%      the existing singleton*.
%
%      ANALYZA_TEXTUR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYZA_TEXTUR_GUI.M with the given input arguments.
%
%      ANALYZA_TEXTUR_GUI('Property','Value',...) creates a new ANALYZA_TEXTUR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analyza_textur_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analyza_textur_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analyza_textur_gui

% Last Modified by GUIDE v2.5 26-May-2014 16:54:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analyza_textur_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @analyza_textur_gui_OutputFcn, ...
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


% --- Executes just before analyza_textur_gui is made visible.
function analyza_textur_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analyza_textur_gui (see VARARGIN)

% Choose default command line output for analyza_textur_gui
handles.output = hObject;

%Nastavenie premenných v editoch
handles.Image = 0;
handles.jas_vypadok = 69;
handles.hrany_vypadok = 80;
handles.hrany_podozrenie = 78;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analyza_textur_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analyza_textur_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in vyber.
function vyber_Callback(hObject, eventdata, handles)
% hObject    handle to vyber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Naèítanie RGB obrázka zo súboru
filename = 0;

while filename == 0,
    [ filename, pathname ] = uigetfile(...
        {'*.jpg;*.tif;*.png;*.gif','All Image Files';...
        '*.*','All Files' },'výber obrázku');     
    if filename == 0,
        error('Neoznaèili ste ¾iadny súbor.');
    end
end

handles.Image = imread([ pathname filename ]);

%Vytvorenie masky pre detekciu ciev
cievy_maska = cievy(handles.Image);

%Predspracovanie obrázka, Prevedenie do ¹edotónovej formy, zvýraznenie
%Selekcia výseku

vysek = predspracovanie(handles.Image, cievy_maska);

handles.segmentacia = vysek;

%Zobrazenie výseku
imshow(vysek, 'Parent', handles.image_zobrazenie);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

%Kontrolný mechanizmus vstupov, naèítanie editov do premenných
vypadok_hrany = str2double(get(hObject,'string'));
if isnan(vypadok_hrany)
  vypadok_hrany = 0;
  errordlg('Zadajte prosím celoèíselnú hodnotu','Zlý vstup','modal')
  uicontrol(hObject)
  return
else
  handles.hrany_vypadok = vypadok_hrany;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Vyberiem výsek na spracovanie
vysek = getimage(handles.image_zobrazenie);

%Porovnávacia segmentácia
[ vysledok ] = porovnavacia_segmentacia( vysek, 1.5, 43, 430, handles.hrany_podozrenie, handles.hrany_vypadok, 2, 45, handles.jas_vypadok, 2, 3);

%Ulo¾enie výsledku
segmentacia = getframe(handles.image_zobrazenie);
vysledna_segmentacia = frame2im(segmentacia);
imwrite(vysledna_segmentacia, 'Vysledky/Segmentacia/glaukom_vysledok.jpg');

%Zobrazenie výsledkov v príslu¹ných èastiach aplikácie
segmentacia_1 = imread('Vysledky/Segmentacia/glaukom_vysledok.jpg');

imshow(vysek, 'Parent', handles.image_zobrazenie);
imshow(segmentacia_1, 'Parent', handles.axes14);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

%Kontrolný mechanizmus vstupov, naèítanie editov do premenných
vypadok_jas = str2double(get(hObject,'string'));
if isnan(vypadok_jas)
  vypadok_jas = 0;
  errordlg('Zadajte prosím celoèíselnú hodnotu','Zlý vstup','modal')
  uicontrol(hObject)
  return
else
  handles.jas_vypadok = vypadok_jas;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Vyberiem výsek na spracovanie
vysek = getimage(handles.image_zobrazenie);

%Segmentácia pomocou genetického algoritmu
[ vysledok ] = geneticky_segmentacia( vysek, handles.hrany_podozrenie, handles.hrany_vypadok, 2, 45, handles.jas_vypadok, 2, 3);

%Ulo¾enie výsledku
segmentacia = getframe(handles.image_zobrazenie);
vysledna_segmentacia = frame2im(segmentacia);
imwrite(vysledna_segmentacia, 'Vysledky/Segmentacia/Geneticky segmentacia/glaukom_vysledok.jpg');

%Zobrazenie výsledkov v príslu¹ných èastiach aplikácie
segmentacia_1 = imread('Vysledky/Segmentacia/Geneticky segmentacia/glaukom_vysledok.jpg');

imshow(vysek, 'Parent', handles.image_zobrazenie);
imshow(segmentacia_1, 'Parent', handles.axes14);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

%Kontrolný mechanizmus vstupov, naèítanie editov do premenných
podozrenie = str2double(get(hObject,'string'));
if isnan(podozrenie)
  podozrenie = 0;
  errordlg('Zadajte prosím celoèíselnú hodnotu','Zlý vstup','modal')
  uicontrol(hObject)
  return
else
  handles.hrany_podozrenie = podozrenie;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
