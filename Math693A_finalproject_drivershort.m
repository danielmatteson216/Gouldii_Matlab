clear; clc; close all
format long

% call function
func         = @(ParameterA, ParameterB, ParameterC, ParameterD) Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string);

gradientfunc = @(ParameterA,ParameterB,ParameterC,ParameterD,functionvalue) [   (  (Math693A_finalproject( ParameterA + epsilon, ParameterB, ParameterC, ParameterD, startdate_string,enddate_string)  - functionvalue)/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB + epsilon, ParameterC, ParameterD, startdate_string,enddate_string)  - functionvalue)/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB, ParameterC + epsilon, ParameterD, startdate_string,enddate_string)  - functionvalue)/ epsilon);...
                                                                                (  (Math693A_finalproject( ParameterA, ParameterB, ParameterC, ParameterD + epsilon, startdate_string,enddate_string)  - functionvalue)/ epsilon)   ];
                                                                            
vf   = @(x)              func(x(1,:),x(2,:),x(3,:),x(4,:));           %FUNCTION
funcval = vf(xk);
vg   = @(x,funcval)      gradientfunc(x(1),x(2),x(3),x(4),funcval);       %GRADIENT
pD   = @(x)              -vg(x,funcval)/norm(vg(x,funcval));             %SEARCH DIRECTION(STEEPEST ASCENT)

phi  = @(a,x,p)  vf(x+a*p);                                       %PHI
phiD = @(a,x,p,funcval)  vg((x+a*p),funcval)'*p;                  %PHI DERIVATIVE


load('finalprojectmath.mat');

