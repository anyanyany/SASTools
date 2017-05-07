/* generowanie tabelek*/
/*********************/

libname ZOO BASE "D:\SASTools\ZOO";
dm log 'clear';
%let today=%sysfunc(today());


/*tabela zawierajaca rodzaje biletow - historyczna*/
data ZOO.TICKET_TYPES_HIST;
	length ticket_type_id 3 
	type_name $30
	price 3
	valid_from 6
	valid_to 6;
	INFILE DATALINES DLM=',';
 	INPUT ticket_type_id type_name $ price valid_from: date9. valid_to: date9.;
	format valid_from valid_to DDMMYY10.;
	DATALINES;
	1, Jednorazowy normalny, 25, '01jan10'd, '31mar10'd
	2, Jednorazowy ulgowy, 15, '01jan10'd, '31mar10'd
	3, Jednorazowy rodzinny 2+1, 50, '01jan10'd, '31mar10'd
	4, Roczny normalny, 90, '01jan10'd, '31dec10'd
	5, Roczny ulgowy, 70, '01jan10'd, '31dec10'd
	6, Roczny rodzinny 2+1, 200, '01jan10'd, '31dec10'd
	7, Jednorazowy grupowy 10+, 15, '01jan10'd, '31mar10'd
	1, Jednorazowy normalny, 30, '01apr10'd, '30sep10'd
	2, Jednorazowy ulgowy, 20, '01apr10'd, '30sep10'd
	3, Jednorazowy rodzinny 2+1, 65, '01apr10'd, '30sep10'd
	7, Jednorazowy grupowy 10+, 20, '01apr10'd, '30sep10'd
	1, Jednorazowy normalny, 27, '01oct10'd, '31mar11'd
	2, Jednorazowy ulgowy, 17, '01oct10'd, '31mar11'd
	3, Jednorazowy rodzinny 2+1, 55, '01oct10'd, '31mar11'd
	7, Jednorazowy grupowy 10+, 17, '01oct10'd, '31mar11'd
	4, Roczny normalny, 100, '01jan11'd, '31dec11'd
	5, Roczny ulgowy, 80, '01jan11'd, '31dec11'd
	6, Roczny rodzinny 2+1, 220, '01jan11'd, '31dec11'd
	1, Jednorazowy normalny, 30, '01apr11'd, '30sep11'd
	2, Jednorazowy ulgowy, 20, '01apr11'd, '30sep11'd
	3, Jednorazowy rodzinny 2+1, 65, '01apr11'd, '30sep11'd
	7, Jednorazowy grupowy 10+, 20, '01apr11'd, '30sep11'd
	1, Jednorazowy normalny, 25, '01oct11'd, '31mar12'd
	2, Jednorazowy ulgowy, 15, '01oct11'd, '31mar12'd
	3, Jednorazowy rodzinny 2+1, 50, '01oct11'd, '31mar12'd
	7, Jednorazowy grupowy 10+, 15, '01oct11'd, '31mar12'd
	4, Roczny normalny, 90, '01jan12'd, '31dec12'd
	5, Roczny ulgowy, 60, '01jan12'd, '31dec12'd
	6, Roczny rodzinny 2+1, 200, '01jan12'd, '31dec12'd
	1, Jednorazowy normalny, 30, '01apr12'd, '30sep12'd
	2, Jednorazowy ulgowy, 20, '01apr12'd, '30sep12'd
	3, Jednorazowy rodzinny 2+1, 65, '01apr12'd, '30sep12'd
	7, Jednorazowy grupowy 10+, 20, '01apr12'd, '30sep12'd
	1, Jednorazowy normalny, 23, '01oct12'd, '31mar13'd
	2, Jednorazowy ulgowy, 13, '01oct12'd, '31mar13'd
	3, Jednorazowy rodzinny 2+1, 50, '01oct12'd, '31mar13'd
	7, Jednorazowy grupowy 10+, 13, '01oct12'd, '31mar13'd
	4, Roczny normalny, 100, '01jan13'd, '31dec13'd
	5, Roczny ulgowy, 70, '01jan13'd, '31dec13'd
	6, Roczny rodzinny 2+1, 220, '01jan13'd, '31dec13'd
	1, Jednorazowy normalny, 27, '01apr13'd, '30sep13'd
	2, Jednorazowy ulgowy, 17, '01apr13'd, '30sep13'd
	3, Jednorazowy rodzinny 2+1, 55, '01apr13'd, '30sep13'd
	7, Jednorazowy grupowy 10+, 17, '01apr13'd, '30sep13'd
	1, Jednorazowy normalny, 25, '01oct13'd, '31mar14'd
	2, Jednorazowy ulgowy, 15, '01oct13'd, '31mar14'd
	3, Jednorazowy rodzinny 2+1, 50, '01oct13'd, '31mar14'd
	7, Jednorazowy grupowy 10+, 15, '01oct13'd, '31mar14'd
	4, Roczny normalny, 90, '01jan14'd, '31dec15'd
	5, Roczny ulgowy, 70, '01jan14'd, '31dec15'd
	6, Roczny rodzinny 2+1, 200, '01jan14'd, '31dec15'd
	1, Jednorazowy normalny, 27, '01apr14'd, '30sep14'd
	2, Jednorazowy ulgowy, 17, '01apr14'd, '30sep14'd
	3, Jednorazowy rodzinny 2+1, 55, '01apr14'd, '30sep14'd
	7, Jednorazowy grupowy 10+, 17, '01apr14'd, '30sep14'd
	1, Jednorazowy normalny, 23, '01oct14'd, '31mar15'd
	2, Jednorazowy ulgowy, 13, '01oct14'd, '31mar15'd
	3, Jednorazowy rodzinny 2+1, 50, '01oct14'd, '31mar15'd
	7, Jednorazowy grupowy 10+, 13, '01oct14'd, '31mar15'd
	1, Jednorazowy normalny, 27, '01apr15'd, '30sep15'd
	2, Jednorazowy ulgowy, 17, '01apr15'd, '30sep15'd
	3, Jednorazowy rodzinny 2+1, 55, '01apr15'd, '30sep15'
	7, Jednorazowy grupowy 10+, 17, '01apr15'd, '30sep15'd
	1, Jednorazowy normalny, 25, '01oct15'd, '31mar16'd
	2, Jednorazowy ulgowy, 15, '01oct15'd, '31mar16'd
	3, Jednorazowy rodzinny 2+1, 50, '01oct15'd, '31mar16'd
	7, Jednorazowy grupowy 10+, 15, '01oct15'd, '31mar16'd
	1, Jednorazowy normalny, 30, '01apr16'd, '30sep16'd
	2, Jednorazowy ulgowy, 20, '01apr16'd, '30sep16'd
	3, Jednorazowy rodzinny 2+1, 65, '01apr16'd, '30sep16'd
	7, Jednorazowy grupowy 10+, 20, '01apr16'd, '30sep16'd
	1, Jednorazowy normalny, 27, '01oct16'd, '31mar17'd
	2, Jednorazowy ulgowy, 17, '01oct16'd, '31mar17'd
	3, Jednorazowy rodzinny 2+1, 55, '01oct16'd, '31mar17'd
	7, Jednorazowy grupowy 10+, 17, '01oct16'd, '31mar17'd
	;
RUN; 
/*********************/


/*tabela zawierajaca rodzaje biletow*/
data ZOO.TICKET_TYPES;
	length ticket_type_id 3 
	type_name $30
	price 3
	valid_from 6;
	INFILE DATALINES DLM=',';
 	INPUT ticket_type_id type_name $ price valid_from: date9.;
	format valid_from DDMMYY10.;
	DATALINES;
	4, Roczny normalny, 80, '01jan16'd
	5, Roczny ulgowy, 60, '01jan16'd
	6, Roczny rodzinny 2+1, 180, '01jan16'd
	1, Jednorazowy normalny, 30, '01apr17'd
	2, Jednorazowy ulgowy, 20, '01apr17'd
	3, Jednorazowy rodzinny 2+1, 65, '01apr17'd
	7, Jednorazowy grupowy 10+, 20, '01apr17'd
	;
RUN; 
/*********************/



/*tabela zawierajaca mozliwe formy zatrudnienia pracownikow*/
data ZOO.CONTRACT_TYPES;
	length contract_type_id 3 
	type_name $30;
	INFILE DATALINES DLM=',';
 	INPUT contract_type_id type_name $;
	DATALINES;
	1, Umowa o prace
	2, Umowa zlecenie
	3, B2B
	;
RUN; 
/*********************/



/*tabela zawierajaca stanowiska pracownikow*/
data ZOO.POSITIONS;
	length position_code 3 
	name $50
	min_salary 5
	max_salary 5;
	INFILE DATALINES DLM=',';
 	INPUT position_code name $ min_salary max_salary;
	DATALINES;
	1, Dyrektor, 7000, 20000
	2, Zastepca Dyrektora, 5000, 15000
	3, Glówny Ksiegowy, 4000, 10000
	4, Pracownik dzialu Finansowo - Ksiegowego, 3500, 8000
	5, Pracownik dzialu Hodowlanego, 3000, 10000
	6, Pracownik dzialu Zieleni, 3000, 10000
	7, Pracownik dzialu Dydaktycznego, 2500, 7000
	8, Pracownik Techniczny, 3000, 7000
	9, Pracownik ds. administracyjnych i kadrowych, 2500, 6000
	;
RUN; 
/*********************/



