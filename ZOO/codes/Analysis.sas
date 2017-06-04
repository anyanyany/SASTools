libname analysis "C:/Users/Karola/Documents/Maretialy/Magisterka/Semestr II/Narzedzia SAS/Projekt";

/*formaty*/

proc format;
 value miesiac 
1='Styczen'
2='Luty'
3='Marzec' 
4='Kwiecien'
5='Maj'
6='Czerwiec'
7='Lipiec'
8='Sierpien'
9='Wrzesien'
10='Pazdziernik'
11='Listopad'
12='Grudzien'
;
run;

data slownik;
	set zoo.ticket_types;
	fmtname='bilety';
	rename ticket_type_id=start type_name=label;
proc format cntlin=slownik;
run;

options mprint;

/*///////////////////////////// S P R Z E D A Z   B I L E T Ó W  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
%macro sprzedaz_biletow(od='01jan2010', do='30apr2017');

%global srednia w;

%let r_od=%sysfunc(inputn(%sysfunc(dequote(&od)), date9.), year4.);
%let r_do=%sysfunc(inputn(%sysfunc(dequote(&do)), date9.), year4.);

proc sql noprint;

create table analysis.zyski_bilety as
select distinct year(date) as rok, month(date) as miesiac format miesiac., sum(amount)/1000 as zysk
from zoo.transactions
where date>=&od.d and date<=&do.d
group by year(date), month(date);

select max(rok), min(rok) into :lata,:min_rok from analysis.zyski_bilety;

quit;

/*wykresy sprzedazy dla kazdego miesiaca w roku*/

proc transpose data=analysis.zyski_bilety out=wykres (drop=_NAME_) prefix=r;
	id rok;
	by miesiac notsorted;
run;

data wykres;
	set wykres;
	format miesiac miesiac.;
run;


goptions hsize=6 vsize=4;  
/*filename gifloc "%sysfunc(GETOPTION(work))\miesieczna_sprzedaz.gif";*/
 
/* Define symbol characteristics */   
symbol1 interpol=join value=squarefilled   color=vibg height=2;                                                                         
symbol2 interpol=join value=trianglefilled color=depk height=2;                                                                         
symbol3 interpol=join value=diamondfilled  color=mob  height=2;
symbol4 interpol=join value=square   	   color=vibg height=2;                                                                         
symbol5 interpol=join value=triangle       color=depk height=2;                                                                         
symbol6 interpol=join value=diamond        color=mob height=2;                                                                         
symbol7 interpol=join value=plus           color=vibg height=2;                                                                         
symbol8 interpol=join value=X              color=depk height=2;                                                                         

                                                                                                                                        
/* Define legend characteristics and legend */                                                                                                     
legend1 label=none frame;                                                                                                               
title1 'Miesieczna sprzedaz biletów w okresie ' &od ' do ' &do;
 
/* Define axis characteristics */                                                                                                       
axis1 label=("miesiace") minor=none offset=(1,1);                                                                                     
axis2 label=(angle=90 "sprzedaz (tys.)")                                                                                                     
      minor=(n=1);                                                                                               
                                                                                                                                        
proc gplot data=wykres;                                                                                                                 
   plot (r%sysfunc(trim(&min_rok))-r%sysfunc(trim(&lata)))*miesiac / overlay legend=legend1                                                                               
                                   haxis=axis1 
									vaxis=axis2;                                                                             
run;                                                                                                                                    
quit;

%let w=1; /*mamy jeden wykres - przydatne do makra 'raport'*/

proc sort data=analysis.zyski_bilety;
	by rok;
run;

proc means data=analysis.zyski_bilety noprint;
	output out=analysis.zyski_srednie;
	var zysk;
	by rok;
run;

data analysis.zyski_srednie;
	set analysis.zyski_srednie;
	where _STAT_="MEAN";
	suma=round(zysk,.01);
	keep rok zysk;
run;

%if (%eval(&r_od-&r_do)=0) %then %do;

data _null_;
	set analysis.zyski_srednie;
	call symput('srednia',zysk);
run;

	%put Srednia sprzedaz biletów w okresie &od - &do wyniosla : &srednia;
%end;

%else %do;

title1 "Srednia sprzedaz biletów w okresie &od do &do";
symbol1 interpol=join value=diamondfilled  color=mob  height=2;

proc gplot data=analysis.zyski_srednie;
	plot zysk*rok;
