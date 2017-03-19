/*kod pozwalajacy na uzupelnienie lacznej kwoty nowej transakcji*/
%macro setTransactionAmount(transaction_id);
	proc sql noprint;
		select sum(td.quantity*tt.price) into: amount
		from ZOO.transactions t
		join ZOO.transaction_details td on t.transaction_id=td.transaction_id
		join ZOO.TICKET_TYPES tt on tt.ticket_type_id=td.ticket_type_id
		where t.date>=tt.valid_from and tt.valid_to=. and t.transaction_id=&transaction_id.
		group by t.transaction_id;

		update ZOO.transactions set amount=&amount where transaction_id=&transaction_id.;
	quit;

%mend;

*%setTransactionAmount(135357);
/*********************/
