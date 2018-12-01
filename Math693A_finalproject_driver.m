 %clear;clc;
 format long
 
 epsilon = 10^-3;
 
%determine method of running code
prompt = 'Press 1 for manual, or 0 for auto\n ';
method= input(prompt);
 
    if method == 1 
            % set dates (start)
        prompt = 'Set StartDate\n ';
        startdate_string = input(prompt,'s');
            % set dates (end)
        prompt = 'Set EndDate\n ';
        enddate_string = input(prompt,'s');
            % set ParameterA
        prompt = 'Set ParameterA\n ';
        ParameterA = input(prompt);
            % set ParameterB
        prompt = 'Set ParameterB\n ';
        ParameterB = input(prompt);
            % set ParameterC
        prompt = 'Set ParameterC\n ';
        ParameterC = input(prompt);
            % set ParameterD
        prompt = 'Set ParameterD\n ';
        ParameterD = input(prompt);
        
    elseif method == 0
%        startdate_string = '08/21/2008';
%        enddate_string = '11/02/2018';
        startdate_string = '08/21/2006';
        enddate_string = '11/02/2018';
        %ParameterA =   -.09;
        %ParameterB =   0;
        %ParameterC =  0.04;  %optmized using our updated SA method
        %ParameterD =  0.03;
        
        %ParameterA =   0.0376;        
        %ParameterB =   0.0154961;
        %ParameterC =   0.0039707; %optmized using SD method 
        %ParameterD =   -0.019874;  
        
        %ParameterA =   .075;        
        %ParameterB =   .075;
        %ParameterC =   -.075; % average baseline results
        %ParameterD =   -.075; 
        
        %ParameterA =   .12;        
        %ParameterB =   .06;
        %ParameterC =   -.1; % LO results
        %ParameterD =   -.1;  
        
        
        ParameterA =   0.11516811;        
        ParameterB =   0.057639137;
        ParameterC =   -0.178141785; % SA results
        ParameterD =   -0.195732866;  
          
        
    else 
        error('MUST PRESS 2, 1 or 0');
    end
   
% call function
[func,ObjectiveVal]   = Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)
% calculate derivatives 
%d_PA = Math693A_finalproject( ParameterA + epsilon, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string) 
%d_PB = Math693A_finalproject( ParameterA, ParameterB + epsilon, ParameterC, ParameterD, startdate_string,enddate_string) 
%d_PC = Math693A_finalproject( ParameterA, ParameterB, ParameterC + epsilon, ParameterD, startdate_string,enddate_string) 
%d_PD = Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD + epsilon, startdate_string,enddate_string) 

%dPA = ((d_PA - funcval)/ epsilon);%finite difference with respect to parameterA
%dPB = ((d_PB - funcval)/ epsilon);%finite difference with respect to parameterB
%dPC = ((d_PC - funcval)/ epsilon);%finite difference with respect to parameterC
%dPD = ((d_PD - funcval)/ epsilon);%finite difference with respect to parameterD

%gradval = [dPA; dPB; dPC; dPD;]
