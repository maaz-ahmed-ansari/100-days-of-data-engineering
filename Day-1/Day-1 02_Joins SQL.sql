-- JOINS

SELECT	* 
FROM	employeedemographics;

SELECT	* 
FROM	employeesalary;

SELECT	*
FROM	employeedemographics ed
INNER JOIN employeesalary es
	ON	ed.employeeid = es.employeeid;
	
	
SELECT	*	
FROM	employeedemographics ed
FULL OUTER JOIN employeesalary es
	ON	ed.employeeid = es.employeeid;
	

SELECT	*	
FROM	employeedemographics ed
LEFT OUTER JOIN employeesalary es
	ON	ed.employeeid = es.employeeid;


SELECT	*	
FROM	employeedemographics ed
RIGHT OUTER JOIN employeesalary es
	ON	ed.employeeid = es.employeeid;
	

SELECT	ed.employeeid,
		firstname,
		lastname,
		jobtitle,
		salary
FROM	employeedemographics ed
LEFT JOIN employeesalary es
	ON	ed.employeeid = es.employeeid;
	

-- Get hight salary for employee except Michael
SELECT	ed.employeeid,
		firstname,
		lastname,
		salary
FROM	employeedemographics ed
INNER JOIN employeesalary es
	ON	ed.employeeid = es.employeeid
WHERE	firstname != 'Michael'
ORDER BY salary DESC;

-- Get averae salary for Salesman
SELECT	jobtitle,
		AVG(salary)
FROM	employeedemographics ed
INNER JOIN employeesalary es
	ON	ed.employeeid = es.employeeid
WHERE	jobtitle = 'Salesman'
GROUP BY jobtitle;
	
	