 function [sigprevious, sigw1,sigw2,ticker1,ticker2] = Gouldii_Strategy_BuyandHold_v1(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO,VIX_VIX3M,VIX_VIX6M,VIX9D_VIX)


    % start of strategy

   counter = 1;
   
     for i = Serial_startdate:Serial_enddate
             
            sig(counter,1) = -1;                

          
             ticker1(counter,1) = curve_tickers(i,2);
             ticker2(counter,1) = curve_tickers(i,4); 
             sigw1(counter,1) = TargetWeightVX1_S30(i) * sig(counter);
             sigw2(counter,1) = TargetWeightVX2_S30(i) * sig(counter);

             counter = counter+1;
     end% end of strategy

 
 sigprevious = sig(end);

end 
    
   

 
 %Exists_ContangoEntry = exist('ContangoEntry');
%Exists_Contango30Entry = exist('Contango30Entry');
%Exists_ContangoExit = exist('ContangoExit');
%Exists_Contango30Exit = exist('Contango30Exit');
%Exists_LongContangoEntry = exist('LongContangoEntry');
%Exists_LongContango30Entry = exist('LongContango30Entry');

