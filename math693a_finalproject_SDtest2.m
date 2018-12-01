clear; clc; close all
format long

epsilon = 10^-3;
%startdate_string = '08/21/2008';
%enddate_string = '11/02/2018';
startdate_string = '10/05/2017';
enddate_string = '11/02/2018';

% call function
[func,ObjectiveVal]         = @(ParameterA, ParameterB, ParameterC, ParameterD) Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string);

gradientfunc = @(ParameterA,ParameterB,ParameterC,ParameterD) [   (  (Math693A_finalproject( ParameterA + epsilon, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)  - (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)))/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB + epsilon, ParameterC, ParameterD, startdate_string,enddate_string)  - (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)))/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB, ParameterC + epsilon, ParameterD, startdate_string,enddate_string)  - (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)))/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD + epsilon, startdate_string,enddate_string)  - (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)))/ epsilon)   ];



ParameterA = .07;
ParameterB = .09;
ParameterC = -.07;
ParameterD = -.08;

xk = [  ParameterA
        ParameterB
        ParameterC
        ParameterD  ];

XK    = xk;
                                                                            
vf   = @(x)              func(x(1,:),x(2,:),x(3,:),x(4,:));           %FUNCTION
%funcval = vf(xk);                                                                                                           % FUNCTION RUN #1
vg   = @(x)      gradientfunc(x(1),x(2),x(3),x(4));       %GRADIENT
pD   = @(x)              vg(x,funcval)/norm(vg(x,funcval));             %SEARCH DIRECTION(STEEPEST ASCENT)

%FunctionVal                     = funcval
GradientVal                     = vg(xk)    
%SteepestAscentSearchDirection   = pD(xk)

phi  = @(a,x,p)  vf(x+a*p);                                     %PHI
phiD = @(a,x,p,funcval)  vg(x+a*p,funcval)'*p;                  %PHI DERIVATIVE

%Initialize Parameters 
counter     = 0;                                %COUNTER
c1          = 10^-4;                            %CONSTANT PARAM C1
rho         = 0.5;
true        = 1;        
MaxIter     = 100000;                           %MAXIMUM ITERATIONS
A           = 1;                        %STEP LENGTH VECTOR;


    
% WHILE LOOP - used to determine if our position is a minimum
while norm(vg(xk,funcval)) > 0.00001                                                                                            % FUNCTION RUN #2,#3,#4, and #5

%does this go inside the while loop?
    alphanew         = 1;        %step length
    
    funcval = vf(xk);                                                                                                           % FUNCTION RUN #6
    gradientval = vg(xk,funcval);
    
    %Initial search direction and initial phi and phi derivative calculations
         %find descent direction: ---------------- steepest descent method---------------
    pk           = gradientval/norm(gradientval);                                                                                                      % FUNCTION RUN #7,#8,#9, and #10  
        
    cnt = 0;
    % NESTED WHILE LOOP - used reduce stepsize if Armijo Condition holds
    while phi(alphanew,xk,pk) <= funcval + ( c1*alphanew*pk'*gradientval)                                                   % FUNCTION RUN #11,#12,#13, and #14  
        cnt = cnt + 1
        %calculate new alpha size
        alphanew = rho*alphanew
        
    end
        
  %advance the counter
    counter = counter + 1    
    
    A = [A alphanew];
    
    %calculate new step size
    xnew = xk + (alphanew.*pk);
    
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
    
    output = ['Iteration # ',num2str(counter),' -- Step Length Size = ',num2str(alphanew)];
    disp(output)    
end
