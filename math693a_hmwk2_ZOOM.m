function alphastar = ...
        math693a_hmwk2_ZOOM(phi,phiD,a_low,a_high,xk,pk,c1,c2,evalphiInit,evalphiInit_der)
    
    while ( 1 )
        %call interpolate function
        aj = math693a_hmwk2_INTERPOLATE(min(a_low,a_high),max(a_low,a_high),phi,phiD,xk,pk);
        
        if a_high <= a_low
           a_temp = a_low;
           a_low = a_high;
           a_high = a_temp;
        end
        %evaluate the phi function at old point with old and new alphas
        evalphilow       = phi(a_low,xk,pk); %(bug:: Was a_left)
        evalphik         = phi(aj,xk,pk);

        % IF/ELSE STATEMENT   
        if evalphik > (evalphiInit +( c1*aj*evalphiInit_der) ) ||  ...
                (evalphik >= evalphilow)             
            a_high = aj;   
        else
            
            %compute phi derivative with new alpha
            evalphik_der = phiD(aj,xk,pk);     
            
            % FIRST NESTED IF STATEMENT    
            if abs(evalphik_der) <= -c2*evalphiInit_der
                alphastar = aj;
                return;
            end  
            % SECOND NESTED IF STATEMENT
            if ((a_high-a_low)*evalphik_der) >= 0
                a_high = a_low;
            end                 
            
            a_low = aj;                
        end    
    end
end
