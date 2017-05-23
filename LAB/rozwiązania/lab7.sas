/* Zawadzka Anna - lab 7 */


data pracownik;
	do id = 1 to 100;
		dzial = ((1<>abs(floor(rannor(10) * 4)))><5);
		nazwisko = put(md5(id),$hex32.);
		output;
	end;
run;
data place;
	do id = 1 to 100;
		data = today() - floor(ranuni(10)*60);
		dochod = 2000 + round(abs(rannor(10) * 10000),0.01);
		output;
		data = today() - (300 + floor(ranuni(10)*60));
		dochod = 2000 + round(abs(rannor(10) * 8000),0.01);
		output;
	end;
run;
data dzial;
	infile cards;
	input dzial nazwa $ 50.;
	cards;
	1 Blacharnia
	2 Magazyn
	3 Mechanika
	4 Kadry
	5 Lakiernia
	;
run;


/* podpunkt 1 */
/* v_best - widok pomocniczy */
proc sql;
CREATE VIEW v_best as 
(
	select distinct * from (
	select e.id as IDpracownika, e.nazwisko, e.dzial as IdDzialu, d.nazwa as Dzial, avg(p.dochod) as Srednia from Pracownik e 
	join Place p on e.id=p.id
	join Dzial d on d.dzial=e.dzial
	group by e.id
	)
) 
order by IdDzialu, Srednia desc
;
quit;


/* v_best_three - widok ostateczny */
data v_best_three / VIEW = v_best_three;	
	set v_best;
	by IdDzialu;
	dataRaportu=today(); 
	format dataRaportu date9.;
	retain cnt;
	if first.IdDzialu then cnt=0;
	cnt=cnt+1;
	if cnt<4 then output;
	drop cnt IdDzialu;
run;



/* podpunkt 2 */
/* v_netto - widok pomocniczy */
data v_netto / VIEW = v_netto;
	set Place;
	format data date9.;
	if dochod<2000 then dochod_netto=(1-0.05)*dochod;
	else do;
		if dochod>10000 then dochod_netto=(1-0.1)*dochod;
		else do;
			pod=((5/8000)*dochod+3.75)/100;
			dochod_netto=(1-pod)*dochod;
		end;
	end;
	if (today()-data)<=30 then output;
	drop pod;
run;


/* v_changed - widok ostateczny */
proc sql;
CREATE VIEW v_changed as 
(
	select e.id, e.nazwisko, d.nazwa as NazwaDzialu, n.dochod_netto from v_netto n
	join Pracownik e on n.id=e.id
	join Dzial d on d.dzial=e.dzial
) 
order by NazwaDzialu, dochod_netto desc
;
quit;



