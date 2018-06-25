load('Volatility_Parameters.mat');

        TradeNum = datenum(TradeDate);
        DateString = datestr(TradeDate,'MM/dd/yyyy');        
        TradeNum2 = datenum(DateString);
        TradeCell = cellstr(DateString);
ActiveContractsNum = datenum(ALL_EXP_MONTH);
%while loop
% 2 nested for loops from 1 to length of tradeDate
%   these will check each input to make sure it is a tradedate...
% we need to size all parameters separately from the table!
s1a = 1;
s1b = 1;
Emptycell = cell(1,1);
while s1a == 1

        try
        promptdateStart = {'Please Enter the Start Date in format MM/DD/YYYY: XIV trading begins 01/17/2012'};
        Start_title = 'DateRange Start Date';
        num_lines = 1;
        StartDateInput = inputdlg(promptdateStart,Start_title,num_lines);
       
        
        if isequal(StartDateInput,Emptycell)
            StartDateInput = '08/21/2006';
            
        end
        
        
        % at this point, we need to add a for loop that cycles through each contract expiration date
        % and checks *(if statement)* if startdateinput > contract
        % expiration date. IF true, then set variable equal to last counter
        
        s_date = datenum(StartDateInput, 'mm/dd/yyyy');
        ExpDates = cellstr(ContractExpirationDates);
          
        
        StartDateString = cellstr(StartDateInput);
        StartString = StartDateString{1};
        StartDateDateTime = datetime(StartDateInput,'InputFormat','MM/dd/yyyy');
        StartDateTime = datetime(StartDateDateTime,'Format','MM/dd/yyyy');
        StartDateNum = datenum(StartDateTime);
        validStr_start = validatestring(StartString,TradeCell); 
   
    for i =1:length(ALL_EXP_MONTH)
        if  TradeNum2(i,1) == StartDateNum
            RangeStartRow = i;
            s1a = 0;
            
        end       
    end
       
               
        catch
        warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday');
                
        end
     
         for j = 1:length(ContractExpirationDates)
           
            exp_date = datenum(ExpDates(j), 'mm/dd/yyyy');
            
            if exp_date > s_date
                expirationdateindex = j;
            break;
            end    
        
        end
        
end
 
         



while s1b == 1

        try
        promptdateEnd = {'Please Enter the Stop Date in format MM/DD/YYYY:'};
        Stop_title = 'DateRange Stop Date';
        num_lines = 1;
        StopDateInput = inputdlg(promptdateEnd,Stop_title,num_lines);
        
        if isequal(StopDateInput,Emptycell)
            StopDateInput = datestr(TradeDate(end,1), 'MM/dd/yyyy');
           
        end
        
        StopDateString = cellstr(StopDateInput);
        StopString = StopDateString{1};
        StopDateDateTime = datetime(StopDateInput,'InputFormat','MM/dd/yyyy');
        StopDateTime = datetime(StopDateDateTime,'Format','MM/dd/yyyy'); 
        StopDateNum = datenum(StopDateTime);
        validStr_stop = validatestring(StopString,TradeCell); 

        if StopDateNum < StartDateNum
            msg = 'Stop Date is not after the Start Date';
            uiwait(msgbox('Stop Date is not after the Start Date'));
            error(msg);
        end    
        
        
    for i =1:length(ALL_EXP_MONTH)
        if  TradeNum2(i,1) == StopDateNum
            RangeStopRow = i;
            
            s1b = 0;
        end       
    end
    
               
        catch
        warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday')
                
        end
               
end


    
clear('XIVindexstart','Emptycell','s1a','s1b','DateString','i','num_lines','promptdateEnd','promptdateStart','Start_title','StartDateDateTime','StartDateTime','StartString','Stop_title','StopDateDateTime','StopDateInput','StopDateString','StopDateTime','StopString','TradeCell','TradeNum','TradeNum2','validStr_start','validStr_stop');

%set index for sizing the XIV table (THE ASSET PRICE DATA!!)
XIVindexstart = 2024;


