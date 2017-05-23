/*"magic string"*/

*);*/;/*'*/ /*"*/; %MEND;run;quit;;;;;















/* kilka drobiazgow na temat rzeczy, o ktorych podobno wszystko wiemy :-) */

libname _in_  BASE "C:\SAS_WORK\sas2\zbiory_in";

libname _out_ BASE "C:\SAS_WORK\sas2\zbiory_out";

libname _out2_ BASE "C:\SAS_WORK\sas2\zbiory_out_%sysfunc(datetime(),B8601DT15.)";

%put "C:\SAS_WORK\sas2\zbiory_out_%sysfunc(datetime(),B8601DT15.)";
























options DLCREATEDIR;
run;  /* run nie jest obowiazkowy */

libname _out2_ BASE "C:\SAS_WORK\sas2\zbiory_out_%sysfunc(datetime(),B8601DT15.)";

/* opcja DLCREATEDIR pozwala utworzyc katalog */















libname _out3_ BASE "C:\SAS_WORK\sas2_nie_ma_mnie\zbiory_out_%sysfunc(datetime(),B8601DT15.)";





/* skoro nie moge utworzyc calej sciezki, to po co mi to ?*/

/* np. tymczasowe dodatkowe podkatalogi w work'u */

libname _out4_ BASE "%sysfunc(GETOPTION(work))\pomocniczy_podkatalog";


%put %sysfunc(GETOPTION(work));




















/* czytanie i pisanie do plikow */
/* telegram: */
data telegram1;
infile cards dlm = ".";
input zdanie $ :200. @@;
if lengthN(zdanie);
datalines;
Moi drodzy! Stop. Dojechalismy nad morze. Stop.
Pogoda dopisuje. StoP. Stryjenka ma sie lepiej.
Stop.
Pozdrawiam, Bazyli. Stop.
;
run;











data telegram2;
infile CARDS DLMSTR = "Stop.";
input zdanie $ :200. @@;
if lengthn(zdanie);
DATALINES;
Moi drodzy! Stop. Dojechalismy nad morze. Stop.
Pogoda dopisuje. StoP. Stryjenka ma sie lepiej.
Stop.
Pozdrawiam, Bazyli. Stop.
;
run;


/* DLMSTR - pozwala zastapic pojedynczy znak rozdzielajacy calym napisem */










data telegram3;
infile cards dlmstr = "stop." DLMSOPT='i'; 
input zdanie $ :200. @@;
if lengthn(zdanie);
datalines;
Moi drodzy! Stop. Dojechalismy nad morze. Stop.
Pogoda dopisuje. StoP. Stryjeka ma sie lepiej.
Stop.
Pozdrawiam, Bazyli. Stop.
;
run;

/* DLMSOPT - doodaje dodatkowe opcje "i" <- caes insensitive */





data tabelka;
format id wiek wzrost waga best32.;

infile CARDS4 dlmstr = "</TD><td>" dlmsopt='i' missover; 
input id_char $ :200. wiek wzrost waga_char $ :200. ;

id   = input(COMPRESS(id_char  , ,'DK'),best32.);
waga = input(compress(waga_char, ,'dk'),best32.);
drop id_char waga_char;
if id;

DATALINES4;
<table>
<tr><th>ID</th><th>AGE</th><th>HEIGHT</th><th>WEIGHT</th></tr>
<tr><td>131</td><td>23</td><td>173</td><td>80</td></tr>
<tr><td>448</td><td>31</td><td>181</td><td>83</td></tr>
<tr><td>765</td><td>47</td><td>190</td><td>102</td></tr>
<tr><td>1082</td><td>19</td><td>186</td><td>75</td></tr>
<tr><td>1399</td><td>28</td><td>174</td><td>75</td></tr>
<tr><td>16116</td><td>51</td><td>169</td><td>60</td></tr>
<tr><td>19133</td><td>33</td><td>182</td><td>78</td></tr>
</table>
;;;;
run;







/* chcemy zapisac utworzony plik do lokalizacji wskazanej przez biblioteke _out4_ */

filename _out4_ "%sysfunc(PATHNAME(_out4_))\wynikowy.txt";

data _null_;
set tabelka;
file _out4_ dlmstr = "<separator>";
put id wiek wzrost waga;
run;

%put **%sysfunc(FILEEXIST(%sysfunc(PATHNAME(_out4_))\wynikowy.txt))**;







filename _out4_ "%sysfunc(PATHNAME(_out4_))\wynikowy2.txt";

data _null_;
set tabelka;
length separator $ 20;
separator = cats("<separator",put(_N_,best.),">"); /* best12.*/
file _out4_ dlmstr = separator;
put id wiek wzrost waga;
run;

%put **%sysfunc(FILEEXIST(%sysfunc(PATHNAME(_out4_))\wynikowy2.txt))**;







filename _out4_ "%sysfunc(PATHNAME(_out4_))\wynikowy3.txt";

data _null_;
set tabelka;
length separator $ 20;
separator = cats("<separator",put(_N_,best.),">");
file _out4_ dlmstr = separator DLMSOPT='T'; /* <- kasujemy zbedne spacje */
put id wiek wzrost waga;
run;

%put **%sysfunc(FILEEXIST(%sysfunc(PATHNAME(_out4_))\wynikowy3.txt))**;







%macro make_data_set(n,prefix=work.test_ds_);

%do i = 1 %to &n.;
 data &prefix&i.;
  do i = 1 to &n.;
   x = ranuni(&i.);
   y = ranuni(&i.);
   z = ranuni(&i.);
   output;
  end;
 run;
%end;

%mend make_data_set;
%make_data_set(5);








data combine1;
set work.test_ds_1 work.test_ds_2 work.test_ds_3 work.test_ds_4 work.test_ds_5;
run;















data combine2;
set
%macro ccc(n);
%do i = 1 %to &n.;
 work.test_ds_&i.
%end;
%mend ccc;
%ccc(5)
;
run;








/* mo¿na napisaæ to szybciej :-) */

data combine3;
set work.test_ds_1 - work.test_ds_5;
run;








/* ale niestety jak w "liscie" jest dziura */

data combine4;
set work.test_ds_1 - work.test_ds_5;
run;










/* ratuje nas notacja prefixowa z ":" */

data combine5;
set work.test_ds_:;
run;



%macro make_data_set_date(n,prefix=work.test_date_ds_r,date="20sep2016"d);

%do i = 0 %to &n.;
 data &prefix%sysfunc(INTNX(MONTH, &date., &i., BEGIN),yymm7.);
  do i = 1 to &n.;
   x = ranuni(&i.);
   y = ranuni(&i.);
   z = ranuni(&i.);
   output;
  end;
 run;
%end;

%mend make_data_set_date;
%make_data_set_date(5);
















/* ale jak ja sie dowiem z ktorego zbioru mam informacje? */

data combine6;
length in_data_set $ 41;
set work.test_date_ds_: INDSNAME = indsname;
in_data_set = indsname;
run;


 



data combine7;
length in_data_set 8;
set work.test_date_ds_: INDSNAME = indsname;
in_data_set = COMPRESS(indsname, , "TPSA");

r = floor(in_data_set/100);
m = mod(in_data_set,100);
run;













/* tworzenie makrozmiennych w SQLu */
proc sql noprint;
 select distinct x format best32.
 into :x1-:x&sysmaxlong                /* <- 2'147'483'647 */
 from combine6
 ;
 %let num_values = &sqlobs;
quit;

%put **&num_values.**;


%macro p(nvalues,prefix=x);
%do i = 1 %to &&&nvalues;
 %put NOTE:[&SYSMACRONAME.] **&&&prefix&i.**;
%end;

%mend p;

%p(num_values);





proc sql noprint;
 select distinct i
 into :x1-
 from combine6
 ;
 %let num_values = &sqlobs;
quit;

%put **&num_values.**;

%p(num_values);

/* END OF LECTURE 1 */ /* Line 455 */







proc sql noprint;
 select distinct count(i) as ile_i
 into :x
 from combine6
 ;
quit;

%put **&x**;

%put **%trim(&x)**;











proc sql noprint;
 select distinct count(i) as ile_i
 into :y TRIMMED /* <- kasuje spacej przed i po */
 from combine6
 ;
quit;

%put **&y**;










/* tablice */
data tablice1;
set combine6;

Array XYZ[3] x y z;

Array ABC[3];

do i = 1 to dim(XYZ);
 ABC[i]=XYZ[i];
end;
run;







data tablice2;
set combine6;

Array XYZ x y z; /* tablica deklarowana nie wprost */

Array ABC[3];

do OVER XYZ; 
 ABC[_i_]=XYZ;
end;
run;








data tablice3;
set combine6;

t=.;
Array XYZ x y z t; /* tablica deklarowana nie wprost */

Array ABC[4];

do OVER XYZ; 
 ABC[_i_]=XYZ;
end;

CALL SORTN (of ABC[*]); /* call sortN sortuje zmienne numeryczne w tablicy , lub podanej liscie */

put / (XYZ[*]) (=);
put (ABC[*]) (=/);

put '**********';
s = SMALLEST (1, of XYZ[*]); /* k-ty najmniejszy niepusty */
l = LARGEST (1, of XYZ[*]);  /* k-ty najwiekszy niepusty  */
o = ORDINAL (1, of XYZ[*]);  /* k-ty najmniejszy wg. SASa */

Array SLO s l o;
put (SLO[*]) (=);
/*
put '**********';
s = SMALLEST (dim(XYZ), of XYZ[*]); 
l = LARGEST (dim(XYZ), of XYZ[*]);  
o = ORDINAL (dim(XYZ), of XYZ[*]);  

put (SLO[*]) (=);
*/
run;












/* skoro juz jestesmy przy sortowaniu... */
%let _st_ = %sysfunc(datetime());
%make_data_set(1000,prefix=work.zzzzzz_); /* Ctrl + F2 */
%let _en_ = %sysfunc(datetime());
%put NOTE:[BJ] czas przetwarzania: %sysevalf(&_en_. - &_st_.) s.;


options nomprint nomlogic nosymbolgen;
%put NOTE:[BJ] czas przetwarzania: %sysevalf(&_en_. - &_st_.) s.;
%put NOTE-[BJ] %sysevalf((&_en_. - &_st_.)/1000) na zbior. Sporo nie?;
%put NOTE-[BJ] Popracuj nad wydajnoscia.;






data z_combined;
length in_data_set $ 41;
set work.zzzzzz_: indsname = indsname;
in_data_set = indsname;
run;












proc datasets lib = work NODETAILS;
delete zzzzzz_:;
run;
quit;









proc sort data = z_combined out = sorted3 EQUALS;
by i;
run;

proc sort data = z_combined out = sorted4 NOEQUALS;
by i;
run;














data alfabet_pl;
infile cards dlm=" ";
input symbol $ :2. @@;
cards;
Q W E R T Y U I O P A S D F G H J K L Z X C V B N M
q w e r t y u i o p a s d f g h j k l z x c v b n m
0 9 8 7 6 5 4 3 2 1
00 99 88 77 66 55 44 33 22 11
A Z S Z E C N Ó L a z s z c n ó l
;
run;


proc sort data = alfabet_pl out = alfabet_pl_000;
by symbol;
run;



Proc SORT
data=alfabet_pl
out=alfabet_pl_sort1
SORTSEQ=POLISH
;
    by symbol;
run;




Proc SORT
data=alfabet_pl
out=alfabet_pl_sort2
SORTSEQ=LINGUISTIC
(
CASE_FIRST=UPPER
LOCALE=pl_PL
)
;
    by symbol;
run;
/* zmiana sortowania: WIELKIE przed malymi */




Proc SORT
data=alfabet_pl
out=alfabet_pl_sort3
SORTSEQ=LINGUISTIC
(
CASE_FIRST=UPPER
LOCALE=pl_PL
NUMERIC_COLLATION=ON /* <- sortujemy liczby jak liczby nie jak napisy */
)
;
    by symbol;
run;




DATA dlugie_napisy;
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

Proc SORT
data=dlugie_napisy
out=dlugie_napisy_TAGSORT
TAGSORT
;
    by x;
run;



Proc SORT
data=dlugie_napisy
out=dlugie_napisy_NOTAGSORT
;
    by x;
run;

/*
TAGSORT

przechowuje tylko zmienne z BY i numer obserwacji z oryginalnego zbioru, 
przez co plik posredni do sortowania jest mniejszy

TAGSORT nie jest kompatybilna z OVERWRITE

TAGSORT nie dziala przy sortowaniu wielowatkowym

*/

proc sql;
drop table dlugie_napisy;
drop table dlugie_napisy_TAGSORT;
drop table dlugie_napisy_NOTAGSORT;
quit;





DATA dlugi;
    do i = 1 to 1e7;
        x = ranuni(17);
        y = mod(i,10);
        output;
    end;
run;



Proc SORT
data=dlugi
out=dlugi_THREADS
THREADS
;
    by y x;
run;
/*THREADS | NOTHREADS
zezwala lub nie na sortowanie wielowatkowe
nie wspolpracuje z TAGSORT
*/


Proc SORT
data=dlugi
out=dlugi_NOTHREADS
NOTHREADS
;
    by y x;
run;


proc sql;
drop table dlugi;
drop table dlugi_THREADS;
drop table dlugi_NOTHREADS;
quit;





/* KEY */

data z;
 input x y;
cards;
2 3
23 25
23 22
2 4
23 22
1 2
1 2
;
run;


proc sort data = z out = b1;
 by x y;
run;

proc sort data = z out = k1a;
 key x y;
run;

proc sort data = z out = k1b;
 key x; 
 key y;
run;


proc sort data = z out = b2;
 by descending x y;
run;

proc sort data = z out = k2;
 key x / descending; 
 key y;
run;


proc sort data = z out = b3;
 by descending x descending y;
run;

proc sort data = z out = k3;
 key x y / descending; 
run;







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














/* jeszcze dwa slowa o makrach */ 

dm log 'clear' log;     /* <- to bedzie kiedy indziej :-) */
%macro a1(xyz);
%put NOTE:[&SYSMACRONAME.] **GO!**;
 data &xyz (index=(x)); /* <- to bedzie kiedy indziej :-) */
  do x=1 to 100; 
    y="A" || put(x,best. -L) ; output;
  end;
 run;
%put NOTE:[&SYSMACRONAME.] **END**;
%mend a1;

%macro a2(ABC);
%put NOTE:[&SYSMACRONAME.] **GO!**;
 %a1(&ABC.)

 proc sql;
 create table &ABC.2 as
  select x, sum(x) as i
  from &ABC.
  where x < 33
  having x between avg(x) - std(x) and avg(x) + std(x)
  order by x
 ;
 quit;

 data &ABC.3;
 merge &ABC. &ABC.2;
 by x;
 run;

%put NOTE:[&SYSMACRONAME.] **END**;
%mend a2;

%put NOTE:[&SYSMACRONAME.] **GO!**;
%a2(ghi)
%put NOTE:[&SYSMACRONAME.] **END**;





options STIMER;





options STIMER MPRINT;





options STIMER MPRINT SYMBOLGEN;





options STIMER MPRINT SYMBOLGEN MLOGIC;





options STIMER MPRINT SYMBOLGEN MLOGIC MLOGICNEST;





options STIMER MPRINT SYMBOLGEN MLOGIC MLOGICNEST MCOMPILENOTE=ALL; /* NONE, NOAUTOCALL, ALL */





options STIMER MPRINT SYMBOLGEN MLOGIC MLOGICNEST MCOMPILENOTE=ALL MSGLEVEL=I; /* I, N*/





options STIMER MPRINT SYMBOLGEN MLOGIC MLOGICNEST MCOMPILENOTE=ALL MSGLEVEL=I FULLSTIMER; /* (*) */

/* real time       - calkowity czas wykonania programu - zegar ze sciany                  */
/* user cpu time   - czas procesora potrzebny na wykonanie kodu                           */
/* system cpu time - czas na operacje systemowe przygotowujace/wspierajace wykonanie kodu */
/* memory          - pamiec potrzebna do wykonania data stepu                             */
/* OS memory       - maksymalna ilosc pamieci, ktora byla potrzebna z systemu             */
/* Timestamp       - the date and time that a step was executed.                          */

/* srodowiska UNIX/Linux maj¹ bogatszy wypis do loga z opcji FULLSTIMER: */
/* za dokumentacja:


Timestamp - the date and time that a step was executed. 
Page Faults - the number of pages that SAS tried to access but were not in main memory and 
              required I/O activity. 
Page Reclaims - the number of pages that were accessed without I/O activity. 
Page Swaps - the number of times a process was swapped out of main memory.
Voluntary Context Switches - the number of times that the SAS process had to pause because 
                             of a resource constraint such as a disk drive. 
Involuntary Context Switches - the number of times that the operating system forced the SAS 
                               session to pause processing to allow other process to run. 
Block Input Operations - the number of I/O operations that are performed to read the data into memory. 
Block Output Operations - the number of I/O operations that are performed to write the data to a file.  
*/



options LRECL = max; /* logical record length = 32767 */
filename MPRINT "C:\SAS_WORK\sas2\executed_macro_text.txt" ;
options STIMER MPRINT MLOGIC SYMBOLGEN MLOGICNEST MCOMPILENOTE=ALL MSGLEVEL=I FULLSTIMER MFILE;







%macro debugging(_out_code_set_=);
%if &_out_code_set_. ne 
%then
%do;
filename MPRINT "&_out_code_set_." lrecl = max;
options
MPRINT 
MFILE
MLOGIC 
SYMBOLGEN 
MLOGICNEST 
MCOMPILENOTE=NOAUTOCALL /* ALL */
STIMER
FULLSTIMER 
MSGLEVEL=I;
DETAILS 
run;
%end;
%else %do;
filename MPRINT CLIPBRD;
filename MPRINT;
options 
NOMPRINT 
NOMFILE 
NOMLOGIC 
NOSYMBOLGEN 
NOMLOGICNEST 
MCOMPILENOTE=NONE
/*NO*/ STIMER 
NOFULLSTIMER 
MSGLEVEL=N; 
run;
%end;

