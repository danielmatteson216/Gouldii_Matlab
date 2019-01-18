function varargout = Gouldii_GraphGUI(varargin)
% GOULDII_GRAPHGUI MATLAB code for Gouldii_GraphGUI.fig
%      GOULDII_GRAPHGUI, by itself, creates a new GOULDII_GRAPHGUI or raises the existing
%      singleton*.
%
%      H = GOULDII_GRAPHGUI returns the handle to a new GOULDII_GRAPHGUI or the handle to
%      the existing singleton*.
%
%      GOULDII_GRAPHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOULDII_GRAPHGUI.M with the given input arguments.
%
%      GOULDII_GRAPHGUI('Property','Value',...) creates a new GOULDII_GRAPHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gouldii_GraphGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gouldii_GraphGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gouldii_GraphGUI

% Last Modified by GUIDE v2.5 09-Nov-2018 20:20:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gouldii_GraphGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Gouldii_GraphGUI_OutputFcn, ...
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


% --- Executes just before Gouldii_GraphGUI is made visible.
function Gouldii_GraphGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gouldii_GraphGUI (see VARARGIN)

% Choose default command line output for Gouldii_GraphGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gouldii_GraphGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gouldii_GraphGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectStrategy.
function SelectStrategy_Callback(hObject, eventdata, handles)
% hObject    handle to SelectStrategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[FileName,PathName] = uigetfile('*.m','Select a strategy');
[FileName,PathName] = uigetfile(fullfile(pwd,'Strategies','Select a strategy'));
SelectedStrategy = FileName;
StrategyPath = PathName;
assignin('base','StrategyPath',StrategyPath);
assignin('base','SelectedStrategy',SelectedStrategy);

handles.SelectedStrategy = SelectedStrategy;
%handles.StrategyPath = StrategyPath;

set(handles.Static_Strategy,'String',SelectedStrategy);
%set(handles.Static_StrategyPath,'String',StrategyPath);

guidata(hObject, handles);


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RunStrategyFileName = evalin('base','RunStrategyFileName'); 
RunStrategyPathName = evalin('base','RunStrategyPathName'); 
loadfile = strcat(RunStrategyPathName,'/',RunStrategyFileName);
load(loadfile);
histocolor = 'b';
histotrans = .7;

SelectedStrategy_temp = RunStrategyFileName(19:end-20);
if strcmp(SelectedStrategy_temp,'LOoutput')
    WFAfinaloutput = LOoutput;
end

     Gouldii_AnnualPerformance;
     Gouldii_MonthlyPerformance;
     Gouldii_DailyPerformance(WFAfinaloutput, histocolor,histotrans,TradeDate,initialportfolio,SelectedStrategy_temp);
     

     
% CODE GOES HERE
SelectedStrategy        = 'Gouldii_Strategy_BuyandHold_v2.m';
StrategyPath            = 'C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Strategies\';
TradeDateLength = length(TradeDate);
%Commission              = 0;
%initialportfolio        = 1000000;
StopLoss                = 1;
Serial_startdate_actual = datenum(TradeDate(1));
Serial_enddate_actual   = datenum(TradeDate(TradeDateLength));

OptimizedParameter1String = 'ParameterA';
OptimizedParameter2String = 'ParameterA';
OptimizedParameter3String = 'ParameterA';
OptimizedParameter4String = 'ParameterA';

ParameterA = 0;
ParameterB = 0;
ParameterC = 0;
ParameterD = 0;
ParameterE = 0;
ParameterF = 0;

isfirstday = 0;
startdate_string = datestr(TradeDate(1));
sigprevious = 0;
isWFA = 0;
isMA = 0;
               
%run buy and hold strategy for selected dates.
%need all the parameters prior to runnin!
%   StrategyPath               ---> we have
%   SelectedStrategy           ---> we have
%   Commission                      ---> we can set
%   initialportfolio                ---> we can set
%   StopLoss                        ---> we can set
%   Serial_startdate_actual                 ---> we can compute
%   Serial_enddate_actual                   ---> we can compute
%   OptimizedParameter1String
%   OptimizedParameter2String
%   OptimizedParameter3String
%   OptimizedParameter4String

%   ParameterA
%   ParameterB
%   ParameterC
%   ParameterD
%   ParameterE
%   ParameterF

%   isfirstday
%   startdate_string
%   sigprevious
%   isWFA
%   isMA
isopt1on = 1;
isopt2on = 0;
isopt3on = 0;
isopt4on = 0;

 assignin('base','isopt1on',isopt1on);    
 assignin('base','isopt2on',isopt2on);    
 assignin('base','isopt3on',isopt3on);    
 assignin('base','isopt4on',isopt4on);    

