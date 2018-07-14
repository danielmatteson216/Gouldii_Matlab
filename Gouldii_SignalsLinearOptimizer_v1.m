%                                    LINEAR OPTIMIZATION CODE
%
function [sigprevious,OptContangoEntry,OptContango30Entry,OptContangoExit,OptContango30Exit,OptLongContangoEntry,OptLongContango30Entry,OptMaxDD,OptNetProfit,OptSharpeRatio,OptAnnualizedReturn,isfirstday] = Gouldii_SignalsLinearOptimizer_v1(~, SelectedStrategy, Commission, initialportfolio, StopLoss,Serial_startdate_actual,Serial_enddate_actual,OptimizedParameter1String,opt1numofsteps,opt1lowerbound,opt1upperbound,OptimizedParameter2String,opt2numofsteps,opt2lowerbound,opt2upperbound,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,isfirstday,startdate_string,sigprevious)

addpath('Strategies');

 % SET INPUT ARGUMENTS IF NOT RUNNING FROM GUI
%----------------------------------------------------------------------------------------------------------------------   
%clear; close all; clc
%set input argument default values if they are not passed to the function
if nargin == 0
StrategyPath = 'C:\Program Files\MATLAB\MATLAB Production Server\R2015a\bin\Gouldii_root' ;
SelectedStrategy = 'Gouldii_Strategy_Prime_v1.m';
Commission = 0.0005;
initialportfolio = 1000000;
StopLoss = 0.1;
Serial_startdate_actual = 732910;
Serial_enddate_actual = 737100;
OptimizedParameter1String = 'ContangoEntry';
opt1numofsteps = 1;
opt1lowerbound = 0.07;
opt1upperbound = 0.09;
OptimizedParameter2String = 'ContangoExit';
opt2numofsteps = 1;
opt2lowerbound = 0.03;
opt2upperbound = 0.04;
ContangoEntry = 0.088;
Contango30Entry = 0.10;
ContangoExit = 0.033;
Contango30Exit = 0.1;
LongContangoEntry = -0.05;
LongContango30Entry = 0;
end



 % GET DATA FROM GUI  --- Entire database is loaded in the following line
 % (minus tradedate)
%----------------------------------------------------------------------------------------------------------------------   
load('db_historicaldata.mat');
load('db_tradedate.mat');



%ObjectName = @(x) inputname(1);

%calculate length of test vector
SERIAL_DATE_LEN = length(SERIAL_DATE_DATA);
TradeDate_String = datestr(SERIAL_DATE_DATA, 'yyyymmdd');
TradeDate_cellarray = cellstr(TradeDate_String);
%inputformatfordate = 'mm/dd/yyyy';
%StartDate_Serial = datenum(startdate_string,inputformatfordate);


    if isfirstday == 1
        disp('this is the first day of the database');
        y_CONTANGO = 0;
        y_CONTANGO30 = 0;
        y_sig = 0;
    elseif isfirstday == 0
        previoustradedate = busdate(Serial_startdate_actual,-1);    
        previoustradedate_Index = datefind(previoustradedate,SERIAL_DATE_DATA);    

        y_CONTANGO = CONTANGO(previoustradedate_Index);
        y_CONTANGO30 = CONTANGO30(previoustradedate_Index);

        % ONLY DO THE FOLLOWING LINE IF isWFA is checked!! otherwise, y_sig = 0.
        % *this will prevent us from using yesterdays signal when we dont want to.
        % We only want to use yesterdays signal when running wfa.
        y_sig = sigprevious;
    end


%optimize the contango entry variable...
% stepsize
h1 = (opt1upperbound - opt1lowerbound) / opt1numofsteps;

% set the optimized parameter
OptimizedParameter1 = (opt1lowerbound:h1:opt1upperbound);
%OptParamName = ObjectName(OptimizedParameter);
OptParamName1 = OptimizedParameter1String;
OptParam1 = OptimizedParameter1;

