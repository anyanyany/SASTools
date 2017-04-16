libname ZOO BASE "D:\SASTools\ZOO";
dm log 'clear';

%macro update_animal_deceased_date(animal_id, deceased_date);
	%if %length(&animal_id.)=0 %then %do; %put WARNING: Brak ID zwierzecia!; %goto exit; %end;
	%if %length(&deceased_date.)=0 %then %do; %put WARNING: Nie podano daty!; %goto exit; %end;	
	proc sql noprint; select count(*) into: counter from ZOO.ANIMALS where animal_id=&animal_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma zwierzecia o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.ANIMALS set deceased_date=&deceased_date. where animal_id=&animal_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_surname(employee_id, surname);
	%if %length(&employee_id.)=0 %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&surname.)=0 %then %do; %put WARNING: Nazwisko nie moze byc puste!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set surname=&surname. where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%update_animal_deceased_date(2, '13apr2016'd);
%update_employee_surname(1, 'Pawlak');
