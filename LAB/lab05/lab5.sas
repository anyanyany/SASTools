/* lab 5
Zawadzka Anna */

%macro lab05_AZ254223(nazwa_zbioru=)/ PARMBUFF;
	%let set=%scan(&nazwa_zbioru,-1, %str(.));
	
	%let i=1;
	%let list=%scan(&syspbuff,&i, %str(%(,%),%,));
	%do %while(&list ne);
		%let list&i=&list;	
    	%let i=%eval(&i+1);
    	%let list=%scan(&syspbuff,&i, %str(%(,%),%,));
    %end;

	%let i=%eval(&i-2);
	
	%do j=1 %to &i;	
		data work.list&j;
		%let list=&&list&j.;
		%let k=1;
		%let arg=%scan(&list,&k);
		%do %while(&arg ne);
			&set.&j.="&arg";
			output;
			%let k=%eval(&k+1);
    		%let arg=%scan(&list,&k);
		%end;
		run;
	%end;

	%let sets=;
	%do j=1 %to &i;	
		%if &sets ne %then %let sets=&sets., List&j.;
		%else %let sets=List&j.;
	%end;
	
	proc sql noprint;
		create table &nazwa_zbioru. as
		select distinct * from  &sets;
	quit;
	
	%do j=1 %to &i;	
		proc sql noprint;
			drop table List&j.;
		quit;
	%end;
%mend;

%lab05_AZ254223(1 2, a b, nazwa_zbioru = work.xyz);
%lab05_AZ254223(1 2 2 2 3, a, bc de, nazwa_zbioru = work.bromba);


