

%Read data from database.
%---------------------------------------------------------------------
%    SQL QUERIES TO GET DATA FROM DB
%---------------------------------------------------------------------
curs = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.contracts '...
    'ORDER BY expiryDate']);

%Read data from database.
curs2 = exec(conn, ['SELECT *'...
    ' FROM 	gouldiidb.prices '...
    ' ORDER BY pDate ASC']); 

%Read data from database.
curs3 = exec(conn, ['SELECT *'...
    ' FROM 	gouldiidb.curve_tickers '...
    ' ORDER BY pDate ASC']); 

curs4 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.vx1 '...
    ' ORDER BY pDate ASC']); 

curs5 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.vx2 '...
    ' ORDER BY pDate ASC']); 

curs6 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.vx3 '...
    ' ORDER BY pDate ASC']); 

curs7 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.prices '...
    ' WHERE 	prices.ticker = ''vix''AND pDate > ''2006-08-20'''...
    ' ORDER BY pDate ASC']); 

curs8 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.prices '...
    ' WHERE 	prices.ticker = ''vix9d''AND pDate > ''2006-08-20'''...
    ' ORDER BY pDate DESC']); 

curs9 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.prices '...
    ' WHERE 	prices.ticker = ''vix3m''AND pDate > ''2006-08-20'''...
    ' ORDER BY pDate DESC']); 

curs10 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.prices '...
    ' WHERE 	prices.ticker = ''vix6m''AND pDate > ''2006-08-20'''...
    ' ORDER BY pDate DESC']);

curs11 = exec(conn, ['SELECT 	*'...
    ' FROM 	gouldiidb.prices '...
    ' WHERE 	prices.ticker = ''spxt'''...
    ' ORDER BY pDate DESC']);5

curs = fetch(curs);
close(curs);

curs2 = fetch(curs2);
close(curs2);

curs3 = fetch(curs3);
close(curs3);

curs4 = fetch(curs4);
close(curs4);

curs5 = fetch(curs5);
close(curs5);

curs6 = fetch(curs6);8
close(curs6);

curs7 = fetch(curs7);
close(curs7);

curs8 = fetch(curs8);
close(curs8);

curs9 = fetch(curs9);
close(curs9);

curs10 = fetch(curs10);
close(curs10);

curs11 = fetch(curs11);
close(curs11);

%---------------------------------------------------------------------





%---------------------------------------------------------------------
%    ASSIGN INPUT DATA TO OUTPUT VARIABLES
%---------------------------------------------------------------------
%Assign data to output variable
contracts = curs.Data;
prices = curs2.Data;
curve_tickers = curs3.Data;
vx1 = curs4.Data;
vx2 = curs5.Data;
vx3 = curs6.Data;
vix = curs7.Data;
vix9d = curs8.Data;
vix3m = curs9.Data;
vix6m = curs10.Data;
spxt = curs11.Data;

%Clear variables
clear curs curs2 curs3 curs4 curs5 curs6 curs7 curs8 curs9 curs10 curs11

%---------------------------------------------------------------------






%---------------------------------------------------------------------
%    PERFORM MATLAB DATA MANIPULATION
%---------------------------------------------------------------------
%set trade date vector
TradeDate = datetime(vx1(:,1));

SERIAL_DATE_DATA = datenum(TradeDate);
%convert to arrays
VX1_settle = cell2mat(vx1(:,9));
VX1_close = cell2mat(vx1(:,8));
VX1_open = cell2mat(vx1(:,5));
VX1_high = cell2mat(vx1(:,6));
VX1_low = cell2mat(vx1(:,7));
T1 = cell2mat(vx1(:,4));

VX2_settle = cell2mat(vx2(:,9));
VX2_close = cell2mat(vx2(:,8));
VX2_open = cell2mat(vx2(:,5));
VX2_high = cell2mat(vx2(:,6));
VX2_low = cell2mat(vx2(:,7));
T2 = cell2mat(vx2(:,4));

VX3_settle = cell2mat(vx3(:,9));
VX3_close = cell2mat(vx3(:,8));
VX3_open = cell2mat(vx3(:,5));
VX3_high = cell2mat(vx3(:,6));
VX3_low = cell2mat(vx3(:,7));
T3 = cell2mat(vx3(:,4));

VIX3M_close = cell2mat(vix3m(:,7));
VIX6M_close = cell2mat(vix6m(:,7));
VIX9D_close = cell2mat(vix9d(:,7));