%Opt Param cell array
OptParam1Label = {OptParamName1};
OptParam1 = num2cell(OptParam1);
OptParam1Cell = cat(2,OptParam1Label, OptParam1);
OptParam1Cell = OptParam1Cell';

h2 = (opt2upperbound - opt2lowerbound) / opt2numofsteps;

% set the optimized parameter
OptimizedParameter2 = (opt2lowerbound:h2:opt2upperbound);
%OptParamName = ObjectName(OptimizedParameter);
OptParamName2 = OptimizedParameter2String;
OptParam2 = OptimizedParameter2;

%Opt Param cell array
OptParam2Label = {OptParamName2};
OptParam2 = num2cell(OptParam2);
OptParam2Cell = cat(2,OptParam2Label, OptParam2);
OptParam2Cell = OptParam2Cell';



Serial_startdate = datefind(Serial_startdate_actual,SERIAL_DATE_DATA);
Serial_enddate = datefind(Serial_enddate_actual,SERIAL_DATE_DATA);

%resize data here?!?!
%SERIAL_DATE_DATA = SERIAL_DATE_DATA(Serial_startdate:Serial_enddate, :);
%TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);

 
%initialize flags
%flag_future = 1;
 j = 1;
 k = 1;
 m = 1;

counter = 0;
 % ask user for initial portfolio size...
 %       promptPortfolioInitial = {'Please Enter an Initial Portfolio Value:'};
 %       Stop_title = 'Initial Portfolio Value';
 %       num_lines = 1;
 %       PortfolioCashInitialcell = inputdlg(promptPortfolioInitial,Stop_title,num_lines);

 %XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

     for m = 1:length(OptimizedParameter2)
        OptimizedParameter2Specific = OptimizedParameter2(m);

        if strcmp(OptimizedParameter2String, 'ContangoEntry')
             ContangoEntry = OptimizedParameter2Specific ;
            elseif strcmp(OptimizedParameter2String, 'Contango30Entry')
             Contango30Entry = OptimizedParameter2Specific ; 
            elseif strcmp(OptimizedParameter2String, 'ContangoExit')
             ContangoExit = OptimizedParameter2Specific ; 
            elseif strcmp(OptimizedParameter2String, 'Contango30Exit')
             Contango30Exit = OptimizedParameter2Specific ; 
            elseif strcmp(OptimizedParameter2String, 'LongContangoEntry')
             LongContangoEntry = OptimizedParameter2Specific ;
            elseif strcmp(OptimizedParameter2String, 'LongContango30Entry')
             LongContango30Entry = OptimizedParameter2Specific ; 
        end
        
        
        for j = 1:length(OptimizedParameter1)
            
                OptimizedParameter1Specific = OptimizedParameter1(j);

             %if statement to figure out which param is the opt param
                if strcmp(OptimizedParameter1String, 'ContangoEntry')
                    ContangoEntry = OptimizedParameter1Specific ;
                    elseif strcmp(OptimizedParameter1String, 'Contango30Entry')
                     Contango30Entry = OptimizedParameter1Specific ; 
                    elseif strcmp(OptimizedParameter1String, 'ContangoExit')
                     ContangoExit = OptimizedParameter1Specific ; 
                    elseif strcmp(OptimizedParameter1String, 'Contango30Exit')
                     Contango30Exit = OptimizedParameter1Specific ; 
                    elseif strcmp(OptimizedParameter1String, 'LongContangoEntry')
                     LongContangoEntry = OptimizedParameter1Specific ;
                    elseif strcmp(OptimizedParameter1String, 'LongContango30Entry')
                     LongContango30Entry = OptimizedParameter1Specific ; 
                end

                SelectedStrategy_temp = SelectedStrategy(1:end-2);
                SelectedStrategy_input = str2func(SelectedStrategy_temp);

                if strcmp(SelectedStrategy, 'Gouldii_Strategy_BuyandHold_v1.m') 
                    StopLoss = 100;
                    cashonweekendsflag = 0;
                else
                    cashonweekendsflag = 1;
                end     

    %----------------------------------------------------------------------------------------------------------------------    

   disp('if there is an error, it happens either in the strategy or later'); 

  %=======================================================================
  %   ===============        CALL STRATEGY       ===================
  %=======================================================================
                [sigprevious,sigw1,sigw2,ticker1,ticker2] = feval(SelectedStrategy_input,Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,...
                                                                  ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,...
                                                                  TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers);
 


                sigw1vec(:,j,m) = sigw1;
                sigw2vec(:,j,m) = sigw2;


  %=======================================================================
  % ============        CALL TRADES AND PERFORMANCE       ============
  %=======================================================================    

                finaloutput = Gouldii_TradesPerformanceFunction_v1(Commission,initialportfolio,Serial_enddate,Serial_startdate,VIX, sigw1,sigw2,ticker1,ticker2, SERIAL_DATE_DATA,...
                                                                    TargetWeightVX1_S30, TargetWeightVX2_S30, TradeDate, ExpDates, curve_tickers,...
                                                                    TradeDate_NumFormat,T1,T2,StopLoss,TradeDay,CONTANGO, CONTANGO30, ROLL_YIELD,...
                                                                    VX1_close,VX1_open,VX1_high,VX1_low,VX2_close,VX2_open,VX2_high,VX2_low,cashonweekendsflag);



  % CREATE OUTPUT GRAPHS AND SPREADSHEETS                                                
  %----------------------------------------------------------------------------------------------------------------------                                                   

                OUTPUT_CELL_ARRAY{j} = finaloutput;
                NetLiqTotal(:,j) = OUTPUT_CELL_ARRAY{1,j}(2:end,30);
                SharpeRatio(1,j) = OUTPUT_CELL_ARRAY{1,j}(end,47);
                CummRORcell(1,j) = OUTPUT_CELL_ARRAY{1,j}(end,46);
                CummROR = cell2mat(CummRORcell);
                NetProfit(1,j) = cell2mat(NetLiqTotal(end,j)) - cell2mat(NetLiqTotal(1,j));

                %TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);

                counter = counter + 1;     

                NetLiqTotaldoubles = cell2mat(NetLiqTotal);
                NetLiqTotalMatrix(:,counter) = NetLiqTotaldoubles(:,1);  

                NetLiqTotalTest = NetLiqTotalMatrix(NetLiqTotalMatrix < 0);
                NetLiqTotalempty = isempty(NetLiqTotalTest);

                    if NetLiqTotalempty == 1
                        [MaxDD(j,1),MaxDDindextemp] = maxdrawdown(cell2mat(NetLiqTotal(:,j)));
                        MaxDDindex(j,:) = MaxDDindextemp;

                    elseif NetLiqTotalempty == 0
                        MaxDD(j,1) = 0;
                        MaxDDindex(j,1) = 0;
                    end       


                % this is the linear optimizer output!!! must figure out how to make
                % this dynamic - labels need to change with whatever parameter is
                % optimized.

                LinearOptResults(j,1) = num2cell(ContangoEntry);           
                LinearOptResults(j,2) = num2cell(Contango30Entry);
                LinearOptResults(j,3) = num2cell(ContangoExit);
                LinearOptResults(j,4) = num2cell(Contango30Exit);
                LinearOptResults(j,5) = num2cell(LongContangoEntry);
                LinearOptResults(j,6) = num2cell(LongContango30Entry);           
                LinearOptResults(j,7) = num2cell(MaxDD(j,1));
                LinearOptResults(j,8) = num2cell(NetProfit(1,j));
                LinearOptResults(j,9) = SharpeRatio(1,j);
                LinearOptResults(j,10) = num2cell(((1+CummROR(1,j))^(365/length(sigw1)))-1);
                %LinearOptResults(j,10) = num2cell(MaxDDindex(1,j));

 LinearOpt2_OUTPUT_CELL_ARRAY(1,counter) = OUTPUT_CELL_ARRAY(1,j);
 
        end   %end of INSIDE LINEAR OPT LOOP

                 if  strcmp(OptimizedParameter1String,OptimizedParameter2String)
                     LinearOptimizerResults = LinearOptResults;
                     break;
                 end

                
                 
                        if m == 1
                            LinearOptTemp = LinearOptResults;
                        else    
                            LinearOptimizerResults = vertcat(LinearOptTemp,LinearOptResults);
                            LinearOptTemp = LinearOptimizerResults;
                        end

     end  %end of OUTSIDE LINEAR OPT LOOP

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 
    %this is likely not needed. it was a debugging tool. 
    if NetLiqTotalempty == 0
    disp('Net Liq is negative');
    elseif NetLiqTotalempty == 1
    disp('Net Liq is positive');
    end
    MaxDrawdowntotal = horzcat(MaxDD,MaxDDindex);

    


    clear('emptycell68','XIVindexstop','TradeDate_cellarray','TradeDate_String','ans','emptycell79','EXCEL_ALGO_SIGNAL','DVT_sigNUM','k','lastrowend','lengthofsignals','output_file_ToadCentral','p','y','AVCI','SERIAL_DATE_LEN','VCO_direction','VTRO','VTRO_direction','VTRO_int','VXST_ROLL','VXV_ROLL','i','j')


    %xlswrite('TOTAL_OUTPUT_ARRAY.xlsx',TOTAL_OUTPUT_ARRAY);
    %xlswrite('LinearOptResults.xlsx',LinearOpt3Results);

    %remove the initial value row from the net liq output array
    NetLiqTotalMatrix = NetLiqTotalMatrix(2:end,:);

    % this is the objective function portion!!!!
    %LinearOptResults

    %-----------------------------------
    %calculate the annualized return:
    [MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptimizerResults(1:end,9))) 
    [MaxAnnualizedReturn,MaxAnnualizedReturnIndex] = max(cell2mat(LinearOptimizerResults(1:end,10)))
    %-----------------------------------

    %this should identify which output array is the optimal output array
    output = LinearOpt2_OUTPUT_CELL_ARRAY{MaxSharpeIndex};    
    
    

    OptContangoEntry = LinearOptimizerResults{MaxSharpeIndex,1};
    OptContango30Entry = LinearOptimizerResults{MaxSharpeIndex,2};
    OptContangoExit = LinearOptimizerResults{MaxSharpeIndex,3};
    OptContango30Exit = LinearOptimizerResults{MaxSharpeIndex,4};
    OptLongContangoEntry = LinearOptimizerResults{MaxSharpeIndex,5};
    OptLongContango30Entry = LinearOptimizerResults{MaxSharpeIndex,6};
    OptMaxDD = LinearOptimizerResults{MaxSharpeIndex,7};
    OptNetProfit = LinearOptimizerResults{MaxSharpeIndex,8};
    OptSharpeRatio = LinearOptimizerResults{MaxSharpeIndex,9};
    OptAnnualizedReturn = LinearOptimizerResults{MaxSharpeIndex,10};


    LinearOpt3Labels = {'ContangoEntry','Contango30Entry','ContangoExit','Contango30Exit','LongContangoEntry','LongContango30Entry','MaxDD','NetProfit','SharpeRatio','AnnualizedReturn'};

    TotalLinearOpt3 = [LinearOptimizerResults(1:end,1),LinearOptimizerResults(1:end,2),LinearOptimizerResults(1:end,3),LinearOptimizerResults(1:end,4),LinearOptimizerResults(1:end,5),LinearOptimizerResults(1:end,6),LinearOptimizerResults(1:end,7),LinearOptimizerResults(1:end,8),LinearOptimizerResults(1:end,9),LinearOptimizerResults(1:end,10)];

    TotalLinearOpt = cat(1,LinearOpt3Labels, TotalLinearOpt3);

