
clc;clear;close all;

load('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\Gouldii_Strategy_Prime_v2\WFA\20090819_20181102_WFAfinaloutput_20181108_001040.mat');

[NetLiqR, NetLiqC] = size(WFAfinaloutput);

%[MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptResults(2:end,10))) ;

%%%%%for i = 1 : NetLiqC

NetLiqT = WFAfinaloutput(:,30);

NetLiqT = NetLiqT(3:end);

NetLiqT = cell2mat(NetLiqT);

Dates = datestr(TradeDate);
Dates = cellstr(Dates);

TimeSeriesObject = fints(Dates, NetLiqT);
idate = {'31-Jul-2007'};
initial = fints(idate,1000000);

MonthlyData = tomonthly(TimeSeriesObject);
MonthlyData = merge(initial,MonthlyData);
MonthEndDates = MonthlyData.dates;
MonthlyReturns  = tick2ret(MonthlyData);

MonthlyReturnsData = fts2mat(MonthlyReturns);
xmin = min(MonthlyReturnsData);
xmin = round(xmin,1);
xmax = max(MonthlyReturnsData);
xmax= round(xmax,1);
xtic = [xmin:.01:xmax];

figure(32)
HistoGraphps = histogram(MonthlyReturnsData,xtic);
results = fts2mat(MonthlyReturns, 1);

results(:,1) = str2num(datestr(datenum(results(:,1)),'YYYYmmDD'));

xlswrite('MonthlyReturnsData',MonthlyReturnsData);
xlswrite('MonthlyReturnsDataResults',results);
%end