clear all; clc;
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%   Written By: Daniel James Matteson
%   Name - Date:
%   VIX_algo_version_3_GetData - 5/22/2017


%   Synopsis:
%   First download all the VIX and VIX parameters historical data. Next, we
%   create a list of the future contract names from 2004 to 2070. We scrap
%   the CBOE website for all VIX future contract links and create a list of
%   them. Then we check the two lists against each other, if they match,
%   then we download that contract. Finally, we read all the contracts and
%   organize them in the term structure.

%%
%   Description:
%   The purpose of this code is to download all the historical VIX futures
%   contracts and organize them in the "Term Structure" to be used in the
%   VIX algo parameters code. The code also downloads all additional VIX
%   paramters that are needed to fully describe every volatility curve
%   across the historical data range. 


%   User Definied functions used in code:
%   "GetGoogleData"
%   Input parameters: Ticker, Start Date, End Date
%   Output parameter: Historical Data for Ticker


%   Required Input Parameters: 
%   No input parameters are required for this code. Only internet
%   connection.


%   Output Parameters: 
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
%                   V_PARAMETERS    DataType: Cell Array
%                   XIV_TableData   DataType: Table
%                   TradeDate       DataType: DateTime


%%
%   OUTLINE:
%           Pre-code Definitions
%       1)  VIX Historical Parameters Download
%               1.1) VIX
%               1.2) VXST
%               1.3) VXMT
%               1.4) VXV
%               1.5) XIV
%               1.6) Format VIX Paramters
%       2)  Calculated Contract Name List
%               2.1) Futures Contract Names
%       3)  Webpage Contract Name List
%               3.1) Futures Contract Names
%       4)  Download All Contracts
%               4.1) Match Contract Name Then Download
%       5)  Data Adjustments, Format, and Organization
%               5.1) CBOE Adjustment Row Identification
%               5.2) CBOE Data Adjustment #1
%               5.3) CBOE Data Adjustment #2 And #3
%               5.4) Complete Contract List Array With VIX Trading Dates
%       6)  Data Diagonal Format 
%               6.1) Convert Contract Array To Diagonal Format
%       7)  Data Term Structure Format   
%               7.1) Format Historical Data In Term Structure
%       8)  Format Output Array And Remove Workspace Objects
%               8.1) Format Output Array
%               8.2) Format Term Structure Parameters
%               8.3) Size All Output Variables
%               8.4) Save Term Structure To File
%               8.5) Remove All Workspace Objects Not Critical
%               8.6) Save Remaining Workspace Objects To File
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


%%
%=========================================================================
%-------------------------------------------------------------------------
%                       PRE-CODE DEFINITIONS
%turn off all the warnings
warning('off','all');
%set weboptions for download timeout length
options = weboptions('Timeout',60);
%-------------------------------------------------------------------------










%%
%=========================================================================
%-------------------------------------------------------------------------
%                 #1) VIX HISTORICAL PARAMETERS DOWNLOAD
%                       1.1) VIX
%                       1.2) VXST
%                       1.3) VXMT
%                       1.4) VXV
%                       1.5) XIV   - data from google using function !?!?!?!?!?!?!?!?!
%                       1.6) Format VIX Parameters
%-------------------------------------------------------------------------



%   1.1) VIX
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Download historical VIX data from CBOE website, and save as
% a CSV file. Determine the number of rows and columns in the downloaded 
% file. Create an array holding relevant data (only date and price right now)
% Determine total number of trade dates from VIX date data.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%save vix data from CBOE website as CSV file
VIX_HistoricalSave = websave('vixcurrent.csv', 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vixcurrent.csv');
%read in the CSV file as a table
VIX_Tablefile = readtable('vixcurrent.csv','Headerlines',1);
%find number of rows and columns in VIX data
[nr_VIX, nc_VIX] = size(VIX_Tablefile);
%Create vector with date and close price data
VIX_vector(:,1) = VIX_Tablefile(:,1);
VIX_vector(:,2) = VIX_Tablefile(:,5);
%Create Cell array
VIX_CellArray = table2cell(VIX_vector);
%number of rows in VIX data file
Total_Vix_Rows = nr_VIX;

%TradeDate created from VIX historical single column
% * * * * * * * * * * * * * * * * * * * --> TRADEDATE PARAMETER
TradeDate = datetime(VIX_CellArray(:,1), 'Format', 'mm/dd/yyyy');

%create cell array column with trade dates as strings
VIX_CellArray(:,1) = cellstr(TradeDate);
TradingDate = VIX_CellArray(:,1);

%weekday for every trade date
TradeDay = weekday(TradingDate);

%Create repetitive V_VIX
V_VIX = VIX_CellArray;

% * * * * * * * * * * * * * * * * * * * --> VIX PARAMETER
VIX = VIX_CellArray(:,2);
VIX = cell2mat(VIX);

%TradeDate for signals compare
TradeDateSignals = datetime(TradeDate,'Format', 'yyyymmdd');

%   1.2) VXST
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Download historical VXST data from CBOE website, and save as
% a CSV file. Create an array holding relevant data (only date and price 
% right now).
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%VXST historical download
VXST_HistoricalSave = websave('vxstcurrent.csv', 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vxstcurrent.csv');
VXST_Historical = readtable('vxstcurrent.csv','Headerlines',3);
%Create vector with date and close price data
VXST_vector(:,1) = VXST_Historical(1:end,1);
VXST_vector(:,2) = VXST_Historical(1:end,5);
%Create Cell array
VXST_cellarray = table2cell(VXST_vector);
VXST_date = datetime(VXST_cellarray(:,1), 'Format', 'mm/dd/yyyy');
VXST_cellarray(:,1) = cellstr(VXST_date);


%   1.3) VXMT
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Download historical VXMT data from CBOE website, and save as
% a CSV file. Create an array holding relevant data (only date and price 
% right now).
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%VXMT historical download
VXMT_HistoricalSave = websave('vxmtcurrent.csv', 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vxmtdailyprices.csv');
VXMT_Historical = readtable('vxmtcurrent.csv','Headerlines',2);
%Create vector with date and close price data
VXMT_vector(:,1) = VXMT_Historical(1:end,1);
VXMT_vector(:,2) = VXMT_Historical(1:end,5);
%Create Cell array
VXMT_cellarray = table2cell(VXMT_vector);
VXMT_date = datetime(VXMT_cellarray(:,1), 'Format', 'mm/dd/yyyy');
VXMT_cellarray(:,1) = cellstr(VXMT_date);


%   1.4) VXV
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Download historical VXV data from CBOE website, and save as
% a CSV file. Create an array holding relevant data (only date and price 
% right now).
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%VXV historical download
VXV_HistoricalSave = websave('vxvcurrent.csv', 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vix3mdailyprices.csv');
VXV_Historical = readtable('vxvcurrent.csv','Headerlines',2);
%Create vector with date and close price data
VXV_vector(:,1) = VXV_Historical(1:end,1);
VXV_vector(:,2) = VXV_Historical(1:end,5);
%Create Cell array
VXV_cellarray = table2cell(VXV_vector);
VXV_date = datetime(VXV_cellarray(:,1), 'Format', 'mm/dd/yyyy');
VXV_cellarray(:,1) = cellstr(VXV_date);

%   1.5) XIV
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Download historical XIV data using the GetGoogleData
% function. Format the data correctly for future use.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%try
%Calculate today
%Today = datetime('now', 'Format', 'MMM dd yyyy');

