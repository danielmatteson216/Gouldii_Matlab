%% 
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%   Written By: Daniel James Matteson
%   Name - Date:
%   VIX_algo_version_3_Parameters - 5/22/2017

%   Description:
%   This code is used to calculate all the input parameters required for
%   the SIGNALS code, which is used in the WFAtoolbox for startegy analysis

%   User Definied functions used in code:
%   "all_contract_expiry_test"
%   Input parameters: month_input, year_input
%   Output parameter: Contract Expiration Date

%   Required Input Parameters: (Historical Term Structure and VIX indexes) 
%                   VIX             DataType: Double
%                   VX1             DataType: Double
%                   VX2             DataType: Double
%                   VX3             DataType: Double
%                   VX4             DataType: Double
%                   VX5             DataType: Double
%                   VX6             DataType: Double
%                   VX7             DataType: Double
%                   VX8             DataType: Double
%                   VX9             DataType: Double
%                   VXST            DataType: Double
%                   VXMT            DataType: Double
%                   VXV             DataType: Double
%                   TradeDate       DataType: DateTime


%   Output Parameters: 
%                   T1
%                   T2
%                   T3
%                   T4
%                   T5
%                   T6
%                   T7
%                   T8
%                   T9
%                   Contango
%                   Contango 2
%                   Contango Roll
%                   Roll Yield
%                   AVCI
%                   VDelta
%                   VRatio
%                   VXST Roll
%                   VXV Roll
%                   (All Exp Month)
%                   (Serial Date Data)

%   OUTLINE:
%       1)  Load VIX parameters
%               1.1) Load "Volatility_GetData.mat" Parameters
%       2)  Trade Date
%               2.1) Trade Date Format
%       3)  Initialize Variables  
%               3.1) Time Till Expiry Cell Array Initialization
%       4)  Calculate Parameters
%               4.1) Make Scaling Adjustments to Term Structure
%               4.2) Calculate The Signals Parameters
%       5)  Term Structure Expiration Dates (VX1 - VX9 exp. dates)
%               5.1) Contract Expiration Dates
%       6)  Time Till Expiration
%               6.1) Calculate Time Till Expiry 
%       7)  VCO Calculation
%               7.1) VCO definition
%       8)  Clear Excess Workspace Objects
%               8.1) Remove Extra Workspace Variables
%       9)  Save Workspace To File
%               9.1) Save Remaining Workspace Objects To File
%       10)  Output To CSV File
%               10.1) Save Parameters To CSV File 
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX








%=========================================================================
%-------------------------------------------------------------------------
%                 #1) LOAD VIX PARAMETERS
%                       1.1) Load "Volatility_GetData.mat" Parameters
%-------------------------------------------------------------------------
%   1.1) Load "Volatility_GetData.mat" Parameters
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section loads the most recent saved version of the VIX
% parameters (this is the output from the GetData code)
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%load the workspace objects
%load('Volatility_GetData.mat');
%-------------------------------------------------------------------------
%=========================================================================










%=========================================================================
%-------------------------------------------------------------------------
%                 #2) TRADE DATE
%                       2.1) Trade Date Format
%-------------------------------------------------------------------------
%   2.1) Trade Date Format
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section formats trade date vector in a manner that is
% necessary for future calculations, namely the date difference
% calculation needed for Time till expiry.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%convert TradeDate in datetime format to string
Date_string = datestr(TradeDate, 'MM/dd/yyyy');

%convert date vector into serial
SERIAL_DATE_DATA = datenum(Date_string);

%convert the date to a vector
Date_vector = datevec(SERIAL_DATE_DATA);
TradeDate_converted = datetime(Date_string,'Format','d-MMM-y');
TradeDate_NumFormat = yyyymmdd(TradeDate_converted);

%-------------------------------------------------------------------------
%=========================================================================











%=========================================================================
%-------------------------------------------------------------------------
%                 #3) INITIALIZE VARIABLES
%                       3.1) Time Till Expiry Cell Array Initialization
%-------------------------------------------------------------------------
%   3.1) Time Till Expiry Cell Array Initialization
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to initialize all the
% necessary cell arrays to be filled with data in a subsequent section.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%initialize time to expiry variables as cell arrays      
T1 = [];
T2 = [];
T3 = [];
T4 = [];
T5 = [];
T6 = [];
T7 = [];
T8 = [];
T9 = [];

