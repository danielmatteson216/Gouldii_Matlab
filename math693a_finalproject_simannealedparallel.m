clear; clc; close all
format long
%parpool('local',[4,16])


%set date range
startdate_string = '08/21/2006';
enddate_string = '11/02/2018';

parfor cnt = 1:4

%User defined variables
n = 40; %set total loop count
T = 1.0; %max temp (starting value)
alpha = 0.90; %cooling coefficient 
Tmin = 0.01; %minimum temp (stopping condition)    
    
% function definitions
func                         = @(ParameterA, ParameterB, ParameterC, ParameterD) Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string);
vf                           = @(x)              func(x(1,:),x(2,:),x(3,:),x(4,:));           %FUNCTION
    
    



%set parameter ranges
lb_A = 0;
rb_A = 0.16;

lb_B = 0;
rb_B = 0.16;

lb_C = -0.15;
rb_C = 0;

lb_D = -0.15;
rb_D = 0;

%calculate the distance of the range
spreadA = (rb_A - lb_A);
spreadB = (rb_B - lb_B);
spreadC = (rb_C - lb_C);
spreadD = (rb_D - lb_D);

%initial parameter values
initA = (lb_A + spreadA/2);
initB = (lb_B + spreadB/2);
initC = (lb_C + spreadC/2);
initD = (lb_D + spreadD/2);  

%output to command window for user
InitialParameterA = initA
InitialParameterB = initB
InitialParameterC = initC
InitialParameterD = initD

%Initialize vectors for speed
NewMaxParameterA            = zeros(n,1);
NewMaxParameterB            = zeros(n,1);
NewMaxParameterC            = zeros(n,1);
NewMaxParameterD            = zeros(n,1);
NewMaxObjectiveFunction     = zeros(n,1);
NewMaxSharpeRatio           = zeros(n,1);

%set our initial location vector
xk = [  InitialParameterA
        InitialParameterB
        InitialParameterC
        InitialParameterD  ]

%compute initial objective function value
[initsharpe,initOF] = vf(xk);


%---------------------------------------------------------------------
counter = 0; 
i = 0; %loop semaphore variable

   while T > Tmin
            

        i = 1;
        % WHILE LOOP - used to determine if our position is a minimum                                                           
        while i <= n  
            
            %calculate normally distributed random step for each parameter
            deltaA = ((spreadA)/(1/T)).*randn(1); 
            deltaB = ((spreadB)/(1/T)).*randn(1); 
            deltaC = ((spreadC)/(1/T)).*randn(1); 
            deltaD = ((spreadD)/(1/T)).*randn(1); 
            
            %take random step from current location
            xkrand = [deltaA+xk(1) ; deltaB+xk(2) ; deltaC+xk(3) ; deltaD+xk(4) ];
            
                %if we fall outside our bounds, use previous value for that variable... this has potential for adjustment
                if xkrand(1) > rb_A || xkrand(1) < lb_A
                    xkrand(1) = xk(1); 
                end 
                
                if xkrand(2) > rb_B ||  xkrand(2) < lb_B
                    xkrand(2) = xk(2); 
                end 
                
                if xkrand(3) > rb_C || xkrand(3) < lb_C
                    xkrand(3) = xk(3); 
                end 
                
                if xkrand(4) > rb_D || xkrand(4) < lb_D
                    xkrand(4) = xk(4); 
                end             
            
                %calculate the objective function value at the current/updated location
            [randsharpe,randOF] = vf(xkrand);
         
            %determines which objective function we are optimizing
            % OFdiff = randsharpe-initsharpe;         OFtype = 'Sharpe';    
             OFdiff = randOF-initOF;               
             OFtype = 'MaxAnnualizedReturn/MaxDD';                

            %calculate the acceptance probability here
            a = (exp(OFdiff/T))
            
                if OFdiff >= 0
                     xk = xkrand; %update location
                    initOF = randOF; %update OF
                    initsharpe = randsharpe; %update sharpe
                    
                elseif OFdiff < 0
                    
                    if a > rand(1)  %should this be normally distributed?? *** IF ACCEPTANCE PROPABILITY(a) IS GREATER THAN THE RANDOM NUMBER, ACCEPT IT.
                    xk = xkrand; %update location
                    initOF = randOF;  %update OF
                    initsharpe = randsharpe; %update sharpe                    
                    end
                    
                end

            i = i + 1;
        end
         
    T = alpha*T; %Temperature decrease occurs here.
    newT = T %update temp
    
    counter = counter + 1;
   end
   
objectivefunctiontype = strcat('OBJECTIVE FUNCTION FOR THIS RUN IS: ',OFtype);   
disp(objectivefunctiontype)   
totalparforoutputsharpe(cnt,:) = initsharpe   %save parallel results
totalparforoutput(cnt,:) = initOF    %save parallel results
totalparforoutputxk(cnt,:) = xk      %save parallel results

end

    
   randnumber = num2str(floor(rand()*1000));               %create random number to be used for filename
   outputstring = strcat('SAoutput',randnumber,'.mat');     %create output string for filename
   save(outputstring);  %save workspace data
