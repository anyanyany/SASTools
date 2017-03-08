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
