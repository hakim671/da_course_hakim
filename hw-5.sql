select phone 
from customer
where phone not like '%(%' and phone not like'%)%';


select 
	concat(upper(left('lorem ipsum',1)), right('lorem ipsum',10));
	
select name
from track
where name ilike '%run%';

select *
from invoice;

select 
    extract(month from invoice_date) as month_id,
    sum(total) as sales_sum
from 
    invoice
where 
    invoice_date >= '2021-01-01' and invoice_date < '2022-01-01'
group by 
    month_id
order by 
    month_id;

   
   
select 
    extract(month from invoice_date) as month_id
    , sum(total) as sales_sum
    , to_char(invoice_date, 'month') AS month_name
from 
    invoice
where 
    invoice_date >= '2021-01-01' and invoice_date < '2022-01-01'
group by 
    month_id, month_name
order by 
    month_id;

   
select 
	concat(first_name, ' ', last_name) as full_name
	, birth_date
	, extract(year from age(hire_date, birth_date)) AS age_now
from employee
order by age_now desc
limit 3;


select 
	extract(year from (avg(age(birth_date - interval '3 year 4 month'))))
from employee;

