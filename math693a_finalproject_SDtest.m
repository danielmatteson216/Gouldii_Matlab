clear; clc; close all
format long

epsilon = 10^-2;
%startdate_string = '08/21/2008';
%enddate_string = '11/02/2018';
startdate_string = '10/04/2017';
enddate_string = '11/02/2018';

% call function
func         = @(ParameterA, ParameterB, ParameterC, ParameterD) Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string);

gradientfunc = @(ParameterA,ParameterB,ParameterC,ParameterD,funcval) [   (  (Math693A_finalproject( ParameterA + epsilon, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)  - funcval)/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB + epsilon, ParameterC, ParameterD, startdate_string,enddate_string)  - funcval)/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB, ParameterC + epsilon, ParameterD, startdate_string,enddate_string)  - funcval)/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD + epsilon, startdate_string,enddate_string)  - funcval)/ epsilon)   ];



ParameterA = .075;
ParameterB = .075;
ParameterC = -.075;
ParameterD = -.075;

xk = [  ParameterA
        ParameterB
        ParameterC
        ParameterD  ];

XK    = xk;
                                                                            
vf   = @(x)              func(x(1,:),x(2,:),x(3,:),x(4,:));           %FUNCTION
funcval = vf(xk)
vg   = @(x,funcval)      gradientfunc(x(1),x(2),x(3),x(4),funcval);       %GRADIENT
pD   = @(x)              vg(x,funcval)/norm(vg(x,funcval));             %SEARCH DIRECTION(STEEPEST ASCENT)

%FunctionVal                     = funcval
grad                    = vg(xk,funcval)    
%SteepestAscentSearchDirection   = pD(xk)

%Initialize Parameters 
counter     = 0;                                %COUNTER
c1          = 10^-4;                            %CONSTANT PARAM C1
c2          = .9;                               %CONSTANT PARAM C2
alphaZERO   = 0;                                %INITIAL STEP LENGTH
alphaold    = 0;                                %PREVIOUS STEP LENGTH
alphamax    = 5;                                %MAX STEP LENGTH
true        = 1;        
MaxIter     = 100000;                           %MAXIMUM ITERATIONS
rho         = 0.5;


phi  = @(a,x,p)  vf(x+a*p);                                     %PHI
phiD = @(a,x,p,funcval)  vg(x+a*p,funcval)'*p;                  %PHI DERIVATIVE
A           = 1;                        %STEP LENGTH VECTOR;


% WHILE LOOP - used to determine if our position is a minimum
while norm(grad) > 0.00001
 
    alphanew         = 1;        %step length
    i                = 1;        %number of iterations counter  
        
    gradientval = grad;
    
    %Initial search direction and initial phi and phi derivative calculations
         %find descent direction: ---------------- steepest descent method---------------
    pk           = gradientval/norm(gradientval);                                                                                                      % FUNCTION RUN #7,#8,#9, and #10  

        
    % NESTED WHILE LOOP - used reduce stepsize if Armijo Condition holds
    while phi(alphanew,xk,pk) <= funcval + ( c1*alphanew*pk'*gradientval )
        
        %calculate new alpha size
        alphanew = rho*alphanew
        
    end
    %advance the counter
    counter = counter + 1    ;
    
    A = [A alphanew];
    
    %calculate new step size
    xnew = xk + (alphanew.*pk)
    
    %save resulting function values and position
    Results(counter,1) = func(xk(1),xk(2),xk(3),xk(4));
    Results(counter,2) = xk(1);
    Results(counter,3) = xk(2);
    Results(counter,4) = xk(3);
    Results(counter,5) = xk(4);    
    Results(counter,6)  = A(counter); 
    
    %set new to old for subsequent iteration
    xk = xnew;
    XK = [XK xk];  
    
    funcval = vf(xk)
    grad = vg(xk,funcval)
    output = ['Iteration # ',num2str(counter),' -- Step Length Size = ',num2str(alphanew)];
    disp(output)    
    
    
    
end