%mend debugging;

%debugging();

%debugging(C:\SAS_WORK\sas2\executed_macro_text.txt);



options DETAILS; /* <- troche wiecej szczegolow */
option FULLSTIMER;








/* kilka "MACROdrobiazgow": */



/* chcemy stworzyc makro, ktore buduje zbior o nazwie ZBIOR ze zmienna 'x', 
   ktorej wartosc to string "Jestesmy w zbiorze ZBIOR"
*/
%macro stworz(zbior);
 
 %put NOTE: Budujemy zbior: &zbior w makrze: &SYSMACRONAME.;
 data &zbior;
  x="Jestesmy w zbiorze &zbior";
 run;

%mend;

data abc; /*pomocniczy zb SASowy*/
 input nazwa $;
 cards;
a1
b2
c3
;
run;




data _null_;
 set abc;
 CALL SYMPUT('nazwa',nazwa);
 CALL EXECUTE('%stworz(&nazwa)');
run;




%stworz(Stefan); /* na prosbe Pana Jarka */


%stworz(Stefan1);
%stworz(Stefan2);



data _null_;
 set abc;
 call symput('nazwa',nazwa);
 rc = DOSUBL('%stworz(&nazwa)'); /* nowosc w SAS 9.4 */
 putlog "#############" rc= "#############";
run;













%macro stworz2(zbior);
 
 data &zbior;
  x="Jestesmy w zbiorze &zbior";
  y = Rannor(input("6"||compress("&zbior.",,"TPSA"),best32.));
  call SYMPUTX("na_zywo_z_&zbior.",y,"L");
 run;

 %put NOTE:[BJ] Realacja na zywo z makra &SYSMACRONAME.;
 %put NOTE-[BJ] Zbudowalismy(?) zbior *&zbior.*;
 %put NOTE-[BJ] Nowa makrozmienna na_zywo_z_&zbior. ma wartosc *&&na_zywo_z_&zbior..*;

%mend stworz2;

/* %stworz2(z7); */






data _null_;
 set abc;
 call symput('nazwa',nazwa);
 CALL EXECUTE('%stworz2(&nazwa)');
run;












data _null_;
 set abc;
 call symput('nazwa',nazwa);
 rc = DOSUBL('%stworz2(&nazwa)');
 putlog "#############" rc= "#############";
run;














data abc1 abc2; /*pomocniczy zb SASowy*/
 input nazwa $ :32000.;
 cards;
a13t17
bb8
c3r7
best32
k2
r2d2
c3po
atat
;
run;




data _null_;
set abc1 end=EOF;
retain lmax 0;
l = LENGTH(nazwa); /* LENGTHN ? */
lmax = lmax<>l;
if eof then 
CALL EXECUTE(
"data abc1(rename = (nazwa_X=nazwa)); 
 length nazwa_X $ " !! put(lmax,best32.) !! "; 
 set abc1; 
 nazwa_X = nazwa; 
 drop nazwa; 
 run;"
);
run;








data _null_;
set abc2 end=EOF;
retain lmax 0;
l = lengthn(nazwa);
lmax = lmax<>l;
if eof then 
rc = DOSUBL(
"data abc2(rename = (nazwa_X=nazwa)); 
 length nazwa_X $ " !! put(lmax,best32.) !! "; 
 set abc2; 
 nazwa_X = nazwa; 
 drop nazwa; 
 run;"
);
run;








/* LEKTURA Z WYKLADU */
/* jeszcze szybkie podsumowanie o kolejnosci wykonywania */
/*
    data _null_;
        call symputx('ABC', 12);
    run;
    data ZBIOREK;
     do i = 1 to &abc;
        j = ranuni(&abc);
        output;
     end;
    run;
    proc sort data = ZBIOREK;
        by j;
    run;
*/

options nomlogic nomprint nosymbolgen;
dm log 'clear';
%macro uwaga_na_kolejnosc();

%put NOTE-*1]* Data step _NULL_;

    data _null_;
put "NOTE-*2)* Call SymputX generuje makrozmienna ABC";
        call symputx('ABC', 12);
    run;

%put NOTE-*3]* Kod Data stepu generujacego Zbiorek gotowy do kompilacji;

    data ZBIOREK;
%put NOTE-*4]* Kompilujemy Kod Data stepu generujacego Zbiorek;
%put NOTE-*5]* Uzyjemy makroamiennej ABC o wartosci &ABC;
put "NOTE-*6)* Krece pentla w data stepie i wykonuje kod";
     do i = 1 to &abc;
        j = ranuni(&abc);
        output;
     end;
    run;
    proc sort data = ZBIOREK;
        by j;
    run;

%mend uwaga_na_kolejnosc;

%symdel ABC / nowarn;
%put ########################################################;


/* wywolanie standardowe: */
%uwaga_na_kolejnosc()






%symdel ABC / nowarn;
%put ########################################################;

/* wywolanie w call execute: */
data _null_;
 CALL EXECUTE('%uwaga_na_kolejnosc()');
run;






%symdel ABC / nowarn;
%put ########################################################;

/* wywolanie w call execute: */
data _null_;
 rc = DOSUBL('%uwaga_na_kolejnosc()');
run;


/* end of lecture 4 */ /*1702*/











/* uzywanie wczesniej przygotowanych makrokodow  */
filename nazwa 'C:\SAS_WORK\MAKRA\mkr_a.sas';
%include nazwa;
%mkr_a(113);










options MAUTOSOURCE; /* opcja aktywuje szukanie makr uzytkownika */

options SASAUTOS = (sasautos 'C:\SAS_WORK\MAKRA'); 
/* tutaj pokazujemy gdzie szukac 
   sasautos to automatyczna referencja do lokalizacji automatycznych makr SASa
*/











LIBNAME makra BASE "C:\SAS_WORK\MAKRA";

options 
MSTORED             /* opcja aktywuje szukanie skompilowanych makr uzytkownika */
SASMSTORE = makra   /* tutaj pokazujemy gdzie szukac skompilowanych makr */
;







/* maskowanie kodu makra - SECURE */

%macro open_source() / store; /* Makro zapisane otwartym tekstem */
  data open_source;
    x = 1;
    y = 2;
    z = x + y;
    put "To makro jest open source'owe - jawny kod = bezpieczn[iejsz]y) kod :-)";
    put _all_;
  run;
%mend open_source;





%macro no_open_source() / store SECURE; /* Makro zapisane zakodowanym tekstem */
  data no_open_source;
    x = 3;
    y = 4;
    z = x + y;
    put "To makro nie jest open source'owe - ukryty kod, to zly kod :-( "; 
    put "No chyba, ze nie chca mi zaplacic za open source ;-P";
    put _all_;
  run;
%mend no_open_source;





options mlogic mprint symbolgen;
dm log 'clear';
%open_source()
%no_open_source()




/* wydrukujmy kody makr */
filename os catalog 'makra.sasmacr.open_source.macro';
data _null_;
  infile os;
  input;
  put _INFILE_;
run;


filename nos catalog 'makra.sasmacr.no_open_source.macro';
data _null_;
  infile nos;
  input;
  put _INFILE_;
run;






options nomlogic nomprint nosymbolgen;



/* MINOPERATOR i MINDELIMITER  */
/*
parametr WZOR decyduje czy zmienna to tekst czy liczba
parametr DLUG to dlugosc zminnej
parametr POCZ to wartosc poczatkowa zmiennej
*/
%macro inicjuj(wzor,dlug,pocz) / /* <- opcje:*/
MINOPERATOR                      /* zezwala na prace z operatorem IN w warunkach, domyslnie rozdziela spacja */
MINDELIMITER=','                 /* pozwala zmienic rozdzielacz, UWAGA! znaki: %  &  '  "  (  )  ; sa zakazane*/
; 

 %if %upcase(&wzor) IN (TEKST,T,TEXT) %then /* <- makrofunkcja %UPCASE zamiena wszystkie literki na wielkie */
  %do;

   data a;
    length zmienna $ %sysfunc(min(%sysfunc(max(&dlug,1)),32767));
    zmienna="&pocz";
   run;

  %end;
 %else 
  %if %upcase(&wzor) in (LICZBA,L) %then
   %do;

    data a;
     length zmienna %sysfunc(min(%sysfunc(max(&dlug,3)),8));
     zmienna=&pocz;
    run;

   %end;
  %else %do; %put NOTE:[BJ] ***********************; 
             %put NOTE-[BJ] *nie rozpoznano wzorca*; 
             %put NOTE-[BJ] ***********************;
        %end;
%mend inicjuj;

%inicjuj(TekST,1,A)
%inicjuj(liCZBA,3,5)
%inicjuj(kaLAfiOR,3,5)
%inicjuj(T,54321,54321)








/* opcja PARMBUFF i makrozmienna &SYSPBUFF. */

%macro test_PARMBUFF(testowy1, testowy2, testowy3=a3, testowy4=b4) / PARMBUFF;

    %put $$&SYSPBUFF.$$;
    %put ##&testowy1.##;
    %put ##&testowy2.##;
    %put ##&testowy3.##;
    %put ##&testowy4.##;

%mend test_PARMBUFF;





%test_PARMBUFF(d1,d2,d3,d4,d5,d6,f7,testowy3=d0);














%macro czy_Kazik_jest_na_liscie(a=) /
PARMBUFF MINOPERATOR MINDELIMITER=',' SECURE
; 
%if KAZIK in %upcase(&SYSPBUFF.) %then
 %do;
  %put WARNING:[!] Uwaga! Kazik jest na liscie, wiejemy!;
 %end;
%else
 %do;
  %put NOTE:[+] Kazika nie ma na liscie, jestesmy bezpieczni!;
 %end;

%mend czy_Kazik_jest_na_liscie;


/* Rysiek, Zdzisiek, Roman, Krzysiek, Stasiek, Kazik, Franek */

%czy_Kazik_jest_na_liscie(Rysiek, Zdzisiek, Roman);

%czy_Kazik_jest_na_liscie(Rysiek, Zdzisiek, Roman, Krzysiek, Stasiek, Kazik, Franek);

%czy_Kazik_jest_na_liscie( Roman, Krzysiek, Kazik, Franek);

%czy_Kazik_jest_na_liscie(Rysiek, Zdzisiek, Roman, Krzysiek, Stasiek, Kazik, Franek, Mariola, Zofja);



dm log 'clear';
options nomlogic nomprint nosymbolgen;



%put NOTE-[-] Jestem &sysuserid;

%put NOTE-[-] Mam SASa w wersji: &sysvlong4;





data _null_;
set &nie_ma_takiego.;
run;



%put NOTE-[-] Kod ostatniego ERRORa to: &syserr;
%put NOTE-[-] Tekst ostatniego ERRORa to: %SUPERQ(syserrortext);

%put NOTE-[-] Tekst ostatniego WARNINGa to: %SUPERQ(syswarningtext);





%macro runn();
run;
%if &SYSERR. %then %do; %abort cancel; %end; data _null_; run; %put **&SYSERR.**;
%mend runn;


data x;
x=1;
outputx;
x=2;
output;
%runn;

proc sql;
create table a as 
select *
from x
;
create table b as
select *
from x
;
create table c as
select *
from x
;
create table d as
select *
from x
;
create table e as
select *
from x
;
quit;
%runn;


data x;
x=1;
output;
x=2;
output;
%runn;

proc sql noprint;
create table a as 
select *
from x
;
create table b as
select *
from x
;
create table c as
select *
from x
;
create table d as
select *
from x
;
create table e as
select *
from x
;
quit;
%runn;





/* lista kodow jest w helpie */



options IMPLMAC mprint;
%macro run_2() / STMT;
run;
%if &SYSERR. %then %do; %abort cancel; %end; data _null_; run; %put **&SYSERR.**;
%mend run_2;



data x;
x=1;
output;
x=2;
output;
run_2;


options NOIMPLMAC nomprint;









/* dygresja o komentowaniu kodu */

data a;
napis=17; *komentarz na tema liczby 17;
output;
/*
nie wykonuj tego kodu...
napis=3*napis;
*/

%macro abc();
x= 4+napis;

%* makro komentator - Dariusz Szpakowski ;
%mend abc;

%abc;

run;



















data a;
napis=17; *komentarz na tema liczby 17;
output;

%macro never_execute();

/*
nie wykonuj tego kodu...
napis=3*napis; 
*/

%macro abc();
x= 4+napis;
%* makro komentator - Dariusz Szpakowski ;
%mend abc;

%abc;
%mend never_execute;
%macro never_execute();
%put NOTE:[!] Nie widzisz jak sie nazywam?! "Never_execute"!! To po co uruchamiasz?!;
%mend never_execute;


run;

/*
%mend never_execute;
%macro never_execute();
%put NOTE:[!] Nie widzisz jak sie nazywam?! "Never_execute"!! To po co uruchamiasz?!;
%mend never_execute;
*/












%never_execute;












%put NOTE-[-] Moj system to &SYSSCP., a dokladniej: &SYSSCPL.;








%put NOTE-[-] Nazwa trybu pracy procesu: &SYSPROCESSNAME;
/* jak jest kilka uruchumionych to: "DMS Process (n)" */ 
/* EG: 'Object Server' */
/* BATCH: 'Program "/sciezka/do/lokalizacji/kodu.sas"' */











%put NOTE-[-] Nazwa trybu pracy sesji: &SYSPROCESSMODE;

/* mozliwe opcje:
SAS DMS Session
SAS Batch Mode
SAS Line Mode
SAS/CONNECT Session 
SAS Share Server
SAS IntrNet Server
SAS Workspace Server
SAS Pooled Workspace Server
SAS Stored Process Server
SAS OLAP Server
SAS Table Server
SAS Metadata Server
*/






%put NOTE-[-] Liczba rdzeni: &SYSNCPU;





libname BIBLIOTE "C:\NIE\MA\MNIE";
%put *&SYSLIBRC.*;

libname BIBLIOTE "%sysfunc(getoption(work))";
%put *&SYSLIBRC.*;










data BIBLIOTE.DLUGA_32ZNAKOWA_NAZWA_ZBOIRU_SAS;
a=0;
run;
%put NOTE-[-] ostatnio utworzony zbior w posatci ciaglej: ;
%put NOTE-[-] *+--------1+--------2+--------3+--------4*;
%put NOTE-[-] *&SYSDSN*;
%put NOTE-[-] ostatnio utworzony zbior w posatci z kropka;
%put NOTE-[-] *&SYSLAST*;






data _null_;
a=0;
run;
%put NOTE-[-] *+--------1+--------2+--------3+--------4*;
%put NOTE-[-] *&SYSDSN*;
%put NOTE-[-] *&SYSLAST*;





proc sql;
create table BIBLIOTE.INNA_31ZNAKOWA_NAZWA_ZBOIRU_SAS as
select * 
from BIBLIOTE.DLUGA_32ZNAKOWA_NAZWA_ZBOIRU_SAS
;
quit;
%put NOTE-[-] *+--------1+--------2+--------3+--------4*;
%put NOTE-[-] *&SYSDSN*;
%put NOTE-[-] *&SYSLAST*;









proc sql;
create table INNA_NAZWA_ZBOIRU_SAS as
select * 
from BIBLIOTE.DLUGA_32ZNAKOWA_NAZWA_ZBOIRU_SAS
;
quit;
%put NOTE-[-] *+--------1+--------2+--------3+--------4*;
%put NOTE-[-] *&SYSDSN*;
%put NOTE-[-] *&SYSLAST*;








options NOSOURCE; /* kod przestaje byc wyswietlany wlogu */
options NONOTES; /* notatki nie sa wyswietlane w logu */
options NOSOURCE2; /* kod ze zrodel typu: %include... nie jest wyswietlany wlogu */
options ERRORS=3; /* ogranicza liste wypisywanych pledow danego typu */


options NOTES;




data test;
infile cards;
input triplet 8.; /* <- zapomniany $ */
cards;
aaa
bbb
ccc
ddd
eee
fff
ggg
hhh
iii
;
run;










options SOURCE; 
options NOTES; 
options SOURCE2;
options ERRORS=20;






%put NOTE-[-] *&SYSINDEX*;

%macro a1;
%put NOTE-[-] A1 *&SYSINDEX*;
%mend a1;
%macro a2;
%put NOTE-[-] A2 *&SYSINDEX*;
%mend a2;
%macro a3;
%put NOTE-[-] A3 *&SYSINDEX*;
3
%mend a3;


%a1

%a2;

%let trzy = %a3;



data test1;
do j = 1 to 13;
 put j=; 
 call execute('%a1');
 rc1 = dosubl('%a2'); 
 rc2 = resolve('%a3');
 output;
end;
run;







/* kto sie domysla dlaczego w %a2 ciagle jest 1? */









data test2;
do j = 1 to 13;
 put j=; 
 call execute('%a1');
 rc1 = dosubl('%a1;%a2;%let t=%a3; %put NOTE:[%a3] &t;');
 rc2 = resolve('%a3');
 output;
end;
run;








filename PLIK "C:\NIE\MA\MNIE";
%put *&SYSFILRC.*;

filename PLIK "%sysfunc(getoption(work))";
%put *&SYSFILRC.*;






/* drobna dygresja o FILENAME statement */


data _null_;
file plik("prawdziwy_plik.txt");
put "1" / "2" / "3" / "4";
run;


data _null_;
file plik("prawdziwy_plik2.txt");
put "1" ;
run;



%put Kodowanie sesji: &SYSENCODING;




%put NOTE-[-] Dzien i data rozpoczecia sesji: &sysday,  &sysdate9. o godzinie &systime.; 
/* uwaga jak sesja trwa X dni to jest to data rozpoczecia */









data x;
x=42;
run;
proc sql;
select * from x;
quit;


/* PROC PRINTTO */
proc printto;
run;


 
proc printto 
print = "C:\SAS_WORK\PRINTTO_OUTPUT.TXT"
log = "C:\SAS_WORK\PRINTTO_LOG.TXT"
NEW
;
run;




%put **%superq(SYSPRINTTOLIST)**;
%put **%superq(SYSPRINTTOLOG)**;


