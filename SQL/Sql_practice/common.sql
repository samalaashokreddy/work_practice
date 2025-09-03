Aggregations:
  
-- 1. Count the number of employees in each department
-- This query groups employees by department_id and counts how many employees exist in each.
SELECT department_id, COUNT(*) AS total_employees
FROM employees
GROUP BY department_id;

-- 2. Find the average salary in each department
-- This query calculates the average salary for employees in each department.
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- 3. Find the maximum and minimum salary in each department
-- This query finds the highest and lowest salaries for each department.
SELECT department_id, MAX(salary) AS max_salary, MIN(salary) AS min_salary
FROM employees
GROUP BY department_id;

-- 4. Find the total salary paid in each department
-- This query sums up all employee salaries in each department.
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id;

-- 5. Count the number of employees in each job role
-- This query counts the number of employees who have the same job role.
SELECT job_id, COUNT(*) AS total_employees
FROM employees
GROUP BY job_id;

-- 6. Find the average salary for each job role
-- This query calculates the average salary for employees in each job role.
SELECT job_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY job_id;

-- 7. Find the maximum salary for each job role
-- This query finds the highest salary assigned to employees for each job role.
SELECT job_id, MAX(salary) AS max_salary
FROM employees
GROUP BY job_id;

-- 8. Find the minimum salary for each job role
-- This query finds the lowest salary assigned to employees for each job role.
SELECT job_id, MIN(salary) AS min_salary
FROM employees
GROUP BY job_id;

-- 9. Find the total salary paid for each job role
-- This query calculates the total salary payout for employees in each job role.
SELECT job_id, SUM(salary) AS total_salary
FROM employees
GROUP BY job_id;

-- 10. Count the number of employees hired in each year
-- This query extracts the year from the hire_date and counts employees hired in each year.
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS total_employees
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

-- 11. Find the total salary paid in each location
-- This query sums up the total salary per location by joining employees with department locations.
SELECT d.location_id, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.location_id;

-- 12. Find the number of employees in each manager's team
-- This query counts the employees who report to each manager.
SELECT manager_id, COUNT(*) AS team_size
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 13. Find the highest salary for each manager
-- This query finds the highest salary among employees reporting to each manager.
SELECT manager_id, MAX(salary) AS max_salary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 14. Find the average salary for each manager's team
-- This query calculates the average salary of employees reporting to each manager.
SELECT manager_id, AVG(salary) AS avg_salary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 15. Count the number of employees hired in each month of the year
-- This query extracts the month from hire_date and counts how many employees were hired in each month.
SELECT EXTRACT(MONTH FROM hire_date) AS hire_month, COUNT(*) AS total_hired
FROM employees
GROUP BY EXTRACT(MONTH FROM hire_date)
ORDER BY hire_month;

-- 16. Find the department with the highest total salary
-- This query finds the department that pays the highest total salary by sorting in descending order.
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY total_salary DESC
FETCH FIRST 1 ROW ONLY;

-- 17. Find the job role with the highest average salary
-- This query finds the job role with the highest average salary by sorting in descending order.
SELECT job_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY job_id
ORDER BY avg_salary DESC
FETCH FIRST 1 ROW ONLY;

-- 18. Find the number of employees in each city
-- This query counts the number of employees per city, assuming departments are linked to locations.
SELECT l.city, COUNT(*) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
GROUP BY l.city;

-- 19. Find the number of employees who have a commission, grouped by department
-- This query counts employees who receive a commission, grouped by department.
SELECT department_id, COUNT(*) AS employees_with_commission
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;

-- 20. Find the sum of salaries for employees who have a commission, grouped by department
-- This query sums up the salaries of employees who receive a commission, grouped by department.
SELECT department_id, SUM(salary) AS total_salary_with_commission
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;


-- # Oracle SQL Aggregation Questions for Sales History Table

