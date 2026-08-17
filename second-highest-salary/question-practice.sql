-- Create table

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT
);


-- Insert data

INSERT INTO Employee (id, name, salary)
VALUES
(1, 'Amit', 50000),
(2, 'Rahul', 70000),
(3, 'Priya', 60000),
(4, 'Neha', 70000),
(5, 'Rohan', 40000);


-- Solution 1: MAX() with subquery

SELECT MAX(salary) AS second_highest_salary
FROM Employee
WHERE salary < (
    SELECT MAX(salary)
    FROM Employee
);


-- Solution 2: ORDER BY with LIMIT

SELECT DISTINCT salary AS second_highest_salary
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;


-- Solution 3: DENSE_RANK()

SELECT id, name, salary
FROM (
    SELECT
        id,
        name,
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM Employee
) AS ranked_employee
WHERE salary_rank = 2;