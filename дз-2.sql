/*
 * Бойзода Хаким
 * Д/з 4
*/

select 
	name
	, genre_id
from track;


select 
	name as song
	, unit_price as price
	, composer as author
from track;


select 
	name
	, milliseconds/60000. as minute
from track 
order by 
	minute desc;
	



select 
	name
	, genre_id
from track
limit 15;



select *
from track
offset 49;



select 
	name
from track
where bytes > 104857600;



select
	name
	, composer
from track
where composer != 'U2'
offset 9
limit 10;


select 
	min(invoice_date) as first
	, max(invoice_date) as last
from invoice;


select 
	avg(total)
from invoice
where billing_country = 'USA';

select billing_city
from invoice
group by billing_city
HAVING COUNT(*) > 1;

