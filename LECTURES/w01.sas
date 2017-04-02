/*"magic string"*/

*);*/;/*'*/ /*"*/; %MEND;run;quit;;;;;















/* kilka drobiazgow na temat rzeczy, o ktorych podobno wszystko wiemy :-) */

libname _in_  BASE "C:\SAS_WORK\sas2\zbiory_in";

libname _out_ BASE "C:\SAS_WORK\sas2\zbiory_out";

libname _out2_ BASE "C:\SAS_WORK\sas2\zbiory_out_%sysfunc(datetime(),B8601DT15.)";

%put "C:\SAS_WORK\sas2\zbiory_out_%sysfunc(datetime(),B8601DT15.)";
























options DLCREATEDIR;
run;  /* run nie jest obowiazkowy */

libname _out2_ BASE "C:\SAS_WORK\sas2\zbiory_out_%sysfunc(datetime(),B8601DT15.)";

/* opcja DLCREATEDIR pozwala utworzyc katalog */















libname _out3_ BASE "C:\SAS_WORK\sas2_nie_ma_mnie\zbiory_out_%sysfunc(datetime(),B8601DT15.)";





/* skoro nie moge utworzyc calej sciezki, to po co mi to ?*/

/* np. tymczasowe dodatkowe podkatalogi w work'u */

libname _out4_ BASE "%sysfunc(GETOPTION(work))\pomocniczy_podkatalog";


%put %sysfunc(GETOPTION(work));




















/* czytanie i pisanie do plikow */
/* telegram: */
data telegram1;
infile cards dlm = ".";
input zdanie $ :200. @@;
if lengthN(zdanie);
datalines;
Moi drodzy! Stop. Dojechalismy nad morze. Stop.
Pogoda dopisuje. StoP. Stryjenka ma sie lepiej.
Stop.
Pozdrawiam, Bazyli. Stop.
;
run;











data telegram2;
infile CARDS DLMSTR = "Stop.";
input zdanie $ :200. @@;
if lengthn(zdanie);
DATALINES;
Moi drodzy! Stop. Dojechalismy nad morze. Stop.
Pogoda dopisuje. StoP. Stryjenka ma sie lepiej.
Stop.
Pozdrawiam, Bazyli. Stop.
;
run;


/* DLMSTR - pozwala zastapic pojedynczy znak rozdzielajacy calym napisem */










data telegram3;
infile cards dlmstr = "stop." DLMSOPT='i'; 
input zdanie $ :200. @@;
if lengthn(zdanie);
datalines;
Moi drodzy! Stop. Dojechalismy nad morze. Stop.
Pogoda dopisuje. StoP. Stryjeka ma sie lepiej.
Stop.
Pozdrawiam, Bazyli. Stop.
;
run;

/* DLMSOPT - doodaje dodatkowe opcje "i" <- caes insensitive */





data tabelka;
format id wiek wzrost waga best32.;

infile CARDS4 dlmstr = "</TD><td>" dlmsopt='i' missover; 
input id_char $ :200. wiek wzrost waga_char $ :200. ;

id   = input(COMPRESS(id_char  , ,'DK'),best32.);
waga = input(compress(waga_char, ,'dk'),best32.);
drop id_char waga_char;
if id;

DATALINES4;
<table>
<tr><th>ID</th><th>AGE</th><th>HEIGHT</th><th>WEIGHT</th></tr>
<tr><td>131</td><td>23</td><td>173</td><td>80</td></tr>
<tr><td>448</td><td>31</td><td>181</td><td>83</td></tr>
<tr><td>765</td><td>47</td><td>190</td><td>102</td></tr>
<tr><td>1082</td><td>19</td><td>186</td><td>75</td></tr>
<tr><td>1399</td><td>28</td><td>174</td><td>75</td></tr>
<tr><td>16116</td><td>51</td><td>169</td><td>60</td></tr>
<tr><td>19133</td><td>33</td><td>182</td><td>78</td></tr>
</table>
;;;;
run;