% WHILE LOOP - used to determine if our position is a minimum
while norm(vg(xk,funcval)) > 0.00001
    
    funcval = vf(xk);
                                                                            
    %Initial search direction and initial phi and phi derivative calculations
         %find descent direction: ---------------- steepest descent method---------------
    pkinit           = pD(xk);   
  
    evalphiInit      = phi(alphaZERO,xk,pkinit);
    evalphiInit_der  = phiD(alphaZERO,xk,pkinit,funcval);    
    
    alphaold         = 0;                       %PREVIOUS STEP LENGTH
    alphanew         = 1;                       %CURRENT STEP LENGTH
    i                = 1;                       %COUNTER  
        
    
    while(true == 1)       

        %find descent direction: ---------------- steepest descent method---------------
        pk = pD(xk);
        %find descent direction: ----------------      newton method    ---------------
 %       pk = pN(xk);        
     
        if( pk'*vg(xk,funcval) >= 0 )
            error('Uphill direction')
        end

        evalphiold       = phi(alphaold,xk,pk); %PREVIOUS PHI VALUE
        evalphik         = phi(alphanew,xk,pk); %CURRENT PHI VALUE      
 
        
        
        
        
        
        % =================================================================================================================
        % FIRST IF STATEMENT   -- current step(alphanew) represents a_high and the previous step(alphaold) represents a_low
        if (evalphik > (evalphiInit +( c1*alphanew*evalphiInit_der) )) || ( (evalphik >= evalphiold) && i>1 )
            a_high = alphanew;
            a_low = alphaold;          
            %------  ZOOM FUNCTION  -------
            alphastar = math693a_hmwk2_ZOOM(phi,phiD,a_low,a_high,xk,pk,c1,c2,evalphiInit,evalphiInit_der); 
            %------  ZOOM FUNCTION  -------    
            break;
        end
        
        evalphik_der     = phiD(alphanew,xk,pk,funcval);      
        
        
        % SECOND IF STATEMENT    
        if abs(evalphik_der) <= -c2*evalphiInit_der                         
            alphastar = alphanew;
            break;
        end   
          
              
        % THIRD IF STATEMENT -- current step(alphanew) represents a_low and the previous step(alphaold) represents a_high
        if evalphik_der >= 0
            a_high = alphaold;
            a_low = alphanew;
            %------  ZOOM FUNCTION  -------                
            alphastar = math693a_hmwk2_ZOOM(phi,phiD,a_low,a_high,xk,pk,c1,c2,evalphiInit,evalphiInit_der);
            %------  ZOOM FUNCTION  -------    
            break;
        end
        % =================================================================================================================
        
        
        
        
        alphanew = (alphamax + alphaold) / 2; %pick new alpha
        i = i + 1;  %advance the counter
        alphaold = alphanew; %set new alpha = to old alpha for next run
    end
   
    counter = counter + 1
    
    %construct vector of all step lengths
    AStar = alphastar;    
    
    A(counter) = AStar;
    
    %calculate new position
    xnext = xk + (alphastar.*pk);
    
    if( func(xnext(1),xnext(2),xnext(3),xnext(4)) >= func(xk(1), xk(2),xk(3), xk(4)) )
        %errmsg = strcat('Uphill step!! Occurs on iteration #',num2str(counter),' ------ current function value = ',num2str(func(xnext(1),xnext(2))),...
        %    ' & current stepsize = ',num2str(alphastar),' ------ previous function value = ',num2str(func(xk(1),xk(2))),' & previous stepsize = ',num2str(A(counter-1)),...
        %    ' ------- optimal function value = ',num2str(func(1,1)));
        errmsg ='shit is fucked';
        error(errmsg)
    end
    
    %save resulting function values and position
    Results(counter,1) = func(xk(1),xk(2),xk(3),xk(4));
    Results(counter,2) = xk(1);
    Results(counter,3) = xk(2);
    Results(counter,2) = xk(3);
    Results(counter,3) = xk(4);    
    Results(counter,4) = A(counter); 
   
    %set new to old for subsequent iteration
    xk = xnext;
    XK = [XK xk];    
    
    %stop if code runs past MaxIter value
    if counter == MaxIter;
        msg = 'Maximum Number of Iterations Exceeded';
        error(msg);
    end
    
end


% --------------------------       GRAPHS       ---------------------------
%{
                figure(1)
                [x,y] = meshgrid(-10:.25:10);
                Rosenbrock = (  (100*( y - (x.^2) ).^2) + (( 1 - x ).^2)  );
                surf(x,y,log(Rosenbrock+1),'facealpha',0.75)
                title('Optimization of Rosenbrock''s function')
                xlabel('x value');
                ylabel('y value');
                zlabel('Rosenbrock function value');
                shading interp
                hold on
                plot3(Results(:,2),Results(:,3),log(1+Results(:,1)),'c')
                hold on
                plot3(Results(1,2),Results(1,3),log(1+Results(1,1)),'g*') 
                hold on
                plot3(Results(end,2),Results(end,3),log(1+Results(end,1)),'r*') 

                
                figure(2)
                subplot(3,1,1);                
                plot((1:1:length(A)),log(Results(:,1)));
                legend ('Optimization Method Output','Location','northeast');
                title('Log of Function Value vs Iteration')                
                xlabel('Iteration');
                ylabel('Log(Function Value)');
                subplot(3,1,2);                
                plot((1:1:length(A)),(Results(:,1)));
                legend ('Optimization Method Output','Location','northeast');
                title('Function Value vs Iteration')                
                xlabel('Iteration');
                ylabel('Function Value');              
                subplot(3,1,3);                
                loglog((1:1:length(A)),(Results(:,1)));
                legend ('Optimization Method Output','Location','northeast');
                title('Log of Function Value vs Log of Iteration')                
                xlabel('Log(Iteration)');
                ylabel('Log(Function Value)');                   

                
                figure(3)
                plot(XK(1,:),XK(2,:),'c')
                hold on
                plot(XK(1,1),XK(2,1),'g*')  
                hold on
                plot(XK(1,end),XK(2,end),'r*') 
                legend ('Function output path hw2','Initial guess','Final point (minimum)','Location','southeast');
                title('Historical Path Of Function (Iteration 1 --> Final)')                
                xlabel('x value');
                ylabel('y value');
                
                
                                
                figure(4)
                subplot(3,1,1);
                plot((1:1:length(A)),log(A));
                legend ('Stepsize (Alpha)','Location','northeast');
                title('Log of Stepsize vs Iteration')                
                xlabel('Iteration');
                ylabel('Log(Stepsize)');
                subplot(3,1,2);
                plot((1:1:length(A)),A);
                legend ('Stepsize (Alpha)','Location','northeast');
                title('Stepsize vs Iteration')                
                xlabel('Iteration');
                ylabel('Stepsize (Alpha)');              
                subplot(3,1,3);                
                loglog((1:1:length(A)),A);
                legend ('Stepsize (Alpha)','Location','northeast');
                title('Log of Stepsize vs Log of Iteration')                
                xlabel('Log(Iteration)');
                ylabel('Log(Stepsize)');  

                                
                figure(5)
                contourf(x,y,log(Rosenbrock+1),length(Rosenbrock)/2)
                axis([-5 5 -6 6])
                title('Optimization of Rosenbrock''s function')
                xlabel('x value');
                ylabel('y value');
                shading interp
                hold on
                plot(Results(:,2),Results(:,3),'c','LineWidth',1)                
                hold on
                plot(Results(1,2),Results(1,3),'g*') 
                hold on 
                plot(Results(end,2),Results(end,3),'r*')  
                legend ('Rosenbrock Function','Optimization path hw2','Initial guess','Final point (minimum)','Location','southeast');
                
                figure(6)
                contourf(x,y,log(Rosenbrock+1),length(Rosenbrock)/2)
                axis([(min(XK(1,:))-.1) (max(XK(1,:))+.1) (min(XK(2,:))-.1) (max(XK(2,:))+.1)])
                title('Optimization of Rosenbrock''s function')
                xlabel('x value');
                ylabel('y value');
                shading interp
                hold on
                plot(Results(:,2),Results(:,3),'c','LineWidth',1)                
                hold on
                plot(Results(1,2),Results(1,3),'g*') 
                hold on 
                plot(Results(end,2),Results(end,3),'r*')  
                legend ('Rosenbrock Function','Optimization path hw2','Initial guess','Final point (minimum)','Location','southeast');
                   
                %display vital statistics 
                format long
                fprintf('-----------------\n')
                fprintf('Results:\n')                
                fprintf('-----------------\n')
                x_initial        =  [XK(1,1);XK(2,1)]
                x_star           =  xnext
                objective_value  =  vf(x_star)
                norm_gradient    =  norm(vg(x_star))
                iterations       =  counter
%}