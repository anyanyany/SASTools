
%macro setSupplyAmount(supply_id);
    *TODO!;
%mend;

%macro insert_supply_details(supply_id, food_id, quantity, unit, price);
    %let ok=%check_supply_details(&supply_id., &food_id.);
    %if &ok.=1 %then %do;
        %let counter=;
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



%insert_supply_details(20720, 4, 57, g, 78)
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
	%if %length(&salary.)=0 %then %do; %put WARNING: Nie podano zarobków!; %let ok=0; %goto exit; %end;

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

%macro check_order(name, division_id)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&division_id.)=0 %then %do; %put WARNING: Gromada nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if not(&division_id. in &divisions.) %then %do; %put WARNING: Niepoprawna gromada!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_responsible_staff(employee_id, object_id)/ minoperator;
	%let ok=1;
	%if %length(&employee_id.)=0 or %length(&object_id.)=0 %then %do; %put WARNING: Pracownik ani obiekt nie moga byc puste!; %let ok=0; %goto exit; %end;		
	%if not(&employee_id. in &employees.) %then %do; %put WARNING: Niepoprawny pracownik!; %let ok=0; %goto exit; %end;
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

%macro check_species_requirements(species_id, food_id)/ minoperator;
	%let ok=1;
	%if %length(&species_id.)=0 or %length(&food_id.)=0 %then %do; %put WARNING: Gatunek ani pozywienie nie moga byc puste!; %let ok=0; %goto exit; %end;		
	%if not(&species_id. in &species.) %then %do; %put WARNING: Niepoprawny gatunek!; %let ok=0; %goto exit; %end;
	%if not(&food_id. in &foods.) %then %do; %put WARNING: Niepoprawne pozywienie!; %let ok=0; %goto exit; %end;
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

%macro check_supply_details(supply_id, food_id)/ minoperator;
	%let ok=1;
	%if %length(&supply_id.)=0 %then %do; %put WARNING: Dostawa nie moze byc pusta!; %let ok=0; %goto exit; %end;	
	%if %length(&food_id.)=0 %then %do; %put WARNING: Pozywienie nie moze byc puste!; %let ok=0; %goto exit; %end;
	%if &supply_id.>&supplies. %then %do; %put WARNING: Niepoprawna dostawa!; %let ok=0; %goto exit; %end;
	%if not(&food_id. in &foods.) %then %do; %put WARNING: Niepoprawne pozywienie!; %let ok=0; %goto exit; %end;
	%exit: &ok.
%mend;

%macro check_ticket_type(name, price, valid_from)/ minoperator;
	%let ok=1;
	%if %length(&name.)=0 %then %do; %put WARNING: Nazwa nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&price.)=0 %then %do; %put WARNING: Cena nie moze byc pusta!; %let ok=0; %goto exit; %end;
	%if %length(&valid_from.)=0 %then %do; %put WARNING: Data obowiazywania nie moze byc pusta!; %let ok=0; %goto exit; %end;	
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
	%let cname=;
	proc sql noprint;
		select type_name into: cname from ZOO.CONTRACT_TYPES where lower(type_name)=lower("&type_name.");
	quit;
	%if &cname. ne %then %do;
		%put WARNING: Taki rekord istnieje w bazie!;
	%end;
	%else %do;
		proc sql noprint;
			select max(contract_type_id)+1 into: maxid from ZOO.CONTRACT_TYPES;
			insert into ZOO.CONTRACT_TYPES values(&maxid., "&type_name.");
		quit;	
		%put NOTE: Wstawiono nowy rekord!;	
	%end;
	%let divname=;
%mend;

%macro insert_division(division_name);
	%let divname=;
	proc sql noprint;
		select division_name into: divname from ZOO.DIVISIONS where lower(division_name)=lower("&division_name.");
	quit;
	%if &divname. ne %then %do;
		%put WARNING: Taki rekord istnieje w bazie!;
	%end;
	%else %do;
		proc sql noprint;
			select max(division_id)+1 into: maxid from ZOO.DIVISIONS;
			insert into ZOO.DIVISIONS values(&maxid., "&division_name.");
		quit;	
		%put NOTE: Wstawiono nowy rekord!;	
	%end;
	%let divname=;
%mend;

/*not working */
%macro insert_employee(name, second_name, surname, birth_date, PESEL, address_city, address_street, address_house_num, address_flat_num, postal_code, telephone, email, bank_account_num, hire_date, contract_type, position_code, fte_percentage, salary);
	%let PSL=;
	proc sql noprint;
		select PESEL into: PSL from ZOO.EMPLOYEES where PESEL="&PESEL.";
	quit;
	%if &PSL. ne %then %do;
		%put WARNING: Pracownik o takim peselu istnieje w bazie!;
	%end;
	%else %do;	
		%let ok=%check_employee(&name., &second_name., &surname., &birth_date., &PESEL., &address_city., &address_street., &address_house_num., &address_flat_num., &postal_code., &telephone., &email., &bank_account_num., &hire_date., &contract_type.,  &position_code., &fte_percentage., &salary.);
		%if &ok.=1 %then %do;
			proc sql noprint;
				select max(employee_id)+1 into: maxid from ZOO.EMPLOYEES;
				insert into ZOO.EMPLOYEES values(&maxid., "&name.", "&second_name.", "&surname.", &birth_date., "&PESEL.", "&address_city.", "&address_street.", "&address_house_num.", &address_flat_num., "&postal_code.", "&telephone.", "&email.", "&bank_account_num.", &hire_date., &contract_type., &position_code., &fte_percentage., &salary.);
			quit;
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
		%else %put WARNING: Nie wstawiono nowego rekordu!;	
	%end;
	%let PSL=;