run;
quit;

%let w=2;
%end;

%mend;

/* //////////////////////////////////// W Y D A J N O S C   P R A C O W N I K O W \\\\\\\\\\\\\\\\\\\\\\\ */

%macro wydajnosc(od='01jan2010', do='30apr2017') /PARMBUFF;
/*zakladamy, ze najpierw podajemy nazwisko potem imie, czyli np. Orzechowski Dawid Kowalski Jan itp*/

/*%let od=%sysfunc(inputn(%sysfunc(dequote(&od)), date9.), DDMMYY10.);
%let do=%sysfunc(inputn(%sysfunc(dequote(&do)), date9.), DDMMYY10.);*/
%let i=3;
%let kto=%qscan(&SYSPBUFF,1,",()");

%if %length(%qscan(&SYSPBUFF,3,",()"))=0 %then %do;	/*czyli nie podalismy nazwisk, generujemy zestawienie dla calego dzialu*/

	proc sql noprint;
	
	create table pracownicy as
	select employee_id,surname, name
	from zoo.employees 
	where position_code=9
	;

	select count(*) into :n from zoo.employees /*ile osób jest w tym dziale na ten okres*/
	where position_code=9;

	quit;
%end;


%else %do;
	%let kto1=%scan(&kto,1);
	%let kto2=%scan(&kto,2);
	%let kto_sql_nazwisko="&kto1"; /*do sql'a*/
	%let kto_sql_imie="&kto2";
	%do %while (%scan(&kto,&i) ne ); /*przechodze po liscie osób*/
		%let kto&i=%scan(&kto,&i);
		%let i=%eval(&i+1);
	%end;

	%let n=%eval(&i-1); /*liczba osób, które sprawdzamy*/
	%do i=3 %to &n;
		%if %eval(%sysfunc(mod(&i,2))-1)=0 %then %do;
		%let kto_sql_nazwisko=&kto_sql_nazwisko, "&&kto&i";
		%end;
		%else %do;
		%let kto_sql_imie=&kto_sql_imie, "&&kto&i";
		%end;
	%end;

	proc sql noprint;

	create table pracownicy as
	select employee_id,surname, name
	from zoo.employees 
	where surname in (&kto_sql_nazwisko) and name in (&kto_sql_imie) and position_code=9 /*zapewniamy sobie, ze jezeli jest dwóch pracowników o tym samym nazwisku, ale w innych dzialach, to bierzemy tylko Kasjerów*/
	;
	quit;
	
	%let n=%sysevalf(0.5*&n);
%end;

proc sql noprint;

create table analysis.wydajnosc as
select distinct * from 
(
select t.employee_id,  p.surname, p.name, count(*) as wydajnosc, t.date
from zoo.transactions t
join pracownicy p on p.employee_id=t.employee_id
where date>=&od.d and date<=&do.d and t.employee_id=p.employee_id
group by t.employee_id, year(date), month(date)
)
where day(date)=1
order by employee_id, year(date), month(date)
;

quit;

goptions hsize=8 vsize=6; 
/* Define the title */                                                                                                      
title1 "Miesieczna wydajnosc kasjerów w okresie &od-&do";                                                                                      
                                                                                                                                
/* Define symbol characteristics */ 
%let symbols=squarefilled trianglefilled diamondfilled square triangle diamond plus X squarefilled trianglefilled diamondfilled square;
%let kolor=vigb depk mob pink blue green orange lilac steel depk mob pink blue green;


%do i=1 %to &n;
	symbol&i interpol=join value=%scan(&symbols, &i) color=%scan(&kolor, &i) height=2;
%end;
                                                                        
/* Define legend characteristics */                                                                                                     
legend1 label=none frame;                                                                                                            
                                                                                                                                        
/* Define axis characteristics */                                                                                                       
axis1 label=("miesiace") minor=none offset=(1,1);                                                                                     
axis2 label=(angle=90 "liczba sprzedanych biletów w miesiacu")                                                                                                     
      minor=(n=1); 

proc sort data=analysis.wydajnosc;
	by date;	
run;

proc transpose data=analysis.wydajnosc out=analysis.wydajnosc_t (drop=_NAME_) prefix=p;
	by date;
	id employee_id;
	idlabel surname;
run;

proc gplot data=analysis.wydajnosc_t;
	plot (p:)*date /overlay legend=legend1                                                                               
                                   haxis=axis1 
									vaxis=axis2;                                                                             