-- 1. Count the number of sales transactions for each product.  
-- 2. Find the average sale amount for each product.  
-- 3. Find the maximum and minimum sale amount for each product.  
-- 4. Find the total revenue generated by each product.  
-- 5. Count the number of sales transactions for each customer.  
-- 6. Find the average sale amount per customer.  
-- 7. Find the highest purchase amount for each customer.  
-- 8. Find the lowest purchase amount for each customer.  
-- 9. Find the total revenue generated by each store location.  
-- 10. Count the number of sales transactions for each region.  
-- 11. Find the total revenue per region.  
-- 12. Find the average sale amount per region.  
-- 13. Count the number of sales per month.  
-- 14. Find the total revenue per month.  
-- 15. Find the product that generated the highest revenue.  
-- 16. Find the most frequently purchased product.  
-- 17. Find the most valuable customer based on total spending.  
-- 18. Find the total revenue per sales channel (e.g., online vs. offline).  
-- 19. Count the number of sales for each payment method.  
-- 20. Find the total revenue generated per payment method.  

2. Analytical Functions:
-- Oracle SQL Analytical and Window Function Queries for Employee Table:

-- 1. Find the total number of employees in each department.
-- Counts employees for each department using GROUP BY.
SELECT department_id, COUNT(*) AS total_employees
FROM employees
GROUP BY department_id;

-- 2. Calculate the average salary in each department.
-- Computes the average salary for each department.
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- 3. Find the department with the highest total salary.
-- Summarizes total salaries per department and selects the highest one.
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY total_salary DESC
FETCH FIRST 1 ROW ONLY;

-- 4. Determine the highest and lowest salaries for each job role.
-- Finds the highest and lowest salary within each job role.
SELECT job_id, MAX(salary) AS max_salary, MIN(salary) AS min_salary
FROM employees
GROUP BY job_id;

-- 5. Find the number of employees hired in each year.
-- Extracts year from hire_date and counts employees hired per year.
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS total_employees
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

-- 6. Assign a rank to employees based on their salary within each department.
-- Uses RANK() to assign ranks based on salary in each department.
SELECT department_id, employee_id, salary, 
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;

-- 7. Find the top 3 highest-paid employees in each department.
-- Uses RANK() to rank employees based on salary and filters top 3.
SELECT department_id, employee_id, salary
FROM (
    SELECT department_id, employee_id, salary, 
           RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) WHERE salary_rank <= 3;

-- 8. Identify the second highest salary in each department using DENSE_RANK().
-- Uses DENSE_RANK() to identify employees with the second-highest salary per department.
SELECT department_id, employee_id, salary
FROM (
    SELECT department_id, employee_id, salary, 
           DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) WHERE salary_rank = 2;

-- 9. Compute the cumulative total salary of employees ordered by hire date.
-- Uses SUM() OVER() to create a running total of salaries.
SELECT employee_id, hire_date, salary, 
       SUM(salary) OVER (ORDER BY hire_date) AS cumulative_salary
FROM employees;

-- 10. Assign a row number to each employee in each department.
-- Uses ROW_NUMBER() to assign a unique row number per department.
SELECT department_id, employee_id, 
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY employee_id) AS row_num
FROM employees;

-- 11. Find the salary difference between each employee and the next highest-paid employee.
-- Uses LEAD() to compare an employee's salary with the next highest.
SELECT employee_id, salary, 
       LEAD(salary) OVER (ORDER BY salary DESC) - salary AS salary_diff
FROM employees;

-- 12. Calculate the previous month’s salary for each employee using LAG().
-- Uses LAG() to get the previous salary entry for each employee.
SELECT employee_id, salary, hire_date, 
       LAG(salary) OVER (PARTITION BY employee_id ORDER BY hire_date) AS prev_salary
FROM employees;

-- 13. Identify employees whose salaries increased over time.
-- Uses LAG() to compare an employee's current and previous salaries.
SELECT employee_id, hire_date, salary, 
       LAG(salary) OVER (PARTITION BY employee_id ORDER BY hire_date) AS prev_salary,
       CASE WHEN salary > LAG(salary) OVER (PARTITION BY employee_id ORDER BY hire_date) 
            THEN 'Increased' ELSE 'Decreased' END AS salary_trend
