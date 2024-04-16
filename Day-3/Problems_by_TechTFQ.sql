-- Query 1:

-- Write a SQL query to fetch all the duplicate records from a table.
-- Note: Record is considered duplicate if a user name is present more than once.

create table if exists users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users;

-- My approach:
with partitioned as 
(
select	*,
		row_number() over (partition by user_name order by user_id) as rn
from	users)

select	user_id,
		user_name,
		email
from	partitioned
where	rn > 1;

-- Output:
-- "user_id"	"user_name"	"email"
-- 5	"Robin"	"robin@gmail.com"

-- Query 2:

-- Write a SQL query to fetch the second last record from a employee table.

--Tables Structure:

drop table if exists employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

-- Solution
select	emp_id,
		emp_name,
		dept_name,
		salary
from	(select	*,
				row_number() over (order by emp_id DESC) as rn
		from	employee) as x
where	x.rn = 2;

-- Output:
-- "emp_id"	"emp_name"	"dept_name"	"salary"
-- 123	"Vikram"	"IT"	8000


-- Query 3:

-- Write a SQL query to display only the details of employees who either earn the highest salary
-- or the lowest salary in each department from the employee table.

select * from employee;

-- My Solution:

select	emp_id,
		emp_name,
		dept_name,
		salary
from	(select	*,
				dense_rank() over (partition by dept_name order by salary DESC) as rn_max,
				dense_rank() over (partition by dept_name order by salary ASC) as rn_min
		from	employee) as y
where	y.rn_max = 1 or y.rn_min = 1;

-- Toufiq's solution:

select x.*
from employee e
join (select *,
max(salary) over (partition by dept_name) as max_salary,
min(salary) over (partition by dept_name) as min_salary
from employee) x
on e.emp_id = x.emp_id
and (e.salary = x.max_salary or e.salary = x.min_salary)
order by x.dept_name, x.salary;


-- Query 4:

-- From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.

--Table Structure:

drop table if exists doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

-- Solution:
-- Approach: Use self join to solve this problem. Self join is when you join a table to itself.

select	d1.name,
		d1.speciality,
		d1.hospital
from	doctors as d1
join	doctors as d2
		on	d1.id != d2.id 
			and d1.hospital = d2.hospital 
			and d1.speciality != d2.speciality


-- Query 5:

-- From the login_details table, fetch the users who logged in consecutively 3 or more times.

--Table Structure:

drop table if exists login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;

-- Solution:

-- Approach: We need to fetch users who have appeared 3 or more times consecutively in login details table. 
-- There is a window function which can be used to fetch data from the following record. 
-- Use that window function to compare the user name in current row with user name in the next row and in the row following the next row. 
-- If it matches then fetch those records

with filtered_login_details as
(
	select	*,
			case when user_name = lead(user_name) over (order by login_id)
					and  user_name = lead(user_name, 2) over (order by login_id)
				 then user_name
				 else null
			end as repeated_user
	from	login_details
)
select	distinct repeated_user
from	filtered_login_details
where	repeated_user is not null;

-- Output 

-- "user_name"
-- "Stewart"
-- "James"


-- Query 6:

-- From the students table, write a SQL query to interchange the adjacent student names.

-- Note: If there are no adjacent student then the student name should stay the same.

--Table Structure:

drop table if exists students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

-- Solution:

-- Approach: 
-- If id is an odd number then fetch the student name from the following record. 
-- If id is an even number then fetch the student name from the preceding record. 
-- Try to figure out the window function which can be used to fetch the preceding the following record data. 

-- If the last record is an odd number then it wont have any adjacent even number hence figure out a way to not interchange the last record data.

-- Solution 1
-- Assuming id will be a sequential number always
select	*,
		coalesce
		(
			case when id%2=1 
				 then
					lead(student_name) over (order by id)
				 else
					lag(student_name) over (order by id)
			end,
			student_name
		)as new_student_name
from	students
order by id

-- Solution 2
-- More General, without assuming id will be a sequential number always
with next_prev_student as 
(
	select	*,
			lead(student_name) over (order by id) as next_student,
			lag(student_name) over (order by id) as prev_student,
			row_number() over (order by id) as rn
	from	students
)
select	id,
		student_name,
		coalesce 
		(
			case when rn % 2 = 1 then next_student
			 	 else prev_student
			end,
			student_name
		)as new_student_name
from	next_prev_student;

-- Output

-- "id"	"student_name"	"new_student_name"
-- 1	"James"	"Michael"
-- 2	"Michael"	"James"
-- 3	"George"	"Stewart"
-- 4	"Stewart"	"George"
-- 5	"Robin"	"Robin"


-- Query 7:

-- From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

-- Note: Weather is considered to be extremely cold then its temperature is less than zero.

--Table Structure:

