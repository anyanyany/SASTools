/* Lab 2
Zawadzka Anna 
zakladam ze zbiorek do posortowania jest w WORKu*/

/*%put %sysfunc(GETOPTION(work));
options mprint;*/


%macro LAB02_AZ254223(set, variables, sortigoptions);
	%let i=-1;
	%let variable=%sysfunc(scan(&variables.,&i.,#));
	%do %while (&variable ne );
		%let option=%sysfunc(scan(&sortigoptions.,&i.,#));
		%put &=variable &=option;

		Proc SORT
			data=&set. EQUALS &option. ;
			by &variable.; 
		run;

		%let i=%eval(&i -1);
		%let variable=%sysfunc(scan(&variables.,&i.,#));	
	%end;	
%mend;


%LAB02_AZ254223(L02z01_a, i#descending j, %STR(SORTSEQ=LINGUISTIC(locale = pl_pl NUMERIC_COLLATION=ON)#ASCII));

