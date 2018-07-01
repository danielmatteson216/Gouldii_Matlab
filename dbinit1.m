
%Read data from database.
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
    ' WHERE 	prices.ticker = ''vix'''...
    ' ORDER BY pDate ASC']); 

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

curs6 = fetch(curs6);
close(curs6);

curs7 = fetch(curs7);
close(curs7);

%Assign data to output variable
contracts = curs.Data;
prices = curs2.Data;
curve_tickers = curs3.Data;
vx1 = curs4.Data;
vx2 = curs5.Data;
vx3 = curs6.Data;
vix = curs7.Data;

%Clear variables
clear curs curs2 curs3 curs4 curs5 curs6 curs7

%set trade date vector
TradeDate = datetime(vx1(:,1));

SERIAL_DATE_DATA = datenum(TradeDate);
%convert to arrays
VX1_close = cell2mat(vx1(:,8));
VX1_open = cell2mat(vx1(:,5));
VX1_high = cell2mat(vx1(:,6));
VX1_low = cell2mat(vx1(:,7));
T1 = cell2mat(vx1(:,4));

VX2_close = cell2mat(vx2(:,8));
VX2_open = cell2mat(vx2(:,5));
VX2_high = cell2mat(vx2(:,6));
VX2_low = cell2mat(vx2(:,7));
T2 = cell2mat(vx2(:,4));

VX3_close = cell2mat(vx3(:,8));
VX3_open = cell2mat(vx3(:,5));
VX3_high = cell2mat(vx3(:,6));
VX3_low = cell2mat(vx3(:,7));
T3 = cell2mat(vx3(:,4));

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


%set contango
CONTANGO = CONTANGO_CLOSE;

%TimeToExpiryDiff
TDiff = T2 - T1;
TDiffnumer = T2 - 30;
TDiffCo = TDiffnumer./TDiff;
%calculate synthetic 30 day...
S30VX = (TDiffCo.*VX1_close) + ((1 - TDiffCo).*VX2_close);

CONTANGO30_CLOSE = ((S30VX./VIX)- 1);

CONTANGO30 = CONTANGO30_CLOSE;

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
           
           TargetWeightVX2_S30(i,1) = (1 - TargetWeightVX1_S30(i,1));   
    end           
    
    ExpDates = contracts(2:end,2);

Date_string = datestr(TradeDate, 'mm/dd/yyyy');    
Date_vector = datevec(SERIAL_DATE_DATA);
TradeDate_converted = datetime(Date_string,'Format','d-MMM-y');
TradeDate_NumFormat = yyyymmdd(TradeDate_converted);

%weekday for every trade date
TradeDay = weekday(TradeDate);

ROLL_YIELD(:,1) = ((VX1_close./VIX)-1);
%clear('handles','hObject','eventdata');
save('db_historicaldata.mat','ROLL_YIELD','CONTANGO','CONTANGO_low','T3','TradeDay','VX2_open','CONTANGO30','CONTANGO_open','TDiff','VIX','VX3_close','CONTANGO30_CLOSE','Date_string','TDiffCo','VX1_close','VX3_high','i','CONTANGO_CLOSE','Date_vector','TDiffnumer','VX1_high','VX3_low','prices','CONTANGO_HIGH','ExpDates','TargetWeightVX1_S30','VX1_low','VX3_open','vix','CONTANGO_LOW','S30VX','TargetWeightVX2_S30','VX1_open','vx1','CONTANGO_OPEN','SERIAL_DATE_DATA','VX2_close','contracts','vx2','CONTANGO_close','T1','TradeDate_NumFormat','VX2_high','curve_tickers','vx3','CONTANGO_high','T2','TradeDate_converted','VX2_low') 
clear('ROLL_YIELD','CONTANGO','CONTANGO_low','T3','TradeDay','VX2_open','CONTANGO30','CONTANGO_open','TDiff','VIX','VX3_close','CONTANGO30_CLOSE','Date_string','TDiffCo','VX1_close','VX3_high','i','CONTANGO_CLOSE','Date_vector','TDiffnumer','VX1_high','VX3_low','prices','CONTANGO_HIGH','ExpDates','TargetWeightVX1_S30','VX1_low','VX3_open','vix','CONTANGO_LOW','S30VX','TargetWeightVX2_S30','VX1_open','vx1','CONTANGO_OPEN','SERIAL_DATE_DATA','VX2_close','contracts','vx2','CONTANGO_close','T1','TradeDate_NumFormat','VX2_high','curve_tickers','vx3','CONTANGO_high','T2','TradeDate_converted','VX2_low');
save('db_tradedate.mat', 'TradeDate') 