%Call the get google historical data function with start and end dates
%XIV_temp = GetGoogleData('XIV', 'JAN 17, 2012', Today);
   
%save XIV historical price data
%XIV_ClosePriceNEST = XIV_temp(5);

%save XIV historical tradedate data
%XIV_TradeDateNEST = XIV_temp(1);

%extract data from nested cell array
%XIV_TradeDate(:,1) = vertcat(XIV_TradeDateNEST{1});

%format trade date, convert to string, then convert to cell array
%XIV_TradeDate = datestr(XIV_TradeDate, 'mm/dd/yyyy');
%XIV_TradeDate = cellstr(XIV_TradeDate);

%extract data from nested cell array
%XIV_ClosePrice(:,1) = vertcat(XIV_ClosePriceNEST{1});
%XIV_ClosePrice = num2cell(XIV_ClosePrice);

%combine date and price data in one cell array
%XIV_cellarray(:,1) = XIV_TradeDate(:,1);
%XIV_cellarray(:,2) = XIV_ClosePrice(:,1);

% flip the array
%XIV_cellarray = flipud(XIV_cellarray);

%
%   1.6) Format VIX Paramters
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Format each VIX parameter cell array into the output format.
% This means the value of each parameter is located in the correct row 
% associate with the VIX trading date.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% format loops to organize parameter data in output format
%initialize VXST cell array
VXST = cell(length(TradeDate), 1);

%VXST format
for s1a = 1:length(VXST_cellarray)
    
   for s1b = 1:length(TradeDate)
       
        if isequal(VIX_CellArray(s1b,1), VXST_cellarray(s1a,1))
            VXST(s1b) = VXST_cellarray(s1a,2);
            %end inner loop early if condition is true
            break
        end
   end
    
end
%convert to column vector
VXST = VXST(:);
emptycells1 = cellfun('isempty', VXST);
VXST(emptycells1) = {0};
%Create Validation array
V_VXST(:,2) = VXST;
V_VXST(:,1) = VIX_CellArray(:,1);
% * * * * * * * * * * * * * * * * * * * --> VXST PARAMETER
VXST = cell2mat(VXST);


%initialize VXV cell array
VXV = cell(length(TradeDate), 1);
V_VXV = cell(length(TradeDate),2);
%VXV format
for s1a = 1:length(VXV_cellarray)
    
   for s1b = 1:length(TradeDate)
       
        if isequal(VIX_CellArray(s1b,1), VXV_cellarray(s1a,1))
            VXV(s1b) = VXV_cellarray(s1a,2);
            %end inner loop early if condition is true
            break
        end
   end
    
end
%convert to column vector
VXV = VXV(:);
emptycells2 = cellfun('isempty', VXV);
VXV(emptycells2) = {0};
%Create Validation array
V_VXV(:,2) = VXV;
V_VXV(:,1) = VIX_CellArray(:,1);
% * * * * * * * * * * * * * * * * * * * --> VXV PARAMETER
VXV = cell2mat(VXV);


%initialize VXMT cell array
VXMT = cell(length(TradeDate), 1);
V_VXMT = cell(length(TradeDate),2);
%VXMT format
for s1a = 1:length(VXMT_cellarray)
    
   for s1b = 1:length(TradeDate)
       
        if isequal(VIX_CellArray(s1b,1), VXMT_cellarray(s1a,1))
            VXMT(s1b) = VXMT_cellarray(s1a,2);
            %end inner loop early if condition is true
            break
        end
   end
    
end
%convert to column vector
VXMT = VXMT(:);
emptycells3 = cellfun('isempty', VXMT);
VXMT(emptycells3) = {0};
%Create Validation array
V_VXMT(:,2) = VXMT;
V_VXMT(:,1) = VIX_CellArray(:,1);
% * * * * * * * * * * * * * * * * * * * --> VXMT PARAMETER
VXMT = cell2mat(VXMT);

%initialize XIV cell array
%XIVfinal = cell(length(TradeDate), 1);
%V_XIV = cell(length(TradeDate), 2);
%XIV format
%for s1a = 1:length(XIV_cellarray)
    
%   for s1b = 1:length(TradeDate)
       
%        if isequal(VIX_CellArray(s1b,1), XIV_cellarray(s1a,1))
%            XIVfinal(s1b) = XIV_cellarray(s1a,2);
            %end inner loop early if condition is true
%            break
%        end
%   end
    
%end
%convert to column vector
%XIV_final = XIVfinal(:);

%emptycells4 = cellfun('isempty', XIV_final);
%XIV_final(emptycells4) = {0};
%Create Validation array
%V_XIV(:,2) = XIV_final;
%V_XIV(:,1) = VIX_CellArray(:,1);
% * * * * * * * * * * * * * * * * * * * --> XIV PARAMETER
%XIV = cell2mat(XIV_final);

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       1)  VIX Historical Parameters Download
%                          PARAMETER DESCRIPTION
%-------------------------------------------------------------------------
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%VIX_HistoricalSave                 Character Array
%Used to hold the websave data for VIX

%VIX_Tablefile                      Table
%Table containing ALL of the historical VIX data read from the downloaded
%csv file

%VIX_Vector                         Table
%Table containing only the columns of the historical VIX data that we are
%interested in - Date and Close Price

%VIX_CellArray                      Cell Array
%Cell Array containing the VIX historical trade date and close price data

%TradeDate                          Datetime
%Datetime array that contains every VIX historical trading dates

%VIX                                Double Vector
%Contains just the VIX Close price in a vector with rows coinciding with
%the TradeDate vector

%VXST_HistoricalSave                Character Array
%Used to hold the websave data for VXST

%VXST_Historical                    Table
%Table containing ALL of the historical VXST data read from the downloaded
%csv file

%VXST_Vector                        Table
%Table containing only the columns of the historical VXST data that we are
%interested in - Date and Close Price

%VXST_cellArray                     Cell Array
%Cell Array containing the VXST historical trade date and close price data

%VXMT_HistoricalSave                Character Array
%Used to hold the websave data for VXMT

%VXMT_Historical                    Table
%Table containing ALL of the historical VXMT data read from the downloaded
%csv file

%VXMT_Vector                        Table
%Table containing only the columns of the historical VXMT data that we are
%interested in - Date and Close Price

%VXMT_cellArray                     Cell Array
%Cell Array containing the VXMT historical trade date and close price data

%VXV_HistoricalSave                 Character Array
%Used to hold the websave data for VXV

%VXV_Historical                     Table
%Table containing ALL of the historical VXV data read from the downloaded
%csv file

%VXV_Vector                         Table
%Table containing only the columns of the historical VXV data that we are
%interested in - Date and Close Price

%VXV_cellArray                      Cell Array
%Cell Array containing the VXV historical trade date and close price data

%Today                              Datetime
%Datetime variable that contains todays date in a format that the
%"GetGoogleData" function can read

%XIV_temp                           Cell Array
%Cell array containing nested cell arrays for each column of the historical
%data Table

%XIV_ClosePriceNEST                 Cell Array
%Cell array containing a nested ClosePrice cell array for XIV

%XIV_TradeDateNEST                  Cell Array
%Cell array containing a nested TradeDate cell array for XIV

%XIV_TradeDate                      Cell Array
%Extracted TradeDate data from XIV_TradeDateNEST 

%XIV_ClosePrice                     Cell Array
%Extracted ClosePrice data from XIV_ClosePrice

%XIVfinal                           Cell Array
%Cell Array containing the XIV historical trade date and close price data
%with the price matching the correct VIX TradeDate - (row vector)