%mend;

%macro insert_food(food_name, quantity, unit);
	%let fname=;
	proc sql noprint;
		select name into: fname from ZOO.FOOD where lower(name)=lower("&food_name.");
	quit;
	%if &fname. ne %then %do;
		%put WARNING: Taki rekord istnieje w bazie!;
	%end;
	%else %do;
		proc sql noprint;
			select max(food_id)+1 into: maxid from ZOO.FOOD;
			insert into ZOO.FOOD values(&maxid., "&food_name.", &quantity., "&unit.");
		quit;	
		%put NOTE: Wstawiono nowy rekord!;	
	%end;
	%let fname=;
%mend;

%macro insert_object(object_id, object_type)/minoperator;
	%if %length(&object_id.) gt 5 %then %do; %put WARNING: Niepoprawny identyfikator!; %let ok=0; %goto exit; %end;
	%let id=;
	proc sql noprint;
		select object_id into: id from ZOO.OBJECTS where lower(object_id)=lower("&object_id.");
	quit;
	%if &id. ne %then %do;
		%put WARNING: Taki rekord istnieje w bazie!;
	%end;
	%else %do;
		%if not(%lowcase(&object_type.) in wybieg ptaszarnia akwarium terrarium) %then %do;
			%put WARNING: Niepoprawny typ obiektu!;
		%end;
		%else %do;
			proc sql noprint;
				insert into ZOO.OBJECTS values("&object_id.", "&object_type.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%let id=;
	%exit:
%mend;

%macro insert_order(name, division_id);
	%let ok=%check_order(&name., &division_id.);
	%if &ok.=1 %then %do;
		%let oname=;
		proc sql noprint;
			select order_name into: oname from ZOO.ORDERS where lower(order_name)=lower("&name.");
		quit;
		%if &oname. ne %then %do;
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


/* TODO: other_expenses*/

%macro insert_position(name, min_salary, max_salary);
	%let pname=;
	proc sql noprint;
		select name into: pname from ZOO.POSITIONS where lower(name)=lower("&name.");
	quit;
	%if &pname. ne %then %do;
		%put WARNING: Taki rekord istnieje w bazie!;
	%end;
	%else %do;
		proc sql noprint;
			select max(position_code)+1 into: maxid from ZOO.POSITIONS;
			insert into ZOO.POSITIONS values(&maxid., "&name.", &min_salary., &max_salary.);
		quit;	
		%put NOTE: Wstawiono nowy rekord!;	
	%end;
	%let pname=;
%mend;

%macro insert_responsible_staff(employee_id, object_id);
	%let ok=%check_responsible_staff(&employee_id., &object_id.);
	%if &ok.=1 %then %do;
		%let counter=;
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
		%let sname=;
		proc sql noprint;
			select name into: sname from ZOO.SPECIES where lower(name)=lower("&name.") or lower(polish_name)=lower("&polish_name.");
		quit;
		%if &sname. ne %then %do;
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
	%let ok=%check_species_requirements(&species_id., &food_id.);
	%if &ok.=1 %then %do;
		%let counter=;
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
		%let counter=;
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
		%let counter=;
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
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;	
%mend;


%macro setSupplyAmount(supply_id);
	*TODO!;
%mend;

%macro insert_supply_details(supply_id, food_id, quantity, unit, price);
	%let ok=%check_supply_details(&supply_id., &food_id.);
	%if &ok.=1 %then %do;
		%let counter=;
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
		%let counter=;
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




%insert_animal(Kasia, F, '12dec2016'd, ZOO, ., 2, WYB4);
%insert_division(Dinozaury)
%insert_contract_type(Umowa o dzielo)
%insert_employee(Anna, , Nowa, '20dec1980'd, 78012592483, Warsaw, Koszykowa, 67, 34, 03-456, 502858987, , 12345678901234567890123456, '20dec2010'd, 2,  5, 80, 5000);
%insert_food(Frytki, 200, g);
%insert_object(WYB01, wybieg)
%insert_order(Czlowieki, 2);
%insert_position(Pracownik IT, 3000, 7000);
%insert_responsible_staff(1, WYB00)
%insert_species(Homo sapiens, Czlowiek, 24);
%insert_species_requirements(1, 1, 56, kg)
%insert_supplier(SuperSklep, 502656987, ss@super.com, 0261169626)
%insert_supply('12apr2017'd, 6);
%insert_supply_details(20719, 5, 57, g, 78)
%insert_ticket_type(Roczny seniorski, 80, '20mar2017'd)