isopt1on = evalin('base','isopt1on');   
isopt2on = evalin('base','isopt2on');   
isopt3on = evalin('base','isopt3on');   
isopt4on = evalin('base','isopt4on');   


WFA_NetLiqTotal = WFAfinaloutput(3:end,30);
WFA_SharpeRatio = cell2mat(WFAfinaloutput(end,47));
WFA_CummRORcell = WFAfinaloutput(end,46);
WFA_CummROR = cell2mat(WFA_CummRORcell);
WFA_NetProfit = cell2mat(WFA_NetLiqTotal(end)) - cell2mat(WFA_NetLiqTotal(1));
WFA_NetLiqTotaldoubles = cell2mat(WFA_NetLiqTotal);

[WFA_MaxDD,WFA_MaxDDindex] = maxdrawdown(WFA_NetLiqTotaldoubles);

WFA_AnnualizedReturn = (((1+WFA_CummROR))^(365/length(WFA_NetLiqTotal)))-1;



        try
            [TotalLinearOpt,sigprevious,OptParameterA,OptParameterB,OptParameterC,OptParameterD,OptParameterE,OptParameterF,...
            OptMaxDD,OptNetProfit,OptSharpeRatio,OptAnnualizedReturn,isfirstday,cashonweekendsflag,output] = Gouldii_SignalsLinearOptimizer_v3(StrategyPath,SelectedStrategy,...
            Commission, initialportfolio, StopLoss,Serial_startdate_actual,Serial_enddate_actual,...
            OptimizedParameter1String,0,0,0,...
            OptimizedParameter2String,0,0,0,...
            OptimizedParameter3String,0,0,0,...
            OptimizedParameter4String,0,0,0,...
            ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,...
            isfirstday,startdate_string,sigprevious,isWFA,isMA);
        catch                                    
            disp('Error Running BuyAndHold strategy');
        end

BuynHoldNetLiqTotal = output(3:end,30);
BuynHoldSharpeRatio = cell2mat(output(end,47));
BuynHoldCummRORcell = output(end,46);
BuynHoldCummROR = cell2mat(BuynHoldCummRORcell);
BuynHoldNetProfit = cell2mat(BuynHoldNetLiqTotal(end)) - cell2mat(BuynHoldNetLiqTotal(1));
BuynHoldNetLiqTotaldoubles = cell2mat(BuynHoldNetLiqTotal);

[BuynHoldMaxDD,BuynHoldMaxDDindex] = maxdrawdown(BuynHoldNetLiqTotaldoubles);

BuynHoldAnnualizedReturn = (((1+BuynHoldCummROR))^(365/length(BuynHoldNetLiqTotal)))-1;

%TenPecentAnnual = (1.1^(1/250) ) %initialportfolio*0.10 + initialportfolio); %need to get the slope right for an annualized return of TenPercent
MaxDD_StartDate = TradeDate(WFA_MaxDDindex(1));
MaxDD_EndDate = TradeDate(WFA_MaxDDindex(2));

%plot here!!
figure(1)
      plot(TradeDate,WFA_NetLiqTotaldoubles,'g');
        set(gca,'YScale','log')
        hold on
        plot(TradeDate,BuynHoldNetLiqTotaldoubles); 
        %hold on 
        %plot(TradeDate,TenPercentAnnual);
     hold off 
     
 figure(2)
  plot(TradeDate,WFA_NetLiqTotaldoubles,'g');
    hold on
    plot(TradeDate,BuynHoldNetLiqTotaldoubles);   
 hold off 

try 
PortfolioMovingReturns = WFAfinaloutput(:,56);
PortfolioMovingReturns = PortfolioMovingReturns(3:end);
catch
disp('NO PORTFOLIO MOVING RETURNS FOUND IN THIS FILE');    
end

PortfolioMovingReturnsExists = exist('PortfolioMovingReturns');
 if PortfolioMovingReturnsExists == 1
     PortfolioMovingReturns = WFAfinaloutput(:,56);
     PortfolioMovingReturns = PortfolioMovingReturns(3:end);
  figure(3)
  plot(TradeDate,cell2mat(PortfolioMovingReturns));
 end
 
 
NetLiqTotal = WFAfinaloutput(3:end,30);
SharpeRatio = cell2mat(WFAfinaloutput(end,47));
CummRORcell = WFAfinaloutput(end,46);
CummROR = cell2mat(CummRORcell);
NetProfit = cell2mat(NetLiqTotal(end)) - cell2mat(NetLiqTotal(1));
NetLiqTotaldoubles = cell2mat(NetLiqTotal);

