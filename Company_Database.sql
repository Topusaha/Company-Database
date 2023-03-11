CREATE TABLE employee (
    emp_id INT PRIMARY KEY, 
    first_name VARCHAR(40) NOT NULL, 
    last_name VARCHAR(40) NOT NULL, 
    birth_day DATETIME NOT NULL, 
    sex VARCHAR(1), 
    salary INT NOT NULL,
    super_id INT,
    branch_id INT
); 

CREATE TABLE branch (
    branch_id INT PRIMARY KEY, 
    branch_name VARCHAR(40) NOT NULL, 
    mgr_id INT, 
    mgr_start_date DATETIME NOT NULL, 
    FOREIGN KEY (mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee 
ADD FOREIGN KEY (branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee 
ADD FOREIGN KEY (super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
    client_id INT PRIMARY KEY, 
    client_name VARCHAR(20), 
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
); 

CREATE TABLE works_with (
    emp_id INT, 
    client_id INT,
    total_sales INT NOT NULL,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE  
); 

CREATE TABLE branch_supplier (
    branch_id INT, 
    supplier_name VARCHAR(35),
    supply_type VARCHAR(35),
    PRIMARY KEY(branch_id, supplier_name), 
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
); 


INSERT INTO employee VALUES(100, 'DAVID', 'WALLACE', '1967-11-17', 'M', 250000, null, null);
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1 
WHERE emp_id = 100;


INSERT INTO employee VALUES(101, "Jan", "Levinson", "1961-05-11", "F", 110000, 100, 1);

INSERT INTO employee VALUES(102, "Michael", "Scott", "1964-03-15", "M", 75000, 100, null); 

INSERT INTO branch VALUES(2, "Scranton", 102, "1992-04-06"); 

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;


INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', "F", 63000, 102, 2); 
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-19', 'F', 55000, 102, 2); 
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-05', 'M', 69000, 102, 2); 


INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, null); 
INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, null); 
INSERT INTO employee VALUES(108, "Jim", "Halpert", "1978-10-01", "M", 71000, 106, null);

INSERT INTO branch VALUES(3, "Stamford", 106, "1998-02-13");

UPDATE employee 
SET branch_id = 3
WHERE emp_id IN (106, 107, 108);

INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);



-- Find All Employees
SELECT * FROM employee;

-- Find All Clients
SELECT * FROM client;

-- Find All Employees ordered by salary 
SELECT * 
FROM employee
ORDER BY salary DESC;

-- Find all employees order by sex and name 
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

-- Find the first 5 employees from the table
SELECT * 
FROM employee
LIMIT 5; 


-- Find the first and last name of all employees 
SELECT first_name, last_name
FROM employee;


-- Find the forename and surnames of all employees
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- Find out all the different genders
SELECT DISTINCT sex 
FROM employee;

-- Find out all the different branch ids
SELECT DISTINCT branch_id 
FROM employee;


-- Find the numbers of employees
SELECT COUNT(emp_id) FROM employee; 

-- Find the number of supervisors 
SELECT COUNT(super_id) FROM employee; 

-- Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1970-01-01';

-- Find the average of all employee salary
SELECT AVG(salary) FROM employee; 

-- Find the average salary of all male employees 
SELECT AVG(salary) 
FROM employee
WHERE sex = 'M';


-- Find the average salary of all female employees
SELECT AVG(salary)
FROM employee
WHERE sex = 'F';

-- Find the sum of all the employee salary
SELECT SUM(salary)
FROM employee; 

-- Find out how many males and how many females they're 
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesment 
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id; 

-- Find the amount each client has spent with the company
SELECT SUM(total_sales), client_id 
FROM works_with
GROUP BY client_id; 


-- Wildcards % = any # of characters, _ = one character

-- Find any client who are an LLC 
SELECT *
FROM client 
WHERE client_name LIKE '%LLC';

-- Find any branch suppliers who are in the label buissness
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%labels';


-- Update branch suppliers to fix typo 
UPDATE branch_supplier
SET supplier_name = 'Stamford Labels'
WHERE  supplier_name = 'Stamford Lables';


-- Find any employee who was born in October
SELECT *
FROM employee
WHERE birth_day LIKE '____-10%';

-- Find any client who are schools 
SELECT *
FROM client
WHERE client_name LIKE "%School%";

-- Unions 

-- Find a list of employee and branch names
SELECT first_name AS 'Company Names' FROM employee
UNION 
SELECT branch_name FROM branch
UNION
SELECT client_name FROM client; 

-- Find a list of all clients and Branch suppliers names
SELECT client_name AS "client and branch names", client.branch_id FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id FROM branch_supplier; 


-- Find a list of all money spent or warned by the company 
SELECT salary AS 'Money' FROM employee
UNION
SELECT total_sales FROM works_with;

-- Joins
INSERT INTO branch VALUES(4, "Buffalo", NULL, "2022-01-01"); 

SELECT * FROM branch; 

-- Find all Branches and the names of their managers
SELECT employee.emp_id, employee.first_name, employee.branch_id
FROM employee
JOIN branch --General Join = Inner Join
ON employee.emp_id = branch.mgr_id; 

-- Types of Join 
-- Inner Join - Similiar in Both Tables
-- Right Join - returns right matches with left
-- Left Join - Returns left matches with right
-- Outter join - returns everything 

-- Nested Qurries 
-- Find names of all employees who have 
-- sold over 30,000 to a single client 
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);


-- Find all clients who are handled by the branch
-- that Micheal Scott Manages
-- Assume you know Michael's ID 102

SELECT client.client_name 
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch 
    WHERE branch.mgr_id = 102
    LIMIT 1
);

-- ON DELETE
-- ON DELETE set null = when deleted set it to null 
-- ON DELETE set cascade = when delete delete row
-- See what happens when a set null is deleted from a table
DELETE FROM employee
WHERE emp_id = 102; 

SELECT * FROM branch;
