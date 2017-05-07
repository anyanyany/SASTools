/* aktualizowanie wybanych danych w bazie */
libname ZOO BASE "D:\SASTools\ZOO";
dm log 'clear';

%macro update_animal_deceased_date(animal_id, deceased_date);
	%if %length(&animal_id.)=0 or &animal_id. eq . %then %do; %put WARNING: Brak ID zwierzecia!; %goto exit; %end;
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
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&surname.)=0 %then %do; %put WARNING: Nazwisko nie moze byc puste!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set surname="&surname." where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_adress(employee_id, address_city, address_street, address_house_num, address_flat_num, postal_code);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;
	%if %length(&address_city.)=0 and %length(&address_street.)=0 and %length(&address_house_num.)=0 and %length(&address_flat_num.)=0 and %length(&postal_code.)=0 
	%then %do; %put WARNING: Nie podano wartosci do aktualizacji!; %goto exit; %end;		
	proc sql noprint;
		update ZOO.EMPLOYEES set address_city="&address_city.", address_street="&address_street.", address_house_num="&address_house_num.",
		address_flat_num=&address_flat_num., postal_code="&postal_code." where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_telephone(employee_id, telephone);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&telephone.)=0 %then %do; %put WARNING: Telefon nie moze byc pusty!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set telephone="&telephone." where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_email(employee_id, email);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&email.)=0 %then %do; %put WARNING: Email nie moze byc pusty!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set email="&email." where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_bank_account_num(employee_id, bank_account_num);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&bank_account_num.) ne 26 %then %do; %put WARNING: Niepoprawny NRB!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set bank_account_num="&bank_account_num." where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_layoff_date(employee_id, layoff_date);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&layoff_date.)=0 or &layoff_date. eq . %then %do; %put WARNING: Nie podano daty zwolnienia!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set layoff_date=&layoff_date. where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_contract_type(employee_id, contract_type);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&contract_type.)=0 or &contract_type. eq . %then %do; %put WARNING: Nie podano typu kontraktu!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint; select count(*) into: counter from ZOO.CONTRACT_TYPES where contract_type_id=&contract_type.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma rodzaju zatrudnienia o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.EMPLOYEES set contract_type=&contract_type. where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_fte_percentage(employee_id, fte_percentage);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&fte_percentage.)=0 or &fte_percentage. eq . %then %do; %put WARNING: Niepoprawny procent etatu!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	%if &fte_percentage. gt 100 %then %do; %put WARNING: Nie moze byc wiecej niz 100 procent etatu!; %goto exit; %end;
	proc sql noprint;
		update ZOO.EMPLOYEES set fte_percentage=&fte_percentage. where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_employee_salary(employee_id, salary);
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Brak ID pracownika!; %goto exit; %end;
	%if %length(&salary.)=0 or &salary. eq . %then %do; %put WARNING: Niepoprawna pensja!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pracownika o podanym ID!; %goto exit; %end;	
	proc sql noprint; select position_code into: position from ZOO.EMPLOYEES where employee_id=&employee_id.; quit;
	proc sql noprint; 
		select max_salary into: maxsalary from ZOO.POSITIONS where position_code=&position.;
		select min_salary into: minsalary from ZOO.POSITIONS where position_code=&position.;
	quit;
	%if &salary.<&minsalary. or &salary.>&maxsalary. %then %do; %put WARNING: Nieodpowiednie wynagrodzenie dla tego stanowiska!; %goto exit; %end;
	proc sql noprint;
		update ZOO.EMPLOYEES set salary=&salary. where employee_id=&employee_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_food_quantity(food_id, quantity);
	%if %length(&food_id.)=0 or &food_id. eq . %then %do; %put WARNING: Brak ID pozywienia!; %goto exit; %end;
	%if %length(&quantity.)=0 or &quantity. eq . %then %do; %put WARNING: Niepoprawna ilosc!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.FOOD where food_id=&food_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma pozywienia o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.FOOD set quantity=&quantity. where food_id=&food_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_expense_paid_status(expense_id); *paid=T;
	%if %length(&expense_id.)=0 or &expense_id. eq . %then %do; %put WARNING: Brak ID wydatku!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.OTHER_EXPENSES where expense_id=&expense_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma wydatku o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.OTHER_EXPENSES set paid="T" where expense_id=&expense_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_position_salary_range(position_code, min_salary, max_salary);
	%if %length(&position_code.)=0 or &position_code. eq . %then %do; %put WARNING: Brak ID stanowiska!; %goto exit; %end;
	%if %length(&min_salary.)=0 or &min_salary. eq . %then %do; %put WARNING: Niepoprawna pensja!; %goto exit; %end;
	%if %length(&max_salary.)=0 or &max_salary. eq . %then %do; %put WARNING: Niepoprawna pensja!; %goto exit; %end;
	%if &max_salary.<&min_salary. %then %do; %put WARNING: Stawka maksymalna nie moze byc mniejsza od minimalnej!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.POSITIONS where position_code=&position_code.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma stanowiska o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.POSITIONS set min_salary=&min_salary., max_salary=&max_salary. where position_code=&position_code.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_supplier_phone(supplier_id, phone);
	%if %length(&supplier_id.)=0 or &supplier_id. eq . %then %do; %put WARNING: Brak ID dostawcy!; %goto exit; %end;
	%if %length(&phone.)=0 %then %do; %put WARNING: Telefon nie moze byc pusty!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.SUPPLIERS where supplier_id=&supplier_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma dostawcy o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.SUPPLIERS set phone="&phone." where supplier_id=&supplier_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_supplier_email(supplier_id, email);
	%if %length(&supplier_id.)=0 or &supplier_id. eq . %then %do; %put WARNING: Brak ID dostawcy!; %goto exit; %end;
	%if %length(&email.)=0 %then %do; %put WARNING: Email nie moze byc pusty!; %goto exit; %end;
	proc sql noprint; select count(*) into: counter from ZOO.SUPPLIERS where supplier_id=&supplier_id.; quit;
	%if &counter. eq 0 %then %do; %put WARNING: Nie ma dostawcy o podanym ID!; %goto exit; %end;	
	proc sql noprint;
		update ZOO.SUPPLIERS set email="&email." where supplier_id=&supplier_id.;
	quit;
	%put NOTE: Zaktualizowano rekord!;	
	%exit:
%mend;

%macro update_ticket_type(ticket_type_id, price, valid_from);	
	proc sql noprint;
		select count(*) into: counter from ZOO.TICKET_TYPES where ticket_type_id=&ticket_type_id.;
	quit;
	%if &counter. eq 0 %then %do;
		%put WARNING: Nie ma takiego typu biletu!;
	%end;
	%else %do;	
		proc sql noprint;
			select valid_from into: valid_from_hist from ZOO.TICKET_TYPES where ticket_type_id=&ticket_type_id.;
		quit;
		%let valid_from_hist=%sysfunc(inputn(&valid_from_hist, ddmmyy10.), best12.);
		proc sql noprint;
			insert into ZOO.TICKET_TYPES_HIST select ticket_type_id, type_name, price, &valid_from_hist., (&valid_from.-1) from ZOO.TICKET_TYPES where ticket_type_id=&ticket_type_id.;
			update ZOO.TICKET_TYPES set price=&price., valid_from=&valid_from. where ticket_type_id=&ticket_type_id.;
		quit;	
		%put NOTE: Zaktualizowano rekord!;		
	%end;
%mend;



%macro checking_updates();
%update_animal_deceased_date(0, '13apr2016'd);
%update_animal_deceased_date(2, '13apr2016'd);

%update_employee_surname(12001, Pawlak);
%update_employee_surname(1, );
%update_employee_surname(1, Pawlak);

%update_employee_adress(0, Warszawa, Pulawska, 325, 12, 03-678);
%update_employee_adress(1, Warszawa, Pulawska, 325, 12, 03-678);

%update_employee_telephone(0, 502858789);
%update_employee_telephone(1, );
%update_employee_telephone(1, 502858789);

%update_employee_email(0, anna.anna@gmail.com);
%update_employee_email(1, );
%update_employee_email(1, anna.anna@gmail.com);

%update_employee_bank_account_num(0, 00000000001111111111222222);
%update_employee_bank_account_num(1, 000000000011111111112);
%update_employee_bank_account_num(1, 00000000001111111111222222);

%update_employee_layoff_date(0, '1apr2017'd);
%update_employee_layoff_date(1, .);
%update_employee_layoff_date(1, '1apr2017'd);

%update_employee_contract_type(0, 2);
%update_employee_contract_type(1, 23);
%update_employee_contract_type(1, 2);

%update_employee_fte_percentage(0, 80);
%update_employee_fte_percentage(1, 180);
%update_employee_fte_percentage(1, 80);

%update_employee_salary(0, 7500);
%update_employee_salary(1, 500);
%update_employee_salary(1, 7500);

%update_food_quantity(0, 400);
%update_food_quantity(3, .);
%update_food_quantity(3, 400);

%update_expense_paid_status(.);
%update_expense_paid_status(714);

%update_position_salary_range(0, 1000, 3000);
%update_position_salary_range(4, 10000, 3000);
%update_position_salary_range(4, 1000, 3000);

%update_supplier_phone(12, );
%update_supplier_phone(0, 568569854);
%update_supplier_phone(12, 568569854);

%update_supplier_email(0, nowy@sklep.pl);
%update_supplier_email(1, );
%update_supplier_email(1, nowy@sklep.pl);

%update_ticket_type(9, 245, '30dec2017'd);
%update_ticket_type(2, 245, '30dec2017'd);
%mend;

/*%checking_updates();*/