/* chcemy zapisac utworzony plik do lokalizacji wskazanej przez biblioteke _out4_ */

filename _out4_ "%sysfunc(PATHNAME(_out4_))\wynikowy.txt";

data _null_;
set tabelka;
file _out4_ dlmstr = "<separator>";
put id wiek wzrost waga;
run;

%put **%sysfunc(FILEEXIST(%sysfunc(PATHNAME(_out4_))\wynikowy.txt))**;







filename _out4_ "%sysfunc(PATHNAME(_out4_))\wynikowy2.txt";

data _null_;
set tabelka;
length separator $ 20;
separator = cats("<separator",put(_N_,best.),">"); /* best12.*/
file _out4_ dlmstr = separator;
put id wiek wzrost waga;
run;

%put **%sysfunc(FILEEXIST(%sysfunc(PATHNAME(_out4_))\wynikowy2.txt))**;







filename _out4_ "%sysfunc(PATHNAME(_out4_))\wynikowy3.txt";

data _null_;
set tabelka;
length separator $ 20;
separator = cats("<separator",put(_N_,best.),">");
file _out4_ dlmstr = separator DLMSOPT='T'; /* <- kasujemy zbedne spacje */
put id wiek wzrost waga;
run;

%put **%sysfunc(FILEEXIST(%sysfunc(PATHNAME(_out4_))\wynikowy3.txt))**;







%macro make_data_set(n,prefix=work.test_ds_);

%do i = 1 %to &n.;
 data &prefix&i.;
  do i = 1 to &n.;
   x = ranuni(&i.);
   y = ranuni(&i.);
   z = ranuni(&i.);
   output;
  end;
 run;
%end;

%mend make_data_set;
%make_data_set(5);








data combine1;
set work.test_ds_1 work.test_ds_2 work.test_ds_3 work.test_ds_4 work.test_ds_5;
run;















data combine2;
set
%macro ccc(n);
%do i = 1 %to &n.;
 work.test_ds_&i.
%end;
%mend ccc;
%ccc(5)
;
run;








/* mo¿na napisaæ to szybciej :-) */

data combine3;
set work.test_ds_1 - work.test_ds_5;
run;








/* ale niestety jak w "liscie" jest dziura */

data combine4;
set work.test_ds_1 - work.test_ds_5;
run;










/* ratuje nas notacja prefixowa z ":" */

data combine5;
set work.test_ds_:;
run;



%macro make_data_set_date(n,prefix=work.test_date_ds_r,date="20sep2016"d);

%do i = 0 %to &n.;
 data &prefix%sysfunc(INTNX(MONTH, &date., &i., BEGIN),yymm7.);
  do i = 1 to &n.;
   x = ranuni(&i.);
   y = ranuni(&i.);
   z = ranuni(&i.);
   output;
  end;
 run;
%end;

%mend make_data_set_date;
%make_data_set_date(5);
















/* ale jak ja sie dowiem z ktorego zbioru mam informacje? */

data combine6;
length in_data_set $ 41;
set work.test_date_ds_: INDSNAME = indsname;
in_data_set = indsname;
run;


 



data combine7;
length in_data_set 8;
set work.test_date_ds_: INDSNAME = indsname;
in_data_set = COMPRESS(indsname, , "TPSA");

r = floor(in_data_set/100);
m = mod(in_data_set,100);
run;













/* tworzenie makrozmiennych w SQLu */
proc sql noprint;
 select distinct x format best32.
 into :x1-:x&sysmaxlong                /* <- 2'147'483'647 */
 from combine6
 ;
 %let num_values = &sqlobs;
quit;

%put **&num_values.**;


%macro p(nvalues,prefix=x);
%do i = 1 %to &&&nvalues;
 %put NOTE:[&SYSMACRONAME.] **&&&prefix&i.**;
%end;

%mend p;

%p(num_values);





proc sql noprint;
 select distinct i
 into :x1-
 from combine6
 ;
 %let num_values = &sqlobs;
quit;

%put **&num_values.**;

%p(num_values);
