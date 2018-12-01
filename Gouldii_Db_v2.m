function varargout = Gouldii_Db_v2(varargin)
% GOULDII_DB_V2 MATLAB code for Gouldii_Db_v2.fig
%      GOULDII_DB_V2, by itself, creates a new GOULDII_DB_V2 or raises the existing
%      singleton*.
%
%      H = GOULDII_DB_V2 returns the handle to a new GOULDII_DB_V2 or the handle to
%      the existing singleton*.
%
%      GOULDII_DB_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOULDII_DB_V2.M with the given input arguments.
%
%      GOULDII_DB_V2('Property','Value',...) creates a new GOULDII_DB_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gouldii_Db_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gouldii_Db_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gouldii_Db_v2

% Last Modified by GUIDE v2.5 18-Aug-2018 18:23:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gouldii_Db_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @Gouldii_Db_v2_OutputFcn, ...
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


% --- Executes just before Gouldii_Db_v2 is made visible.
function Gouldii_Db_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gouldii_Db_v2 (see VARARGIN)

% Choose default command line output for Gouldii_Db_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.dbGetData_button, 'enable', 'off')
set(handles.dbGouldiiLO_button, 'enable', 'off')
status1 = 'GUI initialized';
set(handles.status_GUI,'String',status1);

% UIWAIT makes Gouldii_Db_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gouldii_Db_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in GouldiiDbConnect_button.
function GouldiiDbConnect_button_Callback(hObject, eventdata, handles)
% hObject    handle to GouldiiDbConnect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

status2 = 'Database connecting';
status3 = 'Database connected';
set(handles.status_GUI,'String',status2);
run('dbconnect.m');
set(handles.status_GUI,'String',status3);
assignin('base','conn',conn);

set(handles.GouldiiDbConnect_button, 'enable', 'off')
set(handles.dbGetData_button, 'enable', 'on')







% --- Executes on button press in dbGetData_button.
function dbGetData_button_Callback(hObject, eventdata, handles)
% hObject    handle to dbGetData_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

status4 = 'Querying Database for historical data';
set(handles.status_GUI,'String',status4);
pause(.5);
conn = evalin('base','conn');
run('dbinit2.m');
status5 = 'Historical data uploaded';
set(handles.status_GUI,'String',status5);
set(handles.dbGetData_button, 'enable', 'off')
set(handles.dbGouldiiLO_button, 'enable', 'on')
pause(1);
close(conn);
status6 = 'Database connection closed';
set(handles.status_GUI,'String',status6);



% --- Executes on button press in dbGouldiiLO_button.
function dbGouldiiLO_button_Callback(hObject, eventdata, handles)
% hObject    handle to dbGouldiiLO_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB8
% handles    structure with handles and user data (see GUIDATA)
status7 = 'Opening Gouldii LO GUI...';
set(handles.status_GUI,'String',status7);
pause(1);
close(Gouldii_Db_v2);
run('Gouldii_v3.m');
