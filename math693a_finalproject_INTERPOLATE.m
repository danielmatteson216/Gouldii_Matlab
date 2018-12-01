function aj = math693a_finalproject_INTERPOLATE(a_low,a_high,phi,phiD,xk,pk,funcval)
    
    e1 = .05;
    e2 = .05;

    %evaluate the function at with old point and with new point with computed alpha
    evalphilow      = phi(a_low,xk,pk);
    evalphihigh     = phi(a_high,xk,pk);
    evalphilow_der  = phiD(a_low,xk,pk,funcval);
    evalphihigh_der = phiD(a_high,xk,pk,funcval);     

    %Cubic-Hermite based Interpolation
    d1 = (evalphilow_der + evalphihigh_der) - ...
         (3 * ((evalphilow - evalphihigh) / (a_low - a_high)) );
    d2 = sign(a_high - a_low).*sqrt((d1.^2) - ...
                                    (evalphilow_der .* evalphihigh_der));

    %interpolated alpha new
    aj = a_high - ( (a_high - a_low) * ...
                          ( (evalphihigh_der + d2 - d1)/...
                            (evalphihigh_der - evalphilow_der+ 2*d2) ) );    
    

    % safeguards below
    if abs(aj - a_high) < e1 || abs(aj) < e2
        aj = (a_high/2);
    end    
end
