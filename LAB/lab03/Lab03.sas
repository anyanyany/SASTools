
* Wersja robocza, tez dziala;
filename r PIPE "DIR /S /B /L ""%sysfunc(PATHNAME(zoo))""";
filename s clipbrd; 

data _null_;
infile r dlm = '0A'x;
file s;
input;
if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');
put _infile_ ;
run;

* Wersja finalna;
gsubmit "filename s clipbrd; filename r PIPE ""DIR /S /B /L """"%%sysfunc(PATHNAME(%8b))""""""; data _null_;infile r dlm = '0A'x; file s;input;if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');put _infile_ ;run;";




filename r PIPE "DIR /S /B /L ""%sysfunc(PATHNAME(zoo))""";
filename s clipbrd; 

data _null_;
r=FILENAME("DIR /B /L %sysfunc(PATHNAME(zoo))",'PIPE');
infile r dlm = '0A'x;
file s;
input;
if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');
put _infile_ ;
run;

d:\sastools\zoo\animals.sas7bdat
d:\sastools\zoo\contract_types.sas7bdat
d:\sastools\zoo\divisions.sas7bdat
d:\sastools\zoo\employees.sas7bdat
d:\sastools\zoo\food.sas7bdat
d:\sastools\zoo\objects.sas7bdat
d:\sastools\zoo\orders.sas7bdat
d:\sastools\zoo\other_expenses.sas7bdat
d:\sastools\zoo\positions.sas7bdat
d:\sastools\zoo\responsible_staff.sas7bdat
d:\sastools\zoo\species.sas7bdat
d:\sastools\zoo\species_dietary_requirements.sas7bdat
d:\sastools\zoo\suppliers.sas7bdat
d:\sastools\zoo\supplies.sas7bdat
d:\sastools\zoo\supplies_details.sas7bdat
d:\sastools\zoo\ticket_types.sas7bdat
d:\sastools\zoo\transactions.sas7bdat
d:\sastools\zoo\transaction_details.sas7bdat


filename s clipbrd;
data _null_;
file s;
d='zoo.food';
q=pathname(scan(d,1,'.'));
put q=;
q=cats("DIR /B /L ",q);
put q=;
path=FILENAME(q,'PIPE');
infile path dlm='0A'x;
input;
if find(upcase(scan(_INFILE_,-1,'.')),'SAS7BDAT');
f=cats(q,_infile_);
put f;
run;
filename s clear;
