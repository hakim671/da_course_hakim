select 
	employee_id 
	, concat(first_name, ' ', last_name)
	, title
	, reports_to 
	, (select concat(e2.first_name, ' ', e2.last_name, ',', e2.title) 
     from employee e2 
     where e2.employee_id = e1.reports_to) as manager_full_name
from employee e1;


select 
	invoice_id 
	, invoice_date 
	, to_char(invoice_date, 'yyyymm') 
	, customer_id
	, total 
from invoice
where 
	total >= (select avg(total) from invoice) and invoice_date < to_timestamp('2024-01-01','yyyy-mm-dd') and invoice_date >= to_timestamp('2023-01-01','yyyy-mm-dd');
	

select 
	invoice_id 
	, invoice_date 
	, to_char(invoice_date, 'yyyymm') 
	, customer_id
	, total 
	, (select email from customer where customer.customer_id = invoice.customer_id)
from invoice
where 
	total >= (select avg(total) from invoice) and invoice_date < to_timestamp('2024-01-01','yyyy-mm-dd') and invoice_date >= to_timestamp('2023-01-01','yyyy-mm-dd');
	

select 
	invoice_id 
	, invoice_date 
	, to_char(invoice_date, 'yyyymm') 
	, customer_id
	, total 
	, (select email from customer where customer.customer_id = invoice.customer_id) as domen
from invoice
where 
	total >= (select avg(total) from invoice) and invoice_date < to_timestamp('2024-01-01','yyyy-mm-dd') and invoice_date >= to_timestamp('2023-01-01','yyyy-mm-dd') and (select email from customer where customer.customer_id = invoice.customer_id) not ilike '%gmail%';
	

select 
	i1.total / (select sum(total) from invoice) * 100 as Процент
from invoice i1;



select 
	customer_id 
	, sum(i1.total)/(select sum(total) from invoice) * 100 as Процент
from invoice i1
group by
	customer_id
order by customer_id;