%XIV_final                          Cell Array
%Cell Array containing the XIV historical trade date and close price data
%in the correct format with rows matching the TradeDate - (column vector)

%XIV_cellArray                      Cell Array
%Cell Array containing the XIV historical trade date and close price data

%VXST                               Double Vector
%Vector containing all the VXST Close Price data with rows organized
%according to the TradeDate vector, with every empty cell containing a 0.

%VXMT                               Double Vector
%Vector containing all the VXMT Close Price data with rows organized
%according to the TradeDate vector, with every empty cell containing a 0.

%VXV                                Double Vector
%Vector containing all the VXV Close Price data with rows organized
%according to the TradeDate vector, with every empty cell containing a 0.

%XIV                                Double Vector
%Vector containing all the XIV Close Price data with rows organized
%according to the TradeDate vector, with every empty cell containing a 0.

%emptycells1/2/3/4                  Logical
%Vector that identifies whether a cell in a particular cell array is empty
%or not. Subsequent command will add a 0 to all empty cells (the purpose of
%this is to allow for matrix-matrix operations, these cant be performed if
%the arrays are of different size)

%nr_VIX                             Double
%Variable holding the number of rows in the VIX Table (this is used for
%dynamic memory allocation. we want to initialize future parameters with
%the appropriate amount of memory)

%nc_VIX                             Double
%Variable holding the number of columns in the VIX Table (this is used for
%dynamic memory allocation. we want to initialize future parameters with
%the appropriate amount of memory)

%Total_Vix_Rows                     Double
%This Variable is redundant and just holds the amount of VIX rows

%s1a                                Double
%COUNTER SEMAPHORE - used to index through each TradeDate for the purposes
%of organizing each parameter with the correct price on the correct date
%(matching rows between VIX TradeDate and parameter TradeDate)

%s1b                                Double
%COUNTER SEMAPHORE - used to index through each TradeDate for the purposes
%of organizing each parameter with the correct price on the correct date
%(matching rows between VIX TradeDate and parameter TradeDate)

%
%-------------------------------------------------------------------------
%=========================================================================










%%
%=========================================================================
%-------------------------------------------------------------------------
%                 #2) CALCULATED CONTRACT NAME LIST
%                       2.1) Futures Contract Names
%-------------------------------------------------------------------------
%   2.1) Futures Contract Names
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: Create list of all contract names between 2004 and 2070.
% The format of the contract names shall be equivalent to that which exists
% on the CBOE website. The purpose of the list is to match against a
% CBOE webpage scraped list in order to download each contract.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%initialize section row counter
s2_r = 1;
%initialize empty cell arrays
year_converted = [];
Contract_Names_String_Webpage = [];
CONTRACT_NAMES_CBOE_WEBPAGE_EXP = cell(804,1);


% OUTER FOR LOOP (loop through years)
for year_total = 2004 : 2070
    
    %convert year to correct format (two digits)
    year_converted = datetime(year_total, 1, 1); 
    year_converted = datestr(year_converted, 11 );

    % INNER FOR LOOP (loop through months)
    for month_total = 1 : 12
        
        % month conversion for contract name string
        %jan - F
        %feb - G
        %mar - H
        %apr - J
        %may - K
        %jun - M
        %jul - N
        %aug - Q
        %sep - U
        %oct - V
        %nov - X
        %dec - Z
        
        if month_total == 1
            month_converted = 'F';
            month_name = 'Jan';
            
        elseif month_total == 2
            month_converted = 'G';
            month_name = 'Feb';
            
        elseif month_total == 3
            month_converted = 'H';
            month_name = 'Mar';
            
        elseif month_total == 4
            month_converted = 'J';
            month_name = 'Apr';
            
        elseif month_total == 5
            month_converted = 'K';
            month_name = 'May';
            
        elseif month_total == 6
            month_converted = 'M';
            month_name = 'Jun';
            
        elseif month_total == 7
            month_converted = 'N';
            month_name = 'Jul';
            
        elseif month_total == 8
            month_converted = 'Q';
            month_name = 'Aug';
            
        elseif month_total == 9
            month_converted = 'U';
            month_name = 'Sep'; 
            
        elseif month_total == 10
            month_converted = 'V';
            month_name = 'Oct';
            
        elseif month_total == 11
            month_converted = 'X';
            month_name = 'Nov';
            
        elseif month_total == 12
            month_converted = 'Z';           
            month_name = 'Dec';
            
        end
    
    %create the contract name string    
    Contract_Names_String_Webpage = ['VX', month_converted, '(',month_name,year_converted, ')'];
    %save contract name string to cell array
    CONTRACT_NAMES_CBOE_WEBPAGE_EXP{s2_r} = Contract_Names_String_Webpage;
    
    %advance counter
    s2_r = s2_r + 1;
    end
        
end
%convert to column vector
CONTRACT_NAMES_CBOE_WEBPAGE_EXP = CONTRACT_NAMES_CBOE_WEBPAGE_EXP(:);

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       2)  Calculated Contract Name List
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%year_converted                     Character Array
%Used to hold the year in the particular format needed to create the series
%of strings required to match with the CBOE website for contract download

%Contract_Names_String_Webpage      Character Array
%The series of strings required to match with the CBOE website for each
%future contract download

%CONTRACT_NAMES_CBOE_WEBPAGE_EXP    Cell Array
%Cell array containing the series of strings required to match with the 
%CBOE website for each future contract download. this is considered the
%expected download list array

%month_converted                    Character Array
%Used to create the series of strings required to match with the CBOE
%website for each future contract download

%month_name                         Character Array
%Used to create the series of strings required to match with the CBOE
%website for each future contract download

%s2_r                               Double
%COUNTER SEMAPHORE - used to index through each TradeDate for the purposes
%of creating a cell array containing all download contract names

%year_total                         Double
%COUNTER SEMAPHORE - used to index through each year for the purpose of
%creating all future contract names

%month_total                        Double
%COUNTER SEMAPHORE - used to index through each month for the purpose of
%creating all future contract names

%-------------------------------------------------------------------------
%=========================================================================










%%
%=========================================================================
%-------------------------------------------------------------------------
%                 #3) WEBPAGE CONTRACT NAME LIST
%                       3.1) Futures Contract Names
%-------------------------------------------------------------------------
%   3.1) Futures Contract Names
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section scraps the CBOE webpage to check for all
% available futures contracts to be downloaded. It creates a cell array
% with every available contract name.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% save all text on cboe webpage
historicalCBOEwebaddress = 'http://cfe.cboe.com/market-data/historical-data';
options = weboptions('ContentType','text');
html = webread(historicalCBOEwebaddress,options);

%offline version
%webfile = 'C:\Program Files\MATLAB\MATLAB Production Server\R2015a\bin\testhtml.html';
%html = fileread(webfile);

% Use regular expressions to remove undesired html format
txt = regexprep(html,'<script.*?/script>','');
txt = regexprep(txt,'<style.*?/style>','');
txt = regexprep(txt,'<.*?>','');

CONTRACT_NAMES_CBOE_WEBPAGE_TEMP = strsplit(txt, 'VX - Cboe S&P 500 Volatility Index (VIX) Futures Price and Volume Detail:');

