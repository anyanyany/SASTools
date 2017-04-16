*options mprint symbolgen;
libname ZOO BASE "D:\SASTools\ZOO";
dm log 'clear';


/* zapisanie do zmiennych potrzebnych identyfikatorow */
proc sql noprint;
	select species_id into: species separated by " " from ZOO.SPECIES;
	select object_id into: objects separated by " " from ZOO.OBJECTS;
	select contract_type_id into: contract_types separated by " " from ZOO.CONTRACT_TYPES;
	select position_code into: position_codes separated by " " from ZOO.POSITIONS;
	select division_id into: divisions separated by " " from ZOO.DIVISIONS;
	select employee_id into: employees separated by " " from ZOO.EMPLOYEES;
	select order_id into: orders separated by " " from ZOO.ORDERS;
	select food_id into: foods separated by " " from ZOO.FOOD;
	select supplier_id into: suppliers separated by " " from ZOO.SUPPLIERS;
	select max(supply_id) into: supplies from ZOO.SUPPLIES;
	select ticket_type_id into: tickets separated by " " from ZOO.TICKET_TYPES;
	select employee_id into: employees_tran SEPARATED BY " "  from ZOO.EMPLOYEES where position_code=9 and layoff_date=.;
	select employee_id into: employees_resp SEPARATED BY " "  from ZOO.EMPLOYEES where position_code=5 and layoff_date=.;
	select max(transaction_id) into: transactions from ZOO.TRANSACTIONS;
quit;



/* makra sprawdzajace poprawnosc danych */
%macro check_animal(name, sex, birth_date, birth_place, deceased_date, species_id, object_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Zwierze powinno miec imie!; %end;
	%if %length(&sex.)=0 %then %do; %put WARNING: Plec nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&birth_date.)=0 %then %do; %put WARNING: Data urodzenia nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&species_id.)=0 %then %do; %put WARNING: Gatunek nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&object_id.)=0 %then %do; %put WARNING: Obiekt nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if &sex. ne F and &sex. ne M %then %do; %put WARNING: Niepoprawna plec!; %let ok=0; %goto exit; %end;
	%if not(&species_id. in &species.) %then %do; %put WARNING: Niepoprawny gatunek!; %let ok=0; %goto exit; %end;	
	%if not(&object_id. in &objects.) %then %do; %put WARNING: Niepoprawny obiekt!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_contract_type(type_name);
	%let ok=1;
	%if %length(&type_name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %end;
	&ok.
%mend;

%macro check_division(division_name);
	%let ok=1;
	%if %length(&division_name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %end;
	&ok.
%mend;

%macro check_employee(name, second_name, surname, birth_date, PESEL, address_city, address_street, address_house_num, address_flat_num, postal_code, telephone, email, bank_account_num, hire_date, contract_type, position_code, fte_percentage, salary) / minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Imie nie moze byc puste!; %let ok=0; %goto exit; %end;
	%if %length(&surname.)=0 %then %do; %put WARNING: Nazwisko nie moze byc puste!; %let ok=0; %goto exit; %end;
	%if %length(&birth_date.)=0 %then %do; %put WARNING: Data urodzenia nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&PESEL.) ne 11 %then %do; %put WARNING: Niepoprawny PESEL!; %let ok=0; %goto exit; %end;
	%if %length(&address_city.)=0 %then %do; %put WARNING: Miasto nie moze byc puste!; %let ok=0; %goto exit; %end;
	%if %length(&address_house_num.)=0 %then %do; %put WARNING: Numer domu nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&postal_code.)=0 %then %do; %put WARNING: Kod pocztowy nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&telephone.)=0 %then %do; %put WARNING: Telefon nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&bank_account_num.) ne 26 %then %do; %put WARNING: Niepoprawny NRB!; %let ok=0; %goto exit; %end;
	%if %length(&contract_type.)=0 %then %do; %put WARNING: Nie podano typu kontraktu!; %let ok=0; %goto exit; %end;
	%if %length(&position_code.)=0 %then %do; %put WARNING: Nie podano stanowiska!; %let ok=0; %goto exit; %end;
	%if %length(&fte_percentage.)=0 %then %do; %put WARNING: Nie podano etatu!; %let ok=0; %goto exit; %end;
	%if %length(&salary.)=0 %then %do; %put WARNING: Nie podano zarobk�w!; %let ok=0; %goto exit; %end;

	%if not(&contract_type. in &contract_types.) %then %do; %put WARNING: Niepoprawny typ kontraktu!; %let ok=0; %goto exit; %end;
	%if not(&position_code. in &position_codes.) %then %do; %put WARNING: Niepoprawne stanowisko!; %let ok=0;  %goto exit; %end;
	%if &fte_percentage gt 100 %then %do; %put WARNING: Nie moze byc wiecej niz 100 procent etatu!; %let ok=0; %goto exit; %end;	
	proc sql noprint;
		select max_salary into: maxsalary from ZOO.POSITIONS where position_code=&position_code.;
		select min_salary into: minsalary from ZOO.POSITIONS where position_code=&position_code.;
	quit;
	%put &=maxsalary &=minsalary;
	%if &salary<&minsalary. or &salary>&maxsalary. %then %do; %put WARNING: Nieodpowiednie wynagrodzenie dla tego stanowiska!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_food(food_name, quantity, unit);
	%let ok=1;
	%if %length(&food_name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&quantity.)=0 %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&unit.)=0 %then %do; %put WARNING: Jednostka nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_object(object_id, object_type)/minoperator;
	%let ok=1;
	%if %length(&object_id.) gt 5 %then %do; %put WARNING: Niepoprawny identyfikator!; %let ok=0; %goto exit; %end;
	%if not(%lowcase(&object_type.) in wybieg ptaszarnia akwarium terrarium) %then %do; %put WARNING: Niepoprawny typ obiektu!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_order(name, division_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&division_id.)=0 %then %do; %put WARNING: Gromada nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if not(&division_id. in &divisions.) %then %do; %put WARNING: Niepoprawna gromada!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_position(name, min_salary, max_salary);
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&min_salary.)=0 or %length(&max_salary.)=0 %then %do; %put WARNING: Przedial zarobkow musi byc podany!; %let ok=0; %goto exit; %end;	
	%exit: &ok.
