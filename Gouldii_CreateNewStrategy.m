function varargout = Gouldii_CreateNewStrategy(varargin)
% GOULDII_CREATENEWSTRATEGY MATLAB code for Gouldii_CreateNewStrategy.fig
%      GOULDII_CREATENEWSTRATEGY, by itself, creates a new GOULDII_CREATENEWSTRATEGY or raises the existing
%      singleton*.
%
%      H = GOULDII_CREATENEWSTRATEGY returns the handle to a new GOULDII_CREATENEWSTRATEGY or the handle to
%      the existing singleton*.
%
%      GOULDII_CREATENEWSTRATEGY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOULDII_CREATENEWSTRATEGY.M with the given input arguments.
%
%      GOULDII_CREATENEWSTRATEGY('Property','Value',...) creates a new GOULDII_CREATENEWSTRATEGY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gouldii_CreateNewStrategy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gouldii_CreateNewStrategy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gouldii_CreateNewStrategy

% Last Modified by GUIDE v2.5 25-Jun-2018 11:50:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gouldii_CreateNewStrategy_OpeningFcn, ...
                   'gui_OutputFcn',  @Gouldii_CreateNewStrategy_OutputFcn, ...
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


% --- Executes just before Gouldii_CreateNewStrategy is made visible.
function Gouldii_CreateNewStrategy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gouldii_CreateNewStrategy (see VARARGIN)

% Choose default command line output for Gouldii_CreateNewStrategy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gouldii_CreateNewStrategy wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gouldii_CreateNewStrategy_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in createstrategy_button.
function createstrategy_button_Callback(hObject, eventdata, handles)
% hObject    handle to createstrategy_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strategyname = get(handles.edit_newstrategyname, 'String');
strategyname = strcat(strategyname, '.m');
create_Gouldii_template(strategyname);
close(Gouldii_CreateNewStrategy);

function edit_newstrategyname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_newstrategyname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_newstrategyname as text
%        str2double(get(hObject,'String')) returns contents of edit_newstrategyname as a double


% --- Executes during object creation, after setting all properties.
function edit_newstrategyname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_newstrategyname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
