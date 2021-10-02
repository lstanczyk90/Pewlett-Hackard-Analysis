-- Create a Mentorship Title table which discloses the number of employees eligible for mentorship within
-- each department
SELECT count(*) AS emp_retiring, title
INTO mentorship_title
FROM mentorship_eligibility 
GROUP BY title
ORDER BY count(*) DESC;


-- Create a table showing the excess of retiring employees over mentors per department,
-- as well as the number of mentors per retiring employee
SELECT mt.title, (mt.emp_retiring - rt.emp_retiring) AS mentors_vs_retiring, 
	(rt.emp_retiring / mt.emp_retiring) AS retirees_per_mentor
FROM mentorship_title AS mt
INNER JOIN retiring_titles AS rt ON mt.title = rt.title
ORDER BY mentors_vs_retiring;

SELECT * FROM dept_emp
dept_emp

-- Creat a query to determine the average age of each department
SELECT dept_name, AVG(current_age) AS avg_age FROM 
	(SELECT e.emp_no, e.first_name, e.last_name, ((CURRENT_DATE - e.birth_date)/365) AS current_age, d.dept_name
	FROM employees AS e
	INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
	INNER JOIN departments AS d ON de.dept_no = d.dept_no
	WHERE de.to_date = '9999-01-01'
	ORDER BY current_age ASC)
		AS emp_age
GROUP BY dept_name
ORDER BY avg_age DESC