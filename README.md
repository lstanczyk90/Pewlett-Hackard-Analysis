# Pewlett Hackard Analysis

## **Overview of Analysis**

The purpose of this analysis was to perform queries on Pewlett Hackard's employee database to obtain responses to the following business questions:

- Determine the number of retiring employees per title;
- Identify employees who are eligible to participate in a mentorship program.

To perform this analysis, we leveraged Postgres SQL and created queries that help visualize the respones to the above questions in tabular form. 

## **Results**

### **_Retiring Employees Per Title_**

![alt text](https://github.com/lstanczyk90/Pewlett-Hackard-Analysis/blob/454a213b00b0ff340955802b54499728b2945de2/Data/Retiring%20By%20Title.PNG)

As demonstrated in the table above, our analysis yielded the following: 

- The majority of expected-to-retire employees are Senior Engineers (29,414) and Senior Staff (28,254). This is perhaps unsurprising, as these individuals have been at the company longer than those within entry level positions and have been promoted to their current roles. 

- Given that there are less employees expected to retire that are within entry level engineering (14,222) and staff positions (12,243), our recommendation is to promote entry level individuals to replace the retiring higher-level positions, as these would likely be harder to fill from the outside. Then, Pewlett Hackard can hire additional entry level employees, as needed, from the outside. 

- It is also useful to know that not too many managers are slated to retire. As these positions are harder to fill (given the level of experience required), the company is in good shape here.

### **_Mentorship Program Employees_**

Per review of the Mentorship Program table:

- The table provides useful insight as to which employees are mentorship-ready. Additionally, given that this table includes the titles of these employees, we can use this information for further analysis. See the below summary section for additional queries that allow us to compare the numnber of mentorship-ready staff by department to the number of retiring employees.

## **Summary**

- As noted in the Retiring Employees Per Title table shown above, we will need to replace the employees that are expected to retire (the number of which is in the "emp_retiring" column). However, this should be done strategically. Given that the majority of departures are going to happen at intermediate level staff and engineering positions, we should already start promoting entry level staff that have been at the company for a longer period of time and are performing well to these positions. We should do this before the intermediate level personnel start to retire, as this will allow the newly promoted employees to work with the existing ones in order to learn best practices. 

- With regards to the mentorship program, we created an additional query that will allow us to compare the number of mentors to the number of retiring employees (since logically, those employees that retire will need to be repalced by new employees). See the below query and chart:

```
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
```

![alt text](https://github.com/lstanczyk90/Pewlett-Hackard-Analysis/blob/385d188e6311e16e6e6a997d0d928775c250caed/Data/Mentors%20and%20Retiring%20Employees.PNG)


- As noted within this chart, the negative numbers indicate that there are many more retiring employees than mentors available. Additionally, this trend is especially alarming for entry level staff and engineers, as the ratio is over 70 retiring employees per mentor for both. As such, there may not be enough mentors available for entry level positions.

- An additional helpful query which may be used for future reference is shown below, which can be used to track the average age of employees within each department to see which departments may have the greatest areas of need in terms of new hires:

```
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
```

![alt text](https://github.com/lstanczyk90/Pewlett-Hackard-Analysis/blob/454a213b00b0ff340955802b54499728b2945de2/Data/Retiring%20Age%20By%20Department.PNG)