run;                                                                                                                                    
quit;

%mend;


/*///////////////////////////// P O P U L A R N O S C  B I L E T O W  D A N E G O  T Y P U  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/


%macro popularne_bilety(od='01jan2010', do='30apr2017'); /*do poprawienia w raporcie*/

proc sql noprint;

create table analysis.popularne_bilety as /*liczba biletów danego typu sprzedana w miesiacu*/
select ticket_type_id, sum(ilosc) as ilosc, month(date) as msc format miesiac., year(date) as rok
from( 
	select ticket_type_id, sum(quantity) as ilosc, t.date as date /*liczba biletów danego typu sprzedana jednego dnia*/
	from zoo.transaction_details td
	join zoo.transactions t on td.transaction_id=t.transaction_id
	where t.date>=&od.d and t.date<=&do.d
	group by t.date, td.ticket_type_id
	)
group by ticket_type_id, msc, rok
order by ticket_type_id, rok, msc
;

quit;

proc means data=analysis.popularne_bilety mean noprint;
	var ilosc;
	by ticket_type_id rok;
	output out=analysis.popularne_bilety2;
run;

data analysis.max;
	set analysis.popularne_bilety2;
	ilosc=round(ilosc,1);
	where _STAT_="MAX";
	drop _TYPE_ _FREQ_ _STAT_;
	format ticket_type_id bilety.;
run;

proc sql noprint;
create table analysis.max1 as
select rok, ticket_type_id as typ, ilosc from analysis.max
group by rok
having ilosc=max(ilosc);
quit;

data analysis.popularne_srednie; /*dostajemy srednie liczby sprzedanych biletów danego typu w danym miesiacu*/
	set analysis.popularne_bilety2;
	ilosc=round(ilosc, 1);
	where _STAT_="MEAN";
	drop _TYPE_ _FREQ_ _STAT_;
	format ticket_type_id bilety.;
run;

proc transpose data=analysis.popularne_srednie out=analysis.popularne_srednie (drop=_NAME_) prefix=r;
	by ticket_type_id;
	id rok;
run;

%mend;

/*///////////////////////////// L I C Z B A  Z W I E R Z A T  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/

%macro zwierzeta(od='01jan2010', do='30apr2017');

proc sql noprint;
	
select count(*) into :F1-:F2 from zoo.animals /*wyciagam te wierzeta, które jeszcze zyja*/
where deceased_date is null or deceased_date>&do.d
group by sex;

select count(*) into :F3 from zoo.animals 
where birth_date>=&od.d and birth_date<=&do.d and birth_place="ZOO"; /*wyciagam te, które urodzily sie w tym okresie w zoo"*/

select count(*) into :F4 from zoo.animals 
where deceased_date>=&od.d and deceased_date<=&do.d; /*wyciagam te, które zmarly w tym okresie w zoo"*/

/*wyciagam ile zwierzat danego typu bylo w danym okresie w zoo*/
create table analysis.zwierzeta_gatunki as
select r.division_name, count(*) as liczba from zoo.divisions r
join zoo.orders o on r.division_id=o.division_id
join zoo.species s on s.order_id=o.order_id
join zoo.animals zw on zw.species_id=s.species_id
where zw.deceased_date is null and zw.birth_date<=&do.d /*te, które zyja i które urodzily sie przed koncem okresu*/
group by r.division_name;
quit;

%let od=%sysfunc(inputn(%sysfunc(dequote(&od)), date9.), DDMMYY10.);
%let do=%sysfunc(inputn(%sysfunc(dequote(&do)), date9.), DDMMYY10.);

%global tresc;
%let tresc="Na dzien dzisiejszy mamy  &F1  samic i  &F2  samcow. W naszym ZOO w okresie  &od  do  &do  przyszlo na swiat  %sysfunc(trim(&F3))  maluchów, odeszlo %sysfunc(trim(&F4)).";
%mend;


/* //////////////////////////////////////////// B I L A N S \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */

%macro bilans(od='01jan2010', do='30apr2017');

/* wyniki sprzedazy w zadanym okresie*/
proc sql noprint;

create table analysis.zyski_bilety as
select distinct year(date) as rok, month(date) as miesiac format miesiac., sum(amount)/1000 as zysk
from zoo.transactions
where date>=&od.d and date<=&do.d
group by year(date), month(date);

