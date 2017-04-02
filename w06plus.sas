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

