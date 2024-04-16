SELECT	* 
FROM	employeedemographics;

SELECT	* 
FROM	employeesalary;

-- CASE statement to specify condition and certain action when the condition is met

SELECT	firstname, 
		lastname, 
		age,
		CASE
			WHEN age > 30 THEN 'Old'
			WHEN age BETWEEN 27 AND 30 THEN 'Young'
			ELSE 'Baby'
		END
FROM	employeedemographics
WHERE	age is NOT NULL
ORDER BY age;

-- The very first condition which is met is retuened and rest of condtions are ignored
-- e.g.

SELECT	firstname, 
		lastname, 
		age,
		CASE
			WHEN age > 30 THEN 'Old'
			WHEN age = 38 THEN 'Stanley'
			WHEN age BETWEEN 27 AND 30 THEN 'Young'
			ELSE 'Baby'
		END
FROM	employeedemographics
WHERE	age is NOT NULL
ORDER BY age;

-- Get additional column with salary raise of 10% for salesman, 5% for accountant, 1% for HR and 3% for the rest

SELECT	firstname,
		lastname,
		jobtitle,
		salary,
		CASE
			WHEN jobtitle = 'Salesman' THEN salary + (salary * .10)
			WHEN jobtitle = 'Accountant' THEN salary + (salary * .05)
			WHEN jobtitle = 'HR' THEN salary + (salary * .01)
			ELSE salary + (salary * .03)
		END AS salary_after_raise
FROM	employeedemographics ed
JOIN	employeesalary es
	ON	ed.employeeid = es.employeeid;
