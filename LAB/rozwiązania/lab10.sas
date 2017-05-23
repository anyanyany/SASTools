/* lab 10
Zawadzka Anna */
options FULLSTIMER MSGLEVEL = I; 

/*tworzenie + sortowanie zbiorku */
%macro prepare();
data invoice;
	do id = 1 to 5000;
		dd = '17may2017'd - round(rannor(17)*20);
		do i = 1 to ceil(ranuni(17)*27);
			date = intnx("Month", dd, -i, "Same");
			y = year(date);
			m = month(date);
			d = day(date);
			amt = 200 + round(rannor(17)*20,0.01);
			output;
		end;
	end;
	keep id date y m d amt;
	format id z10. date date11. y z4. m d z2. amt dollar12.2;
run;

proc sort data=invoice;
	by date;
run;
%mend prepare;


/* wykonanie data stepow */
%macro check();
data x1; 
set invoice;
where date >= '1jan2017'd;
run;

data x2;
set invoice;
where id = 1133;
run;

data x3;
set invoice;
where id < 100 and date > '4may2017'd;
run;

data x4;
set invoice;
where y = 2014;
run;

data x5; 
set invoice;
where m between 5 and 6;
run;

data x6;
set invoice;
where d = 1;
run;

data x7;
set invoice;
where y = 2016 and m < 4;
run;

data x8;
set invoice;
where d = 13 and y = 2015;
run;

data x9;
set invoice;
where d < 10 and m = 1;
run;
%mend check;


/* sprzatanko */
%macro clean();
proc sql;
	drop table x1, x2, x3, x4, x5, x6, x7, x8, x9, invoice;
quit;
%mend;

/************************** wszystkie indeksy za jednym razem ***************************/

%prepare;

data invoice
(index = 
	(id_date = (id date)
	date_id = (date id)
	y_m = (y m)
	d_m = (d m)
	m_date = (m date)
	)
);
set invoice;
run;

%check;
%clean;

/* tworzenie indeksow - proc datasets */

%prepare;

proc datasets library = work nolist;
 modify invoice;
  index create id_date = (id date);
  index create date_id = (date id);
  index create y_m = (y m);
  index create d_m = (d m);
  index create m_date = (m date);
 run;
quit;

%check;
%clean;

/* tworzenie indeksow - proc sql */

%prepare;

proc sql;
	create index id_date on invoice(id, date);
	create index date_id on invoice(date, id);
	create index y_m on invoice(y, m);
	create index d_m on invoice(d, m);
	create index m_date on invoice(m, date);
quit;

%check;
%clean;


/************************** tworzenie indeksow po kawalku ***************************/

%prepare;

data invoice
(index = 
	(id_date = (id date)
	date_id = (date id)
	)
);
set invoice;
run;

proc datasets library = work nolist;
 modify invoice;
  index create y_m = (y m);
  index create d_m = (d m);
 run;
quit;

proc sql;
	create index m_date on invoice(m, date);
quit;

%check;
%clean;