%-------------------------------------------------------------------------
%=========================================================================






        



%=========================================================================
%-------------------------------------------------------------------------
%                 #4) CALCULATE PARAMETERS
%                       4.1) Make Scaling Adjustments to Term Structure
%                       4.2) Calculate The Signals Parameters
%-------------------------------------------------------------------------
%   4.1) Make Scaling Adjustments to Term Structure
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section performs all the data scaling necessary for the
% term structure closing prices from inception till 3/27/2006?
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%Scale the term structure because CBOE are stupid jews
for s4c = 1:length(TradeDate)
    
    if s4c <= 811
       
        VX1(s4c) = VX1(s4c)*(.1);
        VX2(s4c) = VX2(s4c)*(.1);
        VX3(s4c) = VX3(s4c)*(.1);
        VX4(s4c) = VX4(s4c)*(.1);
        VX5(s4c) = VX5(s4c)*(.1);
        VX6(s4c) = VX6(s4c)*(.1);
        VX7(s4c) = VX7(s4c)*(.1);
        VX8(s4c) = VX8(s4c)*(.1);
        VX9(s4c) = VX9(s4c)*(.1);

    end    
    
end

%   4.2) Calculate The Signals Parameters
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section performs all the calculations necessary to
% create the input parameters for the "Signals" code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%calculate the  vix parameters
CONTANGO = (VX2./VX1) - 1;
CONTANGO2 = (VX3./VX2) - 1;
ROLL_YIELD = (VX1./VIX) - 1;
V_RATIO = (VXV./VIX) - 1;
V_DELTA = (VIX - VXST);
VXV_ROLL = (VXV./VX2) - 1;
VXST_ROLL = (VIX./VXST) - 1;
CONTANGO_ROLL = (VX2./VIX) - 1;
VIX_MA50 =  tsmovavg(VIX,'s',50,1);


%set all NaN values to 0 in order to perform matrix operations
CONTANGO(isnan(CONTANGO)) = 0;
CONTANGO2(isnan(CONTANGO2)) = 0;
ROLL_YIELD(isnan(ROLL_YIELD)) = 0;
V_RATIO(isnan(V_RATIO)) = 0;
V_DELTA(isnan(V_DELTA)) = 0;


    for s4a = 1:numel(SERIAL_DATE_DATA)

        %calculate AVCI even though some have 0's...
        AVCI_intermediate = [VIX(s4a),VX1(s4a),VX2(s4a),VX3(s4a),VX4(s4a),VX5(s4a),VX6(s4a),VX7(s4a),VX8(s4a),VX9(s4a),VXV(s4a),VXST(s4a),VXMT(s4a)];
        %sum each days future closing prices -- not including future prices that contain a 0 
        vix_futures_sum = sum(AVCI_intermediate~=0);
        vix_futures_sum(vix_futures_sum==0) = NaN;
        %average is of only futures prices that have a value
        AVCI(s4a) = sum(AVCI_intermediate)./vix_futures_sum;
        %create column vector
        AVCI = AVCI(:);
%-------------------------------------------------------------------------
%=========================================================================





    




