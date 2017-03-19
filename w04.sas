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
