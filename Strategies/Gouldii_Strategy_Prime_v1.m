function [sigprevious,sigw1,sigw2,ticker1,ticker2] = Gouldii_Strategy_Prime_v1(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,TargetWeightVX1_S30,TargetWeightVX2_S30,curve_tickers)
     %do we need y_CONTANGO and y_CONTANGO30? i dont think we do.... just
     %the signal.

    % start of strategy

   counter = 1;
   
     for i = Serial_startdate:Serial_enddate
            
            if counter > 1    
            y_sig = sig(counter-1,1);
            end
            
            if (CONTANGO(i) > ContangoEntry && CONTANGO30(i) > Contango30Entry && y_sig == 0) 
                sig(counter,1) = -1;
                
            elseif (CONTANGO(i) > ContangoExit && CONTANGO30(i) > Contango30Exit && y_sig < 0) % 
                sig(counter,1) = -1;
                %counter = counter+1;
            elseif (CONTANGO(i) < LongContangoEntry && CONTANGO30(i) < LongContango30Entry) 
                sig(counter,1) = 1;
                %counter = counter+1;
            else 
                sig(counter,1) = 0;                
                %counter = counter+1;
            end 



 
 
             ticker1(counter,1) = curve_tickers(i,2);
             ticker2(counter,1) = curve_tickers(i,4); 
             sigw1(counter,1) = TargetWeightVX1_S30(i) * sig(counter);
             sigw2(counter,1) = TargetWeightVX2_S30(i) * sig(counter);


             counter = counter+1;
      end % end of strategy
    
sigprevious = sig(end);   




%this shit is test below 
%Exists_ContangoEntry = exist('ContangoEntry');
%Exists_Contango30Entry = exist('Contango30Entry');
%Exists_ContangoExit = exist('ContangoExit');
%Exists_Contango30Exit = exist('Contango30Exit');
%Exists_LongContangoEntry = exist('LongContangoEntry');
%Exists_LongContango30Entry = exist('LongContango30Entry');


end