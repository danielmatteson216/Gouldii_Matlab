%                                    LINEAR OPTIMIZATION CODE
%
function [TotalLinearOpt,sigprevious,OptParameterA,OptParameterB,OptParameterC,OptParameterD,OptParameterE,OptParameterF,OptMaxDD,OptNetProfit,OptSharpeRatio,OptAnnualizedReturn,isfirstday,cashonweekendsflag,output]...
    = Gouldii_SignalsLinearOptimizer_v3(~, SelectedStrategy, Commission, initialportfolio, StopLoss,Serial_startdate_actual,Serial_enddate_actual,...
    OptimizedParameter1String,opt1numofsteps,opt1lowerbound,opt1upperbound,OptimizedParameter2String,opt2numofsteps,opt2lowerbound,opt2upperbound,...
    OptimizedParameter3String,opt3numofsteps,opt3lowerbound,opt3upperbound,OptimizedParameter4String,opt4numofsteps,opt4lowerbound,opt4upperbound,...
    ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,isfirstday,startdate_string,sigprevious,isWFA,isMA)

addpath('Strategies');

 % GET DATA FROM GUI  --- Entire database is loaded in the following line
 % (minus tradedate)
%----------------------------------------------------------------------------------------------------------------------   
load('db_historicaldata.mat');
load('db_tradedate.mat');

% print all in sample wfa runs in excel ("1" = print all)
wfalongexcel = 1;

            assignin('base','sigprevious',sigprevious);
            assignin('base','VIX_VIX3M',VIX_VIX3M);
            assignin('base','VIX_VIX6M',VIX_VIX6M);
            assignin('base','VIX9D_VIX',VIX9D_VIX);
            assignin('base','VIX',VIX);
            assignin('base','VIX_ma50d',VIX_ma50d);
            assignin('base','VIX_ma20d',VIX_ma20d); 
            assignin('base','VIX_ma200d',VIX_ma200d);            
            assignin('base','VIX9D_ma50d',VIX9D_ma50d);
            assignin('base','VIX9D_VIX_ma50d',VIX9D_VIX_ma50d);            
            assignin('base','CONTANGO',CONTANGO);
            assignin('base','CONTANGO30',CONTANGO30);
            assignin('base','TargetWeightVX1_S30',TargetWeightVX1_S30);
            assignin('base','TargetWeightVX2_S30',TargetWeightVX2_S30);
            assignin('base','TargetWeightVX1_S45',TargetWeightVX1_S45);
            assignin('base','TargetWeightVX2_S45',TargetWeightVX2_S45);
            assignin('base','curve_tickers',curve_tickers);    
            assignin('base','TradeDate_NumFormat',TradeDate_NumFormat);
            %assignin('base','isopt1on',isopt1on);            
            %assignin('base','isopt2on',isopt2on);
            %assignin('base','isopt3on',isopt3on);
            %assignin('base','isopt4on',isopt4on);            
%            evalin('base',isWFA);

isopt1on = evalin('base','isopt1on');   
isopt2on = evalin('base','isopt2on');   
isopt3on = evalin('base','isopt3on');   
isopt4on = evalin('base','isopt4on');   



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
    
        isfirstday = 0;  


        
        
        
  % deal with the god damn optimized parameters here!!!      
        
        
        

    h1 = (opt1upperbound - opt1lowerbound) / opt1numofsteps;
    h2 = (opt2upperbound - opt2lowerbound) / opt2numofsteps;    
    h3 = (opt3upperbound - opt3lowerbound) / opt3numofsteps;
    h4 = (opt4upperbound - opt4lowerbound) / opt4numofsteps;    
    
    OptimizedParameter1 = (opt1lowerbound:h1:opt1upperbound);
    OptimizedParameter2 = (opt2lowerbound:h2:opt2upperbound);    
    OptimizedParameter3 = (opt3lowerbound:h3:opt3upperbound);    
    OptimizedParameter4 = (opt4lowerbound:h4:opt4upperbound);
    
    % is this okay???? do we need it??
    if isnan(h1)
        h1 = 1; 
        OptimizedParameter1 = 0;        
    end
    if isnan(h2)
        h2 = 1;   
        OptimizedParameter2 = 0;        
    end    
    if isnan(h3)
        h3 = 1; 
        OptimizedParameter3 = 0;        
    end    
    if isnan(h4)
        h4 = 1;    
        OptimizedParameter4 = 0;        
    end    
    
% isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA
%     isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA
%check to make sure each value is an integer if isMA 

if isMA == 1
    isIntOpt1 = any(mod(OptimizedParameter1,1) ~= 0);
    isIntOpt2 = any(mod(OptimizedParameter2,1) ~= 0);
    isIntOpt3 = any(mod(OptimizedParameter3,1) ~= 0);
    isIntOpt4 = any(mod(OptimizedParameter4,1) ~= 0);
    
    if isIntOpt1 == 1
        OptimizedParameter1 = floor(OptimizedParameter1);  % round down
    end
    if isIntOpt2 == 1
        OptimizedParameter2 = floor(OptimizedParameter2);  
    end    
    if isIntOpt3 == 1
        OptimizedParameter3 = floor(OptimizedParameter3);  % round down
    end
    if isIntOpt4 == 1
        OptimizedParameter4 = floor(OptimizedParameter4);  
    end   

    for i = 1 : length(OptimizedParameter1)    
        if OptimizedParameter1(i) == 0 || isnan(OptimizedParameter1(i)) == 1
            OptimizedParameter1(i) = 1; % set default moving averages
        end
    end

    for i = 1 : length(OptimizedParameter2)    
        if OptimizedParameter2(i) == 0 || isnan(OptimizedParameter2(i)) == 1
            OptimizedParameter2(i) = 1; % set default moving averages       
        end
    end    

    for i = 1 : length(OptimizedParameter3)        
        if OptimizedParameter3(i) == 0 || isnan(OptimizedParameter3(i)) == 1
            OptimizedParameter3(i) = 1; % set default moving averages        
        end
    end

    for i = 1 : length(OptimizedParameter4)        
        if OptimizedParameter4(i) == 0 || isnan(OptimizedParameter4(i)) == 1
            OptimizedParameter4(i) = 1; % set default moving averages       
        end    
    end

end
% isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA
%     isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA   isMA        



% if (opt1numofsteps == 0 || isnan(opt1numofsteps) == 1 || h1 == Inf) && opt1upperbound == 0 && opt1lowerbound ~= 0
%     OptimizedParameter1 = opt1lowerbound;
% elseif (opt1numofsteps == 0 || isnan(opt1numofsteps) == 1 || h1 == Inf) && opt1upperbound ~= 0 && opt1lowerbound == 0    
%     OptimizedParameter1 = opt1upperbound;
% elseif (opt1numofsteps == 0 || isnan(opt1numofsteps) == 1 || h1 == Inf) && opt1upperbound ~= 0 && opt1lowerbound ~= 0  
%     OptimizedParameter1 = opt1lowerbound;
% elseif (opt1numofsteps == 0 || isnan(opt1numofsteps) == 1 || h1 == Inf) && opt1upperbound == 0 && opt1lowerbound == 0  
%     OptimizedParameter1 = opt1lowerbound;
% end    

% if (opt2numofsteps == 0 || isnan(opt2numofsteps) == 1 || h2 == Inf) && opt2upperbound == 0 && opt2lowerbound ~= 0
%     OptimizedParameter2 = opt2lowerbound;
% elseif (opt2numofsteps == 0 || isnan(opt2numofsteps) == 1 || h2 == Inf) && opt2upperbound ~= 0 && opt2lowerbound == 0    
%     OptimizedParameter2 = opt2upperbound;
% elseif (opt2numofsteps == 0 || isnan(opt2numofsteps) == 1 || h2 == Inf) && opt2upperbound ~= 0 && opt2lowerbound ~= 0  
%     OptimizedParameter2 = opt2lowerbound;    
% elseif (opt2numofsteps == 0 || isnan(opt2numofsteps) == 1 || h2 == Inf) && opt2upperbound == 0 && opt2lowerbound == 0  
%     OptimizedParameter2 = opt2lowerbound;
% end 

