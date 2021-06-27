function varargout = MainGUI(varargin)
%MAINGUI MATLAB code file for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to MainGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MAINGUI('CALLBACK') and MAINGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MAINGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 26-Jun-2021 21:50:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% Tampilkan dalam uitable
    % ambil data nama negara (kolom ke-1)
    dataNamaNegara = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','A3:A239');

    % ambil data kolom ke-3
    dataTotalKasus = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','C3:C239');
    
    % ambil data kolom ke-4
    dataTotalKasusPerPopulation = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','D3:D239');
    
    % read table kolom 5-7
    data = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','E3:G239');
    
    % ubah ke bentuk array/matrix
    dataNamaNegara = table2cell(dataNamaNegara);
    dataTotalKasus = table2cell(dataTotalKasus);
    dataTotalKasusPerPopulation = table2cell(dataTotalKasusPerPopulation);
    data = table2cell(data);
    
    % merge tabel
    data=[dataNamaNegara,dataTotalKasus,dataTotalKasusPerPopulation,data];
    
    % tampilkan pada uitable
    set(handles.uitable1,'data',data);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1pilih=1;
set(handles.uitable2,'data',MainFunction(1));


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
set(handles.uitable2,'data',MainFunction(2));
