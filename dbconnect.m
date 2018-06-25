%clear; clc; close all;
%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'cellarray');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');

%Make connection to database.  Note that the password has been omitted.
%Using ODBC driver.
global conn
conn = database('gouldiiDb', 'root', 'toad');
