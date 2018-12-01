%graphing code  --> add output as well

%create GUI that can pull up previous runs data and run against buyandhold
%for their specific dates. 

%incorporate all the returns (annual,daily,monthly) into the graphing GUI.

 plot(TradeDate,cell2mat(BuyandholdNetLiqTotal),'g');
        set(gca,'YScale','log')
        hold on
        plot(TradeDate,cell2mat(NetLiqTotal));
        hold off