/*tabela zawierajaca informacje o pracownikach*/
data ZOO.EMPLOYEES;
	length employee_id 6 
	name $20 
	second_name $20 
	surname $50
	birth_date 6 
	PESEL $11
	address_city $50
	address_street $50
	address_house_num $10
	address_flat_num 3
	postal_code $6
	telephone $9
	email $50
	bank_account_num $26
	hire_date 6
	layoff_date 6
	contract_type 3
	position_code 3
	fte_percentage 3
	salary 5;
	INFILE DATALINES DLM=',';
 	INPUT employee_id name $ second_name $ surname $ birth_date: DDMMYY10. PESEL $	address_city $ address_street $ address_house_num $ address_flat_num 
	postal_code $ telephone $ email $ bank_account_num $ hire_date: DDMMYY10. layoff_date: DDMMYY10. contract_type position_code fte_percentage salary;
	format birth_date hire_date layoff_date DDMMYY10.;
	DATALINES;
	1, Anna, ,Nowak, 09/07/1992, 82070908109, Warszawa, Koszykowa, 45, 123, 00-123, 506980554, anowak@nowak.pl, 12345678901234567890123456, 01/01/10, ., 1, 1, 100, 17000
	2, Karolina, Julia, Kowalska, 01/01/1965, 65010117406, Warszawa, 29 Listopada, 2, 10, 01-740, 596401794, karolina.kowalska@op.pl, 65010117406596401794650101, 01/01/2010, ., 1, 2, 100, 10000
	3, Piotr, , Nowak, 02/02/1966, 66020228517, Warszawa, Adama Idzkowskiego, 22, 21, 02-851, 617512815, piotr.nowak@vp.pl, 66020228517617512815660202, 02/02/2011, ., 1, 2, 100, 10000
	4, Michal, Marcin, Kowalski, 03/03/1967, 67030339628, Pruszków, Adolfa Suligowskiego, 123, 72, 03-962, 728623926, michal.kowalski@gmail.com, 67030339628728623926670303, 03/03/2010, ., 1, 2, 80, 12000
	5, Jakub, Jan, Wisniewski, 04/04/1968, 68040440739, Warszawa, Agrykola, 234, 103, 04-073, 539734037, jakub.wisniewski@op.pl, 68040440739539734037680404, 04/04/2010, ., 3, 3, 100, 8000
	6, Agnieszka, Maria, Dabrowska, 05/05/1969, 69050551840, Warszawa, Bagatela, 46, 45, 05-184, 640845148, agnieszka.dabrowska@vp.pl, 69050551840640845148690505, 05/05/2010, ., 2, 3, 100, 9000
	7, Maria, Anna, Lewandowska, 06/05/1970, 70050662954, Siedlce, Bagno, 66, 65, 06-295, 754956259, maria.lewandowska@gmail.com, 70050662954754956259700506, 06/05/2011, 03/03/2015, 1, 3, 100, 8500
	8, Marcin, , Wójcik, 07/06/1971, 71060773065, Piastów, Barokowa, 167, 116, 07-306, 565067360, marcin.wojcik@vp.pl, 71060773065565067360710607, 07/06/2011, ., 1, 4, 100, 4000
	9, Wojciech, Jakub, Kaminski, 08/07/1972, 72070884476, Warszawa, Bednarska, 278, 147, 08-447, 676478474, wojciech.kaminski@gmail.com, 72070884476676478474720708, 08/07/2010, ., 1, 4, 100, 5000
	10, Bartosz, Daniel, Kowalczyk, 09/08/1973, 73080995587, Siedlce, Belwederska, 90, 89, 09-558, 787589585, bartosz.kowalczyk@o2.pl, 73080995587787589585730809, 09/08/2010, ., 1, 4, 100, 6000
	11, Zuzanna, Anna, Zielinska, 10/09/1974, 74091006698, Warszawa, Bialoskórnicza, 101, 109, 00-669, 598690696, zuzanna.zielinska@aol.com, 74091006698598690696740910, 10/09/2012, ., 1, 4, 100, 7000
	12, Monika, Julia, Szymanska, 11/10/1975, 75101117709, Warszawa, Bielanska, 102, 51, 01-770, 619701717, monika.szymanska@op.pl, 75101117709619701717751011, 11/10/2013, ., 3, 4, 100, 4000
	13, Iga, , Wozniak, 12/11/1976, 76111221810, Warszawa, Blonska, 213, 82, 02-181, 720812128, iga.wozniak@wp.pl, 76111221810720812128761112, 12/11/2014, ., 1, 4, 100, 5000
	14, Artur, , Kozlowski, 13/12/1977, 77121332924, Warszawa, Boczna, 25, 24, 03-292, 534923239, artur.kozlowski@gmail.com, 77121332924534923239771213, 13/12/2015, ., 2, 4, 80, 4000
	15, Pawel, Mateusz, Jankowski, 14/01/1978, 78011443035, Warszawa, Bohaterów Getta, 45, 44, 04-303, 645034340, pawel.jankowski@op.pl, 78011443035645034340780114, 14/01/2016, ., 1, 4, 100, 6000
	16, Daniel, Adam, Wojciechowski, 15/02/1979, 79021554146, Warszawa, Boleslawa Prusa, 146, 95, 05-414, 756145451, daniel.wojciechowski@vp.pl, 79021554146756145451790215, 15/02/2010, ., 3, 4, 100, 7000
	17, Andrzej, , Kwiatkowski, 16/03/1980, 80031665257, Piastów, Bolesc, 257, 126, 06-525, 567256562, andrzej.kwiatkowski@gmail.com, 80031665257567256562800316, 16/03/2011, 01/01/2015, 1, 5, 100, 4000
	18, Pawel, Kamil, Kaczmarek, 17/04/1981, 81041776368, Warszawa, Bonifraterska, 69, 68, 07-636, 678367673, pawel.kaczmarek@o2.pl, 81041776368678367673810417, 17/04/2010, ., 1, 9, 100, 3000
	19, Adam, Jakub, Mazur, 18/05/1982, 82051887479, Warszawa, bp. Juliusza Burschego, 89, 88, 08-747, 789478784, adam.mazur@gmail.com, 82051887479789478784820518, 18/05/2010, ., 1, 5, 100, 5000
	20, Zbigniew, Antoni, Krawczyk, 19/05/1983, 83051998580, Warszawa, Bracka, 181, 139, 09-858, 590589895, zbigniew.krawczyk@op.pl, 83051998580590589895830519, 19/05/2010, ., 1, 6, 100, 6000
	21, Ireneusz, , Piotrowski, 20/06/1984, 84062009691, Warszawa, Browarna, 292, 161, 00-969, 611690916, ireneusz.piotrowski@wp.pl, 84062009691611690916840620, 20/06/2011, ., 1, 5, 100, 7000
	22, Partyk, Jan, Grabowski, 21/07/1985, 85072140702, Siedlce, Brzozowa, 4, 3, 04-070, 722704027, partyk.grabowski@gmail.com, 85072140702722704027850721, 21/07/2011, ., 1, 6, 100, 8000
	23, Julia, Anna, Nowakowska, 22/08/1986, 86082251143, Warszawa, Bugaj, 24, 23, 05-114, 533145131, julia.nowakowska@op.pl, 86082251143533145131860822, 22/08/2010, 02/02/2016, 1, 5, 100, 5000
	24, Ada, Agnieszka, Pawlowska, 23/09/1987, 87092362254, Warszawa, Canaletta, 125, 74, 06-225, 644256242, ada.pawlowska@vp.pl, 87092362254644256242870923, 23/09/2010, ., 1, 7, 100, 3000
	25, Zofia, , Michalska, 24/10/1988, 88102479365, Warszawa, Cecylii Sniegockiej, 236, 105, 07-936, 755367953, zofia.michalska@gmail.com, 88102479365755367953881024, 24/10/2012, ., 3, 7, 100, 4000
	26, Anna, Maria, Nowicka, 25/11/1989, 89112580446, Warszawa, Celna, 48, 47, 08-044, 566448064, anna.nowicka@o2.pl, 89112580446566448064891125, 25/11/2013, ., 1, 7, 100, 3000
	27, Danuta, , Adamczyk, 26/12/1990, 90122691557, Warszawa, Chmielna, 68, 67, 09-155, 677559175, danuta.adamczyk@aol.com, 90122691557677559175901226, 26/12/2010, ., 1, 7, 100, 3500
	28, Ewa, Katarzyna, Dudek, 27/01/1991, 91012702061, Warszawa, Ciasna, 169, 119, 00-206, 791060290, ewa.dudek@op.pl, 91012702061791060290910127, 27/01/2011, ., 1, 5, 100, 6000
	29, Ewelina, Joanna, Zajac, 28/02/1992, 92022813172, Warszawa, Cicha, 271, 141, 01-317, 512171311, ewelina.zajac@wp.pl, 92022813172512171311920228, 28/02/2010, ., 2, 5, 100, 7000
	30, Monika, Marlena, Wieczorek, 29/03/1993, 93032924283, Warszawa, Czerniakowska, 83, 83, 02-428, 623282422, monika.wieczorek@gmail.com, 93032924283623282422930329, 29/03/2010, ., 1, 5, 50, 4000
	31, Lukasz, , Jablonski, 30/04/1965, 65043035394, Pruszków, Czerwonego Krzyza, 103, 103, 03-539, 734393533, lukasz.jablonski@op.pl, 65043035394734393533650430, 30/04/2010, 04/04/2016, 1, 6, 100, 9000
	32, Lucjan, Jan, Król, 16/05/1966, 66051646405, Piastów, Danilowiczowska, 104, 54, 04-640, 545404644, lucjan.krol@vp.pl, 66051646405545404644660516, 16/05/2011, ., 1, 5, 100, 7000
	33, Ryszard, Piotr, Majewski, 17/05/1967, 67051757510, Warszawa, Dawna, 215, 85, 05-751, 650515755, ryszard.majewski@gmail.com, 67051757510650515755670517, 17/05/2011, ., 1, 8, 100, 4000
	34, Roman, Andrzej, Olszewski, 18/06/1968, 68061868621, Warszawa, Dluga, 27, 27, 06-862, 761626866, roman.olszewski@o2.pl, 68061868621761626866680618, 18/06/2010, ., 1, 8, 100, 4000
	35, Dariusz, Bartosz, Jaworski, 19/07/1969, 69071979732, Warszawa, Dobra, 47, 47, 07-973, 572737977, dariusz.jaworski@gmail.com, 69071979732572737977690719, 19/07/2010, 05/05/2015, 1, 7, 100, 3500
	36, Dawid, Krzysztof, Wróbel, 20/08/1970, 70082010843, Warszawa, Dowcip, 148, 98, 01-084, 683841088, dawid.wrobel@op.pl, 70082010843683841088700820, 20/08/2012, ., 1, 7, 100, 4500
	37, Daria, Amelia, Malinowska, 21/09/1971, 71092124954, Warszawa, Dragonów, 259, 129, 02-495, 794952499, daria.malinowska@wp.pl, 71092124954794952499710921, 21/09/2013, ., 3, 6, 100, 8000
	38, Malogrzata, Karolina, Pawlak, 22/10/1972, 72102235065, Warszawa, Drewniana, 62, 62, 03-506, 515063510, malogrzata.pawlak@gmail.com, 72102235065515063510721022, 22/10/2010, ., 1, 5, 100, 6000
	39, Magdalena, Maria, Witkowska, 23/11/1973, 73112346176, Warszawa, Dynasy, 82, 82, 04-617, 626174621, magdalena.witkowska@op.pl, 73112346176626174621731123, 23/11/2011, ., 1, 5, 80, 5000
	40, Karolina, , Walczak, 24/12/1974, 74122457217, Warszawa, Dziekania, 183, 133, 05-721, 737215732, karolina.walczak@vp.pl, 74122457217737215732741224, 24/12/2010, 06/05/2016, 1, 8, 100, 5000
	41, Stanislaw, Maciej, Stepien, 25/05/1975, 75052568328, Warszawa, Dzielna, 294, 164, 06-832, 548326843, stanislaw.stepien@gmail.com, 75052568328548326843750525, 25/05/2010, ., 1, 8, 100, 4500
	42, Maciej, Jan, Górski, 26/06/1976, 76062679439, Warszawa, Dzika, 6, 6, 07-943, 659437954, maciej.gorski@o2.pl, 76062679439659437954760626, 26/06/2010, ., 2, 5, 100, 8000
	43, Jakub, , Rutkowski, 27/07/1977, 77072780540, Warszawa, Edwarda Fondaminskiego, 26, 26, 08-054, 760548065, jakub.rutkowski@aol.com, 77072780540760548065770727, 27/07/2011, ., 1, 5, 100, 9000
	44, Jan, , Michalak, 28/08/1978, 78082891651, Warszawa, Elektoralna, 127, 77, 09-165, 571659176, jan.michalak@op.pl, 78082891651571659176780828, 28/08/2011, ., 1, 5, 100, 7000
	45, Janina, , Sikora, 29/09/1979, 79092902702, Siedlce, Elektryczna, 238, 108, 00-270, 682700287, janina.sikora@wp.pl, 79092902702682700287790929, 29/09/2010, 07/06/2015, 1, 7, 100, 4000
	46, Grazyna, , Ostrowska, 30/10/1980, 80103013813, Warszawa, Emila Zoli, 50, 50, 01-381, 793811398, grazyna.ostrowska@gmail.com, 80103013813793811398801030, 30/10/2010, ., 1, 7, 100, 4500
	47, Katarzyna, Angelika, Baran, 01/11/1981, 81110124924, Warszawa, Emiliana Konopczynskiego, 61, 61, 02-492, 514922419, katarzyna.baran@op.pl, 81110124924514922419811101, 01/11/2012, ., 1, 5, 100, 6000
	48, Antoni, Pawel, Duda, 02/12/1982, 82120235035, Warszawa, Emilii Plater, 162, 112, 03-503, 625033520, antoni.duda@vp.pl, 82120235035625033520821202, 02/12/2013, ., 1, 5, 100, 5000
	49, Szymon, , Szewczyk, 03/01/1983, 83010346446, Warszawa, Fabryczna, 273, 143, 04-644, 736444634, szymon.szewczyk@gmail.com, 83010346446736444634830103, 03/01/2014, 08/07/2016, 3, 5, 60, 6000
	50, Filip, Janusz, Tomaszewski, 04/02/1984, 84020457557, Warszawa, Faustyna Czerwijowskiego, 85, 85, 05-755, 547555745, filip.tomaszewski@o2.pl, 84020457557547555745840204, 04/02/2015, ., 1, 9, 100, 2500
	51, Kacper, , Pietrzak, 05/03/1985, 85030561668, Warszawa, Filtrowa, 105, 105, 06-166, 658666156, kacper.pietrzak@gmail.com, 85030561668658666156850305, 05/03/2016, ., 1, 5, 100, 4000
	52, Aleksander, , Marciniak, 06/04/1986, 86040672079, Warszawa, Flory, 106, 56, 07-207, 769077260, aleksander.marciniak@op.pl, 86040672079769077260860406, 06/04/2010, ., 1, 6, 100, 8000
	53, Franciszek, , Wróblewski, 07/05/1987, 87050783480, Piastów, Freta, 217, 87, 08-348, 570488374, franciszek.wroblewski@wp.pl, 87050783480570488374870507, 07/05/2011, ., 1, 5, 100, 9000
	54, Mikolaj, , Zalewski, 08/05/1988, 88050894594, Warszawa, Fryderyka Chopina, 29, 30, 09-459, 694599495, mikolaj.zalewski@gmail.com, 88050894594694599495880508, 08/05/2010, ., 1, 5, 100, 8000
	55, Marcel, Adam, Jakubowski, 09/06/1989, 89060905605, Pruszków, Furmanska, 49, 41, 00-560, 715600516, marcel.jakubowski@op.pl, 89060905605715600516890609, 09/06/2010, 09/08/2015, 1, 8, 100, 4000
	56, Wiktor, , Jasinski, 10/07/1990, 90071046716, Warszawa, Gabriela Piotra Boduena, 141, 92, 04-671, 526714627, wiktor.jasinski@vp.pl, 90071046716526714627900710, 10/07/2010, ., 1, 8, 100, 5000
	57, Tomasz, Pawel, Zawadzki, 11/08/1991, 91081157820, Warszawa, Garbarska, 252, 123, 05-782, 630825738, tomasz.zawadzki@gmail.com, 91081157820630825738910811, 11/08/2011, ., 2, 5, 100, 7000
	58, Igor, , Sadowski, 12/09/1992, 92091268931, Warszawa, Graniczna, 64, 65, 06-893, 741936849, igor.sadowski@o2.pl, 92091268931741936849920912, 12/09/2011, ., 1, 5, 100, 8000
	59, Mateusz, , Bak, 13/10/1993, 93101379042, Warszawa, Grodzka, 84, 85, 07-904, 552047950, mateusz.bak@aol.com, 93101379042552047950931013, 13/10/2010, ., 1, 5, 100, 9000
	60, Alan, , Chmielewski, 14/11/1965, 65111480153, Warszawa, Grzybowska, 185, 136, 08-015, 663158061, alan.chmielewski@op.pl, 65111480153663158061651114, 14/11/2010, 10/09/2016, 1, 5, 100, 7000
	61, Stanislaw, Piotr, Wlodarczyk, 15/08/1966, 66081591264, Warszawa, Henryka Sienkiewicza, 296, 167, 09-126, 774269172, stanislaw.wlodarczyk@wp.pl, 66081591264774269172660815, 15/08/2012, ., 3, 5, 100, 6000
	62, Zuzanna, Danuta, Borkowska, 16/09/1967, 67091602375, Warszawa, Hipoteczna, 8, 9, 00-237, 585370283, zuzanna.borkowska@gmail.com, 67091602375585370283670916, 16/09/2013, ., 1, 5, 100, 5000
	63, Lena, , Czarnecka, 17/10/1968, 68101713486, Warszawa, Hoza, 28, 29, 01-348, 696481394, lena.czarnecka@op.pl, 68101713486696481394681017, 17/10/2010, ., 1, 6, 80, 6000
	64, Julia, Agnieszka, Sawicka, 18/11/1969, 69111824597, Warszawa, Ignacego Potockiego, 129, 71, 02-459, 717592415, julia.sawicka@vp.pl, 69111824597717592415691118, 18/11/2011, ., 1, 5, 100, 8000
	65, Marlena, , Sokolowska, 19/12/1970, 70121935608, Warszawa, Inflancka, 231, 102, 03-560, 528603526, marlena.sokolowska@gmail.com, 70121935608528603526701219, 19/12/2010, ., 1, 6, 100, 9000
	66, Hanna, , Urbanska, 20/01/1971, 71012046749, Warszawa, Jana i Jedrzeja Sniadeckich, 43, 44, 04-674, 639744637, hanna.urbanska@o2.pl, 71012046749639744637710120, 20/01/2010, 11/10/2015, 1, 5, 100, 8500
	67, Amelia, Iga, Kubiak, 21/02/1972, 72022157150, Warszawa, Jana Jezioranskiego, 63, 64, 05-715, 740155741, amelia.kubiak@gmail.com, 72022157150740155741720221, 21/02/2010, ., 1, 9, 100, 3000
	68, Aleksandra, , Maciejewska, 22/03/1973, 73032268261, Warszawa, Jana Kilinskiego, 164, 115, 06-826, 551266852, aleksandra.maciejewska@op.pl, 73032268261551266852730322, 22/03/2011, ., 1, 5, 100, 7000
	69, Alicja, Kinga, Szczepanska, 23/04/1974, 74042379362, Warszawa, Jana Matejki, 275, 146, 07-936, 662367963, alicja.szczepanska@wp.pl, 74042379362662367963740423, 23/04/2011, ., 2, 8, 100, 6000
	70, Oliwia, , Kucharska, 24/05/1975, 75052460473, Piastów, Jana Pankiewicza, 87, 88, 06-047, 773476074, oliwia.kucharska@gmail.com, 75052460473773476074750524, 24/05/2010, ., 1, 8, 100, 5000
	71, Wiktoria, Oliwia, Wilk, 25/05/1976, 76052571584, Warszawa, Zagloby, 107, 108, 07-158, 584587185, wiktoria.wilk@op.pl, 76052571584584587185760525, 25/05/2010, 12/11/2016, 1, 9, 100, 4000
	72, Nikola, , Kalinowska, 26/06/1977, 77062682095, Warszawa, Janusza Kusocinskiego, 108, 59, 08-209, 695098290, nikola.kalinowska@vp.pl, 77062682095695098290770626, 26/06/2012, ., 1, 5, 100, 6000
	73, Gabriela, Monika, Lis, 27/07/1978, 78072793106, Warszawa, Jasna, 219, 81, 09-310, 716109311, gabriela.lis@gmail.com, 78072793106716109311780727, 27/07/2013, ., 3, 5, 100, 7000
	74, Antonina, , Mazurek, 28/08/1979, 79082804247, Siedlce, Jaworzynska, 22, 23, 00-424, 527240422, antonina.mazurek@o2.pl, 79082804247527240422790828, 28/08/2010, ., 1, 5, 100, 8000
	75, Nadia, Zuzanna, Wysocka, 09/09/1980, 80090945358, Warszawa, Jazdów, 42, 43, 04-535, 638354533, nadia.wysocka@aol.com, 80090945358638354533800909, 09/09/2011, ., 1, 5, 50, 3500
	76, Michal, , Adamski, 10/10/1981, 81101056469, Pruszków, Jezuicka, 143, 94, 05-646, 749465644, michal.adamski@op.pl, 81101056469749465644811010, 10/10/2010, ., 1, 6, 100, 6000
	77, Jakub, Krzysztof, Kazmierczak, 11/11/1982, 82111167570, Warszawa, Johna Lennona, 254, 125, 06-757, 550576755, jakub.kazmierczak@wp.pl, 82111167570550576755821111, 11/11/2010, ., 1, 5, 100, 7000
	78, Agnieszka, , Wasilewska, 12/12/1983, 83121278684, Warszawa, Józefa Hoene-Wronskiego, 66, 67, 07-868, 664687866, agnieszka.wasilewska@gmail.com, 83121278684664687866831212, 12/12/2010, 13/12/2015, 2, 5, 100, 8000
	79, Maria, Wiktoria, Sobczak, 13/01/1984, 84011389795, Warszawa, Józefa Lewartowskiego, 86, 87, 08-979, 775798977, maria.sobczak@op.pl, 84011389795775798977840113, 13/01/2011, ., 1, 5, 100, 9000
	80, Marcin, , Czerwinski, 14/02/1985, 85021490806, Warszawa, Juliana Bartoszewicza, 187, 139, 09-080, 596809098, marcin.czerwinski@vp.pl, 85021490806596809098850214, 14/02/2011, ., 1, 6, 100, 8000
	81, Ryszard, , Andrzejewski, 15/03/1986, 86031504941, Warszawa, Juliana Przybosia, 298, 161, 00-494, 611940419, ryszard.andrzejewski@gmail.com, 86031504941611940419860315, 15/03/2010, ., 1, 5, 100, 7500
	82, Roman, , Cieslak, 16/04/1987, 87041615052, Piastów, Juliana Smulikowskiego, 10, 3, 01-505, 722051520, roman.cieslak@o2.pl, 87041615052722051520870416, 16/04/2010, ., 1, 5, 100, 7000
	83, Dariusz, , Glowacki, 17/05/1988, 88051726163, Warszawa, Juliana Tuwima, 21, 23, 02-616, 533162631, dariusz.glowacki@gmail.com, 88051726163533162631880517, 17/05/2012, ., 1, 5, 100, 6500
	84, Dawid, Alan, Zakrzewski, 18/05/1989, 89051837274, Warszawa, Jurija Gagarina, 122, 74, 03-727, 644273742, dawid.zakrzewski@op.pl, 89051837274644273742890518, 18/05/2013, ., 1, 5, 100, 6000
	85, Bartosz, , Kolodziej, 19/06/1990, 90061948385, Warszawa, Kamienne Schodki, 233, 105, 04-838, 755384853, bartosz.kolodziej@wp.pl, 90061948385755384853900619, 19/06/2014, ., 3, 5, 100, 7000
	86, Zuzanna, , Sikorska, 20/07/1991, 91072059490, Warszawa, Kanonia, 45, 47, 05-949, 560495964, zuzanna.sikorska@gmail.com, 91072059490560495964910720, 20/07/2015, ., 1, 5, 100, 8000
	87, Monika, Pamela, Krajewska, 21/08/1992, 92082160501, Warszawa, Kapitulna, 65, 67, 06-050, 671506075, monika.krajewska@op.pl, 92082160501671506075920821, 21/08/2016, ., 1, 5, 100, 6000
	88, Iga, , Gajewska, 22/09/1993, 93092271612, Warszawa, Kapucynska, 166, 118, 07-161, 782617186, iga.gajewska@vp.pl, 93092271612782617186930922, 22/09/2010, 14/01/2016, 1, 5, 100, 5500
	89, Artur, Piotr, Szymczak, 23/10/1965, 65102312723, Warszawa, Karmelicka, 277, 149, 01-272, 593721297, artur.szymczak@gmail.com, 65102312723593721297651023, 23/10/2011, ., 1, 5, 100, 7000
	90, Julia, , Szulc, 24/11/1966, 66112423834, Warszawa, Karowa, 89, 82, 02-383, 614832318, julia.szulc@o2.pl, 66112423834614832318661124, 24/11/2010, ., 2, 5, 100, 6000
	91, Marlena, , Baranowska, 25/12/1967, 67122534945, Warszawa, Kawalerii, 109, 102, 03-494, 725943429, marlena.baranowska@aol.com, 67122534945725943429671225, 25/12/2010, ., 1, 8, 60, 3000
	92, Hanna, , Laskowska, 26/05/1968, 68052645056, Warszawa, Kazimierza Karasia, 101, 53, 04-505, 536054530, hanna.laskowska@op.pl, 68052645056536054530680526, 26/05/2010, ., 1, 5, 100, 6500
	93, Amelia, , Brzezinska, 27/06/1969, 69062756467, Warszawa, Klonowa, 212, 84, 05-646, 647465644, amelia.brzezinska@wp.pl, 69062756467647465644690627, 27/06/2011, ., 1, 6, 100, 5500
	94, Aleksandra, , Makowska, 28/07/1970, 70072867578, Warszawa, Klopot, 24, 26, 06-757, 758576755, aleksandra.makowska@gmail.com, 70072867578758576755700728, 28/07/2011, ., 1, 5, 100, 4500
	95, Monika, Sylwia, Ziólkowska, 29/08/1971, 71082971619, Warszawa, Konstantego Ildefonsa Galczynskiego, 44, 46, 07-161, 569617166, monika.ziolkowska@op.pl, 71082971619569617166710829, 29/08/2010, 15/02/2015, 1, 9, 100, 5000
	96, Iga, , Przybylska, 30/09/1972, 72093082620, Warszawa, Konwiktorska, 145, 97, 08-262, 670628276, iga.przybylska@vp.pl, 72093082620670628276720930, 30/09/2010, ., 1, 5, 100, 8500
	97, Artur, , Domanski, 16/10/1973, 73101693731, Piastów, Koszykowa, 256, 128, 09-373, 781739387, artur.domanski@gmail.com, 73101693731781739387731016, 16/10/2012, ., 3, 6, 100, 7500
	98, Pawel, , Nowacki, 17/11/1974, 74111704842, Warszawa, Koscielna, 68, 70, 00-484, 592840498, pawel.nowacki@o2.pl, 74111704842592840498741117, 17/11/2013, ., 1, 5, 100, 7000
	99, Daniel, Lukasz, Borowski, 18/12/1975, 75121815953, Warszawa, Kozia, 88, 81, 01-595, 613951519, daniel.borowski@gmail.com, 75121815953613951519751218, 18/12/2010, ., 1, 5, 100, 8000
	100, Andrzej, , Blaszczyk, 19/01/1976, 76011926004, Pruszków, Kozla, 189, 132, 02-600, 724002620, andrzej.blaszczyk@op.pl, 76011926004724002620760119, 19/01/2011, ., 1, 5, 100, 7000
	101, Ewelina, , Chojnacka, 20/02/1977, 77022037415, Warszawa, Kozminska, 291, 163, 03-741, 535413734, ewelina.chojnacka@wp.pl, 77022037415535413734770220, 20/02/2010, ., 1, 5, 100, 6000
	102, Monika, , Ciesielska, 21/03/1978, 78032148526, Warszawa, Krakowskie Przedmiescie, 3, 5, 04-852, 646524845, monika.ciesielska@gmail.com, 78032148526646524845780321, 21/03/2010, 16/03/2016, 2, 5, 80, 5000
	103, Lukasz, Mateusz, Mróz, 22/04/1979, 79042259637, Warszawa, Kredytowa, 23, 25, 05-963, 757635956, lukasz.mroz@op.pl, 79042259637757635956790422, 22/04/2010, ., 1, 5, 100, 8000
	104, Lucjan, , Szczepaniak, 23/05/1980, 80052360548, Warszawa, Kreta, 124, 76, 06-054, 568546065, lucjan.szczepaniak@vp.pl, 80052360548568546065800523, 23/05/2011, ., 1, 5, 100, 7000
	105, Ryszard, , Wesolowski, 24/05/1981, 81052471659, Warszawa, Królewska, 235, 107, 07-165, 679657176, ryszard.wesolowski@gmail.com, 81052471659679657176810524, 24/05/2011, ., 1, 5, 100, 6000
	106, Roman, , Górecki, 17/06/1982, 82061782760, Warszawa, Krucza, 47, 50, 08-276, 790768297, roman.gorecki@o2.pl, 82061782760790768297820617, 17/06/2010, 17/04/2015, 1, 5, 100, 5000
	107, Dariusz, , Krupa, 18/07/1983, 83071893874, Siedlce, Krzysztofa Kamila Baczynskiego, 67, 61, 09-387, 514879318, dariusz.krupa@aol.com, 83071893874514879318830718, 18/07/2010, ., 1, 5, 100, 6000
	108, Dawid, , Kaczmarczyk, 19/08/1984, 84081904985, Warszawa, Krzywe Kolo, 168, 112, 00-498, 625980429, dawid.kaczmarczyk@op.pl, 84081904985625980429840819, 19/08/2012, ., 1, 8, 50, 2500
	109, Aleksander, , Leszczynski, 20/01/1985, 85012045096, Warszawa, Krzywopoboczna, 279, 143, 04-509, 736094530, aleksander.leszczynski@wp.pl, 85012045096736094530850120, 20/01/2013, ., 3, 5, 100, 8000
	110, Franciszek, Jan, Lipinski, 21/02/1986, 86022156406, Warszawa, ks. Ignacego Skorupki, 82, 85, 05-640, 546405644, franciszek.lipinski@gmail.com, 86022156406546405644860221, 21/02/2010, ., 1, 8, 100, 3000
	111, Mikolaj, , Kowalewski, 22/03/1987, 87032267517, Warszawa, Ksiazeca, 102, 105, 06-751, 657516755, mikolaj.kowalewski@op.pl, 87032267517657516755870322, 22/03/2011, 18/05/2016, 2, 5, 100, 7000
	112, Marcel, Piotr, Urbaniak, 23/04/1988, 88042378628, Piastów, Kubusia Puchatka, 103, 56, 07-862, 768627866, marcel.urbaniak@vp.pl, 88042378628768627866880423, 23/04/2010, ., 1, 9, 100, 4000
	113, Wiktor, , Kozak, 24/05/1989, 89052489739, Warszawa, Ladowa, 214, 87, 08-973, 579738977, wiktor.kozak@gmail.com, 89052489739579738977890524, 24/05/2010, ., 1, 5, 100, 8000
	114, Magdalena, , Kania, 25/05/1990, 90052590840, Warszawa, Lekarska, 26, 29, 09-084, 680849088, magdalena.kania@o2.pl, 90052590840680849088900525, 25/05/2010, ., 1, 5, 100, 9000
	115, Karolina, , Mikolajczyk, 26/06/1991, 91062601954, Warszawa, Leona Kruczkowskiego, 46, 49, 00-195, 794950199, karolina.mikolajczyk@gmail.com, 91062601954794950199910626, 26/06/2011, ., 1, 5, 100, 8500
	116, Stanislaw, Pawel, Czajkowski, 27/07/1992, 92072712065, Warszawa, Leona Schillera, 147, 91, 01-206, 515061210, stanislaw.czajkowski@op.pl, 92072712065515061210920727, 27/07/2011, ., 1, 9, 100, 3000
	117, Ewelina, , Mucha, 28/08/1993, 93082823176, Warszawa, Leszczynska, 258, 122, 02-317, 626172321, ewelina.mucha@wp.pl, 93082823176626172321930828, 28/08/2010, ., 1, 5, 100, 6500
	118, Monika, , Tomczak, 29/09/1965, 65092934286, Warszawa, Lipowa, 70, 64, 03-428, 736283432, monika.tomczak@gmail.com, 65092934286736283432650929, 29/09/2010, ., 1, 5, 100, 6000
	119, Lukasz, Michal, Koziol, 30/10/1966, 66103045397, Warszawa, Litewska, 81, 84, 04-539, 547394543, lukasz.koziol@op.pl, 66103045397547394543661030, 30/10/2012, ., 1, 5, 100, 7500
	120, Lucjan, , Markowski, 01/11/1967, 67110156408, Warszawa, Ludna, 182, 135, 05-640, 658405654, lucjan.markowski@vp.pl, 67110156408658405654671101, 01/11/2013, ., 1, 5, 100, 8000
	121, Ryszard, , Kowalik, 02/12/1968, 68120267549, Pruszków, Ludwika Warynskiego, 293, 166, 06-754, 769546765, ryszard.kowalik@gmail.com, 68120267549769546765681202, 02/12/2014, ., 3, 5, 100, 9000
	122, Roman, Dariusz, Nawrocki, 03/01/1969, 69010378650, Warszawa, Ludwika Zamenhofa, 5, 8, 07-865, 570657876, roman.nawrocki@o2.pl, 69010378650570657876690103, 03/01/2015, ., 1, 5, 100, 7500
	123, Dariusz, , Brzozowski, 04/02/1970, 70020469764, Warszawa, Lwowska, 25, 28, 06-976, 684766987, dariusz.brzozowski@aol.com, 70020469764684766987700204, 04/02/2016, ., 2, 8, 100, 3500
	124, Dawid, , Janik, 05/03/1971, 71030570155, Piastów, Lazienkowska, 126, 79, 07-015, 795157091, dawid.janik@op.pl, 71030570155795157091710305, 05/03/2010, ., 1, 5, 100, 8500
	125, Iga, , Musial, 06/04/1972, 72040684266, Warszawa, Marcella Bacciarellego, 237, 101, 08-426, 516268412, iga.musial@wp.pl, 72040684266516268412720406, 06/04/2011, ., 1, 5, 60, 3500
	126, Artur, Jakub, Wawrzyniak, 15/05/1973, 73051595377, Warszawa, Marianska, 49, 43, 09-537, 627379523, artur.wawrzyniak@gmail.com, 73051595377627379523730515, 15/05/2010, 19/05/2015, 1, 5, 100, 6000
	127, Pawel, , Markiewicz, 16/05/1974, 74051606488, Warszawa, Mariensztat, 69, 63, 00-648, 738480634, pawel.markiewicz@op.pl, 74051606488738480634740516, 16/05/2010, ., 1, 9, 100, 3000
	128, Daniel, , Orlowski, 17/06/1975, 75061747599, Warszawa, Marii Konopnickiej, 161, 114, 04-759, 549594745, daniel.orlowski@vp.pl, 75061747599549594745750617, 17/06/2010, ., 1, 5, 100, 7000
	129, Maciej, Michal, Tomczyk, 18/07/1976, 76071858600, Warszawa, Mazowiecka, 272, 145, 05-860, 650605856, maciej.tomczyk@gmail.com, 76071858600650605856760718, 18/07/2011, ., 1, 5, 100, 8000
	130, Jakub, , Jarosz, 19/08/1977, 77081969711, Warszawa, Mazowiecka, 84, 87, 06-971, 761716967, jakub.jarosz@o2.pl, 77081969711761716967770819, 19/08/2011, ., 1, 5, 100, 7500
	131, Jan, , Kolodziejczyk, 20/09/1978, 78092070822, Warszawa, Marszalkowska, 104, 107, 07-082, 572827078, jan.kolodziejczyk@gmail.com, 78092070822572827078780920, 20/09/2010, ., 1, 6, 100, 7000
	132, Janina, Anna, Kurek, 21/10/1979, 79102181933, Warszawa, Mazowiecka, 105, 59, 08-193, 693938199, janina.kurek@op.pl, 79102181933693938199791021, 21/10/2010, ., 1, 5, 100, 8500
	133, Grazyna, , Kopec, 22/11/1980, 80112292044, Warszawa, Miechowska, 216, 81, 09-204, 714049210, grazyna.kopec@wp.pl, 80112292044714049210801122, 22/11/2012, ., 3, 5, 100, 9000
	134, Katarzyna, , Zak, 23/12/1981, 81122303455, Warszawa, Wilanowska, 28, 23, 00-345, 525450324, katarzyna.zak@gmail.com, 81122303455525450324811223, 23/12/2013, ., 1, 5, 100, 7500
	135, Antoni, , Wolski, 24/01/1982, 82012414566, Warszawa, Wilcza, 48, 43, 01-456, 636561435, antoni.wolski@op.pl, 82012414566636561435820124, 24/01/2010, 20/06/2016, 2, 5, 100, 7000
	136, Wojciech, , Luczak, 25/02/1983, 83022525677, Siedlce, Wioslarska, 149, 94, 02-567, 747672546, wojciech.luczak@vp.pl, 83022525677747672546830225, 25/02/2011, ., 1, 5, 100, 6500
	137, Bartosz, Marcin, Dziedzic, 26/03/1984, 84032636511, Warszawa, Miedzyparkowa, 251, 125, 03-651, 551513655, bartosz.dziedzic@gmail.com, 84032636511551513655840326, 26/03/2010, ., 1, 5, 100, 6000
	138, Zuzanna, , Kot, 27/04/1985, 85042747622, Warszawa, Mikolaja Kopernika, 63, 67, 04-762, 662624766, zuzanna.kot@o2.pl, 85042747622662624766850427, 27/04/2010, ., 1, 6, 100, 5000
	139, Monika, , Stasiak, 28/05/1986, 86052851733, Piastów, Mila, 83, 87, 05-173, 773735177, monika.stasiak@aol.com, 86052851733773735177860528, 28/05/2010, ., 1, 5, 100, 7000
	140, Iga, Malgorzata, Stankiewicz, 09/05/1987, 87050962844, Warszawa, Miodowa, 184, 138, 06-284, 584846288, iga.stankiewicz@op.pl, 87050962844584846288870509, 09/05/2011, ., 1, 9, 100, 4000
	141, Artur, , Piatek, 28/06/1988, 88062873955, Warszawa, Mokotowska, 295, 169, 07-395, 695957399, artur.piatek@wp.pl, 88062873955695957399880628, 28/06/2011, ., 1, 5, 80, 4500
	142, Alan, , Józwiak, 29/07/1989, 89072914006, Warszawa, Moliera, 7, 2, 01-400, 716001410, alan.jozwiak@gmail.com, 89072914006716001410890729, 29/07/2010, ., 1, 6, 100, 6000
	143, Stanislaw, , Urban, 30/08/1990, 90083025417, Warszawa, Mordechaja Anielewicza, 27, 22, 02-541, 527412524, stanislaw.urban@op.pl, 90083025417527412524900830, 30/08/2010, 21/07/2015, 1, 5, 100, 7000
	144, Zuzanna, Iwona, Dobrowolska, 01/09/1991, 91090136528, Warszawa, Stara, 128, 73, 03-652, 638523635, zuzanna.dobrowolska@vp.pl, 91090136528638523635910901, 01/09/2012, ., 1, 5, 100, 8000
	145, Lena, , Pawlik, 02/10/1992, 92100247639, Pruszków, Stawki, 239, 104, 04-763, 749634746, lena.pawlik@gmail.com, 92100247639749634746921002, 02/10/2013, ., 3, 5, 100, 9000
	146, Julia, , Kruk, 23/11/1993, 93112358740, Warszawa, Stefana Batorego, 42, 46, 05-874, 550745857, julia.kruk@o2.pl, 93112358740550745857931123, 23/11/2010, ., 1, 9, 100, 5000
	147, Marlena, Patrycja, Domagala, 24/12/1965, 65122469854, Warszawa, Rozbrat, 62, 66, 06-985, 664856968, marlena.domagala@gmail.com, 65122469854664856968651224, 24/12/2011, ., 2, 5, 100, 5500
	148, Hanna, , Piasecka, 25/05/1966, 66052570965, Warszawa, Rybaki, 163, 117, 07-096, 775967079, hanna.piasecka@op.pl, 66052570965775967079660525, 25/05/2010, ., 1, 5, 100, 6500
	149, Amelia, , Wierzbicka, 26/06/1967, 67062681076, Warszawa, Mostowa, 274, 148, 08-107, 586078180, amelia.wierzbicka@wp.pl, 67062681076586078180670626, 26/06/2010, ., 1, 5, 100, 7500
	150, Aleksandra, Daria, Karpinska, 27/07/1968, 68072792182, Siedlce, Muranowska, 86, 90, 09-218, 692189291, aleksandra.karpinska@gmail.com, 68072792182692189291680727, 27/07/2010, ., 1, 5, 50, 4500
	151, Alicja, , Jastrzebska, 28/08/1969, 69082803293, Warszawa, Mysia, 106, 101, 00-329, 713290312, alicja.jastrzebska@op.pl, 69082803293713290312690828, 28/08/2011, ., 1, 6, 100, 6000
	152, Oliwia, Karolina, Polak, 09/09/1970, 70090914304, Warszawa, Mysliwiecka, 107, 52, 01-430, 524301423, oliwia.polak@vp.pl, 70090914304524301423700909, 09/09/2011, ., 1, 5, 100, 7500
	153, Wiktoria, , Zieba, 10/10/1971, 71101025415, Warszawa, Nalewki, 218, 83, 02-541, 635412534, wiktoria.zieba@gmail.com, 71101025415635412534711010, 10/10/2010, 22/08/2016, 1, 5, 100, 6500
	154, Nikola, , Janicka, 11/11/1972, 72111136526, Piastów, Natolinska, 30, 25, 03-652, 746523645, nikola.janicka@o2.pl, 72111136526746523645721111, 11/11/2010, ., 1, 5, 100, 7000
	155, Gabriela, Marta, Wójtowicz, 20/12/1973, 73122047637, Warszawa, Niecala, 41, 45, 04-763, 557634756, gabriela.wojtowicz@aol.com, 73122047637557634756731220, 20/12/2012, ., 1, 6, 100, 8000
	156, Antonina, , Stefanska, 21/01/1974, 74012158748, Warszawa, Niska, 142, 96, 05-874, 668745867, antonina.stefanska@op.pl, 74012158748668745867740121, 21/01/2013, ., 1, 5, 100, 9000
	157, Nadia, , Sosnowska, 22/02/1975, 75022269159, Warszawa, Nowiniarska, 253, 127, 06-915, 779156971, nadia.sosnowska@wp.pl, 75022269159779156971750222, 22/02/2014, ., 3, 5, 100, 8500
	158, Michal, Mariusz, Bednarek, 23/03/1976, 76032370260, Warszawa, Nowogrodzka, 65, 70, 07-026, 590267092, michal.bednarek@gmail.com, 76032370260590267092760323, 23/03/2015, ., 1, 5, 100, 7500
	159, Jakub, , Majchrzak, 24/04/1977, 77042481371, Warszawa, Nowolipie, 85, 81, 08-137, 611378113, jakub.majchrzak@op.pl, 77042481371611378113770424, 24/04/2016, ., 2, 5, 100, 6500
	160, Agnieszka, Marlena, Bielecka, 25/01/1978, 78012592482, Warszawa, Nowolipki, 186, 132, 09-248, 722489224, agnieszka.bielecka@vp.pl, 78012592482722489224780125, 25/01/2010, ., 1, 5, 100, 6000
	161, Maria, , Malecka, 26/02/1979, 79022603593, Warszawa, Nowomiejska, 297, 163, 00-359, 533590335, maria.malecka@gmail.com, 79022603593533590335790226, 26/02/2011, ., 1, 6, 100, 7000
	162, Marian, , Maj, 27/03/1980, 80032744804, Warszawa, Nowosielecka, 9, 5, 04-480, 644804448, marian.maj@o2.pl, 80032744804644804448800327, 27/03/2010, ., 1, 5, 100, 8000
	163, Zbigniew, , Sowa, 28/04/1981, 81042855945, Warszawa, Nowowiejska, 29, 25, 05-594, 755945559, zbigniew.sowa@gmail.com, 81042855945755945559810428, 28/04/2010, 23/09/2015, 1, 5, 100, 6000
	164, Ireneusz, , Milewski, 29/05/1982, 82052966056, Warszawa, Nowy Przejazd, 121, 76, 06-605, 566056660, ireneusz.milewski@op.pl, 82052966056566056660820529, 29/05/2010, ., 1, 5, 100, 5000
	165, Partyk, , Gajda, 30/05/1983, 83053077467, Warszawa, Nowy Swiat, 232, 107, 07-746, 677467774, partyk.gajda@wp.pl, 83053077467677467774830530, 30/05/2011, ., 1, 5, 100, 4000
	166, Julia, , Klimek, 01/06/1984, 84060188588, Pruszków, Nowy Zjazd, 44, 49, 08-858, 788588885, julia.klimek@gmail.com, 84060188588788588885840601, 01/06/2011, ., 1, 9, 100, 3000
	167, Ada, Monika, Olejniczak, 02/07/1985, 85070299699, Warszawa, Obozna, 64, 69, 09-969, 599699996, ada.olejniczak@op.pl, 85070299699599699996850702, 02/07/2010, ., 1, 5, 100, 3500
	168, Zofia, , Ratajczak, 03/08/1986, 86080300700, Warszawa, Okólnik, 165, 111, 00-070, 610700017, zofia.ratajczak@vp.pl, 86080300700610700017860803, 03/08/2010, ., 1, 6, 100, 8000
	169, Anna, , Romanowska, 26/09/1987, 87092614814, Piastów, Okrag, 276, 142, 01-481, 724811428, anna.romanowska@gmail.com, 87092614814724811428870926, 26/09/2012, ., 3, 5, 100, 7000
	170, Danuta, Zofia, Matuszewska, 27/10/1988, 88102725925, Warszawa, Oleandrów, 88, 84, 02-592, 535922539, danuta.matuszewska@o2.pl, 88102725925535922539881027, 27/10/2013, ., 1, 6, 100, 8000
	171, Ewa, , Liwinska, 28/11/1989, 89112836036, Warszawa, Ordynacka, 108, 104, 03-603, 646033640, ewa.liwinska@aol.com, 89112836036646033640891128, 28/11/2010, 24/10/2016, 2, 5, 100, 8500
	172, Amelia, , Madej, 29/12/1990, 90122947148, Warszawa, Orla, 109, 55, 04-714, 758144751, amelia.madej@op.pl, 90122947148758144751901229, 29/12/2011, ., 1, 5, 100, 6500
	173, Aleksandra, Malgorzata, Kasprzak, 30/01/1991, 91013058259, Warszawa, Ossolinskich, 211, 86, 05-825, 569255862, aleksandra.kasprzak@wp.pl, 91013058259569255862910130, 30/01/2010, ., 1, 5, 100, 5500
	174, Monika, , Wilczynska, 16/02/1992, 92021669360, Warszawa, Pamietajcie o Ogrodach, 23, 28, 06-936, 670366973, monika.wilczynska@gmail.com, 92021669360670366973920216, 16/02/2010, ., 1, 6, 60, 4000
	175, Iga, , Grzelak, 17/03/1993, 93031770474, Siedlce, Panska, 43, 48, 07-047, 784477084, iga.grzelak@op.pl, 93031770474784477084930317, 17/03/2010, ., 1, 5, 100, 6500
	176, Artur, Piotr, Socha, 18/04/1965, 65041861515, Warszawa, Profesorska, 144, 99, 06-151, 595516195, artur.socha@vp.pl, 65041861515595516195650418, 18/04/2011, ., 1, 5, 100, 8000
	177, Pawel, , Czajka, 19/05/1966, 66051972806, Warszawa, Parkingowa, 255, 121, 07-280, 616807218, pawel.czajka@gmail.com, 66051972806616807218660519, 19/05/2011, ., 1, 5, 100, 7000
	178, Daniel, , Marek, 20/05/1967, 67052083917, Warszawa, Parkowa, 67, 63, 08-391, 727918329, daniel.marek@o2.pl, 67052083917727918329670520, 20/05/2010, ., 1, 5, 100, 4500
	179, Andrzej, Zenon, Kowal, 21/06/1968, 68062194028, Warszawa, Przeskok, 87, 83, 09-402, 538029430, andrzej.kowal@gmail.com, 68062194028538029430680621, 21/06/2010, 25/11/2015, 1, 8, 100, 4000
	180, Ewelina, , Bednarczyk, 22/07/1969, 69072205139, Warszawa, Przyrynek, 188, 134, 00-513, 649130541, ewelina.bednarczyk@op.pl, 69072205139649130541690722, 22/07/2012, ., 1, 5, 80, 6000
	181, Monika, , Skiba, 23/08/1970, 70082346240, Warszawa, Przystaniowa, 299, 165, 04-624, 750244652, monika.skiba@wp.pl, 70082346240750244652700823, 23/08/2013, ., 3, 5, 100, 8000
	182, Lukasz, Zbigniew, Wrona, 24/09/1971, 71092457351, Warszawa, Ptasia, 2, 7, 05-735, 561355763, lukasz.wrona@gmail.com, 71092457351561355763710924, 24/09/2010, ., 1, 5, 100, 9000
	183, Lucjan, , Owczarek, 17/10/1972, 72101761462, Piastów, Radna, 22, 27, 06-146, 672466174, lucjan.owczarek@op.pl, 72101761462672466174721017, 17/10/2011, ., 2, 5, 100, 7500
	184, Ryszard, Mateusz, Marcinkowski, 18/11/1973, 73111872573, Warszawa, Rajców, 123, 73, 07-257, 733577235, ryszard.marcinkowski@vp.pl, 73111872573733577235731118, 18/11/2010, ., 1, 5, 100, 4500
	185, Roman, , Matusiak, 19/12/1974, 74121983684, Warszawa, Raoula Wallenberga, 234, 104, 08-368, 544688346, roman.matusiak@gmail.com, 74121983684544688346741219, 19/12/2010, 28/02/2015, 1, 5, 100, 5000
	186, Dariusz, , Orzechowski, 20/01/1975, 75012094795, Warszawa, Rektorska, 46, 46, 09-479, 655799457, dariusz.orzechowski@o2.pl, 75012094795655799457750120, 20/01/2010, ., 1, 9, 50, 2000
	187, Dawid, Krzysztof, Sobolewski, 21/02/1976, 76022105108, Pruszków, Piekarska, 66, 66, 00-510, 768100561, dawid.sobolewski@aol.com, 76022105108768100561760221, 21/02/2011, 30/04/2015, 1, 5, 100, 6000
	188, Aleksander, , Kedzierski, 22/03/1977, 77032216419, Warszawa, Piesza, 167, 117, 01-641, 579411674, aleksander.kedzierski@op.pl, 77032216419579411674770322, 22/03/2011, ., 1, 6, 100, 7000
	189, Franciszek, , Kurowski, 23/04/1978, 78042327520, Siedlce, Piekna, 278, 148, 02-752, 680522785, franciszek.kurowski@wp.pl, 78042327520680522785780423, 23/04/2010, ., 1, 5, 100, 8000
	190, Mikolaj, Marcel, Rogowski, 24/05/1979, 79052438631, Warszawa, Piotra Antoniego Steinkellera, 90, 90, 03-863, 791633896, mikolaj.rogowski@gmail.com, 79052438631791633896790524, 24/05/2010, 26/12/2015, 1, 5, 100, 9000
	191, Marcel, , Olejnik, 25/05/1980, 80052549742, Warszawa, Piotra Maszynskiego, 101, 101, 04-974, 512744917, marcel.olejnik@op.pl, 80052549742512744917800525, 25/05/2012, ., 1, 5, 100, 6500
	192, Wiktor, Antoni, Debski, 26/06/1981, 81062650853, Warszawa, Piwna, 102, 52, 05-085, 623855028, wiktor.debski@vp.pl, 81062650853623855028810626, 26/06/2013, ., 1, 6, 100, 7500
	193, Magdalena, , Baranska, 27/07/1982, 82072761964, Warszawa, Pokorna, 213, 83, 06-196, 734966139, magdalena.baranska@gmail.com, 82072761964734966139820727, 27/07/2014, ., 3, 5, 100, 7000
	194, Karolina, Antonina, Skowronska, 28/08/1983, 83082872075, Warszawa, Polna, 25, 25, 07-207, 545077240, karolina.skowronska@o2.pl, 83082872075545077240830828, 28/08/2015, ., 1, 5, 100, 6500
	195, Stanislaw, , Mazurkiewicz, 29/09/1984, 84092913186, Piastów, Poznanska, 45, 45, 01-318, 656181351, stanislaw.mazurkiewicz@gmail.com, 84092913186656181351840929, 29/09/2016, ., 2, 9, 60, 2500
	196, Danuta, Ewa, Pajak, 30/10/1985, 85103024297, Warszawa, Zgoda, 146, 96, 02-429, 767292462, danuta.pajak@op.pl, 85103024297767292462851030, 30/10/2010, 27/01/2016, 1, 5, 100, 5500
	197, Ewa, , Czech, 01/11/1986, 86110135301, Warszawa, Zielna, 257, 123, 03-530, 531303533, ewa.czech@wp.pl, 86110135301531303533861101, 01/11/2011, ., 1, 8, 100, 4500
	198, Ewelina, , Janiszewska, 02/12/1987, 87120246445, Warszawa, Zimna, 69, 65, 04-644, 645444644, ewelina.janiszewska@gmail.com, 87120246445645444644871202, 02/12/2010, ., 2, 5, 100, 8000
	199, Monika, Ewelina, Bednarska, 03/05/1988, 88050357556, Siedlce, Zlota, 89, 85, 05-755, 756555755, monika.bednarska@gmail.com, 88050357556756555755880503, 03/05/2010, ., 1, 5, 100, 9000
	200, Lukasz, Andrzej, Chrzanowski, 04/06/1989, 89060468667, Warszawa, Zygmunta Slominskiego, 181, 136, 06-866, 567666866, lukasz.chrzanowski@gmail.com, 89060468667567666866890604, 04/06/2010, 29/03/2016, 1, 5, 100, 8500
	;