%=========================================================================
%-------------------------------------------------------------------------
%                 #5) TERM STRUCTURE EXPIRATION DATES (VX1 - VX9 EXP. DATES)
%                       5.1) Contract Expiration Dates
%-------------------------------------------------------------------------
%   5.1) Contract Expiration Dates
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section calls the "all_contract_expiry_test" function
% in order to calculate all the contracts expiration dates. This data is
% needed to calculate the Time till expiry everyday for each continuous
% contract.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        %month and year input into all contract expiry function for every day.
        month_input = Date_vector(s4a,2);
        year_input = Date_vector(s4a,1);   

        %RUN ALL CONTRACT EXPIRY TEST FUNCTION and save to array
        ALL_EXP_MONTH(s4a,1) = all_contract_expiry_test(month_input, year_input);
        ALL_EXP_MONTH(s4a,2) = all_contract_expiry_test(month_input + 1, year_input);
        ALL_EXP_MONTH(s4a,3) = all_contract_expiry_test(month_input + 2, year_input);
        ALL_EXP_MONTH(s4a,4) = all_contract_expiry_test(month_input + 3, year_input);
        ALL_EXP_MONTH(s4a,5) = all_contract_expiry_test(month_input + 4, year_input);
        ALL_EXP_MONTH(s4a,6) = all_contract_expiry_test(month_input + 5, year_input);
        ALL_EXP_MONTH(s4a,7) = all_contract_expiry_test(month_input + 6, year_input);
        ALL_EXP_MONTH(s4a,8) = all_contract_expiry_test(month_input + 7, year_input);
        ALL_EXP_MONTH(s4a,9) = all_contract_expiry_test(month_input + 8, year_input);
%-------------------------------------------------------------------------
%=========================================================================





   




%=========================================================================
%-------------------------------------------------------------------------
%                 #6) TIME TILL EXPIRY
%                       6.1) Calculate Time Till Expiry 
%-------------------------------------------------------------------------
%   6.1) Calculate Time Till Expiry 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section calculates the time till expiration for each of
% the continuous contracts for every trading date.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            
        %calculate whether the contract expiration has passed the trading date
        if TradeDate_converted(s4a) < ALL_EXP_MONTH(s4a,1)
            TVX1(s4a) = ALL_EXP_MONTH(s4a,1) - TradeDate_converted(s4a);
            TVX2(s4a) = ALL_EXP_MONTH(s4a,2) - TradeDate_converted(s4a);     
            TVX3(s4a) = ALL_EXP_MONTH(s4a,3) - TradeDate_converted(s4a);     
            TVX4(s4a) = ALL_EXP_MONTH(s4a,4) - TradeDate_converted(s4a);     
            TVX5(s4a) = ALL_EXP_MONTH(s4a,5) - TradeDate_converted(s4a);     
            TVX6(s4a) = ALL_EXP_MONTH(s4a,6) - TradeDate_converted(s4a);
            TVX7(s4a) = ALL_EXP_MONTH(s4a,7) - TradeDate_converted(s4a);
            TVX8(s4a) = ALL_EXP_MONTH(s4a,8) - TradeDate_converted(s4a);
            TVX9(s4a) = ALL_EXP_MONTH(s4a,9) - TradeDate_converted(s4a);
     
        elseif TradeDate_converted(s4a) >= ALL_EXP_MONTH(s4a,1)       
            TVX1(s4a) = ALL_EXP_MONTH(s4a,2) - TradeDate_converted(s4a);
            TVX2(s4a) = ALL_EXP_MONTH(s4a,3) - TradeDate_converted(s4a); 
            TVX3(s4a) = ALL_EXP_MONTH(s4a,4) - TradeDate_converted(s4a);     
            TVX4(s4a) = ALL_EXP_MONTH(s4a,5) - TradeDate_converted(s4a);         
            TVX5(s4a) = ALL_EXP_MONTH(s4a,6) - TradeDate_converted(s4a);
            TVX6(s4a) = ALL_EXP_MONTH(s4a,7) - TradeDate_converted(s4a);
            TVX7(s4a) = ALL_EXP_MONTH(s4a,8) - TradeDate_converted(s4a);
            TVX8(s4a) = ALL_EXP_MONTH(s4a,9) - TradeDate_converted(s4a);
            TVX9(s4a) = ALL_EXP_MONTH(s4a,9) - TradeDate_converted(s4a);
                
        end
        
        %convert duration to days (then minus 1)
        T1(s4a) = days(TVX1(s4a))-1;
        T2(s4a) = days(TVX2(s4a))-1;
        T3(s4a) = days(TVX3(s4a))-1;
        T4(s4a) = days(TVX4(s4a))-1;
        T5(s4a) = days(TVX5(s4a))-1;        
        T6(s4a) = days(TVX6(s4a))-1;
        T7(s4a) = days(TVX7(s4a))-1;        
        T8(s4a) = days(TVX8(s4a))-1;
        T9(s4a) = days(TVX9(s4a))-1;  

        %change all time till expiry vectors to column vectors     
        T1 = T1(:);
        T2 = T2(:);
        T3 = T3(:);
        T4 = T4(:);
        T5 = T5(:);
        T6 = T6(:);
        T7 = T7(:);
        T8 = T8(:);
        T9 = T9(:); 

        
           TargetWeightVX1(s4a, 1) = ((T2(s4a,1)-30)./(T2(s4a,1)-T1(s4a,1)));
            
           if TargetWeightVX1(s4a,1) > 1.00
           TargetWeightVX1(s4a,1) = 1.00;
                           
           elseif TargetWeightVX1(s4a,1) < 0
           TargetWeightVX1(s4a,1) = 0.00;        
           
           end
           
           if T1(s4a,1) < 2
           TargetWeightVX1(s4a,1) = 0.00;
           end
                
           TargetWeightVX1(s4a, 1) = TargetWeightVX1(s4a, 1);
           
           TargetWeightVX2(s4a,1) = (1 - TargetWeightVX1(s4a,1));   
           
        
        
        
    end
