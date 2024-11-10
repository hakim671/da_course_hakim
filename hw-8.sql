select 
    e.employee_id as employee_id
    , concat(e.first_name, ' ', e.last_name) as full_name
    , count(c.customer_id) as customer_count
from 
    employee e
join 
    customer c on e.employee_id = c.support_rep_id
group by 
    e.employee_id, e.first_name, e.last_name
;

   

select 
    e.employee_id as employee_id
    , concat(e.first_name, ' ', e.last_name) as full_name
    , count(c.customer_id) as customer_count
    , count(c.customer_id) * 100 / (select count(*) from customer) as Процент
from 
    employee e
join 
    customer c on e.employee_id = c.support_rep_id
group by 
    e.employee_id, e.first_name, e.last_name
;



select title
from album a
left join
	track t on t.album_id = a.album_id 
left join 
	invoice_line il on t.track_id = il.track_id 
where 
	il.track_id is null
group by a.title
;



select 
	c.customer_id
	, concat(c.first_name, ' ', c.last_name) as full_name
	, to_char(i.invoice_date,'yyyymm')::int as monthkey
	, sum(i.total) as total
from customer c 
join invoice i on c.customer_id = i.customer_id
group by 
    c.customer_id, full_name, monthkey
order by
	c.customer_id,monthkey;


select 
	c.customer_id
	, concat(c.first_name, ' ', c.last_name) as full_name
	, to_char(i.invoice_date,'yyyymm')::int as monthkey
	, sum(i.total) as total_in_month
	, sum(i.total) * 100 / sum(sum(i.total)) over (partition by (to_char(i.invoice_date,'yyyymm')::int)) as Процент
from customer c 
join invoice i on c.customer_id = i.customer_id
group by 
    c.customer_id, full_name, monthkey
order by
	c.customer_id,monthkey;
	


select 
	c.customer_id
	, concat(c.first_name, ' ', c.last_name) as full_name
	, to_char(i.invoice_date,'yyyymm')::int as monthkey
	, sum(i.total) as total_in_month
	, sum(i.total) * 100 / sum(sum(i.total)) over (partition by (to_char(i.invoice_date,'yyyymm')::int)) as Процент
	, sum(sum(i.total)) over (partition by c.customer_id, (extract(year from i.invoice_date)) order by to_char(i.invoice_date, 'yyyymm')::int) as Running_total
from customer c 
join invoice i on c.customer_id = i.customer_id
group by 
    c.customer_id, full_name, monthkey, extract(year from i.invoice_date)
order by
	c.customer_id,monthkey;
	

select 
	c.customer_id
	, concat(c.first_name, ' ', c.last_name) as full_name
	, to_char(i.invoice_date,'yyyymm')::int as monthkey
	, sum(i.total) as total_in_month
	, sum(i.total) * 100 / sum(sum(i.total)) over (partition by (to_char(i.invoice_date,'yyyymm')::int)) as Процент
	, sum(sum(i.total)) over (partition by c.customer_id, (extract(year from i.invoice_date)) order by to_char(i.invoice_date, 'yyyymm')::int) as Running_total
	, avg(sum(i.total)) over (partition by c.customer_id order by to_char(i.invoice_date, 'yyyymm')::int rows between 2 preceding and current row)
	, sum(i.total) - lag(sum(i.total)) over(partition by c.customer_id order by to_char(i.invoice_date, 'yyyymm')::int) as now_lag
from customer c 
join invoice i on c.customer_id = i.customer_id
group by 
    c.customer_id, full_name, monthkey, extract(year from i.invoice_date)
order by
	c.customer_id,monthkey;
	

select *
from employee e
left join employee e2 on e.employee_id = e2.reports_to 
where e2.employee_id is null;


select 
	c.customer_id 
	, concat(c.first_name, ' ', c.last_name) as full_name
	, min(i.invoice_date) over(partition by c.customer_id) as min_i
	, max(i.invoice_date) over(partition by c.customer_id) as max_i
	, extract(year from (max(i.invoice_date) over(partition by c.customer_id))) - extract(year from (min(i.invoice_date) over(partition by c.customer_id))) as diff_in_year
from customer c 
left join invoice i on i.customer_id = c.customer_id
group by i.invoice_date, c.customer_id;



select year, title, name, cnt
from (
    select
        extract(year from i.invoice_date) as year,
        a.title as title,
        a2.name as name,
        count(*) as cnt
    from track t 
    left join invoice_line il on t.track_id = il.track_id
    left join invoice i on il.invoice_id = i.invoice_id
    left join album a on t.album_id = a.album_id
    left join artist a2 on a.artist_id = a2.artist_id
    group by extract(year from i.invoice_date), a.album_id, a.title, a2.name
) as ranked_albums
order by cnt desc
limit 3;



select
	t.track_id
	, t.name
from track t 
left join invoice_line il on t.track_id = il.track_id
left join invoice i on il.invoice_id = i.invoice_id
left join invoice_line il2 on t.track_id = il2.track_id
left join invoice i2 on il2.invoice_id = i2.invoice_id
where (i.billing_country = 'USA' and i2.billing_country = 'Canada') or (i2.billing_country = 'USA' and i.billing_country = 'Canada');




select
	t.track_id
	, t.name
from track t 
left join invoice_line il on t.track_id = il.track_id
left join invoice i on il.invoice_id = i.invoice_id
left join invoice_line il2 on t.track_id = il2.track_id
left join invoice i2 on il2.invoice_id = i2.invoice_id
where (i.billing_country = 'Canada' and i2.billing_country != 'USA')