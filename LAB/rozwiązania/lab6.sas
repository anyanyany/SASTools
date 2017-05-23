/* Anna Zawadzka
lab 6*/

%let W=10;
%let H=1000;


data a;
	array y[&W.];
	do i = 1 to &H.;
		do j=1 to dim(y);
			y[j] = rannor(42);
		end;
		drop i j;
		output;
	end;
run;


%macro zabawa;
filename kodzik TEMP;
data _null_;
file kodzik;
%do i=1 %to 512;
		put "options BUFSIZE=&i.k;";
		put "data a&i.;";
		put "	set a;";
		put "run;";

	%end;
run;
%include kodzik / source2;
filename kodzik;
%mend;

%zabawa;

proc sql noprint;
	select min(filesize) into: minsize from SASHELP.VTABLE
	where libname = "WORK" and memname like "A%";
quit;

proc sql noprint;
	select substr(memname,2,5) into: bufsizes SEPARATED BY ", " from SASHELP.VTABLE
	where libname = "WORK" and memname like "A%" and filesize=&minsize.;
quit;

/*wyswietlenie jakie rozmiary bufora daja nam najmniejszy rozmiar pliku*/
%put **** &=bufsizes ****;


/*wyswietlenie wszystkich informacji*/
proc sql;
	select memname, bufsize, filesize, npage from SASHELP.VTABLE
	where libname = "WORK" and memname like "A%" and filesize=&minsize.;
quit;

proc sql;
	drop table
	where libname = "WORK" and memname like "A%" and filesize=&minsize.;
quit;


%macro clear_work;
	%do i=1 %to 512;	
		proc sql noprint;
			drop table a&i.;
		quit;
	%end;
%mend;

%clear_work;

/* 
przeprowadzone testy:
w=10 h=1000 BUFSIZES=1, 2, 3
w=1000 h=10 BUFSIZES=1, 2, 3, 4, 5, 6, 7, 8
w=100 h=100 BUFSIZES=4
w=10 h=100 BUFSIZES=1, 2
w=100 h=10 BUFSIZES=1, 2
w=1000 h=1000 BUFSIZES=47


Mozemy zauwazyc, ze w wiekszosci przypadkow najmniejsze rozmiary bufora sa optymalne.
Przy ustalaniu duzej szerokosci (w) bufsize automatycznie powiekszy sie do odpowiedniego rozmiaru aby zmiescic nasze dane,
wtedy mimo ustalenia danego rozmiaru np na 1 albo 2k, w tabeli wynikowej zauwazymy bufsize rzedu 8k.
*/