%-------------------------------------------------------------------------
%=========================================================================




%TimeToExpiryDiff
TDiff = T2 - T1;
TDiffnumer = T2 - 30;
TDiffCo = TDiffnumer./TDiff;
%calculate synthetic 30 day...
S30VX = (TDiffCo.*VX1) + ((1 - TDiffCo).*VX2);
S45VX = 0; %CREATE THE SYNTHETIC 45 DAY SPREAD HERE (using vx3)

CONTANGO30 = ((S30VX./VIX)- 1);

ActiveContractsNum = datenum(ALL_EXP_MONTH);

for j = 1:length(ALL_EXP_MONTH)
    
   if SERIAL_DATE_DATA(j,1) < ActiveContractsNum(j,1)
      
       ActiveContracts(j,1) = ALL_EXP_MONTH(j,1);
       ActiveContracts(j,2) = ALL_EXP_MONTH(j,2);
       ActiveContracts(j,3) = ALL_EXP_MONTH(j,3);
       ActiveContracts(j,4) = ALL_EXP_MONTH(j,4);
       ActiveContracts(j,5) = ALL_EXP_MONTH(j,5);
       ActiveContracts(j,6) = ALL_EXP_MONTH(j,6);
       ActiveContracts(j,7) = ALL_EXP_MONTH(j,7);
       ActiveContracts(j,8) = ALL_EXP_MONTH(j,8);
       
   else 
   
       ActiveContracts(j,1) = ALL_EXP_MONTH(j,2);
       ActiveContracts(j,2) = ALL_EXP_MONTH(j,3);
       ActiveContracts(j,3) = ALL_EXP_MONTH(j,4);
       ActiveContracts(j,4) = ALL_EXP_MONTH(j,5);
       ActiveContracts(j,5) = ALL_EXP_MONTH(j,6);
       ActiveContracts(j,6) = ALL_EXP_MONTH(j,7);
       ActiveContracts(j,7) = ALL_EXP_MONTH(j,8);
       ActiveContracts(j,8) = ALL_EXP_MONTH(j,9);      
       
   end 
   

   
end








%=========================================================================
%-------------------------------------------------------------------------
%                 #7) VCO CALCULATION
%                       7.1) VCO Definition
%-------------------------------------------------------------------------
%   7.1) Calculate the VCO Parameter
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section removes calculates the VCO parameter
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
VCO = zeros(length(SERIAL_DATE_DATA),1);

    for i = 1:numel(SERIAL_DATE_DATA)

        if T1(i) <= 8
            VCO(i) = (VIX(i) - 45) + (1000*CONTANGO2(i));
        
        elseif T1(i) > 8
            VCO(i) = (VIX(i) - 45) + (1000*CONTANGO(i));    
            
        end
       

    end
%-------------------------------------------------------------------------
%=========================================================================