CONTRACT_NAMES_CBOE_WEBPAGE_TEMP = char(CONTRACT_NAMES_CBOE_WEBPAGE_TEMP(1,2));
CONTRACT_NAMES_CBOE_WEBPAGE_TEMP = strsplit(CONTRACT_NAMES_CBOE_WEBPAGE_TEMP, 'Back to Top');
CONTRACT_NAMES_CBOE_WEBPAGE_TEMP = char(CONTRACT_NAMES_CBOE_WEBPAGE_TEMP(1,1));
CONTRACT_NAMES_CBOE_WEBPAGE_TEMP = strsplit(CONTRACT_NAMES_CBOE_WEBPAGE_TEMP, '    ');

CONTRACT_NAMES_CBOE_WEBPAGE_TEMP = regexprep(CONTRACT_NAMES_CBOE_WEBPAGE_TEMP, '\s', ''); 
emptycellsweb = cellfun('isempty', CONTRACT_NAMES_CBOE_WEBPAGE_TEMP);
counterweb = 1;
for iweb = 1:length(CONTRACT_NAMES_CBOE_WEBPAGE_TEMP)
   if emptycellsweb(iweb) == 1
       
   elseif emptycellsweb(iweb) == 0    
    CONTRACT_NAMES_CBOE_WEBPAGE_ACT(counterweb,1) = CONTRACT_NAMES_CBOE_WEBPAGE_TEMP(1,iweb);
    counterweb = counterweb + 1;
   end 
   
end


%convert to column vector
CONTRACT_NAMES_CBOE_WEBPAGE_ACT = CONTRACT_NAMES_CBOE_WEBPAGE_ACT(:);

%remove trailing spaces
CONTRACT_NAMES_CBOE_WEBPAGE_ACT = deblank(CONTRACT_NAMES_CBOE_WEBPAGE_ACT);

%remove leading spaces
CONTRACT_NAMES_CBOE_WEBPAGE_ACT = strtrim(CONTRACT_NAMES_CBOE_WEBPAGE_ACT);

%remove all empty cells from cell array
emptycells7 = cellfun('isempty', CONTRACT_NAMES_CBOE_WEBPAGE_ACT);
CONTRACT_NAMES_CBOE_WEBPAGE_ACT(all(emptycells7,2),:) = [];

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       3)  Webpage Contract Name List
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%historicalCBOEwebaddress           Character Array
%This variable holds the web address needed to download all the CBOE VIX
%futures contracts. Each contract is downloaded from this website.

%html                               Character Array
%Used to hold all the information on the CBOE website in html format. This
%is necessary to determine which contracts are available for download
%everytime the code runs.

%txt                                Character Array
%This variable is used to perform all the regular expression standard
%matlab function output. We use this to remove the html format and identify
%which part of the html string we are interested in. (the contract names)

%online_int1                        Cell Array
%Cell Array used to hold the "split string". We split the txt output by 
%tab space in order to parse the required strings

%online_int2                        Character Array
%Used to identify which section/cell of the split string contains the
%required strings we want. (the contract names)

%CONTRACT_NAMES_CBOE_WEBPAGE_ACT    Cell Array
%Cell Array the holds all the contract names available for download on the
%CBOE website. The cell array includes ALL contracts available on the
%webpage meaning it is not limited to just the monthly contracts.

%emptycells7                        Logical
%Vector that identifies whether a cell in a particular cell array is empty
%or not. Subsequent command will add a 0 to all empty cells (the purpose of
%this is to allow for matrix-matrix operations, these cant be performed if
%the arrays are of different size)

%-------------------------------------------------------------------------
%=========================================================================










%%
%=========================================================================
%-------------------------------------------------------------------------
%                 #4) DOWNLOAD ALL CONTRACTS
%                       4.1) Match Contract Name Then Download
%-------------------------------------------------------------------------
%   4.1) Match Contract Name Then Download
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to match contract names
% between the calculated list and the webpage scraped list. If the
% contract names match, that means that contract exists for download from
% CBOE. Download all available contracts and save as CSV files.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%initialize cell arrays
Contract_Names_Online_Temp1 = cell(CONTRACT_NAMES_CBOE_WEBPAGE_EXP);
Contract_Names_Online_Temp1(:) = [];
CONTRACT_NAMES_ONLINE_DOWNLOADED = cell(CONTRACT_NAMES_CBOE_WEBPAGE_EXP);
CONTRACT_NAMES_ONLINE_DOWNLOADED(:) = [];
ALL_CONTRACTS_WEBSAVE = cell(CONTRACT_NAMES_CBOE_WEBPAGE_EXP);
ALL_CONTRACTS_WEBSAVE(:) = [];
%download all historical contracts from internet
for s4a = 1:numel(CONTRACT_NAMES_CBOE_WEBPAGE_EXP)
    %calculated contract name
    contract_name1 = CONTRACT_NAMES_CBOE_WEBPAGE_EXP{s4a};
    
        for s4b = 1:numel(CONTRACT_NAMES_CBOE_WEBPAGE_ACT)
            %webpage scraped  contract name
            contract_name2 = CONTRACT_NAMES_CBOE_WEBPAGE_ACT{s4b};
            
            if  isequal(contract_name1, contract_name2)

                %create list of downloaded file names for later reference
                Contract_Names_Online_Temp1{s4a} = contract_name1;                

                %format contract download string for csv file names using character indexing                
                Contract_Names_Online_Temp2 = char(Contract_Names_Online_Temp1{s4a});
                
                Contract_Names_Online_Temp2month = Contract_Names_Online_Temp2(3);
                Contract_Names_Online_Temp2year = strcat(Contract_Names_Online_Temp2(8),Contract_Names_Online_Temp2(9));                            
                
                Contract_Names_Online_Temp3 = cat(2,'CFE_',Contract_Names_Online_Temp2month,Contract_Names_Online_Temp2year,'_VX.csv');
                CONTRACT_NAMES_ONLINE_DOWNLOADED{s4a} = Contract_Names_Online_Temp3;
                webaddress = cat(2,'http://www.cboe.com/Publish/ScheduledTask/MktData/datahouse/', Contract_Names_Online_Temp3);
                
                %download file from CBOE!! *** THIS DOWLOADS EVERY CONTRACT
                ALL_CONTRACTS_WEBSAVE{s4a} = websave(Contract_Names_Online_Temp3,webaddress,options);            
                
               break
            end

            
        end
        
        
end

% Format list of downloaded names for future reference (NOT NEEDED?!??)
Contract_Names_Online_Temp1 = Contract_Names_Online_Temp1(:);
%remove all empty cells from cell array
emptycells5 = cellfun('isempty', Contract_Names_Online_Temp1);
Contract_Names_Online_Temp1(all(emptycells5,2),:) = [];

% Format list of downloaded names for immediate subsequent use
CONTRACT_NAMES_ONLINE_DOWNLOADED = CONTRACT_NAMES_ONLINE_DOWNLOADED(:);
%remove all empty cells from cell array
emptycells6 = cellfun('isempty', CONTRACT_NAMES_ONLINE_DOWNLOADED);
CONTRACT_NAMES_ONLINE_DOWNLOADED(all(emptycells6,2),:) = [];

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       4)  Download All Contracts
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%contract_name1                     Character Array
%This variable holds the contract name from the list of expected contracts

%contract_name2                     Character Array
%This variable holds the contract name from the list of contract names that
%were scraped from the CBOE webpage

%Contract_Names_Online_Temp1        Cell Array
%Cell Array that contains a list of ALL the matched contract names from the
%expected list and the webpage scraped list

%Contract_Names_Online_Temp2        Cell Array
%Cell Array used to hold the "split string". We split the variable
%Contract_Names_Online_Temp1 output in order to parse the correct portion
%of the Contract Name String. The objective is to create the Contract Name
%exactly as it appears in the download link.