% if (opt3numofsteps == 0 || isnan(opt3numofsteps) == 1 || h3 == Inf) && opt3upperbound == 0 && opt3lowerbound ~= 0
%     OptimizedParameter3 = opt3lowerbound;
% elseif (opt3numofsteps == 0 || isnan(opt3numofsteps) == 1 || h3 == Inf) && opt3upperbound ~= 0 && opt3lowerbound == 0    
%     OptimizedParameter3 = opt3upperbound;
% elseif (opt3numofsteps == 0 || isnan(opt3numofsteps) == 1 || h3 == Inf) && opt3upperbound ~= 0 && opt3lowerbound ~= 0  
%     OptimizedParameter3 = opt3lowerbound;
% elseif (opt3numofsteps == 0 || isnan(opt3numofsteps) == 1 || h3 == Inf) && opt3upperbound == 0 && opt3lowerbound == 0  
%     OptimizedParameter3 = opt3lowerbound;
% end    

% if (opt4numofsteps == 0 || isnan(opt4numofsteps) == 1 || h4 == Inf) && opt4upperbound == 0 && opt4lowerbound ~= 0
%     OptimizedParameter4 = opt4lowerbound;
% elseif (opt4numofsteps == 0 || isnan(opt4numofsteps) == 1 || h4 == Inf) && opt4upperbound ~= 0 && opt4lowerbound == 0    
%     OptimizedParameter4 = opt4upperbound;
% elseif (opt4numofsteps == 0 || isnan(opt4numofsteps) == 1 || h4 == Inf) && opt4upperbound ~= 0 && opt4lowerbound ~= 0  
%     OptimizedParameter4 = opt4lowerbound;    
% elseif (opt4numofsteps == 0 || isnan(opt4numofsteps) == 1 || h4 == Inf) && opt4upperbound == 0 && opt4lowerbound == 0  
%     OptimizedParameter4 = opt4lowerbound;
% end 


  % deal with the god damn optimized parameters here!!!   

  
  
% -------------------------------------------------------------------------
%                    CODE LOOPS START HERE
% -------------------------------------------------------------------------
Serial_startdate = datefind(Serial_startdate_actual,SERIAL_DATE_DATA);
Serial_enddate = datefind(Serial_enddate_actual,SERIAL_DATE_DATA);
 
%initialize flags
%flag_future = 1;
 j = 1;
 k = 1;
 m = 1;
 p = 1;

counter = 0;