%=========================================================================
%-------------------------------------------------------------------------
%                 #8) CLEAR EXCESS WORKSPACE OBJECTS
%                       8.1) Remove Extra Workspace Variables
%-------------------------------------------------------------------------
%   8.1) Remove Extra Workspace Variables 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section removes all workspace objects not necessary for
% operation of subsequent "Signals" code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
clear('s4a','AVCI_intermediate','i','Date_string','Date_vector','TVX1','TVX2','TVX3','TVX4','TVX5','TVX6','TVX7','TVX8','TVX9','TradeDate_converted','VIX_MA50','month_input','vix_futures_sum','year_input');
%-------------------------------------------------------------------------
%=========================================================================




 
%=========================================================================
%------------------------------------------------------------------------
%                 #9) OUTPUT TO CSV FILE
%                       9.1) Save Parameters To CSV File
%-------------------------------------------------------------------------
%   9.1) Save Parameters To CSV File
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to save all the VIX algo
% parameters to a CSV File for analysis.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%Create a output CSV file for Kyle to analyze
  Tdate = datetime(SERIAL_DATE_DATA,'ConvertFrom','datenum');
  TdateStr = datestr(Tdate, 'yyyymmdd');
  TdateNum = str2num(TdateStr);
  AllLabels = {'TradeDate','VX1','VX2','VX3','VX4','VX5','VX6','VX7','VX8','VX9','T1','T2','T3','T4','T5','T6','T7','T8','T9','AVCI','CONTANGO','CONTANGO2','CONTANGO30','CONTANGO_ROLL','ROLL_YIELD','S30VX','V_DELTA','V_RATIO','VCO','VIX','VXMT','VXST','VXV','VXST_ROLL','VXV_ROLL'};
  SmithLabels = {'TradeDate','VIX','VX1','VX2','VX3','CONTANGO','CONTANGO2','CONTANGO30','CONTANGO_ROLL','ROLL_YIELD','S30VX','T1','T2','T3'};
  
  AllParameters = [TdateNum,VX1,VX2,VX3,VX4,VX5,VX6,VX7,VX8,VX9,T1,T2,T3,T4,T5,T6,T7,T8,T9,AVCI,CONTANGO,CONTANGO2,CONTANGO30,CONTANGO_ROLL,ROLL_YIELD,S30VX,V_DELTA,V_RATIO,VCO,VIX,VXMT,VXST,VXV,VXST_ROLL,VXV_ROLL];
  AllParameters = num2cell(AllParameters);
  AllParameters = cat(1,AllLabels, AllParameters);

  
  output_file_AllParameters = fopen('AllParameters.csv','w+');
  %
  fprintf(output_file_AllParameters,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', AllParameters{1,:});
  for y = 2:length(SERIAL_DATE_DATA)
  fprintf(output_file_AllParameters,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n', AllParameters{y,:});
  end
  fclose(output_file_AllParameters);

  
  SmithParameters = [TdateNum,VIX,VX1,VX2,VX3,CONTANGO,CONTANGO2,CONTANGO30,CONTANGO_ROLL,ROLL_YIELD,S30VX,T1,T2,T3];
  SmithParameters = num2cell(SmithParameters);
  SmithParameters = cat(1,SmithLabels, SmithParameters);

  
  output_file_SmithParameters = fopen('SmithParameters.csv','w+');
  %
  fprintf(output_file_SmithParameters,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', SmithParameters{1,:});
  for y = 2:length(SERIAL_DATE_DATA)
  fprintf(output_file_SmithParameters,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n', SmithParameters{y,:});
  end
  fclose(output_file_SmithParameters); 
  
%-------------------------------------------------------------------------
%=========================================================================








%=========================================================================
%------------------------------------------------------------------------
%                 #10) SAVE WORKSPACE TO FILE
%                       10.1) Save Remaining Workspace Objects To File
%-------------------------------------------------------------------------
%   10.1) Save Remaining Workspace Objects To File 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to save all workspace objects
% to a file.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear ('AllLabels','AllParameters','ans','j','output_file_AllParameters','output_file_SmithParameters','s4c','SmithLabels','SmithParameters','Tdate','TdateNum','TdateStr','TDiff','TDiffCo','TDiffnumer','y');


%save the workspace variables to a file
save('Volatility_Parameters');

%-------------------------------------------------------------------------
%=========================================================================


