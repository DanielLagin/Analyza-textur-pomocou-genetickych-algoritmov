function varargout = geneticky_algoritmus_gui(varargin)
% GENETICKY_ALGORITMUS_GUI M-file for geneticky_algoritmus_gui.fig
%      GENETICKY_ALGORITMUS_GUI, by itself, creates a new GENETICKY_ALGORITMUS_GUI or raises the existing
%      singleton*.
%
%      H = GENETICKY_ALGORITMUS_GUI returns the handle to a new GENETICKY_ALGORITMUS_GUI or the handle to
%      the existing singleton*.
%
%      GENETICKY_ALGORITMUS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENETICKY_ALGORITMUS_GUI.M with the given input arguments.
%
%      GENETICKY_ALGORITMUS_GUI('Property','Value',...) creates a new GENETICKY_ALGORITMUS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before geneticky_algoritmus_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to geneticky_algoritmus_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help geneticky_algoritmus_gui

% Last Modified by GUIDE v2.5 24-May-2014 14:31:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @geneticky_algoritmus_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @geneticky_algoritmus_gui_OutputFcn, ...
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


% --- Executes just before geneticky_algoritmus_gui is made visible.
function geneticky_algoritmus_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to geneticky_algoritmus_gui (see VARARGIN)

% Choose default command line output for geneticky_algoritmus_gui
handles.output = hObject;

handles.edit2 = 100; %velkost populacie
handles.edit4 = 100; %pociatocna populacia
handles.edit5 = 5;  %parameter mutacie
handles.edit6 = 600;%klasifikator max
handles.edit7 = 40;  %minimum max
handles.edit8 = 1.6;   %sigma max

handles.sigma = 0;
handles.minimum = 0;
handles.klasifikator = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes geneticky_algoritmus_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = geneticky_algoritmus_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;

jedince = pociatocna_populacia(handles.edit2, handles.edit8, handles.edit7, handles.edit6);
[ vitaz, pocitadlo ] = selekcia_reprodukcia(jedince, handles.edit2, handles.edit4, handles.edit5);

vitaz_sigma = num2str(vitaz.sigma);
vitaz_minimum = num2str(vitaz.minimum);
vitaz_klasifikator = num2str(vitaz.klasifikator);

vitaz_fitness = num2str(vitaz.fitness);
pocitadlo_display = num2str(pocitadlo);

set(handles.text10, 'String', vitaz_sigma);
set(handles.text11, 'String', vitaz_minimum); 
set(handles.text12, 'String', vitaz_klasifikator); 
set(handles.text13, 'String', vitaz_fitness); 
set(handles.text21, 'String', pocitadlo);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
%velkost_populacie = get(hObject,'string');
%handles.velkost_populacie = velkost_populacie;
%guidatda(gcbo,handles);
velkost_populacie = str2double(get(hObject,'string'));
velkost_populacie = round(velkost_populacie);

modular = mod(velkost_populacie, 10);
if isnan(velkost_populacie)
  velkost_populacie = 0;
  errordlg('Prosím zadajte numerickú hodnotu.','Zlý vstup','modal')
  uicontrol(hObject)
  return
elseif (modular == 0)
  handles.edit2 = velkost_populacie;
  guidata(hObject,handles)
else
  velkost_populacie = 0;
  errordlg('Hodnota musí by» deliteµna èíslom 10.','Zlý vstup','modal')
  uicontrol(hObject) 
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
pocet_generacii = str2double(get(hObject,'string'));
if isnan(pocet_generacii)
  pocet_generacii = 0;
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.edit4 = pocet_generacii;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
parameter_mutacie = str2double(get(hObject,'string'));
if isnan(parameter_mutacie)
  parameter_mutacie = 0;
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.edit5 = parameter_mutacie;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
sigma_max = str2double(get(hObject,'string'));
if isnan(sigma_max)
  sigma_max = 0;
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.edit6 = sigma_max;
  guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
minimum_max = str2double(get(hObject,'string'));
if isnan(minimum_max)
  minimum_max = 0;
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.edit7 = minimum_max;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
klasifikator_max = str2double(get(hObject,'string'));
if isnan(klasifikator_max)
  klasifikator_max = 0;
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.edit8 = klasifikator_max;
  guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
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
sigma_uloz = get(handles.text10, 'String');
minimum_uloz = get(handles.text11, 'String');
klasifikator_uloz = get(handles.text12, 'String');

save('najlepsi_jedinec.mat', 'sigma_uloz', 'minimum_uloz', 'klasifikator_uloz');
