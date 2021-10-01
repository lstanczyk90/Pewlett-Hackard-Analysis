-- Employees eligible for retirement, and creating a new table from this list
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
	WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(last_name)
FROM employees
	WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	
-- Joining departments and dept_manager tables
SELECT d.dept_name, 
	dm.emp_no, 
	dm.from_date,
	dm.to_date
FROM departments d
INNER JOIN dept_manager dm ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no, 
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info ri
LEFT JOIN dept_emp de ON de.emp_no = ri.emp_no;
	
-- Same join as before, but creating new table to house data
-- only for employees that are still at the company
SELECT ri.emp_no, 
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de ON de.emp_no = ri.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
-- We are also exporting this table into a new table
SELECT count(ce.emp_no), de.dept_no
INTO retirement_dept
FROM current_emp AS ce
LEFT JOIN dept_emp AS de ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee Information: 
-- A list of employees containing their unique employee number, their last name, first name, gender, and salary
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN 
	salaries AS s ON (e.emp_no = s.emp_no)
INNER JOIN 
	dept_emp AS de ON (e.emp_no = de.emp_no)
WHERE 
	(e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

-- Management: 
-- A list of managers for each department, including 
-- the department number, name, and the manager's employee number, last name, first name, and the starting and ending employment dates
SELECT d.dept_no,
	d.dept_name, 
	dm.emp_no,
	e.last_name,
	e.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM departments AS d
INNER JOIN 
	dept_manager AS dm ON (d.dept_no = dm.dept_no)
INNER JOIN 
	employees AS e ON (e.emp_no = dm.emp_no)
WHERE 
	(e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Department Retirees: 
-- An updated current_emp list that includes everything it currently has, but also the employee's departments
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
FROM current_emp AS ce
INNER JOIN 
	dept_emp AS de ON (de.emp_no = ce.emp_no)
INNER JOIN
	departments AS d ON (d.dept_no = de.dept_no);
	
-- Retirement info list, but specific to sales
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON
	(de.emp_no = e.emp_no)
INNER JOIN departments as d ON
	(d.dept_no = de.dept_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31') AND
	(dept_name = 'Sales');
	
-- Retirement info list, but specific to sales and marketing
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON
	(de.emp_no = e.emp_no)
INNER JOIN departments as d ON
	(d.dept_no = de.dept_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31') AND
	dept_name IN ('Sales', 'Development');
	