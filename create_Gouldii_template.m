function create_Gouldii_template = Gouldii_Strategy_Template(V)
V = strcat('C:\Program Files\Matlab\MATLAB Production Server\R2015a\bin\Gouldii_root\Strategies\Gouldii_Strategy_',V);
copyfile('Gouldii_Strategy_Template.m',V)
edit(V)
end