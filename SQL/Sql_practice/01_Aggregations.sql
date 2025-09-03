-- 1. grouping by department ids and counting the employees by department wise, aggregation at department id
select department_id, count(*) as total_employess from hr.employees group by department_id;

-- 2. calculating average salary of employees in each department, aggregation at department id
select department_id, avg(salary) from hr.employees group by department_id;

-- 3. calculating max and min salary of each department, aggregation at department id
select department_id, min(salary) as min_salary, max(salary)as max_salary from hr.employees group by department_id order by department_id;

-- 4. calculating total salaries for each departments, aggregation at department id
select department_id, sum(salary) as total_salary from hr.employees group by department_id;

-- 5. calculating total emplyess and grouping by job wise, aggregation at job level
select job_id, count(*) as total_employeses from hr.employees group by job_id;

-- 6. calculating the avg salary for job wise, aggregation at job level
select job_id, avg(salary) as avg_salary from hr.employees group by job_id;

-- 7. calculating max salary for job wise
select job_id, max(salary) as max_salary from hr.employees group by job_id;

-- 8. calculating min salary for job wise
select job_id, min(salary) as min_salary from hr.employees group by job_id;


-- 9. calculating total salary paid for each job role
select job_id, sum(salary) as job_wise_salary from hr.employees group by job_id;

-- 10.Count the number of employees hired in each year
select extract(year from hire_date) as year, count(*)as total_employees_hired, from hr.employees group by year; 