FROM employees;

-- 14. Find the average salary of employees who joined in each year.
-- Computes average salary grouped by year of hire.
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, AVG(salary) AS avg_salary
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

-- 15. Count the number of employees in each job role.
-- Counts employees for each job role using GROUP BY.
SELECT job_id, COUNT(*) AS total_employees
FROM employees
GROUP BY job_id;

-- 16. Find the total salary expenditure for each manager's team.
-- Sums salaries of employees under each manager.
SELECT manager_id, SUM(salary) AS total_team_salary
FROM employees
GROUP BY manager_id;

-- 17. Find the highest-paid employee in each department.
-- Uses RANK() to find the highest-paid employee in each department.
SELECT department_id, employee_id, salary
FROM (
    SELECT department_id, employee_id, salary,
           RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) WHERE salary_rank = 1;

-- 18. Calculate the running total of salaries for employees hired in each department.
-- Uses SUM() OVER() to compute cumulative salary totals.
SELECT department_id, employee_id, salary, 
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date) AS running_total
FROM employees;

-- 19. Find the employees who earn above the average salary of their department.
-- Uses a subquery to filter employees earning above department average.
SELECT employee_id, department_id, salary
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);

-- 20. Rank employees within their department based on experience.
-- Uses RANK() to order employees by hire date per department.
SELECT employee_id, department_id, hire_date, 
       RANK() OVER (PARTITION BY department_id ORDER BY hire_date ASC) AS experience_rank
FROM employees;

-- 21. Find the difference between each employee’s salary and the department average.
-- Uses AVG() OVER() to compute salary difference from department average.
SELECT employee_id, department_id, salary, 
       salary - AVG(salary) OVER (PARTITION BY department_id) AS salary_diff
FROM employees;

-- 22. Find the department where the most employees have been hired.
-- Counts employees in each department and selects the highest.
SELECT department_id, COUNT(*) AS total_hired
FROM employees
GROUP BY department_id
ORDER BY total_hired DESC
FETCH FIRST 1 ROW ONLY;

-- 23. Identify employees who were hired in the same month and year as someone else.
-- Uses COUNT() OVER() to count employees hired in the same month-year.
SELECT employee_id, hire_date, 
       COUNT(*) OVER (PARTITION BY EXTRACT(MONTH FROM hire_date), EXTRACT(YEAR FROM hire_date)) AS same_month_hires
FROM employees;

-- 24. Calculate the moving average salary over the last 3 employees ordered by hire date.
-- Uses AVG() OVER() with ROWS BETWEEN for moving average calculation.
SELECT employee_id, hire_date, salary, 
       AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_salary
FROM employees;

-- 25. Find employees whose salary is greater than that of the average of their manager’s team.
-- Uses a subquery to compare employee salary with manager's team average.
SELECT e.employee_id, e.manager_id, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE manager_id = e.manager_id);

3. Joins:
-- Oracle SQL Queries Using Different Types of Joins on Employee Table:

-- 1. Retrieve employee names and their department names using INNER JOIN
SELECT e.employee_id, e.employee_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- 2. Retrieve all employees and their respective department names (including those without a department) using LEFT JOIN
SELECT e.employee_id, e.employee_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- 3. Retrieve all departments and employees (including departments without employees) using RIGHT JOIN
SELECT e.employee_id, e.employee_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- 4. Retrieve all employees and their department names using FULL OUTER JOIN
SELECT e.employee_id, e.employee_name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id;

-- 5. Retrieve employees who do not belong to any department using LEFT JOIN with NULL check
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- 6. Retrieve departments that have no employees using RIGHT JOIN with NULL check
SELECT d.department_id, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- 7. Retrieve employees along with their manager names using SELF JOIN
SELECT e.employee_id, e.employee_name, m.employee_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 8. Retrieve employees along with their job title using INNER JOIN
SELECT e.employee_id, e.employee_name, j.job_title
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id;

