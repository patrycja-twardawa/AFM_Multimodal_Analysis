function varargout = Krzywe(varargin)
% KRZYWE MATLAB code for Krzywe.fig
%      KRZYWE, by itself, creates a new KRZYWE or raises the existing
%      singleton*.
%
%      H = KRZYWE returns the handle to a new KRZYWE or the handle to
%      the existing singleton*.
%
%      KRZYWE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KRZYWE.M with the given input arguments.
%
%      KRZYWE('Property','Value',...) creates a new KRZYWE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Krzywe_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Krzywe_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Krzywe

% Last Modified by GUIDE v2.5 28-Apr-2021 18:46:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Krzywe_OpeningFcn, ...
                   'gui_OutputFcn',  @Krzywe_OutputFcn, ...
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

% --- Executes just before Krzywe is made visible.
function Krzywe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Krzywe (see VARARGIN)

% Choose default command line output for Krzywe
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Krzywe wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% DEKLARACJA ZMIENNYCH GLOBALNYCH

assignin('base', 'h', []); %narzêdzie pêdzla
assignin('base', 'kolor', [255, 255, 146]); %kolor zaznaczenia - ¿ó³ty
assignin('base', 'szer_bin', [0, 0, 0]); %skala obrazu - [kolumny (Y), wiersze (X), kana³y (Z)]
assignin('base', 'szer_bin_check', 0); %flaga wprowadzenia wspó³czynnika skalowania
assignin('base', 'file_check', 0); %flaga wprowadzenia pliku

% --- Outputs from this function are returned to the command line.
function varargout = Krzywe_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% OBS£UGA ZDARZEÑ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% PRZYCISK WYBORU ROI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in roi_btn.
function roi_btn_Callback(hObject, eventdata, handles)
% hObject    handle to roi_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.listbox1, 'Enable', 'off'); %zmiana statusu kontrolek okna
%set(handles.arkusz_btn, 'Enable', 'off');
%set(handles.zapisztsv_btn, 'Enable', 'off');
set(handles.zapisztxt_btn, 'Enable', 'off');

h = evalin('base', 'h'); %wczytanie zmiennych z przestrzeni roboczej
I = evalin('base', 'I'); 
szer_bin = evalin('base', 'szer_bin');
kolor = evalin('base', 'kolor');

delete(h);
axes(handles.axes1); hold off;
cla(handles.axes1);
axes(handles.axes1);
imshow(I); hold on;

h = imfreehand; %pêdzel zaznaczenia
binarny = h.createMask();
pos = h.getPosition();

rc = I(:, :, 1); %kolorowanie zaznaczenia
gc = I(:, :, 2);
bc = I(:, :, 3);
rc(binarny) = kolor(1);
gc(binarny) = kolor(2);
bc(binarny) = kolor(3);
rgbI = cat(3, rc, gc, bc);

plot(pos(:,1), pos(:,2), '-g'); hold on; %rysowanie zaznaczenia
imshow(rgbI); hold on;

v = linspace(1, szer_bin(1) * szer_bin(2), szer_bin(1) * szer_bin(2)); %przygotowanie mapy kolejnoœci krzywych, zgodnej z numeracj¹ JPK
c = mat2cell(v, 1, repmat( szer_bin(2), 1, szer_bin(1) )); %szer_bin(1) - wiersze, szer_bin(2) - kolumny
c(2: 2: fix(numel(c)/2) * 2) = mat2cell( fliplr(cell2mat( ...
    c(fix(numel(c)/2) * 2: -2: 2) )), ...
    1,  repmat(szer_bin(2), 1, fix(szer_bin(1)/2)) );
