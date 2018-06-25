
clc;clear;close all;

load('Volatility_Signals_linearopt_baseline.mat');

[NetLiqR, NetLiqC] = size(NetLiqTotalMatrix);

[MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptResults(2:end,10))) ;

%for i = 1 : NetLiqC

NetLiqT(:,1) = NetLiqTotalMatrix(:,MaxSharpeIndex);

TimeSeriesObject = fints(SERIAL_DATE_DATA, NetLiqT);

AnnualData = toannual(TimeSeriesObject);

AnnualReturns  = tick2ret(AnnualData);

AnnualReturnsData(:,MaxSharpeIndex) = fts2mat(AnnualReturns);

figure(MaxSharpeIndex)
HistoGraphps = histogram(AnnualReturnsData(:,MaxSharpeIndex),40);

%end