%Contract_Names_Online_Temp3        Character Array
%This variable holds a contract name and is appended with ".csv". This is
%used to download the particular contact from the CBOE webpage

%webaddress                         Character Array
%This variable holds the complete download URL for each contract.

%ALL_CONTRACTS_WEBSAVE              Cell Array
%Cell Array used to hold every global path for the downloaded contracts

%emptycells5/6                      Logical
%Vector that identifies whether a cell in a particular cell array is empty
%or not. Subsequent command will add a 0 to all empty cells (the purpose of
%this is to allow for matrix-matrix operations, these cant be performed if
%the arrays are of different size)

%s4a                                Double
%COUNTER SEMAPHORE - used to index through each Contract Name for the 
%purposes of matching between expected and website generated contract name
%lists. If the match exists, then download the contract.

%s4b                                Double
%COUNTER SEMAPHORE - used to index through each Contract Name for the 
%purposes of matching between expected and website generated contract name
%lists. If the match exists, then download the contract.

%-------------------------------------------------------------------------
%=========================================================================










%%
%=========================================================================
%-------------------------------------------------------------------------
%             #5) DATA ADJUSTMENT, FORMAT, AND ORGANIZATION
%                       5.1) CBOE Adjustment Row Identification
%                       5.2) CBOE Data Adjustment #1
%                       5.3) CBOE Data Adjustment #2 And #3
%                       5.4) Complete Contract List Array With VIX Trading Dates
%-------------------------------------------------------------------------
%initialize cell arrays
FILE_SAVE = cell(CONTRACT_NAMES_ONLINE_DOWNLOADED);
FILE_SAVE(:) = [];
FutureContracts_RowsAsTradeDates = cell(CONTRACT_NAMES_ONLINE_DOWNLOADED);
FutureContracts_RowsAsTradeDates(:) = [];
FutureContracts_RowsNumbered = cell(CONTRACT_NAMES_ONLINE_DOWNLOADED);
FutureContracts_RowsNumbered(:) = [];

%   5.1) CBOE Adjustment Row Identification
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to identify the particular
% rows in which the CBOE data is changed from a previous format. We need to
% make adjustments to how we format each set of incoming contracts to
% ensure that all the data is uniformally formatted.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%list of all contract names that were downloaded
Contract_Name_Array(:,1) = CONTRACT_NAMES_ONLINE_DOWNLOADED;

%list of all the expiration dates for the downloaded contracts
ContractExpirationDates = ContractExpirationDate(CONTRACT_NAMES_ONLINE_DOWNLOADED);
Contract_Name_Array(:,2) = cellstr(ContractExpirationDates);

%DYNAMIC - calculate how many contracts exist for initialization of total
%final array to hold all the contracts in one cell array
Total_Contract_Columns = (length(Contract_Name_Array)*2);
 
for s5a = 1:length(Contract_Name_Array)

     if isequal(Contract_Name_Array{s5a}, 'CFE_M13_VX.csv')
         %CBOE header adjustment stop row to denote which contract
         stop_row = s5a;
     end       
     
end


%   5.2) CBOE Data Adjutment #1
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to adjust the incoming contract
% data due to the addition of a header row in June 2013.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%read csv files in a loop
for s5b = 1:length(Contract_Name_Array)
%array with file names to be read in
Future_Contracts = Contract_Name_Array{s5b};

%read all contracts ---***** we need two structures in order to capture the
%trade date as a row names in one, and not in the other. if you include the
%trade dates as row names, there is no way to keep them as a column when
%converting to cell array but is very useful for searching and organizing
%data when utilizing a structure -> similar to relational database

            if s5b <= stop_row
                % No header row exists before june 2013 
                % Database format (rows are trade dates)
                FutureContracts_RowsAsTradeDates{s5b} = readtable(Future_Contracts,'ReadRowNames',1);
                % Cell array format (rows are numbered)
                FutureContracts_RowsNumbered{s5b} = readtable(Future_Contracts);
            elseif s5b> stop_row
                % Account for the header row after june 2013
                % Database format (rows are trade dates)
                FutureContracts_RowsAsTradeDates{s5b} = readtable(Future_Contracts,'ReadRowNames',1,'Headerlines',1);
                % Cell array format (rows are numbered)
                FutureContracts_RowsNumbered{s5b} = readtable(Future_Contracts,'Headerlines',1);            
            end
            
                CONTRACT_NAME_ARRAY_update = strrep(Contract_Name_Array{s5b}, '.csv', '');
                FILE_SAVE{s5b} = CONTRACT_NAME_ARRAY_update;
                
                % Create Structure of all Contracts (rows numbered)
                ContractsAsStructure = cell2struct(FutureContracts_RowsNumbered, FILE_SAVE,2);
                % Create Structure of all Contracts (rows as dates)
                ContractsAsStructure_RowsAsDates = cell2struct(FutureContracts_RowsAsTradeDates, FILE_SAVE,2);
end


%%

save('Volatility_GetData_delete');


%   5.3) CBOE Data Adjustment #2 And #3
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to make adjustments to the
% final trading day of each contract. 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%create a cell array that contains all contract names 
ContractNamesfromStructure = fieldnames(ContractsAsStructure);

NumOfTotalContracts = numel(ContractNamesfromStructure);

%format the ContractAsStructure_RowsAsDates tables to fix the m/d/yyyy vs
%mm/dd/yyyy issue.
for i = 1:NumOfTotalContracts
ContractName = char(ContractNamesfromStructure(i,1));
DateRowNames = ContractsAsStructure_RowsAsDates.(ContractName).Properties.RowNames;
DateRowNames = datestr(DateRowNames, 'mm/dd/yyyy');
DateRowNames = cellstr(DateRowNames);
ContractsAsStructure_RowsAsDates.(ContractName).Properties.RowNames = DateRowNames;
end




%initialize the cell array that holds all the contracts array
AllContracts_vector = cell(NumOfTotalContracts,1);
%make a column vector
AllContracts_vector = AllContracts_vector(:);
 
%loop to save each contact to its own cell array - then save nested in a
%separate cell array
for s5c = 1:NumOfTotalContracts
    %create table for each contract from the structure object
    IndividualContract_table = ContractsAsStructure.(ContractNamesfromStructure{s5c});
    %IndividualContract_table_RowsAsDates = ContractsAsStructure_RowsAsDates.(ContractNamesfromStructure{s5c});    
    
    %create cell array for each contract
    IndividualContract_cellarray = table2cell(IndividualContract_table);
    %IndividualContract_cellarray_RowsAsDates = table2cell(IndividualContract_table);
     
    TD = datetime(IndividualContract_cellarray(:,1), 'Format', 'mm/dd/yyyy');
    %TD_RowsAsDates = datetime(IndividualContract_cellarray_RowsAsDates(:,1), 'Format', 'mm/dd/yyyy');
    
    
    %create cell array column with trade dates as strings
    IndividualContract_cellarray(:,1) = cellstr(TD);
    %IndividualContract_cellarray_RowsAsDates (:,1) = cellstr(TD_RowsAsDates);
     
    %calculate the number of rows and columns of each contract
    [nr_ContractUnderTest, nc_ContractUnderTest] = size(IndividualContract_cellarray);
    
    
    for s5d = 1:nr_ContractUnderTest
        
        if isequal(IndividualContract_cellarray{s5d,6}, 0)
            IndividualContract_cellarray(s5d,6) = IndividualContract_cellarray(s5d,7);
        end  
        
        if isnan(IndividualContract_cellarray{s5d,6})
            IndividualContract_cellarray(s5d,6) = IndividualContract_cellarray(s5d,7);
        end  
        
        if isequal(IndividualContract_cellarray{s5d,1}, Contract_Name_Array{s5c,2})
            IndividualContract_cellarray(s5d,:) = [];
        end
    end
    
    AllContracts_vector{s5c} = IndividualContract_cellarray;