run;


PROC SORT DATA=ZOO.employees;
  BY hire_date;
RUN;

data ZOO.employees;
	set ZOO.employees;
	employee_id=_n_;
run;
/*********************/



/*tabela zawierajaca wszystkie transakcje*/
/*tymczasowo bez obliczonej lacznej kwoty transakcji*/
proc sql noprint;
	select employee_id into:employees SEPARATED BY ", "  from ZOO.EMPLOYEES where position_code=9 and layoff_date=.;
quit;

data ZOO.TRANSACTIONS;
	length transaction_id 8 date 6 employee_id 6 amount 4;
	format date ddmmyy10.;
	date='01jan10'd;
	days=&today.-date;
	transaction_id=0;
	amount=0;
	array emp[11]  (&employees.); 
	do i=1 to days;
		m=month(date);
		n=0;
		if m eq 1 then n=30;
		if m eq 2 then n=30;
		if m eq 3 then n=35;
		if m eq 4 then n=35;
		if m eq 4 then n=40;
		if m eq 5 then n=50;
		if m eq 6 then n=60;
		if m eq 7 then n=70;
		if m eq 8 then n=70;
		if m eq 9 then n=60;
		if m eq 10 then n=50;
		if m eq 11 then n=40;
		if m eq 12 then n=35;
		x=n+ceil(ranuni(0)*10);

		do j=1 to x;
			transaction_id=transaction_id+1;
			e=ceil(ranuni(0)*11);
			employee_id=emp(e);
			output;
		end;
		date=date+1;
	end;
	keep transaction_id date employee_id amount;