loop4Pcnt = 0;
loop3Kcnt = 0;
loop2Mcnt = 0;
loop1Jcnt = 0;

 %XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 
     for p = 1:length(OptimizedParameter4)
        OptimizedParameter4Specific = OptimizedParameter4(p);
        loop4Pcnt = loop4Pcnt + 1;
        
        if isopt4on == 1    
            
            if strcmp(OptimizedParameter4String, 'ParameterA')
                 ParameterA = OptimizedParameter4Specific ;
                elseif strcmp(OptimizedParameter4String, 'ParameterB')
                 ParameterB = OptimizedParameter4Specific ; 
                elseif strcmp(OptimizedParameter4String, 'ParameterC')
                 ParameterC = OptimizedParameter4Specific ; 
                elseif strcmp(OptimizedParameter4String, 'ParameterD')
                 ParameterD = OptimizedParameter4Specific ; 
                elseif strcmp(OptimizedParameter4String, 'ParameterE')
                 ParameterE = OptimizedParameter4Specific ;
                elseif strcmp(OptimizedParameter4String, 'ParameterF')
                 ParameterF = OptimizedParameter4Specific ; 
            end     
            
        end
        
        
        for k = 1:length(OptimizedParameter3)
            OptimizedParameter3Specific = OptimizedParameter3(k);
            loop3Kcnt = loop3Kcnt + 1;  
            
            if isopt3on == 1   

                if strcmp(OptimizedParameter3String, 'ParameterA')
                     ParameterA = OptimizedParameter3Specific ;
                     elseif strcmp(OptimizedParameter3String, 'ParameterB')
                     ParameterB = OptimizedParameter3Specific ; 
                     elseif strcmp(OptimizedParameter3String, 'ParameterC')
                     ParameterC = OptimizedParameter3Specific ; 
                     elseif strcmp(OptimizedParameter3String, 'ParameterD')
                     ParameterD = OptimizedParameter3Specific ; 
                     elseif strcmp(OptimizedParameter3String, 'ParameterE')
                     ParameterE = OptimizedParameter3Specific ;
                     elseif strcmp(OptimizedParameter3String, 'ParameterF')
                     ParameterF = OptimizedParameter3Specific ; 
                end
                
            end
                
                for m = 1:length(OptimizedParameter2)
                    OptimizedParameter2Specific = OptimizedParameter2(m);
                    loop2Mcnt = loop2Mcnt + 1; 
                    
                    if isopt2on == 1 

                            if strcmp(OptimizedParameter2String, 'ParameterA')
                                ParameterA = OptimizedParameter2Specific ;
                                elseif strcmp(OptimizedParameter2String, 'ParameterB')
                                 ParameterB = OptimizedParameter2Specific ; 
                                elseif strcmp(OptimizedParameter2String, 'ParameterC')
                                 ParameterC = OptimizedParameter2Specific ; 
                                elseif strcmp(OptimizedParameter2String, 'ParameterD')
                                 ParameterD = OptimizedParameter2Specific ; 
                                elseif strcmp(OptimizedParameter2String, 'ParameterE')
                                 ParameterE = OptimizedParameter2Specific ;
                                elseif strcmp(OptimizedParameter2String, 'ParameterF')
                                 ParameterF = OptimizedParameter2Specific ; 
                            end
                    end
                    
                    
                        for j = 1:length(OptimizedParameter1)
                            OptimizedParameter1Specific = OptimizedParameter1(j);
                            loop1Jcnt = loop1Jcnt + 1; 
                            
                            if isopt1on == 1 

                                    if strcmp(OptimizedParameter1String, 'ParameterA')
                                        ParameterA = OptimizedParameter1Specific ;
                                        elseif strcmp(OptimizedParameter1String, 'ParameterB')
                                         ParameterB = OptimizedParameter1Specific ; 
                                        elseif strcmp(OptimizedParameter1String, 'ParameterC')
                                         ParameterC = OptimizedParameter1Specific ; 
                                        elseif strcmp(OptimizedParameter1String, 'ParameterD')
                                         ParameterD = OptimizedParameter1Specific ; 
                                        elseif strcmp(OptimizedParameter1String, 'ParameterE')
                                         ParameterE = OptimizedParameter1Specific ;
                                        elseif strcmp(OptimizedParameter1String, 'ParameterF')
                                         ParameterF = OptimizedParameter1Specific ; 
                                    end 
                            end
            
                    
                
                SelectedStrategy_temp = SelectedStrategy(1:end-2);
                SelectedStrategy_input = str2func(SelectedStrategy_temp);
                
                
                % Determine if strategy is BuyandHold
                if strcmp(SelectedStrategy, 'Gouldii_Strategy_BuyandHold_v2.m') 
                    StopLoss = 100;
                    cashonweekendsflag = 0;
                else
                    cashonweekendsflag = 1;
                end     

    %----------------------------------------------------------------------------------------------------------------------    

 

  %=======================================================================
  %   ===============        CALL STRATEGY       ===================
  %=======================================================================