end

%%

 %make sure we dynamically allocate memory for the amount of columns and
 %rows for the initialization of total_array_final
 COMPLETE_OUTPUT_ARRAY = cell(Total_Vix_Rows,Total_Contract_Columns + 1);  
 %set the trading date for the combined contract cell array
 COMPLETE_OUTPUT_ARRAY(:,1) = VIX_CellArray(:,1);
 
 %Total output array
 TOTAL_OUTPUT_ARRAY = cell(Total_Vix_Rows,Total_Contract_Columns + 1);  
 %set the trading date for the combined contract cell array
 TOTAL_OUTPUT_ARRAY(:,1) = VIX_CellArray(:,1);

 
%   5.4) Complete Contract List Array With VIX Trading Dates
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to organize all the contracts
% in one cell array with the VIX trading dates as column 1, and each
% contract with its own trading dates and prices in subsequent columns.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 %create a single cell array w/ all contracts closing prices and trade dates
 %initialize column counters
 s5_c1 = 2;
 s5_c2 = 3;

for s5e = 1:NumOfTotalContracts
%create vector from contract trade dates
ContractDateColumn = AllContracts_vector{s5e,1}(:,1);
%convert vector entries to strings
ContractDateColumn = cellstr(datestr(ContractDateColumn, 23));
%create vector from contract price
ContractPriceColumn = AllContracts_vector{s5e,1}(:,6);
%calculate the number of rows and columns of each contract
[nr_ContractDates,nc_ContractDates] = size(ContractDateColumn); 

    for s5f = 1:nr_ContractDates
        
        %copy each contract to the complete contract array
        COMPLETE_OUTPUT_ARRAY{s5f,s5_c1} = ContractDateColumn{s5f,1};
        COMPLETE_OUTPUT_ARRAY{s5f,s5_c2} = ContractPriceColumn{s5f,1};
        
    end

 %advance column counters  
 s5_c1 = s5_c1 + 2;
 s5_c2 = s5_c2 + 2;

end

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       5)  Data Adjustments, Format, and Organization
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%FILE_SAVE                          Cell Array
%This variable holds the contract name from the list of expected contracts

%FutureContracts_RowsAsTradeDates   Cell Array
%This variable holds the contract name from the list of expected contracts

%FutureContracts_RowsNumbered       Cell Array
%This variable holds the contract name from the list of expected contracts

%Contract_Name_Array                Cell Array
%This variable holds the contract name from the list of expected contracts

%Total_Contract_Columns             Double
%This variable holds the contract name from the list of expected contracts

%stop_row                           Double
%This variable holds the contract name from the list of expected contracts

%stop_row2                          Double
%This variable holds the contract name from the list of expected contracts

%stop_row3                          Double
%This variable holds the contract name from the list of expected contracts

%Future_Contracts                   Character Array
%This variable holds the contract name from the list of expected contracts

%CONTRACT_NAME_ARRAY_update         Character Array
%This variable holds the contract name from the list of expected contracts

%ContractsAsStructure               Structure
%This variable holds the contract name from the list of expected contracts

%ContractsAsStructure_RowsAsDates   Structure
%This variable holds the contract name from the list of expected contracts

%ContractNamesfromStructure         Cell Array
%This variable holds the contract name from the list of expected contracts

%LastContract                       Character Array
%This variable holds the contract name from the list of expected contracts

%NumOfTotalContracts                Double
%This variable holds the contract name from the list of expected contracts

%IndividualContract_table           Table
%This variable holds the contract name from the list of expected contracts

%IndividualContract_cellarray       Cell Array
%This variable holds the contract name from the list of expected contracts

%AllContracts_vector                Cell Array
%This variable holds the contract name from the list of expected contracts

%ContractDateColumn                 Cell Array
%This variable holds the contract name from the list of expected contracts

%ContractPriceColumn                Cell Array
%This variable holds the contract name from the list of expected contracts

%COMPLETE_OUTPUT_ARRAY              Cell Array
%This variable holds the contract name from the list of expected contracts

%s5a                                Double
%COUNTER SEMAPHORE - used to index through each of the downloaded contracts 
%which are described in the Contract_Name_Array variable.

%s5b                                Double
%COUNTER SEMAPHORE - used to index through each of the downloaded contracts 
%which are described in the Contract_Name_Array variable.

%s5c                                Double
%COUNTER SEMAPHORE - used to index through each of the total number of
%futures contracts downloaded which are described by the variable
%NumOfTotalContracts.

%s5d                                Double
%COUNTER SEMAPHORE - used to index through the rows of the ContractUnder

%s5e                                Double
%COUNTER SEMAPHORE - used to index through each Contract Name for the 
%purposes of matching between expected and website generated contract name
%lists. If the match exists, then download the contract.

%s5f                                Double
%COUNTER SEMAPHORE - used to index through each Contract Name for the 
%purposes of matching between expected and website generated contract name
%lists. If the match exists, then download the contract.

%nr_LastContract                    Double
%This variable holds the number of rows in the LastContract Variable which
%contains the last downloaded futures contract.

%nc_LastContract                    Double
%This variable holds the number of columns in the LastContract Variable 
%which contains the last downloaded futures contract.

%nr_ContractUnderTest               Double
%This variable holds the contract name from the list of expected contracts

%nc_ContractUnderTest               Double
%This variable holds the contract name from the list of expected contracts

%nr_ContractDates                   Double
%This variable holds the contract name from the list of expected contracts

%nc_ContractDates                   Double
%This variable holds the contract name from the list of expected contracts

%s5_c1                              Double
%This variable holds the contract name from the list of expected contracts

%s5_c2                              Double
%This variable holds the contract name from the list of expected contracts

%-------------------------------------------------------------------------
%=========================================================================








%save the workspace variables to a file
save('Volatility_PreDiag');

%%
%=========================================================================
%-------------------------------------------------------------------------
%                    #6) DATA DIAGONAL FORMAT
%                       6.1) Convert Contract Array To Diagonal Format
%-------------------------------------------------------------------------
%   6.1) Convert Contract Array To Diagonal Format
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to convert the complete
% contract array into the diagonal format. The diagonal format locates each
% contracts trade date and price in the correct corresponding VIX trade
% date row. The objective is to have one large array with every VIX trade
% date in column 1 then every contracts daily price in subsequent columns.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%convert total array to correct angled format
%initialize counter (date column counter)
s6_c1 = 1;

%initialize counter (price column counter)
s6_c2 = 2;


