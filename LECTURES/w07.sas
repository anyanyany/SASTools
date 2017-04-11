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