CONTANGO_CLOSE = ((VX2_close./VX1_close) - 1);
CONTANGO_OPEN = ((VX2_open./VX1_open) - 1);
CONTANGO_HIGH = ((VX2_high./VX1_high) - 1);
CONTANGO_LOW = ((VX2_low./VX1_low) - 1);

CONTANGO_close(:,1) = (cellstr(datestr(TradeDate(:,1))));
CONTANGO_close(:,2) = num2cell(CONTANGO_CLOSE(:,1));

CONTANGO_open(:,1) = (cellstr(datestr(TradeDate(:,1))));
CONTANGO_open(:,2) = num2cell(CONTANGO_OPEN(:,1));

CONTANGO_high(:,1) = (cellstr(datestr(TradeDate(:,1))));
CONTANGO_high(:,2) = num2cell(CONTANGO_HIGH(:,1));

CONTANGO_low(:,1) = (cellstr(datestr(TradeDate(:,1))));
CONTANGO_low(:,2) = num2cell(CONTANGO_LOW(:,1));

VIX = cell2mat(vix(:,7));
VIX_len = length(VIX);

vix3mlendiff = (VIX_len - length(VIX3M_close));
vix3mtempvec = zeros(vix3mlendiff,1);
VIX3M_close = [VIX3M_close;vix3mtempvec];
VIX3M_close = flipud(VIX3M_close);
VIX_VIX3M = (VIX./VIX3M_close)-1;

vix6mlendiff = (VIX_len - length(VIX6M_close));
vix6mtempvec = zeros(vix6mlendiff,1);
VIX6M_close = [VIX6M_close;vix6mtempvec];
VIX6M_close = flipud(VIX6M_close);
VIX_VIX6M = (VIX./VIX6M_close)-1;

vix9dlendiff = (VIX_len - length(VIX9D_close));
vix9dtempvec = zeros(vix9dlendiff,1);
VIX9D_close = [VIX9D_close;vix9dtempvec];
VIX9D_close = flipud(VIX9D_close);
VIX9D_VIX = (VIX9D_close./VIX)-1;

VIX_ma50d = tsmovavg(VIX,'s',50,1);
VIX_ma50d(1:49) = NaN;

VIX_ma20d = tsmovavg(VIX,'s',20,1);
VIX_ma20d(1:19) = NaN;

VIX_ma200d = tsmovavg(VIX,'s',200,1);
VIX_ma200d(1:199) = NaN;

VIX9D_ma50d = tsmovavg(VIX9D_close,'s',50,1);
VIX9D_ma50d(1:vix9dlendiff+49) = NaN;

VIX9D_VIX_ma50d = tsmovavg(VIX9D_VIX,'s',50,1);
VIX9D_VIX_ma50d(1:vix9dlendiff+49) = NaN;

%set contango
CONTANGO = CONTANGO_CLOSE;

%TimeToExpiryDiff
TDiff = T2 - T1;
TDiffnumer30 = T2 - 30;
TDiffCo30 = TDiffnumer30./TDiff;
%calculate synthetic 30 day...
S30VX = (TDiffCo30.*VX1_close) + ((1 - TDiffCo30).*VX2_close);
 
TDiffnumer45 = T2 - 45;
TDiffCo45 = TDiffnumer45./TDiff;
%calculate synthetic 45 day...
S45VX = (TDiffCo45.*VX1_close) + ((1 - TDiffCo45).*VX2_close);

CONTANGO30_CLOSE = ((S30VX./VIX)- 1);

CONTANGO45_CLOSE = ((S45VX./VIX)- 1);

CONTANGO30 = CONTANGO30_CLOSE;

CONTANGO45 = CONTANGO45_CLOSE;

%calculate gouldiiVCO
gouldiiVCO = VIX + (100*CONTANGO30); 

%---------------------------------------------------------------------






%---------------------------------------------------------------------
%    CALCULATE TARGET WEIGHTS
%---------------------------------------------------------------------
    for i = 1:numel(SERIAL_DATE_DATA)
           TargetWeightVX1_S30(i, 1) = ((T2(i,1)-30)./(T2(i,1)-T1(i,1)));
            
           if TargetWeightVX1_S30(i,1) > 1.00
           TargetWeightVX1_S30(i,1) = 1.00;
                           
           elseif TargetWeightVX1_S30(i,1) < 0
           TargetWeightVX1_S30(i,1) = 0.00;        
           
           end
           
           if T1(i,1) < 2
           TargetWeightVX1_S30(i,1) = 0.00;
           end
           
           TargetWeightVX2_S30(i,1) = (1 - TargetWeightVX1_S30(i,1));  %this is why 45 day didnt work  
    end     
    
    
    for i = 1:numel(SERIAL_DATE_DATA)
        
           if T2(i,1) <= 45
           TargetWeightVX2_S45(i,1) = T2(i,1)./45;
           TargetWeightVX1_S45(i,1) = 0.0;
           
           else
           TargetWeightVX1_S45(i,1) = (T1(i,1)./45);        
           TargetWeightVX2_S45(i,1) = 0.0;
           end
        

    end       
