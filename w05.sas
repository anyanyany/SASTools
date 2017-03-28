data x;
x=1;
output;
x=2;
output;
run_2;
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











LIBNAME makra BASE "C:\SASTools";

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
print = "C:\Users\p.gburczyk\AppData\Local\Temp\SAS Temporary Files\_TD11196_ITDP-KOMPUTER_\PRINTTO_OUTPUT.TXT"
log = "C:\Users\p.gburczyk\AppData\Local\Temp\SAS Temporary Files\_TD11196_ITDP-KOMPUTER_\PRINTTO_LOG.TXT"
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