run;
/*********************/



/*tabela zawierajaca szczegoly transakcji*/
proc sql noprint;
	select max(transaction_id) into: tran_count
	from ZOO.transactions;
quit;

data ZOO.TRANSACTION_DETAILS;
	length transaction_id 8
	ticket_type_id 3 
	quantity 3;
	do transaction_id=1 to &tran_count;
		t1=0; t2=0; t3=0; 
		t4=0; t5=0; t6=0; 
		t7=0;

		if ranuni(0)<0.1 then do;
			if ranuni(0)<0.3 then t6=ceil(ranuni(0)*2);
			else do;
				if ranuni(0)<0.5 then do;
					t4=round(ranuni(0));
					t5=ceil(ranuni(0)*3);
				end;
				else do;
					t5=round(ranuni(0));
					t4=ceil(ranuni(0)*3);
				end;
			end;
		end;
		else do;
			if ranuni(0)<0.15 then do;
				t7=10+round(ranuni(0)*10);
			end;
			else do;
				if ranuni(0)<0.3 then t3=ceil(ranuni(0)*2);
				if t3>0 then do;
					if ranuni(0)<0.5 then do;
						if ranuni(0)<0.4 then t1=ceil(ranuni(0)*3);
						else t2=ceil(ranuni(0)*4);
					end;
				end;
				else do;
					if ranuni(0)<0.5 then do;
						t1=round(ranuni(0));
						t2=ceil(ranuni(0)*5);
					end;
					else do;
						t2=round(ranuni(0));
						t1=ceil(ranuni(0)*5);
					end;
				end;
			end;
		end;

		if t1>0 then do; ticket_type_id=1; quantity=t1; output; end;
		if t2>0 then do; ticket_type_id=2; quantity=t2; output; end;
		if t3>0 then do; ticket_type_id=3; quantity=t3; output; end;
		if t4>0 then do; ticket_type_id=4; quantity=t4; output; end;
		if t5>0 then do; ticket_type_id=5; quantity=t5; output; end;
		if t6>0 then do; ticket_type_id=6; quantity=t6; output; end;
		if t7>0 then do; ticket_type_id=7; quantity=t7; output; end;
	end;
	keep transaction_id ticket_type_id quantity;
