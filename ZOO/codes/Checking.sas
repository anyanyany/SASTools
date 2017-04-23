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
%macro check_animal(name, sex, birth_date, birth_place, species_id, object_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Zwierze powinno miec imie!; %end;
	%if %length(&sex.)=0 %then %do; %put WARNING: Plec nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&birth_date.)=0 or &birth_date. eq . %then %do; %put WARNING: Data urodzenia nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&species_id.)=0 or &species_id. eq . %then %do; %put WARNING: Gatunek nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&object_id.)=0 or &object_id. eq . %then %do; %put WARNING: Obiekt nie moze byc pusty!; %let ok=0; %goto exit; %end;
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

%macro check_employee(name, second_name, surname, birth_date, PESEL, address_city, address_street, address_house_num, address_flat_num, postal_code, telephone, email, bank_account_num, hire_date, contract_type, __position_code, fte_percentage, salary) / minoperator;
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
	%if %length(&hire_date.)=0 or &hire_date. eq . %then %do; %put WARNING: Data zatrudnienia nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&contract_type.)=0 or &contract_type. eq . %then %do; %put WARNING: Nie podano typu kontraktu!; %let ok=0; %goto exit; %end;
	%if %length(&__position_code.)=0 or &__position_code. eq . %then %do; %put WARNING: Nie podano stanowiska!; %let ok=0; %goto exit; %end;
	%if %length(&fte_percentage.)=0 or &fte_percentage. eq . %then %do; %put WARNING: Nie podano etatu!; %let ok=0; %goto exit; %end;
	%if %length(&salary.)=0 or &salary. eq . %then %do; %put WARNING: Nie podano zarobków!; %let ok=0; %goto exit; %end;

	%if not(&contract_type. in &contract_types.) %then %do; %put WARNING: Niepoprawny typ kontraktu!; %let ok=0; %goto exit; %end;
	%if not(&__position_code. in &position_codes.) %then %do; %put WARNING: Niepoprawne stanowisko!; %let ok=0;  %goto exit; %end;
	%if &fte_percentage gt 100 %then %do; %put WARNING: Nie moze byc wiecej niz 100 procent etatu!; %let ok=0; %goto exit; %end;


	%let dsid=%sysfunc(open(ZOO.POSITIONS, i));  /* otwieramy zbior */
	%if (&dsid=0) %then /* jesli sie nie otworzyl to error i exit */
	%do;
		%put %sysfunc(sysmsg());
		%let ok=0; %goto exit;
	%end;
	%else /* jesli zadzialalo, to przez syscal set tworzymy makrozmienne o nazwach jak zmienne w zbiorze */
	%do;
		%syscall set(dsid);
		%let __I__=1;
		%let position_code = -1;
		%do %while(&position_code. ne &__position_code.); /* iterujemy po zbiorze az znajdziemy rekord ktory nas interesuje */
		 	%let rc=%sysfunc(fetchobs(&dsid, &__I__.));
		    %let __I__=%eval(&__I__. + 1);
		%end;

	 	%let rc=%sysfunc(close(&dsid));
	 	%put &=max_salary &=min_salary;
	 	%if &salary.<&min_salary. or &salary.>&max_salary. %then
	    %do;
	        %put WARNING: Nieodpowiednie wynagrodzenie dla tego stanowiska!; %let ok=0; %goto exit;
	    %end;
	%end;

%exit: &ok.
%mend;

%macro check_food(food_name, quantity, unit);
	%let ok=1;
	%if %length(&food_name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&quantity.)=0 or &quantity. eq . %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&unit.)=0 %then %do; %put WARNING: Jednostka nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_object(object_id, object_type)/minoperator;
	%let ok=1;
	%if %length(&object_type.)=0 %then %do; %put WARNING: Pusty typ!; %let ok=0; %goto exit; %end;
	%if %length(&object_id.) gt 5 %then %do; %put WARNING: Niepoprawny identyfikator!; %let ok=0; %goto exit; %end;
	%if not(%lowcase(&object_type.) in wybieg ptaszarnia akwarium terrarium) %then %do; %put WARNING: Niepoprawny typ obiektu!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_order(name, division_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&division_id.)=0 or &division_id. eq . %then %do; %put WARNING: Gromada nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if not(&division_id. in &divisions.) %then %do; %put WARNING: Niepoprawna gromada!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_expense(invoice_id,  company_name,  NIP, invoice_date,  payment_date,  amount_gross);
	%let ok=1;
	%if %length(&invoice_id.)=0 %then %do; %put WARNING: Numer faktury nie moze byc pusty!; %let ok=0; %goto exit; %end;	
	%if %length(&company_name.)=0 %then %do; %put WARNING: Nazwa firmy nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&NIP.) ne 10 %then %do; %put WARNING: Niepoprawny NIP!; %let ok=0; %goto exit; %end;
	%if %length(&invoice_date.)=0 or &invoice_date. eq . %then %do; %put WARNING: Data wystawienia faktury nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&payment_date.)=0 or &payment_date. eq . %then %do; %put WARNING: Data platnosci nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&amount_gross.)=0 or &amount_gross. eq . %then %do; %put WARNING: Kwota nie moze byc pusta!; %let ok=0; %goto exit; %end;		
	%if &amount_gross. lt 1 %then %do; %put WARNING: Niepoprawna kwota!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_position(name, min_salary, max_salary);
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&min_salary.)=0 or %length(&max_salary.)=0 %then %do; %put WARNING: Przedzial zarobkow musi byc podany!; %let ok=0; %goto exit; %end;
	%if &min_salary. eq . or &max_salary. eq . %then %do; %put WARNING: Przedzial zarobkow musi byc podany!; %let ok=0; %goto exit; %end;	
	%if &min_salary. gt &max_salary. %then %do; %put WARNING: Niepoprawny przedzial zarobkow!; %let ok=0; %goto exit; %end;	
	%exit: &ok.
