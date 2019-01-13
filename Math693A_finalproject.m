function [funcval,AnnualizedReturn_MaxDD] = Math693A_finalproject(ParameterA,ParameterB,ParameterC,ParameterD,startdate_string,enddate_string)
addpath('Strategies');
%clear;clc;

%set static param values  (some of these should be pulled from the GUI!! - may/will have WFA implications)
ParameterE = 0;
ParameterF = 0;
y_sig = 0;
y_CONTANGO = 0;
y_CONTANGO30 = 0;
Commission = 20;
initialportfolio = 1000000;
StopLoss = .10;
cashonweekendsflag = 1;

 % GET DATA HISTORICAL DATA - Entire database is loaded in the following line   --- THIS TAKES ALOT OF TIME!!! WE SHOULD DO THIS ONCE AND PASS THE INDICATORS NEEDED
%------------------------------------------------------ 
load('db_historicaldata.mat');
load('db_tradedate.mat');  

% DEAL WITH DATES
Serial_startdate_actual = datenum(startdate_string,'mm/dd/yyyy');
Serial_enddate_actual = datenum(enddate_string,'mm/dd/yyyy');
Serial_startdate = datefind(Serial_startdate_actual,SERIAL_DATE_DATA);
Serial_enddate = datefind(Serial_enddate_actual,SERIAL_DATE_DATA);
TradeDateSpan = TradeDate_NumFormat(Serial_startdate:Serial_enddate);
TradeDateActualSpan = TradeDate(Serial_startdate:Serial_enddate);


%--------------------------------------------------------
% SELECT STRATEGY TO RUN    -----------------------------
% -------------------------------------------------------
SelectedStrategy_temp = 'Gouldii_Strategy_Prime_v2';
SelectedStrategy_input = str2func(SelectedStrategy_temp);
% -------------------------------------------------------

  %=======================================================================
  %   ===============        CALL STRATEGY       ===================
  %=======================================================================
try
                [~,sigw1,sigw2,ticker1,ticker2] = feval(SelectedStrategy_input,Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,...
                                                                  ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,...
                                                                  TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO,...
                                                                  VIX_VIX3M,VIX_VIX6M,VIX9D_VIX,VIX_ma50d,VIX9D_ma50d,VIX9D_VIX_ma50d,VIX_ma20d,VIX_ma200d,VIX);
               
catch
    disp('Error occurs in LO code while trying to run strategy'); %debugging tool
end
  %=======================================================================
  % ============        CALL TRADES AND PERFORMANCE       ============
  %=======================================================================    
try
    finaloutput = Gouldii_TradesPerformanceFunction_v2(Commission,initialportfolio,Serial_enddate,Serial_startdate,VIX, sigw1,sigw2,ticker1,ticker2, SERIAL_DATE_DATA,...
                                                       TargetWeightVX1_S30, TargetWeightVX2_S30, TradeDate, ExpDates, curve_tickers,...
                                                       TradeDate_NumFormat,T1,T2,StopLoss,TradeDay,CONTANGO, CONTANGO30, ROLL_YIELD,...
                                                       VX1_close,VX1_open,VX1_high,VX1_low,VX2_close,VX2_open,VX2_high,VX2_low,VX1_settle,VX2_settle,cashonweekendsflag);
    
catch
disp('Error occurs in LO code while trying to run T&P code');  %debugging tool
end

% CREATE OUTPUT
NetLiqTotal(:,1) = finaloutput(3:end,30);
SharpeRatio(1,1) = finaloutput(end,47);
funcval = cell2mat(SharpeRatio);

CummROR(1,1) = cell2mat(finaloutput(end,46));       
NetProfit(1,1) = cell2mat(NetLiqTotal(end,1)) - cell2mat(NetLiqTotal(1,1));

AnnualizedReturn = (((1+CummROR))^(365/length(NetLiqTotal)))-1;
                
% MaxDD calculations
[MaxDD,MaxDDindex] = maxdrawdown(cell2mat(NetLiqTotal(:,1))); 

AnnualizedReturn_MaxDD = AnnualizedReturn/MaxDD;

Objective_function = AnnualizedReturn_MaxDD
%Objective_function = funcval


% -----------------  everything below this line is not needed -------------


SharpeRatio
MaxDrawdown = MaxDD;
DrawdownIndices = MaxDDindex';
startindexDD = DrawdownIndices(1,1);
endindexDD = DrawdownIndices(1,2);
MaxDDstartdate = TradeDateSpan(startindexDD);  
MaxDDenddate = TradeDateSpan(endindexDD);
MaxDrawdownDates = [MaxDDstartdate MaxDDenddate];
MaxDrawdownTotal = [MaxDD MaxDDstartdate MaxDDenddate];

%{

%GRAPHS AND EXCEL OUTPUT
stratpath = 'C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\';
strategypath = strcat(stratpath, SelectedStrategy_temp, '\');
strategypathResults = strcat(strategypath,'Results\');

now = datetime('now','Format','yyyyMMdd_HHmmss');
now = datestr(now,'yyyymmdd_HHMMss');
sdate = datestr(Serial_startdate_actual,'yyyymmdd');
edate = datestr(Serial_enddate_actual,'yyyymmdd');

strategypath_output = strcat(strategypathResults,sdate,'_',edate,'_');
strategypath_output = strcat(strategypath_output,'SingleRun-mathproject-OutputArray_',now,'.xlsx'); 

strategypath_maxdd = strcat(strategypathResults,sdate,'_',edate,'_');
strategypath_maxdd = strcat(strategypath_maxdd,'SingleRun-mathproject-MaxDrawdowntotal_',now,'.xlsx');

            xlswrite(strategypath_output,finaloutput);                     
            xlswrite(strategypath_maxdd,MaxDrawdownTotal); 

            Netliqtotalnum = cell2mat(NetLiqTotal(:,1));
            
figure(1)
semilogy(TradeDateSpan,Netliqtotalnum)
title('NETLIQ TOTAL VS TRADEDATE')
xlabel('TradeDate');
ylabel('Dollars');
hold on

figure(2)
semilogy(TradeDateSpan,log10(Netliqtotalnum))
title('Log(NETLIQ TOTAL) VS TRADEDATE')
xlabel('TradeDate');
ylabel('Log(Dollars)');
hold on
%}

end