data x;
a=1; output;
a=2; output;
a=3; output;
a=4; output;
a=5; output;
a=6; output;
run;

proc sql;
select sum(a) as sum_a
, avg(a) as avg_a
from
x
;
quit;






proc printto print = print log = log;
run;








proc printto;
run;







data tajny(pw=admin1);
a=1; output;
a=2; output;
a=3; output;
a=4; output;
a=5; output;
a=6; output;
run;

data tajny2(pw=XX);
a=1; output;
a=2; output;
a=3; output;
a=4; output;
a=5; output;
a=6; output;
run;








%macro TajnePrzezPoufne(PPP);
/*%put **&ppp.**;*/

data odszyfrowany;
set tajny(pw = &ppp.);
b=2**a;
drop a;
run;

%mend TajnePrzezPoufne;

%TajnePrzezPoufne(admin1)






/* DUMMY */
FILENAME proznia DUMMY; 
proc printto log = proznia; 
run;

%TajnePrzezPoufne(admin1)

proc printto;
run;

data test1;
x=1;
run;






/* end of lecture 5 *//*2565*/

/* dodatek */
/* gdzie przechowywana jest makrozmienna? w ktorej tablicy? */

/* CALL SYMPUT tworzy zmienna w najbardziej lokalnej _niepustej_ tabeli makrozmiennych */

%macro test1_CallSymput();

data _null_;
    call symput('test1', 'Gdzie mnie wsadzi Call Symput ? v1');
run;

%put **********;
%put _local_;
%put **********;


%mend test1_CallSymput;

%test1_CallSymput()

%put ##########;
%put _user_;
%put ##########;









%macro test2_CallSymput();

%let dummy_x=2;

data _null_;
    call symput('test2', 'Gdzie mnie wsadzi Call Symput ? v2');
run;

%put **********;
%put _local_;
%put **********;


%mend test2_CallSymput;

%test2_CallSymput()

%put ##########;
%put _user_;
%put ##########;







%macro test3_CallSymput(dummy_x);

data _null_;
    call symput('test3', 'Gdzie mnie wsadzi Call Symput ? v3');
run;

%put **********;
%put _local_;
%put **********;


%mend test3_CallSymput;

%test3_CallSymput(3)

%put ##########;
%put _user_;
%put ##########;







%macro test3_CallSymput(dummy_x=3.5);

data _null_;
    call symput('test3_5', 'Gdzie mnie wsadzi Call Symput ? v3.5');
run;

%put **********;
%put _local_;
%put **********;


%mend test3_CallSymput;

%test3_CallSymput()

%put ##########;
%put _user_;
%put ##########;








/* jak wymusic wypchniecie makrozmiennej do zakresu globalnego? */



%macro test4_CallSymputX(x=17);

data _null_;
    call SYMPUTX('test4', 'Gdzie mnie wsadzi Call SymputX ? v4', 'G');
run;

%put **********;
%put _local_;
%put **********;


%mend test4_CallSymputX;

%test4_CallSymputX()

%put ##########;
%put _user_;
%put ##########;









/* jeszcze jedna drobna obserwacja */


%macro test5_CallSymputX();

data _null_;
    call SYMPUTX('test5', 12345, 'G');
run;

data _null_;
    call SYMPUT('test6', 12345);
run;

%put **********;
%put _local_;
%put **********;


%mend test5_CallSymputX;


%test5_CallSymputX();

%put ##########;
%put _user_;
%put ##########;




/* call SymputX konwertuje liczy formatem BEST. i nie wypisuje warning'a */







/* pusta tablica lokalna */

/* wyjatek 1 - po uzyciu procedury SQL */

%macro test7_CallSymput(); 

data _null_;
    call symput('test7', 'Gdzie mnie wsadzi Call Symput ? v7'); /* przed SQL */
run;

PROC SQL;
QUIT;

data _null_;
    call symput('test8', 'Gdzie mnie wsadzi Call Symput ? v8'); /* po SQL */
run;

%put **********;
%put _local_;
%put **********;

%mend test7_CallSymput;

%test7_CallSymput()

%put ##########;
%put _user_;
%put ##########;








/* wyjatek 2 - uzywamy pocji PARMBUFF i makrozmiennej &SYSPBUFF. */

%let test10=jestem w globalnej tablicy;

%macro test9_CallSymput() / PARMBUFF; /* <- bufor parametrow pozwala na budowanie 
                                            makr ze zmienna iloscia parametrow */

data _null_;
    call symput('test9', 'Gdzie mnie wsadzi Call Symput ? v9'); 
run;

%put $$&SYSPBUFF.$$; /* makrozmienna przechowujaca liste podanych do makra parametrow */

data _null_;
    call symput('test10', 'Gdzie mnie wsadzi Call Symput ? v10'); /* zmienna juz istniejaca w zakresie wyzej */
run;

%put **********;
%put _local_;
%put **********;

%mend test9_CallSymput;

%test9_CallSymput(parametr1,parametr2,parametr3,parametr4)

%put ##########;
%put _user_;
%put ##########;










/* wyjatek 3 - %GOTO &LABEL */

%let labelka=OminMnie;
%let test12=ja tez jestem w globalnej tablicy;

%macro test11_CallSymput(); 

data _null_;
    call symput('test11', 'Gdzie mnie wsadzi Call Symput ? v11'); 
run;

%if %eval(2+2 = 4) %then %GOTO &labelka; /* <- computed %GOTO - etykieta powstaje z makra(%) lub makrozmiennej(&)*/

data kawalek_do_ominiecia;
    x = "To skip or not to skip? That is the question!";
run;


%OminMnie:
;

data _null_;
    call symput('test12', 'Gdzie mnie wsadzi Call Symput ? v12'); 
run;

%put **********;
%put _local_;
%put **********;

%mend test11_CallSymput;

%test11_CallSymput()

%put ##########;
%put _user_;
%put ##########;

/*dodatek*/

/* end of lecture 5 *//*2565*/






/* TEMP */

data pacjenci;
infile cards;
input pacjent_id waga wzrost;
cards;
123 76 172
322 133 198
142 121 165
541 90 186
654 56 170
177 65 170
623 73 180
run;






data programy;
length id 8 in out kod $ 200;
id = 1;
out = "data ";
in = "; set ";
kod = "; where waga > 120; bmi = waga / ((wzrost/100)**2); run;";
output;

id = 2;
out = "proc sort out = ";
in = "  data =";
kod = "; by wzrost waga; run;";
output;

id = 3;
out = "proc sql; create table ";
in = " as select pacjent_id from ";
kod = " having waga < avg(waga); quit;";
output;

run;







%macro programy(id, in, out);

filename kodzik TEMP;

data _null_;
 file kodzik;
 set programy;
 where id = &id;
  put out;
  put "&out.";
  put in;
  put "&in.";
  put kod;
run;


%include kodzik / source2;

filename kodzik;

%mend programy;

%programy(1,pacjenci,d1)


%programy(2,pacjenci,d2)


%programy(3,pacjenci,d3)








/* RESOLVE - ciekawostka */
data test;
length x y 8 kod $ 50;
kod = '(x > 1)';                  x= 3; y=11; output;
kod = '(x < 1 and (9 < y < 13))'; x=-3; y=11; output;
kod = '(z > 1)';                  x= 3; y=11; output;
kod = '(y < 1)';                  x= 3; y=-1; output;
run;
















data test;
length x y 8 kod $ 50;
kod = '(&x > 1)';                   x= 3; y=11.0; output;
kod = '(&x < 1 and (9 < &y < 13))'; x=-3; y=11; output;
kod = '(&x < 1)';                   x= 3; y=11; output;
kod = '(&y < 1)';                   x= 3; y=-1; output;
run;

options symbolgen;
data test2;
set test;


call symputx("X",put(X,best32.),"G");
call symputx("Y",put(Y,best32.),"G");

_rc_ = resolve('%put _user_;');

length wynik $ 50;
wynik = resolve('%sysevalf(' || kod ||')');

if input(resolve('%sysevalf(' || kod ||')'), best32.)
then sprawdzenie1=1;
else sprawdzenie1=0;

a = symget("X");
b = symget("Y");
put _ALL_;
run;












data testa;
length x y 8 kod $ 50;
kod = '(x > 1)';                        x= 3; y=11; output;
kod = '(x < 1 and (9 < y < 13))';       x=-3; y=11; output;
kod = '(x < 1)';                        x= 3; y=11; output;
kod = '(y < 1)';                        x= 3; y=-1; output;
run;


data testa2;
set testa;

length kodeval $ 2000;

array VARSn _NUMERIC_;


kodeval = kod;
do over VARSn;
 kodeval = TRANWRD(kodeval, vname(VARSn), strip(put(VARSn,best32.)));
end;

if input(resolve('%sysevalf(' || strip(kodeval) ||',BOOLEAN)'), best32.)
then sprawdzenie1=1;
else sprawdzenie1=0;
run;










data testb;
length x y 8 kod $ 50;
kod = '(x > 1)';                  x= 3; y=11; output;
kod = '(x < 1 and (9 < y < 13))'; x=-3; y=11; output;
kod = '(x < 1)';                  x= 3; y=11; output;
kod = '(y < 1)';                  x= 3; y=-1; output;
run;





proc sql;
create table kody_b as select distinct QUOTE(strip(kod)) as q from testb;
quit;





filename testb2 TEMP lrecl=2000;

data _null_;
file testb2;
set kody_b end=EOF;
length _X_ $ 2000;

if _N_ = 1 then
do;
 put "data testb2;";
 put "set testb;";
 put "select;";
end;

_X_ = "when (kod = " || strip(q) || ") do; if (" || dequote(q) || ") then sprawdzenie1=1; else sprawdzenie1=0; end;";
put _X_;


if EOF = 1 then
do;
 put "otherwise;";
 put "end;";
 put "run;";
end;

run;


%include testb2 / SOURCE2;

filename testb2;






data testc;
length x y 8 c $ 10 kod $ 50;
kod = '(x > 1) and c=''A''';            x= 3; y=11; c="A"; output;
kod = '(x < 1 and (9 < y < 13))';       x=-3; y=11; c="B"; output;
kod = '(x < 1) or C in ("C","D","E")';  x= 3; y=11; c="C"; output;
kod = '(y < 1)';                        x= 3; y=11; c="D"; output;
run;




proc sql;
create table kody_c as select distinct QUOTE(strip(kod)) as q from testc;
quit;




filename testc2 TEMP lrecl=2000;

data _null_;
file testc2;
set kody_c end=EOF;
length _X_ $ 2000;

if _N_ = 1 then
do;
 put "proc sql;";
 put "create table testc2 as";
 put "select * ";
 put "from testc";
 put "where case";

end;

_X_ = "when (kod = " || strip(q) || ") and (" || dequote(q) || ") then 1";
put _X_;


if EOF = 1 then
do;
 put "else 0 end = 1";
 put ";";
 put "quit;";
end;

run;


%include testc2 / SOURCE2;

filename testc2 clear;














/*********************************************************************************************
Zasoby:
- przestrzen na dysku

- pamiec - nietrwala

- CPU - czas procesora, obliczenia, czytanie i zapisywanie danych, iteracje, logika warunkowa

- I/O - dyski, pamiec stala, 
            input  - czytanie z dysku do pamieci,  
            output - pisanie z pamieci na dysk, na monitor lub inne urzadzenie wyjscia

- network bandwidth - komunikacja miedzy maszynami
*********************************************************************************************/

/* jak sobis z tym radzic? */


/*
monitorowanie pracy prgramu - "benchmarking"
*/
/* formalnie nalezy sprawdzac statystyki po pare razy i usredniac */
/* kazde wykonanie wywolywac w nowej sesji SAS-a */

%debugging();
options DETAILS;


OPTIONS STIMER;

data x;
 y=1; output;
 y=9; output;
 y=6; output;
 y=3; output;
run;
proc sort data = x;
 by y;
run;

OPTIONS FULLSTIMER;

data z;
 y=1; output;
 y=9; output;
 y=6; output;
 y=3; output;
run;
proc sort data = z;
 by y;
run;





/* buffers */
options BUFSIZE=0; 
data a;
 do i = 1 to 100;
  y = i * 3; output;
 end;
run;
proc contents data = a 
;
run;


options BUFSIZE=4k; 
data b;
 do i = 1 to 100;
  y = i * 3; output;
 end;
run;
proc contents data = b 
;
run;


options BUFSIZE=1M; 
data c;
 do i = 1 to 100;
  y = i * 3; output;
 end;
run;
proc contents data = c 
;
run;


options BUFSIZE=0; 










/* buffers */
options BUFSIZE=0;
data IO_SAS_LONG;
array XXX[50] x1-x50;
do i=1 to 1E6;
 do j=1 to dim(XXX); drop j;
  XXX[j] = round(ranuni(10000),0.0001);
 end;
 output;
end;
run;

data _null_;
set IO_SAS_LONG;
array XXX[50] x1-x50;
y=sum(of XXX[*]);
run;

ODS EXCLUDE  Contents.DataSet.Variables; /* <- o tym innym razem */
proc contents data = IO_SAS_LONG 
;
run;




options BUFSIZE=16k;
data IO_SAS_LONG2;
array XXX[50] x1-x50;
do i=1 to 1E6;
 do j=1 to dim(XXX); drop j;
  XXX[j] = round(ranuni(10000),0.0001);
 end;
 output;
end;
run;

data _null_;
set IO_SAS_LONG2;
array XXX[50] x1-x50;
y=sum(of XXX[*]);
run;

ODS EXCLUDE  Contents.DataSet.Variables;
proc contents data = IO_SAS_LONG2 
;
run;




options BUFSIZE=1M;
data IO_SAS_LONG3;
array XXX[50] x1-x50;
do i=1 to 1E6;
 do j=1 to dim(XXX); drop j;
  XXX[j] = round(ranuni(10000),0.0001);
 end;
 output;
end;
run;

data _null_;
set IO_SAS_LONG3;
array XXX[50] x1-x50;
y=sum(of XXX[*]);
run;

ODS EXCLUDE  Contents.DataSet.Variables;
proc contents data = IO_SAS_LONG3 
;
run;




%MACRO lista(set,n);
%do i=1 %to &n.; &set.&i. %end;
%MEND lista;

options DLCREATEDIR;
libname x BASE "%sysfunc(GETOPTION(work))\local";

/* buffers */
options BUFSIZE=0; 
data 
%lista(x.a,100)
;
 do i = 1 to 100;
  y = i * 3; output;
 end;
run;



options BUFSIZE=4k; 
data 
%lista(x.b,100)
;
 do i = 1 to 100;
  y = i * 3; output;
 end;
run;



options BUFSIZE=1M; 
data 
%lista(x.c,100)
;
 do i = 1 to 100;
  y = i * 3; output;
 end;
run;











/* przywraca ustawienia systemowe*/
options BUFSIZE=0; /*BUFFNO=0;*/



/************* redukcja I/O ****************/

options BUFSIZE=0;
data IO_SAS_LONG;
array XXX[50000] x1-x50000;
do i=1 to 1E3;
 do j=1 to dim(XXX); drop j;
  XXX[j] = round(ranuni(10000),0.0001);
 end;
 output;
end;
run;


/*1. ograniczenie liczby obserwacji i zmiennych - DROP, KEEP, WHERE, OBS, FIRSTOBS*/

/* - KEEP przy data*/

data IO_DATA_KEEP(keep = i x13);
 set IO_SAS_LONG;
run;




/* - KEEP wewnatrz datastepu */

data IO_DATASTEP_KEEP;
 set IO_SAS_LONG;
 keep i x13;
run;






/* - KEEP przy set */

data IO_SET_KEEP;
 set IO_SAS_LONG(keep = i x13);
run;
/* zysk miedzy buforami a PDV */

/* end of lecture 6 */ /* line 3156 */
/*dodatek */
/*
"A teraz cos z zupelnie innej beczki" - M.Python
*/

/*
MacroQuoting polega na zastapieniu w napisach przekazywanych 
przez makrozmienne znakow specjalnych typu:
; & % ' " ( ) + - * / < > ^ = | , ~ 
przez tak zwane Delat characters, czyli specjalne niedrukowalne 
znaki z tablicy ASCII, ktorych nie uzywany przy pisaniu kodu.

%STR() - funkcja maskuje na etapie kompilacji makra.
%NRSTR() - maskuje dodatkowo % i &. NR ~ Not Resolve.

*/

/* makrozmienna xyz nie istnieje */

%macro a(abc);

%put *&abc.*;

%mend a;

%a(%str(&xyz.))

%a(%NRstr(&xyz.))


options symbolgen mlogic;


/* ustalenie separatorow przy pracy z makrofunkcja %SCAN */

/* That's Tom's book, use it if you need. */

%let text=%str(That%'s)%str( Tom%'s book, use it if you need.);
%put NOTE:*&text*;
/*%put **;*/


%put NOTE:*%scan(&text.,3,' ')*;
%put **;

%put NOTE:*%scan(&text.,3,%str( ))*;
%put **;