stratpath = 'C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\';
strategypath = strcat(stratpath, SelectedStrategy_temp, '\');
strategypathResults = strcat(strategypath,'Results\');
strategypathOptParams = strcat(strategypath,'OptParams\');

now = datetime('now','Format','yyyyMMdd_HHmmss');
now = datestr(now,'yyyymmdd_HHMMss');
sdate = datestr(Serial_startdate_actual,'yyyymmdd');
edate = datestr(Serial_enddate_actual,'yyyymmdd');

strategypath_output = strcat(strategypathResults,sdate,'_',edate,'_');
strategypath_output = strcat(strategypath_output,'OptResultsOutputArray_',now,'.xlsx');

%strategypath_complete = strcat(strategypathResults,sdate,'_',edate,'_');
%strategypath_complete = strcat(strategypath_complete,'COMPLETE_OUTPUT_ARRAY_',now,'.xlsx');

strategypath_maxdd = strcat(strategypathResults,sdate,'_',edate,'_');
strategypath_maxdd = strcat(strategypath_maxdd,'MaxDrawdowntotal_',now,'.xlsx');

strategypath_linearopt = strcat(strategypathOptParams,sdate,'_',edate,'_');
strategypath_linearopt = strcat(strategypath_linearopt,'LinearOptResults_',now,'.xlsx');

        try
            xlswrite(strategypath_output,output);      
            %xlswrite(strategypath_complete,output);                
            xlswrite(strategypath_maxdd,MaxDrawdowntotal);            
            xlswrite(strategypath_linearopt,TotalLinearOpt);
        catch
            try
            system('taskkill /F /IM EXCEL.EXE');
            catch
                disp('no excel open error')
            end

            %check to see if the directory exists, if not, create it.
            % we will need another try catch
            
            xlswrite(strategypath_output,output);
            %xlswrite(strategypath_complete,output); 
            xlswrite(strategypath_maxdd,MaxDrawdowntotal);
            xlswrite(strategypath_linearopt,TotalLinearOpt);
        end    


    NetLiqOptimized(:,1) = NetLiqTotalMatrix(:,MaxSharpeIndex); 

    if strcmp(SelectedStrategy, 'Gouldii_Strategy_BuyandHold_v1.m')
        NetLiqTotalBuyAndHold = NetLiqOptimized;
        OptSharpeRatio_temp = OptSharpeRatio;
        OptMaxDD_temp = OptMaxDD;
        OptAnnualizedReturn_temp = OptAnnualizedReturn;
        OptNetProfit_temp = OptNetProfit;
        OptContangoEntry_temp = OptContangoEntry;
        OptContango30Entry_temp = OptContango30Entry;
        OptContangoExit_temp = OptContangoExit; 
        OptContango30Exit_temp = OptContango30Exit;
        OptLongContangoEntry_temp = OptLongContangoEntry;
        OptLongContango30Entry_temp = OptLongContango30Entry;     

        clear('OptLongContango30Entry','OptLongContangoEntry','OptContango30Exit','OptContangoExit','OptContango30Entry','OptContangoEntry','OptSharpeRatio','OptMaxDD','OptAnnualizedReturn','OptNetProfit','MaxDrawdowntotal','MaxAnnualizedReturnIndex','MaxAnnualizedReturn','MaxSharpe','NetLiqOptimized','LinearOptimizerResults','MaxDD','NetProfit','NetLiqTotalMatrix','MaxSharpeIndex','TotalLinearOpt','TotalLinearOpt3','LinearOpt3Labels')

        save('Volatility_BuyAndHold')

        OptSharpeRatio = OptSharpeRatio_temp;
        OptMaxDD = OptMaxDD_temp;
        OptAnnualizedReturn = OptAnnualizedReturn_temp;
        OptNetProfit = OptNetProfit_temp;   
        OptContangoEntry = OptContangoEntry_temp;
        OptContango30Entry = OptContango30Entry_temp;
        OptContangoExit = OptContangoExit_temp; 
        OptContango30Exit = OptContango30Exit_temp;
        OptLongContangoEntry = OptLongContangoEntry_temp;
        OptLongContango30Entry = OptLongContango30Entry_temp;   


        NetLiqTotalBuyAndHold_Returns = tick2ret(NetLiqTotalBuyAndHold);
        NetLiqTotalBuyAndHold_Scaled = ret2price(NetLiqTotalBuyAndHold_Returns,initialportfolio,1,1,'Periodic');

        TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);  
    
            figure(999)
            plot(TradeDate,NetLiqTotalBuyAndHold_Scaled)

        disp('Buy and Hold Strategy complete');

    return; 

    else
       save('Volatility_Signals_linearopt') 

    end
    
    disp(TotalLinearOpt);
    disp('LO FINISHED RUNNING');
 % end of LO code
    
    
    
    
    
    
    
    
    
    
    
    
    


    % --------       GRAPHS N' SHIT    --------------------------------------
    % ------------------------------------------------------------------------------
    try
        
    load('Volatility_BuyAndHold.mat');
    NetLiqTotalBuyAndHold_Returns = tick2ret(NetLiqTotalBuyAndHold);
    %NetLiqTotalBuyAndHold_Returns = NetLiqTotalBuyAndHold_Returns(Serial_startdate:Serial_enddate, :);
    NetLiqTotalBuyAndHold_Scaled = ret2price(NetLiqTotalBuyAndHold_Returns,initialportfolio,1,1,'Periodic');
    TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);  
    %TradeDates = datetime(SERIAL_DATE_DATA,'ConvertFrom','datenum');
    figure(100)
    plot(TradeDate,NetLiqTotalBuyAndHold_Scaled)

                                                                %COMMENT -create title with all params values (optimized will change!!!) maybe add
    hold on
    plot(TradeDate,NetLiqOptimized)
    hold on                                                            %COMMENT -axis([FromDate ToDate])
    set(gca,'YScale','log')

    catch
       disp('ERROR IN GRAPH CODE, likely did NOT run BuyandHold after changing dates'); 
    end    
    %figure(101)

    %plot(TradeDates,CONTANGO)
    %hold on
    %plot(TradeDates,CONTANGO30)
    %axis([0 40 -70 -10])
    %figure(102)
    %plot(TradeDates,VIX)
    %axis([0 40 -70 -10])

    % *** how do i determine if a strategy is using a particular parameter? 
    % maybe use the "exist" function? - use it at the end of the stategy (which
    % is a function) then have the output variables be the "answer" to whether
    % the variables exist in that particular strategy. we can use the output to
    % either include or exclude those parameters in the "optimal parameter list
    % created from each days linear opt results"

    % we dont want to display parameters that are not used... if we just write
    % the stategy as a function, then call it in the linearopt code we are able
    % to modify/create as many strategies as we want and just switch out the
    % function call in the linearopt code. - we will want to save the
    % function/strategy name so we can refer to it later. we should have three
    % matrices ---(1 with just netliqtotal values for all the optimal steps, 1
    % with all the param values for each optimal step, and 1 for the name of
    % each stratgy used)--- Finally, we want to be able to append an excel
    % document to do this. if we need a counter, we should setup an if
    % statement that checks to see if the date is equal to the last time it was
    % run... if is equal, do nothing, if it is different, start a counter that
    % will be used to increment the columns in the excel doc to save all the
    % runs from one day. if they are not equal, after the run is over, then set
    % the variable equal to today... next time it runs, it will check the date,
    % the date will be the same, and nothing will happen.

    % next step is to build a small code that will read in the excel files, and
    % create a graph for us that overlays each stratgy.

    %create a FLOW CHART to show all the relationships between the different
    %backtester codes and functions. -- this is necessary!! keep shit straight

end




