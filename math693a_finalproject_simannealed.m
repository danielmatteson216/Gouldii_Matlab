clear; clc; close all
format long
% NOTE: We need to track the number of test cases it takes to get a larger
% solution value. As that number increases,the likelyhood of finding a
% better solution value decreases. As this likelyhood decreases past some
% threshold (this could be thought of as the some number of test guesses),
% we should accept the last solution that was found.

% how do we ensure we dont test the same value twice... or even values
% within some tolerance of previous values? (does this matter? this seems
% wrong) we dont want to spend time checking previous values every loop
% tho.
%%
counter = 0;
n = 35; %set total loop count
T = 1.0;
alpha = 0.9;

Tmin = 0.01;
startdate_string = '08/21/2006';
enddate_string = '11/02/2018';

% function definitions
func                         = @(ParameterA, ParameterB, ParameterC, ParameterD) Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string);
vf                           = @(x)              func(x(1,:),x(2,:),x(3,:),x(4,:));           %FUNCTION

lb1 = -0.30;
rb1 = 0;
lb2 = rb1;
rb2 = 0.30;

spread1 = (rb1 - lb1);
spread2 = (rb2 - lb2);

randnum1 = (lb1 + ((spread1).*rand(2,1))); %create 4 random numbers
randnum2 = (lb2 + ((spread2).*rand(2,1))); %create 4 random numbers

InitialParameterA = randnum2(1,1);
InitialParameterB = randnum2(2,1);
InitialParameterC = randnum1(1,1);
InitialParameterD = randnum1(2,1);

NewMaxParameterA            = zeros(n,1);
NewMaxParameterB            = zeros(n,1);
NewMaxParameterC            = zeros(n,1);
NewMaxParameterD            = zeros(n,1);
NewMaxObjectiveFunction     = zeros(n,1);
NewMaxSharpeRatio           = zeros(n,1);

xk = [  InitialParameterA
        InitialParameterB
        InitialParameterC
        InitialParameterD  ]

    %neighborhood calcs
lb = -0.02;
rb = 0.02;

spread = (rb - lb);

[initsharpe,initOF] = vf(xk);




%---------------------------------------------------------------------
        counter = 1; 
  
   while T > Tmin
            

        i = 1;
        % WHILE LOOP - used to determine if our position is a minimum
        %while randsharpe <= initsharpe                                                                 
        while i <= n  
            randnum = (lb + ((spread).*rand(4,1))); %create 4 random numbers

            xkrand = [randnum(1)+xk(1) ; randnum(2)+xk(2) ; randnum(3)+xk(3) ; randnum(4)+xk(4) ];
                        
            [randsharpe,randOF] = vf(xkrand);
            
            if randOF > initOF
               BestOF(i,:) = randOF;
               BestXK(i,:) = xkrand;
            else
               BestOF(i,:) = initOF;
               BestXK(i,:) = xk;
            end    
            
           OFdiff = randOF-initOF; 
            %calculate the acceptance probability here
            a = (exp(OFdiff/T))
            
                if OFdiff >= 0
                     xk = xkrand;
                    initOF = randOF; 
                    
                elseif OFdiff < 0
                    
                    if a > rand(1)
                    xk = xkrand;
                    initOF = randOF;   
                    end
                    
                end

            randomobjectivefunctionvalue = randOF;
            randomsharperatio = randsharpe;

            %initOF = randOF;
            
            i = i + 1;
        end
    
    OverallBestOF(counter,:) = BestOF(end,:);
    OverallBestXK(counter,:) = BestXK(end,:);
    T = alpha*T;
    newT = T
    
    counter = counter + 1;
   end

    


