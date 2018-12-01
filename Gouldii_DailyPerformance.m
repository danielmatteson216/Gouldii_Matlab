
%clc;clear;close all;

% ----------------------------------------------------------------------
%load('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\Gouldii_Strategy_Prime_v2\WFA\20070820_20181102_WFAfinaloutput_20181109_001859.mat');
load('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\buynhold.mat');

%[NetLiqR, NetLiqC] = size(WFAfinaloutput);
[NetLiqR, NetLiqC] = size(finaloutput);

%NetLiqT = WFAfinaloutput(:,30);
NetLiqT = finaloutput(:,30);
% ----------------------------------------------------------------------
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
zoom = [-.01:.001:.01];
zoomneg = [-.1:.001:0];
zoompos = [0:.001:0.1];

random1 = rand(1,3);
random2 = rand(1,3);
random3 = rand(1,3);

figure(1000)
HistoGraphps = histogram(DailyReturnsData,xtic);
HistoGraphps(1).FaceColor = 'b';
hold on
%{
figure(2001)
HistoGraphs = histogram(DailyReturnsData,zoom);
HistoGraphps(1).FaceColor = random1;
hold on

figure(4001)
HistoGraphps = histogram(DailyReturnsData,zoompos);
HistoGraphps(1).FaceColor = random1;
hold on

figure(3001)
HistoGraphps = histogram(DailyReturnsData,zoomneg);
HistoGraphps(1).FaceColor = random1;
hold on

figindex = floor(200*random1(1));
figure(figindex)
HistoGraph2 = histfit(DailyReturnsData,length(xtic));
HistoGraph2(1).FaceColor = random2;
HistoGraph2(2).Color = random3;
pd = fitdist(DailyReturnsData,'Normal')

results = fts2mat(DailyReturns, 1);
results(:,1) = str2num(datestr(datenum(results(:,1)),'YYYYmmDD'));

xlswrite('DailyReturnsData',DailyReturnsData);
xlswrite('DailyReturnsDataResults',results);
%}


%end