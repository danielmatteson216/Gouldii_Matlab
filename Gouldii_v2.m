function varargout = Gouldii_v2(varargin)
% GOULDII_V2 MATLAB code for Gouldii_v2.fig
%      GOULDII_V2, by itself, creates a new GOULDII_V2 or raises the existing
%      singleton*.
%
%      H = GOULDII_V2 returns the handle to a new GOULDII_V2 or the handle to
%      the existing singleton*.
%
%      GOULDII_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOULDII_V2.M with the given input arguments.
%
%      GOULDII_V2('Property','Value',...) creates a new GOULDII_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gouldii_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gouldii_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gouldii_v2

% Last Modified by GUIDE v2.5 26-Aug-2018 08:25:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gouldii_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @Gouldii_v2_OutputFcn, ...
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


% --- Executes just before Gouldii_v2 is made visible.
function Gouldii_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gouldii_v2 (see VARARGIN)
clc

% Choose default command line output for Gouldii_LO_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gouldii_LO_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui('northwest')
set(handles.Input_ParameterA, 'enable', 'off')
set(handles.Input_opt2numofsteps, 'enable', 'off')
set(handles.Input_opt2lowerbound, 'enable', 'off')
set(handles.Input_opt2upperbound, 'enable', 'off')
set(handles.edit_wfaperiod, 'enable', 'off')
set(handles.edit_wfasample, 'enable', 'off')
filename = 'load(''db_tradedate.mat'')';
evalin('base',filename);






% --- Outputs from this function are returned to the command line.
function varargout = Gouldii_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                            OPTIMIZED INPUTS
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

%--------------------------------------------------------------------------
% OPT 1


function Input_opt1numofsteps_Callback(hObject, eventdata, handles)
% hObject    handle to Input_opt1numofsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_opt1numofsteps as text
%        str2double(get(hObject,'String')) returns contents of Input_opt1numofsteps as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_opt1numofsteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1numofsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on Input_opt1numofsteps and none of its controls.
function Input_opt1numofsteps_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1numofsteps (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'on');

%===================


function Input_opt1lowerbound_Callback(hObject, eventdata, handles)
% hObject    handle to Input_opt1lowerbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_opt1lowerbound as text
%        str2double(get(hObject,'String')) returns contents of Input_opt1lowerbound as a double
guidata(hObject, handles);
set(hObject, 'Enable', 'on');
handles = guidata(hObject);
handles.in_opt1lowerbound = get(hObject,'String');
%temp_input = handles.in_opt1lowerbound;
input_lower1 = get(handles.Input_opt1lowerbound, 'String');
drawnow;
input_upper1 = get(handles.Input_opt1upperbound, 'String');
drawnow;
input_lower1 = str2double(input_lower1);
input_upper1 = str2double(input_upper1);
if input_lower1 > input_upper1
              warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday');    
              set(handles.Input_opt1lowerbound, 'string', handles.temp_opt1lowerbound) 
              set(hObject, 'Enable', 'on');
              guidata(hObject, handles);
end 

guidata(hObject, handles);
set(hObject, 'Enable', 'Inactive');
drawnow;