%mend;

%macro check_responsible_staff(employee_id, object_id)/ minoperator;
	%let ok=1;
	%if %length(&employee_id.)=0 or %length(&object_id.)=0 %then %do; %put WARNING: Pracownik ani obiekt nie moga byc puste!; %let ok=0; %goto exit; %end;	
	%if &employee_id. eq . or &object_id. eq . %then %do; %put WARNING: Pracownik ani obiekt nie moga byc puste!; %let ok=0; %goto exit; %end;			
	%if not(&employee_id. in &employees_resp.) %then %do; %put WARNING: Niepoprawny pracownik!; %let ok=0; %goto exit; %end;
	%if not(&object_id. in &objects.) %then %do; %put WARNING: Niepoprawny obiekt!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_species(name, order_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&order_id.)=0 or &order_id. eq . %then %do; %put WARNING: Rzad nie moze byc pusty!; %let ok=0; %goto exit; %end;	
	%if not(&order_id. in &orders.) %then %do; %put WARNING: Niepoprawny rzad!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_species_requirements(species_id, food_id, amount, unit)/ minoperator;
	%let ok=1;
	%if %length(&species_id.)=0 or %length(&food_id.)=0 %then %do; %put WARNING: Gatunek ani pozywienie nie moga byc puste!; %let ok=0; %goto exit; %end;		
	%if &species_id. eq . or &food_id. eq . %then %do; %put WARNING: Gatunek ani pozywienie nie moga byc puste!; %let ok=0; %goto exit; %end;		
	%if %length(&amount.)=0 or &amount. eq . %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
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
	%if %length(&date.)=0 or &date. eq . %then %do; %put WARNING: Data nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&supplier_id.)=0 or &supplier_id. eq . %then %do; %put WARNING: Dostawca nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if not(&supplier_id. in &suppliers.) %then %do; %put WARNING: Niepoprawny dostawca!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_supply_details(supply_id, food_id, quantity, unit, price)/ minoperator;
	%let ok=1;
	%if %length(&supply_id.)=0 or &supply_id. eq . %then %do; %put WARNING: Dostawa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&food_id.)=0  or &food_id. eq . %then %do; %put WARNING: Pozywienie nie moze byc puste!; %let ok=0; %goto exit; %end;
	%if %length(&quantity.)=0 or &quantity. eq . %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&unit.)=0 %then %do; %put WARNING: Jednostka nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&price.)=0 or &price. eq . %then %do; %put WARNING: Cena nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if &supply_id.>&supplies. %then %do; %put WARNING: Niepoprawna dostawa!; %let ok=0; %goto exit; %end;
	%if not(&food_id. in &foods.) %then %do; %put WARNING: Niepoprawne pozywienie!; %let ok=0; %goto exit; %end;
	%if &quantity. lt 1 %then %do; %put WARNING: Niepoprawna ilosc!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_ticket_type(name, price, valid_from)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&price.)=0 or &price. eq . %then %do; %put WARNING: Cena nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&valid_from.)=0 or &valid_from. eq . %then %do; %put WARNING: Data obowiazywania nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%exit: &ok.
%mend;

%macro check_transaction(date, employee_id)/ minoperator;
	%let ok=1;
	%if %length(&date.)=0 %then %do; %put WARNING: Data nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&employee_id.)=0 or &employee_id. eq . %then %do; %put WARNING: Dostawca nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if not(&employee_id. in &employees_tran.) %then %do; %put WARNING: Niepoprawny pracownik!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_transaction_details(transaction_id, ticket_type_id, quantity)/ minoperator;
	%let ok=1;
	%if %length(&transaction_id.)=0 or &transaction_id. eq . %then %do; %put WARNING: Transakcja nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&ticket_type_id.)=0 or &ticket_type_id. eq . %then %do; %put WARNING: Typ biletu nie moze byc pusty!; %let ok=0; %goto exit; %end;
	%if %length(&quantity.)=0 or &quantity. eq . %then %do; %put WARNING: Ilosc nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if &transaction_id.>&transactions. %then %do; %put WARNING: Niepoprawna transakcja!; %let ok=0; %goto exit; %end;
	%if not(&ticket_type_id. in &tickets.) %then %do; %put WARNING: Niepoprawny typ biletu!; %let ok=0; %goto exit; %end;
	%if &quantity. lt 1 %then %do; %put WARNING: Niepoprawna ilosc!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;


