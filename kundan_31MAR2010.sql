/*
Description : Datafix for amount_remaining in payment schedules and
amount_paid in ap_invoices_all.
Script Name : incorrect_pay_schedules_sel.sql
Author : Gkarampu
Date : 15-Oct-2008
*/


DROP TABLE ap_improper_pay_sched;


CREATE TABLE ap_improper_pay_sched AS
SELECT invoice_num,
vendor_id,
invoice_amount,
amount_paid,
ai.invoice_id,
COUNT(payment_num) AS numpaym,
SUM(amount_remaining) AS topay
FROM ap_invoices_all ai,
ap_payment_schedules_all aps
WHERE ai.invoice_id = aps.invoice_id
AND cancelled_date is null
GROUP BY invoice_num,
vendor_id,
invoice_amount,
amount_paid,
ai.invoice_id
HAVING SUM(aps.amount_remaining) <> ai.invoice_amount -ai.amount_paid;


/*
Description : Datafix for amount_remaining in payment schedules and
amount_paid in ap_invoices_all.
Script Name : incorrect_pay_schedules_fix.sql
Author : Gkarampu
Date : 15-Oct-2008
*/

set serveroutput on
declare
l_inv_rec ap_invoices_all%rowtype;
l_amt_paid number;
l_awt_amt number;
l_prepay_amt number;
l_amt_old number;
l_amt_remn number;
l_pay_curr_amt number;
l_awt_calc_level varchar2(100);
l_base_ccy varchar2(100);
l_base_amt number := 0;
l_upd boolean := false;
begin

for l_inv_rec in (select ai.*
from ap_invoices_all ai,
ap_improper_pay_sched c
where c.invoice_id = ai.invoice_id ) loop
--setting org context
mo_global.set_policy_context('S',l_inv_rec.org_id);


select sum(amount_remaining), sum(gross_amount)
into l_amt_remn, l_amt_old
from ap_payment_schedules_all
where invoice_id = l_inv_rec.invoice_id;

 
select sum(amount + nvl(discount_taken,0))
into l_amt_paid
from ap_invoice_payments_all
where invoice_id = l_inv_rec.invoice_id;
 

l_amt_paid := nvl(l_amt_paid, 0);

select AP_UTILITIES_PKG.ap_round_currency(sum(amount) *
l_inv_rec.payment_cross_rate, l_inv_rec.payment_currency_code)
into l_prepay_amt
from ap_invoice_distributions
where prepay_distribution_id is not null
and invoice_id = l_inv_rec.invoice_id;


select AP_UTILITIES_PKG.ap_round_currency(sum(amount) *
l_inv_rec.payment_cross_rate, l_inv_rec.payment_currency_code)
into l_awt_amt
from ap_invoice_distributions
where line_type_lookup_code = 'AWT'
and invoice_id = l_inv_rec.invoice_id;


l_amt_paid := l_amt_paid - nvl(l_prepay_amt, 0) - nvl(l_awt_amt, 0);

-- updated amount_paid

update ap_invoices_all
set amount_paid = l_amt_paid + nvl(l_awt_amt, 0)
where invoice_id = l_inv_rec.invoice_id;

for l_ps_rec in (select gross_amount, rowid
from ap_payment_schedules_all
where invoice_id = l_inv_rec.invoice_id
order by due_date asc) loop

l_amt_old := AP_UTILITIES_PKG.ap_round_currency(
l_ps_rec.gross_amount, l_inv_rec.payment_currency_code);

 
l_amt_remn := l_amt_old;

if abs(l_amt_remn) < abs(l_amt_paid) then -- bug 3134430
l_amt_paid := l_amt_paid - l_amt_remn;
l_amt_remn := 0;
else
l_amt_remn := l_amt_remn - l_amt_paid;
l_amt_paid := 0;
end if;

 

update ap_payment_schedules_all
set amount_remaining = l_amt_remn,
payment_status_flag = decode(l_amt_remn, 0, 'Y',l_amt_old, 'N', 'P')
where rowid = l_ps_rec.rowid;

end loop; --l_ps_rec

-- first make it partially paid

update ap_invoices_all
set payment_status_flag = 'P'
where invoice_id = l_inv_rec.invoice_id;

-- unpaid invoices

update ap_invoices_all
set payment_status_flag = 'N'
where invoice_id = l_inv_rec.invoice_id
and not exists (select '1'
from ap_payment_schedules_all
where invoice_id = l_inv_rec.invoice_id
and payment_status_flag in ('Y', 'P'));

 

-- Fully paid invoices

update ap_invoices_all
set payment_status_flag = 'Y'
where invoice_id = l_inv_rec.invoice_id
and not exists (select '2'
from ap_payment_schedules_all
where invoice_id = l_inv_rec.invoice_id
and payment_status_flag in ('N', 'P'));

commit;

end loop; --l_inv_rec
Dbms_output.put_line('DataFix Completed!!!');
Exception When Others Then
Dbms_output.put_line('Error Occurred :'||sqlerrm);
ROLLBACK;
end;
/

