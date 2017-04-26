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
