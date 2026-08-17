# SQL Interview Question: Second Highest Salary

A common SQL interview question:

> **Find the second highest salary from the Employee table.**

This example covers **3 different SQL approaches** and explains when each approach is useful.

---

## 📌 Problem

Suppose we have an `Employee` table:

|  id | name  | salary |
| --: | ----- | -----: |
|   1 | Amit  |  50000 |
|   2 | Rahul |  70000 |
|   3 | Priya |  60000 |
|   4 | Neha  |  70000 |
|   5 | Rohan |  40000 |

The highest salary is:

```text
70000
```

The second highest **distinct** salary is:

```text
60000
```

---

# Table Structure

```sql
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT
);
```

Sample data:

```sql
INSERT INTO Employee (id, name, salary)
VALUES
    (1, 'Amit', 50000),
    (2, 'Rahul', 70000),
    (3, 'Priya', 60000),
    (4, 'Neha', 70000),
    (5, 'Rohan', 40000);
```

---

# Solution 1: MAX() + Subquery

```sql
SELECT MAX(salary) AS second_highest_salary
FROM Employee
WHERE salary < (
    SELECT MAX(salary)
    FROM Employee
);
```

### How it works

First, the inner query finds the highest salary:

```sql
SELECT MAX(salary)
FROM Employee;
```

Result:

```text
70000
```

Then the outer query considers only salaries below `70000`:

```sql
WHERE salary < 70000
```

Among those salaries, `MAX()` finds:

```text
60000
```

### Output

```text
60000
```

### Why use this approach?

- Easy to understand
- Easy to explain in an interview
- Does not depend on `LIMIT`
- Handles duplicate highest salaries correctly

---

# Solution 2: ORDER BY + LIMIT + OFFSET

```sql
SELECT DISTINCT salary
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

### How it works

First:

```sql
ORDER BY salary DESC
```

sorts salaries from highest to lowest.

Without `DISTINCT`, we would have:

```text
70000
70000
60000
50000
40000
```

Using:

```sql
DISTINCT salary
```

gives:

```text
70000
60000
50000
40000
```

Then:

```sql
LIMIT 1 OFFSET 1
```

means:

- `OFFSET 1` → skip the first row
- `LIMIT 1` → return one row

So the result is:

```text
60000
```

### Important

`LIMIT/OFFSET` syntax is commonly used in MySQL, but SQL syntax can vary between database systems.

---

# Solution 3: DENSE_RANK()

```sql
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
```

### How it works

`DENSE_RANK()` assigns a rank based on salary.

For our example:

| salary | rank |
| -----: | ---: |
|  70000 |    1 |
|  70000 |    1 |
|  60000 |    2 |
|  50000 |    3 |
|  40000 |    4 |

Therefore:

```sql
WHERE salary_rank = 2
```

returns employees whose salary is the second highest distinct salary.

### Output

```text
3 | Priya | 60000
```

If another employee also had a salary of `60000`, that employee would also be returned.

---

# Why DENSE_RANK() is Important

Consider this data:

| name  | salary |
| ----- | -----: |
| Amit  |  70000 |
| Rahul |  70000 |
| Priya |  60000 |
| Karan |  60000 |
| Rohan |  50000 |

`DENSE_RANK()` produces:

| name  | salary | rank |
| ----- | -----: | ---: |
| Amit  |  70000 |    1 |
| Rahul |  70000 |    1 |
| Priya |  60000 |    2 |
| Karan |  60000 |    2 |
| Rohan |  50000 |    3 |

So:

```sql
WHERE salary_rank = 2
```

returns both:

```text
Priya → 60000
Karan → 60000
```

This is useful when the interviewer asks:

> **"Find all employees who have the second highest salary."**

---

# Quick Comparison

| Approach             | Main Idea              | Duplicate Salary Handling | Best For                  |
| -------------------- | ---------------------- | ------------------------- | ------------------------- |
| `MAX()` + Subquery   | Find max below maximum | ✅                        | Simple interview solution |
| `ORDER BY` + `LIMIT` | Sort and skip highest  | ✅ with `DISTINCT`        | Short MySQL solution      |
| `DENSE_RANK()`       | Assign salary ranks    | ✅                        | Returning all employees   |

---

# Interview Tip

If the interviewer simply asks:

> **Find the second highest salary.**

A good answer is:

```sql
SELECT MAX(salary)
FROM Employee
WHERE salary < (
    SELECT MAX(salary)
    FROM Employee
);
```

If the interviewer asks:

> **What if multiple employees have the second highest salary?**

Use:

```sql
DENSE_RANK()
```

Example:

```sql
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
```

---

# Key SQL Concepts Learned

- `MAX()`
- Subqueries
- `ORDER BY`
- `DISTINCT`
- `LIMIT`
- `OFFSET`
- Window Functions
- `DENSE_RANK()`
- Handling duplicate salaries

---

## 📂 Files

```text
second-highest-salary/
├── README.md
└── second-highest-salary.sql
```

This is a beginner-friendly SQL interview problem and a good example for understanding different ways to solve the same problem.