%mend;

%macro check_responsible_staff(employee_id, object_id)/ minoperator;
	%let ok=1;
	%if %length(&employee_id.)=0 or %length(&object_id.)=0 %then %do; %put WARNING: Pracownik ani obiekt nie moga byc puste!; %let ok=0; %goto exit; %end;		
	%if not(&employee_id. in &employees_resp.) %then %do; %put WARNING: Niepoprawny pracownik!; %let ok=0; %goto exit; %end;
	%if not(&object_id. in &objects.) %then %do; %put WARNING: Niepoprawny obiekt!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_species(name, order_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&order_id.)=0 %then %do; %put WARNING: Rzad nie moze byc pusty!; %let ok=0; %goto exit; %end;	
	%if not(&order_id. in &orders.) %then %do; %put WARNING: Niepoprawny rzad!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_species_requirements(species_id, food_id, amount, unit)/ minoperator;
	%let ok=1;
	%if %length(&species_id.)=0 or %length(&food_id.)=0 %then %do; %put WARNING: Gatunek ani pozywienie nie moga byc puste!; %let ok=0; %goto exit; %end;		
	%if %length(&amount.)=0 %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&unit.)=0 %then %do; %put WARNING: Jednostka nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if not(&species_id. in &species.) %then %do; %put WARNING: Niepoprawny gatunek!; %let ok=0; %goto exit; %end;
	%if not(&food_id. in &foods.) %then %do; %put WARNING: Niepoprawne pozywienie!; %let ok=0; %goto exit; %end;
	%if &amount. lt 1 %then %do; %put WARNING: Niepoprawna ilosc!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_supplier(name, phone, email, NIP)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&phone.)=0 %then %do; %put WARNING: Telefon nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&email.)=0 %then %do; %put WARNING: Email nie moze byc pusty!; %let ok=0; %goto exit; %end;	
	%if %length(&NIP.) ne 10 %then %do; %put WARNING: Niepoprawny NIP!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_supply(date, supplier_id)/ minoperator;
	%let ok=1;
	%if %length(&date.)=0 %then %do; %put WARNING: Data nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&supplier_id.)=0 %then %do; %put WARNING: Dostawca nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if not(&supplier_id. in &suppliers.) %then %do; %put WARNING: Niepoprawny dostawca!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_supply_details(supply_id, food_id, quantity, unit, price)/ minoperator;
	%let ok=1;
	%if %length(&supply_id.)=0 %then %do; %put WARNING: Dostawa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&food_id.)=0 %then %do; %put WARNING: Pozywienie nie moze byc puste!; %let ok=0; %goto exit; %end;
	%if %length(&quantity.)=0 %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&unit.)=0 %then %do; %put WARNING: Jednostka nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&price.)=0 %then %do; %put WARNING: Cena nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if &supply_id.>&supplies. %then %do; %put WARNING: Niepoprawna dostawa!; %let ok=0; %goto exit; %end;
	%if not(&food_id. in &foods.) %then %do; %put WARNING: Niepoprawne pozywienie!; %let ok=0; %goto exit; %end;
	%if &quantity. lt 1 %then %do; %put WARNING: Niepoprawna ilosc!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_ticket_type(name, price, valid_from)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&price.)=0 %then %do; %put WARNING: Cena nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&valid_from.)=0 %then %do; %put WARNING: Data obowiazywania nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%exit: &ok.
