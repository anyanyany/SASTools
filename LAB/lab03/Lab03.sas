
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



gsubmit "
data _null_;x='%8b';r=FILENAME('r','DIR /S/B/L ' || translate(compress(pathname(x),'()'),'""',""'""),'PIPE');run;filename s CLIPBRD;data _null_;infile r dlm='0A'x;file s;input;if scan(_infile_,-1)='sas7bdat';put _infile_;run;filename s;
";

/*
gsubmit "
filename s CLIPBRD;
data _null_;
set sashelp.vtable;
where libname = upcase('%8b') and memname like upcase(substr('%32b',1,1) || '%%');
file s;
length x $ 41; x =catx('.',libname,memname);
put x;
run;
filename s;
";