[MaxDD,MaxDDindex] = maxdrawdown(NetLiqTotaldoubles);

AnnualizedReturn = (((1+CummROR))^(365/length(NetLiqTotaldoubles)))-1;


disp('Sharpe Ratio for OutOfSample Run:');
disp(SharpeRatio);
disp('NetProfit for OutOfSample Run:');
disp(NetProfit);
disp('AnnualizedReturn for OutOfSample Run:');
disp(AnnualizedReturn);
disp('Max Drawdown for OutOfSample Run:');
disp(MaxDD);  

%this is some bullshit that can be deleted. we are cheating to get spxt data
load('SPXT_RETURNS.mat')
%SPXT_CLOSE = SPXT_CLOSE(251:end);
%SPXT_Returns = SPXT_Returns(250:end);


%disp('SPXT_GOULDII Correlation factor')
%SPXT_GOULDII_corrcoef = corrcoef(SPXT_CLOSE,NetLiqT)
%SPXT_GOULDII_corrcoef = corrcoef(SPXT_Returns,DailyReturnsData)

%SPXT_GOULDII_cov = cov(SPXT_CLOSE,NetLiqT)
%SPXT_GOULDII_covr = cov(SPXT_Returns,DailyReturnsData)
histocolor = 'y';
histotrans = 0.5;

WFAfinaloutput = output;
     Gouldii_AnnualPerformance;
     Gouldii_MonthlyPerformance;
     Gouldii_DailyPerformance(output, histocolor,histotrans,TradeDate,initialportfolio,SelectedStrategy_temp);
 
     % CODE GOES HERE

     

NetLiqTotal = WFAfinaloutput(3:end,30);
SharpeRatio = cell2mat(WFAfinaloutput(end,47));
CummRORcell = WFAfinaloutput(end,46);
CummROR = cell2mat(CummRORcell);
NetProfit = cell2mat(NetLiqTotal(end)) - cell2mat(NetLiqTotal(1));
NetLiqTotaldoubles = cell2mat(NetLiqTotal);

[MaxDD,MaxDDindex] = maxdrawdown(NetLiqTotaldoubles);

AnnualizedReturn = (((1+CummROR))^(365/length(NetLiqTotaldoubles)))-1;


disp('Sharpe Ratio for OutOfSample Run:');
disp(SharpeRatio);
disp('NetProfit for OutOfSample Run:');
disp(NetProfit);
disp('AnnualizedReturn for OutOfSample Run:');
disp(AnnualizedReturn);
disp('Max Drawdown for OutOfSample Run:');
disp(MaxDD);     
     




guidata(hObject, handles);



% --- Executes on button press in SelectRunFile.
function SelectRunFile_Callback(hObject, eventdata, handles)
% hObject    handle to SelectRunFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StrategyPath = evalin('base','StrategyPath'); 
SelectedStrategy = evalin('base','SelectedStrategy'); 




SelectedStrategy = SelectedStrategy(1:end-2);
StrategyPath = StrategyPath(1:end-11);
RunStrategyPath = strcat(StrategyPath,'Reference\',SelectedStrategy);

[RunStrategyFileName,RunStrategyPathName] = uigetfile(RunStrategyPath);
assignin('base','RunStrategyFileName',RunStrategyFileName);
assignin('base','RunStrategyPathName',RunStrategyPathName);
%RunStrategyFileName = RunStrategyFileName;
%RunStrategyPathName = RunStrategyPathName;

Sdateyear = RunStrategyFileName(1:4);
Sdatemonth = RunStrategyFileName(5:6);
Sdateday = RunStrategyFileName(7:8);

Edateyear = RunStrategyFileName(10:13);
Edatemonth = RunStrategyFileName(14:15);
Edateday = RunStrategyFileName(16:17);

Sdate = strcat(Sdatemonth,'/',Sdateday,'/',Sdateyear);
Edate = strcat(Edatemonth,'/',Edateday,'/',Edateyear);

SelectedRunStrategy = RunStrategyFileName(19:end-20);

if strcmp(SelectedRunStrategy,'WFAfinaloutput') || strcmp(SelectedRunStrategy,'LOoutput');
disp('You have selected the correct file name/type');
else    
   msg = 'YOU HAVE NOT SELECTED THE CORRECT FILE TYPE';
   error(msg); 
end
set(handles.Static_StartDate,'String',Sdate);
set(handles.Static_EndDate,'String',Edate);
set(handles.Static_nameofstrategy,'String',SelectedRunStrategy);

guidata(hObject, handles);