%mend;

%macro check_transaction(date, employee_id)/ minoperator;
	%let ok=1;
	%if %length(&date.)=0 %then %do; %put WARNING: Data nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&employee_id.)=0 %then %do; %put WARNING: Dostawca nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if not(&employee_id. in &employees_tran.) %then %do; %put WARNING: Niepoprawny pracownik!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_transaction_details(transaction_id, ticket_type_id, quantity)/ minoperator;
	%let ok=1;
	%if %length(&transaction_id.)=0 %then %do; %put WARNING: Transakcja nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&ticket_type_id.)=0 %then %do; %put WARNING: Typ biletu nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&quantity.)=0 %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if &transaction_id.>&transactions. %then %do; %put WARNING: Niepoprawna transakcja!; %let ok=0; %goto exit; %end;
	%if not(&ticket_type_id. in &tickets.) %then %do; %put WARNING: Niepoprawny typ biletu!; %let ok=0; %goto exit; %end;
	%if &quantity. lt 1 %then %do; %put WARNING: Niepoprawna ilosc!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;



/* makra wstawiajace nowe dane */
%macro insert_animal(name, sex, birth_date, birth_place, deceased_date, species_id, object_id);
	%let ok=%check_animal(&name., &sex., &birth_date., &birth_place., &deceased_date., &species_id., &object_id.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select max(animal_id)+1 into: maxid from ZOO.ANIMALS;
			insert into ZOO.ANIMALS values(&maxid., "&name.", "&sex.", &birth_date., "&birth_place.", &deceased_date., &species_id., "&object_id.");
		quit;	
		%put NOTE: Wstawiono nowy rekord!;	
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_contract_type(type_name);
	%let ok=%check_contract_type(&type_name.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.CONTRACT_TYPES where lower(type_name)=lower("&type_name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(contract_type_id)+1 into: maxid from ZOO.CONTRACT_TYPES;
				insert into ZOO.CONTRACT_TYPES values(&maxid., "&type_name.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_division(division_name);
	%let ok=%check_division(&division_name.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.DIVISIONS where lower(division_name)=lower("&division_name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(division_id)+1 into: maxid from ZOO.DIVISIONS;
				insert into ZOO.DIVISIONS values(&maxid., "&division_name.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

/*not working */
%macro insert_employee(name, second_name, surname, birth_date, PESEL, address_city, address_street, address_house_num, address_flat_num, postal_code, telephone, email, bank_account_num, hire_date, contract_type, position_code, fte_percentage, salary);
	%let ok=%check_employee(&name., &second_name., &surname., &birth_date., &PESEL., &address_city., &address_street., &address_house_num., &address_flat_num., &postal_code., &telephone., &email., &bank_account_num., &hire_date., &contract_type.,  &position_code., &fte_percentage., &salary.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.EMPLOYEES where PESEL="&PESEL.";
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Pracownik o takim peselu istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(employee_id)+1 into: maxid from ZOO.EMPLOYEES;
				insert into ZOO.EMPLOYEES values(&maxid., "&name.", "&second_name.", "&surname.", &birth_date., "&PESEL.", "&address_city.", "&address_street.", "&address_house_num.", &address_flat_num., "&postal_code.", "&telephone.", "&email.", "&bank_account_num.", &hire_date., ., &contract_type., &position_code., &fte_percentage., &salary.);
			quit;
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_food(food_name, quantity, unit);
	%let ok=%check_food(&food_name., &quantity., &unit.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.FOOD where lower(name)=lower("&food_name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(food_id)+1 into: maxid from ZOO.FOOD;
				insert into ZOO.FOOD values(&maxid., "&food_name.", &quantity., "&unit.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_object(object_id, object_type)/minoperator;
	%let ok=%check_object(&object_id., &object_type.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.OBJECTS where lower(object_id)=lower("&object_id.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				insert into ZOO.OBJECTS values("&object_id.", "&object_type.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_order(name, division_id);
	%let ok=%check_order(&name., &division_id.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.ORDERS where lower(order_name)=lower("&name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(order_id)+1 into: maxid from ZOO.ORDERS;
				insert into ZOO.ORDERS values(&maxid., "&name.", &division_id.);
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_expense(); /* TODO*/
%mend;

%macro insert_position(name, min_salary, max_salary);
	%let ok=%check_position(&name., &min_salary., &max_salary.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.POSITIONS where lower(name)=lower("&name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(position_code)+1 into: maxid from ZOO.POSITIONS;
				insert into ZOO.POSITIONS values(&maxid., "&name.", &min_salary., &max_salary.);
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_responsible_staff(employee_id, object_id);
	%let ok=%check_responsible_staff(&employee_id., &object_id.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.RESPONSIBLE_STAFF where lower(object_id)=lower("&object_id.") and employee_id=&employee_id.;
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				insert into ZOO.RESPONSIBLE_STAFF values(&employee_id., "&object_id.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_species(name, polish_name, order_id);
	%let ok=%check_species(&name., &order_id.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.SPECIES where lower(name)=lower("&name.") or lower(polish_name)=lower("&polish_name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(species_id)+1 into: maxid from ZOO.SPECIES;
				insert into ZOO.SPECIES values(&maxid., "&polish_name.","&name.", &order_id.);
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_species_requirements(species_id, food_id, daily_amount, unit);
	%let ok=%check_species_requirements(&species_id., &food_id., &daily_amount., &unit.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.SPECIES_DIETARY_REQUIREMENTS where species_id=&species_id. and food_id=&food_id.;
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(requirement_id)+1 into: maxid from ZOO.SPECIES_DIETARY_REQUIREMENTS;
				insert into ZOO.SPECIES_DIETARY_REQUIREMENTS values(&maxid., &species_id., &food_id., &daily_amount., "&unit.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_supplier(name, phone, email, NIP);
	%let ok=%check_supplier(&name., &phone., &email., &NIP.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.SUPPLIERS where NIP="&NIP.";
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(supplier_id)+1 into: maxid from ZOO.SUPPLIERS;
				insert into ZOO.SUPPLIERS values(&maxid., "&name.", "&phone.", "&email.", "&NIP.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_supply(date, supplier_id);
	%let ok=%check_supply(&date., &supplier_id.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.SUPPLIES where date=&date. and supplier_id=&supplier_id.;
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(supply_id)+1 into: maxid from ZOO.SUPPLIES;
				insert into ZOO.SUPPLIES values(&maxid., &date., &supplier_id., .);
			quit;	
			%let supplies=&maxid.;
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro setSupplyAmount(supply_id);
	proc sql noprint;
		select sum(price) into: amount
		from ZOO.supplies t
		join ZOO.supplies_details td on t.supply_id=td.supply_id
		where t.supply_id=&supply_id.;
		update ZOO.SUPPLIES set amount=&amount where supply_id=&supply_id.;
	quit;
%mend;

%macro insert_supply_details(supply_id, food_id, quantity, unit, price);
	%let ok=%check_supply_details(&supply_id., &food_id., &quantity., &unit., &price.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.SUPPLIES_DETAILS where supply_id=&supply_id. and food_id=&food_id.;
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				insert into ZOO.SUPPLIES_DETAILS values(&supply_id., &food_id., &quantity., "&unit.", &price.);
			quit;	
			%setSupplyAmount(&supply_id.);
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro insert_ticket_type(name, price, valid_from);
	%let ok=%check_ticket_type(&name., &price., &valid_from.);
	%if &ok.=1 %then %do;	
		proc sql noprint;
			select count(*) into: counter from ZOO.TICKET_TYPES where lower(type_name)=lower("&name.");
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;	
			proc sql noprint;
				select max(ticket_type_id)+1 into: maxid from ZOO.TICKET_TYPES;
				insert into ZOO.TICKET_TYPES values(&maxid., "&name.", &price., &valid_from.);
			quit;	
			%put NOTE: Wstawiono nowy rekord!;		
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
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

%macro insert_transaction(date, employee_id);
	%let ok=%check_transaction(&date., &employee_id.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select max(transaction_id)+1 into: maxid from ZOO.TRANSACTIONS;
			insert into ZOO.TRANSACTIONS values(&maxid., &date., &employee_id., .);
		quit;	
		%let transactions=&maxid.;
		%put NOTE: Wstawiono nowy rekord!;			
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;

%macro setTransactionAmount(transaction_id);
	proc sql noprint;
		select sum(td.quantity*tt.price) into: amount
		from ZOO.transactions t
		join ZOO.transaction_details td on t.transaction_id=td.transaction_id
		join ZOO.TICKET_TYPES tt on tt.ticket_type_id=td.ticket_type_id
		where t.transaction_id=&transaction_id.;
		update ZOO.transactions set amount=&amount where transaction_id=&transaction_id.;
	quit;
%mend;

%macro insert_transaction_details(transaction_id, ticket_type_id, quantity);
	%let ok=%check_transaction_details(&transaction_id., &ticket_type_id., &quantity.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.TRANSACTION_DETAILS where transaction_id=&transaction_id. and ticket_type_id=&ticket_type_id.;
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				insert into ZOO.TRANSACTION_DETAILS values(&transaction_id., &ticket_type_id., &quantity.);
			quit;	
			%setTransactionAmount(&transaction_id.);
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;




%insert_animal(Kasia, F, '12dec2016'd, ZOO, ., 2, WYB4);
%insert_contract_type(Umowa o dzielo)
%insert_division(Dinozaury)
%insert_employee(Anna, , Nowa, '20dec1980'd, 78012592483, Warsaw, Koszykowa, 67, 34, 03-456, 502858987, , 12345678901234567890123456, '20dec2010'd, 2,  5, 80, 5000);
%insert_food(Frytki, 200, g);
%insert_object(WYB0, wybieg)
%insert_order(Czlowieki, 2);
%insert_position(Pracownik IT, 3000, 7000);
%insert_responsible_staff(6, WYB5)
%insert_species(Homo sapiens, Czlowiek, 24);
%insert_species_requirements(1, 1, 6, kg)
%insert_supplier(SuperSklep, 502656987, ss@super.com, 0261169626)
%insert_supply('12apr2017'd, 7);
%insert_supply_details(18834, 6, 57, g, 78)
%insert_ticket_type(Roczny seniorski, 80, '20mar2017'd)
%update_ticket_type(2, 245, '30dec2017'd);
%insert_transaction('12may2017'd, 190)
%insert_transaction_details(132981, 5, 2)

%check_employee(Anna, , Nowa, '20dec1980'd, 78012592483, Warsaw, Koszykowa, 67, 34, 03-456, 502858987, , 12345678901234567890123456, '20dec2010'd, 2,  5, 80, 5000);




