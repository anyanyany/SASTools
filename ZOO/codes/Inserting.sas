*options mprint symbolgen;

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

%macro insert_expense(invoice_id,  company_name,  NIP, invoice_date,  payment_date,  amount_gross, description); 
	%let ok=%check_expense(&invoice_id.,  &company_name.,  &NIP., &invoice_date.,  &payment_date.,  &amount_gross.);
	%if &ok.=1 %then %do;
		proc sql noprint;
			select count(*) into: counter from ZOO.OTHER_EXPENSES where lower(invoice_id)=lower("&invoice_id.") and NIP="&NIP.";
		quit;
		%if &counter. ne 0 %then %do;
			%put WARNING: Taki rekord istnieje w bazie!;
		%end;
		%else %do;
			proc sql noprint;
				select max(expense_id)+1 into: maxid from ZOO.OTHER_EXPENSES;
				insert into ZOO.OTHER_EXPENSES values(&maxid., "&invoice_id.",  "&company_name.",  "&NIP.", &invoice_date.,  &payment_date.,  &amount_gross.,"N", "&description.");
			quit;	
			%put NOTE: Wstawiono nowy rekord!;	
		%end;
	%end;
	%else %put WARNING: Nie wstawiono nowego rekordu!;
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



%macro checking_inserts();
%insert_animal(Kasia, F, '12dec2016'd, ZOO, ., 2, WYB4);
%insert_contract_type(Umowa o dzielo)
%insert_division(Dinozaury)
%insert_employee(Anna, , Nowa, '20dec1980'd, 78012552483, Warsaw, Koszykowa, 67, 34, 03-456, 502858987, , 12345678901234567890123456, '20dec2010'd, 2,  5, 80, 5000);
%insert_food(Frytki, 200, g);
%insert_object(WYB0, wybieg)
%insert_order(Czlowieki, 2);
%insert_expense(FV2,  firma,  1234567890, '25apr2017'd,  '13may2017'd,  100); 
%insert_position(Pracownik IT, 3000, 7000);
%insert_responsible_staff(6, WYB5)
%insert_species(Homo sapiens, Czlowiek, 24);
%insert_species_requirements(1, 1, 6, kg)
%insert_supplier(SuperSklep, 502656987, ss@super.com, 0261169626)
%insert_supply('12apr2017'd, 7);
%insert_supply_details(18834, 6, 57, g, 78)
%insert_ticket_type(Roczny seniorski, 80, '20mar2017'd)
%insert_transaction('12may2017'd, 190)
%insert_transaction_details(132981, 5, 2)
%mend;

%checking_inserts();
