
clc;clear;close all;

load('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\Gouldii_Strategy_Prime_v2\WFA_strat2\20070820_20180810_WFAfinaloutput_20180925_062525.mat');

[NetLiqR, NetLiqC] = size(WFAfinaloutput);

%[MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptResults(2:end,10))) ;

%%%%%for i = 1 : NetLiqC

NetLiqT = WFAfinaloutput(:,30);

NetLiqT = NetLiqT(3:end);

NetLiqT = cell2mat(NetLiqT);

Dates = datestr(TradeDate);
Dates = cellstr(Dates);

TimeSeriesObject = fints(Dates, NetLiqT);
idate = {'17-Aug-2007'};
initial = fints(idate,1000000);

DailyData = todaily(TimeSeriesObject);
DailyData = merge(initial,DailyData);

DailyReturns  = tick2ret(DailyData);

DailyReturnsData = fts2mat(DailyReturns);
xmin = min(DailyReturnsData);
xmin = round(xmin,1);
xmax = max(DailyReturnsData);
xmax= round(xmax,1);
xtic = [xmin:.01:xmax];



figure(32)

HistoGraphps = histogram(DailyReturnsData,xtic);

results = fts2mat(DailyReturns, 1);
results(:,1) = str2num(datestr(datenum(results(:,1)),'YYYYmmDD'));

xlswrite('DailyReturnsData',DailyReturnsData);
xlswrite('DailyReturnsDataResults',results);



%end