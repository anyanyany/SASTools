*options mprint symbolgen;

%macro insert_divisions(division_name);
	%let divname=;
	proc sql noprint;
		select division_name into: divname from ZOO.DIVISIONS where lower(division_name)="&division_name.";
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

%insert_divisions(Dinozaury)