/*utrzymanie zoo*/

create table analysis.wydatki_inne_kontrahenci as /*ta tabela zawiera kwtowy wyplacone poszczególnym kontrahentom*/
select year(invoice_date) as rok, month(invoice_date) format miesiac. as miesiac, company_name as firma, sum(amount_gross) as brutto
from zoo.other_expenses
where invoice_date>=&od.d and invoice_date<=&do.d
group by company_name, year(invoice_date), month(invoice_date)
order by month(invoice_date),year(invoice_date), firma;

/*liczba zaplaconych faktur w miesiacu wraz z laczna kwota*/
create table analysis.wydatki_inne as
select rok, miesiac, sum(brutto) as brutto
from analysis.wydatki_inne_kontrahenci
group by rok, miesiac;

/*koszty wyzywienia zwierzat*/

create table analysis.wydatki_wyzywienie as
select distinct year(date) as rok, month(date) as miesiac format miesiac., round(sum(s.amount), .01) as wyzywienie
from zoo.supplies s
join zoo.supplies_details sd on sd.supply_id=s.supply_id
where s.date>=&od.d and s.date<=&do.d
group by year(s.date), month(s.date)
;
quit;

/*lista plac*/
%let m_od=%sysfunc(inputn(%sysfunc(dequote(&od)), date9.), month2.);
%let r_od=%sysfunc(inputn(%sysfunc(dequote(&od)), date9.), year4.);

%let m_do=%sysfunc(inputn(%sysfunc(dequote(&do)), date9.), month2.);
%let r_do=%sysfunc(inputn(%sysfunc(dequote(&do)), date9.), year4.);

%put **&m_od**&r_od**&m_do**&r_do**;

%let miesiace=%sysevalf(12*%eval(&r_do-&r_od));
%let miesiace=%eval(%eval(%eval(&miesiace-&m_od)+&m_do)+1);

%let rok=&r_od;

%do i=1 %to &miesiace;  /*generujemy miesieczna kwote wyplat, spr czy danemu pracownikowi w danym miesiacu nalezy sie wynagrodzenie*/
	%let m=%sysfunc(mod(%eval(%eval(&i+&m_od)-1),12));
	%put **&m**;
	%if &m=0 %then %do;
		%let m=12;
		%let pocz=%sysfunc(mdy(&m,01,&rok));
		%let koniec=%sysfunc(mdy(&m,28,&rok));		
		%let rok=%eval(&rok+1);
		%goto continue;
	%end;
	%if &m<10 %then %do;
		%let pocz=%sysfunc(mdy(0&m,01,&rok));
		%let koniec=%sysfunc(mdy(0&m,28,&rok));
	%end;
	%else %do;
		%let pocz=%sysfunc(mdy(&m,01,&rok));
		%let koniec=%sysfunc(mdy(&m,28,&rok));
	%end;
	%continue:
	data _null_;
		set zoo.employees (keep=salary hire_date layoff_date employee_id) end=k;
		retain suma 0;
		pocz="&pocz";
		koniec="&koniec";
		format hire_date layoff_date best32.;
		if hire_date<pocz and (layoff_date>koniec or layoff_date=.) then do; /*pracowal w poprzednim miesiacu i pracuje nadal*/
			suma=suma+salary;
		end;
		if hire_date>=pocz and hire_date<=koniec then do; /*rozpoczal prace w tym miesiacu i nadal pracuje*/
			suma=suma+salary;
		end;
		if k then do;
			call symput("miesiac&i",suma);
		end;
	run;
	%put **&pocz**&koniec**&&miesiac&i**;

%end;

data analysis.wynagrodzenia;
retain rok &r_od;
	%do i=1 %to &miesiace;
		if mod(&i+&m_od-1,12)=0 then do;
			rok=rok;
			miesiac=12;
			wynagrodzenia=&&miesiac&i;
			output;
			rok=rok+1;
		end;	
		else do;
			rok=rok;
			miesiac=mod(&i+&m_od-1,12);
			wynagrodzenia=&&miesiac&i;
			output;
		end;
	%end;
	format wynagrodzenia best32. miesiac miesiac.;
run;	


data analysis.bilans;
	merge analysis.wydatki_inne analysis.wydatki_wyzywienie analysis.zyski_bilety analysis.wynagrodzenia;
	bilans=1000*zysk-brutto-wyzywienie-wynagrodzenia;
