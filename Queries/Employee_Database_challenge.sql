-- DELIVERABLE 1

-- Creating retirement_titles table
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
	FROM employees AS e
	INNER JOIN titles AS ti on (e.emp_no = ti.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	ORDER BY (e.emp_no);

-- Removing duplicate employees to get most recent positions
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
	FROM retirement_titles
	ORDER BY emp_no, to_date DESC;
	
-- Create count of number of employees retiring grouped by title
SELECT count(*) AS emp_retiring, title
INTO retiring_titles
	FROM unique_titles
	GROUP BY title
	ORDER BY emp_retiring DESC;

-- DELIVERABLE 2

-- Creating mentorship eligibility table
SELECT DISTINCT ON (e.emp_no)
	e.emp_no, e.first_name, e.last_name, e.birth_date, 
	de.from_date, de.to_date, ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti ON (e.emp_no = ti.emp_no)
WHERE 
	(ti.to_date = '9999-01-01') AND
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;