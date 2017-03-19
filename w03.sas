/* END OF LECTURE 2 */ /* Line 866 */


/* rurki to nie spodnie... to strumieniowe przetwarzanie danych - PIPE */




options VALIDVARNAME=ANY;

data x;
 'Ala ma kota'n = 17;
run;


data y;
set x;
z='Ala ma kota'n + 13;
run;

options VALIDVARNAME=v7;

data z;
set x;
run;





%put *%sysfunc(PATHNAME(ZBIORY))*;

filename rurka1 PIPE "DIR %sysfunc(PATHNAME(ZBIORY))";

data zbiory1;
infile rurka1 dlm = "0A"x;
input x :$char200.;
run;











filename rurka2 PIPE "DIR /S /B /L ""C:\SAS_WORK\""";

data zbiory2;
infile rurka2 dlm = "0A"x;
input;

if find(upcase(scan(_INFILE_,-1,".")),'SAS7BDAT');

length fullpath $ 2000 dsname $ 41;

dsname = scan(_infile_,-1,"\");
fullpath = substrn(_infile_, 1, length(strip(_infile_)) - length(strip(dsname)));

run;







filename rurka3 pipe "SET";

data zbiory3;
infile rurka3 dlm = "0A"x;
input x :$char2000.;
run;










filename rurka4 pipe 'tree "C:\SAS_WORK" /F /A' lrecl=5555;

data zbiory4;
infile rurka4 dlm = "0A"x;
input x :$char5555.;
run;









filename rurka5 pipe "COPY ""%sysfunc(PATHNAME(ZBIORY))\*"" ""%sysfunc(PATHNAME(WORK))""" lrecl=5555;

data zbiory5;
infile rurka5 dlm = "0A"x;
input x :$char5555.;
run;





libname zbiory  BASE "C:\SAS_WORK\zbiory";



DATA ZBIORY.dlugie_napisy;
array TABLICA[100] $216.;

    do i = 1 to 100000;
        x = ranuni(17);
        a = "BLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLEBLEBELBLE";
        b = "BLABLABALBLABLABALBLABLABALBLABLABALBLABLABALBLABLABAL";
        c = "BLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLUBLU";
        d = "BLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLOBLO";
        do j = 1 to dim(TABLICA);
            TABLICA[j] = cats(a,b,c,d);
        end;
        output;
    end;
run;






filename rurka6 pipe 
 "COPY ""%sysfunc(PATHNAME(ZBIORY))\dlugie_napisy.*"" ""%sysfunc(PATHNAME(WORK))""" 
lrecl=5555;

data zbiory6;
infile rurka6 dlm = "0A"x;
input x :$char5555.;
run;









filename rurka7 pipe 
 "ERASE ""%sysfunc(PATHNAME(ZBIORY))\dlugie_napisy.*"" ""%sysfunc(PATHNAME(WORK))\dlugie_napisy.*""" 
lrecl=5555;

data zbiory7;
infile rurka7 dlm = "0A"x;
input x :$char5555.;
run;









data lista_bibliotek;
infile cards;
input libname $ :8.;
cards;
work
zbiory
;
run;


filename XYZ "C:\SAS_WORK\11111111111111111111111111111111111.txt";
data _null_;
file XYZ;
set lista_bibliotek;

if libname = "work" then
do;
put "nie sprawdzaj WORKA ³osiu!!!";
end;

put _all_;

run;



filename XYZ "C:\SAS_WORK\2222222222222222222222222222222222.txt";
data _null_;
file XYZ;
set lista_bibliotek;

if libname = "work" then
do;
PUTLOG "nie sprawdzaj WORKA ³osiu!!!";
end;

put _all_;

run;


data _null_;
set lista_bibliotek;
rc = FILENAME('f' || strip(put(_N_,best32.)),'DIR /B /L /S "' || strip(PATHNAME(libname)) || '"', "PIPE"); 
PUTLOG "**" rc= "**";

CALL EXECUTE(
CATS(
 'data zbiory.from_'
,libname
,'; infile f'
,put(_N_,best32.)
,'%str( )dlm = "0A"x; input x :$char5555.; run;'
) 
);

run;

/*
data zbiory.from_work; 
infile f1%str( )dlm = "0A"x; input x :$char5555.; 
run;
*/




filename rurka8 PIPE "wmic logicaldisk get name, description";
data _null_;
infile rurka8 dlm='0A'x;
input disc $ :100.;
if findc(disc,":");
put _all_;
run;
filename rurka8;









filename schowek1 CLIPBRD;

data schowek1;
infile schowek1 dsd dlm = "0A"x;
input x :$char5555.;
run;

filename schowek1 clear;

filename schowe_e CLIPBRD;
data schowek1_e;
infile schowe_e dsd dlm = "0A"x;
input x :$char200.;
a1 = input(scan(x,1),best.);
a2 = input(scan(x,2),best.);
a3 = input(scan(x,3),best.);
run;










filename schowek CLIPBRD;

data _null_;
file schowek;
dsn = "sashelp.class";

length name $32;
do dsid = OPEN(dsn,'I') while(dsid ne 0);
 nvars = ATTRN(dsid,'NVARS');
 do i = 1 to nvars;
  name = VARNAME(dsid,i);
   if i NE nvars then put name +(-1) ", " @;
                 else put name +(-1) @;
 end;
 dsid = close(dsid);
end;
run;

filename schowek clear;










%macro GetVarList(DSNAME,SEPARATOR=%str(,));

filename schowek CLIPBRD;

%IF &DSNAME. ne  AND %sysfunc(EXIST(&DSNAME.)) %THEN %DO;

data _null_;
file schowek;
dsn = "&DSNAME.";

length name $32;
do dsid = open(dsn,'I') while(dsid ne 0);
 nvars = attrn(dsid,'NVARS');
 do i = 1 to nvars;
  name = varname(dsid,i);
   if i NE nvars then put name +(-1) "&SEPARATOR. " @;
                 else put name +(-1) @;
 end;
 dsid = close(dsid);
end;
run;

%END;

filename schowek clear;

%mend GetVarList;

%GetVarList(sashelp.cars,SEPARATOR= );

%GetVarList(sashelp.class);













/*
gsubmit "
filename s clipbrd;
data _null_;
file s;
d = '%8b'||.||'%32b';
length n $ 32;
do di=open(d,'I') while(di ne 0);
 do i=1 to attrn(di,'NVARS');
  n=varname(di,i);
  put n @;
 end;
end;
run;
filename s clear;
";
*/
/*
gsubmit "filename s clipbrd; data _null_; file s; d = '%8b'||.||'%32b'; length n $ 32; do di=open(d,'I') while(di ne 0); do i=1 to attrn(di,'NVARS'); n=varname(di,i); put n @; end; end; run; filename s clear;";
*/


/*
1) klik na okno Explorer
2) Tools -> Options -> Explorer... -> Members -> Table -> Edit
*/

/* elnd of lecture 3 */ /*1248*/
