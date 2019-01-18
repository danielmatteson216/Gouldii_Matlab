
%clc;clear;close all;

%load('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\Gouldii_Strategy_Prime_v2\WFA\20070820_20181231_WFAfinaloutput_20190103_115646.mat');
isprint = 1;

[NetLiqR, NetLiqC] = size(WFAfinaloutput);

%[MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptResults(2:end,10))) ;

%%%%%for i = 1 : NetLiqC

NetLiqT = WFAfinaloutput(:,30);

NetLiqT = NetLiqT(3:end);

NetLiqT = cell2mat(NetLiqT);

Dates = datestr(TradeDate);
Dates = cellstr(Dates);

TimeSeriesObject = fints(Dates, NetLiqT);
idate = {'31-Dec-2006'};
initial = fints(idate,initialportfolio);

AnnualData = toannual(TimeSeriesObject);

AnnualData = merge(initial,AnnualData);

AnnualReturns  = tick2ret(AnnualData);

AnnualReturnsData = fts2mat(AnnualReturns);
xmin = min(AnnualReturnsData);
xmin = round(xmin,1);
xmin = xmin - .05;
xmax = max(AnnualReturnsData);
xmax= round(xmax,1);
xtic = [xmin:.01:xmax];
xmax1 = xmax + .01370;
xtic = vertcat(xtic', xmax1);

%figure(33)
%axis([xmin xmax 0 inf]);
%HistoGraphs = histogram(AnnualReturnsData,xtic);
%hold on

results = fts2mat(AnnualReturns, 1);
results(:,1) = str2num(datestr(datenum(results(:,1)),'YYYYmmDD'));

xlswrite('AnnualReturns',AnnualReturnsData);
xlswrite('AnnualReturnsData',results);

if isprint == 1
    AnnualReturns
end    

%end