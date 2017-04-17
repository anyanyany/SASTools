/* sprawdzenie poprawnosci wszystkich istniejacych danych */

dm log 'clear';

/* wstawienie niepoprawnych danych */
proc sql noprint;
insert into ZOO.ANIMALS values(6320, "Marcin", "f", '20mar2016'd, "ZOO", . , 2, "WYB2");
insert into ZOO.ANIMALS values(6321,"" , "M", '20mar2016'd, "ZOO", . , 5, "WYB2");
insert into ZOO.CONTRACT_TYPES values(5, "");
insert into ZOO.DIVISIONS values(9, "");
insert into ZOO.EMPLOYEES values(203, "Anna", "", "Nowa", '20dec1980'd, "801220524", "Warsaw", "Koszykowa", "67", 34, "03-456", "502858987", "annanowa@op.pl" , "12345678901234567890123456", '20dec2010'd, .,  2,  5, 80, 5000);
insert into ZOO.EMPLOYEES values(204, "Anna", "", "Nowa", '20dec1980'd, "80122052486", "Warsaw", "Koszykowa", "67", 34, "03-456", "502858987", "annanowa@op.pl" , "12345678901234567890123", '20dec2010'd, ., 2,  5, 80, 5000);
insert into ZOO.EMPLOYEES values(205, "Anna", "", "Nowa", '20dec1980'd, "80122052486", "Warsaw", "Koszykowa", "67", 34, "03-456", "502858987", "annanowa@op.pl" , "12345678901234567890123456", '22dec2010'd, '20dec2010'd, 2,  5, 80, 5000);
insert into ZOO.FOOD values(37, "Jedzonko", 100, "");
insert into ZOO.FOOD values(38, "Jedzonko", ., "g");
insert into ZOO.OBJECTS values("WYB00", "Jeziorko");
insert into ZOO.OBJECTS values("WYB01", "");
insert into ZOO.ORDERS values(59, "", 1);
insert into ZOO.ORDERS values(60, "Aaa", .);
insert into ZOO.OTHER_EXPENSES values(902, "Faktura", "Sklep spozywczy", "12345678", '17apr2017'd, '25apr2017'd,300,"N","");
insert into ZOO.OTHER_EXPENSES values(903, "Faktura", "Sklep spozywczy", "1234567890", '17apr2017'd, '25apr2017'd,300,"u","");
insert into ZOO.POSITIONS values(11,"",200,3000);
insert into ZOO.POSITIONS values(12,"Stazysta",200,.);
insert into ZOO.POSITIONS values(13,"Stazysta",2000,300);
insert into ZOO.SPECIES values(358,"","",5);
insert into ZOO.SPECIES_DIETARY_REQUIREMENTS values(800,12,5,.,"g");
insert into ZOO.SPECIES_DIETARY_REQUIREMENTS values(801,12,5,0,"g");
insert into ZOO.SUPPLIERS values(26,"Awokado","700800600","awo@kado.pl","123456789");
insert into ZOO.SUPPLIERS values(27,"Awokado","700800600","","1234567890");
insert into ZOO.SUPPLIERS values(28,"Awokado","","awo@kado.pl","1234567890");
insert into ZOO.SUPPLIES values(30002,'20apr2017'd,2,.);
insert into ZOO.SUPPLIES values(30001,.,2,200);
insert into ZOO.SUPPLIES_DETAILS values(1, 1, 300, "", 40);
insert into ZOO.TICKET_TYPES values(10, "Sezonowy", ., '20apr2017'd);
insert into ZOO.TICKET_TYPES values(11, "", 30, '20apr2017'd);
insert into ZOO.TICKET_TYPES values(12, "Sezonowy", 30, .);
insert into ZOO.TICKET_TYPES_HIST values(1, "Sezonowy", 20, '18apr2017'd,'2apr2017'd );
insert into ZOO.TRANSACTIONS values(200000, '18apr2017'd, 20, .);
insert into ZOO.TRANSACTIONS values(200001, ., 20, 200);
insert into ZOO.TRANSACTION_DETAILS values(1, 1, 0);
quit;


%macro check_entity_animal(name, sex, birth_date, birth_place, deceased_date, species_id, object_id);
	%global check;
   	%let check = %check_animal(&name., &sex., &birth_date., &birth_place., &species_id., &object_id.);
%mend;

%macro check_entity_contract_type(type_name);
	%global check;
   	%let check = %check_contract_type(&type_name.);
%mend;

%macro check_entity_division(division_name);
	%global check;
   	%let check = %check_division(&division_name.);
%mend;