%size each variable.
    ALL_EXP_MONTH = ALL_EXP_MONTH(RangeStartRow:RangeStopRow, :); 
    AVCI = AVCI(RangeStartRow:RangeStopRow, :); 
    CONTANGO = CONTANGO(RangeStartRow:RangeStopRow, :);                
    CONTANGO2 = CONTANGO2(RangeStartRow:RangeStopRow, :); 
    CONTANGO_ROLL = CONTANGO_ROLL(RangeStartRow:RangeStopRow, :);      
    ROLL_YIELD = ROLL_YIELD(RangeStartRow:RangeStopRow, :); 
    SERIAL_DATE_DATA = SERIAL_DATE_DATA(RangeStartRow:RangeStopRow, :); 
    T1 = T1(RangeStartRow:RangeStopRow, :); 
    T2 = T2(RangeStartRow:RangeStopRow, :);                              
    T3 = T3(RangeStartRow:RangeStopRow, :);                           
    T4 = T4(RangeStartRow:RangeStopRow, :);                          
    T5 = T5(RangeStartRow:RangeStopRow, :);                             
    T6 = T6(RangeStartRow:RangeStopRow, :);                               
    T7 = T7(RangeStartRow:RangeStopRow, :);                                
    T8 = T8(RangeStartRow:RangeStopRow, :);                             
    T9 = T9(RangeStartRow:RangeStopRow, :);
    TargetWeightVX1 = TargetWeightVX1(RangeStartRow:RangeStopRow, :);                             
    TargetWeightVX2 = TargetWeightVX2(RangeStartRow:RangeStopRow, :);
    VX1 = VX1(RangeStartRow:RangeStopRow, :); 
    VX2 = VX2(RangeStartRow:RangeStopRow, :);                              
    VX3 = VX3(RangeStartRow:RangeStopRow, :);                           
    VX4 = VX4(RangeStartRow:RangeStopRow, :);                          
    VX5 = VX5(RangeStartRow:RangeStopRow, :);                             
    VX6 = VX6(RangeStartRow:RangeStopRow, :);                               
    VX7 = VX7(RangeStartRow:RangeStopRow, :);                                
    VX8 = VX8(RangeStartRow:RangeStopRow, :);                             
    VX9 = VX9(RangeStartRow:RangeStopRow, :); 
    TradeDate = TradeDate(RangeStartRow:RangeStopRow, :);
    TradeDay = TradeDay(RangeStartRow:RangeStopRow, :);
    ActiveContractsNum = ActiveContractsNum(RangeStartRow:RangeStopRow, :);
    ActiveContracts = ActiveContracts(RangeStartRow:RangeStopRow, :);
    %DateString = DateString(RangeStartRow:RangeStopRow, :);
    VIX = VIX(RangeStartRow:RangeStopRow, :);                           
    VXST_ROLL = VXST_ROLL(RangeStartRow:RangeStopRow, :);                          
    VXV_ROLL = VXV_ROLL(RangeStartRow:RangeStopRow, :);       
    V_DELTA = V_DELTA(RangeStartRow:RangeStopRow, :);        
    V_RATIO = V_RATIO(RangeStartRow:RangeStopRow, :);  
    VCO = VCO(RangeStartRow:RangeStopRow, :); 
    CONTANGO30 = CONTANGO30(RangeStartRow:RangeStopRow, :); 
    S30VX = S30VX(RangeStartRow:RangeStopRow, :);
    TradeDate_NumFormat = TradeDate_NumFormat(RangeStartRow:RangeStopRow, :);
    ExpDates = ExpDates(expirationdateindex:length(ContractExpirationDates), 1);
    
    %size asset price data
    if RangeStartRow < 2024
        
    elseif RangeStartRow >= 2024   
    
    XIVindexstop = RangeStopRow - XIVindexstart;    
    XIV_TableData = XIV_TableData(RangeStartRow-XIVindexstart:XIVindexstop,:);

    end



run('expirationdate_contractname.m');
clear('ActiveContractsNum','RangeStartRow','RangeStopRow','StartDateInput','StartDateNum','StartDateString','StopDateNum','XIVindexstart','a','i','j','s_date');

save('Volatility_Parameters_RangeDate');    