v2 = flip( reshape(cell2mat(c), szer_bin(2), szer_bin(1))' );

krzywe = sort(v2(binarny));

set(handles.roi_btn, 'ForegroundColor', [1 1 1]); %zmiana statusu kontrolek okna
% set(handles.arkusz_btn, 'ForegroundColor', [0 1 0]);
% set(handles.zapisztsv_btn, 'ForegroundColor', [0 1 0]);
set(handles.zapisztxt_btn, 'ForegroundColor', [0 1 0]);
set(handles.listbox1, 'String', krzywe, 'Enable', 'on'); 
%set(handles.arkusz_btn, 'Enable', 'on');
set(handles.skala_ebx, 'Enable', 'on');
set(handles.skala2_ebx, 'Enable', 'on');
%set(handles.zapisztsv_btn, 'Enable', 'on');
set(handles.zapisztxt_btn, 'Enable', 'on');
set(handles.przykrywka_l1_tbx, 'Visible', 'off');

assignin('base', 'h', h); %zapis zmiennych do przestrzeni roboczej
assignin('base', 'krzywe', krzywe);


% PRZYCISK WYBORU PLIKU %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in plik_btn.
function plik_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plik_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[plik, sciezka] = uigetfile({'*.bmp';'*.png';'*.jpg';'*.tiff*'}, ...
    'Wybierz dane obrazowe pomiaru AFM');

if ~isequal(plik,0)
    
    h = evalin('base', 'h'); %wczytanie zmiennych z przestrzeni roboczej
    delete(h);
    
    I = imread(fullfile(sciezka, plik)); %wczytanie pliku    
    szer_bin = size(I); %wczytanie skali podstawowej    
    I = imresize(I, 1 / ((size(I,1) / szer_bin(1)))); %skalowanie

    axes(handles.axes1); hold off;
    cla(handles.axes1);
    axes(handles.axes1); %wyœwietlanie obrazu
    imshow(I); hold on;
    
    set(handles.plik_btn, 'ForegroundColor', [1 1 1]); %zmiana statusu kontrolek okna
    set(handles.roi_btn, 'ForegroundColor', [0 1 0]); 
    set( handles.plik_tbx, 'String', strcat({'PLIK: '}, {plik}) );
    set( handles.skala_ebx, 'String', num2str(szer_bin(1)) );
    set( handles.skala2_ebx, 'String', num2str(szer_bin(2)) );
    %set(handles.arkusz_btn, 'Enable', 'off');
    set(handles.roi_btn, 'Enable', 'on');
    set(handles.skala_ebx, 'Enable', 'on');
    set(handles.skala2_ebx, 'Enable', 'on');
    %set(handles.zapisztsv_btn, 'Enable', 'off');
    set(handles.zapisztxt_btn, 'Enable', 'off');
    set(handles.przykrywka_l1_tbx, 'Visible', 'on');
    
    assignin('base', 'I', I); %zapis do bazy zmiennych przestrzeni roboczej 
    assignin('base', 'file_check', 1);
    assignin('base', 'plik', plik);
    assignin('base', 'sciezka', sciezka);
    assignin('base', 'szer_bin', szer_bin);
    
end


% PRZYCISK ZAPISU W PLIKU TEKSTOWYM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in zapisztxt_btn.
function zapisztxt_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zapisztxt_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

krzywe = evalin('base', 'krzywe'); %wczytanie zmiennych z przestrzeni roboczej
plik = evalin('base', 'plik');
sciezka = evalin('base', 'sciezka');

sciezka_zapisu = fullfile(sciezka, plik); %jeœli istnieje plik o tej samej nazwie, zostanie nadpisany
sciezka_zapisu = strcat(sciezka_zapisu(1:end-4), '.txt');

dlmwrite(sciezka_zapisu, krzywe); %zapisz do pliku

f = msgbox('Plik w formacie .txt zapisano na dysku w lokalizacji, w której znajduje siê wybrany plik obrazu.', 'Informacja');
%close(Krzywe);

% ZAZNACZENIE WYBORU NA LIŒCIE - BRAK AKCJI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% WSPÓ£CZYNNIK SKALOWANIA X (WIERSZE) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function skala_ebx_Callback(hObject, eventdata, handles)
% hObject    handle to skala_ebx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of skala_ebx as text
%        str2double(get(hObject,'String')) returns contents of skala_ebx as a double

sciezka = evalin('base', 'sciezka'); %wczytanie zmiennych z przestrzeni roboczej
plik = evalin('base', 'plik');
h = evalin('base', 'h'); %wczytanie zmiennych z przestrzeni roboczej
delete(h);

szer_temp = get(handles.skala_ebx, 'String'); %docelowy rozmiar obrazu w kolumnach - wczytanie z okna

if isnumeric( abs(str2double(szer_temp)) ) %sprawdzenie poprawnoœci danych
    
    I = evalin('base', 'I');
    
    if (numel( abs(str2double(szer_temp)) ) > 1 && abs(ceil(str2double(szer_temp))) > 0)        
        szer_bin(1) = abs( ceil( str2double(szer_temp(1)) )); %przypisanie docelowych wartoœci pikseli we wierszach i kolumnach
        szer_bin(2) = size(I,2) / ( (size(I,1) / szer_bin(1)) );        
    elseif (abs(ceil(szer_temp)) > 0)   
        szer_bin(1) = abs( ceil( str2double(szer_temp) )); %przypisanie docelowych wartoœci pikseli we wierszach i kolumnach
        szer_bin(2) = size(I,2) / ( (size(I,1) / szer_bin(1)) );        
    else
        szer_bin = size(evalin('base', 'I')); %pobranie defaultowych wartoœci rozmiaru obrazu
    end   
end
    
I = imread(fullfile(sciezka, plik)); %wczytanie pliku
I = imresize( I, 1 / ( (size(I,1) / szer_bin(1)) )); %skalowanie zgodnie z wartoœci¹ wspó³czynnika wierszy
    
axes(handles.axes1); hold off; %wyœwietlanie przeskalowanego obrazu
cla(handles.axes1);
axes(handles.axes1);
imshow(I); hold on;

set(handles.roi_btn, 'ForegroundColor', [0 1 0]); %zmiana statusu kontrolek okna
set( handles.skala_ebx, 'String', num2str(szer_bin(1)) );
set( handles.skala2_ebx, 'String', num2str(szer_bin(2)) );
%set(handles.arkusz_btn, 'Enable', 'off');
set(handles.roi_btn, 'Enable', 'on');
%set(handles.zapisztsv_btn, 'Enable', 'off');
set(handles.zapisztxt_btn, 'Enable', 'off');
set(handles.przykrywka_l1_tbx, 'Visible', 'on');

assignin('base', 'I', I); %zapis do bazy zmiennych przestrzeni roboczej 
assignin('base', 'szer_bin', szer_bin); 
assignin('base', 'szer_bin_check', 1);

% --- Executes during object creation, after setting all properties.
function skala_ebx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skala_ebx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% WSPÓ£CZYNNIK SKALOWANIA Y (KOLUMNY) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function skala2_ebx_Callback(hObject, eventdata, handles)
% hObject    handle to skala2_ebx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of skala2_ebx as text
%        str2double(get(hObject,'String')) returns contents of skala2_ebx as a double

sciezka = evalin('base', 'sciezka'); %wczytanie zmiennych z przestrzeni roboczej
plik = evalin('base', 'plik');
h = evalin('base', 'h'); %wczytanie zmiennych z przestrzeni roboczej
delete(h);

szer_temp = get(handles.skala2_ebx, 'String'); %docelowy rozmiar obrazu w kolumnach - wczytanie z okna

if isnumeric( abs(str2double(szer_temp)) ) %sprawdzenie poprawnoœci danych
    
    I = evalin('base', 'I');
    
    if (numel( abs(str2double(szer_temp)) ) > 1 && abs( ceil( str2double(szer_temp) )) > 0)        
        szer_bin(2) = abs( ceil( str2double(szer_temp(1)) )); %przypisanie docelowych wartoœci pikseli w kolumnach i wierszach
        szer_bin(1) = size(I,1) / ( (size(I,2) / szer_bin(2)) );        
    elseif (abs(ceil(szer_temp)) > 0)   
        szer_bin(2) = abs( ceil( str2double(szer_temp) )); %przypisanie docelowych wartoœci pikseli we kolumnach i wierszach
        szer_bin(1) = size(I,1) / ( (size(I,2) / szer_bin(2)) );            
    else   
        szer_bin = size(evalin('base', 'I')); %pobranie defaultowych wartoœci rozmiaru obrazu
    end
    
end
    
I = imread(fullfile(sciezka, plik)); %wczytanie pliku
I = imresize( I, 1 / ( (size(I,1) / szer_bin(1)) )); %skalowanie zgodnie z wartoœci¹ wspó³czynnika wierszy
    
axes(handles.axes1); hold off; %wyœwietlanie przeskalowanego obrazu
cla(handles.axes1);
axes(handles.axes1);
imshow(I); hold on;

set(handles.roi_btn, 'ForegroundColor', [0 1 0]); %zmiana statusu kontrolek okna
set( handles.skala_ebx, 'String', num2str(szer_bin(1)) );
set( handles.skala2_ebx, 'String', num2str(szer_bin(2)) );
%set(handles.arkusz_btn, 'Enable', 'off');
set(handles.roi_btn, 'Enable', 'on');
%set(handles.zapisztsv_btn, 'Enable', 'off');
set(handles.zapisztxt_btn, 'Enable', 'off');
set(handles.przykrywka_l1_tbx, 'Visible', 'on');

assignin('base', 'I', I); %zapis do bazy zmiennych przestrzeni roboczej 
assignin('base', 'szer_bin', szer_bin); 
assignin('base', 'szer_bin_check', 1);

% --- Executes during object creation, after setting all properties.
function skala2_ebx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skala2_ebx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% PRZYCISK ZAPISU W PLIKU TSV - UZUPE£NIÆ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in zapisztsv_btn.
function zapisztsv_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zapisztsv_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% PRZYCISK WYBORU ARKUSZA - UZUPE£NIÆ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in arkusz_btn.
function arkusz_btn_Callback(hObject, eventdata, handles)
% hObject    handle to arkusz_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