%macro check_entity_employee(name, second_name, surname, birth_date, PESEL, address_city, address_street, address_house_num, address_flat_num, postal_code, telephone, email, bank_account_num, hire_date, layoff_date, contract_type, position_code, fte_percentage, salary);
	%global check;
   	%let check = %check_employee(&name., &second_name., &surname., &birth_date., &PESEL., &address_city., &address_street., &address_house_num., &address_flat_num., &postal_code., &telephone., &email., &bank_account_num., &hire_date., &contract_type.,  &position_code., &fte_percentage., &salary.);
	%if &check. eq 1 and &layoff_date. ne . %then %do;
		%if %eval(&hire_date. gt &layoff_date.) %then %do; %put WARNING: Data zwolnienia nie moze byc wczesniejsza niz data zatrudnienia!; %let check=0; %end;
	%end;
%mend;

%macro check_entity_food(name, quantity, unit);
	%global check;
   	%let check = %check_food(&name., &quantity., &unit.);
%mend;

%macro check_entity_object(object_id, object_type);
	%global check;
   	%let check = %check_object(&object_id., &object_type.);
%mend;

%macro check_entity_order(name, division_id);
	%global check;
   	%let check = %check_order(&name., &division_id.);
%mend;

%macro check_entity_expense(invoice_id,  company_name,  NIP, invoice_date,  payment_date,  amount_gross, paid)/minoperator;
	%global check;
   	%let check = %check_expense(&invoice_id.,  &company_name.,  &NIP., &invoice_date.,  &payment_date.,  &amount_gross.);
	%if &check. eq 1 %then %do;
		%if %length(&paid.)=0 %then %do; %put WARNING: Pole paid nie moze byc puste!; %let check=0; %end;
		%else %do;	
			%if not(&paid in T t N n) %then  %do; %put WARNING: Niepoprawna wartosc pola paid!; %let check=0; %end;
		%end;
	%end;	
%mend;

%macro check_entity_position(name, min_salary, max_salary);
	%global check;
   	%let check = %check_position(&name., &min_salary., &max_salary.);
%mend;

%macro check_entity_responsible_staff(employee_id, object_id);
	%global check;
   	%let check = %check_responsible_staff(&employee_id., &object_id.);
%mend;

%macro check_entity_species(name, order_id);
	%global check;
   	%let check = %check_species(&name., &order_id.);
%mend;

%macro check_entity_species_requirement(species_id, food_id, amount, unit);
	%global check;
   	%let check = %check_species_requirements(&species_id., &food_id., &amount., &unit.);
%mend;

%macro check_entity_supplier(name, phone, email, NIP);
	%global check;
   	%let check = %check_supplier(&name., &phone., &email., &NIP.);
%mend;

%macro check_entity_supply(date, supplier_id, amount);
	%global check;
   	%let check = %check_supply(&date., &supplier_id.);
	%if &check. eq 1 %then %do;
		%if &amount. eq . %then %do; %put WARNING: Kwota nie moze byc pusta!; %let check=0; %end;
	%end;
%mend;

%macro check_entity_supply_details(supply_id, food_id, quantity, unit, price);
	%global check;
   	%let check = %check_supply_details(&supply_id., &food_id., &quantity., &unit., &price.);
%mend;

%macro check_entity_ticket_type(name, price, valid_from);
	%global check;
   	%let check = %check_ticket_type(&name., &price., &valid_from.);
%mend;

%macro check_entity_ticket_type_hist(name, price, valid_from, valid_to);
	%global check;
   	%let check = %check_ticket_type(&name., &price., &valid_from.);
	%if &check. eq 1 %then %do;
		%if %eval(&valid_from. gt &valid_to.) %then %do; %put WARNING: Niepoprawne daty obowiazywania!; %let check=0; %end;
	%end;
%mend;

%macro check_entity_transaction(date, employee_id, amount);
	%global check;
   	%let check = %check_transaction(&date., &employee_id.);
	%if &check. eq 1 %then %do;
		%if &amount. eq . %then %do; %put WARNING: Kwota nie moze byc pusta!; %let check=0; %end;
	%end;
%mend;

%macro check_entity_transaction_details(transaction_id, ticket_type_id, quantity);
	%global check;
   	%let check = %check_transaction_details(&transaction_id., &ticket_type_id., &quantity.);
%mend;