try
                [sigprevious,sigw1,sigw2,ticker1,ticker2] = feval(SelectedStrategy_input,Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,...
                                                                  ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,...
                                                                  TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO,...
                                                                  VIX_VIX3M,VIX_VIX6M,VIX9D_VIX,VIX_ma50d,VIX9D_ma50d,VIX9D_VIX_ma50d,VIX_ma20d,VIX_ma200d,VIX);
 


                sigw1vec(:,j,m) = sigw1;
                sigw2vec(:,j,m) = sigw2;
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
  % CREATE OUTPUT GRAPHS AND SPREADSHEETS                                                
  %----------------------------------------------------------------------------------------------------------------------                                                   


                OUTPUT_CELL_ARRAY{j} = finaloutput;
                
        %save the netliq, sharperatio, and cummROR
                NetLiqTotal(:,j) = OUTPUT_CELL_ARRAY{1,j}(2:end,30);
                SharpeRatio(1,j) = OUTPUT_CELL_ARRAY{1,j}(end,47);
                CummROR(1,j) = cell2mat(OUTPUT_CELL_ARRAY{1,j}(end,46));
                %CummROR = cell2mat(CummRORcell);
        %calculate netprofit         
                NetProfit(1,j) = cell2mat(NetLiqTotal(end,j)) - cell2mat(NetLiqTotal(1,j));

                counter = counter + 1;     

                
                %stupid netliq total positve/negative test --> CAN WE DELETE THIS?
                %#######################################################
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
                %#######################################################

                    
                % this is the linear optimizer output!!!
                % -------------------------------------------------------
                LinearOptResults(j,1) = num2cell(ParameterA);           
                LinearOptResults(j,2) = num2cell(ParameterB);
                LinearOptResults(j,3) = num2cell(ParameterC);
                LinearOptResults(j,4) = num2cell(ParameterD);
                LinearOptResults(j,5) = num2cell(ParameterE);
                LinearOptResults(j,6) = num2cell(ParameterF);           
                LinearOptResults(j,7) = num2cell(MaxDD(j,1));
                LinearOptResults(j,8) = num2cell(NetProfit(1,j));
                LinearOptResults(j,9) = SharpeRatio(1,j);
                LinearOptResults(j,10) = num2cell(((1+CummROR(1,j))^(365/length(sigw1)))-1);
                %LinearOptResults(j,10) = num2cell(MaxDDindex(1,j));
                % -------------------------------------------------------
                
                
 LinearOpt2_OUTPUT_CELL_ARRAY(1,counter) = OUTPUT_CELL_ARRAY(1,j);

                            LinearOptimizerResults(counter,:) = LinearOptResults(j,:); 
                            %LinearOptResults(j,:) = [];
                            
                end   %end of INSIDE LINEAR OPT LOOP (j loop)
 
            end   %end of INSIDE LINEAR OPT LOOP (m loop)          
                                                
        end   %end of INSIDE LINEAR OPT LOOP (k loop)
            
     end  %end of OUTSIDE LINEAR OPT LOOP (p loop)

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 
    %this is likely not needed. it was a debugging tool. 
    