%---------------------------------------------------------------------


    
    
    
    
%---------------------------------------------------------------------
%    EXTRA SHIT
%---------------------------------------------------------------------    
    ExpDates = contracts(2:end,2);

Date_string = datestr(TradeDate, 'mm/dd/yyyy');    
Date_vector = datevec(SERIAL_DATE_DATA);
%TradeDate_converted = datetime(Date_string,'Format','d-MMM-y');
TradeDate_NumFormat = yyyymmdd(TradeDate);

%weekday for every trade date
TradeDay = weekday(TradeDate);

ROLL_YIELD(:,1) = ((VX1_close./VIX)-1);

%---------------------------------------------------------------------






%---------------------------------------------------------------------
%    SAVE AND CLEAR
%---------------------------------------------------------------------
%clear('handles','hObject','eventdata');
save('db_historicaldata.mat','CONTANGO45','CONTANGO45_CLOSE','S45VX','TDiffCo45','TDiffnumer30','TDiffnumer45','TargetWeightVX1_S45','TargetWeightVX2_S45','ROLL_YIELD','CONTANGO','CONTANGO_low','T3','TradeDay','VX2_open','VX2_settle','CONTANGO30','CONTANGO45','CONTANGO_open','TDiff','VIX','VX3_close','CONTANGO30_CLOSE','Date_string','TDiffCo30','TDiffCo45','VX1_close','VX1_settle','VX3_settle','VX3_high','i','CONTANGO_CLOSE','Date_vector','VX1_high','VX3_low','prices','CONTANGO_HIGH','ExpDates','TargetWeightVX1_S30','TargetWeightVX2_S45','TargetWeightVX1_S45','VX1_low','VX3_open','vix','CONTANGO_LOW','S30VX','TargetWeightVX2_S30','VX1_open','vx1','CONTANGO_OPEN','SERIAL_DATE_DATA','VX2_close','contracts','vx2','CONTANGO_close','T1','TradeDate_NumFormat','VX2_high','curve_tickers','vx3','CONTANGO_high','T2','VX2_low','gouldiiVCO','VIX_VIX3M','VIX_VIX6M','VIX9D_VIX','VIX_ma50d','VIX9D_ma50d','VIX9D_VIX_ma50d','VIX_ma20d','VIX_ma200d','spxt')
clear('CONTANGO45','CONTANGO45_CLOSE','S45VX','TDiffCo45','TDiffnumer30','TDiffnumer45','TargetWeightVX1_S45','TargetWeightVX2_S45','ROLL_YIELD','CONTANGO','CONTANGO_low','T3','TradeDay','VX2_open','CONTANGO30','CONTANGO_open','TDiff','VIX','VX3_close','CONTANGO30_CLOSE','Date_string','TDiffCo30','VX1_close','VX3_high','i','CONTANGO_CLOSE','Date_vector','TDiffnumer','VX1_high','VX3_low','prices','CONTANGO_HIGH','ExpDates','TargetWeightVX1_S30','VX1_low','VX3_open','vix','CONTANGO_LOW','S30VX','TargetWeightVX2_S30','VX1_open','vx1','CONTANGO_OPEN','VX2_close','contracts','vx2','CONTANGO_close','T1','VX2_high','curve_tickers','vx3','CONTANGO_high','T2','TradeDate_converted','VX2_low','gouldiiVCO','VIX_VIX3M','VIX_VIX6M','VIX9D_VIX','VIX_ma50d','VIX9D_ma50d','VIX9D_VIX_ma50d','vix3m','VIX3M_close','vix3mlendiff','vix3mtempvec','vix6m','VIX6M_close','vix6mlendiff','vix6mtempvec','vix9d','VIX9D_close','vix9dlendiff','vix9dtempvec','VIX_len','VX1_settle','VX2_settle','VX3_settle','VIX_ma20d','VIX_ma200d','spxt');
save('db_tradedate.mat', 'TradeDate','SERIAL_DATE_DATA','TradeDate_NumFormat') 

%---------------------------------------------------------------------


