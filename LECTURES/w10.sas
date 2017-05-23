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
