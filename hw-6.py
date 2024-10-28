create table students(
	student_id serial primary key 
	, student_name varchar(30) not null
	, username varchar(20)
	, bio varchar(50)
	, mobile varchar(15)
	, has_picture varchar(5) not null default 'no'
)

insert into students(student_name, username, mobile, has_picture)
values
	('hakim boyzoda', '@hakim25753', '502055054', 'no');
insert into students(student_name, username, bio, has_picture)
values
	('Murtazoev_Alijon', '@M_Alijon', 'I am Batman','yes');
insert into students(student_name, username, mobile, has_picture)
values
	('ibodulo', '@ZAR1509' , '987925005', 'yes');
insert into students(student_name, username, mobile, has_picture)
values
	('Behzod', '@behzod_31', '559009474', 'yes');
insert into students(student_name, username, bio, has_picture)
values
	('Sadriddin Khojazoda', '@khojazodas', '.', 'yes');
insert into students(student_name, has_picture)
values
	('Aziz Abdullaev', 'yes');
insert into students(student_name, username, has_picture)
values
	('Munira' , '@krb_munira', 'yes');

select *
from students;


create table lessons(
	lessons_id serial primary key 
	, lesson_name varchar(40) not null
	, lesson_date timestamp 
	, attendance varchar(5) not null default 'yes'
)

insert into lessons(lesson_name,lesson_date)
values 
	('SQL_Знакомство', '2024-10-18')
	, ('Фильтрация и агрегация', '2024-10-18')
	, ('Текст и дата', '2024-10-21')
	, ('Создание и редактирование', '2024-10-23')
	, ('Подзапросы', '2024-10-25')
;
select *
from lessons;

create table scores(
	score_id serial primary key
	, user_id integer not null default 1
	, lesson_id integer not null
	, score integer 
	, foreign key (user_id) references students(student_id)
	, foreign key (lesson_id) references lessons(lessons_id)
);

insert into scores(lesson_id,score)
values
	(1,90)
;

insert into scores(lesson_id,score)
values
	(2,57);
	

insert into scores(lesson_id)
values
	(3)
	,(4)
	,(5)
;

select *
from scores;

create index username_indx on students(username);

create view my_results as
select 
 students.student_id
 , students.student_name
 , students.username
 , students.mobile,
 (select count(*) from lessons where attendance = 'yes' and student_id = students.student_id) as total_attendance
 , (select avg(score) from scores where student_id = students.student_id) as average_score
from students ;
