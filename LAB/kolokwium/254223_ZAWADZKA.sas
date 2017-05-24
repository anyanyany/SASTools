dm log 'clear' log;  
/************************************************************************************************

1) Rozwiazanie kolokwium sklada sie z kodu i loga!
2) Nalezy zalaczyc obydwa pliki zapisane w postaci: NRALBUMU_NAZWISKO.SAS i NRALBUMU_NAZWISKO.LOG 
3) Prosze pamietac (we wlasnym interesie) o czestym zapisywaniu pliku z kodem.

*************************************************************************************************/
options mprint fullstimer msglevel = I; /* nie edytuj tej linii */


/* uzupelnij ponizsze dane */
%let Imie_i_Nazwisko = Anna Zawadzka;
%let Numer_Albumu = 254223;
%put *Imie_i_Nazwisko*&Imie_i_Nazwisko.*Numer_Albumu*&Numer_Albumu.*;


/****************************************************************************************/
/* Zadanie 1 (8 pkt)*/
/*
Dany jest zbior X_WIDE o strukturze: 

id | x1       | x2       | ... | xn 
---+----------+----------+-...-+----------
1  | 0.124... | -0.47... | ... | 0.995...
2  | -0.31...
...


Utworzyc widok X_LONG, ktory wyswietli dane zbioru X_WIDE 
w postaci:

id | var | val
---+-----+---------
 1 | x1  | 0.124...
 1 | x2  | -0.47... 
...
 1 | xn  | 0.995...
 2 | x1  | -0.31...
...
*/

%macro make_x_wide(_top_);
data x_wide;
do id = 1 to 100;
%let _loop_ = %sysfunc(ceil(%sysevalf(%sysfunc(ranuni(123)) * &_top_.)));
 %do _ii_ = 1 %to &_loop_.;
  x&_ii_. = rannor(123);
 %end;
output;
end;
run;
%mend make_x_wide;

%let userid = %sysfunc(compress(%sysfunc(md5(&sysuserid.),$hex5.),,TPSA));
%put **&userid**;

%make_x_wide(&userid.);

/************* A OTO WIDOK *****************/
data X_LONG / VIEW = X_LONG;
  set x_wide;
	array tab x:;
	do j=1 to dim(tab); 
	  var=cats("x",j);
	  val=tab(j);
	  output;
	 end;
	keep id var val;
run;


/****************************************************************************************/
/* Zadanie 2 (7 pkt)*/
/*
Napisac kod, ktory umieszczony w menu prawego przycisku myszy zbioru sasowego, wstawi do
schowka systemowego liste wszystkich zmiennych wystepujacych w zbiorze.
*/
/* tu wpisz kod rozwiazania: 

prosze bardzo:
gsubmit "filename s clipbrd; data _null_; file s; d = '%8b'||.||'%32b'; length n $ 32; do di=open(d,'I') while(di ne 0); do i=1 to attrn(di,'NVARS'); n=varname(di,i); put n @; end; end; run; filename s clear;";

*/

/******************************





******************************/


/* Zadanie 3 (15 pkt)*/
/****************************************************************************************/
/*
Dana jest baza danych z tabelami: A, B, C, DictB, DictC.
Tabele laczy sie zmiennymi o tych samych nazwach. 
*/
/*
1) Uzywajac co najmniej 2 sposobow poindeksuj zbiory bazy w celu przyspieszenia wyszukiwania.
2) Skompresuj zbiory, dla ktorych jest to oplacalne.
3) Dodaj integrity constreints tak, aby: 
    a) w tabeli A mogly wystepowac tylko wartosci wystepujace w tabelach B i C, 
    b) w slowniki DictB i DictC mialy unikalne opisy.
*/

data A;
length klient 8 paragon $ 32;
keep klient paragon;
do i = 1 to 1000 ;
 paragon = put(md5(put(i,best.)),$hex32.);
 klient = ceil(ranuni(123) * 100);
 output;
end;
run;

data B;
length paragon $ 32 produkt_id 8 data 8;
format data yymmdd10.;
keep paragon produkt_id data;

do i = 1 to 1000 ;
 paragon = put(md5(put(i,best.)),$hex32.);
 data = today() - floor(1000 * ranuni(123));
 do j = 1 to ceil(ranuni(123) * 40);
  produkt_id = ceil(17 * ranuni(123));
  output;
 end;
end;

run;