run; 
/*********************/



/*uzupelnienie tabeli z transakcjami*/
proc sql;
	create table ZOO.transactions_amount as
	select t.transaction_id, sum(td.quantity*tt.price) as amount
	from ZOO.transactions t
	join ZOO.transaction_details td on t.transaction_id=td.transaction_id
	join ZOO.TICKET_TYPES tt on tt.ticket_type_id=td.ticket_type_id
	join ZOO.TICKET_TYPES_HIST tth on tth.ticket_type_id=td.ticket_type_id
	where (t.date>=tth.valid_from and t.date<=tth.valid_to) or (t.date>=tt.valid_from and t.amount=0)
	group by t.transaction_id;
quit;

data ZOO.TRANSACTIONS; 
  merge ZOO.transactions ZOO.transactions_amount; 
  by transaction_id; 
run; 

proc sql;
	drop table ZOO.transactions_amount;
quit;
/*********************/



/*tabela zawierajaca informacje o dostawcach*/
data ZOO.SUPPLIERS;
	length supplier_id 3 
	name $50
	phone $9
	email $30
	NIP $10;
	INFILE DATALINES DLM=',';
 	INPUT supplier_id name $ phone $ email $ NIP $;
	DATALINES;
	1, Delikatesy dla zwierzat, 597179643, kontakt@ddz.pl, 9246404449
	2, Mamba, 697989269, zamowienia@mamba.com, 6470933144
	3, WildFood, 795070486, orders@wildfood.net, 7902453360
	4, Animal foods, 585478816, kontakt@animalfoods.pl, 7166955080
	5, ZooCenter, 677460840, zoocenter@zoocenter.com, 4277477753
	6, Bird Food, 726381703, birds@birdfood.com.pl, 0261119677
	7, Sklep dla dzikich zwierzat, 559506794, kontakt@dzikisklep.pl, 5707356114
	8, TURDUS, 693801988, turdus@turdus.com, 9395561094
	9, ZOO express, 783756201, kontakt@zooexpress.pl, 5501542104
	10, Tigers, 579195276, tigers@tigers.com, 9502396615
	11, Tucan, 642092542, tucan@tucan.pl, 6182757972
	12, Pelican, 788658398, contact@pelican.com, 3524864533
	13, ZooArt, 547367805, zoo@zooart.pl, 8656720464
	14, KrakVet, 607820730, kontakt@krakvet.com, 2735815439
	15, Telekarma, 752040264, tele@telekarma@pl, 2623710063
	16, Animalia, 508986029, animals@animalia.pl, 2359617172
	17, Batiba, 659753876, kontakt@batiba.com, 9946310324
	18, AnimalWorld, 794668176, contact@animalworls.pl, 6371410111
	19, Kampol, 554800528, karma@kampol.pl, 2887803649
	20, Dziki trop, 615577181, dzikitrop@dzikitrop.pl, 3281121954
	21, Emusklep, 739583221, sklep@emusklep.pl, 0296298077
	22, LamaShop, 553012014, shop@lamashop.pl, 2095457814
	23, ORIJEN, 672446789, kontakt@orijen.com, 6693265997
	24, ZOO expert, 702887219, zoo@zooexpert.com.pl, 3224006689
	;
RUN; 
/*********************/



