/* lab 5
Zawadzka Anna */

%macro lab05_AZ254223(nazwa_zbioru=)/ PARMBUFF;

	/* check if library name is correct */
	%if %sysfunc(index(&nazwa_zbioru.,.)) ne 0 %then %do;
		%let lib=%scan(&nazwa_zbioru,1, %str(.)); 
		%let length=%sysfunc(length(&lib.));
		%if &length.>8 %then %let lib=work; /* cannot just concatenate library name because we don't know if there is such libref */
	%end;
	%else %let lib=work;

	%let set=%scan(&nazwa_zbioru,-1, %str(.));
	%let setname=list;

	/* get all of the lists */
	%let i=1;
	%let list=%scan(&syspbuff,&i, %str(%(,%),%,));
	%do %while(&list ne);
		%let list&i=&list;	
    	%let i=%eval(&i+1);
    	%let list=%scan(&syspbuff,&i, %str(%(,%),%,));
    %end;

	/* number of lists */
	%let listcounter=%eval(&i-2);

	/*check if variables names are correct */	
	%let length=%sysfunc(length(&set.));
	%let ilength=%sysfunc(length(&i.));
	%if %eval(&length.+&ilength.)>32 %then %let set=%SUBSTR(&set,1,%eval(32-&ilength));
	
	%do i=1 %to &listcounter;	
		/* firstly need to get max length of variable in dataset */
		%let list=&&list&i.;
		%let k=1;
		%let arg=%scan(&list,&k);
		%let maxlength=%sysfunc(length(&arg.));
		%do %while(&arg ne);
			%let length=%sysfunc(length(&arg.));
			%if &length.>&maxlength. %then %let maxlength=&length;
			%let k=%eval(&k+1);
    		%let arg=%scan(&list,&k);
		%end;

		/* then we can create datasets */
		data work.&setname.&i.;
		length &set.&i. $&maxlength.;

		%let k=1;
		%let arg=%scan(&list,&k);
		%do %while(&arg ne);
			&set.&i.="&arg"; /* assumption that all variables are characters */
			output;
			%let k=%eval(&k+1);
    		%let arg=%scan(&list,&k);
		%end;
		run;
	%end;

	/* list of all sets */
	%let sets=;
	%do i=1 %to &listcounter;	
		%if &sets ne %then %let sets=&sets., &setname.&i.;
		%else %let sets=&setname.&i.;
	%end;
	
	/* create the final dataset */
	proc sql noprint;
		create table &lib..&set. as
		select distinct * from  &sets;
	quit;
	
	/* cleaning after work */
	%do i=1 %to &listcounter;	
		proc sql noprint;
			drop table &setname.&i.;
		quit;
	%end;
%mend;

/* tests */
%lab05_AZ254223(1 2, a b, nazwa_zbioru = work.xyz);
%lab05_AZ254223(1 2 2 2 3, a, bc de, nazwa_zbioru = work.bromba);
%lab05_AZ254223(1 5 60 34 123 45, a 1 g 4 f, bc de rt yyyy zz yy ee, nazwa_zbioru = ojejkujejkujakadluganazwabardzoniemozliwe);
%lab05_AZ254223(10 5 500, ee aa yy ee i oo i ee, nazwa_zbioru = workworkwork.bardzodluganazwakosmospoprostutakadluga);
%lab05_AZ254223(10, 5, 500, ee, aa, yy, ee, i, oo, i ee, t y, u i, nazwa_zbioru = workworkwork.okropniebardzodluganazwakosmospoprostutakadluga);