for s6a = 1:length(AllContracts_vector)
   
    %calculate how many rows are in each contract
    length_each_contract(s6a) = cellfun('length',AllContracts_vector(s6a));
    %set test rows equal to the length of each contract
    length_each_contract = length_each_contract(:);
    total_testrows = length_each_contract(s6a);
    LastRowMatched = 1;
    
    for s6b = 1:total_testrows      
        
        %each contracts test date and price
        %Contract test dates for matching
        TestDate_Contracts = COMPLETE_OUTPUT_ARRAY{s6b,s6_c2};
        TestPrice_Contracts = COMPLETE_OUTPUT_ARRAY{s6b,s6_c2 + 1};
 
                       
        for s6c = LastRowMatched:Total_Vix_Rows
           
            %VIX test dates for matching
            TestDate_VIX = COMPLETE_OUTPUT_ARRAY{s6c,1};
            
                if isequal(TestDate_Contracts, TestDate_VIX)
                    %copy contract data to correct spot
                    TOTAL_OUTPUT_ARRAY{s6c,s6_c1 + 1} = TestDate_Contracts;
                    TOTAL_OUTPUT_ARRAY{s6c,s6_c1 + 2} = TestPrice_Contracts;

                    %initialize counter
                    LastRowMatched = s6c + 1;
                    %s6c = 1;
                    break
                else
                    % dates were not equal
                end
           
                
                
        end
        
    end
            %advance column counter
            s6_c2 = s6_c2 + 2;
            s6_c1 = s6_c1 + 2;
           
end

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       6)  Data Diagonal Format
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%length_each_contract               Cell Array
%This variable holds the contract name from the list of expected contracts

%FILE_SAVE                          Cell Array
%This variable holds the contract name from the list of expected contracts

%-------------------------------------------------------------------------
%=========================================================================










%%
%=========================================================================
%-------------------------------------------------------------------------
%                    #7) DATA TERM STRUCTURE FORMAT
%                       7.1) Format Historical Data In Term Structure
%-------------------------------------------------------------------------
%   7.1) Format Historical Data In Term Structure
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to remove all whitespace in
% the diagonal formatted data. Our objective is to organize data in the 
% term structure. We hold each VIX trade date row constant then loop 
% over each column to check if data exists or not. If data exists, then
% copy to first available column in that row, if no data exists, ignore.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%remove all empty cells from cell array
emptycells7 = cellfun('isempty',TOTAL_OUTPUT_ARRAY);
%calculate size of output array
[nr_Complete, nc_Complete] = size(TOTAL_OUTPUT_ARRAY);
%initialize counter
s7_r = 1;
%initialize cell array
CBOE_TERM_STRUCTURE = cell(TOTAL_OUTPUT_ARRAY);
CBOE_TERM_STRUCTURE(:) = []; 

for s7a = 1:nr_Complete
        %initialize counter
        s7_c = 1;
   
        for s7b = 1:nc_Complete
        %copy the price to the "Data" variable
        Data = TOTAL_OUTPUT_ARRAY{s7a,s7b};

            if emptycells7(s7a,s7b) == 1
            %dont do anything because the cell is empty

            elseif emptycells7(s7a,s7b) == 0
            %copy price data to correct cell in term structure (cols 1-9)   
            CBOE_TERM_STRUCTURE{s7_r,s7_c} = Data;
            %advance the column counter
            s7_c = s7_c + 1; 
            end
        
        end
    %advance the row counter
    s7_r = s7_r + 1;
end

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       7)  Data Term Structure Format 
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%CBOE_TERM_STRUCTURE                Cell Array
%This variable holds the contract name from the list of expected contracts

%FILE_SAVE                          Cell Array
%This variable holds the contract name from the list of expected contracts

%-------------------------------------------------------------------------
%=========================================================================





% !*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
%                            PROBLEM:
%       We are going to delete the last two rows in the term structure in
%       order to avoid having to change the "delete last row" data
%       adjustment from delete last row of every contract to delete last
%       row of expired contracts. **  <--- this is the change needed to fix
%       We realize that the issue is that we delete the last row of
%       contracts that are still active, there by removing yesterdays data,
%       and the VIX trade date which controls the amount of total rows is
%       updated for today while the contracts are updated for yesterday.
%       This is why we lose two rows. Today is because we dont have data
%       and yesterday is because we delete it.

CBOE_TERM_STRUCTURE = CBOE_TERM_STRUCTURE(1:end-1,:); 

% !*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!










%%
%=========================================================================
%-------------------------------------------------------------------------
%           #8) FORMAT OUTPUT ARRAY AND REMOVE WORKSPACE OBJECTS
%                       8.1) Format Output Array
%                       8.2) Format Term Structure Parameters
%                       8.3) Save Term Structure To File
%                       8.4) Remove All Workspace Objects Not Critical
%                       8.5) Save Remaining Workspace Objects To File
%-------------------------------------------------------------------------
%   8.1) Format Output Array
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to format the entire term
% structure into one cell array with VIX trade dates but without contract
% trading dates.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Create the FINAL format for term structure (it does not include all the
% contract dates)
CBOE_TERM_STRUCTURE_FINAL = CBOE_TERM_STRUCTURE;
CBOE_TERM_STRUCTURE_FINAL(:,2) = CBOE_TERM_STRUCTURE_FINAL(:,3);
CBOE_TERM_STRUCTURE_FINAL(:,3) = CBOE_TERM_STRUCTURE_FINAL(:,5);
CBOE_TERM_STRUCTURE_FINAL(:,4) = CBOE_TERM_STRUCTURE_FINAL(:,7);
CBOE_TERM_STRUCTURE_FINAL(:,5) = CBOE_TERM_STRUCTURE_FINAL(:,9);
CBOE_TERM_STRUCTURE_FINAL(:,6) = CBOE_TERM_STRUCTURE_FINAL(:,11);
CBOE_TERM_STRUCTURE_FINAL(:,7) = CBOE_TERM_STRUCTURE_FINAL(:,13);
CBOE_TERM_STRUCTURE_FINAL(:,8) = CBOE_TERM_STRUCTURE_FINAL(:,15);
CBOE_TERM_STRUCTURE_FINAL(:,9) = CBOE_TERM_STRUCTURE_FINAL(:,17);
CBOE_TERM_STRUCTURE_FINAL(:,10) = CBOE_TERM_STRUCTURE_FINAL(:,19);
CBOE_TERM_STRUCTURE_FINAL(:,11:end) = [];

%Create the parameter validation cell array
%number 1... do i need to do this earlier? we want to ensure the dates are
%correct between the parameters
V_PARAMETERS(:,1) = V_VIX(:,1);
V_PARAMETERS(:,2) = V_VIX(:,2);
V_PARAMETERS(:,3) = V_VXST(:,1);
V_PARAMETERS(:,4) = V_VXST(:,2);
V_PARAMETERS(:,5) = V_VXMT(:,1);
V_PARAMETERS(:,6) = V_VXMT(:,2);
V_PARAMETERS(:,7) = V_VXV(:,1);
V_PARAMETERS(:,8) = V_VXV(:,2);
%V_PARAMETERS(:,9) = V_XIV(:,1);
%V_PARAMETERS(:,10) = V_XIV(:,2);



%   8.2) Format Term Structure Parameters
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to create individual
% variables to hold each continuous contracts historical data
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%create individual vectors for continuous contracts with closing price data
VX1(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,2);
emptycells8 = cellfun('isempty', VX1);
VX1(emptycells8) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX1 PARAMETER
VX1 = cell2mat(VX1);


VX2(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,3);
emptycells9 = cellfun('isempty', VX2);
VX2(emptycells9) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX2 PARAMETER
VX2 = cell2mat(VX2);



VX3(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,4);
emptycells10 = cellfun('isempty', VX3);
VX3(emptycells10) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX3 PARAMETER
VX3 = cell2mat(VX3);


VX4(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,5);
emptycells11 = cellfun('isempty', VX4);
VX4(emptycells11) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX4 PARAMETER
VX4 = cell2mat(VX4);