-- 9. Retrieve employees along with the location of their department using INNER JOIN
SELECT e.employee_id, e.employee_name, d.department_name, l.city
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id;

-- 10. Retrieve employees and the projects they are assigned to using INNER JOIN
SELECT e.employee_id, e.employee_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- 11. Retrieve employees who have not been assigned to any project using LEFT JOIN
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.project_id IS NULL;

-- 12. Retrieve project names along with the department handling them using INNER JOIN
SELECT p.project_name, d.department_name
FROM projects p
INNER JOIN departments d ON p.department_id = d.department_id;

-- 13. Retrieve employees along with the names of their training programs using INNER JOIN
SELECT e.employee_id, e.employee_name, t.training_name
FROM employees e
INNER JOIN training_programs t ON e.training_id = t.training_id;

-- 14. Retrieve employees who have not attended any training programs using LEFT JOIN
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN training_programs t ON e.training_id = t.training_id
WHERE t.training_id IS NULL;

-- 15. Retrieve employee names and their assigned shifts using INNER JOIN
SELECT e.employee_id, e.employee_name, s.shift_timing
FROM employees e
INNER JOIN shifts s ON e.shift_id = s.shift_id;

-- 16. Retrieve employees who do not have an assigned shift using LEFT JOIN
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN shifts s ON e.shift_id = s.shift_id
WHERE s.shift_id IS NULL;

-- 17. Retrieve employees, their department names, and their assigned project names using multiple INNER JOINs
SELECT e.employee_id, e.employee_name, d.department_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- 18. Retrieve employees who have worked on more than one project using INNER JOIN and GROUP BY
SELECT e.employee_id, e.employee_name, COUNT(p.project_id) AS project_count
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
GROUP BY e.employee_id, e.employee_name
HAVING COUNT(p.project_id) > 1;

-- 19. Retrieve employees along with their salaries and their department budget using INNER JOIN
SELECT e.employee_id, e.employee_name, e.salary, d.budget
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- 20. Retrieve employees who earn more than their department’s average salary using INNER JOIN and a subquery
SELECT e.employee_id, e.employee_name, e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);

-- 21. Retrieve employees who have the same job role as another employee using SELF JOIN
SELECT e1.employee_id, e1.employee_name, e2.employee_name AS coworker_name, e1.job_id
FROM employees e1
INNER JOIN employees e2 ON e1.job_id = e2.job_id AND e1.employee_id <> e2.employee_id;

-- 22. Retrieve employees and their department names, but show "Not Assigned" if an employee has no department using LEFT JOIN and COALESCE
SELECT e.employee_id, e.employee_name, COALESCE(d.department_name, 'Not Assigned') AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- 23. Retrieve employees and their assigned projects, including employees who are not assigned to any project using FULL OUTER JOIN
SELECT e.employee_id, e.employee_name, p.project_name
FROM employees e
FULL OUTER JOIN projects p ON e.employee_id = p.employee_id;

-- 24. Retrieve employees who work in a city where their department is located using INNER JOIN
SELECT e.employee_id, e.employee_name, l.city
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id;

-- 25. Retrieve employees and their total bonus amount using INNER JOIN with a bonus table
SELECT e.employee_id, e.employee_name, SUM(b.bonus_amount) AS total_bonus
FROM employees e
INNER JOIN bonuses b ON e.employee_id = b.employee_id
GROUP BY e.employee_id, e.employee_name;

-- 26. Retrieve employees who do not have any recorded bonuses using LEFT JOIN
SELECT e.employee_id, e.employee_name
FROM employees e
LEFT JOIN bonuses b ON e.employee_id = b.employee_id
WHERE b.bonus_amount IS NULL;

-- 27. Retrieve employees and their department names where employees belong to a specific region using INNER JOIN
SELECT e.employee_id, e.employee_name, d.department_name, r.region_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
INNER JOIN regions r ON l.region_id = r.region_id;