data DictB;
length produkt_id 8 produkt $ 100 cena 8;
produkt_id = 1; produkt = "Chleb"; cena = 2.59; output; 
produkt_id = 2; produkt = "Kajzerka"; cena = 0.39; output;
produkt_id = 3; produkt = "Muffinka"; cena = 1.21; output;
produkt_id = 4; produkt = "Tortilla"; cena = 4.50; output;
produkt_id = 5; produkt = "Banany"; cena = 4.99; output;
produkt_id = 6; produkt = "Marchewka"; cena = 1.19; output;
produkt_id = 7; produkt = "Jablka"; cena = 2.29; output;
produkt_id = 8; produkt = "Ziemniaki"; cena = 1.09; output;
produkt_id = 9; produkt = "Pomidory"; cena = 5.99; output;
produkt_id = 10; produkt = "Papryka"; cena = 8.09; output;
produkt_id = 11; produkt = "Maslo"; cena = 4.99; output;
produkt_id = 12; produkt = "Mleko"; cena = 2.79; output;
produkt_id = 13; produkt = "Ser"; cena = 3.99; output;
produkt_id = 14; produkt = "Kefir"; cena = 1.49; output;
produkt_id = 15; produkt = "Parowki"; cena = 3.49; output;
produkt_id = 16; produkt = "Szynka"; cena = 22.19; output;
produkt_id = 17; produkt = "Kielbasa"; cena = 18.79; output;
run;


data C;
length klient sklep_id 8;
do klient = 1 to 100;
sklep_id = ceil(ranuni(123) * 13);
output;
end;
run;

data DictC;
length sklep_id 8 sklep $ 100;
sklep_id = 1; sklep = "Warszawa1"; output;
sklep_id = 2; sklep = "Warszawa2"; output;
sklep_id = 3; sklep = "Warszawa3"; output;
sklep_id = 4; sklep = "Wroclaw1"; output;
sklep_id = 5; sklep = "Wroclaw2"; output;
sklep_id = 6; sklep = "Krakow"; output;
sklep_id = 7; sklep = "Olsztyn"; output;
sklep_id = 8; sklep = "Gdansk"; output;
sklep_id = 9; sklep = "Gdynia"; output;
sklep_id = 10; sklep = "Zielona Gora"; output;
sklep_id = 11; sklep = "Bialystok"; output;
sklep_id = 12; sklep = "Lodz1"; output;
sklep_id = 13; sklep = "Lodz2"; output;
run;



/************* INDEKSY *****************/
data A
	(index = (klient));
	set A;
run;

/* niesamowicie wazny index, przyda sie np tu: */
data A_select;
	set A;
	where klient = 4;
run;


/* najpierw sortuje */
proc sort data=B;
	by data;
run;
proc datasets library = work nolist;
 modify B;
 index create data;
 run;
quit;

/* rowniez bardzo przydatny indeks, o tu: */
data B_select;
	set B;
	where data>'1jul2015'd;
run;



proc sql;
	create index sklep_id on C(sklep_id);
quit;

/* a ten jak chcemy sobie sprawdzic kto chodzi do podanych sklepow: */
data C_select;
	set C;
	where sklep_id in (2,4,5);
run;



/************* KOMPRESJA *****************/
/* niestety kompresja zadnego zbiorku nie jest oplacalna, w kazdym przypadku zwiekszamy rozmiar pliku... */
/*przeprowadzone testy: 
data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
 set A;
run;
data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
 set B;
run;
data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
 set C;
run;
data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
 set Dictb;
run;
data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
 set Dictc;
run;  

*/



/************* CONSTRAINTSY *****************/

proc sql;
	create table paragony as select distinct paragon from B;
	create table klienci as select distinct klient from C;
quit;

proc datasets lib = work nolist;
	modify paragony;
		ic create PK_paragony = primary key(paragon);
	run;

	modify klienci;
		ic create PK_klienci = primary key(klient);
	run;

	modify A;
		ic create klienci_fk = foreign key (klient) REFERENCES klienci message = "Nie ma w bazie takiego klienta!" msgtype = USER;
		ic create paragony_fk = foreign key (paragon) REFERENCES paragony message = "Nie ma w bazie takiego paragonu!" msgtype = USER;
	run;

	modify Dictb;
  		ic create IC_DICTB_unique = unique(produkt) message = "Wartosci pola produkt musza byc UNIKALNE!" msgtype = USER; 
 	run;

	modify Dictc;
  		ic create IC_DICTC_unique = unique(sklep) message = "Wartosci pola sklep musza byc UNIKALNE!" msgtype = USER; 
 	run;
quit;

proc sql noprint;
	insert into A values(33,'niematakiegoparagonu');
	insert into A values(123456,'3A0BE0671460761DDC988DE0DFBB949D');
	insert into dictb values (2334,'Ser',0);
	insert into dictc values (15,'Gdynia');
quit;

proc sql noprint;
	drop table a_select, b_select, c_select, set_witout, set_char, set_binary;
quit;
