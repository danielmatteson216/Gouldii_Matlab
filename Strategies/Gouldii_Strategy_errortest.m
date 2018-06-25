%
%              This is the strategy design template
%
%
%        %Output variables              %Insert strategy name below          %Input Variables   
function [sigW1,sigW2,ticker1,ticker2] = Gouldii_Strategy_Template(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,TargetWeightVX1_S30,TargetWeightVX2_S30,curve_tickers)
    

counter = 1;

    % start of strategy   
     for i = Serial_startdate:Serial_enddate
         
        if i == Serial_startdate 
            sig(counter,1) = 0;
      
        elseif i > Serial_startdate  
             
% ========================================================================
% Put strategy Below.
%           % The following is a strategy example

            if (CONTANGO(i) > ContangoEntry && CONTANGO30(i) > Contango30Entry && sig(counter-1,1) == 0) 
                sig(counter,1) = -1;
               
            else 
                sigw1(counter,1) = 0;                
                
            end 
            
% ========================================================================
            
        end

         %ticker1(counter,1) = curve_tickers(counter,2);
         %ticker2(counter,1) = curve_tickers(counter,4); 
         %sigW1(counter,1) = TargetWeightVX1_S30(counter) * sig(counter);
         %sigW2(counter,1) = TargetWeightVX2_S30(counter) * sig(counter);
 
        counter = counter+1;

     end % end of strategy
       
 
 
end