drop table if exists weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd')),
(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd')),
(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd')),
(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd')),
(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd')),
(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd')),
(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd')),
(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd'));

select * from weather;

-- "id"	"city"	"temperature"	"day"
-- 1	"London"	-1	"2021-01-01"
-- 2	"London"	-2	"2021-01-02"
-- 3	"London"	4	"2021-01-03"
-- 4	"London"	1	"2021-01-04"
-- 5	"London"	-2	"2021-01-05"
-- 6	"London"	-5	"2021-01-06"
-- 7	"London"	-7	"2021-01-07"
-- 8	"London"	5	"2021-01-08"

-- Solution

-- Approach: First using a sub query identify all the records where the temperature was very cold and 
-- then use a main query to fetch only the records returned as very cold from the sub query. 
-- You will not only need to compare the records following the current row but also need to compare the records preceding the current row. 
-- And may also need to compare rows preceding and following the current row. 
-- Identify a window function which can do this comparison pretty easily.

with london_weather as
(
	select	*
	from	weather
	where	city = 'London'
),

filtered_weather as
(
	select	*,
			case when temperature < 0
					and  lead(temperature) over (order by id) < 0
					and  lead(temperature, 2) over (order by id) < 0
				 then 'Yes'
				 when temperature < 0
					and  lag(temperature) over (order by id) < 0
					and  lead(temperature) over (order by id) < 0
				 then 'Yes'
				 when temperature < 0
					and  lag(temperature) over (order by id) < 0
					and  lag(temperature, 2) over (order by id) < 0
				 then 'Yes'
				 else null
			end as cons_cold_flag
	from	london_weather
)
select	id,
		city,
		temperature,
		day
from	filtered_weather
where	cons_cold_flag = 'Yes';

-- Output 

-- "id"	"city"	"temperature"	"day"
-- 5	"London"	-2	"2021-01-05"
-- 6	"London"	-5	"2021-01-06"
-- 7	"London"	-7	"2021-01-07"



-- Query 8:

-- From the following 3 tables (event_category, physician_speciality, patient_treatment),
-- write a SQL query to get the histogram of specialities of the unique physicians
-- who have done the procedures but never did prescribe anything.

--Table Structure:

drop table if exists event_category;
create table event_category
(
  event_name varchar(50),
  category varchar(100)
);

drop table if exists physician_speciality;
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

drop table if exists patient_treatment;
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);


insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');


insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');


insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);


select * from patient_treatment;
select * from event_category;
select * from physician_speciality;


-- "patient_id"	"event_name"	"physician_id"
-- 1	"Radiation"	1000
-- 2	"Chemotherapy"	2000
-- 1	"Biopsy"	1000
-- 3	"Immunosuppressants"	2000
-- 4	"BTKI"	3000
-- 5	"Radiation"	4000
-- 4	"Chemotherapy"	2000
-- 1	"Biopsy"	5000
-- 6	"Chemotherapy"	6000

-- "event_name"	"category"
-- "Chemotherapy"	"Procedure"
-- "Radiation"	"Procedure"
-- "Immunosuppressants"	"Prescription"
-- "BTKI"	"Prescription"
-- "Biopsy"	"Test"

-- "physician_id"	"speciality"
-- 1000	"Radiologist"
-- 2000	"Oncologist"
-- 3000	"Hermatologist"
-- 4000	"Oncologist"
-- 5000	"Pathologist"
-- 6000	"Oncologist"


-- Solution:

-- Approach: Using the patient treatment and event category table, 
-- identify all the physicians who have done “Prescription”. Have this recorded in a sub query. 

-- Then in the main query join the patient treatment, event category and physician speciality table 
-- to identify all the physician who have done “Procedure”. From these physicians, remove those physicians you got 
-- from sub query to return the physicians who have done Procedure but never did Prescription.
		
with prescription_only as
(
	select	pt.physician_id
	from	patient_treatment as pt
			join event_category as ec
				on pt.event_name = ec.event_name
	where	ec.category = 'Prescription'
),

procedure_only as
(
	select	ps.physician_id,
			ps.speciality
	from	patient_treatment as pt
			join event_category as ec
				on pt.event_name = ec.event_name
			join physician_speciality as ps
				on pt.physician_id = ps.physician_id
	where	ec.category = 'Procedure'	
)

select	procedure_only.speciality,
		count(procedure_only.speciality) as speciality_count
from	procedure_only
where	procedure_only.physician_id not in (select * from prescription_only)
group	by procedure_only.speciality;

-- Output

-- "speciality"	"speciality_count"
-- "Oncologist"	2
-- "Radiologist"	1



-- Query 9:

-- Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

-- Note: Prefer the account if with the least value in case of same number of unique patients

--Table Structure:

drop table if exists patient_logs;
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, to_date('02-01-2020','dd-mm-yyyy'), 100);
insert into patient_logs values (1, to_date('27-01-2020','dd-mm-yyyy'), 200);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (1, to_date('04-03-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 450);

select * from patient_logs;

-- "account_id"	"date"	"patient_id"
-- 1	"2020-01-02"	100
-- 1	"2020-01-27"	200
-- 2	"2020-01-01"	300
-- 2	"2020-01-21"	400
-- 2	"2020-01-21"	300
-- 2	"2020-01-01"	500
-- 3	"2020-01-20"	400
-- 1	"2020-03-04"	500
-- 3	"2020-01-20"	450

-- Solution:

-- Approach: First convert the date to month format since we need the output specific to each month. 
-- Then group together all data based on each month and account id so you get the total no of patients belonging to each account per month basis. 

-- Then rank this data as per no of patients in descending order and account id in ascending order so in case there are same no of patients present under multiple account if then the ranking will prefer the account if with lower value. Finally, choose upto 2 records only per month to arrive at the final output.

with cleaned_patient_logs as
(
	select	distinct to_char(date, 'month') as month,
			account_id,
			patient_id
	from	patient_logs
),
grouped_cleaned_patient_logs as
(
	select	month,
			account_id,
			count(1) as no_of_patient
	from	cleaned_patient_logs as cpl
	group	by month, account_id
),
ranked_grouped_cleaned_patient_logs as
(
	select	*,
			rank() over (partition by month order by no_of_patient DESC, account_id) as rnk
	from	grouped_cleaned_patient_logs
)

select	month,
		account_id,
		no_of_patient as no_of_unique_patients
from	ranked_grouped_cleaned_patient_logs
where	rnk <= 2;

-- Output

-- "month"	"account_id"	"no_of_unique_patients"
-- "january  "	2	3
-- "january  "	1	2
-- "march    "	1	1



