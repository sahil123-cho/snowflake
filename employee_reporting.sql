-- Employee Reporting SQL
-- Example hierarchy, salary analysis, and department reporting.

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(80) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    manager_id INT,
    salary DECIMAL(12, 2),
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

INSERT INTO departments VALUES
(10, 'Engineering'), (20, 'Analytics'), (30, 'Finance');

INSERT INTO employees VALUES
(1, 'Ananya Rao', 10, NULL, 95000, '2022-01-10'),
(2, 'Kabir Singh', 10, 1, 72000, '2023-03-15'),
(3, 'Diya Nair', 20, 1, 68000, '2023-07-01'),
(4, 'Arjun Das', 20, 3, 54000, '2024-02-12'),
(5, 'Sara Khan', 30, 1, 61000, '2024-06-20');

-- Rank employees by salary within each department.
SELECT e.employee_name, d.department_name, e.salary,
       DENSE_RANK() OVER (
           PARTITION BY e.department_id
           ORDER BY e.salary DESC
       ) AS salary_rank
FROM employees e
JOIN departments d ON d.department_id = e.department_id;

-- Department salary statistics.
SELECT d.department_name,
       COUNT(e.employee_id) AS employee_count,
       ROUND(AVG(e.salary), 2) AS average_salary,
       MAX(e.salary) AS highest_salary
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY average_salary DESC;

-- Employee and manager names (self join).
SELECT e.employee_name AS employee,
       m.employee_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