data ZOO.DELETED_ANIMALS;
	set ZOO.ANIMALS; *(where=(animal_id>6200));
	rc=dosubl('%check_entity_animal('||name||', '||sex||', '||birth_date||', '||birth_place||', '||deceased_date||', '||species_id||', '||object_id||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.ANIMALS where animal_id='||animal_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_CONTRACT_TYPES;
	set ZOO.CONTRACT_TYPES; 
	rc=dosubl('%check_entity_contract_type('||type_name||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.CONTRACT_TYPES where contract_type_id='||contract_type_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_DIVISIONS;
	set ZOO.DIVISIONS; 
	rc=dosubl('%check_entity_division('||division_name||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.DIVISIONS where division_id='||division_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_EMPLOYEES;
	set ZOO.EMPLOYEES; 
	rc=dosubl('%check_entity_employee('||name||', '||second_name||', '||surname||', '||birth_date||', '||PESEL||', '||address_city||', '||address_street||', '||address_house_num||', '||address_flat_num||', '||postal_code||', '||telephone||', '||email||', '||bank_account_num||', '||hire_date||', '||layoff_date||', '||contract_type||', '||position_code||', '||fte_percentage||', '||salary||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.EMPLOYEES where employee_id='||employee_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_FOOD;
	set ZOO.FOOD; 
	rc=dosubl('%check_entity_food('||name||', '||quantity||', '||unit||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.FOOD where food_id='||food_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_OBJECTS;
	set ZOO.OBJECTS; 
	rc=dosubl('%check_entity_object('||object_id||', '||object_type||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.OBJECTS where object_id="'||object_id||'"; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_ORDERS;
	set ZOO.ORDERS; 
	rc=dosubl('%check_entity_order('||order_name||', '||division_id||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.ORDERS where order_id='||order_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;
    
data ZOO.DELETED_OTHER_EXPENSES;
	set ZOO.OTHER_EXPENSES ;*(where=(expense_id>=900)); 
	rc=dosubl('%check_entity_expense('||invoice_id||', '||company_name||', '||NIP||', '||invoice_date||', '||payment_date||', '||amount_gross||', '||paid||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.OTHER_EXPENSES where expense_id='||expense_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_POSITIONS;
	set ZOO.POSITIONS; 
	rc=dosubl('%check_entity_position('||name||', '||min_salary||', '||max_salary||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.POSITIONS where position_code='||position_code||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_RESPONSIBLE_STAFF;
	set ZOO.RESPONSIBLE_STAFF; 
	rc=dosubl('%check_entity_responsible_staff('||employee_id||', '||object_id||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.RESPONSIBLE_STAFF where employee_id='||employee_id||' and object_id="'||object_id||'"; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_SPECIES;
	set ZOO.SPECIES; 
	rc=dosubl('%check_entity_species('||name||', '||order_id||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.SPECIES where species_id='||species_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_SPECIES_REQUIREMENTS;
	set ZOO.SPECIES_DIETARY_REQUIREMENTS (where=(requirement_id>=800)); ; 
	rc=dosubl('%check_entity_species_requirement('||species_id||', '||food_id||', '||daily_amount||', '||unit||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.SPECIES_DIETARY_REQUIREMENTS where requirement_id='||requirement_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_SUPPLIERS;
	set ZOO.SUPPLIERS; 
	rc=dosubl('%check_entity_supplier('||name||', '||phone||', '||email||', '||NIP||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.SUPPLIERS where supplier_id='||supplier_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_SUPPLIES;
	set ZOO.SUPPLIES ;*(where=(supply_id>=30000)); 
	rc=dosubl('%check_entity_supply('||date||', '||supplier_id||', '||amount||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.SUPPLIES where supply_id='||supply_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_SUPPLIES_DETAILS;
	set ZOO.SUPPLIES_DETAILS ; *(where=(supply_id<3)); 
	rc=dosubl('%check_entity_supply_details('||supply_id||', '||food_id||', '||quantity||', '||unit||', '||price||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.SUPPLIES_DETAILS where supply_id='||supply_id||' and food_id='||food_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_TICKET_TYPES;
	set ZOO.TICKET_TYPES; 
	rc=dosubl('%check_entity_ticket_type('||type_name||', '||price||', '||valid_from||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.TICKET_TYPES where ticket_type_id='||ticket_type_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_TICKET_TYPES_HIST;
	set ZOO.TICKET_TYPES_HIST; 
	rc=dosubl('%check_entity_ticket_type_hist('||type_name||', '||price||', '||valid_from||', '||valid_to||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.TICKET_TYPES_HIST where ticket_type_id='||ticket_type_id||' and valid_from='||valid_from||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_TRANSACTIONS;
	set ZOO.TRANSACTIONS; * (where=(transaction_id>=200000)); 
	rc=dosubl('%check_entity_transaction('||date||', '||employee_id||', '||amount||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.TRANSACTIONS where transaction_id='||transaction_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;

data ZOO.DELETED_TRANSACTION_DETAILS;
	set ZOO.TRANSACTION_DETAILS ; *(where=(transaction_id<10)); 
	rc=dosubl('%check_entity_transaction_details('||transaction_id||', '||ticket_type_id||', '||quantity||')');
	check=symget('check');
	if check=0 then do; 
		output;
		call execute('proc sql noprint; delete from ZOO.TRANSACTION_DETAILS where transaction_id='||transaction_id||' and ticket_type_id='||ticket_type_id||'; quit;');
		put "NOTE: Usuwam rekord"; 
	end;
	drop rc check;
run;







         