% --- Executes during object creation, after setting all properties.
function Input_opt1lowerbound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1lowerbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on Input_opt1lowerbound and none of its controls.
function Input_opt1lowerbound_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1lowerbound (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Input_opt1lowerbound.
function Input_opt1lowerbound_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1lowerbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles = guidata(hObject);
%set(hObject, 'Enable', 'Inactive');
%uicontrol(handles.Input_opt1lowerbound);
guidata(hObject, handles);
handles.temp_opt1lowerbound = get(handles.Input_opt1lowerbound,'String');
drawnow;
%temp_input = handles.temp_opt1lowerbound;
guidata(hObject, handles);
set(hObject, 'Enable', 'on');



%===================


function Input_opt1upperbound_Callback(hObject, eventdata, handles)
% hObject    handle to Input_opt1upperbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_opt1upperbound as text
%        str2double(get(hObject,'String')) returns contents of Input_opt1upperbound as a double
guidata(hObject, handles);
set(hObject, 'Enable', 'on');
handles = guidata(hObject);
handles.in_opt1upperound = get(hObject,'String');
%temp_input = handles.in_opt1upperbound;
input_lower1 = get(handles.Input_opt1lowerbound, 'String');
drawnow;
input_upper1 = get(handles.Input_opt1upperbound, 'String');
drawnow;
input_lower1 = str2double(input_lower1);
input_upper1 = str2double(input_upper1);
if input_upper1 < input_lower1
              warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday');    
              set(handles.Input_opt1upperbound, 'string', handles.temp_opt1upperbound) 
              set(hObject, 'Enable', 'on');
              guidata(hObject, handles);
end 

guidata(hObject, handles);
set(hObject, 'Enable', 'Inactive');
drawnow;

% --- Executes during object creation, after setting all properties.
function Input_opt1upperbound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1upperbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Input_opt1upperbound.
function Input_opt1upperbound_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt1upperbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(hObject, 'Enable', 'Inactive');
guidata(hObject, handles);
handles.temp_opt1upperbound = get(handles.Input_opt1upperbound,'String');
drawnow;
%temp_input = handles.temp_opt1lowerbound;
guidata(hObject, handles);
set(hObject, 'Enable', 'on');



%--------------------------------------------------------------------------
% OPT 2


function Input_opt2numofsteps_Callback(hObject, eventdata, handles)
% hObject    handle to Input_opt2numofsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_opt2numofsteps as text
%        str2double(get(hObject,'String')) returns contents of Input_opt2numofsteps as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_opt2numofsteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt2numofsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_opt2lowerbound_Callback(hObject, eventdata, handles)
% hObject    handle to Input_opt2lowerbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_opt2lowerbound as text
%        str2double(get(hObject,'String')) returns contents of Input_opt2lowerbound as a double
guidata(hObject, handles);
set(hObject, 'Enable', 'on');
handles = guidata(hObject);
handles.in_opt2lowerbound = get(hObject,'String');
%temp_input = handles.in_opt1lowerbound;
input_lower2 = get(handles.Input_opt2lowerbound, 'String');
drawnow;
input_upper2 = get(handles.Input_opt2upperbound, 'String');
drawnow;
input_lower2 = str2double(input_lower2);
input_upper2 = str2double(input_upper2);
if input_lower2 > input_upper2
              warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday');    
              set(handles.Input_opt2lowerbound, 'string', handles.temp_opt2lowerbound) 
              set(hObject, 'Enable', 'on');
              guidata(hObject, handles);
end 

guidata(hObject, handles);

set(hObject, 'Enable', 'Inactive');
drawnow;

% --- Executes during object creation, after setting all properties.
function Input_opt2lowerbound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt2lowerbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Input_opt2lowerbound.
function Input_opt2lowerbound_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt2lowerbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
handles.temp_opt2lowerbound = get(handles.Input_opt2lowerbound,'String');
drawnow;
%temp_input = handles.temp_opt1lowerbound;
guidata(hObject, handles);
set(hObject, 'Enable', 'on');


%===================


function Input_opt2upperbound_Callback(hObject, eventdata, handles)
% hObject    handle to Input_opt2upperbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_opt2upperbound as text
%        str2double(get(hObject,'String')) returns contents of Input_opt2upperbound as a double
guidata(hObject, handles);
set(hObject, 'Enable', 'on');
handles = guidata(hObject);
handles.in_opt2upperound = get(hObject,'String');
%temp_input = handles.in_opt1upperbound;
input_lower2 = get(handles.Input_opt2lowerbound, 'String');
drawnow;
input_upper2 = get(handles.Input_opt2upperbound, 'String');
drawnow;
input_lower2 = str2double(input_lower2);
input_upper2 = str2double(input_upper2);
if input_upper2 < input_lower2
              warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday');    
              set(handles.Input_opt2upperbound, 'string', handles.temp_opt2upperbound) 
              set(hObject, 'Enable', 'on');
              guidata(hObject, handles);
end 

guidata(hObject, handles);
set(hObject, 'Enable', 'Inactive');
drawnow;

% --- Executes during object creation, after setting all properties.
function Input_opt2upperbound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt2upperbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Input_opt2upperbound.
function Input_opt2upperbound_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Input_opt2upperbound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
handles.temp_opt2upperbound = get(handles.Input_opt2upperbound,'String');
drawnow;
%temp_input = handles.temp_opt1lowerbound;
guidata(hObject, handles);
set(hObject, 'Enable', 'on');


%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                            PARAMETER INPUTS
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


function Input_ParameterA_Callback(hObject, eventdata, handles)
% hObject    handle to Input_ParameterA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_ParameterA as text
%        str2double(get(hObject,'String')) returns contents of Input_ParameterA as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_ParameterA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_ParameterA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_ParameterB_Callback(hObject, eventdata, handles)
% hObject    handle to Input_ParameterB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_ParameterB as text
%        str2double(get(hObject,'String')) returns contents of Input_ParameterB as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_ParameterB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_ParameterB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_ParameterC_Callback(hObject, eventdata, handles)
% hObject    handle to Input_ParameterC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_ParameterC as text
%        str2double(get(hObject,'String')) returns contents of Input_ParameterC as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_ParameterC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_ParameterC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_ParameterD_Callback(hObject, eventdata, handles)
% hObject    handle to Input_ParameterD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_ParameterD as text
%        str2double(get(hObject,'String')) returns contents of Input_ParameterD as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_ParameterD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_ParameterD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_ParameterE_Callback(hObject, eventdata, handles)
% hObject    handle to Input_ParameterE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_ParameterE as text
%        str2double(get(hObject,'String')) returns contents of Input_ParameterE as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_ParameterE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_ParameterE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_ParameterF_Callback(hObject, eventdata, handles)
% hObject    handle to Input_ParameterF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_ParameterF as text
%        str2double(get(hObject,'String')) returns contents of Input_ParameterF as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_ParameterF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_ParameterF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                    DATE/STOPLOSS/PORTFOLIO INPUTS
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


function Input_StartDate_Callback(hObject, eventdata, handles)
% hObject    handle to Input_StartDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_StartDate as text
%        str2double(get(hObject,'String')) returns contents of Input_StartDate as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_StartDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_StartDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_EndDate_Callback(hObject, eventdata, handles)
% hObject    handle to Input_EndDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_EndDate as text
%        str2double(get(hObject,'String')) returns contents of Input_EndDate as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_EndDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_EndDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_Stoploss_Callback(hObject, eventdata, handles)
% hObject    handle to Input_Stoploss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_Stoploss as text
%        str2double(get(hObject,'String')) returns contents of Input_Stoploss as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_Stoploss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Stoploss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%===================


function Input_InitialPortfolio_Callback(hObject, eventdata, handles)
% hObject    handle to Input_InitialPortfolio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_InitialPortfolio as text
%        str2double(get(hObject,'String')) returns contents of Input_InitialPortfolio as a double
input = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input_InitialPortfolio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_InitialPortfolio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                            RADIO PANELS
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

%--------------------------------------------------------------------------
% PANEL 1

% --- Executes when selected object is changed in radiopanel1.
function radiopanel1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in radiopanel1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OptimizedParameter1Button = get(handles.radiopanel1,'SelectedObject');
OptimizedParameter1String = get(OptimizedParameter1Button, 'String');

set(handles.OptimizedParam1, 'String', OptimizedParameter1String)
%drawnow

OptimizedParameter2Button = get(handles.radiopanel2,'SelectedObject');
OptimizedParameter2String = get(OptimizedParameter2Button, 'String');

if strcmp(OptimizedParameter1String,OptimizedParameter2String)

%    set(handles.Input_opt2numofsteps, 'String', '0')
%    set(handles.Input_opt2lowerbound, 'String', '0')
%    set(handles.Input_opt2upperbound, 'String', '0')
    set(handles.Input_opt2numofsteps, 'enable', 'off')
    set(handles.Input_opt2lowerbound, 'enable', 'off')
    set(handles.Input_opt2upperbound, 'enable', 'off')
    
        if strcmp(OptimizedParameter1String, 'ParameterA')   
            set(handles.Input_ParameterA, 'enable', 'off')

            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on') 
            
        elseif strcmp(OptimizedParameter1String, 'ParameterB')    
            set(handles.Input_ParameterB, 'enable', 'off')

            set(handles.Input_ParameterA, 'enable', 'on')        
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on') 
            
        elseif strcmp(OptimizedParameter1String, 'ParameterC')
            set(handles.Input_ParameterC, 'enable', 'off') 

            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')             
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on')  
            
        elseif strcmp(OptimizedParameter1String,  'ParameterD')
            set(handles.Input_ParameterD, 'enable', 'off') 

            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')            
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on')
            
        elseif strcmp(OptimizedParameter1String, 'ParameterE') 
            set(handles.Input_ParameterE, 'enable', 'off') 

            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')         
            set(handles.Input_ParameterF, 'enable', 'on')
            
        elseif strcmp(OptimizedParameter1String,  'ParameterF')     
            set(handles.Input_ParameterF, 'enable', 'off')
            
            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')                 
            %set(handles.input_parameterb, 'string', '0.10')  
            
        end
        

else 
    
    
    set(handles.Input_ParameterA, 'enable', 'on')    
    set(handles.Input_ParameterB, 'enable', 'on')
    set(handles.Input_ParameterC, 'enable', 'on') 
    set(handles.Input_ParameterD, 'enable', 'on') 
    set(handles.Input_ParameterE, 'enable', 'on')   
    set(handles.Input_ParameterF, 'enable', 'on')
    
    set(handles.Input_opt2numofsteps, 'enable', 'on')
    set(handles.Input_opt2lowerbound, 'enable', 'on')
    set(handles.Input_opt2upperbound, 'enable', 'on')        
     
    
        if strcmp(OptimizedParameter1String, 'ParameterA') || strcmp(OptimizedParameter2String, 'ParameterA')   
            set(handles.Input_ParameterA, 'enable', 'off') 
        end
        
        if strcmp(OptimizedParameter1String, 'ParameterB') || strcmp(OptimizedParameter2String, 'ParameterB')   
            set(handles.Input_ParameterB, 'enable', 'off')
        end
        
        if strcmp(OptimizedParameter1String, 'ParameterC') || strcmp(OptimizedParameter2String, 'ParameterC')
            set(handles.Input_ParameterC, 'enable', 'off')   
        end
        
        if strcmp(OptimizedParameter1String,  'ParameterD') || strcmp(OptimizedParameter2String, 'ParameterD')
            set(handles.Input_ParameterD, 'enable', 'off') 
        end
        
        if strcmp(OptimizedParameter1String, 'ParameterE') || strcmp(OptimizedParameter2String, 'ParameterE')
            set(handles.Input_ParameterE, 'enable', 'off') 
        end
        
        if strcmp(OptimizedParameter1String,  'ParameterF') || strcmp(OptimizedParameter2String, 'ParameterF')     
            set(handles.Input_ParameterF, 'enable', 'off')     
        end
    
    
    
    
    
end        
        
guidata(hObject, handles);


%--------------------------------------------------------------------------
% PANEL 2


% --- Executes when selected object is changed in radiopanel2.
function radiopanel2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in radiopanel2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OptimizedParameter1Button = get(handles.radiopanel1,'SelectedObject');
OptimizedParameter1String = get(OptimizedParameter1Button, 'String');

OptimizedParameter2Button = get(handles.radiopanel2,'SelectedObject');
OptimizedParameter2String = get(OptimizedParameter2Button, 'String');

set(handles.OptimizedParam2, 'String', OptimizedParameter2String)
%drawnow

if strcmp(OptimizedParameter1String,OptimizedParameter2String)
    
%    set(handles.Input_opt2numofsteps, 'String', '0')
%    set(handles.Input_opt2lowerbound, 'String', '0')
%    set(handles.Input_opt2upperbound, 'String', '0')    
    set(handles.Input_opt2numofsteps, 'enable', 'off')
    set(handles.Input_opt2lowerbound, 'enable', 'off')
    set(handles.Input_opt2upperbound, 'enable', 'off')
    
        if strcmp(OptimizedParameter2String, 'ParameterA')   
            set(handles.Input_ParameterA, 'enable', 'off')

            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on') 
            
        elseif strcmp(OptimizedParameter2String, 'ParameterB')    
            set(handles.Input_ParameterB, 'enable', 'off')

            set(handles.Input_ParameterA, 'enable', 'on')        
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on') 

        elseif strcmp(OptimizedParameter2String, 'ParameterC')
            set(handles.Input_ParameterC, 'enable', 'off') 

            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')             
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on')  

        elseif strcmp(OptimizedParameter2String,  'ParameterD')
            set(handles.Input_ParameterD, 'enable', 'off') 

            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')            
            set(handles.Input_ParameterE, 'enable', 'on')    
            set(handles.Input_ParameterF, 'enable', 'on')

        elseif strcmp(OptimizedParameter2String, 'ParameterE') 
            set(handles.Input_ParameterE, 'enable', 'off') 

            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')         
            set(handles.Input_ParameterF, 'enable', 'on')

        elseif strcmp(OptimizedParameter2String,  'ParameterF')     
            set(handles.Input_ParameterF, 'enable', 'off')
            
            set(handles.Input_ParameterA, 'enable', 'on') 
            set(handles.Input_ParameterB, 'enable', 'on')         
            set(handles.Input_ParameterC, 'enable', 'on')       
            set(handles.Input_ParameterD, 'enable', 'on')       
            set(handles.Input_ParameterE, 'enable', 'on')
            
        end
        

else
    
    set(handles.Input_ParameterA, 'enable', 'on')    
    set(handles.Input_ParameterB, 'enable', 'on')
    set(handles.Input_ParameterC, 'enable', 'on') 
    set(handles.Input_ParameterD, 'enable', 'on') 
    set(handles.Input_ParameterE, 'enable', 'on')   
    set(handles.Input_ParameterF, 'enable', 'on')    
    
    set(handles.Input_opt2numofsteps, 'enable', 'on')
    set(handles.Input_opt2lowerbound, 'enable', 'on')
    set(handles.Input_opt2upperbound, 'enable', 'on')     
    

        if strcmp(OptimizedParameter2String, 'ParameterA') || strcmp(OptimizedParameter1String, 'ParameterA')  
            set(handles.Input_ParameterA, 'enable', 'off') 
        end
        
        if strcmp(OptimizedParameter2String, 'ParameterB') || strcmp(OptimizedParameter1String, 'ParameterB')    
            set(handles.Input_ParameterB, 'enable', 'off')
        end
        
        if strcmp(OptimizedParameter2String, 'ParameterC') || strcmp(OptimizedParameter1String, 'ParameterC')
            set(handles.Input_ParameterC, 'enable', 'off')   
        end
        
        if strcmp(OptimizedParameter2String,  'ParameterD') || strcmp(OptimizedParameter1String, 'ParameterD')
            set(handles.Input_ParameterD, 'enable', 'off') 
        end
        
        if strcmp(OptimizedParameter2String, 'ParameterE') || strcmp(OptimizedParameter1String, 'ParameterE') 
            set(handles.Input_ParameterE, 'enable', 'off') 
        end
        
        if strcmp(OptimizedParameter2String,  'ParameterF') || strcmp(OptimizedParameter1String, 'ParameterF')     
            set(handles.Input_ParameterF, 'enable', 'off')     
        end    
    
    
end        
        
guidata(hObject, handles);








%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                            RUN BUTTON
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


% --- Executes on button press in Run_LO.

function Run_LO_Callback(hObject, eventdata, handles)
% hObject    handle to Run_LO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status_loading = 'Loading Data';
set(handles.status_GUI,'String',status_loading);
drawnow;
load('db_historicaldata.mat');


status_strategyrun = 'Strategy Running...';
%set(handles.status_GUI,'String',status_strategyrun);
%drawnow;

OptimizedParameter1Button = get(handles.radiopanel1,'SelectedObject');
OptimizedParameter1String = get(OptimizedParameter1Button, 'String');

OptimizedParameter2Button = get(handles.radiopanel2,'SelectedObject');
OptimizedParameter2String = get(OptimizedParameter2Button, 'String');

status_error4 = 'Error in LO code - Try again';
status_error3 = 'Setting default parameters';
status_error2 = 'Setting default dates';
status_error = 'Error Occurred - Check Dates';
status_start = 'Initialized';
status_run = 'Running';
status_end = 'Finished';
set(handles.status_GUI,'String',status_run);
%drawnow;
previousrun = get(handles.OutputTextBox,'String');
previousrun = previousrun(8:end);
previousrun = cellstr(previousrun);
previousrun = vertcat('Previous Run:',previousrun);
set(handles.OutputTextBox,'String', previousrun);    
%drawnow;

opt1numofsteps = get(handles.Input_opt1numofsteps,'String');
opt1lowerbound = get(handles.Input_opt1lowerbound,'String');
opt1upperbound = get(handles.Input_opt1upperbound,'String');

opt1numofsteps = str2num(opt1numofsteps);
opt1lowerbound = str2num(opt1lowerbound);
opt1upperbound = str2num(opt1upperbound);

opt2numofsteps = get(handles.Input_opt2numofsteps,'String');
opt2lowerbound = get(handles.Input_opt2lowerbound,'String');
opt2upperbound = get(handles.Input_opt2upperbound,'String');

opt2numofsteps = str2num(opt2numofsteps);
opt2lowerbound = str2num(opt2lowerbound);
opt2upperbound = str2num(opt2upperbound);




% the following is used to prevent opt 1 from being 0 (coincides with our
% strategy prime 


%if opt1lowerbound == 0 && opt1upperbound == 0 
%opt1lowerbound = 0.08;
%set(handles.Input_opt1lowerbound, 'String',opt1lowerbound);
%end


% the above should be changed and more logic applied



    

%----------------------------------------------------
% deal with the dates!!!

         startdate_string = get(handles.Input_StartDate,'String');
         enddate_string = get(handles.Input_EndDate,'String');

         
try
TradeDate = evalin('base','TradeDate');   
SERIAL_DATE_DATA = evalin('base','SERIAL_DATE_DATA'); 
TradeDate_NumFormat = evalin('base','TradeDate_NumFormat'); 
catch
load('db_tradedate.mat');  
end   


db_startdate = TradeDate(1);
db_enddate = TradeDate(end);

db_startdate = datestr(datetime(db_startdate, 'Format', 'MM/dd/yyyy'),'mm/dd/yyyy');
db_enddate = datestr(datetime(db_enddate, 'Format', 'MM/dd/yyyy'),'mm/dd/yyyy');

         if strcmp (startdate_string, 'MM/DD/YYYY') || strcmp (enddate_string , 'MM/DD/YYYY') || isempty(startdate_string) || isempty(enddate_string)
             set(handles.status_GUI,'String',status_error);
             warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday'); 
             pause(2)
             set(handles.status_GUI,'String',status_error2);
             set(handles.Input_StartDate,'String', db_startdate);
             set(handles.Input_EndDate,'String', db_enddate);             
             pause(2)
             clc
             set(handles.OutputTextBox,'String', '');
             set(handles.status_GUI,'String',status_start);
             startdate_string = db_startdate;
             enddate_string = db_enddate;
             %drawnow;
         %return;
         end
            
         %check if Db startdate is same as startdatestring(from GUI) if so,
         %then we must initialize the yesterdays variables, else, if they
         %are different, we set yesterdays variables equal to the values
         %from the previous trading day.
         %*********************************************
if strcmp(db_startdate,startdate_string)         
isfirstday = 1;
else
isfirstday = 0;
end
         %**********************************************
         
         
         Serial_startdate_actual = datenum(startdate_string,'mm/dd/yyyy');
         Serial_enddate_actual = datenum(enddate_string,'mm/dd/yyyy');
         
         datecheck = 1; 
         %beginningdate = db_startdate; 
         %finaldate = db_enddate;
         
         if Serial_startdate_actual < datenum(db_startdate,'mm/dd/yyyy');
         datecheck = 0;
         end
         if Serial_enddate_actual > datenum(db_enddate,'mm/dd/yyyy');
         datecheck = 0;
         end
         
        ProperDates = isbusday(Serial_startdate_actual) && isbusday(Serial_enddate_actual) && datecheck == 1 ;

          if ProperDates == 0
             set(handles.status_GUI,'String',status_error);
             warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday'); 
             pause(2)
             clc
             set(handles.status_GUI,'String',status_start);
             set(handles.OutputTextBox,'String', '');
             %drawnow;
             return;
             
          end        

%----------------------------------------------------

isWFA = get(handles.checkbox_wfa, 'Value');
isMA = get(handles.checkbox_MA, 'Value');
%try
%isWFA = evalin('base','isWFA'); 
%isWFA = get(handles.checkbox_wfa, 'Value');
%catch
%disp('shit is fucked, isWFA flag not working')
%automatically check the isWFA check box
%isWFA = 1;
%end
%if isWFA == 1 


%start WFA here toad
if isWFA == 1
DaysInSample = get(handles.edit_wfaperiod,'String');
DaysInSample = str2num(DaysInSample);
    if isempty(DaysInSample)
       DaysInSample = 150;
    end   
PercentOutofSample = get(handles.edit_wfasample,'String');
PercentOutofSample = str2num(PercentOutofSample);
    if isempty(PercentOutofSample)
        PercentOutofSample = 25;
    end   
PercentOutofSample = PercentOutofSample * .01;

DaysOutSample = floor(PercentOutofSample * DaysInSample);

TradeDateSerial = datenum(TradeDate);

startdate = datefind(Serial_startdate_actual,TradeDateSerial);
enddate = datefind(Serial_enddate_actual,TradeDateSerial);

NumOfTradeDays = enddate - startdate;
%NumOfTradeDays = enddate - startdate ;
startdateOutofSample = startdate +DaysInSample;
TradeDateOutofSample = TradeDate_NumFormat;
TradeDateOutofSample = TradeDateOutofSample(startdateOutofSample:enddate);
WFAstartdate_serial = TradeDateSerial(startdateOutofSample);
WFAenddate_serial = TradeDateSerial(enddate);
WFAdatediff = NumOfTradeDays - DaysInSample;

NumOfPeriods = ceil(WFAdatediff ./ DaysOutSample);
startwfaperiodindex = 1;

    for i = 1:NumOfPeriods
        if i == 1
        WFAdateindexrange(i,1) = startwfaperiodindex;
        WFAdateindexrange(i,2) = DaysInSample + startwfaperiodindex -1; 
        WFAdateindexrange(i,3) = WFAdateindexrange(i,2) + 1; 
        WFAdateindexrange(i,4) = WFAdateindexrange(i,3) + DaysOutSample - 1;         
        else
        WFAdateindexrange(i,1) = WFAdateindexrange(i-1,1) + DaysOutSample;
        WFAdateindexrange(i,2) = WFAdateindexrange(i,1) + DaysInSample - 1; 
        WFAdateindexrange(i,3) = WFAdateindexrange(i,2) + 1;
            if i == NumOfPeriods
                WFAdateindexrange(i,4) = enddate;        
            else
                WFAdateindexrange(i,4) = WFAdateindexrange(i,3) + DaysOutSample - 1;
            end    
        end


        WFAdaterange(i,1) = TradeDateSerial(WFAdateindexrange(i,1)+ startdate - 1);
        WFAdaterange(i,2) = TradeDateSerial(WFAdateindexrange(i,2)+ startdate - 1); 
        WFAdaterange(i,3) = TradeDateSerial(WFAdateindexrange(i,3)+ startdate - 1);
            if i == NumOfPeriods
                WFAdaterange(i,4) = TradeDateSerial(enddate);        
            else
                WFAdaterange(i,4) = TradeDateSerial(WFAdateindexrange(i,4)+ startdate - 1);
            end    

        
        
    end    
else
    disp('isWFA not checked');
end


%----------------------------------------------------

stoploss_string = get(handles.Input_Stoploss,'String');
StopLoss = str2num(stoploss_string);

initialportfolio_string = get(handles.Input_InitialPortfolio,'String');
initialportfolio = str2num(initialportfolio_string);

Commission_string = get(handles.Input_Commission,'String');
Commission = str2num(Commission_string);

ParameterA = get(handles.Input_ParameterA,'String');
ParameterB = get(handles.Input_ParameterB,'String');
ParameterC = get(handles.Input_ParameterC,'String');
ParameterD = get(handles.Input_ParameterD,'String');
ParameterE = get(handles.Input_ParameterE,'String');
ParameterF = get(handles.Input_ParameterF,'String');

ParameterA = str2num(ParameterA);
ParameterB = str2num(ParameterB);
ParameterC = str2num(ParameterC);
ParameterD = str2num(ParameterD);
ParameterE = str2num(ParameterE);
ParameterF = str2num(ParameterF);

if ParameterA == 0 && ParameterB == 0 && ParameterC == 0 && ParameterD == 0 && ParameterE == 0 && ParameterF == 0

    
ParameterA = 0.08;
ParameterB = 0.1;
ParameterC = 0.035;
ParameterD = 0.1;
ParameterE = -0.05;
ParameterF = 0;

set(handles.status_GUI,'String',status_error3);
             
set(handles.Input_ParameterA,'String',ParameterA);
set(handles.Input_ParameterB,'String',ParameterB);
set(handles.Input_ParameterC,'String',ParameterC);
set(handles.Input_ParameterD,'String',ParameterD);
set(handles.Input_ParameterE,'String',ParameterE);
set(handles.Input_ParameterF,'String',ParameterF);

pause(.5)

set(handles.status_GUI,'String',status_start);
drawnow;
end


try
StrategyPath = handles.StrategyPath;
SelectedStrategy = handles.SelectedStrategy;
catch
StrategyPath = 'C:\Program Files\MATLAB\MATLAB Production Server\R2015a\bin\Gouldii_root';
SelectedStrategy = 'Gouldii_Strategy_BuyandHold_v2.m';
set(handles.Static_Strategy,'String',SelectedStrategy);
set(handles.Static_StrategyPath,'String',StrategyPath);
end
set(handles.status_GUI,'String',status_strategyrun);
drawnow;






% IN LOOP FOR WFA, we must check the value of the previous signal variable
% sigprevious. It should be inside the loop at the very end so the next
% date range inputs its value into the LO code.

%have to figure out how to set this correctly:
try
sigprevious = evalin('base','sigprevious'); 
catch
sigprevious = 0;
disp('error while trying to evalin sigprevious, set to 0, investigate if this is okay.?.!?.');
end





%disp('starting isWFA check now...');

% -------------------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------
%                           WFA 
% -------------------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------


if isWFA == 1

    
 %--------------------------------------------------------------------------------------------------------------
 % start of WFA loop
    for i = 1:NumOfPeriods
        
        %-------
        
        %deal with dates here! 
        Serial_startdate_actual =  WFAdaterange(i,1);

        Serial_enddate_actual = WFAdaterange(i,2);   
          
        %------
%if i == 15
%pause(1);
%end

%if i == 16
%pause(1);
%end
        try
             [TotalLinearOpt,sigprevious,OptParameterA,OptParameterB,OptParameterC,OptParameterD,OptParameterE,OptParameterF,OptMaxDD,OptNetProfit,OptSharpeRatio,OptAnnualizedReturn,isfirstday,cashonweekendsflag,output] = Gouldii_SignalsLinearOptimizer_v2(StrategyPath, SelectedStrategy, Commission, initialportfolio, StopLoss,Serial_startdate_actual,Serial_enddate_actual,OptimizedParameter1String,opt1numofsteps,opt1lowerbound,opt1upperbound,OptimizedParameter2String,opt2numofsteps,opt2lowerbound,opt2upperbound,ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,isfirstday,startdate_string,sigprevious,isWFA);
               
           
            % ERROR IN ATTEMPT TO RUN LO CODE
        catch
             disp('Error in LO code running WFA, error on run#');
             disp(num2str(i));
            set(handles.status_GUI,'String',status_error4);
            drawnow; 
            pause(3.2);
            set(handles.status_GUI,'String',status_start);
            drawnow; 
        end

            assignin('base','sigprevious',sigprevious);
try
            CONTANGO = evalin('base','CONTANGO');
            CONTANGO30 = evalin('base','CONTANGO30');
            TargetWeightVX1_S30 = evalin('base','TargetWeightVX1_S30');
            TargetWeightVX2_S30 = evalin('base','TargetWeightVX2_S30');
            TargetWeightVX1_S45 = evalin('base','TargetWeightVX1_S45');
            TargetWeightVX2_S45 = evalin('base','TargetWeightVX2_S45');
            curve_tickers = evalin('base','curve_tickers');        
catch
   disp('the problem is with the evalin for the strategy inputs'); 
end    
        ParameterA = OptParameterA;
        ParameterB = OptParameterB;
        ParameterC = OptParameterC;
        ParameterD = OptParameterD;
        ParameterE = OptParameterE;
        ParameterF = OptParameterF;
        y_sig = sigprevious;
        Serial_startdate = WFAdaterange(i,3);
        Serial_enddate = WFAdaterange(i,4);
        
        WFAoptparams(i,1) = OptParameterA;
        WFAoptparams(i,2) = OptParameterB;
        WFAoptparams(i,3) = OptParameterC;
        WFAoptparams(i,4) = OptParameterD;
        WFAoptparams(i,5) = OptParameterE;
        WFAoptparams(i,6) = OptParameterF;
        WFAoptparams(i,7) = y_sig;
        
        WFAoptoutput{i,1} = output;
        WFAoptoutput{i,2} = datestr(WFAdaterange(i,1),'mm/dd/yyyy');
        WFAoptoutput{i,3} = datestr(WFAdaterange(i,2),'mm/dd/yyyy');
        WFAoptoutput{i,4} = datestr(WFAdaterange(i,3),'mm/dd/yyyy');
        WFAoptoutput{i,5} = datestr(WFAdaterange(i,4),'mm/dd/yyyy');
        WFAoptoutput{i,6} = TotalLinearOpt;
        WFAoptoutput{i,7} = OptParameterA; 
        WFAoptoutput{i,8} = OptParameterB;
        WFAoptoutput{i,9} = OptParameterC;
        WFAoptoutput{i,10} = OptParameterD;
        WFAoptoutput{i,11} = OptParameterE;
        WFAoptoutput{i,12} = OptParameterF;
        WFAoptoutput{i,13} = y_sig;


    if isfirstday == 1
        %disp('this is the first day of the database');
        y_CONTANGO = 0;
        y_CONTANGO30 = 0;
        y_sig = 0;

    elseif isfirstday == 0
        previoustradedate = busdate(Serial_startdate_actual,-1);    
        previoustradedate_Index = datefind(previoustradedate,SERIAL_DATE_DATA);    
        y_CONTANGO = 0;
        y_CONTANGO30 = 0;
        % ONLY DO THE FOLLOWING LINE IF isWFA is checked!! otherwise, y_sig = 0.
        % *this will prevent us from using yesterdays signal when we dont want to.
        % We only want to use yesterdays signal when running wfa.
        y_sig = sigprevious;
    end
    
  
    
    %datefind again... n OUT OF SAMPLE PERIOD
    Serial_startdate = datefind(Serial_startdate,TradeDateSerial);
    Serial_enddate = datefind(Serial_enddate,TradeDateSerial);
    
    
                SelectedStrategy_temp = SelectedStrategy(1:end-2);
                SelectedStrategy_input = str2func(SelectedStrategy_temp);
    
                                                                            
 %call strategy to calculate signals for OutofSample period
                [sigprevious,sigw1,sigw2,ticker1,ticker2] = feval(SelectedStrategy_input,Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,...
                                                                  ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,...
                                                                  TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO,...
                                                                  VIX_VIX3M,VIX_VIX6M,VIX9D_VIX,VIX_ma50d,VIX9D_ma50d,VIX9D_VIX_ma50d,VIX_ma20d,VIX_ma200d,VIX);                                                                    
                                                                            
if i == 1
    WFAsigw1 = sigw1;
    WFAsigw2 = sigw2;
    WFAticker1 = ticker1;
    WFAticker2 = ticker2;
else
    WFAsigw1 = vertcat(WFAsigw1,sigw1);
    WFAsigw2 = vertcat(WFAsigw2,sigw2);
    WFAticker1 = vertcat(WFAticker1,ticker1);
    WFAticker2 = vertcat(WFAticker2,ticker2);
end    
            


 wfacount = num2str(i);
 wfaperiods = num2str(NumOfPeriods);
 statuswfa = strcat('End of run_', wfacount, ' of total_', wfaperiods, ' number of runs');
 %statuswfa = strcat('End of run ', wfacount);
 %statuswfa = strcat(statuswfa,'of total',' ');
 %statuswfa = strcat(statuswfa,wfaperiods);
 %statuswfa = strcat(statuswfa,' number of runs');
 disp(statuswfa);
    end
 %--------------------------------------------------------------------------------------------------------------
 % end of WFA loop

    
            assignin('base','WFAoptparams',WFAoptparams);
%            assignin('base','TradeDateOutofSample',TradeDateOutofSample);
            assignin('base','WFAsigw1',WFAsigw1);
            assignin('base','WFAsigw2',WFAsigw2);
            assignin('base','WFAticker1',WFAticker1);
            assignin('base','WFAticker2',WFAticker2);   
            %evalin('base',cashonweekendsflag);            
    
    
            WFAsignals(:,1) = TradeDateOutofSample;
            WFAsignals(:,2) = WFAsigw1;
            WFAsignals(:,3) = WFAsigw2;

            assignin('base','WFAsignals',WFAsignals);
            

            % Trades and Performance input parameters below!!
sigw1 = WFAsigw1;
sigw2 = WFAsigw2;
% ************************************************************
% set out of sample date range
% **************************************************************
Serial_enddate = enddate;
Serial_startdate = startdateOutofSample;
ticker1 = WFAticker1;
ticker2 = WFAticker2;
try
                WFAfinaloutput = Gouldii_TradesPerformanceFunction_v2(Commission,initialportfolio,Serial_enddate,Serial_startdate,VIX, sigw1,sigw2,ticker1,ticker2, SERIAL_DATE_DATA,...
                                                                    TargetWeightVX1_S30, TargetWeightVX2_S30, TradeDate, ExpDates, curve_tickers,...
                                                                    TradeDate_NumFormat,T1,T2,StopLoss,TradeDay,CONTANGO, CONTANGO30, ROLL_YIELD,...
                                                                    VX1_close,VX1_open,VX1_high,VX1_low,VX2_close,VX2_open,VX2_high,VX2_low,VX1_settle,VX2_settle,cashonweekendsflag);
catch
disp('Error occurs in GUI code while trying to run T&P code');
end
            assignin('base','WFAfinaloutput',WFAfinaloutput);   
            assignin('base','WFAoptoutput',WFAoptoutput); 
%            assignin('base','buyandholdsigw1',buyandholdsigw1);             
%            assignin('base','buyandholdsigw2',buyandholdsigw2); 
            now = datetime('now','Format','yyyyMMdd_HHmmss');
            now = datestr(now,'yyyymmdd_HHMMss');            

selectedstrategy = SelectedStrategy(1:end-2);
strategypath = StrategyPath(1:end-11);
strategypath = strcat(strategypath,'Reference\');
strategypath = strcat(strategypath,selectedstrategy,'\');
WFAstrategypath = strcat(strategypath,'WFA\');    
WFAstrategypath = strcat(WFAstrategypath,'WFAoutput_',now,'.xlsx');            
            

NetLiqTotal = WFAfinaloutput(3:end,30);
SharpeRatio = cell2mat(WFAfinaloutput(end,47));
CummRORcell = WFAfinaloutput(end,46);
CummROR = cell2mat(CummRORcell);
NetProfit = cell2mat(NetLiqTotal(end)) - cell2mat(NetLiqTotal(1));
NetLiqTotaldoubles = cell2mat(NetLiqTotal);

[MaxDD,MaxDDindex] = maxdrawdown(NetLiqTotaldoubles);

AnnualizedReturn = (((1+CummROR))^(365/length(WFAsigw1)))-1;


disp('Sharpe Ratio for OutOfSample Run:');
disp(SharpeRatio);
disp('NetProfit for OutOfSample Run:');
disp(NetProfit);
disp('AnnualizedReturn for OutOfSample Run:');
disp(AnnualizedReturn);
disp('Max Drawdown for OutOfSample Run:');
disp(MaxDD);



% BUY AND HOLD FOR WFA GRAPHING

                    StopLoss = 100;
                    cashonweekendsflag = 0;
                    
    %call strategy for buyandhold graphing 
    [sigprevious,sigw1,sigw2,ticker1,ticker2] = Gouldii_Strategy_BuyandHold_v2(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,...
                                                                                ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,...
                                                                                TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO,...
                                                                                VIX_VIX3M,VIX_VIX6M,VIX9D_VIX,VIX_ma50d,VIX9D_ma50d,VIX9D_VIX_ma50d,VIX_ma20d,VIX_ma200d,VIX);
       
       
try
                Buyandholdfinaloutput = Gouldii_TradesPerformanceFunction_v2(Commission,initialportfolio,Serial_enddate,Serial_startdate,VIX, sigw1,sigw2,ticker1,ticker2, SERIAL_DATE_DATA,...
                                                                    TargetWeightVX1_S30, TargetWeightVX2_S30, TradeDate, ExpDates, curve_tickers,...
                                                                    TradeDate_NumFormat,T1,T2,StopLoss,TradeDay,CONTANGO, CONTANGO30, ROLL_YIELD,...
                                                                    VX1_close,VX1_open,VX1_high,VX1_low,VX2_close,VX2_open,VX2_high,VX2_low,VX1_settle,VX2_settle,cashonweekendsflag);
catch
disp('Error occurs in GUI code while trying to run T&P code');
end


BuyandholdNetLiqTotal = Buyandholdfinaloutput(3:end,30);
BuyandholdSharpeRatio = cell2mat(Buyandholdfinaloutput(end,47));
BuyandholdCummRORcell = Buyandholdfinaloutput(end,46);
BuyandholdCummROR = cell2mat(BuyandholdCummRORcell);
BuyandholdNetProfit = cell2mat(BuyandholdNetLiqTotal(end)) - cell2mat(BuyandholdNetLiqTotal(1));
BuyandholdNetLiqTotaldoubles = cell2mat(BuyandholdNetLiqTotal);

[BuyandholdMaxDD,BuyandholdMaxDDindex] = maxdrawdown(BuyandholdNetLiqTotaldoubles);

BuyandholdAnnualizedReturn = (((1+BuyandholdCummROR))^(365/length(sigw1)))-1;

                                    disp('Running BuyandHold strategy for graphing');
                                    
disp('Sharpe Ratio for BuyandHold Run:');
disp(BuyandholdSharpeRatio);
disp('NetProfit for BuyandHold Run:');
disp(BuyandholdNetProfit);
disp('AnnualizedReturn for BuyandHold Run:');
disp(BuyandholdAnnualizedReturn);
disp('Max Drawdown for BuyandHold Run:');
disp(BuyandholdMaxDD);





 %       NetLiqTotalBuyAndHold_Returns = tick2ret(BuyandholdNetLiqTotaldoubles);
 %       NetLiqTotalBuyAndHold_Scaled = ret2price(NetLiqTotalBuyAndHold_Returns,initialportfolio,1,1,'Periodic');
        TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);
        figure(40) 
       % yyaxis left        
        plot(TradeDate,BuyandholdNetLiqTotaldoubles,'g');
        set(gca,'YScale','log')
        hold on
        plot(TradeDate,NetLiqTotaldoubles);
        hold off
        
disp('WFA complete');
 try
 xlswrite(WFAstrategypath,WFAfinaloutput);

 catch
disp('your shit is fucked, wont save excel');
 end

            
% END OF WFA CODE                
            
 
 
 
 
 
 
 
% =========================================================================            
% ==========================  LO only!  (NOT WFA)  ========================
% =========================================================================

else
    
%the following code is run if NOT using WFA
%

                                    try
                                     [TotalLinearOpt,sigprevious,OptParameterA,OptParameterB,OptParameterC,OptParameterD,OptParameterE,OptParameterF,OptMaxDD,OptNetProfit,OptSharpeRatio,OptAnnualizedReturn,isfirstday,cashonweekendsflag,output] = Gouldii_SignalsLinearOptimizer_v2(StrategyPath, SelectedStrategy, Commission, initialportfolio, StopLoss,Serial_startdate_actual,Serial_enddate_actual,OptimizedParameter1String,opt1numofsteps,opt1lowerbound,opt1upperbound,OptimizedParameter2String,opt2numofsteps,opt2lowerbound,opt2upperbound,ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,isfirstday,startdate_string,sigprevious,isWFA);

                                    %disp('The final trading day signal from previous run:');
                                    %disp(sigprevious)
                                    assignin('base','sigprevious',sigprevious);                                    
                                                                  
LOoutput = output;  

LONetLiqTotal = output(3:end,30);
LOSharpeRatio = cell2mat(output(end,47));
LOCummRORcell = output(end,46);
LOCummROR = cell2mat(LOCummRORcell);
LONetProfit = cell2mat(LONetLiqTotal(end)) - cell2mat(LONetLiqTotal(1));
LONetLiqTotaldoubles = cell2mat(LONetLiqTotal);

[LOMaxDD,LOMaxDDindex] = maxdrawdown(LONetLiqTotaldoubles);

LOAnnualizedReturn = (((1+LOCummROR))^(365/length(LONetLiqTotal)))-1;


disp('Sharpe Ratio for LO Run:');
disp(LOSharpeRatio);
disp('NetProfit for LO Run:');
disp(LONetProfit);
disp('AnnualizedReturn for LO Run:');
disp(LOAnnualizedReturn);
disp('Max Drawdown for LO Run:');
disp(LOMaxDD);                                  
                                    
                                    
                                    
                                    
                                    
                                    %GUI updates and output
                                    %-----------------------------------------------------------------------------------------
                                                set(handles.Input_ParameterA, 'String', OptParameterA) 
                                                set(handles.Input_ParameterB, 'String', OptParameterB)         
                                                set(handles.Input_ParameterC, 'String', OptParameterC)       
                                                set(handles.Input_ParameterD, 'String', OptParameterD)       
                                                set(handles.Input_ParameterE, 'String', OptParameterE)    
                                                set(handles.Input_ParameterF,'String', OptParameterF) 


                                    opt1output = sprintf('ParameterA = %.3f',OptParameterA);
                                    opt2output = sprintf('ParameterB = %.3f',OptParameterB);   
                                    opt3output = sprintf('ParameterC = %.3f',OptParameterC);        
                                    opt4output = sprintf('ParameterD = %.3f',OptParameterD);
                                    opt5output = sprintf('ParameterE = %.3f',OptParameterE);
                                    opt6output = sprintf('ParameterF = %.3f',OptParameterF);
                                    opt7output = sprintf('MaxDD = %.3f', OptMaxDD);
                                    opt8output = sprintf('NetProfit = %.1f', OptNetProfit);
                                    opt9output = sprintf('SharpeRatio = %.3f', OptSharpeRatio);
                                    opt10output = sprintf('AnnualizedReturn = %.3f', OptAnnualizedReturn);

                                    resultstitle = cellstr('Optimal Results:');


                                    outputstring = {opt1output;
                                                    opt2output;
                                                    opt3output;
                                                    opt4output;
                                                    opt5output;
                                                    opt6output;
                                                    opt7output;
                                                    opt8output;
                                                    opt9output;
                                                    opt10output};

                                    outputstring = vertcat(resultstitle, outputstring);

                                    xlswrite('LinearOptParams.xlsx',outputstring);
                                    %-----------------------------------------------------------------------------------------


                                    
                                    
                                    
                                    
                                    
                                    
% STUPID MA shit

if isMA == 1
    
SelectedStrategy_temp = SelectedStrategy(1:end-2);
stratpath = 'C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\';
strategypath = strcat(stratpath, SelectedStrategy_temp, '\');
strategypathOptParams = strcat(strategypath,'OptParams\');

now = datetime('now','Format','yyyyMMdd_HHmmss');
now = datestr(now,'yyyymmdd_HHMMss');
sdate = datestr(Serial_startdate_actual,'yyyymmdd');
edate = datestr(Serial_enddate_actual,'yyyymmdd');

strategypath_optparams = strcat(strategypathOptParams,sdate,'_',edate,'_');
strategypath_optparams = strcat(strategypath_optparams,'OptParamsMovingAverages_',now,'.xlsx');

ParamAisInt = mod(OptParameterA,1) == 0;
ParamBisInt = mod(OptParameterB,1) == 0;
ParamCisInt = mod(OptParameterC,1) == 0;
ParamDisInt = mod(OptParameterD,1) == 0;
ParamEisInt = mod(OptParameterE,1) == 0;
ParamFisInt = mod(OptParameterF,1) == 0;

if ParamAisInt == 1 && OptParameterA ~= 0
%calc moving average
VIX_maA = tsmovavg(VIX,'s',OptParameterA,1);
else
VIX_maA = zeros(length(VIX),1);    
end 

if ParamBisInt == 1 && OptParameterB ~= 0
%calc moving average
VIX_maB = tsmovavg(VIX,'s',OptParameterB,1);
else
VIX_maB = zeros(length(VIX),1);    
end

if ParamCisInt == 1 && OptParameterC ~= 0
%calc moving average
VIX_maC = tsmovavg(VIX,'s',OptParameterC,1);
else
VIX_maC = zeros(length(VIX),1);    
end 

if ParamDisInt == 1 && OptParameterD ~= 0
%calc moving average
VIX_maD = tsmovavg(VIX,'s',OptParameterD,1);
else
VIX_maD = zeros(length(VIX),1);    
end

if ParamEisInt == 1 && OptParameterE ~= 0
%calc moving average
VIX_maE = tsmovavg(VIX,'s',OptParameterE,1);
else
VIX_maE = zeros(length(VIX),1);    
end 

if ParamFisInt == 1 && OptParameterF ~= 0
%calc moving average
VIX_maF = tsmovavg(VIX,'s',OptParameterF,1);
else
VIX_maF = zeros(length(VIX),1);    
end

VIX_maX = [TradeDate_NumFormat,VIX_maA,VIX_maB,VIX_maC,VIX_maD,VIX_maE,VIX_maF];

            xlswrite(strategypath_optparams,VIX_maX);  
 
            disp('Optimized Moving Averages');
end


                                    
                                    
                                    previousrun = get(handles.OutputTextBox,'String');
                                    set(handles.PreviousTextbox,'String', previousrun);

                                    set(handles.OutputTextBox,'String', outputstring)             

                                    disp('Running BuyandHold strategy for graphing');
SelectedStrategy = 'Gouldii_Strategy_BuyandHold_v2.m';
%run buyandhold for LO graphing                                    
                                     [TotalLinearOpt,sigprevious,OptParameterA,OptParameterB,OptParameterC,OptParameterD,OptParameterE,OptParameterF,OptMaxDD,OptNetProfit,OptSharpeRatio,OptAnnualizedReturn,isfirstday,cashonweekendsflag,output] = Gouldii_SignalsLinearOptimizer_v2(StrategyPath, SelectedStrategy, Commission, initialportfolio, StopLoss,Serial_startdate_actual,Serial_enddate_actual,OptimizedParameter1String,0,0,0,OptimizedParameter2String,0,0,0,ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,isfirstday,startdate_string,sigprevious,isWFA);
                                    


BuyandholdNetLiqTotal = output(3:end,30);
BuyandholdSharpeRatio = cell2mat(output(end,47));
BuyandholdCummRORcell = output(end,46);
BuyandholdCummROR = cell2mat(BuyandholdCummRORcell);
BuyandholdNetProfit = cell2mat(BuyandholdNetLiqTotal(end)) - cell2mat(BuyandholdNetLiqTotal(1));
BuyandholdNetLiqTotaldoubles = cell2mat(BuyandholdNetLiqTotal);

[BuyandholdMaxDD,BuyandholdMaxDDindex] = maxdrawdown(BuyandholdNetLiqTotaldoubles);

BuyandholdAnnualizedReturn = (((1+BuyandholdCummROR))^(365/length(BuyandholdNetLiqTotal)))-1;


disp('Sharpe Ratio for Buyandhold Run:');
disp(BuyandholdSharpeRatio);
disp('NetProfit for Buyandhold Run:');
disp(BuyandholdNetProfit);
disp('AnnualizedReturn for Buyandhold Run:');
disp(BuyandholdAnnualizedReturn);
disp('Max Drawdown for Buyandhold Run:');
disp(BuyandholdMaxDD); 
            

                                   % ERROR IN ATTEMPT TO RUN LO CODE
                                    catch
                                     disp('Error in LO code not WFA');
                                    set(handles.status_GUI,'String',status_error4);
                                    drawnow; 
                                    pause(3.2);
                                    set(handles.status_GUI,'String',status_start);
                                    drawnow; 
                                    end

    %datefind again...
    Serial_startdate = datefind(Serial_startdate_actual,SERIAL_DATE_DATA);
    Serial_enddate = datefind(Serial_enddate_actual,SERIAL_DATE_DATA);   
           TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);   
 if isMA == 1   
        figure(40)   
        plot(TradeDate,BuyandholdNetLiqTotaldoubles,'g');
        set(gca,'YScale','log')
        hold on
        plotyy(TradeDate,LONetLiqTotaldoubles,TradeDate,[VIX(Serial_startdate:Serial_enddate),VIX_maA(Serial_startdate:Serial_enddate),VIX_maB(Serial_startdate:Serial_enddate),VIX_maC(Serial_startdate:Serial_enddate),VIX_maD(Serial_startdate:Serial_enddate),VIX_maE(Serial_startdate:Serial_enddate),VIX_maF(Serial_startdate:Serial_enddate)]);

     %   plotyy(TradeDate,LONetLiqTotaldoubles,TradeDate,VIX9D_VIX(Serial_startdate:Serial_enddate));
     %   plot(TradeDate,LONetLiqTotaldoubles);   
     hold off
 else
        figure(40)   
        plot(TradeDate,BuyandholdNetLiqTotaldoubles,'g');
        set(gca,'YScale','log')
        hold on
     %   plotyy(TradeDate,LONetLiqTotaldoubles,TradeDate,[VIX(Serial_startdate:Serial_enddate),VIX_maA(Serial_startdate:Serial_enddate),VIX_maB(Serial_startdate:Serial_enddate),VIX_maC(Serial_startdate:Serial_enddate),VIX_maD(Serial_startdate:Serial_enddate),VIX_maE(Serial_startdate:Serial_enddate),VIX_maF(Serial_startdate:Serial_enddate)]);

     %   plotyy(TradeDate,LONetLiqTotaldoubles,TradeDate,VIX9D_VIX(Serial_startdate:Serial_enddate));
        plot(TradeDate,LONetLiqTotaldoubles);   
     hold off   
 end
     set(handles.status_GUI,'String',status_end);
                                    pause(3)
                                    set(handles.status_GUI,'String',status_start);
                                    guidata(hObject, handles);
xlswrite('LinearOptResults.xlsx',TotalLinearOpt);                                    
% end of run                                    
end

% STUPID MA shit









% --- Executes on button press in Strategy_button.
function Strategy_button_Callback(hObject, eventdata, handles)
% hObject    handle to Strategy_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[FileName,PathName] = uigetfile('*.m','Select a strategy');
[FileName,PathName] = uigetfile(fullfile(pwd,'Strategies','Select a strategy'));
SelectedStrategy = FileName;
StrategyPath = PathName;

handles.SelectedStrategy = SelectedStrategy;
handles.StrategyPath = StrategyPath;

set(handles.Static_Strategy,'String',SelectedStrategy);
set(handles.Static_StrategyPath,'String',StrategyPath);

guidata(hObject, handles);



function Input_Commission_Callback(hObject, eventdata, handles)
% hObject    handle to Input_Commission (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_Commission as text
%        str2double(get(hObject,'String')) returns contents of Input_Commission as a double
input = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Input_Commission_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Commission (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Stop_button.
function Stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in createstrategy_button.
function createstrategy_button_Callback(hObject, eventdata, handles)
% hObject    handle to createstrategy_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('Gouldii_CreateNewStrategy.m');




function edit_wfaperiod_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wfaperiod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wfaperiod as text
%        str2double(get(hObject,'String')) returns contents of edit_wfaperiod as a double


% --- Executes during object creation, after setting all properties.
function edit_wfaperiod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wfaperiod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox_wfa.
function checkbox_wfa_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_wfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_wfa

ischecked = get(hObject,'Value');

if ischecked == 1
set(handles.edit_wfaperiod, 'enable', 'on')
set(handles.edit_wfasample, 'enable', 'on') 
elseif ischecked == 0
set(handles.edit_wfaperiod, 'enable', 'off')
set(handles.edit_wfasample, 'enable', 'off')   
end    
assignin('base','isWFA',ischecked);





function edit_wfasample_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wfasample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wfasample as text
%        str2double(get(hObject,'String')) returns contents of edit_wfasample as a double


% --- Executes during object creation, after setting all properties.
function edit_wfasample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wfasample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_MA.
function checkbox_MA_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_MA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_MA
ischecked_MA = get(hObject,'Value');

%if ischecked_MA == 1
%set(handles.edit_wfaperiod, 'enable', 'on')
%set(handles.edit_wfasample, 'enable', 'on') 
%elseif ischecked_MA == 0
%set(handles.edit_wfaperiod, 'enable', 'off')
%set(handles.edit_wfasample, 'enable', 'off')   
%end    
assignin('base','isMA',ischecked_MA);
