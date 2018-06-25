 function [sigW1,sigW2,ticker1,ticker2] = Gouldii_Strategy_BuyandHold_v1(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,TargetWeightVX1_S30,TargetWeightVX2_S30,curve_tickers)
     

    % start of strategy

   counter = 1;
   
     for i = Serial_startdate:Serial_enddate
         
        if i == Serial_startdate 
            sig(counter,1) = 0;
      
        elseif i > Serial_startdate  
             
            sig(counter,1) = -1;                

         end 
 ticker1(counter,1) = curve_tickers(counter,2);
 ticker2(counter,1) = curve_tickers(counter,4); 
 sigW1(counter,1) = TargetWeightVX1_S30(counter) * sig(counter);
 sigW2(counter,1) = TargetWeightVX2_S30(counter) * sig(counter);
 
 counter = counter+1;
     end

 
 

    end % end of strategy
    
   

 
 %Exists_ContangoEntry = exist('ContangoEntry');
%Exists_Contango30Entry = exist('Contango30Entry');
%Exists_ContangoExit = exist('ContangoExit');
%Exists_Contango30Exit = exist('Contango30Exit');
%Exists_LongContangoEntry = exist('LongContangoEntry');
%Exists_LongContango30Entry = exist('LongContango30Entry');