%put NOTE:*%scan(&text.,3,%str(%'))*;
%put **;



/*
%BQUOTE - funkcja maskuje na etapie wykonywania. To "starszy" brat %quote, 
          radzi sobie z pojedynczymi nawiasami czy sudzyslowami.
%NRBQUOTE() - maskuje dodatkowo % i &. NR ~ Not Resolve.
*/

/* makrozmienna xyz nie istnieje */

%macro b(abc);

%put *&abc.*;

%mend b;

%b(%bquote(&xyz.))

%b(%NRbquote(&xyz.))



%let text2=%bquote(That's Tom's book, use it if you need.);
%put NOTE:*&text2*;
%put **;


%put NOTE:*%scan(&text2.,3,%str( ))*;
%put **;

%put NOTE:*%scan(&text2.,3,%str(%'))*;
%put **;

%put NOTE:*%scan(&text2.,3,%str(, ))*; /* <- dwa "rozdzielacze" */
%put **;





%let text3=%nrstr(&text2.);
%put NOTE:*&text3*;
%put **;

%let text4=%nrbquote(&text2.);
%put NOTE:*&text4*;
%put **;







data _null_;
call symputx('czasownik'
, '&blablabla'
, 'G');
call symputx('blablabla'
, 'USE'
, 'G');
run;

%put _user_;

%let text5=%bquote(That's Tom's book, &czasownik. it if you need.);
%put NOTE:*&text5*;
%put **;



%let text6=%nrbquote(That's Tom's book, &czasownik. it if you need.);
%put NOTE:*&text6*;
%put **;

%let text7=%nrbquote(&text6.);
%put NOTE:*&text6*;
%put **;



/* czas kompilacji a czas wykonania */

%macro parametr_bquote(parametr);

%IF %BQUOTE(&parametr) eq %then %put *Nie ma parametru*; /* <- w czasie wykonywania wartosc 
                                                               makrozmiennej jest maskowana */
                          %else %put *Prametr:&parametr.*;
%put _local_;
%mend parametr_bquote;


%parametr_bquote()
%parametr_bquote(slodko-gozki)
%parametr_bquote(^!@)
%parametr_bquote(or)


%macro parametr_str(parametr); 

%IF %STR(&parametr) eq %then %put *Nie ma parametru*; /* <- w czasie wykonywania wartosc 
                                                            makrozmiennej nie jest maskowana */
                       %else %put *Prametr:&parametr.*;
%put _local_;
%mend parametr_str;

%parametr_str()
%parametr_str(slodko-gozki)
%parametr_str(^!@)
%parametr_str(or)


/* %unquote - zdejmujemy Delta zank i dosatjemu "czysta" wartosc makrozmiennej */

%let czasownik=use;
%let text8=%str(That%'s)%str( Tom%'s book,)%nrstr( &czasownik. it if you need.);
%put NOTE:*&text8*;
%put **;

%let text9=%nrbquote(&text8.);
%put NOTE:*&text9*;
%put **;


%put NOTE:*%unquote(&text9.)*;
%put **;

%put _user_;



%let czasownik=use;
%let text8=%str(That%'s)%str( Tom%'s book,)%nrstr( &czasownik. it if you need.);
%put NOTE:*&text8*;
%put **;

%let text9=%nrstr(&text8.);
%put NOTE:*&text9*;
%put **;


%put NOTE:*%unquote(&text9.)*;
%put **;

%put _user_;


/* %superq - dziala w czasie wykonywania */

data _null_;
call symputx('text10'
, 'jakas dziwna makrozmienna, %macroprogram() ma i &makrozmienne w srodku, srednik; i jakies przecinki,,,,, dziwna...'
, 'G');
run;

%put NOTE:*&text10*;

%let text11=%superq(text10);
%put NOTE:*&text11*;
%put **;

%put _USER_;

/*dodatek */

/* end of lecture 6 */ /* line 3156 */




options FULLSTIMER MSGLEVEL=I;

/*  - WHERE vs SUBSETTING IF */
options BUFSIZE=0;
data IO_SAS_LONG;
array XXX[50] x1-x50;
do i=1 to 1E7;
 do j=1 to dim(XXX); drop j;
  XXX[j] = round(ranuni(10000),0.0001);
 end;
 output;
end;
run;





data IO_SUBSETTING_IF;
 set IO_SAS_LONG;
 if not mod(i,13579);
run;




data IO_WHERE;
 set IO_SAS_LONG;
 where not mod(i,13579);
run;




data IO_WHERE;
 set IO_SAS_LONG(where = (not mod(i,13579)));
run;





data IO_WHERE;
 set IO_SAS_LONG(where = (not mod(i,13579)));
  where not mod(i,13578);
run;




data IO_WHERE;
 set IO_SAS_LONG;
  where not mod(i,13579);
  where not mod(i,13578);
run;






/* 2. tworzenie zbioru sasowego, zeby nie czytac wielokrotnie danych surowych */

/* I/O przy czytaniu pliku txt i sas */

filename IO_FLAT "%sysfunc(getoption(work))\IO_FLAT.TXT";
data IO_SAS;
file IO_FLAT;

array XXX[5000] x1-x5000;
do i=1 to 1E4;
 do j=1 to dim(XXX); drop j;
  XXX[j] = round(ranuni(10000),0.0001);
 end;
 output; put i XXX[*];
end;

run;
ODS EXCLUDE  Contents.DataSet.Variables;
proc contents data = IO_SAS;
run;


data t1;
 length i x: 8;
 set IO_SAS;
run;

data t2;
 infile IO_flat;
 input i x1 - x5000;
run;





/*
READING RAW DATA 
input raw data 
 -> (caches) 
  -> I/O measured here 
   -> memory buffers 
    -> input buffer 
     -> (konwersja zmiennych do formatu SAS-owego) PDV 
   -> memory buffers 
  -> (caches) 
 -> I/O measured here 
-> output SAS data

READING SAS DATA (nie ma potrzeby konwersji)
input raw data 
 -> (caches) 
  -> I/O measured here 
   -> memory buffers (page size) 
    -> PDV 
   -> memory buffers 
  -> (caches) 
 -> I/O measured here
-> output SAS data
*/









/* 3. data view - widok, perspektywa */

/* data view - na dysku trzymany jest kod programu 
               generujacy dane zamiast zbioru danych */
/* gdy w data lub proc stepie odwolamy sie do view, 
   najpierw wykona sie "pod spodem" jego kod         */


/*** tworzenie ***/

data A_VIEW(label="A view is light") / VIEW = A_VIEW;
  set IO_SAS_LONG(keep = i x1-x20);
  where not mod(i,3);
  label i = "Variable from a view";
run;



data A_SET(label="A view is heavy");
  set IO_SAS_LONG(keep = i x1-x20);
  where not mod(i,3);
  label i = "Variable from a set";
run;



data B_FORM_SET;
 set A_SET;
 array xxx[*] x:;
 y=sum(of XXX[*]);
 keep i y;
run;



data B_FORM_VIEW;
 set A_VIEW;
 array xxx[*] x:;
 y=sum(of XXX[*]);
 keep i y;
run;




data A_VIEW(label="A different view") / VIEW = Different_VIEW;
  set IO_SAS_LONG(keep = i x1-x20);
  where not mod(i,3);
  label i = "Variable from a view";
run;



/* opcja VIEW= mowi SAS-owi, zeby skompilowal kod, ale go nie wykonal, 
   i w zamian trzymal ten kod na dysku jako widok o nazwie
   podanej w opcji (nazwa musi byc taka sama jak nazwa przy DATA)
*/

/* z poziomu SQL: */

data /* pomocnicze zbiory SASowe */
zbiory.gracz_poziom(keep = id poziom_aktualny_od poziom_aktualny_do poziom)
zbiory.gracz_swiat(keep = id swiat_aktualny_od swiat_aktualny_do swiat)
;
format 
id Z8. 
poziom_aktualny_od poziom_aktualny_do swiat_aktualny_od swiat_aktualny_do yymmdd10.
;

do id = 1 to 1E6; 
 poziom_aktualny_od = '14mar2015'd + ceil(100 * ranuni(10));
 swiat_aktualny_od = poziom_aktualny_od;
 /* poziomy gracza w czasie */
 lp = ceil(10 * ranuni(10)); drop lp;
 do poziom = 1 to lp;
  poziom_aktualny_do = ifn(poziom = lp, '31dec9999'd, poziom_aktualny_od + 50 + ceil(50 * ranuni(10)));
  output zbiory.gracz_poziom;
  poziom_aktualny_od =  poziom_aktualny_do + 1;
 end;
/* swiat gry gracza w czasie */
 lp = ceil(20 * ranuni(10)); drop lp;
 do swiat_lp = 1 to lp;
  swiat_aktualny_do = ifn(swiat_lp = lp, '31dec9999'd, swiat_aktualny_od + 20 + ceil(20 * ranuni(10)));
  swiat = ceil(20 * ranuni(10));
  output zbiory.gracz_swiat;
  swiat_aktualny_od =  swiat_aktualny_do + 1;
 end;
end;

run;


proc sql;
CREATE VIEW gracz_swiat_poziom as /* <- tworzymy widok */
(
    select 
     datetime() as generation_time format E8601DT19.
    ,a.id as identyfikator_gracza
    ,b.poziom as poziom_gracza
    ,a.swiat as swiat_gry
    ,max(a.swiat_aktualny_od, b.poziom_aktualny_od) format YYMMDD10. as data_od 
    ,min(a.swiat_aktualny_do, b.poziom_aktualny_do) format YYMMDD10. as data_do

    from 
     model.gracz_poziom b
    join
     model.gracz_swiat a
    on a.id = b.id

    where 
     a.swiat_aktualny_od <= b.poziom_aktualny_do
    and
     b.poziom_aktualny_od <= a.swiat_aktualny_do
)
ORDER BY a.id, calculated data_od desc                        /* mozemy wymusic sortowanie */
USING LIBNAME model BASE "C:\SAS_WORK\ZBIORY" ACCESS=READONLY /* mozemy wskazac biblioteke */   
;

quit;



/* zmaterializujmy widok */
data gracz_swiat_poziom_set1;
set gracz_swiat_poziom;
where identyfikator_gracza = 13;
run;

data gracz_swiat_poziom_set2(where = (identyfikator_gracza = 13));
set gracz_swiat_poziom;
run;

data gracz_swiat_poziom_set3;
set gracz_swiat_poziom;
if identyfikator_gracza = 13;
run;

proc sql;
create table gracz_swiat_poziom_set4 as
select * from gracz_swiat_poziom
where identyfikator_gracza = 13
;
quit;


/* podgladanie kodu generujacego widok */

data view = gracz_swiat_poziom;
   describe;
run;
/* w logu wyswietli sie kod wykorzystany do utworzenia view, ale... jest haczyk! */




proc sql;
 describe view gracz_swiat_poziom; /* do ogladania widokow SQL-owych trzeba uzyc SQLa... */
quit;




data view = A_VIEW;
 describe;
run;




proc sql;
 describe view A_VIEW; /* ...a do ogladania widokow DS-owych trzeba uzyc DSa */
quit;


/* Wady i Zalety: */
/* wada - jesli odwolujemy sie do widoku wiele razy w programie, 
          to czesto wykonujemy ten sam kod. */
%let _st_ = %sysfunc(datetime());

data czas_gry_V;
 set gracz_swiat_poziom;
 by identyfikator_gracza;
 retain start end;
 if first.identyfikator_gracza then end = min(today(),data_do);
 if  last.identyfikator_gracza then 
    do; 
        start = data_od;
        czas_gry = end - start;
        output;
    end;
 keep identyfikator_gracza czas_gry;
run;

proc freq data = gracz_swiat_poziom;
 table poziom_gracza;
 table swiat_gry;
run;

proc univariate data = gracz_swiat_poziom;
where poziom_gracza = 1;
var data_od;
run;

%let _en_ = %sysfunc(datetime());
%put NOTE:[BJ] czas przetwarzania z widokiem: %sysevalf(&_en_. - &_st_.) s.;








/* czasami warto pomyslec o zmaterializowaniu widoku, 
   ale zawsze biorac pod uwage relacje kosztu przestrzeni dyskowej
   i kosztu czasu/procesora
*/

%let _st_ = %sysfunc(datetime());

data _TMP_; 
set gracz_swiat_poziom;
run;

data czas_gry_M;
 set _TMP_;
 by identyfikator_gracza;
 retain start end;
 if first.identyfikator_gracza then end = min(today(),data_do);
 if  last.identyfikator_gracza then 
    do; 
        start = data_od;
        czas_gry = end - start;
        output;
    end;
 keep identyfikator_gracza czas_gry;
run;

proc freq data = _TMP_;
 table poziom_gracza;
 table swiat_gry;
run;

proc univariate data = _TMP_;
where poziom_gracza = 1;
var data_od;
run;

%let _en_ = %sysfunc(datetime());
%put NOTE:[BJ] czas przetwarzania z materializacja: %sysevalf(&_en_. - &_st_.) s.;

/*
proc sql;
 drop table _TMP_;
quit;
*/





/* zaleta/wada - jesli view zostal stworzony na podst. danych, 
                 ktore sie zmieniaja, uaktualni sie od razu view i wszystko,
                 co z nim dalej robimy
*/
data zbiory.gracz_swiat;
set zbiory.gracz_swiat;
where swiat in (3,6,7,17);
run;

data _TMP_2; 
set gracz_swiat_poziom;
run;








/* zaleta - unika sie tworzenia posrednich plikow; np. gdy potrzeba 
            wprowadzic jedna dodatkowa zmienna do pliku,
            ktorego nie mozemy modyfikowac, a potem na 
            tej podstawie stworzyc jakis raport
*/


data czas_na_poziom / view = czas_na_poziom;
 set zbiory.gracz_poziom;
 where poziom_aktualny_do ne '31dec9999'd;
 czas_na_poziom = poziom_aktualny_do - poziom_aktualny_od;
run;

proc univariate data = czas_na_poziom mu0=75;
var czas_na_poziom;
histogram czas_na_poziom / normal(color=green mu=75 sigma=15); ; 
run;








/* ciekawostki */
/*** tworzenie w jednym stepie pliku i widoku ***/

data Sss Vvv / view = Vvv;
 do i = 1 to 10;
  output;
 end;
run;

proc print data = Sss (obs = 5);
run;





/* plik Sss nie utworzy sie, dopoki nie wymusimy wykonania kodu zapisanego w view */

proc print data = Vvv (obs = 5);
run;

proc print data = Sss (obs = 5);
run;





/* uwaga! */
data Eee Ooo / view = Eee Ooo;
 do i = 1 to 10;
    if mod(i,2) then output Eee; else output Ooo;
 end;
run;

/* jeden widok na datastep */



/* "sterowanie" dostepem do danych */

data x;
 do i = 1 to 40;
 x=ranuni(1);
 output;
 end;
run;

data y / view = y;
 set x;
 where symget("sysuserid") in 
 (
 'bart'
 );
run;

data view=y;
   describe;
run;

data _null_;
   y=MD5('bart');
   z=MD5('test');
   put y=/ y=$hex32.;
   put z=/ z=$hex32.;
run;

data y / view = y;
 set x;
 where put(md5(symget("sysuserid")),$hex32.) in 
 (
 'F54146A3FC82AB17E5265695B23F646B'
 );
run;

data view=y;
   describe;
run;

proc sql;
create view z as
 select * from x
 where put(md5(symget("sysuserid")),$hex32.) in 
 (
 'F54146A3FC82AB17E5265695B23F646B'
 )
 ;
 describe view z;
quit;


data zbiory.good_user;
 user = 'F54146A3FC82AB17E5265695B23F646B'; output;
run;

proc sql;
create view z as
 select * from x
 where put(md5(symget("sysuserid")),$hex32.) in 
 (
 select * from t.good_user
 )
 using libname t "C:\SAS_WORK\ZBIORY" ACCESS=READONLY;
 describe view z;
quit;


/* end of lecture 7 *//* 3704 */
/* end of lecture 7 *//* 3704 */





/* pliki textowe */
data test_w_worku;
x=17;
run;

data zbiory.co_tam_w_worku / view = zbiory.co_tam_w_worku;
 infile "DIR /B /L %sysfunc(getoption(work))"  PIPE dlm = "0A"x;
 input;
 length txt $ 200;
 txt = _infile_;
run;


data view=zbiory.co_tam_w_worku ;
   describe;
run; 




/* makrozmienne w widoku - uwaga na boku */
data zbiory.test_Kamil / view = zbiory.test_Kamil;
do x = 1 to symget("XYZ");
y = ranuni(42);
output;
end;
run;


data view=zbiory.test_Kamil ;
   describe;
run;


data  test1;
set zbiory.test_Kamil;
run;

%let XYZ = 17;
data  test2;
set zbiory.test_Kamil;
run;






/*szerokie i dlugie na jednych danych*/

data szeroki;
 array XXX[10000] x1-x10000;
 do i=1 to 1E2;
  do j=1 to dim(XXX); drop j;
   XXX[j] = round(ranuni(10000),0.0001);
  end;
  output; 
 end;
run;

data dlugi / view=dlugi;
  length i 8 zmienna $ 4 wartosc 8;
  keep i zmienna wartosc;
 set szeroki;
  array XXX x1-x10000;
 do over XXX;
  zmienna = strip(vname(XXX));
  wartosc = XXX;
  output;
 end;
run;







/* SQL i FEEDBACK i VIEW */
options fullstimer msglevel=i;
data /* pomocnicze zbiory SASowe */
zbiory.gracz_poziom(keep = id poziom_aktualny_od poziom_aktualny_do poziom)
zbiory.gracz_swiat(keep = id swiat_aktualny_od swiat_aktualny_do swiat)
;
format 
id Z8. 
poziom_aktualny_od poziom_aktualny_do swiat_aktualny_od swiat_aktualny_do yymmdd10.
;

do id = 1 to 1E6; 
 poziom_aktualny_od = '14mar2015'd + ceil(100 * ranuni(10));
 swiat_aktualny_od = poziom_aktualny_od;
 /* poziomy gracza w czasie */
 lp = ceil(10 * ranuni(10)); drop lp;
 do poziom = 1 to lp;
  poziom_aktualny_do = ifn(poziom = lp, '31dec9999'd, poziom_aktualny_od + 50 + ceil(50 * ranuni(10)));
  output zbiory.gracz_poziom;
  poziom_aktualny_od =  poziom_aktualny_do + 1;
 end;
/* swiat gry gracza w czasie */
 lp = ceil(20 * ranuni(10)); drop lp;
 do swiat_lp = 1 to lp;
  swiat_aktualny_do = ifn(swiat_lp = lp, '31dec9999'd, swiat_aktualny_od + 20 + ceil(20 * ranuni(10)));
  swiat = ceil(20 * ranuni(10));
  output zbiory.gracz_swiat;
  swiat_aktualny_od =  swiat_aktualny_do + 1;
 end;
end;

run;


proc sql;
CREATE VIEW gracz_swiat_poziom as /* <- tworzymy widok */
(
    select 
     datetime() as generation_time format E8601DT19.
    ,a.id as identyfikator_gracza
    ,b.poziom as poziom_gracza
    ,a.swiat as swiat_gry
    ,max(a.swiat_aktualny_od, b.poziom_aktualny_od) format YYMMDD10. as data_od 
    ,min(a.swiat_aktualny_do, b.poziom_aktualny_do) format YYMMDD10. as data_do

    from 
     model.gracz_poziom b
    join
     model.gracz_swiat a
    on a.id = b.id

    where 
     a.swiat_aktualny_od <= b.poziom_aktualny_do
    and
     b.poziom_aktualny_od <= a.swiat_aktualny_do
)
ORDER BY a.id, calculated data_od desc                        /* mozemy wymusic sortowanie */
USING LIBNAME model BASE "C:\SAS_WORK\ZBIORY" ACCESS=READONLY /* mozemy wskazac biblioteke */   
;

quit;
/**/




proc sql;
create table najdluzsza_gra as 
select 
  identyfikator_gracza
 ,poziom_gracza
 ,swiat_gry
 ,data_od 
 ,data_do
from
 gracz_swiat_poziom
 having (min(today(),data_do) - data_od) = max(min(today(),data_do) - data_od)
;
quit;






proc sql FEEDBACK;
create table gracz_najdluzsza_gra as 
select 
 x1.*
from
 zbiory.gracz_poziom as x1
join
 (
 select
   identyfikator_gracza
 from
  gracz_swiat_poziom
  having (min(today(),data_do) - data_od) = max(min(today(),data_do) - data_od)
 ) as x2
on x1.id = x2.identyfikator_gracza
;
quit;






proc sql;
create view clakowity_czas_gry as
select id, sum(min(today(),swiat_aktualny_do) - swiat_aktualny_od) as clakowity_czas_gry
from zbiory.gracz_swiat
group by id
;
quit;




proc sql FEEDBACK;
create table poziom_maks as
select maksymalny_poziom, count(distinct id) as ile
from
 (
 select distinct
  gp.id, max(gp.poziom) as maksymalny_poziom
 from
  zbiory.gracz_poziom as gp
 join
  clakowity_czas_gry ccg
 on gp.id = ccg.id
 where ccg.clakowity_czas_gry > 750
 )
group by maksymalny_poziom
;
quit;





/* a widok datastepowy? */
proc sql FEEDBACK;
create table gt09 as
select * 
from dlugi 
where wartosc > 0.9
;
quit;







/* 5. SASFILE statement */

/* polecenie SASFILE laduje plik do pamieci i trzyma go tam, dopoki nie zamkniemy SASFILE */
/* do kolejnych odwolan do pliku w data i proc stepach wykorzystywana jest wersja pliku 
   z pamieci, nie trzeba wiec wielokrotnie go wczytywac (alokowac i zwalniac buforow) */
/* moze to zaoszczedzic I/O i CPU time */
/* przydatne dla plikow, ktore mieszcza sie w calosci w pamieci */


data _TMP_; 
set gracz_swiat_poziom;
run;



%let _st_ = %sysfunc(datetime());

SASFILE _tmp_ LOAD; /* otwiera plik, alokuje bufory i wczytuje plik do pamieci */
                   

/* SASFILE _tmp_ OPEN;  <- otwiera plik, alokuje bufory, ale z ladowaniem do pamieci 
                           czeka na pierwsze odwolanie do pliku 
*/

data czas_gry_S;
 set _TMP_;
 by identyfikator_gracza;
 retain start end;
 if first.identyfikator_gracza then end = min(today(),data_do);
 if  last.identyfikator_gracza then 
    do; 
        start = data_od;
        czas_gry = end - start;
        output;
    end;
 keep identyfikator_gracza czas_gry;
run;

proc freq data = _TMP_;
 table poziom_gracza;
 table swiat_gry;
run;

proc univariate data = _TMP_;
where poziom_gracza = 1;
var data_od;
run;

%let _en_ = %sysfunc(datetime());
%put NOTE:[BJ] czas przetwarzania z sasfile: %sysevalf(&_en_. - &_st_.) s.;




sasfile _tmp_ CLOSE; /* uwalania bufory i zamyka plik */





/* uwaga! */
SASFILE gracz_swiat_poziom LOAD; 







/* nie mozna przy wlaczanej opcji korzystac z niektorych procedur, jak sortowanie 
   na miejscu czy dodawanie lub zmienianie nazw zmiennych (DATASETS) */
SASFILE _tmp_ LOAD;

proc sort data = _TMP_;
by poziom_gracza data_od;
run;

SASFILE _tmp_ CLOSE; 






data zbiory.test_Monika;
do i = 1 to 135;
output;
end;
run;


SASFILE zbiory.test_Monika LOAD;




/*
kod z drugiej sesji:

proc sort data = zbiory.test_Monika;
by descending i;
run;

log mowi:
ERROR: A lock is not available for ZBIORY.TEST_MONIKA.DATA.
NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set ZBIORY.TEST_MONIKA was only partially opened and will not be saved.
*/













/* REDUKCJA ZUZYCIA PRZESTRZENI DYSKOWEJ */


/*1. redukcja dlugosci zmiennych numerycznych*/

/* jesli zmienna numeryczna jest "kategoryzujaca" i przyjmuje malo wartosci, 
   warto rozwazyc zmiane na tekstowa, a jesli jest binarna to juz bez dyskusji ;-)
*/

data t1;
set gracz_swiat_poziom;
run;

data t2(rename=(p_g=poziom_gracza s_g=swiat_gry));
set gracz_swiat_poziom;

length p_g s_g $ 2;
p_g = strip(put(poziom_gracza,best.));
s_g = strip(put(swiat_gry,best.)); 
drop poziom_gracza swiat_gry;
run;




data flagi_num(keep = x:) flagi_txt(keep = y:);

Array NUM[*] x1 - x5000; /* 8 bajtow - dlugosc dla zmiennej numerycznej */
Array CHAR[*] $ 1 y1 - y5000;

do i=1 to 1000;
 do j = 1 to dim(NUM);
  z = ranuni(99);

  if z > 0.5 then 
   do;
    NUM[j]=1;
    CHAR[j]='1';
   end;
  else
   do;
    NUM[j]=0;
    CHAR[j]='0';
   end;
 end;
output;
end;
run;



/*
w data stepie polecenie:
 length default = 3; 
zmieni dlugosc nowo tworzonych zmiennych numerycznych na 3

jednak w PDV zmienne numeryczne zawsze maja dlugosc 8
dopiero w zbiorze wynikowym dlugosc jest z powrotem zmniejszona
*/

data xyz8;
 do i = 1 to 1E6; drop i;
  x=6; y=17; z=42;
  output;
 end;
run;

data xyz3;
 LENGTH DEFAULT = 3;
 do i = 1 to 1E6; drop i;
  x=6; y=17; z=42;
  output;
 end;
run;



/*
Wady i Zalety:
 
+ zmniejsza zuzycie przestrzeni na dysku i I/O
- zwieksza CPU time 
  (SAS przed wczytaniem obs. do PDV rozszerza dlugosc do 8 bajtow)
- moze pogorszyc precyzje
  (najwieksza liczba calk. reprezentowana dokladnie 
   dla 4 bajtow to ok. 2 mln; dla ulamkowych lepiej nie stosowac)
*/

/*
 Length   | Significant Digits | Largest Integer
 in Bytes | Retained           | Represented Exactly
 ---------+--------------------+--------------------
   3          3                    8,192
   4          6                    2,097,152
   5          8                    536,870,912
   6          11                   137,438,953,472
   7          13                   35,184,372,088,832
   8          15                   9,007,199,254,740,992
*/

data abc;
length default = 3;
abc = 12345;
efg = 0.123;

put _all_;
run;




data _null_;
set abc;

put _all_;
run;




data _null_;
abc=12345*1E6; efg=0.123;
x1=abc*efg;

abc=12344*1E6; efg=0.1229858398;
x2=abc*efg;

x_diff = x1-x2;
put x1= dollar32.2 x2= dollar32.2 x_diff= dollar32.2 ;
run;






data zbiory.dict_poziom;
infile cards dlm = '|';
input poziom poziom_nazwa $ :100.;
cards;
1|Kocur bury
2|Kadet mlekopij
3|Pretendent do szansy na mo¿liwoœæ wyjœcia z grupy
4|Absolvent w ³ódce
5|Szeregowy Œwie¿ynka
6|Pierfsza kref
7|Szacun na kompañji
8|Ot'dzia³owy celebryta
9|Czempjon
10|Krzysztof Jarzyna ze Szczecina - Szef wszystkich szefów
;
run;

data zbiory.dict_swiat;
infile cards dlm = '|';
input swiat swiat_nazwa $ :50.;
cards;
1|Pó³nocne Góry
2|Po³udniowe Góry
3|Wschodnie Góry
4|Zachodnie Góry
5|Pó³nocne Lasy
6|Po³udniowe Lasy
7|Wschodnie Lasy
8|Zachodnie Lasy
9|Pó³nocne Morze
10|Po³udniowe Morze
11|Wschodnie Morze
12|Zachodnie Morze
13|Pó³nocne Bagna
14|Po³udniowe Bagna
15|Wschodnie Bagna
16|Zachodnie Bagna
17|Pó³nocne Równiny
18|Po³udniowe Równiny
19|Wschodnie Równiny
20|Zachodnie Równiny
;
run;





proc sql;
CREATE VIEW gracz_swiat_poziom_opis as /* <- tworzymy widok */
(
    select 
     datetime() as generation_time format E8601DT19.
    ,a.id as identyfikator_gracza
    ,db.poziom_nazwa as poziom_gracza
    ,da.swiat_nazwa as swiat_gry
    ,max(a.swiat_aktualny_od, b.poziom_aktualny_od) format YYMMDD10. as data_od 
    ,min(a.swiat_aktualny_do, b.poziom_aktualny_do) format YYMMDD10. as data_do

    from 
     model.gracz_poziom b
    join
     model.gracz_swiat a
    on a.id = b.id
    join
    model.dict_poziom as db
    on b.poziom = db.poziom
    join
    model.dict_swiat as da
    on a.swiat = da.swiat

    where 
     a.swiat_aktualny_od <= b.poziom_aktualny_do
    and
     b.poziom_aktualny_od <= a.swiat_aktualny_do
)
ORDER BY a.id, calculated data_od desc                        /* mozemy wymusic sortowanie */
USING LIBNAME model BASE "C:\SAS_WORK\ZBIORY" ACCESS=READONLY /* mozemy wskazac biblioteke */   
;

quit;



data test;
set gracz_swiat_poziom_opis;
run;


data test2;
set gracz_swiat_poziom;
run;




data x;
length label $ 100;

set zbiory.dict_poziom(rename=(poziom=start poziom_nazwa=label)) end=last;
retain fmtname 'poziom_nazwa' type 'n';
output;
 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=zbiory cntlin=x;
run;

data x;
length label $ 100;

set zbiory.dict_swiat(rename=(swiat=start swiat_nazwa=label)) end=last;
retain fmtname 'swiat_nazwa' type 'n';
output;
 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=zbiory cntlin=x;
run;



options fmtsearch=(zbiory work);

proc sql;
CREATE VIEW gracz_swiat_poziom_opis_light as /* <- tworzymy widok */
(
    select 
     datetime() as generation_time format E8601DT19.
    ,a.id as identyfikator_gracza
    ,b.poziom as poziom_gracza format poziom_nazwa.
    ,a.swiat as swiat_gry format swiat_nazwa.
    ,max(a.swiat_aktualny_od, b.poziom_aktualny_od) format YYMMDD10. as data_od 
    ,min(a.swiat_aktualny_do, b.poziom_aktualny_do) format YYMMDD10. as data_do

    from 
     model.gracz_poziom b
    join
     model.gracz_swiat a
    on a.id = b.id
    
    where 
     a.swiat_aktualny_od <= b.poziom_aktualny_do
    and
     b.poziom_aktualny_od <= a.swiat_aktualny_do
)
ORDER BY a.id, calculated data_od desc                        /* mozemy wymusic sortowanie */
USING LIBNAME model BASE "C:\SAS_WORK\ZBIORY" ACCESS=READONLY /* mozemy wskazac biblioteke */   
;

quit;



data test3;
set gracz_swiat_poziom_opis_light;
run;








data x;
length label $ 100;

set zbiory.dict_poziom(rename=(poziom_nazwa=label)) end=last;
retain fmtname 'poziom_nazwa' type 'c';
start = strip(byte(64+poziom));
output;
 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=zbiory cntlin=x;
run;

data x;
length label $ 100;

set zbiory.dict_swiat(rename=(swiat_nazwa=label)) end=last;
retain fmtname 'swiat_nazwa' type 'c';
start = strip(byte(64+swiat)); 
output;
 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=zbiory cntlin=x;
run;

options fmtsearch=(zbiory work);

data test4(rename=(p_g=poziom_gracza s_g=swiat_gry));
set gracz_swiat_poziom;

length p_g s_g $ 1;
p_g = strip(byte(64+poziom_gracza));
s_g = strip(byte(64+swiat_gry)); 
drop poziom_gracza swiat_gry;
format p_g $poziom_nazwa. s_g $swiat_nazwa. ; 
run;













/* KOMPRESJA ZBIOROW */
/*
COMPRESS= system option NO/(YES/CHAR)/BINARY
COMPRESS= data set option - nadpisuje opcje globalna

YES/CHAR - RLE (Run-Length Encoding)
BINARY   - RDC (Ross Data Compresion)  
*/


/* jak wyglada nieskompresowany zbior SASowy: */
/* 
1) kazda obserwacja zajmuje taka sama liczbe bajtow 
   i ma staly rozmiar
2) kazda zmienna ma ustalona dlugosc(liczbe bajtow)
3) zmienne tekstowe uzupelnone sa spacjami
4) zmienne numeryczne uzupelnone sa binarnymi zerami
5) pierwsza strona danych zawiera deskryptor pliku
6) kazda strona zawiera na poczatku 24/40 bajtow narzutu
7) dla kazeje obserwacji dodany jest 1 dodatkowy bit, 
   zaokraglany do pelnego bajta
8) nowe obserwacje dodawane sa na koncu zbioru
9) miejsce po usunieteych obserwacjach nie jest uzywane ponownie,
   o ile zbior nie jest zbudowany od nowa 
*/

/* jak wyglada skompresowany zbior SASowy: */
/*
1) kazda obserwacja to pojedynczy ciag bajtow, 
   typy zmiennych i ograniczenia sa ignorowane
2) kazda obserwacja moze miec inna dlugosc
3) nastepujace po sobie takie same liczy lub znaki 
   sa scalane w mniejszej liczbe bajtow
4) jesli update'owana obserwacja jest wieksza niz
   oryginalna, to jest umieszczana na tej samej stronie,
   albo jest przeniesiona na inna ze wsakznikem na oryginalna strone
5) deskryptor znajduje sie na koncu pierwszej strony
6) kazda strona zawiera na poczatku 24/40 bajtow narzutu
7) dla kazdej obserwacji dodawane jest 12/24 bajty narzutu 
   zwiazanego z kompresja (np. gdzie konczy sie konkretna zmienna)
8) miejsce po usunietych zmiennych moze zostac nadpisane
   o ile uzyje sie opcji Reuse = yes przy kompresowaniu * <- to bedzie w innym terminie *;

nie mozna kompresowac widokow
*/



options COMPRESS = YES; /* opcja globalna nakazuje kompresowanie wszystkich zbiorow */

libname cmp 'C:\SAS_WORK\kompresowane' COMPRESS = YES; /* opcja biblioteki nakazuje 
                                                          kompresowanie wszystkich zbiorow
                                                          zapisywanych w biblioterce */

data 
    c1(COMPRESS = NO) /* opcja lokalna nakazuje nie kompresowac wskazanego zbioru */
;
length c $ 1;
do i = 1 to 1E5; drop i;
c = 'C';
d = 'D';
e = 'E';
f = 'F';
output;
end;
run;

options COMPRESS = NO;


/* przyklady zmiany rozmiaru z zaleznosci od zmiany w zbiorze */

data c2 cmp.c2; 
length c d e f $ 10;
do i = 1 to 1E5; drop i;
 c = 'CCCCCCCCCC';
 d = 'DDDDDDDDDD';
 e = 'EEEEEEEEEE';
 f = 'FFFFFFFFFF';
output;
end;
run;


data c3(COMPRESS=YES);
set c2;
run;

data c3_Bartek;
set c3;
run;


data c4;
set c2;
if mod(_N_,2) then call missing(c,d,e,f);
run;


data c5(COMPRESS=YES);
set c2;
if mod(_N_,2) then call missing(c,d,e,f);
run;

data c6;
set c2;
 c = substr(c,1,1);
 e = substr(e,1,1);
run;

data c7(COMPRESS=YES);
set c2;
 c = substr(c,1,1);
 e = substr(e,1,1);
run;


ods html;
proc contents data = c2;
run;
proc contents data = c3;
run;



/* end of lecture 8 *//* line 4557 */
data zbiory.kraje;
infile cards dlm = '0A'x;;
input kraj $ :50.;
cards;
Afghanistan [AFG]
Aland Islands [ALA]
Albania [ALB]
Algeria [DZA]
American Samoa [ASM]
Andorra [AND]
Angola [AGO]
Anguilla [AIA]
Antarctica [ATA]
Antigua and Barbuda [ATG]
Argentina [ARG]
Armenia [ARM]
Aruba [ABW]
Australia [AUS]
Austria [AUT]
Azerbaijan [AZE]
Bahamas [BHS]
Bahrain [BHR]
Bangladesh [BGD]
Barbados [BRB]
Belarus [BLR]
Belgium [BEL]
Belize [BLZ]
Benin [BEN]
Bermuda [BMU]
Bhutan [BTN]
Bolivia [BOL]
Bosnia and Herzegovina [BIH]
Botswana [BWA]
Bouvet Island [BVT]
Brazil [BRA]
British Virgin Islands [VGB]
British Indian Ocean Territory [IOT]
Brunei Darussalam [BRN]
Bulgaria [BGR]
Burkina Faso [BFA]
Burundi [BDI]
Cambodia [KHM]
Cameroon [CMR]
Canada [CAN]
Cape Verde [CPV]
Cayman Islands  [CYM]
Central African Republic [CAF]
Chad [TCD]
Chile [CHL]
China [CHN]
Hong Kong, SAR China [HKG]
Macao, SAR China [MAC]
Christmas Island [CXR]
Cocos (Keeling) Islands [CCK]
Colombia [COL]
Comoros [COM]
Congo (Brazzaville) [COG]
Congo, (Kinshasa) [COD]
Cook Islands  [COK]
Costa Rica [CRI]
Côte d'Ivoire [CIV]
Croatia [HRV]
Cuba [CUB]
Cyprus [CYP]
Czech Republic [CZE]
Denmark [DNK]
Djibouti [DJI]
Dominica [DMA]
Dominican Republic [DOM]
Ecuador [ECU]
Egypt [EGY]
El Salvador [SLV]
Equatorial Guinea [GNQ]
Eritrea [ERI]
Estonia [EST]
Ethiopia [ETH]
Falkland Islands (Malvinas)  [FLK]
Faroe Islands [FRO]
Fiji [FJI]
Finland [FIN]
France [FRA]
French Guiana [GUF]
French Polynesia [PYF]
French Southern Territories [ATF]
Gabon [GAB]
Gambia [GMB]
Georgia [GEO]
Germany [DEU]
Ghana [GHA]
Gibraltar  [GIB]
Greece [GRC]
Greenland [GRL]
Grenada [GRD]
Guadeloupe [GLP]
Guam [GUM]
Guatemala [GTM]
Guernsey [GGY]
Guinea [GIN]
Guinea-Bissau [GNB]
Guyana [GUY]
Haiti [HTI]
Heard and Mcdonald Islands [HMD]
Holy See (Vatican City State) [VAT]
Honduras [HND]
Hungary [HUN]
Iceland [ISL]
India [IND]
Indonesia [IDN]
Iran, Islamic Republic of [IRN]
Iraq [IRQ]
Ireland [IRL]
Isle of Man  [IMN]
Israel [ISR]
Italy [ITA]
Jamaica [JAM]
Japan [JPN]
Jersey [JEY]
Jordan [JOR]
Kazakhstan [KAZ]
Kenya [KEN]
Kiribati [KIR]
Korea (North) [PRK]
Korea (South) [KOR]
Kuwait [KWT]
Kyrgyzstan [KGZ]
Lao PDR [LAO]
Latvia [LVA]
Lebanon [LBN]
Lesotho [LSO]
Liberia [LBR]
Libya [LBY]
Liechtenstein [LIE]
Lithuania [LTU]
Luxembourg [LUX]
Macedonia, Republic of [MKD]
Madagascar [MDG]
Malawi [MWI]
Malaysia [MYS]
Maldives [MDV]
Mali [MLI]
Malta [MLT]
Marshall Islands [MHL]
Martinique [MTQ]
Mauritania [MRT]
Mauritius [MUS]
Mayotte [MYT]
Mexico [MEX]
Micronesia, Federated States of [FSM]
Moldova [MDA]
Monaco [MCO]
Mongolia [MNG]
Montenegro [MNE]
Montserrat [MSR]
Morocco [MAR]
Mozambique [MOZ]
Myanmar [MMR]
Namibia [NAM]
Nauru [NRU]
Nepal [NPL]
Netherlands [NLD]
Netherlands Antilles [ANT]
New Caledonia [NCL]
New Zealand [NZL]
Nicaragua [NIC]
Niger [NER]
Nigeria [NGA]
Niue  [NIU]
Norfolk Island [NFK]
Northern Mariana Islands [MNP]
Norway [NOR]
Oman [OMN]
Pakistan [PAK]
Palau [PLW]
Palestinian Territory [PSE]
Panama [PAN]
Papua New Guinea [PNG]
Paraguay [PRY]
Peru [PER]
Philippines [PHL]
Pitcairn [PCN]
Poland [POL]
Portugal [PRT]
Puerto Rico [PRI]
Qatar [QAT]
Réunion [REU]
Romania [ROU]
Russian Federation [RUS]
Rwanda [RWA]
Saint-Barthélemy [BLM]
Saint Helena [SHN]
Saint Kitts and Nevis [KNA]
Saint Lucia [LCA]
Saint-Martin (French part) [MAF]
Saint Pierre and Miquelon  [SPM]
Saint Vincent and Grenadines [VCT]
Samoa [WSM]
San Escobar [SER]
San Marino [SMR]
Sao Tome and Principe [STP]
Saudi Arabia [SAU]
Senegal [SEN]
Serbia [SRB]
Seychelles [SYC]
Sierra Leone [SLE]
Singapore [SGP]
Slovakia [SVK]
Slovenia [SVN]
Solomon Islands [SLB]
Somalia [SOM]
South Africa [ZAF]
South Georgia and the South Sandwich Islands [SGS]
South Sudan [SSD]
Spain [ESP]
Sri Lanka [LKA]
Sudan [SDN]
Suriname [SUR]
Svalbard and Jan Mayen Islands  [SJM]
Swaziland [SWZ]
Sweden [SWE]
Switzerland [CHE]
Syrian Arab Republic (Syria) [SYR]
Taiwan, Republic of China [TWN]
Tajikistan [TJK]
Tanzania, United Republic of [TZA]
Thailand [THA]
Timor-Leste [TLS]
Togo [TGO]
Tokelau  [TKL]
Tonga [TON]
Trinidad and Tobago [TTO]
Tunisia [TUN]
Turkey [TUR]
Turkmenistan [TKM]
Turks and Caicos Islands  [TCA]
Tuvalu [TUV]
Uganda [UGA]
Ukraine [UKR]
United Arab Emirates [ARE]
United Kingdom [GBR]
United States of America [USA]
US Minor Outlying Islands [UMI]
Uruguay [URY]
Uzbekistan [UZB]
Vanuatu [VUT]
Venezuela (Bolivarian Republic) [VEN]
Viet Nam [VNM]
Virgin Islands, US [VIR]
Wallis and Futuna Islands  [WLF]
Western Sahara [ESH]
Yemen [YEM]
Zambia [ZMB]
Zimbabwe [ZWE]
;
run;

proc sort data = zbiory.kraje;
by kraj;
run;
/* end of lecture 8 *//* line 4557 */

/* czy dolaczenie tagow nie zwiekszy zajmowanego miejsca bardziej, niz kompresja zmniejszy? */



/* dlugie zmienne tekstowe, dlugie obserwacje (>100) */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;
    j="abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc";
    k="defdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdef";
    l="ghighighighighighighighighighighighighighighighighighighighighighighighi";
    m="jkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkl";
    n="mnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomno";
output;
end;

run;


/* mieszane zmienne tekstowe, dlugie obserwacje (>100) */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;
length j k l m n $ 72;
    j=substrn("abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",1,ceil(72*ranuni(17)));
    k=substrn("defdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdefdef",1,ceil(72*ranuni(17)));
    l=substrn("ghighighighighighighighighighighighighighighighighighighighighighighighi",1,ceil(72*ranuni(17)));
    m=substrn("jkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkljkl",1,ceil(72*ranuni(17)));
    n=substrn("mnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomnomno",1,ceil(72*ranuni(17)));
output;
end;

run;





/* mieszane zmienne tekstowe, krotkie obserwacje (<100) */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;
length j k l m n $ 12;
    j=substrn("abcabcabcabc",1,ceil(12*ranuni(17)));
    k=substrn("defdefdefdef",1,ceil(12*ranuni(17)));
    l=substrn("ghighighighi",1,ceil(12*ranuni(17)));
    m=substrn("jkljkljkljkl",1,ceil(12*ranuni(17)));
    n=substrn("mnomnomnomno",1,ceil(12*ranuni(17)));
output;
end;

run;





/* krotkie zmienne tekstowe, krotkie obserwacje (<100) */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;
length j k l m n $ 3;
    j="abc";
    k="def";
    l="ghi";
    m="jkl";
    n="mno";
output;
end;

run;




/* malo zmiennych numerycznych o zroznicowanych wartosciach*/
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
    m=rannor(17);
    n=rannor(17);
output;
end;

run;




/* malo zmiennych numerycznych o malym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[5];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ceil(6*ranuni(17));
    end;
output;
end;

run;




/* srednia ilosc zmiennych numerycznych o malym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[50];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ceil(6*ranuni(17));
    end;
output;
end;

run;




/* duzo zmiennych numerycznych o malym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[500];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ceil(6*ranuni(17));
    end;
output;
end;

run;




/* duzo zmiennych numerycznych o malym zakresie wartosci i wzorzec */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[500];
    do j=1 to dim(XXX); drop j;
        XXX[j] = mod(j,5) + mod(i,5);
    end;
output;
end;

run;




/* duzo krotkich zmiennych numerycznych o malym zakresie wartosci i wzorzec */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

LENGTH DEFAULT = 3; /* <- !!! */

do i=1 to 1E4; drop i;
array XXX[500];
    do j=1 to dim(XXX); drop j;
        XXX[j] = mod(j,5) + mod(i,5);
    end;
output;
end;

run;








/* duzo krotkich zmiennych tekstowych o malym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[500] $ 1;
    do j=1 to dim(XXX); drop j;
        XXX[j] = put(mod(j,3) + mod(i,3),$1.);
    end;
output;
end;

run;




/* malo zmiennych numerycznych o zmiennym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[5];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ranuni(17);
    end;
output;
end;

run;




/* srednia ilosc zmiennych numerycznych o zmiennym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[50];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ranuni(17);
    end;
output;
end;

run;




/* duzo zminnych numerycznych o zmiennym zakresie wartosci */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4; drop i;
array XXX[500];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ranuni(17);
    end;
output;
end;

run;



/* napisy ze wzorcami, liczby o malym zakresie*/

/* duzo zmiennych textowych malo numerycznych */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;

array YYY[100] $ 72;
    do j=1 to dim(YYY); drop j;
        YYY[j] = substrn("abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",1,floor(72*ranuni(17)));
    end;
   
array XXX[20];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ceil(6*ranuni(17));
    end;

output;
end;

run;




/* malo zmiennych textowych duzo numerycznych */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;

array YYY[20] $ 72;
    do j=1 to dim(YYY); drop j;
        YYY[j] = substrn("abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",1,floor(72*ranuni(17)));
    end;
   
array XXX[100];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ceil(6*ranuni(17));
    end;

output;
end;

run;




/* duzo zmiennych textowych malo numerycznych */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;

array YYY[100] $ 72;
    do j=1 to dim(YYY); drop j;
        YYY[j] = substrn("abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",1,floor(72*ranuni(17)));
    end;
   
array XXX[20];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ranuni(17);
    end;

output;
end;

run;




/* malo zmiennych textowych duzo numerycznych */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;

array YYY[20] $ 72;
    do j=1 to dim(YYY); drop j;
        YYY[j] = substrn("abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",1,floor(72*ranuni(17)));
    end;
   
array XXX[100];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ceil(6*ranuni(17));
    end;

output;
end;

run;




/* napisy bez wzorcow, liczby o duzym zakresie*/
/* malo zmiennych textowych duzo numerycznych */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;

array YYY[20] $ 72;
    do j=1 to dim(YYY); drop j;
        YYY[j] = "";
        do k = 1 to floor(72*ranuni(17)); drop k;
            YYY[j] = cats(YYY[j],byte(65+floor(26*ranuni(17))));
        end;

    end;
   
array XXX[100];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ranuni(17);
    end;

output;
end;

run;



/* duzo zmiennych textowych malo numerycznych */
data test_NO(COMPRESS=NO) test_CHAR(COMPRESS=CHAR) test_BINARY(COMPRESS=BINARY);

do i=1 to 1E4;

array YYY[100] $ 72;
    do j=1 to dim(YYY); drop j;
        YYY[j] = "";
        do k = 1 to floor(72*ranuni(17)); drop k;
            YYY[j] = cats(YYY[j],byte(65+floor(26*ranuni(17))));
        end;

    end;
   
array XXX[20];
    do j=1 to dim(XXX); drop j;
        XXX[j] = ranuni(17);
    end;

output;
end;

run;










/* zalecane stosowanie: 
   - dla duzych zbiorow z wieloma brakami danych 
   - krotkie napisy w zmiennych o duzej dlugosci
   - powtarzajace sie ciagi tego samego znaku
   - powtarzajace sie wartosci (wzorce)

zawsze warto najpierw sprawdzic zanim sie zacznie kompresowac
*/



options details;
/* alternatywa dla kompresji w SASie */
/* device-type: ZIP */
filename zip_plik ZIP 'X:\Pi - Dec - Chudnovsky.zip' member="Pi - Dec - Chudnovsky.txt";
data a_zip; 
 infile zip_plik lrecl=1000000000;
 input i 1. @@;
 array DIGITS[0:9] DIGITS0-DIGITS9;

    if i ne . then DIGITS[i]+1;

if sum(of DIGITS[*])>=1000000000 then do; 
put (DIGITS[*]) (=/);
output;
stop;
keep D:;
end;
run;


libname x BASE "X:\";
data a_set;
set x.pi end=EOF;
 i = input(substr(cyfra,1,1),best.);
 array DIGITS[0:9] DIGITS0-DIGITS9;

    if i ne . then DIGITS[i]+1;

if EOF then do; 
put (DIGITS[*]) (=/);
output;
stop;
keep D:;
end;

run;











/** INDEKSY **/
/*
- struktura stowarzyszona ze zbiorem danych umozliwiajaca dostep do obserwacji 
  przez wartosci (bez koniecznosci czytania sekwencyjnego)

- indeks sklada sie z elementow przechowywanych w porzadaku wyznaczonym 
  przez zmienne kluczowe:

  key val  record identifier (RID)
  1234     17(80, 86) 
  2345     17(84)
  3456     12(43, 44, 51, 53)
  klucz    strona(obserwacja)

- moze przyspieszyc dostep do podzbioru danych, 
  szczegolnie gdy ten jest stosunkowo niewielki (WHERE)
- zabiera przestrzen dyskowa i pamiec
- polecany dla duzych zbiorow danych
- zwraca obserwacje posortowane -> BY statement
- do wykonywania table look-ups -> SET statement with KEY= option
- do laczenia obserwacji -> PROC SQL
- do modyfikowania obserwacji -> MODIFY statement with KEY= option

- zbior i jego plik z indeksami, sa przechowywane w tej samej lokalizacji
*/


/*** PRZETWARZANIE POINDEKSOWANEGO ZBIORU: ***/

    data Zbior_Wyjsciowy;
     set Zbior_Wejsciowy;
     where Zmienna = 1234;
    end;
/*
1. SAS laduje do pamieci i sprawdza plik indeksowy:
   - przeszukiwanie binarne:
    - SAS sprawdza, w ktorej polowce indeksu znajduje sie podany nr zmiennej Zmienna 
    - dalej sprawdza, w ktorej polowce tej polowki znajduje sie wartosc, itd.
    - jak znajdzie, sprawdza, ktore strony zawieraja ten numer

2. SAS laduje do buforow tylko potrzebne strony (zmniejsza sie I/O) - dodatkowo, jeœli dane
   sa posortowane po zmiennych kluczowych albo obserwacje z tymi samymi wartosciami zmiennych 
   kluczowych sa blisko siebie

3. WHERE statement uzywa RID do bezposredniego zlokalizowania obserwacji -> PDV
*/


options FULLSTIMER MSGLEVEL = I; 

/** TWORZENIE INDEKSOW **/

/* dane -> plik kraje.sas */


data zbiory.bez_indeksu(compress=char);
set zbiory.kraje;
format date yymmdds10.;
do date = '1jan1976'd to today();
 y=year(date);
 m=month(date);
 d=day(date);
 s="N";
 pomiar = 123 + round(rannor(123)*25,0.01);
  _suma_ + pomiar;
  _iterator_ + 1;
  drop _:;
 output;
 if m=12 and d=31 then /* "podsumowanie" roczne */
 do;
  call missing(m,d,y);
  s="Y";
  pomiar = round(_suma_ / _iterator_,0.001);
  output;
 end;
end;
run;



/* 1. w data stepie */

data zbiory.indeks_i1
    (index = (
              y                                     /* prosty  */
              m                   
              kraj
              date_kraj_s = (date kraj s) / unique  /* zlozony */
              y_m = (y m)
             )
    compress=char);
 set zbiory.bez_indeksu;
run;


/* end of lecture 9 */ /* 5104 */
/* end of lecture 9 */ /* 5104 */

/*
mamy 2 rodzaje indeksow: 
    prosty (jedna zmienna - nazwa musi byc taka jak nazwa zmiennej) 
    zlozony (wiele zmiennych - wlasna nazwa)
*/

data zbiory.indeks_i1x
    (index = (
              tylko_kraj = (kraj)
             )
    compress=char);
 set zbiory.bez_indeksu;
run;



/*
  / UNIQUE option - nie pozwala na tworzenie indeksu, gdy wiecej niz 1 obserwacja 
                    ma te sama wartosc dla zmiennych klucza
  / NOMISS option - braki danych nie wchodza do indeksu (nadal sa czytane, ale nie poprzez indeks)
*/

data zbiory.indeks_i1_NU
    (index = (
              y                     
              m                   
              y_m=(y m)  / UNIQUE  /* <- co jest gdy nieunikalny */
             )
    compress=char);
 set zbiory.bez_indeksu;
run;



data zbiory.indeks_i1_MI
    (index = (
              y                     
              m    / NOMISS               
              d    / NOMISS
             )
    compress=char);
 set zbiory.bez_indeksu;
run;



data test1;
set zbiory.indeks_i1_MI;
where m = 1 and d = 1;
run;


data test2;
set zbiory.indeks_i1_MI;
where m <= 1 and d <= 1;
run;





/* usuwanie indeksow */

data zbiory.indeks_i1;
 set zbiory.indeks_i1;
run;
/* utworzenie zbioru na nowo kasuje indeksy (wszystkie!) */


proc sort data = zbiory.indeks_i1_nu;
by y m kraj;
run;
/* bez opcji force indeks blokuje sortowanie */

proc sort data = zbiory.indeks_i1_nu FORCE;
by y m kraj;
run;
/* posortowanie zbioru z opcja FORCE kasuje indeksy (wszystkie!) */






data zbiory.indeks_i1
    (index = (
              y                                     /* prosty  */
              m                   
              kraj
              date_kraj_s = (date kraj s) / unique  /* zlozony */
              y_m = (y m)
             )
    compress=char);
 set zbiory.bez_indeksu;
run;


/* czas przetwarzania */
data czas_bez_indeksu;
set  zbiory.bez_indeksu;
where y=1994 and m=7;
run;

data czas_z_indeksem;
set  zbiory.indeks_i1;
where y=1994 and m=7;
run;











/*
2. proc DATASETS

+ dodatkowe indeksy moga byc tworzone bez koniecznosci ponownego tworzenia starych
+ indeksy moga byc kasowane osobno
*/
data zbiory.indeks_i2(compress=char);
set zbiory.bez_indeksu;
run;




proc datasets library = zbiory nolist;
 modify indeks_i2;
  index create y;
  index create m;
  index create kraj;
 run;
quit;




proc contents data = zbiory.indeks_i2; 
run;




proc datasets library = zbiory nolist;
 modify indeks_i2;
  index create date_kraj_s = (date kraj s) / unique;
  index create y_m = (y m);
 run;
quit;






ods html;
proc contents data = zbiory.indeks_i2;
run;





proc datasets library = zbiory nolist;
 modify indeks_i2;
   index delete y;
 run;
 modify indeks_i2;
   index delete m y_m;
/* index delete _all_; */
 run;
quit;




ods html;
proc contents data = zbiory.indeks_i2;
run;









/* jesli zbior jest posortowany to tworzenie indeksu moze byc szybsze */
data zbiory.indeks_i3(compress=char);
set zbiory.bez_indeksu;
run;

ods html;
proc datasets library = zbiory nolist;

 modify indeks_i3;
   index create kraj;
 run;



 contents data = indeks_i3;
 run;



 modify indeks_i3;
   index delete kraj;
 run;



 contents data = indeks_i3;
 run;



 modify indeks_i3(SORTEDBY=kraj date); /* zbior wejsciowy KRAJE jest posortowany */
   index create kraj;
 run;



 contents data = zbiory.indeks_i3;
 run;
quit;





/* co jeszcze tam siedzi? */
ods html;
proc contents data = zbiory.indeks_i2 centiles; /* cumulative percentiles - 21 */
run;


data test1(index = (i)
             );
do i = 0 to 100;
output;
end;
run;
ods html;
proc contents data = test1 centiles; /* cumulative percentiles - 21 */
run;





data zbiory.update(compress=char);
set zbiory.kraje;
format date yymmdds10.;
do date = today()+1 to today()+500;
 y=year(date);
 m=month(date);
 d=day(date);
 s="N";
 pomiar = 123 + round(rannor(123)*25,0.01);
  _suma_ + pomiar;
  _iterator_ + 1;
  drop _:;
 output;
 if m=12 and d=31 then /* "podsumowanie" roczne */
 do;
  call missing(m,d,y);
  s="Y";
  pomiar = round(_suma_ / _iterator_,0.001);
  output;
 end;
end;
run;




proc append base = zbiory.indeks_i2 data = zbiory.update;
run;


ods html;
proc contents data = zbiory.indeks_i2 centiles; /* cumulative percentiles - 21 */
run;

data _null_;
x = 20935;
put x date9.;
run;






data zbiory.update2(compress=char);
set zbiory.kraje;
format date yymmdds10.;
do date = today()+501 to today()+1000;
 y=year(date);
 m=month(date);
 d=day(date);
 s="N";
 pomiar = 123 + round(rannor(123)*25,0.01);
  _suma_ + pomiar;
  _iterator_ + 1;
  drop _:;
 output;
 if m=12 and d=31 then /* "podsumowanie" roczne */
 do;
  call missing(m,d,y);
  s="Y";
  pomiar = round(_suma_ / _iterator_,0.001);
  output;
 end;
end;
run;





proc append base = zbiory.indeks_i2 data = zbiory.update2;
run;


ods html;
proc contents data = zbiory.indeks_i2 centiles; /* cumulative percentiles - 21 */
run;




proc datasets library = zbiory nolist;

 modify indeks_i2;
   INDEX CENTILES date_kraj_s / REFRESH;

   INDEX CENTILES kraj / UPDATECENTILES = 13; /* ALWAYS=0, 1, 2 ... 99, 100, NEVER=101 */ 

   INDEX CREATE date;
   INDEX CENTILES date / UPDATECENTILES = NEVER; /* ALWAYS=0, 1, 2 ... 99, 100, NEVER=101 */

 run;



 contents data = indeks_i2 centiles;
 run;

quit;








/* 3. SQL */
proc sql feedback;
 create table zbiory.indeks_i4(compress=char) as
 select 
     BEZ_INDEKSU.kraj
   , BEZ_INDEKSU.date
   , BEZ_INDEKSU.y
   , BEZ_INDEKSU.m
   , BEZ_INDEKSU.d
   , BEZ_INDEKSU.s
   , BEZ_INDEKSU.pomiar
 from ZBIORY.BEZ_INDEKSU
 ;


 CREATE INDEX date
 ON zbiory.indeks_i4 /* zbiory.indeks_i3(date) */
 ;


 CREATE UNIQUE INDEX date_kraj_s
 ON zbiory.indeks_i4(date, kraj, s) /* <- Przecinek rozdziela pola! */
 ;


 DROP INDEX date
 FROM zbiory.indeks_i4
 ;
quit;





proc sql;
drop index _ALL_ /* UWAGA! */
from zbiory.indeks_i4
;
quit;



proc datasets lib = zbiory nolist;
 modify indeks_i4;
  index delete _ALL_;
 run;
quit;

options IBUFSIZE=0; /* 0 oznacza domyslny rozmiar strony indeksu */

proc sql;
 CREATE UNIQUE INDEX date_kraj_s
 ON zbiory.indeks_i4(date, kraj, s) 
 ;
quit;


proc contents data = zbiory.indeks_i4;
run;



proc datasets lib = zbiory nolist;
 modify indeks_i4;
  index delete _ALL_;
 run;
quit;

options IBUFSIZE=MAX; /* maksymalny (32kB) rozmiar strony indeksu */

proc sql;
 CREATE UNIQUE INDEX date_kraj_s
 ON zbiory.indeks_i4(date, kraj, s) /* <- Przecinek rozdziela pola! */
 ;
quit;


proc contents data = zbiory.indeks_i4;
run;


options IBUFSIZE=0;









/* co pojawia sie w logu? */
proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.bez_indeksu
where '13may2015'd < date < '17may2015'd
;
quit;

proc sql;
create index date
on zbiory.indeks_i1;
quit;

proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1
where '13may2015'd < date < '17may2015'd
;
quit;




/* Kiedy SAS moze uzyc indeksu? */

proc datasets library = zbiory nolist;
 modify indeks_i1;
  index delete _all_;
 run;
 modify indeks_i1;
  index create k_d = (kraj date);

  index create y m d;

 run;
quit;



/* czy SAS uzyje tu indeksu? */
proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1
where '13may2015'd < date < '17may2015'd
;
quit;

/* nie, bo 'date' jest druga zmienna w indeksie zlozonym */

/* uzyje np. teraz */
proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1
where '13may2015'd < date < '17may2015'd and kraj = 'Poland [POL]'
;
quit;


proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1
where '13may2015'd < date < '17may2015'd and substr(kraj,1,1) between "A" and "Z"
;
quit;

/*
- SAS wybiera najlepszy indeks z dostepnych 
    -> estymacja kwalifikujacych sie obserwacji 
        -> oszacowanie zuzycia zasobow przy 
           czytaniu sekwencyjnym vs korzystaniu z indeksu

- SAS uzywa tylko jednego indeksu, nawet jesli w warunku wyst. 2 potencjalnie dobre zmienne
- SAS sprawdza, czy indeks jest bardziej efektywny niz czytanie sekwencyjne
- jesli SAS oszacuje, ze najwyzej 30% obs. sie kwalifikuje, uzyje indeksu
- jesli SAS oszacuje, ze najwyzej 3% obserwacji sie kwalifikuje uzyje indeksu bez szacowania zasobow

w WHERE statement jesli zmienna jest zmienna kluczowa dla indeksu prostego, 
albo wyst. jako pierwsza w kluczu zlozonym SAS bedzie sprawdzal czy uzyc indeksu
*/



/* czy indeks zadziala tu: */
data test;
 set zbiory.indeks_i1;
 where 1982 <= y <= 2006; 
run;

/* nie - za duzo obserwacji sie kwalifikuje
- indeksy sa najbardziej efektywne, gdy uzywane sa do wylaczania ponizej 15% danych
- gdy powyzej 1/3 obs. spelnia war., indeks zazwyczaj nie zostanie uzyty 
- posortowanie danych moze czasmi pomoc 
*/

proc sort data = zbiory.indeks_i1 out = zbiory.indeks_i1_sort(compress = char);
by y m d date kraj;
run;

proc datasets library = zbiory nolist;
 modify indeks_i1_sort;
  index create k_d = (kraj date);

  index create y m d kraj date;

 run;
quit;


data test;
 set zbiory.indeks_i1_sort;
 where 1982 <= y <= 2016; 
run;




data test;
 set zbiory.indeks_i1;
 where 1982 <= y <=1992;
run;

/* teraz */
data _null_;
 set zbiory.indeks_i1;
 where 1982 <= y <=1991;
run;



/*  */
data test;
 set zbiory.indeks_i1_sort;
 where 1982 <= y <=1992;
run;

/*  */
data _null_;
 set zbiory.indeks_i1_sort;
 where 1982 <= y <=1993;
run;

/*  */
data _null_;
 set zbiory.indeks_i1_sort;
 where 1982 <= y <=1994;
run;


data _null_;
 set zbiory.indeks_i1_sort;
 where 1982 <= y <= 1997;
run;
data _null_;
 set zbiory.indeks_i1_sort;
 where 1982 <= y <= 1998;
run;



/* a teraz? */
data test;
 set zbiory.indeks_i1;
 if 1982 <= y <=1984;
run;


/* nie - zly timing - if nie bierze pod uwage indeksow */



/*
weryfikacja czy indeks zostanie uzyty (szacowane sa I/Osy) jest nastepijaca:

1) oszacuj na podstawie centyli liczbe obserwacji (z dokladnoscia do 5%), 
   ktore sie kwalifikuja
2) oszacuj "posortowalnosc" zbioru - zliczajac ilosc stron na jakie wskazuja RIDy,
   podzielona przez liczbe RIDow na pierwszej czytanej stronie (to jest koszt I/Osow na RIDa)
3) przemnoz koszt I/Osow na RIDa (2) przez ilosc zakwalifikowanych obserwacji (1) 
   do oszacowania liczby stron, ktore trzeba wczytac jesli uzyje sie indeksu.
*/




/* dla kluczy zlozonych */
/* co teraz? */

proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1
where '13may2015'd < date < '17may2015'd    OR    kraj = 'Poland [POL]'
;
quit;

/* nie, bo jest 'OR' z dwiema roznymi zmiennymi */



data _null_;
set  zbiory.indeks_i1;
where '13may2015'd < date < '17may2015'd   
  and  (kraj = 'Poland [POL]' or kraj = 'San Escobar [SER]')
;
run;

/*
polaczone warunkiem AND lub OR, ale OR musi dotyczyc tej samej zmiennej
co najmniej jeden warunkek musi byc typu "=" albo "in"

OR na warto?ciach jest ok, na zmiennych niekoniecznie...
*/

data _null_;
set  zbiory.indeks_i1;
where '13may2015'd < date < '17may2015'd   
  and  (kraj between 'Poland [POL]' and 'San Escobar [SER]')
;
run;



options FULLSTIMER MSGLEVEL = I; 
/*
DATA SET OPTIONS - jesli znamy dane i chcemy oszczedzic SAS-owi sprawdzania, co jest lepsze
- IDXWHERE=yes - zawsze uzyj indeksu (wybierz najlepszy)
- IDXWHERE=no - nigdy nie uzywaj indeksu
- IDXNAME=<nazwa indeksu> - uzyj konkretnego indeksu
*/


proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1(IDXWHERE=yes)       /* (!) */ 
where '13may2015'd < date < '17may2015'd
;
quit;


proc sql;
select sum(pomiar) as SP, count(1) as i
from zbiory.indeks_i1(IDXNAME=k_d)        /* (!!) */ 
where '13may2015'd < date < '17may2015'd
;
quit;




/* dodajmy sobie index */
proc sql;
create index date on zbiory.indeks_i1(date);
quit;


/* i co teraz? */
data _null_;
set  zbiory.indeks_i1;
where (today() - 365) = date 
;
run;



data _null_;
set  zbiory.indeks_i1;
where %sysevalf(%sysfunc(today()) - 365) = date
;
run;



data _null_;
set  zbiory.indeks_i1(IDXNAME=date);
where date = (today() - 365)
;
run;







data _dummy_;
x=.;
run;


proc sql feedback _method;
select count(1) as i
from
zbiory.indeks_i1
where
date in (select today()-365 as d from _dummy_)
;
quit;




proc sql feedback _method;
select count(1) as i
from
zbiory.indeks_i1
where
date = (select today()-365 as d from _dummy_)
;
quit;






proc sql feedback _method;
select count(1) as i
from
zbiory.indeks_i1(IDXNAME=date)
where
date in (select today()-365 as d from _dummy_)
;
quit;







proc sql feedback _method;
select count(1) as i
from
 zbiory.indeks_i1
,(select today()-365 as d from _dummy_) as d
where d.d = indeks_i1.date
;
quit;



/* end of lecture 10 */ /* line 5902 */
/* end of lecture 10 */ /* line 5902 */


proc sql feedback _method;
select count(1) as i
from
zbiory.indeks_i1
join
(select today()-365 as d from _dummy_) as d
on d.d = indeks_i1.date
;
quit;



libname x "X:\";

%let _data_ = "%sysfunc(today(),yymmddn8.)";
%put *&_data_.*;

data IDXWHERE_yes;
set x.pi(IDXWHERE=yes);
where cyfra = &_data_.;
run;


data IDXWHERE_no;
set x.pi(IDXWHERE=no);
where cyfra = &_data_.;
run;


data IDXNAME;
set x.pi(IDXNAME=cyfra);
where cyfra = &_data_.;
run;



/*
WSKAZOWKI:
- uzywac na duzych zbiorach do ekstraktowania malych podzbiorow
- na zmiennych, ktore maja duzo roznych poziomow
- posortowac zbior przed indeksowaniem (o ile ma to sens)
*/



/*
INDEX + BY statement - zbior nie musi byc posortowany
*/

data t1(index=(klucz));
do i = 1 to 10000;
 klucz = ceil(100 * ranuni(123));
 output;
end;
run;

data t2(index=(klucz));
length klucz 8 wybrany $ 3;
wybrany = 'TAK';

klucz = 97; output;
klucz = 17; output;
klucz = 74; output;
klucz =  3; output;
klucz = 19; output;
klucz = 24; output;
klucz = 64; output;
run;



proc contents data = t1;
run;
proc contents data = t2;
run;

/* zbiory t1 i t2 nie sa posortowane */

data t2s;
 set t2;
 by klucz;
run;


data t12s(where = (wybrany = 'TAK'));
 merge t1 t2;
 by klucz;
run;


/* SAS uzyl indeksu, a jako efekt uboczny zwrocil zbior posortowany 
   rosnaco wzgledem zmiennej klucz                                  */
/* mozna w ten sposob sortowac bez koniecznosci uzywania proc sort  */
/* zmienne .first i .last odnosza sie do rosnacego posortowania     */

/* SAS nie uzyje indeksu z opcja descending */
data t2sd;
 set t2;
 by descending klucz;
run;



/* WHERE, BY i INDEKSY */
options fullstimer msglevel = I;

data WBI(index=(I J));
do i = 100 to 1 by -1;
 do j = 100 to 1 by -2, 1 to 99 by 2;
  output;
 end;
end;
run;


data WBI2;
set WBI;
by j;
where i between 11 and 13;
run;


/* BY ma wyzszy priorytet dla indeksu niz WHERE */





/* rozne takie tam oczywistosci */
/* 1) */
data zbiory.ijk(index=(klucz I_J=(I J)));
do i = 1 to 100;
 do j = 1 to 100;
  klucz = ceil(100 * ranuni(123));
  output;
 end;
end;
run;

proc delete data = zbiory.ijk; /* skasowanie zbioru */
run;

 
/* 2) */
data zbiory.ijk(index=(klucz I_J=(I J)));
do i = 1 to 100;
 do j = 1 to 100;
  klucz = ceil(100 * ranuni(123));
  output;
 end;
end;
run;

proc datasets lib = zbiory nolist;
 change ijk = abc; /* zmiana nazwy zbioru */
 run;
quit;


/* 3) */
proc datasets lib = zbiory nolist;
 modify abc; 
  rename klucz = k; /* zmiana nazwy zmiennej indeksu prostego */
 run;
quit;


/* 4) */
proc datasets lib = zbiory nolist;
 modify abc; 
  rename j = dzej; /* zmiana nazwy zmiennej indeksu zlozonego */
 run;
quit;
 








/* NAPRAWIANIE ZEPSUTEGO INDEKSU */
options FULLSTIMER MSGLEVEL = I;
data zbiory.ijk_interactive(index=(klucz I_J=(I J))) zbiory.ijk_interactive2;
do i = 1 to 100;
 do j = 1 to 100;
  klucz = ceil(100 * ranuni(123));
  output;
 end;
end;
run;



/* kasujemy[fizycznie] plik z indeksem */
/* options NOXWAIT; */
x ERASE C:\SAS_WORK\ZBIORY\ijk_interactive.sas7bndx; /*Win*/
/* x rm ~/SAS_WORK/ZBIORY/ijk_interactive.sas7bndx; */ /*UNIX/Linux*/


data test;
set zbiory.ijk_interactive; 
where j > 93;
run;

proc sql noprint;
select count(1) as i
into :_III_ trimmed
from
zbiory.ijk_interactive2
where j > 93;
quit;

%put **&_III_.**;










/* DeLete DaMaGe ACTION */
%put **%sysfunc(getoption(DLDMGACTION))**;

options DLDMGACTION = REPAIR ;/* FAIL | ABORT | REPAIR | NOINDEX | PROMPT */
/* lub dataset option */


data 
zbiory.ijk_FAIL(index=(klucz I_J=(I J)))
zbiory.ijk_ABORT(index=(klucz I_J=(I J)))
zbiory.ijk_REPAIR(index=(klucz I_J=(I J)))
zbiory.ijk_NOINDEX(index=(klucz I_J=(I J)))
zbiory.ijk_PROMPT(index=(klucz I_J=(I J)))
;
do i = 1 to 100;
 do j = 1 to 100;
  klucz = ceil(100 * ranuni(123));
  output;
 end;
end;
run;


options NOXWAIT;
x ERASE C:\SAS_WORK\ZBIORY\ijk_FAIL.sas7bndx;
x ERASE C:\SAS_WORK\ZBIORY\ijk_ABORT.sas7bndx;
x ERASE C:\SAS_WORK\ZBIORY\ijk_REPAIR.sas7bndx;
x ERASE C:\SAS_WORK\ZBIORY\ijk_NOINDEX.sas7bndx;
x ERASE C:\SAS_WORK\ZBIORY\ijk_PROMPT.sas7bndx; /*Win*/

/* 
x rm ~/SAS_WORK/ZBIORY/ijk_FAIL.sas7bndx; 
x rm ~/SAS_WORK/ZBIORY/ijk_ABORT.sas7bndx;
x rm ~/SAS_WORK/ZBIORY/ijk_REPAIR.sas7bndx;
x rm ~/SAS_WORK/ZBIORY/ijk_NOINDEX.sas7bndx;
x rm ~/SAS_WORK/ZBIORY/ijk_PROMPT.sas7bndx; */ /*UNIX/Linux*/


data test1;
set zbiory.ijk_FAIL(DLDMGACTION = FAIL);
run;

data test2;
set zbiory.ijk_ABORT(DLDMGACTION = ABORT);
run;

data test3;
set zbiory.ijk_REPAIR(DLDMGACTION = REPAIR);
run;

data test4;
set zbiory.ijk_NOINDEX(DLDMGACTION = NOINDEX);
run;

data test5;
set zbiory.ijk_PROMPT(DLDMGACTION = PROMPT);
run;






proc datasets lib = zbiory nolist;
 REBUILD ijk_NOINDEX;
 run;
quit;
/* moze wymagac zamkniecia okienka explorera */


proc datasets lib = zbiory nolist;
 REBUILD ijk_NOINDEX / NOINDEX; 
 run;
quit;



/*
REBUILD SAS-file  </ <ENCRYPTKEY=key-value>
<ALTER=password> <GENNUM=n> <MEMTYPE=member-type> <NOINDEX>>; 
*/








/* nie mylic z REPAIR, bo REPAIR tutaj nie pomoze */
proc datasets lib = zbiory nolist;
 REPAIR ijk_NOINDEX;
 run;
quit;






/* INTEGRITY CONSTRAINTS */

/* pomocnicze zbiory SASowe */
data zbiory.dict_poziom;
infile cards dlm = '|';
input poziom poziom_nazwa $ :100.;
cards;
1|Szeregowy Œwie¿ynka
2|Pierfsza kref
3|Szacun na kompañji
4|Ot'dzia³owy celebryta
5|Czempjon
6|Krzysztof Jarzyna ze Szczecina - Szef wszystkich szefów
;
run;

data zbiory.dict_swiat;
infile cards dlm = '|';
input swiat swiat_nazwa $ :50.;
cards;
1|Pó³nocne Morze
2|Po³udniowe Góry
3|Wschodnie Lasy
4|Zachodnie Równiny
5|Centralne Bagna
;
run;


data x;
length label $ 100;

set zbiory.dict_poziom(rename=(poziom=start poziom_nazwa=label)) end=last;
retain fmtname 'poziom_nazwa' type 'n';
output;
 
    if last then do;
     hlo='O';
     label='!!!ERROR!!!';
     output;
    end;
run;
proc format library=zbiory cntlin=x;
run;

data x;
length label $ 100;

set zbiory.dict_swiat(rename=(swiat=start swiat_nazwa=label)) end=last;
retain fmtname 'swiat_nazwa' type 'n';
output;
 
    if last then do;
     hlo='O';
     label='!!!ERROR!!!';
     output;
    end;
run;
proc format library=zbiory cntlin=x;
run;

options fmtsearch=(zbiory work);

data
zbiory.gracz_poziom(keep = id poziom_aktualny_od poziom_aktualny_do poziom)
zbiory.gracz_swiat(keep = id swiat_aktualny_od swiat_aktualny_do swiat)
;
format 
id Z8. 
poziom_aktualny_od poziom_aktualny_do swiat_aktualny_od swiat_aktualny_do yymmdd10.
swiat swiat_nazwa.
poziom poziom_nazwa.
;

do id = 1 to 1E1; /* <- do zmiany rozmiaru */
 poziom_aktualny_od = '14mar2015'd + ceil(100 * ranuni(10));
 swiat_aktualny_od = poziom_aktualny_od;
 /* poziomy gracza w czasie */
 lp = ceil(6 * ranuni(10)); drop lp;
 do poziom = 1 to lp;
  poziom_aktualny_do = ifn(poziom = lp, '31dec9999'd, poziom_aktualny_od + 250 + ceil(50 * ranuni(10)));
  output zbiory.gracz_poziom;
  poziom_aktualny_od =  poziom_aktualny_do + 1;
 end;
/* swiat gry gracza w czasie */
 lp = ceil(5 * ranuni(10)); drop lp;
 do swiat_lp = 1 to lp;
  swiat_aktualny_do = ifn(swiat_lp = lp, '31dec9999'd, swiat_aktualny_od + 220 + ceil(20 * ranuni(10)));
  swiat = ceil(5 * ranuni(10));
  output zbiory.gracz_swiat;
  swiat_aktualny_od =  swiat_aktualny_do + 1;
 end;
end;

run;




proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_notnull = not null(poziom); 
 run;
quit;





proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_unique = unique(poziom); 
 run;
quit;




proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_check1 = check(poziom > 0); 
 run;
quit;




proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_check1 = check(where poziom > 0); 
 run;
quit;





proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_check1 = check(where = (poziom > 0)); 
 run;
quit;





data nowy_poziom1;
length poziom 8 poziom_nazwa $ 100;
poziom = .;
poziom_nazwa = "Nieistniejacy poziom";
run;

proc append BASE = zbiory.dict_poziom DATA = nowy_poziom1;
run;



data nowy_poziom2;
length poziom 8 poziom_nazwa $ 100;
poziom = 1;
poziom_nazwa = "Szeregowy 'Œwie¿e Miêsko'";
run;

proc append BASE = zbiory.dict_poziom DATA = nowy_poziom2;
run;




data nowy_poziom3;
length poziom 8 poziom_nazwa $ 100;
poziom = 0;
poziom_nazwa = "Kadet";
run;

proc append BASE = zbiory.dict_poziom DATA = nowy_poziom3;
run;







proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_pk = primary key(poziom)
    message = "Wartosci pola musza byc NIEPUSTE! i UNIKALNE!" /* wiadomosc dla uzytkownika od autora */
  ; 
 run;
quit;



data nowy_poziom12;
length poziom 8 poziom_nazwa $ 100;
poziom = .;
poziom_nazwa = "Nieistniejacy poziom";
output;
poziom = 1;
poziom_nazwa = "Szeregowy 'Œwie¿e Miêsko'";
output;
run;

proc append BASE = zbiory.dict_poziom DATA = nowy_poziom12;
run;








proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_pk = primary key(poziom)
    message = "Wartosci pola musza byc NIEPUSTE! i UNIKALNE baranie!" /* wiadomosc dla uzytkownika od autora */
    msgtype = USER                                            /* i tylko ona, bez SASowego gadania   */
  ; 
 run;
quit;





proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic delete poprawne_poziomy_pk; /* kasowanie konkretnego integrity constreintsa */
 run;










 modify dict_poziom;
  ic delete _ALL_; /* kasowanie wszystkich integrity constreintsow */
 run;
quit;





proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create poprawne_poziomy_pk = primary key(poziom)
    message = "Wartosci pola musza byc NIEPUSTE! i UNIKALNE!" /* wiadomosc dla uzytkownika od autora */
    msgtype = USER                                            /* i tylko ona, bez SASowego gadania   */
  ; 
 run;
quit;

proc append BASE = zbiory.dict_poziom DATA = nowy_poziom12;
run;






proc datasets lib = zbiory nolist;
 modify gracz_poziom;
  ic create gracz_poziom_pk = primary key(id poziom)
    message = "Wartosci pola musza byc NIEPUSTE! i UNIKALNE!"
    msgtype = USER                                             
  ; 
 run;




 modify gracz_poziom;
  ic create poziom_nn = not null(poziom)
    message = "Wartosci pola musza byc NIEPUSTE!"
    msgtype = USER                                             
  ; 
 run;
 /* 
    na zmiennych uzywanych w PK nie trzeba nakladac warunku Not Null
 */




 modify gracz_poziom;
  ic create poziom_aktualny_od_nn = not null(poziom_aktualny_od); 
  ic create poziom_aktualny_do_nn = not null(poziom_aktualny_do);
  ic create poziom_aktualny_od_ch1 = check(where=(poziom_aktualny_od < poziom_aktualny_do));
 run;




 modify gracz_poziom;
  ic create poziom_ch1 = check(where=(1 le poziom le 6));
 run;

quit;





data nowy_gracz1;
format 
id Z8. 
poziom_aktualny_od poziom_aktualny_do yymmdd10.
poziom poziom_nazwa.
;
id = 113; 
poziom_aktualny_od = today();
poziom_aktualny_do = '31dec9999'd;
poziom = 7;
run;

proc append BASE = zbiory.gracz_poziom data = nowy_gracz1;
run;







data nowy_poziom99;
length poziom 8 poziom_nazwa $ 100;
poziom = 99;
poziom_nazwa = "Król Julian";
run;

proc append BASE = zbiory.dict_poziom DATA = nowy_poziom99;
run;



proc datasets lib = zbiory nolist;
 modify gracz_poziom;
  ic delete poziom_ch1;
  ic create poziom_ch99 = check(where=(1 le poziom le 99));
 run;
quit;

proc contents data = zbiory.gracz_poziom;
run;





proc append BASE = zbiory.gracz_poziom data = nowy_gracz1;
run;



data zbiory.gracz_poziom;
set zbiory.gracz_poziom;
if poziom = 7 then delete;
run;

proc contents data = zbiory.gracz_poziom;
run;
/* skasowalismy sobie wszystkie IC :-( 
   ale spokojnie nauczymy sie jak modyfikowac zbior bez robienia "balaganu" 
*/







proc datasets lib = zbiory nolist;
 modify gracz_poziom;
  ic create gracz_poziom_pk = primary key(id poziom);
  ic create poziom_aktualny_od_nn = not null(poziom_aktualny_od); 
  ic create poziom_aktualny_do_nn = not null(poziom_aktualny_do);
  ic create poziom_aktualny_od_ch1 = check(where=(poziom_aktualny_od < poziom_aktualny_do));
 run;



 modify gracz_poziom;
  ic create poziom_fk = foreign key (poziom) REFERENCES zbiory.dict_poziom;
 run;

quit;



proc append BASE = zbiory.gracz_poziom data = nowy_gracz1;
run;


proc contents data = zbiory.gracz_poziom;
run;


/* FOREIGN KEY (variables) REFERENCES table-name 
   <ON DELETE referential-action: RESTRICT[default]|SET NULL> 
   <ON UPDATE referential-action: RESTRICT[default]|SET NULL|CASCADE> 
*/


proc datasets lib = zbiory nolist;
 modify gracz_poziom;
  ic delete _all_;
 run;
 modify dict_poziom;
  ic delete _all_;
 run;
quit;


proc datasets lib = zbiory nolist;
 modify gracz_poziom;
  ic create poziom_fk = foreign key (poziom) REFERENCES zbiory.dict_poziom;
 run;
quit;



/* zbior, do ktorego referujemy, musi(!) miec klucz glowny */



proc datasets lib = zbiory nolist;
 modify dict_poziom;
  ic create primary key (poziom); /* <- defaultowa nazwa _PK0001_ */
 run;

 modify gracz_poziom;
  ic create poziom_fk = foreign key (poziom) REFERENCES zbiory.dict_poziom;
 run;
quit;





/* ON DELETE RESTRICT */
data zbiory.dict_poziom;
modify zbiory.dict_poziom; /* <- MODIFY statement, omowimy za chwile */
if poziom = 6 then REMOVE;
run;



data zbiory.dict_poziom;
modify zbiory.dict_poziom;
if poziom ^= 6 then output;
run;


/* ON UPDATE RESTRICT */
data zbiory.dict_poziom;
modify zbiory.dict_poziom; 
if poziom = 6 then poziom = 66;
run;




proc datasets lib = zbiory nolist;

 modify dict_poziom;
  ic delete _ALL_; /* uwaga na loga! */
 run;
 modify gracz_poziom;
  ic delete _ALL_;
 run;



/* wlasciwa kolejnosc */
 modify gracz_poziom;
  ic delete _ALL_; /* najpierw kasujemy referencje */
 run;
 modify dict_poziom;
  ic delete _ALL_; /* potem PK na referowanym zbiorze */
 run;
/**********************/


 modify dict_poziom;
  ic create primary key (poziom);
 run;

 modify gracz_poziom;
  ic create poziom_fk = foreign key (poziom) REFERENCES zbiory.dict_poziom
   ON DELETE SET NULL 
   ON UPDATE SET NULL
  ;
 run;
quit;



/* ON DELETE SET NULL */
data zbiory.dict_poziom;
modify zbiory.dict_poziom;
if poziom = 6 then REMOVE;
run;



/* ON UPDATE SET NULL */
data zbiory.dict_poziom;
modify zbiory.dict_poziom; 
if poziom = 1 then poziom = 11;
run;








proc datasets lib = zbiory nolist;
 modify gracz_poziom;
  ic delete _ALL_; /* najpierw kasujemy referencje */
 run;
 modify dict_poziom;
  ic delete _ALL_; /* potem PK na referowanym zbiorze */
 run;

 modify dict_poziom;
  ic create primary key (poziom);
 run;

 modify gracz_poziom;
  ic create poziom_fk = foreign key (poziom) REFERENCES zbiory.dict_poziom
   ON UPDATE CASCADE
  ;
 run;
quit;



/* ON UPDATE CASCADE */
data zbiory.dict_poziom;
modify zbiory.dict_poziom; 
if poziom < 99 then poziom = poziom * 11;
run;




data zbiory.dict_poziom;
modify zbiory.dict_poziom; 
poziom = poziom / 11;
run;


/* end of lecture 11 */ /* 6792 */

/* zbior wejsciowy */
data work.dict_swiat;
infile cards dlm = '|';
input swiat swiat_nazwa $ :50.;
cards;
1|Pólnocne Morze
2|Poludniowe Góry
3|Wschodnie Lasy
4|Zachodnie Równiny
5|Centralne Bagna
;
run;

/* dodawanie warunkow */
proc datasets lib = work;
modify dict_swiat;
 ic create unique(swiat);
 ic create not null(swiat);
 ic create check(where = (swiat > 0));
run;
quit;

/* nowe obserwacje do dodania */
data _fail_;
length swiat 8 swiat_nazwa $ 50;
swiat = 1;  swiat_nazwa = "Taki juz istnieje"; output;       /* <- zla   */
swiat = .;  swiat_nazwa = "Pusty swiat"; output;             /* <- zla   */
swiat = 6;  swiat_nazwa = "Nowy Wspanialy Swiat"; output;    /* <- dobra */
swiat = -1; swiat_nazwa = """Podziemia - piwnica"""; output; /* <- zla   */
swiat = 7;  swiat_nazwa = "Discworld"; output;               /* <- dobra */
run;


/* dodajemy obserwacje */
proc append base = work.dict_swiat data =_fail_;
run;

/* podglad obserwacji logicznych i fizycznych */
data _null_;
dsid = open("work.dict_swiat");

obserwacje_fizyczne = ATTRN(dsid,"NOBS"); /* <- ATTRN i jej siostra ATTRC - bardzo przydatne funkcje */

obserwacje_logiczne = attrn(dsid,"NLOBS");

IC = attrn(dsid,"ICONST");

put "Przed przepisaniem zbioru:";
put obserwacje_fizyczne= obserwacje_logiczne= IC=;
rc = close(dsid);
stop;
run;


data test1;
point = 7;
set work.dict_swiat point = point;
stop;
run;


/* czytanie sekwencyjne */
data test1;
set work.dict_swiat;
run;

/* czytanie losowe */ /*(uwaga na wynik!!)*/
data test2;

do point = 1 to NOBS by 1;
 set work.dict_swiat point = point nobs = nobs;
 output;
end;

stop;
run;



/* przepisujemy zbior */
data work.dict_swiat;
set work.dict_swiat;
run;

/* podglad obserwacji logicznych i fizycznych */
data _null_;
dsid = open("work.dict_swiat");

obserwacje_fizyczne = attrn(dsid,"NOBS");

obserwacje_logiczne = attrn(dsid,"NLOBS");

IC = attrn(dsid,"ICONST");

put "Po przepisanu zbioru:";
put obserwacje_fizyczne= obserwacje_logiczne= IC=;
rc = close(dsid);
stop;
run;

