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
