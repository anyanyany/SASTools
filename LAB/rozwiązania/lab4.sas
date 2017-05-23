/* Lab 4
Zawadzka Anna */

dm log 'clear' log;

data Lab04;
	length dsin dsout $ 8 loop 8 variable $ 8;
	dsin=" "; dsout="a"; loop=102; variable="x"; output;
	dsin="a b"; dsout="c"; loop=.; variable=" "; output;
	dsin=" "; dsout="b"; loop=100; variable="x"; output;
	dsin="c d"; dsout="e"; loop=.; variable=" "; output;
	dsin=" "; dsout="d"; loop=321; variable="x"; output;
run;


%macro generate1(dsout, loop, variable);
	data &dsout.;
	do &variable.=1 to &loop.;
		output;
	end;
	run;
%mend;


%macro generate2(dsin, dsout);		
	data &dsout.;
		set &dsin.;
	run;
%mend;



/*wersja z makrami*/

data _null_;
	set Lab04;
	call symput('dsin',dsin);
	call symput('dsout',dsout);
	call symput('loop',loop);
	call symput('variable',variable);

	if dsin ne "" then do;
		CALL EXECUTE('%generate2(&dsin, &dsout)');
	end;
	else do;
		 rc = DOSUBL('%generate1(&dsout, &loop, &variable)');
	end;
run;



/*wersja bez makr*/

data _null_;
	set Lab04;
	if dsin ne "" then do;
		CALL EXECUTE('data '|| dsout||'; set '|| dsin||'; run;');
	end;
	else do;
		 rc = DOSUBL('data '||dsout||'; do '||variable||'=1 to '||loop||'; output; end; run;');
	end;
run;