VX5(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,6);
emptycells12 = cellfun('isempty', VX5);
VX5(emptycells12) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX5 PARAMETER
VX5 = cell2mat(VX5);


VX6(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,7);
emptycells13 = cellfun('isempty', VX6);
VX6(emptycells13) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX6 PARAMETER
VX6 = cell2mat(VX6);


VX7(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,8);
emptycells14 = cellfun('isempty', VX7);
VX7(emptycells14) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX7 PARAMETER
VX7 = cell2mat(VX7);


VX8(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,9);
emptycells15 = cellfun('isempty', VX8);
VX8(emptycells15) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX8 PARAMETER
VX8 = cell2mat(VX8);


VX9(:,1) = CBOE_TERM_STRUCTURE_FINAL(:,10);
emptycells16 = cellfun('isempty', VX9);
VX9(emptycells16) = {0};
% * * * * * * * * * * * * * * * * * * * --> VX9 PARAMETER
VX9 = cell2mat(VX9);



%   8.3) Size All Output Variables
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to resize the remaining
% workspace objects/output variables to ensure that future matrix-matrix
% operations can be performed without error due to conflicting array sizes.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%delete last two rows off all parameters 
TradeDate = TradeDate(1:end-1,1);
VXST = VXST(1:end-1,1);
VXMT = VXMT(1:end-1,1);
VXV = VXV(1:end-1,1);
%XIV = XIV(1:end-1,1);
VIX = VIX(1:end-1,1);



%convert XIV cell array to table
%XIV_TableData = cell2table(XIV_cellarray);

%rename the XIV table columns to match the WFA requirements
%XIV_TableData.Properties.VariableNames = {'Date' 'Close'};


%Create the VIX parameter validation array
V_array(:,1) = V_VIX(:,1);
V_array(:,2) = V_VIX(:,2);
V_array(:,3) = V_VXST(:,1);
V_array(:,4) = V_VXST(:,2);
V_array(:,5) = V_VXMT(:,1);
V_array(:,6) = V_VXMT(:,2);
V_array(:,7) = V_VXV(:,1);
V_array(:,8) = V_VXV(:,2);
%V_array(:,9) = V_XIV(:,1);
%V_array(:,10) = V_XIV(:,2);

%%
%   8.4) Save Term Structure To File
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to save the term structure to
% a file.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%convert cell array to table for writing to text file
CBOE_TERM_STRUCTURE_TABLE = cell2table(CBOE_TERM_STRUCTURE);
CBOE_TERM_STRUCTURE_FINAL_TABLE = cell2table(CBOE_TERM_STRUCTURE);

%write term structure without dates to text file
%writetable(CBOE_TERM_STRUCTURE_TABLE);
%write term structure without dates to excel file
xlswrite('CBOE_TermStructure_All.xlsx', CBOE_TERM_STRUCTURE);

%write term structure with dates to text file
writetable(CBOE_TERM_STRUCTURE_FINAL_TABLE);
%write term structure with dates to excel file
xlswrite('CBOE_TermStructure.xlsx', CBOE_TERM_STRUCTURE_FINAL);

%write term structure with dates to excel file
xlswrite('Validation_VIX_Parameters.xlsx', V_array);

%   8.5) Remove All Workspace Objects Not Critical
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to remove all workspace
% objects that are not used in the "Parameters" code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% clear all workspace objects
clear('output_file_AllParameters','output_file_SmithParameters','ans','AllLabels','SmithLabels','Tdate','TdateNum','TdateStr','TDiff','TDiffCo','TDiffnumer','y','VXMT_date','VXST_date','VXV_date','XIV_date','V_array','V_VIX','V_VXV','V_VXST','V_VXMT','V_XIV','s1a','s1b','s2_r','s4a','s4b','s5_c1','s5_c2','s5a','s5b','s5c','s5d','s5e','s5f','s6_c1','s6_c2','s6a','s6b','s6c','s7_c','s7_r','s7a','s7b','Today','ALL_CONTRACTS_WEBSAVE','CBOE_TERM_STRUCTURE','CBOE_TERM_STRUCTURE_FINAL','CBOE_TERM_STRUCTURE_FINAL_TABLE','CBOE_TERM_STRUCTURE_TABLE','CONTRACT_NAMES_CBOE_WEBPAGE_ACT','CONTRACT_NAMES_CBOE_WEBPAGE_EXP','CONTRACT_NAME_ARRAY_update','ContractDateColumn','ContractNamesfromStructure','ContractPriceColumn','Contract_Names_Online_Temp1','Contract_Names_Online_Temp2','Contract_Names_Online_Temp3','Contract_Names_String_Webpage','Data','FILE_SAVE','FutureContracts_RowsAsTradeDates','FutureContracts_RowsNumbered','Future_Contracts','IndividualContract_cellarray','IndividualContract_table','NumOfTotalContracts','TestDate_Contracts','TestDate_VIX','TestPrice_Contracts','Total_Contract_Columns','VIX_CellArray','VIX_HistoricalSave','VIX_Tablefile','VIX_vector','VXMT_Historical','VXMT_HistoricalSave','VXMT_cellarray','VXMT_vector','VXST_Historical','VXST_HistoricalSave','VXST_cellarray','VXST_vector','VXV_Historical','VXV_HistoricalSave','VXV_cellarray','VXV_vector','XIV_cellarray', 'XIV_ClosePrice', 'XIV_ClosePriceNEST', 'XIV_final', 'XIVfinal', 'XIV_TradeDate', 'XIV_TradeDateNEST', 'LastContract', 'nc_LastContract','nr_LastContract','ans','contract_name1','contract_name2','emptycells1','emptycells2','emptycells3','emptycells4','emptycells5','emptycells6','emptycells7','emptycells8','emptycells9','emptycells10','emptycells11','emptycells12','emptycells13','emptycells14','emptycells15','emptycells16', 'historicalCBOEwebaddress','html','length_each_contract','month_converted','month_name','month_total','nc_Complete','nc_ContractDates','nc_ContractUnderTest','nc_VIX','nr_Complete','nr_ContractDates','nr_ContractUnderTest','nr_VIX','online_int1','online_int2','options','stop_row','stop_row2','stop_row3','total_testrows','txt','webaddress','year_converted','year_total');


%   8.6) Save Remaining Workspace Objects To File
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to save all workspace objects
% to a file.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%save the workspace variables to a file
%save('Volatility_GetData');

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% 
%       8)  Format Output Array And Remove Workspace Objects
%-------------------------------------------------------------------------
%                          PARAMETER DESCRIPTION
%Name:                              DataType:
%Description:
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%CBOE_TERM_STRUCTURE_FINAL          Cell Array
%This variable holds the contract name from the list of expected contracts

%FILE_SAVE                          Cell Array
%This variable holds the contract name from the list of expected contracts

%-------------------------------------------------------------------------
%=========================================================================

%clear workspace objects

clear ('AllContracts_vector','CONTRACT_NAMES_CBOE_WEBPAGE_TEMP','CONTRACT_NAMES_ONLINE_DOWNLOADED','ContractName','Contract_Names_Online_Temp2month','Contract_Names_Online_Temp2year','DateRowNames','LastRowMatched','TD','Total_Vix_Rows','TradeDateSignals','TradingDate','V_PARAMETERS','counterweb','emptycellsweb','i','iweb');
save('Volatility_GetData');
%run the parameters
%run('VIX_algo_version_5_Parameters.m');