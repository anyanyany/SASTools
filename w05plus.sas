/* gdzie przechowywana jest makrozmienna? w ktorej tablicy? */

/* CALL SYMPUT tworzy zmienna w najbardziej lokalnej _niepustej_ tabeli makrozmiennych */

%macro test1_CallSymput();

data _null_;
    call symput('test1', 'Gdzie mnie wsadzi Call Symput ? v1');
run;

%put **********;
%put _local_;
%put **********;


%mend test1_CallSymput;

%test1_CallSymput()

%put ##########;
%put _user_;
%put ##########;









%macro test2_CallSymput();

%let dummy_x=2;

data _null_;
    call symput('test2', 'Gdzie mnie wsadzi Call Symput ? v2');
run;

%put **********;
%put _local_;
%put **********;


%mend test2_CallSymput;

%test2_CallSymput()

%put ##########;
%put _user_;
%put ##########;







%macro test3_CallSymput(dummy_x);

data _null_;
    call symput('test3', 'Gdzie mnie wsadzi Call Symput ? v3');
run;

%put **********;
%put _local_;
%put **********;


%mend test3_CallSymput;

%test3_CallSymput(3)

%put ##########;
%put _user_;
%put ##########;







%macro test3_CallSymput(dummy_x=3.5);

data _null_;
    call symput('test3_5', 'Gdzie mnie wsadzi Call Symput ? v3.5');
run;

%put **********;
%put _local_;
%put **********;


%mend test3_CallSymput;

%test3_CallSymput()

%put ##########;
%put _user_;
%put ##########;








/* jak wymusic wypchniecie makrozmiennej do zakresu globalnego? */



%macro test4_CallSymputX(x=17);

data _null_;
    call SYMPUTX('test4', 'Gdzie mnie wsadzi Call SymputX ? v4', 'G');
run;

%put **********;
%put _local_;
%put **********;


%mend test4_CallSymputX;

%test4_CallSymputX()

%put ##########;
%put _user_;
%put ##########;









/* jeszcze jedna drobna obserwacja */


%macro test5_CallSymputX();

data _null_;
    call SYMPUTX('test5', 12345, 'G');
run;

data _null_;
    call SYMPUT('test6', 12345);
run;

%put **********;
%put _local_;
%put **********;


%mend test5_CallSymputX;


%test5_CallSymputX();

%put ##########;
%put _user_;
%put ##########;




/* call SymputX konwertuje liczy formatem BEST. i nie wypisuje warning'a */







/* pusta tablica lokalna */

/* wyjatek 1 - po uzyciu procedury SQL */

%macro test7_CallSymput(); 

data _null_;
    call symput('test7', 'Gdzie mnie wsadzi Call Symput ? v7'); /* przed SQL */
run;

PROC SQL;
QUIT;

data _null_;
    call symput('test8', 'Gdzie mnie wsadzi Call Symput ? v8'); /* po SQL */
run;

%put **********;
%put _local_;
%put **********;

%mend test7_CallSymput;

%test7_CallSymput()

%put ##########;
%put _user_;
%put ##########;








/* wyjatek 2 - uzywamy pocji PARMBUFF i makrozmiennej &SYSPBUFF. */

%let test10=jestem w globalnej tablicy;

%macro test9_CallSymput() / PARMBUFF; /* <- bufor parametrow pozwala na budowanie 
                                            makr ze zmienna iloscia parametrow */

data _null_;
    call symput('test9', 'Gdzie mnie wsadzi Call Symput ? v9'); 
run;

%put $$&SYSPBUFF.$$; /* makrozmienna przechowujaca liste podanych do makra parametrow */

data _null_;
    call symput('test10', 'Gdzie mnie wsadzi Call Symput ? v10'); /* zmienna juz istniejaca w zakresie wyzej */
run;

%put **********;
%put _local_;
%put **********;

%mend test9_CallSymput;

%test9_CallSymput(parametr1,parametr2,parametr3,parametr4)

%put ##########;
%put _user_;
%put ##########;










/* wyjatek 3 - %GOTO &LABEL */

%let labelka=OminMnie;
%let test12=ja tez jestem w globalnej tablicy;

%macro test11_CallSymput(); 

data _null_;
    call symput('test11', 'Gdzie mnie wsadzi Call Symput ? v11'); 
run;

%if %eval(2+2 = 4) %then %GOTO &labelka; /* <- computed %GOTO - etykieta powstaje z makra(%) lub makrozmiennej(&)*/

data kawalek_do_ominiecia;
    x = "To skip or not to skip? That is the question!";
run;


%OminMnie:
;

data _null_;
    call symput('test12', 'Gdzie mnie wsadzi Call Symput ? v12'); 
run;

%put **********;
%put _local_;
%put **********;

%mend test11_CallSymput;

%test11_CallSymput()

%put ##########;
%put _user_;
%put ##########;