/*tabela zawierajaca gatunki zwierzat*/
data ZOO.SPECIES;
	length species_id 3 
	polish_name $50
	name $50
	order_id 3;
	INFILE DATALINES DLM=',';
 	INPUT species_id polish_name $ name $ order_id;
	DATALINES;
	1, Kazuar helmiasty, Casuarius casuarius, 1
	2, Emu, Dromaius novaehollandiae, 1
	3, Strus czerwonoskóry, Struthio camelus, 1
	4, Pingwin przyladkowy, Spheniscus demersus, 2
	5, Labedz niemy, Cygnus olor, 3
	6, Labedz czarny, Cygnus atratus, 3
	7, Sniezyca duza, Anser caerulescens, 3
	8, Bernikla kanadyjska, Branta canadensis, 3
	9, Bernikla pólnocna, Branta hutchinsii minima, 3
	10, Bernikla bialolica, Branta leucopsis, 3
	11, Kazarka rdzawa, Tadorna ferruginea, 3
	12, Kazarka obrozna, Tadorna tadornoides, 3
	13, Kazarka rajska, Tadorna variegata, 3
	14, Ohar, Tadorna tadorna, 3
	15, Pizmówka malajska, Asarcornis scutulata, 3
	16, Mandarynka, Aix galericulata, 3
	17, Karolinka, Aix sponsa, 3
	18, Cyraneczka madagaskarska, Anas bernieri, 3
	19, Cyraneczka europejska, Anas crecca, 3
	20, Cyranka, Anas querquedula, 3
	21, Srebrzanka hotentocka, Anas hottentota, 3
	22, Swistun europejski, Anas penelope, 3
	23, Krzyzówka, Anas platyrhynchos, 3
	24, Podgorzalka zielonoglowa, Aythya baeri, 3
	25, Glowienka, Aythya ferina, 3
	26, Czernica, Aythya fuligula, 3
	27, Podgorzalka, Aythya nyroca, 3
	28, Helmiatka, Netta rufina, 3
	29, Skrzydloszpon obrozny, Chauna torquata, 3
	30, Czapla zlotawa, Bubulcus ibis/Ardeola ibis, 4
	31, Ibis szkarlatny, Eudocimus ruber, 4
	32, Warzecha czerwonolica, Platalea alba, 4
	33, Pelikan rózowy, Pelecanus onocrotalus, 4
	34, Bocian bialy, Ciconia ciconia, 5
	35, Bocian czarny, Ciconia nigra, 5
	36, Flaming chilijski, Phoenicopterus chilensis, 6
	37, Modrzyk, Porphyrio porphyrio, 7
	38, Koronnik szary, Balearica regulorum, 7
	39, Zuraw zwyczajny, Grus grus, 7
	40, Zuraw mandzurski, Grus japonensis, 7
	41, Dlugoszpon krasnoczelny, Jacana jacana, 8
	42, Kulon, Burhinus oedicnemus, 8
	43, Kulik wielki, Numenius arquata, 8
	44, Batalion, Philomachus pugnax, 8
	45, Czajka, Vanellus vanellus, 8
	46, Siewka zlota, Pluvialis apricaria, 8
	47, Kondor wielki, Vultur gryphus, 9
	48, Kondor królewski, Sarcoramphus papa, 9
	49, Bielik olbrzymi, Haliaeetus pelagicus, 9
	50, Orzel stepowy, Aquila nipalensis orientalis, 9
	51, Trzmielojad, Pernis apivorus, 9
	52, Myszolów zwyczajny, Buteo buteo, 9
	53, Myszolowiec, Parabuteo unicinctus, 9
	54, Rybolów, Pandion haliaetus haliaetus, 9
	55, Czubacz zmienny, Crax rubra, 10
	56, Czubacz gololicy, Crax fasciolata, 10
	57, Paw indyjski, Pavo cristatus, 10
	58, Uszak siwy, Crossoptilon auritum, 10
	59, Uszak bialy, Crossoptilon crossoptilon drouynii, 10
	60, Bazant himalajski, Catreus wallichi, 10
	61, Bazant Elliota, Syrmaticus ellioti, 10
	62, Bazant królewski, Syrmaticus reevesii, 10
	63, Bazant diamentowy, Chrysolophus amherstiae, 10
	64, Olsniak himalajski, Lophophorus impejanus, 10
	65, Kisciec annamski, Lophura edwardsi, 10
	66, Kisciec nepalski, Lophura leucomelanos, 10
	67, Kisciec srebrzysty, Lophura nycthemera, 10
	68, Kisciec tajwanski, Lophura swinhoii, 10
	69, Kisciec syjamski, Lophura diardi, 10
	70, Kura domowa, Gallus gallus domesticus, 10
	71, Paw kongijski, Afropavo congensis, 10
	72, Puchoczub, Rollulus rouloul, 10
	73, Przepiórka polna, Coturnix coturnix, 10
	74, Perlica domowa, Numida meleagris, 10
	75, Perlica sepia, Acryllium vulturinum, 10
	76, Cieciornik kanadyjski, Bonasa umbellus, 10
	77, Gluszec, Tetrao urogallus, 10
	78, Cietrzew, Tetrao tetrix, 10
	79, Góropatwa skalna, Alectoris graeca, 10
	80, Kuropatwa, Perdix perdix, 10
	81, Wieloszpon szary, Polyplectron bicalcaratum, 10
	82, Koroniec plamoczuby, Goura victoria, 11
	83, Nikobarczyk, Caloenas nicobarica, 11
	84, Wyspiarek zbroczony, Gallicolumba luzonica, 11
	85, Owocozer wspanialy, Ptilinopus superbus superbus, 11
	86, Golab gwinejski, Columba guinea, 11
	87, Golab domowy, Columba livia domestica, 11
	88, Golab grzywacz, Columba palumbus, 11
	89, Golabek diamentowy, Geopelia cuneata, 11
	90, Sierpówka, Streptopelia decaocto, 11
	91, Synogarlica brunatna, Streptopelia picturata, 11
	92, Cukrówka, Streptopelia roseogrisea, 11
	93, Synogarlica senegalska, Streptopelia senegalensis, 11
	94, Turkawka zwyczajna, Streptopelia turtur, 11
	95, Golebiak bialoskrzydly, Zenaida asiatica, 11
	96, Golebiak kasztanowaty, Zenaida graysoni, 11
	97, Zalobnica palmowa, Probosciger aterrimus, 12
	98, Kakadu biala, Cacatua alba, 12
	99, Kakadu rózowa, Eolophus roseicapilla/Cacatua roseicapilla, 12
	100, Kea, Nestor notabilis, 12
	101, Barwnica, Eclectus roratus polychloros, 12
	102, Ara hiacyntowa, Anodorhynchus hyacinthinus, 12
	103, Ara ararauna, Ara ararauna, 12
	104, Ara zielonoskrzydla, Ara chloroptera, 12
	105, Ara zielona, Ara militaris, 12
	106, Ara zóltoszyja, Propyrrhura auricollis, 12
	107, Amazonka modrobrewa, Amazona amazonica, 12
	108, Amazonka zóltoszyja, Amazona auropalliata, 12
	109, Amazonka zóltoglowa, Amazona ochrocephala, 12
	110, Patagonka, Cyanoliseus patagonus, 12
	111, Zako liberyjskie, Psittacus timneh, 12
	112, Zako kongijskie, Psittacus erithacus, 12
	113, Afrykanka ognistobrzucha, Poicephalus senegalus, 12
	114, Nierozlaczka czarnolica, Agapornis nigrigenis, 12
	115, Aleksandretta wieksza, Psittacula eupatria, 12
	116, Sowa uszata, Asio otus, 13
	117, Pójdzka, Athene noctua, 13
	118, Wlochatka, Aegolius funereus, 13
	119, Puchacz, Bubo bubo, 13
	120, Syczek, Otus scops, 13
	121, Puszczyk, Strix aluco, 13
	122, Puszczyk bialy, Strix aluco alba, 13
	123, Puszczyk mszarny, Strix nebulosa, 13
	124, Puszczyk uralski, Strix uralensis, 13
	125, Sowa jarzebata, Surnia ulula, 13
	126, Plomykówka, Tyto alba, 13
	127, Kraska zwyczajna, Coracias garrulus, 14
	128, Kukabura chichotliwa, Dacelo novaeguineae, 14
	129, Slonecznica, Eurypyga helias, 15
	130, Wasal zóltooki, Lybius dubius, 16
	131, Tukan wielki, Ramphastos toco, 16
	132, Turak fioletowy, Musophaga violacea, 17
	133, Dzioborozec srebrnolicy, Bycanistes brevis, 18
	134, Dzioborozec karbodzioby, Rhyticeros plicatus, 18
	135, Dudek zwyczajny, Upupa epops, 18
	136, Czepiga rudawa, Colius striatus, 19
	137, Szpak balijski, Leucopsar rothschild, 20
	138, Szpak, Sturnus vulgaris, 20
	139, Blyszczak stalowy, Lamprotornis chalybaeus, 20
	140, Wilga, Oriolus oriolus, 20
	141, Kitta czerwonodzioba, Urocissa erythrorhyncha, 20
	142, Turkusnik indyjski, Irena puella, 20
	143, Bilbil krwawnik, Pycnonotus jocosus, 20
	144, Bilbil arabski, Pycnonotus xanthopygos, 20
	145, Slowik chinski, Leiothrix lutea, 20
	146, Slodnik bialoskrzydly	, Entomyzon cyanotis, 20
	147, Ryzowiec siwy, Padda oryzivora, 20
	148, Amadyna ostrosterna	, Poephila acuticauda hecki, 20
	149, Amadyna wspaniala, Chloebia gouldiae, 20
	150, Amadyna obrozna, Amadina fasciata, 20
	151, Wiklacz czerwonodzioby, Quelea quelea, 20
	152, Wiklacz sloneczny, Euplectes afer, 20
	153, Wiklacz ognisty	, Euplectes orix franciscanus, 20
	154, Wiklacz czerwony, Foudia madagascariensis, 20
	155, Wróbel zloty, Passer luteus, 20
	156, Kulczyk mozambijski	, Serinus mozambicus, 20
	157, Czyzyk, Carduelis spinus, 20
	158, Szczygiel, Carduelis carduelis, 20
	159, Grubodziób, Coccothraustes coccothraustes, 20
	160, Jemioluszka, Bombycilla garrulus, 20
	161, Pliszka siwa, Motacilla alba, 20
	162, Lerka, Lullula arborea, 20
	163, Kubanik, Tiaris canora, 20
	164, Slon afrykanski	, Loxodonta africana africana, 21
	165, Góralek abisynski	, Procavia capensis, 22
	166, Nosorozec indyjski	, Rhinoceros unicornis, 23
	167, Zebra równikowa	, Equus quagga boehmi, 23
	168, Kon Przewalskiego	, Equus przewalskii, 23
	169, Kuc szetlandzki	, Equus caballus setland, 23
	170, Osiol domowy	, Equus asinus, 23
	171, Osiol somalijski, Equus asinus somalicus, 23
	172, Hipopotam nilowy	, Hippopotamus amphibius, 24
	173, Lama	, Lama glama, 24
	174, Wikunia, Vicugna vicugna, 24
	175, Wielblad dwugarbny	, Camelus bactrianus, 24
	176, Zyrafa rothschilda, Giraffa camelopardalis rothschild, 24
	177, Pudu chilijski	, Pudu pudu, 24
	178, Daniel	, Dama dama, 24
	179, Bizon	, Bison bison, 24
	180, Zubr	, Bison bonasus, 24
	181, Jak	, Bos grunniens, 24
	182, Sitatunga	, Tragelaphus spekii gratus, 24
	183, Bongo	, Tragelaphus eurycerus isaaci, 24
	184, Oryks szablorogi	, Oryx dammah, 24
	185, Goral dlugoogoniasty	, Naemorhedus caudatus, 24
	186, Takin syczuanski, Budorcas taxicolor tibetana, 24
	187, Nachur, Pseudois nayaur, 24
	188, Koza holenderska	, Capra hircus, 24
	189, Owca somali, Ovis aries, 24
	190, Wrzosówka	, Ovis aries, 24
	191, Wól pizmowy, Ovibos moschatus, 24
	192, Foka szara	, Halichoerus grypus, 25
	193, Niedzwiedz brunatny	, Ursus arctos, 25
	194, Niedzwiedz polarny, Thalarctos maritimus, 25
	195, Panda mala	, Ailurus fulgens fulgens, 25
	196, Likaon, Lycaon pictus, 25
	197, Wilk grzywiasty	, Chrysocyon brachyurus, 25
	198, Wydra europejska	, Lutra lutra, 25
	199, Surykatka, Suricata suricatta, 25
	200, Manul, Otocolobus manul, 25
	201, Kot argentynski	, Oncifelis geoffroyi, 25
	202, Serwal, Leptailurus serval, 25
	203, Gepard, Acinonyx jubatus, 25
	204, Pantera sniezna	, Panthera uncia, 25
	205, Jaguar, Panthera onca, 25
	206, Lew, Panthera leo, 25
	207, Tygrys sumatrzanski	, Panthera tigris sumatrae, 25
	208, Lemur katta, Lemur catta, 26
	209, Wari czarno-bialy, Varecia variegata, 26
	210, Pigmejka, Callithrix pygmaea, 26
	211, Uistiti bialoucha, Callithrix jacchus, 26
	212, Tamaryna bialoczuba, Saguinus oedipus, 26
	213, Tamaryna czewonobrzucha	, Saguinus labiatus, 26
	214, Sajmiri wiewiórcza, Saimiri sciureus, 26
	215, Kapucynka zóltopiersna	, Sapajus xanthosternos, 26
	216, Koczkodan blotny, Allenopithecus nigroviridis, 26
	217, Koczkodan diana, Cercopithecus diana diana, 26
	218, Makak czubaty, Macaca nigra nigra, 26
	219, Pawian plaszczowy, Papio hamadryas, 26
	220, Gibbon czubaty, Nomascus gabriellae, 26
	221, Szympans, Pan troglodytes, 26
	222, Goryl nizinny, Gorilla gorilla gorilla, 26
	223, Królik domowy, Oryctolagus cuniculus f. domesticus, 27
	224, Swinka morska	, Cavia porcellus, 28
	225, Rudawka nilowa	, Rousettus aegyptiacus, 29
	226, Bolita poludniowa, Tolypeutes matacus, 30
	227, Leniwiec dwupalczasty, Choloepus didactylus, 30
	228, Mrówkojad wielki	, Myrmecophaga tridactyla, 30
	229, Kangur rudy	, Macropus rufus, 31
	230, Walabia Benetta	, Macropus rufogriseus, 31
	231, Ptasznik z Hondurasu, Brachypelma vagans, 32
	232, Tarantula chilijska, Grammostola rosea, 32
	233, Skolopendra, Scolopendra sp., 33
	234, Ptasznik, Theraphosa blondi, 32
	235, Ptasznik czerwonokolanowy, Brachypelma smithi, 32
	236, Skorpion cesarski, Pandinus imperator, 34
	237, Ptasznik brazylijski, Lasidora parahybana, 32
	238, Ptasznik, Brachypelma boehmei, 32
	239, Ptasznik, Lasiorora cristata, 32
	240, Pluskwiak afrykanski, Platymeris biguttatus, 35
	241, Ptasznik bialokolanowy, Acantoscurra geniculata, 32
	242, Ptasznik, Aphonopelma seemani, 32
	243, Szaranczak, Tropidacris Violaceus, 36
	244, Osa szmaragdowa, Ampulex Compressa, 37
	245, Slimak Achatina, Achatina reticulata, 38
	246, Rohatyniec, Dynastes hercules, 39
	247, Szaranczak patyczakowaty, Proscopia sp., 40
	248, Zuk z Konga, Pachnoda peregrina, 39
	249, Zuk, Pachnoda sinuata flaviventris, 39
	250, Patyczak Rogaty, Baculum extradentatum, 41
	251, Karaczan, Eublaberus posticus, 42
	252, Karaczan madagaskarski, Gromphadorrhina portentosa, 42
	253, Karaczan brazylijski, Blaberus cranifer, 42
	254, Karaczan zlotoglowy, Eublaberus distanti, 42
	255, Spieszek cieplarniany, Tachycines asynamorus, 36
	256, Krab pustelnik, Paguroidea sp., 43
	257, Motylowiec, Pantodon buchholzi, 44
	258, Barwniak szmaragdowy, Pelvicachromis taeniatus, 45
	259, Iglicznia slodkowodna, Doryichthys boaia, 46
	260, Krewetka filtrujaca, Atyopsis moluccensis, 43
	261, Krewetka, Caridina sp., 43
	262, Krewetka, Caridina simmoni simmoni, 43
	263, Sumik szklisty, Kryptopterus bicirrhis, 47
	264, Blyszczek teczowy, Notropis chrosomus, 48
	265, Sczupak, Esox lucius, 49
	266, Ciernik, Gasterosterus aculeatus, 50
	267, Kielb, Gobio gobio, 51
	268, Ploc, Rutilus rutilus, 51
	269, Strzebla blotna, Phoxinus perenurus, 51
	270, Slepiec jaskiniowy, Astyanax mexicanus, 48
	271, Nozowiec indyjski, Chitala ornata, 44
	272, Zbrojnik, Hypostomus plecostomus, 47
	273, Zbrojnik lamparci, Glyptopterichthys gibbiceps, 47
	274, Murena, Echidna nebulosa, 52
	275, Arabski rekin dywanowy, Chiloscyllium arabicum, 55
	276, Nadymka, Arothron molinerisis, 54
	277, Arowana dwuwasa, Osteoglossum bicirrhosum, 44
	278, Arowana azjatycka, Scleropages formosus, 44
	279, Ziemiojad, Geophagus altifrons, 45
	280, Zbrojnik lamparci, Glyptopterichthys gibbiceps, 47
	281, Zbrojnik, Hypostomus plecostomus, 47
	282, Pirania czerwona, Pygocentrus nattereri, 48
	283, Pensetnik czarnoglowy, Forcipiger flavissimus, 45
	284, Pokolec krolewski, Paracanthrus hepatus, 45
	287, Zebrasoma zólta, Zebrasoma flavescens, 45
	288, Zebrasoma bialolica, Zebrasoma scopas, 45
	289, Zebrasoma zaglopletwa, Zebrasoma veliferum, 45
	291, Amfiprion okoniowy, Ampifrion ocellaris, 45
	292, Mieczyk hellera, Xiphophorus helleri, 53
	293, Limka czarnoprega, Limia nigrofasciata, 53
	294, Zmienniak wielobarwny, Xiphophorus variatus, 53
	295, Zbrojnik niebieski, Ancistrus dolichopterus, 47
	296, Gupik, Poecilia reticulata, 53
	298, Pokolec turkusowy, Acanthurus coeruleus, 56
	299, Pielegnica cytrynowa, Amphilophus citrinellus, 56
	300, Amfiprion okoniowy, Amphiprion ocellaris, 56
	301, Zbrojnik niebieski, Ancistrus dolichopterus/Hemiancistrus dolichopterus, 56
	302, Duch brazylijski, Apteronotus albifrons, 56
	303, Arapaima, Arapaima gigas, 56
	304, Pielegnica pawiooka, Astronotus ocellatus, 56
	305, Lustrzen meksykanski, Astyanax mexicanus, 56
	306, Rogatnica kolczasta, Balistapus undulatus, 56
	307, Bedocja madagaskarska, Bedotia geayi, 56
	308, Karas zlocisty, Carassius auratus auratus, 56
	309, Nozowiec, Chitala ornata, 56
	310, Bocja wspaniala, Chromobotia macracanthus/Botia macracanthus, 56
	311, Stadnik zóltoogonowy, Chrysiptera parasema, 56
	312, Dlugowšs zabi, Clarias batrachus, 56
	313, Grubowarg syjamski, Crossocheilus oblongus, 56
	314, Dascylus trójplamy, Dascyllus trimaculatus, 56
	315, Skrzydlica mala, Dendrochirus zebra, 56
	316, Zerardynka metaliczna, Girardinus metallicus, 56
	317, Mruk Petersa (trabonos), Gnathonemus petersii, 56
	318, Gurami calujacy, Helostoma temminkii, 56
	319, Drobniczka jednodniówka, Heterandria formosa, 56
	320, Plawikonik zólty, Hippocampus kuda, 56
	321, Bystrzyk pieknopletwy, Hyphessobrycon pulchripinnis, 56
	322, Glonojad sp., Hypostomus sp., 56
	323, Sumek szklisty, Kryptopterus bicirrhis, 56
	324, Niszczuka plamista, Lepisosteus oculatus, 56
	325, Brzanka jednoprega, Leptobarbus hoevenii, 56
	326, Limka czarnoprega, Limia nigrofasciata, 56
	327, Teczanka sp., Melanotaenia sp., 56
	328, Teczanka Boesemana, Melanotaenia boesemani, 56
	329, Rozec skrobacz, Naso lituratus, 56
	330, Ksiezniczka z Burundi, Neolamprologus brichardi, 56
	331, Muszlowiec duzy, Neolamprologus meeli, 56
	332, Arowana srebrna, Osteoglossum bicirrhosum, 56
	333, Motylowiec, Pantodon buchholzi, 56
	334, Pokolec królewski, Paracanthurus hepatus, 56
	335, Gupik, Poecilia reticulata, 56
	336, Molinezja ostrousta, Poecilia sphenops, 56
	337, Ustniczek królewski, Pomacanthus semicirculatus, 56
	338, Zaglowiec wysoki, Pterophyllum altum, 56
	339, Brzanka pregowana, Puntius fasciatus, 56
	340, Brzanka zielona, Puntius semifasciolatus, 56
	341, Brzanka birmanska, Puntius ticto, 56
	342, Pirania czerwona, Pygocentrus nattereri, 56
	343, Lisoglów, Siganus vulpinus, 56
	344, Paletka, Symphysodon aequifasciatus, 56
	345, Dyskowiec, Symphysodon discus, 56
	346, Mandaryn, Synchiropus ocellatus, 56
	347, Gurami drobnoluski, Trichogaster microlepis, 56
	348, Ksenotoka, Xenotoca eiseni, 56
	349, Mieczyk Hellera, Xiphophorus hellerii, 56
	350, Zebrasoma zólta, Zebrasoma flavescens, 56
	351, Zebrasoma zaglopletwa, Zebrasoma veliferum, 56
	352, Zarlacz czarnopletwy, Carcharhinus melanopterus, 57
	353, Arabski rekin dywanowy, Chiloscyllium arabicum, 57
	354, Plaszczka plamista, Potamotrygon motoro, 57
	355, Tawrosz piaskowy, Carcharias taurus, 57
	;
RUN; 
/*********************/



/*tabela zawierajaca informacje o rzedach (klasyfikacja semantyczna zwierzat)*/
data ZOO.ORDERS;
	length order_id 3 
	order_name $50
	division_id 3;
	INFILE DATALINES DLM=',';
 	INPUT order_id order_name $ division_id;
	DATALINES;
	1, Bezgrzebieniowce, 1
	2, Pingwiny, 1
	3, Blaszkodziobe, 1   
	4, Pelnopletwe, 1
	5, Bocianowe, 1
	6, Flamingi, 1
	7, Zurawiowe , 1
	8, Siewkowe, 1
	9, Szponiaste, 1
	10, Grzebiace , 1
	11, Golebiowate, 1
	12, Papugowate, 1
	13, Sowy, 1
	14, Kraskowe, 1
	15, Slonecznicowe, 1
	16, Dzieciolowe, 1
	17, Turakowate, 1
	18, Dzioborozce i dudki, 1
	19, Czepigi, 1
	20, Wróblowate, 1
	21, Trabowce, 2
	22, Góralki, 2
	23, Nieparzystokopytne , 2
	24, Parzystokopytne, 2
	25, Drapiezne, 2
	26, Naczelne, 2
	27, Zajeczaki, 2
	28, Gryzonie, 2
	29, Nietoperze, 2
	30, Szczerbaki, 2
	31, Torbacze, 2
	32, Pajaki, 3
	33, Skolopendroksztaltne, 5
	34, Skorpiony, 3
	35, Pluskwiaki, 6
	36, Prostoskrzydle, 6
	37, Blonkoskrzydle, 6
	38, Systellommatophora, 7
	39, Chrzaszcze, 6
	40, Proscopiidae, 6
	41, Straszyki, 6
	42, Karaczany, 6
	43, Dziesiecionogi, 8
	44, Kostnojezykoksztaltne, 4
	45, Okonioksztaltne, 4
	46, Iglicznioksztaltne, 4
	47, Sumoksztaltne, 4
	48, Kasaczoksztaltne, 4
	49, Szczupakoksztaltne, 4
	50, Ciernikoksztaltne, 4
	51, Karpioksztaltne, 4
	52, Wegorzoksztaltne, 4
	53, Karpiencoksztaltne, 4
	54, Rozdymkoksztaltne, 4
	55, Dywanoksztaltne, 4
	56, Kostnoszkieletowe, 4
	57, Chrzestnoszkieletowe, 4
;
RUN; 
/*********************/



/*tabela zawierajaca informacje o gromadach (klasyfikacja semantyczna zwierzat)*/
data ZOO.DIVISIONS;
	length division_id 3 
	division_name $50;
	INFILE DATALINES DLM=',';
 	INPUT division_id division_name $;
	DATALINES;
	1,	Ptaki
	2,	Ssaki
	3,	Pajeczaki
	4,	Ryby
	5,	Wije
	6,	Owady
	7,	Slimaki
	8,	Pancerzowce
;
RUN; 
/*********************/



/*zbior z imionami dla zwierzakow*/
DATA ZOO.original;
 INPUT name $ @@;
