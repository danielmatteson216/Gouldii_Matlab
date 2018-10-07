function create_Gouldii_template = Gouldii_Strategy_Template(inputstring)
filepath = strcat('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Strategies\Gouldii_Strategy_',inputstring);
copyfile('Gouldii_Strategy_Template.m',filepath)
edit(filepath)
inputstring = strcat('Gouldii_Strategy_',inputstring);
inputstring = inputstring(1:end-2);
SelectedStrategy_input = inputstring;
%SelectedStrategy_input = str2func(SelectedStrategy_input);
assignin('base','SelectedStrategy_input',SelectedStrategy_input);
changefuncname;
%str = 'Gouldii_Strategy_Template';
%newstr = strrep(str,'Template',V);



    %replace the name of function to match the name of file
    function changefuncname
       
        replaceLine = 0;
        newtext1 = 'function [sigprevious,sigw1,sigw2,ticker1,ticker2] = ';
        newtext2 = '(Serial_startdate,Serial_enddate,CONTANGO,CONTANGO30,y_CONTANGO,y_CONTANGO30,y_sig,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry,TargetWeightVX1_S30,TargetWeightVX2_S30,TargetWeightVX1_S45,TargetWeightVX2_S45,curve_tickers,gouldiiVCO)';
        newtext3 = strcat(newtext1,SelectedStrategy_input,newtext2);
        
        fileID = fopen(filepath, 'r+');
        
%            for k=1:(replaceLine-1)
%                fgetl(fileID);
%            end

fgetl(fileID);

        %fseek(fileID,0,'cof');
        fprintf(fileID,newtext3);
        fclose(fileID);
    end

mkdir('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\',SelectedStrategy_input);
strategydir = strcat('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Reference\',SelectedStrategy_input);

mkdir(strategydir, 'Results');
mkdir(strategydir, 'Graphs');
mkdir(strategydir, 'OptParams');
mkdir(strategydir, 'WFA');

end