/*
Zadanie 1. Napisac makro o nazwie LAB01 IN123456 [inicjaly + nr indeksu] o dwóch parametrach: lib i path,
które utworzy biblioteke lib w lokalizacji wskazanej przez sciezke path. Makro ma zapewnic obsluge bledów, np.:
utworzyc katalog w przypadku jego braku, poinformowac uzytkownika o sukcesie/porazce przypisania bibliotek,
zagwarantowac ”katalog zastepczy” w odpowiednim podkatalogu worka, etc.
*/

/*Anna Zawadzka*/

%macro DirectoryExist(path) ; 
	%LOCAL rc fileref return; 
	%let rc = %sysfunc(filename(fileref,&path)) ; 
	%if %sysfunc(fexist(&fileref))  %then %let return=1;    
	%else %let return=0;
	&return
%mend DirectoryExist;



%macro LAB01_AZ254223(lib,path);
options errorcheck=normal;
%put %DirectoryExist(&path);
%let ok=1;
%if %DirectoryExist(&path.) %then %do;
 	%put Correct path!;
%end;
%else %do;
	%put Wrong path!;
	%let newpath=;
	%let oldpath=;
	%let i=1;
	%let partialpath=%sysfunc(scan(&path.,&i.,\));
	%do %while (&partialpath ne );
		%let oldpath=&newpath;
		%if &newpath= %then %let newpath=&partialpath;
		%else %let newpath=&newpath.\&partialpath.;

		%if %DirectoryExist(&newpath.) ne 1 %then %do;
			%put Creating new path: &newpath;	
			options DLCREATEDIR;
			libname test BASE "&newpath.";			
			%if %DirectoryExist(&newpath.) ne 1 %then %let ok=0;
			LIBNAME test CLEAR;
		%end;
		%let i=%eval(&i +1);
		%let partialpath=%sysfunc(scan(&path.,&i.,\));
		
	%end;	
%end;

%if &ok. eq 1 %then %do;
 	libname &lib. BASE "&path.";
	%put Library created in path: &path.;
%end;
%else %do;
	libname &lib. BASE "%sysfunc(GETOPTION(work))\temporary";
	%put Library created in path: %sysfunc(GETOPTION(work))\temporary ;
%end;
%mend;

%LAB01_AZ254223(lib1,C:\SAS_WORK\sas2\yyyddddyft66frdrrrdttry\zbiory_in6);
%LAB01_AZ254223(lib1,Cxxx6);