%    if NetLiqTotalempty == 0
%    disp('Net Liq is negative');
%    elseif NetLiqTotalempty == 1
%    disp('Net Liq is positive');
%    end
 


    
    MaxDrawdowntotal = horzcat(MaxDD,MaxDDindex);

    clear('emptycell68','XIVindexstop','TradeDate_cellarray','TradeDate_String','ans','emptycell79','EXCEL_ALGO_SIGNAL','DVT_sigNUM','k','lastrowend','lengthofsignals','output_file_ToadCentral','p','y','AVCI','SERIAL_DATE_LEN','VCO_direction','VTRO','VTRO_direction','VTRO_int','VXST_ROLL','VXV_ROLL','i','j')


    %xlswrite('TOTAL_OUTPUT_ARRAY.xlsx',TOTAL_OUTPUT_ARRAY);
    xlswrite('LinearOptResults.xlsx',LinearOptResults);

    %remove the initial value row from the net liq output array
    NetLiqTotalMatrix = NetLiqTotalMatrix(2:end,:);

    % this is the objective function portion!!!!
    %LinearOptResults

    %-----------------------------------
    %calculate the annualized return:
    [MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptimizerResults(1:end,9)))         ; 
    [MaxAnnualizedReturn,MaxAnnualizedReturnIndex] = max(cell2mat(LinearOptimizerResults(1:end,10)))    ;
    %-----------------------------------

    %this should identify which output array is the optimal output array
    output = LinearOpt2_OUTPUT_CELL_ARRAY{MaxSharpeIndex};    
    
    

    OptParameterA = LinearOptimizerResults{MaxSharpeIndex,1};
    OptParameterB = LinearOptimizerResults{MaxSharpeIndex,2};
    OptParameterC = LinearOptimizerResults{MaxSharpeIndex,3};
    OptParameterD = LinearOptimizerResults{MaxSharpeIndex,4};
    OptParameterE = LinearOptimizerResults{MaxSharpeIndex,5};
    OptParameterF = LinearOptimizerResults{MaxSharpeIndex,6};
    OptMaxDD = LinearOptimizerResults{MaxSharpeIndex,7};
    OptNetProfit = LinearOptimizerResults{MaxSharpeIndex,8};
    OptSharpeRatio = LinearOptimizerResults{MaxSharpeIndex,9};
    OptAnnualizedReturn = LinearOptimizerResults{MaxSharpeIndex,10};


    LinearOpt3Labels = {'ParameterA','ParameterB','ParameterC','ParameterD','ParameterE','ParameterF','MaxDD','NetProfit','SharpeRatio','AnnualizedReturn'};

    TotalLinearOpt3 = [LinearOptimizerResults(1:end,1),LinearOptimizerResults(1:end,2),LinearOptimizerResults(1:end,3),LinearOptimizerResults(1:end,4),LinearOptimizerResults(1:end,5),LinearOptimizerResults(1:end,6),LinearOptimizerResults(1:end,7),LinearOptimizerResults(1:end,8),LinearOptimizerResults(1:end,9),LinearOptimizerResults(1:end,10)];

    TotalLinearOpt = cat(1,LinearOpt3Labels, TotalLinearOpt3);