run;

%mend;

/*testowanie
%sprzedaz_biletow();
%wydajnosc();
%popularne_bilety();
%zwierzeta();
%bilans();

*/

/*///////////////////////////////////////////// R A P O R T \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/

/*domyslnie generujemy wszystkie rodzaje mozliwych rapotów*/
/*przed argumentem sciezka podajemy opcjonalnie nazwiska pracowniów kas*/
/*najpierw podajemy sciezke plikow .pdf*/

%macro raport(sciezka,sprzedaz=1,kasy=1,bilety=1,zwierzeta=1,bilans=1,od='01jan2010',do='30apr2017') /PARMBUFF;

/*wyciagamy liste nazwisk, o ile istnieje*/
%let i = 1;
%let parm_&i = %scan(&syspbuff,&i,%str(%(,%))); 
     
%do %while (%str(&&parm_&i.) ne %str());
	%let i = %eval(&i+1); 
	%let parm_&i = %scan(&syspbuff,&i,%str(%(,%)));
	%put **&&parm_&i**;
%end;

ods _all_ close;

%if &sprzedaz=1 %then %do;
	
	options ORIENTATION=PORTRAIT;
	ods pdf file="&sciezka\sprzedaz.pdf" pdftoc=2 startpage=no BOOKMARKLIST=no TITLE='Sprzedaz biletów';
	title 'Sprzedaz biletów w danym miesiacu w okresie ' &od ' do ' &do;

	%sprzedaz_biletow(od=&od,do=&do);
	%if &w=2 %then %do;
		proc print data=analysis.zyski_bilety obs='Pozycja numer';
		run;
	%end;
	%else %do;
		proc print data=analysis.zyski_bilety obs='Pozycja numer';
		run;

		ods text="Srednia sprzedaz biletów w okresie &od do &do wynosi &srednia tys. zlotych";
	%end;

	ods pdf close;

%end;


%if &kasy=1 %then %do;

	ods pdf file="&sciezka\kasy.pdf" pdftoc=2 BOOKMARKLIST=no;
	options ORIENTATION=landscape;
	%if  %substr(&parm_2,1,8)=%sysfunc(dequote("sprzedaz")) %then %do;
		%wydajnosc(od=&od,do=&do);
		proc print data=analysis.wydajnosc_t label obs='Pozycja numer' WIDTH=MINIMUM;
		run;
	%end;
	%else %do;
		%wydajnosc(&parm_2,od=&od,do=&do);
		proc print data=analysis.wydajnosc_t label obs='Pozycja numer' WIDTH=MINIMUM;
		run;
	%end;

	ods pdf close;

%end;

%if &bilety=1 %then %do;

	ods pdf file="&sciezka\bilety.pdf" pdftoc=2 startpage=no BOOKMARKLIST=no;
	options ORIENTATION=PORTRAIT;

	%popularne_bilety(od=&do,do=&do);

	title 'Zestawienie popularnosci biletów w okresie ' &od ' do ' &do;
	proc print data=analysis.popularne_srednie label obs='Pozycja nr' WIDTH=UNIFORN;
	run;

	proc print data=analysis.max1 label obs='Pozycja nr';
	run;

	ods pdf close;

%end;

%if &zwierzeta=1 %then %do;

	ods pdf file="&sciezka\zwierzeta.pdf" pdftoc=2 startpage=no BOOKMARKLIST=no;
	options ORIENTATION=PORTRAIT;

	%zwierzeta(od=&od,do=&do);

	ods text=&tresc;

	title 'Stan zwierzat.';

	proc print data=analysis.zwierzeta_gatunki;
	run;

	ods pdf close;

%end;

%if &bilans=1 %then %do;

	options ORIENTATION=PORTRAIT;
	ods pdf file="&sciezka\bilans.pdf" pdftoc=2 startpage=no BOOKMARKLIST=no;

	%bilans(od=&od,do=&do);
	title 'Bilans';
	proc print data=analysis.bilans WIDTH=MINIMUM;
	run; 

	ods pdf close;
%end;


%mend;


/*
przyklad
%raport(C:\Users\Karola\Desktop, Orzechowski Dariusz Kubiak Amelia, sprzedaz=1,kasy=0,bilety=0,zwierzeta=0,bilans=0,od='01jan2010',do='31dec2012');
*/

