/* Anna Zawadzka
lab 9 */

/*********************************************************************************/
/* 1. uzycie kompresji spowoduje jej automatyczne wylaczenie przez SASa*/

data set_without(COMPRESS=NO) set_binary(COMPRESS=BINARY);
	hehe="hehe";
run;

/* Compression was disabled for data set WORK.SET_BINARY because compression overhead would
      increase the size of the data set. */
/*********************************************************************************/


/*********************************************************************************/
/* 2. uzycie kompresji spowoduje zwiekszenie rozmiaru pliku co najmniej o 50%*/

data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR);
	do i=1 to 1E4; 
		hehe1=ranuni(0);
	    hehe2=ranuni(0);
		output;
	end;
	drop i;
run;

/* Compressing data set WORK.SET_CHAR increased size by 100.00 percent.*/
/*********************************************************************************/


/*********************************************************************************/
/* 3. uzycie kompresji binarnej spowoduje zwiekszenie rozmiaru pliku bardziej niz uzycie kompresji znakowej*/

data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
	do i=1 to 1E4;
	    hehe1="abc";
	    hehe2="def";
	    hehe3="ghi";
	    hehe4="jkl";
	    hehe5="mno";
		output;
	end;
run;

/* Compressing data set WORK.SET_CHAR increased size by 50.00 percent.
   Compressing data set WORK.SET_BINARY increased size by 75.00 percent. */
/*********************************************************************************/


/*********************************************************************************/
/* 4. uzycie kompresji spowoduje zmniejszenie rozmiaru pliku co najmniej o 95%*/  

data set_without(COMPRESS=NO) set_binary(COMPRESS=BINARY);
	length hehe $ 2000;
	do i=1 to 1E4; drop i;
		hehe="hehe";
		output;
	end;
run;

/* Compressing data set WORK.SET_BINARY decreased size by 98.40 percent. */
/*********************************************************************************/


/*********************************************************************************/
/* 5. uzycie kompresji binarnej spowoduje zmniejszenie rozmiaru pliku bardziej niz uzycie kompresji znakowej*/

data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
	do i=1 to 1E4;
	    hehe1="hehehehehehehehehehehehehehehehehehehehehehehehehehehehehehehehehehehehe";
	    hehe2="hohohohohohohohohohohohohohohohohohohohohohohohohohohohohohohohohohohoho";
	    hehe3=hehe1;
	    hehe4=hehe1;
	    hehe5=hehe1;
		output;
	end;
run;

/*  Compressing data set WORK.set_char increased size by 3.51 percent.
	Compressing data set WORK.set_binary decreased size by 17.54 percent. */
/*********************************************************************************/


/*********************************************************************************/
/* 6. uzycie kompresji znakowej spowoduje zmniejszenie rozmiaru pliku bardziej niz uzycie kompresji binarnej*/

data set_without(COMPRESS=NO) set_char(COMPRESS=CHAR) set_binary(COMPRESS=BINARY);
do i=1 to 1E4;
array hehe[20] $ 50;
    do j=1 to dim(hehe); 
        hehe[j] = "";
        do k = 1 to floor(50*ranuni(1)); 
            hehe[j] = cats(hehe[j],byte(65+floor(26*ranuni(17))));
        end;
    end;
output;
end;
run;

/*   Compressing data set WORK.SET_CHAR decreased size by 44.65 percent.
	 Compressing data set WORK.SET_BINARY decreased size by 38.99 percent. */
/*********************************************************************************/

proc sql noprint;
	drop table set_without, set_char, set_binary;
quit;

