CREATE TABLE employees
(
	id int,
	name varchar(256),
	manager_id int
);

INSERT INTO employees VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Chuck', 1),
(4, 'Drake', 2),
(5, 'Eve', 2);

SELECT * FROM employees;

-- SELF JOINs
-- Self-joins are not really a new kind of JOIN. They are just a JOIN from a table to itself.

-- In this case, if we wanted to know who the manager is for each employee, all the information we need is already in the employees table.

-- Consider the following employees table:

-- id	name	manager_id
-- 1	Alice	NULL
-- 2	Bob	1
-- 3	Chuck	1
-- 4	Drake	2
-- 5	Eve	2
-- This company’s structure is:

-- Alice
	-- Bob
		-- Drake
		-- Eve
	-- Chuck

-- In this case, if we wanted to know who the manager is for each employee, all the information we need is already in the employees table.

-- To show this information, we can join the employees table to itself:

SELECT	e.name as employee,
		m.name as manager
FROM	employees as e LEFT JOIN
		employees as m
			ON e.manager_id = m.id;
			
-- Output
-- "Alice"	
-- "Bob"	"Alice"
-- "Chuck"	"Alice"
-- "Drake"	"Bob"
-- "Eve"	"Bob"
			
-- Note that we used a LEFT JOIN, since the CEO, Alice, has no manager.

-- Also note that we use different aliases for the “left” employees table (e) and the “right” employees table (m), so that SQL is not confused as to which “version” of the table we are referring to.


-- CROSS JOIN
-- CROSS JOIN is a clause that returns all row combinations within two tables.

-- For example, if we have the tables cars and colors:

-- cars

-- model
-- Ford
-- Chevrolet
-- Toyota
-- colors

-- color
-- Red
-- Blue
-- Black
-- Then the CROSS JOIN will return all of their combinations:

-- model	color
-- Ford	Red
-- Ford	Blue
-- Ford	Black
-- Chevrolet	Red
-- Chevrolet	Blue
-- Chevrolet	Black
-- Toyota	Red
-- Toyota	Blue
-- Toyota	Black
-- CROSS JOINS tend to generate very large tables, so they are usually costly. However, they virtually allow us to iterate over two tables directly with SQL.

-- In general, we should try to avoid them, but it’s good to know they exist in case we need them.

CREATE TABLE cars 
(
	model varchar(256)
);

INSERT INTO cars VALUES
('Ford'),
('Chevrolet'),
('Toyota');

CREATE TABLE colors
(
	color varchar(256)
);

INSERT INTO colors VALUES
('Red'),
('Blue'),
('Black');


SELECT	* FROM cars;

SELECT	* FROM colors;

SELECT	*
FROM	cars CROSS JOIN colors;