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