-- 28. Retrieve employees and their project details, even if they are not assigned to a project using LEFT JOIN
SELECT e.employee_id, e.employee_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;

-- 29. Retrieve departments and the count of employees in each department using INNER JOIN and GROUP BY
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- 30. Retrieve employees who work on projects located in a different city than their department using INNER JOIN
SELECT e.employee_id, e.employee_name, d.department_name, p.project_name, l.city AS project_city
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON p.location_id = l.location_id
WHERE d.location_id <> p.location_id;

5. Assignment:
-- racle SQL - 30 Questions on Joins in Sales Schema:

1-10: Basic Joins:
Retrieve all sales transactions along with the customer name.
Retrieve all sales transactions along with product details.
Retrieve all sales transactions along with store location details.
Retrieve all sales transactions along with the sales representative handling them.
Retrieve all sales transactions along with customer and product details.
Retrieve all sales transactions along with the region they occurred in.
Retrieve all customers and their sales transactions, including those who have never made a purchase.
Retrieve all products and their sales, including those that have never been sold.
Retrieve all stores and their sales transactions, including stores without sales.
Retrieve all sales transactions along with payment method details.
  
11-20: Advanced Joins:
Retrieve all customers who have purchased more than one product.
Retrieve all products that have been purchased by more than one customer.
Retrieve all stores that have recorded more than 100 transactions.
Retrieve all customers and their most recent purchase.
Retrieve all customers who have made a purchase in multiple regions.
Retrieve all customers who have purchased the same product more than once.
Retrieve all products along with the names of the customers who bought them.
Retrieve all stores along with the total revenue generated per store.
Retrieve all customers who have used more than one payment method.
Retrieve all regions along with the total sales generated.
  
21-30: Complex Joins:
Retrieve all customers along with the store location they frequently purchase from.
Retrieve all sales transactions along with customer, product, and store details.
Retrieve all customers along with the total amount they have spent.
Retrieve all products that have never been sold in a particular region.
Retrieve all customers who have made a purchase every month for the past year.
Retrieve all sales transactions where the product was purchased at a discount.
Retrieve all customers along with the first and last product they purchased.
Retrieve all stores along with the most frequently sold product.
Retrieve all sales transactions where the customer used a credit card.
Retrieve all customers who have made a purchase but have not returned to buy again.

-- Oracle SQL - 30 Questions on Analytical Functions:
  
1-10: Ranking Functions:
Rank customers based on total purchases made.
Rank products based on total sales revenue.
Assign a rank to stores based on total revenue generated.
Find the top 3 highest-spending customers in each region.
Identify the second most sold product in each store.
Rank customers within each region based on their spending.
Identify the top-selling product for each month.
Find the top 5 stores with the highest sales for the past quarter.
Identify the store with the highest revenue for each region.
Rank customers by the number of transactions they have made.
  
11-20: Window Functions:
Calculate the running total of sales revenue for each store.
Calculate the cumulative total sales revenue per region.
Find the moving average sales for each product over the last three months.
Compute the percentage contribution of each store to total revenue.
Calculate the difference in sales revenue between consecutive months.
Find the previous transaction amount for each customer.
Find the next purchase amount for each customer.
Compute the average transaction amount for each customer.
Identify customers whose spending has increased month over month.
Calculate the average sales revenue per region for the past 12 months.
  
21-30: Advanced Analytical Queries:
Find the total sales revenue per customer over their lifetime.
Identify customers who made a purchase in every quarter for the past year.
Calculate the percentage increase in sales revenue from one year to the next.
Compute the total revenue generated by each product category.
Determine the most profitable store in each city.
Find customers whose spending has decreased compared to the previous year.
Calculate the total revenue generated by each sales representative.
Identify the store with the most consistent sales revenue over the past year.
Calculate the average sales transaction size per payment method.
Determine the sales channel (online vs. offline) with the highest revenue growth.  

These 60 questions cover JOINs and Analytical Functions in the Sales Schema, providing a comprehensive foundation for SQL query writing in Oracle.




  

