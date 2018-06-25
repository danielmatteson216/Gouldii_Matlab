
clc;clear;close all;

load('Volatility_Signals_linearopt.mat');

[NetLiqR, NetLiqC] = size(NetLiqTotalMatrix);

[MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptResults(2:end,10))) ;

%for i = 1 : NetLiqC

NetLiqT(:,1) = NetLiqTotalMatrix(:,MaxSharpeIndex);

TimeSeriesObject = fints(SERIAL_DATE_DATA, NetLiqT);

MonthlyData = tomonthly(TimeSeriesObject);

MonthEndDates = MonthlyData.dates;

MonthlyReturns  = tick2ret(MonthlyData);

MonthlyReturnsData(:,MaxSharpeIndex) = fts2mat(MonthlyReturns);

figure(MaxSharpeIndex)
HistoGraphps = histogram(MonthlyReturnsData(:,MaxSharpeIndex),40);

%end