DATALINES;
Agri Ajman Akima Akir Akon Akse Akte Alamo Albert Aleks Alex Alf Alfik Ali Alidor Alidoro Alpik Alvin Algan Amar Amaro Amaru Amazy Ambak Amber Amik Amor Amorek Ampirek Anabol Andersen 
Aneks Anex Antek Anton Antoniusz Anton Anonim Anu Anzo Apacz Apel Apollo Apser Ares Argos Arial Ariel Armani Arma Armi Arnold Aron Arti Artu As Asik Asior Askan Asper Asos Asti Astor 
Astro Atlas Atos Atticus Audrey Ax Axel Azis Azor Azorek Babu Baby Baca Badi Bady Badzi Badzio Badziu Bafi Baffi Baflo Bajan Bajer Bajron Baki Bakir Baks Bakster Bakugan Baku Balko 
Balon Baltazar Baltic Balto Bambi Bambo Bandi Bandziorek Bango Barabol Barney Bartok Bary Barry Basik Basil Baster Bati Batman Baton Bazyl Beethoven Bejbi Beka Beks Bem Bemek Ben Benek 
Beni Benio Benito Benji Berek Berni Bery Bibi Biedul Biegun Big Bigi Bija Bika Bila Bilbo Bill Billi Billy Bilu Bim Bimbo Bistro Blacky Blair Blejk Bleki Blink Blondyn BlueJay Blues 
Bo Bob Bobbie Bobby Bobek Bobi Bobik Bobo Bobus Bodzio Boerboel Bogi Bolek Bolo Bolt Bombon Bond Boni Bono Bonus Bonzo Boo BooBoo Bord Borys Boria Borka Borys Bosman Boston Bounty Bozo 
Brandi Breek Brek Brok Broki Bruiser Brump Bruno Brunon Brutek Brutus Brytan Buba Bubu Budda Buddy Buffy Bugs Buka Bula Bulba Bunio Burek Buro Bursztyn Cacao Caesar Campari Capitan 
Carlo Cash Casio Celta Cezar Chaps Charli Charlie Chaser Cheester Chewy Chico Chief Chip Chojrak Chowder Chrupek Chromo Ciapek Cleo Clifford Cliper Clipper Clown Cmok Coco Cody Cola 
Colargol Colo Como Connie Cookie Cooper Cujo Cygan Cykor Cyprian Cytrus Cywil Czaki Czako Czarek Czarny Cziczi Cziko Czoka Czoko Czort Czujny Czwartek DJ Dafik Dale Dali Damazy Dancer 
Daniele Darel Daster Dasti Dawidz Daz Debi Debian Debiut Dejl Dejler Dejzul Delgado Demon Deryl Dexter Diablo Dick Dido Diego Dino Dodo Dog Dokis Dolar Domingo Donald Dong Dookie Doolar 
Doudou Doug Doyle Draco Drab Drago Dragon Drako Droopy Dropek Drops Dropsik Dual Duck Ducky Dudek Dui Duke Duki Dusty Dylan Dynamit Dyzio Easy Ed Eddie Edek Edi Edward Efi Egor Elfi Eliot 
Elmo Elvis Emil Emir Emo Envy Erni Eston Ewan Fabi Fabio Fado Fafik Faith Falco Falko Falkon Famik Farah Fazi Felek Feliks Felix Fender Feniks Fenix Ferbi Ferdek Ferdynand Fero Fidel Fido 
Fiend Fifi Figiel Figlarz Figaro Fikus Filip Fila Filo Filomen Find Fiodor Fisk Fitek Fix Fliper Flipper Flossie Fofek Foks Fokus Forest Forga Forta Foster Fox Fradzio Franek Franik Francik 
Franz Fred Freddie Fredek Frederick Fredi Fredzio Frodo Frykas Fugo Fuka Fuks Funfel Funy Futrzak Gacek Gacenty Gander Gapa Garfield Gary George Gibson Giff Ginger Gini Gino Gizmo Gobson 
Gonzo Goofy Gorm Graffi Grafi Grand Gremlin Grik Gromit Grubson Gryffindor Grymas Grzmot Guapo Gucio Gufi Gumi Gunter Gustaw Gustawo Gustek Gusto Gutek Gwido Hachi Hachiko Hades Hakelbery 
Hans Happy Harbor Hari Haribo Haris Hary Harry Harvey Hasacz Hasim Hasiu Heban Hektor Herbi Herkules Hermes Heros Hipolit Homer Hooch Hrabia Huck Huckleberry Hugo Humberto Hung Hurbis Idol 
Idriss Imbir Indigo Irys Iwan Iwo Izi Jacek Jacenty Jackie Jag Jake Jakon Jakub Jambo Janek Janosik Jantar Japa Jasper Jerry Jimpa Jogi Johnny Joker Jorga Jorgu Joszko Judy Juki Jumba 
Junior Justin Kabang Kabi Kabir Kacper Kai Kajetan Kajtek Kamik Kamil Kami Kano Kapitan Kaps Kapsel Karmel Karo Karot Karusek Kaspar Kasper Kastor Kazan Keks Kejsi Kelt Kessy Kesy Kevin 
Kibic Kiki Kiler Killer Killian Kim Kimi Kimbo King Kioko Kira Kiri Kissie Kleks Kleksio Klusek Kodi Kofi Koko Kokos Kola Kolik Kolox Koksu Konfi Koni Koral Koralik Korek Kosa Kosmo Kovu 
Krecik Kropek Kruczek Kruszek Krzysiu Kuba Kuki Kusy Kulfon Kundi Kurt Labek Label Labik Lador Laki Lalu Lamba Lamer Lampari Lampo Lapek Laptop Lary Larry Lars Lecik Lego Lejek Leks Leksiu 
Leo Leon Lepek Lesik Leszek Lex Lio Lizak Lizus Loczek Loku Lolik Lord Lorenzo Lucek Luckey Lucky Lucyfer Luger Lui Luka Luki Lulu Lumpek Lutek Luzak Maciek Madison Madziar Maf Mafik Mafin 
Magic Magus Mailo Mailoo Majki Majko Majlo Major Maks Maksik Maksio Maksiu Malin Malloy Mamba Mango Maniek Mapet Maras Marco Mari Marian Markus Marley Marocho Mars Marszand Maruda Max 
Maxim Maxiu Maxuel Maxymilian Mefi Mello Messi Messy Metin Micah Mick Mietek Mikado Mike Miki Mikrus Milo Milus Miras Mirek Misiaczek Misiek Misio Misiu Miszka Mizio Mleczko Moko Monti 
Monty Mops Mopsik Morgan Moric Moris Morisek Morus Morusek Mozart Muchomorek Mufi Muffin Mugly Mundi Murek Murzyn Murzynek Musiek Mussi Nagaj Najki Naki Naomi Napi Narcyz Natan Nawi Nazir 
Nefryt Negro Nelson Nemo Nemrod Nergo Nero Neron Nesi Nessi Nesta Nesti Nesty Net Newil Nex Niki Nikita Nikki Niko Nitro Nixon Nokia Norek Noric Noris Normi Nugat Nuka Obi Obie Oddie Odi 
Odie Okruszek Olen Olive Olek Opal Orbis Orkisz Orlando Orkisz Oscar Oskar Oskarek Otello Othello Otis Otto OwiAxel Ozor Ozzi Ozzy Paka Pajk Paco Pako Paliw Pandur Pankracy Papik Papin 
Patrick Patyk Parys Paxi Pedro Pello Pepe Percy Persi Phillip Piegus Pikador Pietro Piko Piksi Piksel Pilot Pimpek Pinio Pirat Pixel Plamik Platon Pluto Poldek Pongo Porter Portos Potter 
Psikus Puc Pucek Pudsey Puggy Pui Pus Puszek Puzon Raban Rabik Raby Rafcio Rafi Rafik Rainbow Rambo Ramzes Rapi Raptor Raptus Raven Regan Reks Reksio Remi Remik Resco Resko Rex Rexxx Rico Riko Ringo River Rob Robi Robik Rocky Rodos Rodzyn Roki Roky Rolmops Rover Romeo Rony Roy Roys Ruben Ruber 
 Rubi Rubin Rubinek Ruby Rudi Rudolf Rufi Rufus Rulon Rush Ruten Rysiek Rywal Sabaku Sagan Saha Sajmon Sam Sambor Sando Sasha Scooby Scrapi Shadow Shaggy Shanti Shorty Sid Sidney Sienik 
 Sierra Silver Simba Simon Sitek Skiper Skoti Skrapi Skrobek Skoczek Skubi Sliver Smokie Smookie Smutek Smyk Smrodek Snooby Snookie Snapi Snuffls Snupi Snuppy Sonik Soofy Sookie Spajk 
 Spajki Speed Springer Star Stefan Stich Sticz Stig Stubby Sulej Suliko Suzuki Sweet Sybil Szajba Szaman Szarik Szczudlik Szejk Szilok Szkrab Szon Szyszek Tabi Tabun Tachfiku Tadeusz 
 Tadzik Tajga Tako Tajson Tamtam Taner Tarol Tarzan Tasman Ted Teddy Tedi Tibo Tichtiku Tiger Tigger Timon Timur Tito Tobi Tobias Tobiasz Tobik Toffee Toffi Toffik Toffin Tofi Tofi-fi 
 Tofik Tokaj Tolek Tom Tomy Tonik Topek Toro Torro Tory Tosiek Toto Toudi Trajpod Tramp Trampek Trymer Tupet Turbo Tutu Twix Tygrysek Tymi Tymon Tysek Tyson Tytus Uggi Uggie Uno Urwisek 
 Venturi Vero Verus Viggo Vigo Vip  Wacek Walen Wang Wasyl Wedel Weteran Wicher Wigdeon Whiskers Whisky Whusky Wiercioch Wulcan Wulkan Xander Xavi Xavier Xiao Yaris Yogi Zajon Zak Zaki 
 Zamas Zanjeer Zano Zefir Zeus Zibi Ziomal Ziutek Zordon Zorus Zuzu
;
run;


DATA ZOO.augmented;
  SET ZOO.original;
  sortval = ranuni(0);
RUN;

PROC SORT DATA=ZOO.augmented OUT=ZOO.names(DROP=sortval) ;
  BY sortval;
RUN;

proc sql;
	drop table ZOO.augmented;
	drop table ZOO.original;
quit;
/*********************/



/*tabela zawierajaca spis zwierzat w ZOO*/
data ZOO.ANIMALS;
	length 
	animal_id 7
	name $20
	sex $1
	birth_date 6
	birth_place $20
	deceased_date 6
	species_id 3
	object_id $5;

	retain animal_id 1 female 'F' male 'M' start_date '09mar08'd;
	retain countrycounter 41 countrylist 'Andora Angola Argentyna Australia Barbados Brazylia Chile Chiny Cypr Dominikana Ekwador Filipiny Finlandia Gabon Gambia Ghana Grenada Haiti Honduras Indie Indonezja Jemen Jordania Kambodza Kanada Kolumbia Kongo Kuba Laos Madagaskar Malezja Maroko 
 	Meksyk Mozambik Nepal Suazi Sudan Tanzania Togo Tuvalu Uganda';
	retain pta 0 ter 0 wyb 0 akw 0;
	format start_date birth_date deceased_date ddmmyy10.;
	set ZOO.SPECIES end=last;		
		birth_country=scan(countrylist,round(ranuni(0)*40)+1); *dla calego gatunku jeden kraj;

		if order_id<=20 then do; *ptaki;
			if pta eq 0 then pta=1; else do; if ranuni(0)<=0.5 then pta=pta+1; end;
			object_id=cats("PTA",pta);
			do i=1 to ceil(20*ranuni(0))+6;				
				birth_date=start_date+round(365*9*ranuni(0));
				if ranuni(0)<=0.5 then sex=female; else sex=male;
				if year(birth_date)>=2010 then birth_place="ZOO"; else birth_place=birth_country; 

				if ranuni(0)<=0.7 then do;
					if year(birth_date)<2013 then deceased_date=birth_date+round(365*2*ranuni(0)+365);
				end; 
					
				output;
				animal_id=animal_id+1;
				deceased_date=.;				
			end;
		end;
		if order_id>20 and order_id<=31 then do; *ssaki;
			if wyb eq 0 then wyb=1; else do; if ranuni(0)<=0.5 then wyb=wyb+1; end;
			object_id=cats("WYB",wyb);
			do i=1 to ceil(20*ranuni(0))+5;				
				birth_date=start_date+round(365*9*ranuni(0));
				if ranuni(0)<=0.5 then sex=female; else sex=male;
				if year(birth_date)>=2010 then birth_place="ZOO"; else birth_place=birth_country; 

				if ranuni(0)<=0.5 then do;
					if year(birth_date)<2013 then deceased_date=birth_date+round(365*2*ranuni(0)+365);
				end; 

				output;
				animal_id=animal_id+1;
				deceased_date=.;
			end;
		end;
		if order_id>31 and order_id<=43 then do; *bezkregowce;
			if ter eq 0 then ter=1; else do; if ranuni(0)<=0.5 then ter=ter+1; end;
			object_id=cats("TER",ter);
			do i=1 to ceil(30*ranuni(0))+7;				
				birth_date=start_date+round(365*9*ranuni(0));
				if ranuni(0)<=0.5 then sex=female; else sex=male;
				if year(birth_date)>=2010 then birth_place="ZOO"; else birth_place=birth_country; 

				if ranuni(0)<=0.8 then do;
					if year(birth_date)<2014 then deceased_date=birth_date+round(365*3*ranuni(0));
				end; 

				output;
				animal_id=animal_id+1;
				deceased_date=.;
			end;
		end;
		if order_id>43 then do; *ryby;
			if akw eq 0 then akw=1; else do; if ranuni(0)<=0.5 then akw=akw+1; end;
			object_id=cats("AKW",akw);
			do i=1 to ceil(25*ranuni(0))+6;				
				birth_date=start_date+round(365*9*ranuni(0));
				if ranuni(0)<=0.5 then sex=female; else sex=male;
				if year(birth_date)>=2010 then birth_place="ZOO"; else birth_place=birth_country; 

				if ranuni(0)<=0.5 then do;
					if year(birth_date)<2013 then deceased_date=birth_date+round(365*2*ranuni(0)+365);
				end; 

				output;
				animal_id=animal_id+1;
				deceased_date=.;
			end;
		end;

	if last then do;
		call symputx('pta',pta);
		call symputx('wyb',wyb);
		call symputx('ter',ter);
		call symputx('akw',akw);
		call symputx('animals',animal_id-1);
	end;
	keep animal_id name sex birth_date birth_place deceased_date species_id object_id;
RUN; 

proc sql noprint;
	select count(*) into: names_count
	from ZOO.names;
quit;

%macro multipleNames();
	%let loop=%sysevalf(&animals./&names_count.,ceil);

	data ZOO.NAMES;
	set %do i=1 %to &loop.;
		ZOO.NAMES 
	%end;
	;
	run;
	%put &=loop.;
%mend;

%multipleNames();

data ZOO.ANIMALS;
	set ZOO.ANIMALS;
	set ZOO.NAMES;
run;

proc sort data=ZOO.ANIMALS;
	by BIRTH_DATE;
run;

proc sql;
	drop table ZOO.names;
quit;

data ZOO.ANIMALS;
	set ZOO.ANIMALS;
	animal_id=_n_;
run;
/*********************/



/*tabela zawierajaca spis obiektów*/
data ZOO.OBJECTS;
	length object_id $5
	object_type $15;
	
	do i=1 to &wyb.;
		object_id=cats("WYB",i);
		object_type="Wybieg";
		output;
	end;

	do i=1 to &ter.;
		object_id=cats("TER",i);
		object_type="Terrarium";
		output;
	end;

	do i=1 to &pta.;
		object_id=cats("PTA",i);
		object_type="Ptaszarnia";
		output;
	end;

	do i=1 to &akw.;
		object_id=cats("AKW",i);
		object_type="Akwarium";
		output;
	end;
	keep object_id object_type;
run;
/*********************/



/*tabela zawierajaca zestawienie pracowników odpowiedzialnych za poszczególne obiekty*/
proc sql noprint;
	select count(*) into: staffcounter from ZOO.EMPLOYEES where position_code=5 and layoff_date=.;
quit;

proc sql noprint;
	select employee_id into: staff1- from ZOO.EMPLOYEES where position_code=5 and layoff_date=.;
quit;

data ZOO.RESPONSIBLE_STAFF;
	length employee_id 6
	object_id $5;
	set ZOO.OBJECTS;
		do i=1 to round(4*ranuni(0)+3);
			index=ceil(&staffcounter.*ranuni(0));
			varname=cats("staff",index);
			employee_id=symget(varname);
			output;
		end;
	keep employee_id object_id;
run;

proc sort data=ZOO.RESPONSIBLE_STAFF nodup;
by employee_id;
run;


/*********************/



/*tabela zawierajaca spis zywnosci*/
data ZOO.FOOD;
	length food_id 4
	name $30
	quantity 6
	unit $8;
	INFILE DATALINES DLM=',';
 	INPUT food_id name $ quantity unit $;
	DATALINES;
	1, Ziarna slonecznika, 1200, g
	2, Proso zólte, 2000, g
	3, Rzepak ziarna, 3400, g
	4, Mak, 1500, g
	5, Orzechy mix, 2200, g
	6, Sezam ziarna, 3200, g
	7, Proso senegalskie, 1600, g
	8, Kasza mix, 2000, g
	9, Pszenica ziarna, 3000, g
	10, Owies ziarna, 1300, g
	11, Platki owsiane, 3100, g
	12, Plankton, 1200, g
	13, Slimaki, 3000, g
	14, Muszki owocówki, 2000, g
	15, Oczlik, 1500, g
	16, Rozwielitka, 1800, g
	17, Czarna larwa komara, 2300, g
	18, Ochotka, 2500, g
	19, Wodzien, 3200, g
	20, Rurecznik, 2600, g
	21, Doniczkowce, 1900, g
	22, Granulat dla ryb, 5200, g
	23, Pokarm w tabletkach dla ryb, 6500, g
	24, Glony, 4500, g
	25, Mieso ryb mix, 2500, g
	26, Karma dla owadów mix, 3500, g
	27, Swierszcze, 1800, g
	28, Salata, 500, g
	29, Kapusta, 900, g
	30, Pedy traw Spinifex, 4500, g
	31, Rosliny mix, 6500, g	
	32, Owoce mix, 6500, g
	33, Pedy bambusa, 3600, g
	34, Mieso ssaków, 36, kg
	35, Mieso ptaków, 28, kg
	;
