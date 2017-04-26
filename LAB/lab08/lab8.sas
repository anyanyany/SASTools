/* Zawadzka Anna
lab 8 */

%let _rozmiar_ = 1E4;
data pracownicy_zawodow_dawnych;
	length id 8 Imie Nazwisko $ 50 Zawod $ 500 Brutto Netto 8;
	do id = 1 to &_rozmiar_.; drop i_:;
	i_1 = ceil(10*ranuni(42));
	i_2 = ceil(10*ranuni(42));
	i_3 = ceil( 3*ranuni(42));
	i_4 = round( 1000*rannor(42) ,0.01);
	select(i_1);
	when( 1) Imie = "Andrzej"; when( 2) Imie = "Bogdan";
	when( 3) Imie = "Cezary"; when( 4) Imie = "Dominik";
	when( 5) Imie = "Edward"; when( 6) Imie = "Fryderyk";
	when( 7) Imie = "Grzegorz"; when( 8) Imie = "Henryk";
	when( 9) Imie = "Ireneusz"; when(10) Imie = "Jan";
	otherwise;
	end;
	select(i_2);
	when( 1) Nazwisko = "Kowalski"; when( 2) Nazwisko = "Lewandowski";
	when( 3) Nazwisko = "Luczak"; when( 4) Nazwisko = "Mlynarski";
	when( 5) Nazwisko = "Nowak"; when( 6) Nazwisko = "Ostrowski";
	when( 7) Nazwisko = "Pawlak"; when( 8) Nazwisko = "Rutkowski";
	when( 9) Nazwisko = "Szymanski"; when(10) Nazwisko = "Traczyk";
	otherwise;
	end;
	select(i_3);
	when(1) Zawod = "Ultaj (lub Hultaj) najemnik, pracownik, dawniej
	hultaje to ludzie wolni, luzni, najemnicy, nieosiadli wyrobnicy,
	którzy pracowali na czasowym (krótszym niz rok) kontrakcie badz na
	umowie o wykonanie dziela.";
	when(2) Zawod = "Wolchw (pot. Guslarz) u dawnych Slowian wrózbita,
	czesciowo tez mag, swego rodzaju odpowiednik szamana znanego
	z innych kultur pierwotnych.";
	when(3) Zawod = "Zalaz (lac. Adwenae) w piastowskiej Polsce
	najemnicy rolni, robotnicy sezonowi, ludzie luzni, wedrowni,
	najmujacy sie do róznych prac pomocniczych.";
	otherwise;
	end;
	Zawod = compbl(Zawod);
	Brutto = 10000 + i_4;
	Netto = Brutto * (1 - 0.17);
	output;
	end;
run;


/* do usuniecia kolumny brutto */

proc sql noprint;
	create table podatek as select distinct round(Brutto/Netto,0.000001) as podatek from pracownicy_zawodow_dawnych;
quit;


/* tworzymy formaty - imie nazwisko i zawod */
proc sql;
	create table slownik_zawod as select distinct Zawod from pracownicy_zawodow_dawnych;
	create table slownik_imie as select distinct Imie from pracownicy_zawodow_dawnych;
	create table slownik_nazwisko as select distinct Nazwisko from pracownicy_zawodow_dawnych;
quit;

data slownik_zawod; set slownik_zawod; id_zawod=_N_; run;
data slownik_imie; set slownik_imie; id_imie=_N_; run;
data slownik_nazwisko; set slownik_nazwisko; id_nazwisko=_N_; run;

data fmt_zawod;
set slownik_zawod(rename=(id_zawod=start Zawod=label)) end=last;
retain fmtname 'zawod' type 'n';
output; 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=work cntlin=fmt_zawod;
run;


data fmt_imie;
set slownik_imie(rename=(id_imie=start Imie=label)) end=last;
retain fmtname 'imie' type 'n';
output; 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=work cntlin=fmt_imie;
run;


data fmt_nazwisko;
set slownik_nazwisko(rename=(id_nazwisko=start Nazwisko=label)) end=last;
retain fmtname 'nazwisko' type 'n';
output; 
    if last then do;
    hlo='O';
    label='!!!ERROR!!!';
    output;
    end;
run;
proc format library=work cntlin=fmt_nazwisko;
run;

options fmtsearch=(work);

proc sql noprint;
 create table pracownicy_light as select id, id_imie format Imie. as Imie, id_nazwisko format Nazwisko. as Nazwisko, id_zawod format Zawod. as Zawod, Netto from pracownicy_zawodow_dawnych p
 join slownik_imie si on si.Imie=p.Imie
 join slownik_nazwisko sn on sn.Nazwisko=p.Nazwisko
 join slownik_zawod sz on sz.Zawod=p.Zawod;
quit;



/* zmniejszenie rozmiaru zmiennnych */

data pracownicy_very_light;
	set pracownicy_light;
	length nazwisko imie zawod 3;
run;


/* widok dzieki ktoremu mamy kolumne brutto */

data pracownicy_very_light_view / VIEW = pracownicy_very_light_view;
  set pracownicy_very_light;
  	ip=1;
	set podatek point=ip;
	Brutto=round(netto*podatek,0.01);
  	output;
 drop podatek;
run;



/* rozmiar oryginalnego zbioru 6.1MB
rozmiar po zastosowaniu formatow 512.0KB + tabela podatek 128KB + formaty 2.5KB
rozmiar po zmniejszeniu rozmiaru zmiennych 384.0KB + tabela podatek 128KB + formaty 2.5KB
tabelka wynikowa = widok 9KB + tabela 384KB + tabela podatek 128KB + formaty 2.5KB

SUPER MALO!!!!
*/


/* cytujac klasyka - trzeba po sobie posprzatac */
proc sql noprint;
	drop table slownik_zawod, slownik_imie, slownik_nazwisko, fmt_zawod, fmt_imie, fmt_nazwisko, pracownicy_light;
quit;



/*odzyskanie duzego zbiorku */

data pracownicy_not_very_light;
	length id 8 Imie Nazwisko $ 50 Zawod $ 500 Brutto Netto 8;
  set pracownicy_very_light_view(rename=(Imie=n_Imie Zawod=n_Zawod Nazwisko=n_Nazwisko));
  Imie = vvalue(n_Imie);
  Nazwisko = vvalue(n_Nazwisko);
  Zawod = vvalue(n_Zawod);
  drop n_Imie n_Zawod n_Nazwisko;
run;
