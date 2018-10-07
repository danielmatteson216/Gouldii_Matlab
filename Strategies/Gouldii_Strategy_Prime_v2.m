function [sigprevious,sigw1,sigw2,ticker1,ticker2] = Gouldii_Strategy_Prime_v2(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,...
                                                                                ParameterA,ParameterB,ParameterC,ParameterD,ParameterE,ParameterF,...
                                                                                TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO,...
                                                                                VIX_VIX3M,VIX_VIX6M,VIX9D_VIX,VIX_ma50d,VIX9D_ma50d,VIX9D_VIX_ma50d,VIX_ma20d,VIX_ma200d,VIX)
     %do we need y_CONTANGO and y_CONTANGO30? i dont think we do.... just
     %the signal.

    % start of strategy
%VIX_ma1 = tsmovavg(VIX,'s',ParameterA,1);
%VIX_ma2 = tsmovavg(VIX,'s',ParameterB,1);

  
counter = 1;
   
     for i = Serial_startdate:Serial_enddate
            
            if counter > 1    
            y_sig = sig(counter-1,1);
            end
            
            
             if (CONTANGO30(i) > ParameterA && y_sig == 0) 

                sig(counter,1) = -1;

            elseif (CONTANGO30(i) > ParameterB && y_sig < 0)

                sig(counter,1) = -1;

            elseif (CONTANGO30(i) < ParameterC && y_sig == 0)

                sig(counter,1) = 0.5;            

            elseif (CONTANGO30(i) < ParameterD && y_sig > 0)

                sig(counter,1) = 0.5;
                
             else

                sig(counter,1) = 0;                

             end 
            
         
             
                
            %if ( CONTANGO30(i) > ParameterA ) % 
            %    sig(counter,1) = -1;
                %counter = counter+1;
           % elseif (CONTANGO30(i) < ParameterB) 
            %    sig(counter,1) = 0.5;
                %counter = counter+1;
            %else 
            %    sig(counter,1) = 0;                
                %counter = counter+1;
            %end 



 
 
             ticker1(counter,1) = curve_tickers(i,2);
             ticker2(counter,1) = curve_tickers(i,4); 
            % sigw1(counter,1) = TargetWeightVX1_S45(i) * sig(counter);
            % sigw2(counter,1) = TargetWeightVX2_S45(i) * sig(counter);
             sigw1(counter,1) = TargetWeightVX1_S30(i) * sig(counter);
             sigw2(counter,1) = TargetWeightVX2_S30(i) * sig(counter);

             counter = counter+1;
      end % end of strategy
    
sigprevious = sig(end);   




%this shit is test below 
%Exists_ParameterA = exist('ParameterA');
%Exists_ParameterB = exist('ParameterB');
%Exists_ParameterC = exist('ParameterC');
%Exists_ParameterD = exist('ParameterD');
%Exists_ParameterE = exist('ParameterE');
%Exists_ParameterF = exist('ParameterF');


end