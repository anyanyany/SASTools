/* Lab 3
Zawadzka Anna */

gsubmit "filename s clipbrd;data _null_;file s;d='%8b'||.||'%32b';q=pathname(scan(d,1,'.'));p=FILENAME('DIR /B /L '||q||'\','PIPE');infile p dlm='0A'x;input;if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');f=cats(q,_infile_);put f;run;filename s clear;";

