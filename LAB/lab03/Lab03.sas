
filename r PIPE "DIR /S /B /L ""%sysfunc(PATHNAME(zoo))""";
filename s clipbrd; 

data _null_;
infile r dlm = '0A'x;
file s;
input;
if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');
put _infile_ ;
run;


gsubmit "filename s clipbrd; filename r PIPE ""DIR /S /B /L """"%%sysfunc(PATHNAME(%8b))""""""; data _null_;infile r dlm = '0A'x; file s;input;if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');put _infile_ ;run;";