stratpath = 'C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\';
strategypath = strcat(stratpath, SelectedStrategy_temp, '\');
strategypathResults = strcat(strategypath,'Results\');
strategypathOptParams = strcat(strategypath,'OptParams\');
strategypathWFA = strcat(strategypath,'WFA\');

now = datetime('now','Format','yyyyMMdd_HHmmss');
now = datestr(now,'yyyymmdd_HHMMss');
sdate = datestr(Serial_startdate_actual,'yyyymmdd');
edate = datestr(Serial_enddate_actual,'yyyymmdd');

strategypath_output = strcat(strategypathResults,sdate,'_',edate,'_');
strategypath_output = strcat(strategypath_output,'OptResultsOutputArray_',now,'.xlsx');

strategypathWFA = strcat(strategypathWFA,sdate,'_',edate,'_');
strategypathWFA = strcat(strategypathWFA,'WFA_',now,'.xlsx');

strategypath_maxdd = strcat(strategypathResults,sdate,'_',edate,'_');
strategypath_maxdd = strcat(strategypath_maxdd,'MaxDrawdowntotal_',now,'.xlsx');

strategypath_linearopt = strcat(strategypathOptParams,sdate,'_',edate,'_');
strategypath_linearopt = strcat(strategypath_linearopt,'LinearOptResults_',now,'.xlsx');



if isWFA == 0

        try
            xlswrite(strategypath_output,output);                     
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


else
   
%print results of IN-SAMPLE runs
    if wfalongexcel == 1
            xlswrite(strategypathWFA,output);  
    end


end










%end
    NetLiqOptimized(:,1) = NetLiqTotalMatrix(:,MaxSharpeIndex); 
return;
%    if strcmp(SelectedStrategy, 'Gouldii_Strategy_BuyandHold_v1.m')
%        NetLiqTotalBuyAndHold = NetLiqOptimized;
%        OptSharpeRatio_temp = OptSharpeRatio;
%        OptMaxDD_temp = OptMaxDD;
%        OptAnnualizedReturn_temp = OptAnnualizedReturn;
%        OptNetProfit_temp = OptNetProfit;
%        OptParameterA_temp = OptParameterA;
%        OptParameterB_temp = OptParameterB;
%        OptParameterC_temp = OptParameterC; 
%        OptParameterD_temp = OptParameterD;
%        OptParameterE_temp = OptParameterE;
%        OptParameterF_temp = OptParameterF;     

%        clear('OptParameterF','OptParameterE','OptParameterD','OptParameterC','OptParameterB','OptParameterA','OptSharpeRatio','OptMaxDD','OptAnnualizedReturn','OptNetProfit','MaxDrawdowntotal','MaxAnnualizedReturnIndex','MaxAnnualizedReturn','MaxSharpe','NetLiqOptimized','LinearOptimizerResults','MaxDD','NetProfit','NetLiqTotalMatrix','MaxSharpeIndex','TotalLinearOpt','TotalLinearOpt3','LinearOpt3Labels')

%        save('Volatility_BuyAndHold')

%        OptSharpeRatio = OptSharpeRatio_temp;
%        OptMaxDD = OptMaxDD_temp;
%        OptAnnualizedReturn = OptAnnualizedReturn_temp;
%        OptNetProfit = OptNetProfit_temp;   
%        OptParameterA = OptParameterA_temp;
%        OptParameterB = OptParameterB_temp;qaa``   
%        OptParameterC = OptParameterC_temp; 
%        OptParameterD = OptParameterD_temp;
%        OptParameterE = OptParameterE_temp;
%        OptParameterF = OptParameterF_temp;   


%        NetLiqTotalBuyAndHold_Returns = tick2ret(NetLiqTotalBuyAndHold);
%        NetLiqTotalBuyAndHold_Scaled = ret2price(NetLiqTotalBuyAndHold_Returns,initialportfolio,1,1,'Periodic');

%        TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);  
    
%            fig1k = figure(1000);
%            plot(TradeDate,NetLiqTotalBuyAndHold_Scaled)
            %pause(1);
            %close(fig1k);
%            hold on
        %disp('Buy and Hold Strategy complete');

%    return; 

%    else
%       save('Volatility_Signals_linearopt') 

%    end

%    hold off
%    close(fig1k);
%    disp(TotalLinearOpt);
%    disp('LO FINISHED RUNNING');
    
    
    
 % end of LO code
    
    
    
    
    
    
    
    
    
    
    
    
    


    % --------       GRAPHS N' SHIT    --------------------------------------
    % ------------------------------------------------------------------------------
%    try
        
%    load('Volatility_BuyAndHold.mat');
%    NetLiqTotalBuyAndHold_Returns = tick2ret(NetLiqTotalBuyAndHold);
%    NetLiqTotalBuyAndHold_Scaled = ret2price(NetLiqTotalBuyAndHold_Returns,initialportfolio,1,1,'Periodic');
%    TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);  

%    figure(100)
%    plot(TradeDate,NetLiqTotalBuyAndHold_Scaled)

                                                                %COMMENT -create title with all params values (optimized will change!!!) maybe add
%    hold on
%    plot(TradeDate,NetLiqOptimized)
%    hold on                                                            %COMMENT -axis([FromDate ToDate])
%    set(gca,'YScale','log')

%    catch
%       disp('ERROR IN GRAPH CODE, likely did NOT run BuyandHold after changing dates'); 
%    end   
    
    
    
    
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