RUN; 
/*********************/



/*tabela zawierajaca wymagania dietetyczne dla poszczególnych gatunków*/
data ZOO.SPECIES_DIETARY_REQUIREMENTS;
	length requirement_id 4 
	species_id 3 
	food_id 4 
	daily_amount 4 
	unit $3;

	retain requirement_id 1;
	set ZOO.SPECIES;
		
		if species_id<164 then do; *ptaki;
			food_id=1+round(10*ranuni(0));
			daily_amount = 10*ceil(10*ranuni(0));
			unit="g";
			
			tmp=1+round(10*ranuni(0));
			if tmp ne food_id then do;
				output;		
				requirement_id=requirement_id+1;
				food_id=tmp;
				daily_amount = 10*ceil(10*ranuni(0));
				unit="g";		
			end;	
		end;
		else if species_id>=164 and species_id<=230 then do; *ssaki;
			if species_id<=191 or (species_id>=208 and species_id<=228) then do;
				food_id=30;
				daily_amount = 50+10*ceil(7*ranuni(0));
				unit="g";
				output;		
				requirement_id=requirement_id+1;
				food_id=31;
				daily_amount = 100+100*ceil(6*ranuni(0));
				unit="g";
				output;		
				requirement_id=requirement_id+1;
				food_id=32;
				daily_amount = 100+100*ceil(3*ranuni(0));
				unit="g";
			end;
			if species_id>=192 and species_id<=195 then do;
				food_id=25;
				daily_amount = 200+100*ceil(9*ranuni(0));
				unit="g";	
				output;		
				requirement_id=requirement_id+1;
				if species_id=195 then do;
					food_id=33;
					daily_amount = 200+100*ceil(5*ranuni(0));
					unit="g";
				end;
			end;

			if species_id>=196 and species_id<=207 then do;
				food_id=34;
				daily_amount = 1+ceil(9*ranuni(0));
				unit="kg";
				output;		
				requirement_id=requirement_id+1;
				food_id=35;
				daily_amount = 1+ceil(9*ranuni(0));
				unit="kg";
			end;
			if species_id=229 or species_id=230  then do;
				food_id=30;
				daily_amount = 100+100*ceil(5*ranuni(0));
				unit="g";
			end;
		end;
		else if species_id>=231 and species_id<=242 then do; *pajaki;
			food_id=14+round(7*ranuni(0));
			if ranuni(0)<0.3 then food_id=27;
			daily_amount = 10*ceil(7*ranuni(0));
			unit="g";
			
			tmp=14+round(7*ranuni(0));
			if tmp ne food_id then do;
				output;		
				requirement_id=requirement_id+1;
				food_id=tmp;
				daily_amount = 10*ceil(5*ranuni(0));
				unit="g";
			end;	
		end;
		else if species_id>=243 and species_id<=255 then do; *owady;
			food_id=26;
			if species_id=245 then food_id=28+round(ranuni(0));
			daily_amount = 10*ceil(7*ranuni(0));
			unit="g";
		end;
		else if species_id=256 or species_id=260 or species_id=261 or species_id=262 then do; *pancerzyki;
			food_id=24;
			daily_amount = 10*ceil(7*ranuni(0));
			unit="g";
			
			if species_id=256 then do;
				output;
				requirement_id=requirement_id+1;
				food_id=25;
				daily_amount = 10*ceil(5*ranuni(0));
				unit="g";
			end;
		end;
		else if (species_id>=257 and species_id<=259) or species_id>=263 then do; *ryby;
			food_id=12+round(11*ranuni(0));
			daily_amount = 10*ceil(7*ranuni(0));
			unit="g";
			
			tmp=12+round(11*ranuni(0));
			if tmp ne food_id then do;
				output;		
				requirement_id=requirement_id+1;
				food_id=tmp;
				daily_amount = 10*ceil(5*ranuni(0));
				unit="g";
			end;	
		end;

		output;
		requirement_id=requirement_id+1;

	keep requirement_id species_id food_id daily_amount unit;
run;
/*********************/



/*tabela zawierajaca spis wszystkich dostaw*/
proc sql noprint;
	select count(*) into: suppliers from ZOO.SUPPLIERS;
quit;

data ZOO.SUPPLIES;
	length supply_id 8 date 6 supplier_id 3 amount 7;
	format date ddmmyy10. amount 5.2;
	date='01jan10'd;
	days_cnt=&today.-date;
	supply_id=0;
	array days[&suppliers.];

	do supplier=1 to &suppliers.;
		days[supplier]=ceil(7*ranuni(0));
	end;

	do i=1 to days_cnt;
		do supplier_id=1 to &suppliers.;
			if mod(date,days(supplier_id)) eq 0 then do;
				supply_id=supply_id+1;
				output;
			end;
		end;
		date=date+1;
	end;
	keep supply_id date supplier_id amount;
run;
/*********************/



/*tabela zawierajaca szczegoly wszystkich dostaw*/
data ZOO.SUPPLIES_DETAILS;
	length supply_id 8 food_id 4 quantity 5 unit $3 price 4;
	format price 5.2;
	set ZOO.SUPPLIES;

	if supplier_id=1 then do;
		do i=28 to 29;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(20+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id=2 then do;
		do i=12 to 13;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(60+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id=3 then do;
		do i=22 to 24;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(45+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id=4 then do;
		food_id=14; 
		quantity=100+100*ceil(2*ranuni(0));
		unit='g';
		price=(quantity/1000)*(39+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=5 then do;
		food_id=15; 
		quantity=100+100*ceil(2*ranuni(0));
		unit='g';
		price=(quantity/1000)*(35+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=6 then do;
		do i=1 to 3;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(40+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id=7 then do;
		food_id=16; 
		quantity=100+100*ceil(3*ranuni(0));
		unit='g';
		price=(quantity/1000)*(35+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=8 then do;
		food_id=17; 
		quantity=100+100*ceil(2*ranuni(0));
		unit='g';
		price=(quantity/1000)*(40+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=9 then do;
		food_id=18; 
		quantity=100+100*ceil(2*ranuni(0));
		unit='g';
		price=(quantity/1000)*(35+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=10 then do;
		food_id=19; 
		quantity=100+100*ceil(2*ranuni(0));
		unit='g';
		price=(quantity/1000)*(35+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=11 then do;
		do i=4 to 6;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(40+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id=12 then do;
		do i=7 to 9;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(40+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id>=13 and supplier_id<=19 then do;
		food_id=supplier_id+7; 
		quantity=100+100*ceil(2*ranuni(0));
		unit='g';
		price=(quantity/1000)*(35+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=20 then do;
		food_id=34;
		quantity=2+ceil(5*ranuni(0));
		unit='kg';
		price=quantity*(60+ceil(20*ranuni(0)));
		output;	
	end;

	if supplier_id=21 then do;
		do i=10 to 11;
			food_id=i;
			quantity=200+100*ceil(5*ranuni(0));
			unit='g';
			price=(quantity/1000)*(40+ceil(20*ranuni(0)));
			output;
		end;
	end;

	if supplier_id>=22 and supplier_id<=23 then do;
		food_id=supplier_id+10; 
		quantity=100+100*ceil(4*ranuni(0));
		unit='g';
		price=(quantity/1000)*(35+ceil(10*ranuni(0)));
		output;	
	end;

	if supplier_id=24 then do;
		food_id=35;
		quantity=2+ceil(5*ranuni(0));
		unit='kg';
		price=quantity*(60+ceil(20*ranuni(0)));
		output;	
	end;

	keep supply_id food_id quantity unit price;

run;

/*uzupelnienie tabeli z dostawami */
proc sql;
	create table ZOO.supplies_amount as
	select t.supply_id, sum(price) as amount
	from ZOO.supplies t
	join ZOO.supplies_details td on t.supply_id=td.supply_id
	group by t.supply_id;
quit;

data ZOO.SUPPLIES; 
  merge ZOO.supplies ZOO.supplies_amount; 
  by supply_id; 
run; 

proc sql;
	drop table ZOO.supplies_amount;
quit;
/*********************/



/*tabela przedstawiajaca inne wydatki*/
data ZOO.OTHER_EXPENSES;
	length expense_id 8 invoice_id $15 company_name $20 NIP $10 invoice_date 6 payment_date 6 amount_gross 5 paid $1 description $40;
	format invoice_date payment_date ddmmyy10. amount_gross 7.2;
	
	companies=10;
	array NIPS[10]  (2953643889, 7676147342, 4581456487, 5975906760, 4515484995, 6861299937, 4620109414, 1841576325, 3839642736, 9332786857);
	array comp_names[10] $20 ("Wodociagi", "Urzad miasta", "LUXMED", "Serwis techniczny", "Biuro reklamowe", "Elektrownia", "PGNiG", "8", "9", "10");
	array amounts[10]  (1500, 10000, 5000, 1000, 3000, 2000, 2000, 0, 0, 0);
	array days[10];

	do company=1 to companies;
		days[company]=ceil(14*ranuni(0));
	end;
	expense_id = 0;
	do year=2010 to 2017;
		do month=1 to 12;
			*if year=2017 and month>=6 then leave;
			if year=year(&today.) and month>=month(&today.) then leave;
			do company=1 to companies;
				if company=5 and ranuni(0)>0.7 then leave;
				expense_id=expense_id+1;
				invoice_id=cats("FV/",month,"/",year,"/",ceil(14*ranuni(0)));
				company_name=comp_names(company);
				NIP =NIPS(company);
				invoice_date = mdy(month,days(company),year);
				payment_date =invoice_date+ceil(14*ranuni(0));
				amount_gross = amounts(company)+100*round(5*ranuni(0));
				paid = "T";
				if year=2017 and month>=(month(&today.)-1) then paid = "N";
				description="";
				output;
			end;	
		end;
	end;
	keep expense_id  invoice_id  company_name  NIP invoice_date  payment_date  amount_gross  paid description;
run;
/*********************/



/* klucze glówne */
PROC SQL;
ALTER TABLE ZOO.CONTRACT_TYPES ADD CONSTRAINT PK_CONTRACT_TYPES PRIMARY KEY (contract_type_id);
ALTER TABLE ZOO.POSITIONS ADD CONSTRAINT PK_POSITIONS PRIMARY KEY (position_code);
ALTER TABLE ZOO.TICKET_TYPES ADD CONSTRAINT PK_TICKET_TYPES PRIMARY KEY (ticket_type_id);
ALTER TABLE ZOO.TICKET_TYPES_HIST ADD CONSTRAINT PK_TICKET_TYPES_HIST PRIMARY KEY (ticket_type_id, valid_from);
ALTER TABLE ZOO.EMPLOYEES ADD CONSTRAINT PK_EMPLOYEES PRIMARY KEY (employee_id);
ALTER TABLE ZOO.TRANSACTIONS ADD CONSTRAINT PK_TRANSACTIONS PRIMARY KEY (transaction_id);
ALTER TABLE ZOO.TRANSACTION_DETAILS  ADD CONSTRAINT PK_TRANSACTION_DETAILS PRIMARY KEY (transaction_id, ticket_type_id);
ALTER TABLE ZOO.OBJECTS  ADD CONSTRAINT PK_OBJECTS PRIMARY KEY (object_id);
ALTER TABLE ZOO.RESPONSIBLE_STAFF ADD CONSTRAINT PK_RESPONSIBLE_STAFF PRIMARY KEY (employee_id, object_id); 
ALTER TABLE ZOO.ANIMALS ADD CONSTRAINT PK_ANIMALS PRIMARY KEY (animal_id);
ALTER TABLE ZOO.SPECIES ADD CONSTRAINT PK_SPECIES PRIMARY KEY (species_id);
ALTER TABLE ZOO.ORDERS ADD CONSTRAINT PK_ORDERS PRIMARY KEY (order_id);
ALTER TABLE ZOO.DIVISIONS ADD CONSTRAINT PK_DIVISIONS PRIMARY KEY (division_id);
ALTER TABLE ZOO.FOOD ADD CONSTRAINT PK_FOOD PRIMARY KEY (food_id);
ALTER TABLE ZOO.SUPPLIERS ADD CONSTRAINT PK_SUPPLIERS PRIMARY KEY (supplier_id);
ALTER TABLE ZOO.SUPPLIES ADD CONSTRAINT PK_SUPPLIES PRIMARY KEY (supply_id);
ALTER TABLE ZOO.SUPPLIES_DETAILS ADD CONSTRAINT PK_SUPPLIES_DETAILS PRIMARY KEY (supply_id, food_id);
ALTER TABLE ZOO.SPECIES_DIETARY_REQUIREMENTS ADD CONSTRAINT PK_SPECIES_DIETARY_REQUIREMENTS PRIMARY KEY (requirement_id);
ALTER TABLE ZOO.OTHER_EXPENSES ADD CONSTRAINT PK_OTHER_EXPENSES PRIMARY KEY (expense_id);
QUIT;
/*********************/



/* klucze obce */
PROC SQL;
ALTER TABLE ZOO.EMPLOYEES ADD CONSTRAINT FK_EMPLOYEES_CONTRACT_TYPES FOREIGN KEY(contract_type) REFERENCES ZOO.CONTRACT_TYPES;
ALTER TABLE ZOO.EMPLOYEES ADD CONSTRAINT FK_EMPLOYEES_POSITIONS FOREIGN KEY(position_code) REFERENCES ZOO.POSITIONS;
ALTER TABLE ZOO.TRANSACTION_DETAILS ADD CONSTRAINT FK_TRANDETAILS_TRAN FOREIGN KEY(TRANSACTION_ID) REFERENCES ZOO.transactions;
ALTER TABLE ZOO.TRANSACTIONS ADD CONSTRAINT FK_TRAN_EMPLOYEES FOREIGN KEY(employee_id) REFERENCES ZOO.EMPLOYEES;
ALTER TABLE ZOO.RESPONSIBLE_STAFF ADD CONSTRAINT FK_RESPSTAFF_EMPLOYEES FOREIGN KEY(employee_id) REFERENCES ZOO.EMPLOYEES;
ALTER TABLE ZOO.RESPONSIBLE_STAFF ADD CONSTRAINT FK_RESPSTAFF_OBJECTS FOREIGN KEY(object_id) REFERENCES ZOO.OBJECTS;
ALTER TABLE ZOO.ANIMALS ADD CONSTRAINT FK_ANIMALS_OBJECTS FOREIGN KEY(object_id) REFERENCES ZOO.OBJECTS;
ALTER TABLE ZOO.ANIMALS ADD CONSTRAINT FK_ANIMALS_SPECIES FOREIGN KEY(species_id) REFERENCES ZOO.SPECIES;
ALTER TABLE ZOO.SPECIES ADD CONSTRAINT FK_SPECIES_ORDERS FOREIGN KEY(order_id) REFERENCES ZOO.ORDERS;
ALTER TABLE ZOO.ORDERS ADD CONSTRAINT FK_ORDERS_DIVISIONS FOREIGN KEY(division_id) REFERENCES ZOO.DIVISIONS;
ALTER TABLE ZOO.SPECIES_DIETARY_REQUIREMENTS ADD CONSTRAINT FK_DIETREQ_SPECIES FOREIGN KEY(species_id) REFERENCES ZOO.SPECIES;
ALTER TABLE ZOO.SPECIES_DIETARY_REQUIREMENTS ADD CONSTRAINT FK_DIETREQ_FOOD FOREIGN KEY(food_id) REFERENCES ZOO.FOOD;
ALTER TABLE ZOO.SUPPLIES_DETAILS ADD CONSTRAINT FK_SUPPLIES_DET_FOOD FOREIGN KEY(food_id) REFERENCES ZOO.FOOD;
ALTER TABLE ZOO.SUPPLIES_DETAILS ADD CONSTRAINT FK_SUPPLIES_DET_SUPPLIES FOREIGN KEY(supply_id) REFERENCES ZOO.SUPPLIES;
ALTER TABLE ZOO.SUPPLIES ADD CONSTRAINT FK_SUPPLIES_SUPPLIERS FOREIGN KEY(supplier_id) REFERENCES ZOO.SUPPLIERS;
ALTER TABLE ZOO.TRANSACTION_DETAILS ADD CONSTRAINT FK_TRANDETAILS_TICKETTYPES FOREIGN KEY(ticket_type_id) REFERENCES ZOO.TICKET_TYPES;
ALTER TABLE ZOO.TICKET_TYPES_HIST ADD CONSTRAINT FK_TICKETTYPESHIST_TICKETTYPES FOREIGN KEY(ticket_type_id) REFERENCES ZOO.TICKET_TYPES;
QUIT;
/*********************/



